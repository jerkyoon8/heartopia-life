# Heartopia Wiki Agent Rules

## Project Specs

- MySQL baseline: MySQL 8.0.
- Spring SQL auto-initialization is disabled with `spring.sql.init.mode=never`.
- SQL schema or seed changes usually require a separate DB execution step after deployment.
- When adding or changing SQL, schema, seed data, or mapper code that depends on a new DB column/table/index, tell the user clearly that the SQL must be executed before asking them to run or test the app.
- Keep Heartopia-specific runtime, DB, deployment, and server notes in `C:\Users\k\.codex\manuals\heartopia_project_info.md`.
- Before production server, Docker, Nginx, production MySQL, deploy, rollback, or server log work, follow `C:\Users\k\.codex\manuals\heartopia_server_access_rules.md`.
