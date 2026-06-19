# GitHub Repository Settings (manuell)

Diese Schritte können nicht per Code im Toolkit gesetzt werden. Pro Site-Repo in GitHub UI ausführen.

## Allow auto-merge

**Settings → General → Pull Requests → Allow auto-merge** aktivieren.

## Branch Protection auf `main`

**Settings → Branches → Add branch protection rule** (oder bestehende Regel bearbeiten):

- Branch name pattern: `main`
- **Require a pull request before merging**: optional für Dependabot (Dependabot nutzt PRs)
- **Require status checks to pass before merging** (Namen nach erstem CI-Lauf prüfen):
  - `ci / quality` (lint, typecheck, build)
  - `ci / smoke` (Playwright, sobald aktiv)
- **Require branches to be up to date before merging**: empfohlen
- **Do not allow bypassing the above settings**: empfohlen

## Dependabot

**Settings → Code security → Dependabot** — Alerts und Security Updates aktiviert lassen.

## Toolkit Tag `v1`

Nach dem ersten Push des Toolkits auf `main`:

```bash
git checkout main
git pull
git tag v1
git push origin v1
```

Site-Repos referenzieren `@v1` in `uses: pynnie/sh-webdesign-toolkit/...`.
