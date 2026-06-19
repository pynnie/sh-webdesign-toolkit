# GitHub Repository Settings (manuell)

Diese Schritte können nicht per Code im Toolkit gesetzt werden. Pro Site-Repo in GitHub UI ausführen.

## Dependabot-Merge ohne GitHub Pro

**GitHub Native Auto-Merge** (Settings → Allow auto-merge) ist auf **privaten Free-Repos nicht verfügbar** bzw. setzt Pro/Team voraus.

Stattdessen merged `.github/workflows/dependabot-auto-merge.yml` Dependabot-PRs **direkt per Action**, sobald der **CI**-Workflow auf dem PR erfolgreich durchgelaufen ist. Dafür ist **kein** Auto-Merge-Toggle nötig.

Optional kannst du Branch Protection aktivieren (abhängig vom GitHub-Plan). Der Merge-Workflow ist unabhängig davon die eigentliche Sicherheits-Schranke: Merge nur nach grünem CI.

## Branch Protection auf `main` (optional, Plan-abhängig)

**Settings → Branches → Add branch protection rule**:

- Branch name pattern: `main`
- **Require status checks to pass before merging** (Namen nach erstem CI-Lauf prüfen):
  - `ci / quality` (lint, typecheck, build)
  - `ci / smoke` (Playwright)
- **Require branches to be up to date before merging**: empfohlen

Auf Free-Accounts mit privaten Repos greift Branch Protection ggf. eingeschränkt — der `dependabot-auto-merge`-Workflow wartet trotzdem auf erfolgreiches CI (`workflow_run`).

## Dependabot

**Settings → Code security → Dependabot** — Alerts und Security Updates aktiviert lassen.

## Repo-Variablen

| Variable | Zweck |
|----------|-------|
| `DEPLOY_WEBHOOK_URL` | Prod-Deploy nach Merge auf `main` |
| `PREVIEW_DEPLOY_WEBHOOK_URL` | Preview-Deploy für Feature/Dependabot-Branches |

## Toolkit Tag `v1`

Site-Repos referenzieren `@v1` in `uses: pynnie/sh-webdesign-toolkit/...`.

Bei Breaking Changes im Toolkit: neues Tag setzen und Site-Repos anpassen.
