# 📚 Skripsi Manager

> A CLI application for managing student thesis (skripsi) — handle student data, thesis records, and supervision history directly from your terminal.

![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart)
![SQLite](https://img.shields.io/badge/SQLite-3-003B57?style=flat-square&logo=sqlite)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=flat-square)

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Database](#database)
- [User Flow](#user-flow)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

---

## About

**Skripsi Manager** is a CLI (Command Line Interface) application built with Dart. It helps manage student thesis data in a structured way — from registering students, recording thesis titles and progress status, to tracking supervision sessions.

All data is stored locally using SQLite, requiring no internet connection or external server. The app runs entirely in the terminal and is well-suited as a lightweight academic administration tool.

---

## Features

### Students (Mahasiswa)
- Register new students
- List all students
- Edit student data (NIM, name, major, email)
- Delete a student along with all related thesis and supervision records

### Thesis (Skripsi)
- Add a thesis and link it to a student
- List all theses along with the student's name
- Update thesis status: `Proposal` → `In Progress` → `Revision` → `Done`

### Supervision (Bimbingan)
- Record supervision sessions per thesis
- View supervision history per thesis
- Edit supervision date and notes

### Dashboard
- Data summary displayed automatically every time the app starts
- Shows total students, total theses per status, and total supervision sessions

---

## Prerequisites

Make sure you have the Dart SDK installed.

```bash
dart --version
# Dart SDK version: 3.x.x
```

Don't have Dart yet? Follow the official installation guide: https://dart.dev/get-dart

---

## Installation

**1. Clone the repository**

```bash
git clone https://github.com/username/skripsi_manager.git
cd skripsi_manager
```

**2. Install dependencies**

```bash
dart pub get
```

That's it. No additional configuration needed.

---

## Usage

```bash
dart run lib/main.dart
```

On first run, the app will automatically create a `.data/` folder and `skripsi.db` database file in the project directory.

```
skripsi_manager/
└── .data/
    └── skripsi.db   ← auto-generated
```

> **Note:** Do not delete the `.data/` folder — all your data lives there.

### Preview

```
╔══════════════════════════════════════════╗
║     SISTEM MANAJEMEN TUGAS AKHIR         ║
╚══════════════════════════════════════════╝

══════════════════════════════════════════════
  REKAP DATA
────────────────────────────────────────────
  Total Mahasiswa  : 5
────────────────────────────────────────────
  Total Skripsi    : 4
    ↳ Proposal     : 1
    ↳ Berjalan     : 2
    ↳ Revisi       : 1
    ↳ Selesai      : 0
────────────────────────────────────────────
  Total Bimbingan  : 12
══════════════════════════════════════════════

Menu Utama:
  [1] Manajemen Mahasiswa
  [2] Manajemen Skripsi
  [3] Manajemen Bimbingan
  [0] Keluar

Pilih:
```

---

## Project Structure

```
skripsi_manager/
├── lib/
│   ├── core/
│   │   ├── db/
│   │   │   └── database.dart               # SQLite singleton connection & table init
│   │   ├── error/
│   │   │   └── failure.dart                # Sealed class for error handling
│   │   └── utils/
│   │       └── date_formatter.dart         # Date formatting helper
│   │
│   ├── features/
│   │   ├── dashboard/
│   │   │   └── dashboard.dart              # Data summary shown on startup
│   │   │
│   │   ├── mahasiswa/
│   │   │   ├── datasource/
│   │   │   │   └── mahasiswa_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── mahasiswa.dart
│   │   │   ├── usecases/
│   │   │   │   └── mahasiswa_usecases.dart
│   │   │   ├── presentation/
│   │   │   │   ├── commands/
│   │   │   │   │   └── mahasiswa_command.dart
│   │   │   │   └── presenters/
│   │   │   │       └── mahasiswa_presenter.dart
│   │   │   └── injection/
│   │   │       └── mahasiswa_module.dart
│   │   │
│   │   ├── skripsi/                        # Same structure as mahasiswa
│   │   │   └── ...
│   │   │
│   │   └── bimbingan/                      # Same structure as mahasiswa
│   │       └── ...
│   │
│   ├── injection/
│   │   └── injection_container.dart        # Aggregates all feature modules
│   │
│   └── main.dart                           # Entry point & menu routing
│
├── test/                                   # Unit tests (coming soon)
├── .data/                                  # Local database folder (auto-generated)
├── pubspec.yaml
└── README.md
```

---

## Architecture

This project follows **Clean Architecture** principles with a **per-feature module** pattern for dependency injection.

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│        Command  ←→  Presenter           │
├─────────────────────────────────────────┤
│             Domain Layer                │
│              Usecases                   │
├─────────────────────────────────────────┤
│              Data Layer                 │
│             Datasource                  │
├─────────────────────────────────────────┤
│                SQLite                   │
└─────────────────────────────────────────┘
```

### Layer Breakdown

| Layer | File | Responsibility |
|---|---|---|
| **Datasource** | `*_datasource.dart` | The only layer that touches the database. Contains raw SQL queries. |
| **Model** | `*.dart` (models/) | Data representation + `fromRow()` and `toMap()` mappers. |
| **Usecase** | `*_usecases.dart` | All validation and business logic. Unaware of UI or database details. |
| **Command** | `*_command.dart` | Handles user input from the terminal. Calls usecases. |
| **Presenter** | `*_presenter.dart` | Formats and displays output to the terminal. |
| **Module** | `*_module.dart` | Wires up all dependencies within a feature (manual DI). |
| **InjectionContainer** | `injection_container.dart` | Aggregates all modules into a single access point. |

### Why Per-Feature Module?

Compared to putting all dependencies in a single injection file, the per-feature module pattern ensures:
- Each feature is self-contained and doesn't bloat a central file
- Adding a new feature only requires creating a new module and one registration line in `InjectionContainer`
- Easier to trace dependencies during debugging

---

## Database

The app uses SQLite with three main tables linked by foreign key relationships.

### Schema

```sql
CREATE TABLE mahasiswa (
  id         TEXT PRIMARY KEY,
  nim        TEXT UNIQUE NOT NULL,
  nama       TEXT NOT NULL,
  jurusan    TEXT NOT NULL,
  email      TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE skripsi (
  id           TEXT PRIMARY KEY,
  judul        TEXT NOT NULL,
  status       TEXT NOT NULL DEFAULT 'proposal',
  mahasiswa_id TEXT NOT NULL,
  created_at   TEXT NOT NULL,
  FOREIGN KEY (mahasiswa_id) REFERENCES mahasiswa(id) ON DELETE CASCADE
);

CREATE TABLE bimbingan (
  id         TEXT PRIMARY KEY,
  tanggal    TEXT NOT NULL,
  catatan    TEXT NOT NULL,
  skripsi_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (skripsi_id) REFERENCES skripsi(id) ON DELETE CASCADE
);
```

### Relations

```
mahasiswa (1)
    └──< skripsi (many)
              └──< bimbingan (many)
```

Deletions are **cascaded** — deleting a student automatically removes their related thesis and supervision records.

### Thesis Status

| Value | Label | Description |
|---|---|---|
| `proposal` | Proposal | Title submission phase |
| `berjalan` | In Progress | Currently being worked on |
| `revisi` | Revision | Under revision |
| `selesai` | Done | Completed and approved |

---

## User Flow

Recommended order of use:

```
1. Add a Student
       ↓
2. Add a Thesis  (select an existing student)
       ↓
3. Record a Supervision Session  (select an existing thesis)
       ↓
4. Update Thesis Status as progress is made
```

---

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `sqlite3` | ^3.3.1 | SQLite driver for Dart |
| `mason_logger` | ^0.3.5 | Terminal logging & interaction (prompt, confirm, etc.) |
| `uuid` | ^4.5.3 | UUID v4 unique ID generation |

---

## License

Distributed under the MIT License. See `LICENSE` for more information.
