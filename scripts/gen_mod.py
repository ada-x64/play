#!/usr/bin/env -S uv run --script
import os
import re
import sys
from pathlib import Path


def populate(path: Path) -> bool:
    modfile = path / "mod.typ"
    write = False
    content = "// This file is auto-generated. Do not edit!\n"
    for file in path.iterdir():
        name = os.path.basename(file)
        if name == "mod.typ":
            continue
        if file.is_dir():
            if populate(file):
                content += f'#include "{name}/mod.typ"\n'
                write = True
        elif file.suffix == ".typ":
            if re.search(r"//\s*mod-ignore", file.read_text()):
                print(f"Ignored {file}")
                continue
            content += f'#include "{name}"\n'
            write = True
    if write:
        with open(modfile, "w") as f:
            print(f"Wrote {modfile}")
            f.write(content)
    return write


if __name__ == "__main__":
    if len(sys.argv) < 1:
        print("Usage: gen_mod.py SRC_DIR")
        sys.exit(1)
    path = Path(sys.argv[1])
    if not path.exists():
        print("No such path")
        sys.exit(1)
    populate(path)
