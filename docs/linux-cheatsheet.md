# Linux Command Cheatsheet

This document lists basic Linux commands used while working on the AI DevOps Log Analyzer project.

---

## pwd

Shows the current directory path.

Example:
pwd

Example output:
/Users/miraj/ai-devops-log-analyzer

---

## ls

Lists files and folders in the current directory.

Example:
ls

Example output:
app docker docs terraform diagrams screenshots README.md

---

## cd

Changes directory (moves between folders).

Example:
cd docs

Go back one directory:
cd ..

---

## mkdir

Creates a new folder.

Example:
mkdir temp-test

---

## rm -r

Deletes a folder and everything inside it.

Example:
rm -r temp-test

---

## cat

Displays the contents of a file.

Example:
cat README.md

---

## less

Opens a file for reading and scrolling.

Example:
less README.md

Press q to exit.

---

## grep

Searches for text inside a file.

Example:
grep "Project" README.md

---

## curl

Sends an HTTP request from the terminal.

Example:
curl http://example.com

Example API test:
curl http://localhost:8000/health

---

## top

Displays running system processes in real time.

Example:
top

Press q to exit.
