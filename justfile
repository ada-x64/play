dev:
    mkdir out 2>/dev/null || true
    typst watch main.typ ./out/main.pdf --font-path=./fonts --open

gen_mods:
    #!/bin/bash
    shopt -s globstar
    echo "watching"
    while true; do
        ./scripts/gen_mod.py ./src
        inotifywait -rq --include ".*\.typ$" -e create,delete,move ./src/
    done

format:
    find ./src/ -type f -name '*.typ' -print0 | xargs -0 -r typstyle -v -i -l 80

lint:
    tinymist lint ./src/main.typ --root . --font-path="./src/fonts"

check:
    find ./src/ -type f -name '*.typ' -print0 | xargs -0 -r typstyle --check -l 80
    just lint
