#!/usr/bin/env -S uv run --script
"""Tinymist LSP proxy adding preview-click navigation for Zed.

Zed currently rejects the standard LSP window/showDocument request emitted by
Tinymist when a location in the web preview is clicked. This proxy consumes
that request, opens the requested source position through the Zed CLI, and
returns a successful response to Tinymist. All other LSP traffic is forwarded
unchanged.

NOTE: This shim is temporary. Once zed ships #61572 we can delete this.
"""

from __future__ import annotations

import json
import os
import signal
import subprocess
import sys
import threading
from pathlib import Path
from typing import IO, cast
from urllib.parse import unquote, urlparse

WORKSPACE = Path(__file__).resolve().parent.parent
TINYMIST = os.environ.get("TINYMIST_REAL_BINARY", "/usr/bin/tinymist")
ZED = os.environ.get("ZED_CLI", str(Path.home() / ".local/bin/zed"))
LOG = WORKSPACE / "out" / "tinymist-zed.log"

JsonObject = dict[str, object]
ByteStream = IO[bytes]

write_lock = threading.Lock()
log_lock = threading.Lock()


def log(message: str) -> None:
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with log_lock, LOG.open("a", encoding="utf-8") as stream:
        _ = stream.write(message.rstrip() + "\n")


def write_bytes(stream: ByteStream, *chunks: bytes) -> None:
    for chunk in chunks:
        _ = stream.write(chunk)
    _ = stream.flush()


def read_exact(stream: ByteStream, length: int) -> bytes:
    chunks: list[bytes] = []
    remaining = length
    while remaining:
        chunk = stream.read(remaining)
        if not chunk:
            raise EOFError("incomplete LSP message body")
        chunks.append(chunk)
        remaining -= len(chunk)
    return b"".join(chunks)


def read_lsp_message(stream: ByteStream) -> tuple[bytes, bytes] | None:
    """Read one Content-Length-framed LSP message."""
    headers: list[bytes] = []
    content_length: int | None = None

    while True:
        line = stream.readline()
        if not line:
            return None
        headers.append(line)
        if line in (b"\r\n", b"\n"):
            break
        name, separator, value = line.partition(b":")
        if separator and name.strip().lower() == b"content-length":
            content_length = int(value.strip())

    if content_length is None:
        raise RuntimeError("LSP message has no Content-Length header")

    body = read_exact(stream, content_length)
    return b"".join(headers), body


def write_lsp_message(stream: ByteStream, payload: JsonObject) -> None:
    body = json.dumps(payload, separators=(",", ":")).encode("utf-8")
    header = f"Content-Length: {len(body)}\r\n\r\n".encode("ascii")
    with write_lock:
        write_bytes(stream, header, body)


def forward_client_messages(child_stdin: ByteStream) -> None:
    try:
        while message := read_lsp_message(sys.stdin.buffer):
            headers, body = message
            with write_lock:
                write_bytes(child_stdin, headers, body)
    except (BrokenPipeError, EOFError):
        pass
    except Exception as error:  # noqa: BLE001
        log(f"client forwarding error: {error!r}")
    finally:
        try:
            child_stdin.close()
        except OSError:
            pass


def file_path_from_uri(uri: str) -> str | None:
    parsed = urlparse(uri)
    if parsed.scheme != "file":
        return None
    path = unquote(parsed.path)
    if parsed.netloc and parsed.netloc != "localhost":
        path = f"//{parsed.netloc}{path}"
    return path


def as_json_object(value: object) -> JsonObject:
    if isinstance(value, dict):
        return cast(JsonObject, value)
    return {}


def as_int(value: object) -> int:
    return value if isinstance(value, int) and not isinstance(value, bool) else 0


def handle_show_document(message: JsonObject, child_stdin: ByteStream) -> bool:
    if message.get("method") != "window/showDocument":
        return False

    params = as_json_object(message.get("params"))
    uri = params.get("uri")
    path = file_path_from_uri(uri) if isinstance(uri, str) else None
    selection = as_json_object(params.get("selection"))
    start = as_json_object(selection.get("start"))
    # LSP positions are zero-based; the Zed CLI uses one-based positions.
    line = as_int(start.get("line")) + 1
    column = as_int(start.get("character")) + 1
    success = False

    if path:
        target = f"{path}:{line}:{column}"
        try:
            _ = subprocess.Popen(
                [ZED, "--existing", target],
                stdin=subprocess.DEVNULL,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                start_new_session=True,
            )
            success = True
            log(f"preview click -> {target}")
        except OSError as error:
            log(f"failed to launch Zed for {target}: {error!r}")
    else:
        log(f"ignored non-file showDocument URI: {params.get('uri')!r}")

    if "id" in message:
        write_lsp_message(
            child_stdin,
            {
                "jsonrpc": "2.0",
                "id": message["id"],
                "result": {"success": success},
            },
        )
    return True


def forward_server_messages(child_stdout: ByteStream, child_stdin: ByteStream) -> None:
    try:
        while message := read_lsp_message(child_stdout):
            headers, body = message
            try:
                payload = cast(object, json.loads(body))
            except (UnicodeDecodeError, json.JSONDecodeError):
                payload = None

            if handle_show_document(as_json_object(payload), child_stdin):
                continue

            write_bytes(sys.stdout.buffer, headers, body)
    except (BrokenPipeError, EOFError):
        pass
    except Exception as error:  # noqa: BLE001
        log(f"server forwarding error: {error!r}")


def capture_stderr(child_stderr: ByteStream) -> None:
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with LOG.open("ab") as stream:
        while chunk := child_stderr.read(8192):
            write_bytes(stream, chunk)


def main() -> int:
    args = sys.argv[1:]
    if args and args[0] in ("--version", "-V", "--help", "-h"):
        os.execv(TINYMIST, [TINYMIST, *args])

    child_args = args or ["lsp"]
    log(f"\n===== Zed Tinymist proxy start; args={child_args!r} =====")
    env = os.environ.copy()
    _ = env.setdefault(
        "RUST_LOG", "tinymist=info,tinymist_preview=info,tinymist_project=info"
    )

    child: subprocess.Popen[bytes] = subprocess.Popen(
        [TINYMIST, *child_args],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=env,
        bufsize=0,
    )
    assert child.stdin and child.stdout and child.stderr

    def terminate_child(_signum: int, _frame: object) -> None:
        _ = child.terminate()

    _ = signal.signal(signal.SIGTERM, terminate_child)
    _ = signal.signal(signal.SIGINT, terminate_child)

    client_thread = threading.Thread(
        target=forward_client_messages, args=(child.stdin,), daemon=True
    )
    stderr_thread = threading.Thread(
        target=capture_stderr, args=(child.stderr,), daemon=True
    )
    client_thread.start()
    stderr_thread.start()
    forward_server_messages(child.stdout, child.stdin)

    if child.poll() is None:
        _ = child.terminate()
    return child.wait()


if __name__ == "__main__":
    raise SystemExit(main())
