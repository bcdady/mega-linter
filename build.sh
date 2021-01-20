#!/usr/bin/env bash
set -eu

PYTHONPATH=.
export PYTHONPATH

# Upgrade pip, just in case
# https://pip.pypa.io/en/stable/installing/#upgrading-pip
python3 -m pip install -U pip

# Ensure build requirements (modules, dependencies) are installed
python3 -m pip install -r requirements.dev.txt

# run the build
python3 ./.automation/build.py

# Prettify markdown tables
# shellcheck disable=SC2086
MD_FILES=$(find . -type f -name "*.md" -not -path "*/node_modules/*" -not -path "*/.automation/*") && npx markdown-table-formatter $MD_FILES

# Build online documentation
mkdocs build

# Prettify `search_index.json` after `mkdocs`
# `mkdocs` removed its own prettify few years ago: https://github.com/mkdocs/mkdocs/pull/1128
python -m json.tool ./site/search/search_index.json >./site/search/search_index_new.json
mv -f -- ./site/search/search_index_new.json ./site/search/search_index.json
