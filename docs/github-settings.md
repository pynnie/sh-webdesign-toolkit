# GitHub Repository Settings (manuell)

Diese Schritte können nicht per Code im Toolkit gesetzt werden. Pro Site-Repo in GitHub UI ausführen.

## Toolkit-Zugriff (einmalig, Pflicht für private Repos)

Reusable Workflows aus `pynnie/sh-webdesign-toolkit` brauchen Freigabe:

**GitHub UI:** `sh-webdesign-toolkit` → Settings → Actions → General → Access → **Accessible from repositories owned by 'pynnie' user**

**Oder per API:**

```bash
gh api -X PUT repos/pynnie/sh-webdesign-toolkit/actions/permissions/access \
  -f access_level=user
```

Ohne das schlagen Site-Workflows mit „workflow file issue“ fehl (0s Laufzeit).

## Dependabot-Merge ohne GitHub Pro

**GitHub Native Auto-Merge** ist auf privaten Free-Repos nicht nötig.

Der Merge passiert in **`ci.yml`**: Job `merge-dependabot` läuft nach grünem `ci`-Job, nur bei Dependabot-PRs, und merged per `pulls.merge` (squash).

Der Job braucht **`workflows: write`**, wenn Dependabot auch `.github/workflows/*` ändert (z. B. `github-actions`-Gruppe).

**Settings → Actions → General → Workflow permissions:** **Read and write permissions** (nicht nur Read). Oder per API:

```bash
gh api -X PUT repos/pynnie/REPO/actions/permissions/workflow \
  -f default_workflow_permissions=write
```

## Branch Protection auf `main` (optional)

**Settings → Branches** — Required checks nach erstem CI-Lauf:

- `ci / quality`
- `ci / smoke`

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
