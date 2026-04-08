#!/usr/bin/env python3
"""Extract Dinka-English entries from a PDF into UTF-8 JSON.

Usage:
  python scripts/extract_dictionary.py --input dictionary.pdf --output assets/data/dictionary.json
"""

from __future__ import annotations

import argparse
import json
import logging
import re
from dataclasses import dataclass, asdict

import pdfplumber


logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")


ENTRY_START = re.compile(r"^([\wŋŊɛƐɔƆïëäöüɣɣ̈\-’' ]+)\s*[—:-]\s*(.+)$")


@dataclass
class Entry:
  id: int
  word: str
  definition: str
  examples: str
  partOfSpeech: str
  synonyms: str
  dialects: str
  searchKey: str
  rawEntry: str


def build_search_key(word: str) -> str:
  replacements = {
      "ŋ": "ng",
      "ɛ": "e",
      "ɔ": "o",
      "ï": "i",
      "ë": "e",
      "ä": "a",
      "ö": "o",
      "ü": "u",
  }
  lowered = word.lower()
  return "".join(replacements.get(ch, ch) for ch in lowered if ch.isalnum() or ch.isspace()).strip()


def extract_lines(pdf_path: str) -> list[str]:
  lines: list[str] = []
  with pdfplumber.open(pdf_path) as pdf:
    for page in pdf.pages:
      text = page.extract_text(x_tolerance=1, y_tolerance=3) or ""
      for line in text.splitlines():
        clean = line.strip()
        if clean:
          lines.append(clean)
  return lines


def parse_entries(lines: list[str]) -> tuple[list[Entry], list[str]]:
  entries: list[Entry] = []
  errors: list[str] = []
  current_word: str | None = None
  current_definition: list[str] = []

  def flush() -> None:
    nonlocal current_word, current_definition
    if not current_word:
      return
    definition = " ".join(current_definition).strip()
    raw = f"{current_word}: {definition}"
    entries.append(
        Entry(
            id=len(entries) + 1,
            word=current_word,
            definition=definition,
            examples="",
            partOfSpeech="",
            synonyms="",
            dialects="",
            searchKey=build_search_key(current_word),
            rawEntry=raw,
        )
    )
    current_word = None
    current_definition = []

  for line in lines:
    match = ENTRY_START.match(line)
    if match:
      flush()
      current_word = match.group(1).strip()
      current_definition = [match.group(2).strip()]
    elif current_word:
      current_definition.append(line)
    else:
      errors.append(f"Unparsed line: {line}")

  flush()
  return entries, errors


def main() -> None:
  parser = argparse.ArgumentParser()
  parser.add_argument("--input", required=True, help="Path to source PDF")
  parser.add_argument("--output", required=True, help="Path to output JSON")
  parser.add_argument("--error-log", default="extract_errors.log", help="Path to parser error log")
  args = parser.parse_args()

  lines = extract_lines(args.input)
  entries, errors = parse_entries(lines)

  with open(args.output, "w", encoding="utf-8") as f:
    json.dump([asdict(entry) for entry in entries], f, ensure_ascii=False, indent=2)

  if errors:
    with open(args.error_log, "w", encoding="utf-8") as ef:
      ef.write("\n".join(errors))
    logging.warning("Extraction finished with %d parse warnings. See %s", len(errors), args.error_log)
  else:
    logging.info("Extraction finished without parse warnings.")

  logging.info("Wrote %d entries to %s", len(entries), args.output)


if __name__ == "__main__":
  main()
