# Data Backup & Restore Design

## Goal

Let a shop owner back up all EziTally data to a single file they control, and
restore that file later (on the same or a new device). All data already lives
in one SQLite database, so the backup is an exact copy of that database file,
which gives a reliable, loss-free round-trip.

Scope: iOS and Android (native file system). The feature is hidden on web,
where the database lives in browser storage and file backup/restore is not
reliable.

## Behavior

The Reports tab gains a "Data Backup" card with two actions:

- **Back up data** — produces a backup file and opens the native share sheet so
  the user can save it to Files, AirDrop, email, etc. The file is named
  `ezitally-backup-YYYYMMDD-HHmmss.sqlite`.
- **Restore from file** — lets the user pick a backup file. The file is
  validated first; then a destructive-action confirmation dialog warns that the
  current data will be replaced. On confirmation the database is replaced and
  reopened, and a success message is shown.

Restore never partially merges data: it fully replaces the current database
with the chosen backup.

## Architecture

Three layers keep plugin/platform code out of the testable core.

### `BackupService` (`lib/src/backup/backup_service.dart`)

Platform-agnostic core. Depends only on the `AppDatabase`, the resolved
database file path, and an injected `reopen` callback. No `share_plus`,
`file_picker`, or `path_provider` imports.

- `Future<File> createBackup(Directory destination)` — runs
  `PRAGMA wal_checkpoint(TRUNCATE)` to fold the WAL into the main file, then
  copies the database file into `destination` with the timestamped name and
  returns it.
- `Future<BackupValidation> validateBackup(File file)` — returns a result that
  is valid only when the file starts with the SQLite header
  (`SQLite format 3\u0000`), its `user_version` equals the app `schemaVersion`,
  and the expected core tables (e.g. `products`, `sales`) exist. Otherwise it
  returns a specific reason.
- `Future<void> restoreBackup(File file)` — validates again, copies the current
  database file to a `.bak` sidecar, closes the database, overwrites the main
  database file with the backup, removes any `-wal`/`-shm` sidecars, then
  invokes `reopen`. If any step after closing fails, it rolls back from `.bak`.

### `backup_providers.dart` (`lib/src/backup/backup_providers.dart`)

Thin Riverpod layer that wires the service to the platform. It resolves the
database file path and temp directory via `path_provider`, shares the created
file via `share_plus`, and picks a restore file via `file_picker`. It exposes a
controller with `idle / working / success(message) / error(message)` state for
the UI, and triggers the `ProviderScope` re-key after a successful restore.

### UI (`lib/src/backup/backup_section.dart`)

A `DataBackupCard` rendered inside the Reports screen, hidden when `kIsWeb`. It
shows the two buttons, a busy indicator while working, the destructive restore
confirmation dialog, and success/error snackbars.

### App reopen (`AppRestarter`)

A root wrapper around `ProviderScope` that can change a `ValueKey`, forcing all
providers (including `databaseProvider`) to be disposed and recreated. This
reopens the freshly restored database without a process restart.

## Data Flow

Backup: tap **Back up data** -> `createBackup(tempDir)` -> share sheet with the
file.

Restore: tap **Restore from file** -> `file_picker` -> `validateBackup` ->
confirm dialog -> `restoreBackup` -> `reopen` (re-key `ProviderScope`) ->
success snackbar. All repositories re-read from the restored database.

## Error Handling

- A non-SQLite, corrupt, or schema-mismatched file is rejected by
  `validateBackup` with a specific message, and the live database is never
  touched.
- If copying/overwriting fails during restore, the original database is restored
  from the `.bak` sidecar and an error message is shown.
- Backup failures (checkpoint or copy) surface as an error snackbar.
- All long operations show a busy state and disable the buttons to prevent
  re-entry.

## Testing

`BackupService` unit tests run against an `AppDatabase` backed by a temporary
file path so the real copy/overwrite logic is exercised:

- Create a backup, mutate/clear data, restore the backup, and assert the
  original rows return.
- `validateBackup` rejects a non-SQLite file and a file whose `user_version`
  does not match `schemaVersion`, and accepts a freshly created backup.
- A failed restore rolls back to the original data via the `.bak` sidecar.

Widget tests cover the Reports `DataBackupCard`: the restore confirmation dialog
appears before any destructive call, and success/error states render. Platform
plugin calls (`share_plus`, `file_picker`, `path_provider`) are injected so the
widget tests do not hit real plugins.

## New Dependencies

- `share_plus` — open the share sheet for the backup file.
- `file_picker` — pick a backup file to restore.
- `path_provider` — resolve the database file path and a temp directory.
