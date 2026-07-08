# GitHub Repository Settings (manuell)

Diese Schritte können nicht per Code im Toolkit gesetzt werden. Pro Site-Repo in GitHub UI ausführen.

## Toolkit-Zugriff für Dependabot (Pflicht)

Das Toolkit `pynnie/sh-webdesign-toolkit` ist **public**. Grund: Dependabot-PRs (`pull_request`-Event) laufen mit einem eingeschränkten read-only Token und können **private** Reusable Workflows nicht auflösen → Site-CI scheitert in 0s („workflow file issue"). Ein public Toolkit löst das ohne Zugriffs-Gefrickel (enthält keine Secrets, nur CI/Deploy-YAML).

Falls das Toolkit doch privat sein muss: entweder CI pro Site inlinen (kein privater Reusable-Call im Dependabot-Lauf) oder `access_level=user` setzen — letzteres reicht aber **nicht** für den Dependabot-`pull_request`-Kontext.

## Dependabot-Merge ohne GitHub Pro

**GitHub Native Auto-Merge** ist auf privaten Free-Repos nicht nötig.

Der Merge passiert in **`ci.yml`**: Job `merge-dependabot` läuft nach grünem `ci`-Job, nur bei Dependabot-PRs, und merged per `pulls.merge` (squash). Job-Permissions: `contents: write` + `pull-requests: write` + `actions: write`.

> [!warning] Deploy nach Auto-Merge muss explizit angestoßen werden
> Ein Merge per `GITHUB_TOKEN` löst **kein** `push`-Event aus (GitHub-Anti-Rekursions-Schutz) → der `deploy.yml`-Workflow auf `main` startet sonst nie. Der `merge-dependabot`-Job dispatcht deshalb nach dem Merge `deploy.yml` per `actions.createWorkflowDispatch` (dafür `actions: write`). Krüger-Sites müssen dort `deploy-strato-ftps.yml` als `workflow_id` setzen.

> [!warning] Kein `workflows: write` im permissions-Block
> `workflows` ist **kein gültiger `permissions`-Scope** — ein solcher Key macht die komplette Workflow-Datei ungültig (0s „workflow file issue"). Bumpt Dependabot `.github/workflows/*` (github-actions-Gruppe) und der Merge scheitert mit 403 „without workflows permission", löst das **nicht** ein Job-Permission, sondern das Repo-Setting unten.

**Settings → Actions → General → Workflow permissions:** **Read and write permissions** (nicht nur Read). Oder per API:

```bash
gh api -X PUT repos/pynnie/REPO/actions/permissions/workflow \
  -f default_workflow_permissions=write
```

## Branch Protection auf `main` (optional)

**Settings → Branches** — Required checks nach erstem CI-Lauf:

- `ci / quality` (enthält Lint, Typecheck, Build und Playwright-Smoke)

Auf Free-Accounts greift Branch Protection eingeschränkt; der Merge-Job in CI ist die eigentliche Schranke.

## Dependabot

**Settings → Code security → Dependabot** — Alerts aktiv lassen.

## Repo-Variablen

| Variable | Zweck |
|----------|-------|
| `DEPLOY_WEBHOOK_URL` | Prod-Deploy nach Merge auf `main` |
| `PREVIEW_DEPLOY_WEBHOOK_URL` | Preview-Deploy für Feature/Dependabot-Branches |

## Toolkit Tag `v1`

Site-Repos referenzieren `@v1`. Bei Breaking Changes neues Tag setzen.
