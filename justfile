gen_mods:
    #!/bin/bash
    shopt -s globstar
    echo "watching"
    while true; do
        ./scripts/gen_mod.py ./src/*/
        inotifywait -rq --include ".*\.typ$" -e create,delete,move ./src/
    done

TYPSTYLE_ARGS := "-l 80 --wrap-text=fill"
FIND := "find ./src/ -type f -name '*.typ' -print0"

format:
    {{ FIND }} | xargs -0 -r typstyle -iv {{ TYPSTYLE_ARGS }}
    uvx ruff format ./scripts/*.py

lint:
    {{ FIND }} | xargs -0 -r typstyle --check {{ TYPSTYLE_ARGS }}
    tinymist lint ./src/main.typ --root . --font-path="./src/fonts"
    uvx ruff check ./scripts/*.py
    uvx ruff format --check ./scripts/*.py
    uvx basedpyright ./scripts/*.py
