dev:
    mkdir out 2>/dev/null || true
    typst watch main.typ ./out/main.pdf --font-path=./fonts --open

gen_mods:
    ./scripts/gen_mod.py ./src
