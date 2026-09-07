#!/usr/bin/env python3
"""Rename this template from "MyProject" / "myproject" to your project's name.

Usage:
    python3 scripts/rename_project.py AwesomeWidgets

This rewrites, across the whole repository:
    MyProject   -> AwesomeWidgets   (CMake project/namespace-alias, PascalCase)
    myproject   -> awesome_widgets  (library/namespace/target names, snake_case)
    MYPROJECT   -> AWESOME_WIDGETS  (CMake option prefix, UPPER_CASE)

and renames any file or directory whose name contains one of those tokens
(e.g. include/myproject/ -> include/awesome_widgets/,
src/myproject.cpp -> src/awesome_widgets.cpp).

Run it once, right after cloning the template, then commit the result.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Directories we never want to descend into.
SKIP_DIRS = {".git", "build", "out", "vcpkg_installed", "vcpkg"}

# This script talks *about* MyProject/myproject in its own docstring and
# variable names; rewriting it in place would leave those explanations
# self-referential and confusing, so it never rewrites itself.
SKIP_FILES = {Path(__file__).resolve()}

# File suffixes worth scanning for content replacement. CMakeLists.txt has
# no suffix and is handled separately.
TEXT_SUFFIXES = {
    ".cpp", ".cc", ".cxx", ".h", ".hpp", ".hxx", ".in",
    ".cmake", ".txt", ".json", ".yml", ".yaml", ".md", ".py",
}


def pascal_to_snake(name: str) -> str:
    s1 = re.sub(r"(.)([A-Z][a-z]+)", r"\1_\2", name)
    s2 = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", s1)
    return s2.lower()


def iter_content_files(root: Path):
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if any(part in SKIP_DIRS for part in path.parts):
            continue
        if path.resolve() in SKIP_FILES:
            continue
        if path.name == "CMakeLists.txt" or path.suffix in TEXT_SUFFIXES:
            yield path


def rewrite_contents(root: Path, replacements: list[tuple[str, str]], dry_run: bool) -> list[Path]:
    changed = []
    for path in iter_content_files(root):
        original = path.read_text(encoding="utf-8")
        updated = original
        for old, new in replacements:
            updated = updated.replace(old, new)
        if updated != original:
            changed.append(path)
            if not dry_run:
                path.write_text(updated, encoding="utf-8")
    return changed


def rename_paths(root: Path, replacements: list[tuple[str, str]], dry_run: bool) -> list[tuple[Path, Path]]:
    """Rename any file/directory whose name contains one of the old tokens.

    Walked bottom-up so a directory is renamed only after its contents have
    already been (potentially) renamed, and so renaming a parent doesn't
    invalidate paths still to be visited.
    """
    renames = []
    all_paths = sorted(root.rglob("*"), key=lambda p: len(p.parts), reverse=True)
    for path in all_paths:
        if any(part in SKIP_DIRS for part in path.parts):
            continue
        if path.resolve() in SKIP_FILES:
            continue
        new_name = path.name
        for old, new in replacements:
            new_name = new_name.replace(old, new)
        if new_name != path.name:
            new_path = path.with_name(new_name)
            renames.append((path, new_path))
            if not dry_run:
                path.rename(new_path)
    return renames


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("new_name", help="New project name in PascalCase, e.g. AwesomeWidgets")
    parser.add_argument("--dry-run", action="store_true", help="Show what would change without writing files")
    args = parser.parse_args()

    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9]*", args.new_name):
        parser.error("new_name should be a single PascalCase identifier, e.g. AwesomeWidgets")

    pascal = args.new_name
    lower = pascal_to_snake(pascal)
    upper = lower.upper()

    # Longest-token-first so "MYPROJECT" isn't partially consumed by a
    # "MyProject" replacement first (they don't overlap here, but keeping
    # this order is cheap insurance if tokens ever change).
    replacements = [
        ("MYPROJECT", upper),
        ("MyProject", pascal),
        ("myproject", lower),
    ]

    changed_files = rewrite_contents(REPO_ROOT, replacements, args.dry_run)
    renamed_paths = rename_paths(REPO_ROOT, replacements, args.dry_run)

    prefix = "[dry-run] " if args.dry_run else ""
    verb = "Would update" if args.dry_run else "Updated"
    rename_verb = "Would rename" if args.dry_run else "Renamed"

    print(f"{verb} {len(changed_files)} file(s):")
    for path in changed_files:
        print(f"  {path.relative_to(REPO_ROOT)}")

    print(f"\n{rename_verb} {len(renamed_paths)} file(s)/folder(s):")
    for old, new in renamed_paths:
        print(f"  {prefix}{old.relative_to(REPO_ROOT)} -> {new.relative_to(REPO_ROOT)}")

    print(f"\nMyProject -> {pascal}")
    print(f"myproject -> {lower}")
    print(f"MYPROJECT -> {upper}")

    if args.dry_run:
        print("\nDry run only - re-run without --dry-run to apply.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
