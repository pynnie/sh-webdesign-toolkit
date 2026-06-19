# Neue Site in 10 Minuten

Checkliste für ein neues Next.js Static-Export-Projekt unter `pynnie/*`.

## 1. Repository anlegen

- GitHub Template aus `website-sh-webdesign` nutzen (sobald aktiviert) oder Repo manuell klonen
- Next.js mit `output: "export"` und Build nach `out/`

## 2. GitHub Variables (Settings → Secrets and variables → Actions → Variables)

| Variable | Pflicht | Zweck |
|----------|---------|-------|
| `DEPLOY_WEBHOOK_URL` | ja (netcup/Plesk) | Prod-Deploy nach Push auf `main` |
| `PREVIEW_DEPLOY_WEBHOOK_URL` | empfohlen | Preview-Deploy für Feature/Dependabot-Branches |
| `NEXT_PUBLIC_SITE_URL` | optional | SEO/Canonical Override |

## 3. Workflows kopieren

Aus [`sh-webdesign-toolkit/.github/templates/`](../.github/templates/) nach `.github/workflows/`:

- `site-deploy.yml` → `deploy.yml`
- `site-preview.yml` → `deploy-preview.yml`
- `site-ci.yml` → `ci.yml` (enthält Dependabot-Merge nach grünem CI)

Alle referenzieren `pynnie/sh-webdesign-toolkit/.github/workflows/...@v1`.

## 4. Dependabot

`.github/dependabot.yml` aus dem Toolkit kopieren (oder Symlink-Vorlage im Template-Repo).

## 5. Playwright Smoke (empfohlen)

- `tests/smoke/` + `playwright.config.ts` aus Pilot-Repo `website-sh-webdesign`
- `package.json`: `@playwright/test`, Script `"test:smoke": "playwright test"`
- In `ci.yml`: `run_smoke_tests: true`

## 6. GitHub Repo-Einstellungen

1. **Toolkit-Zugriff** in `sh-webdesign-toolkit` setzen (siehe [github-settings.md](github-settings.md))
2. **Dependabot-Merge** läuft automatisch in `ci.yml` — kein GitHub Pro nötig
3. **Branch protection auf `main`** (optional, Plan-abhängig):
   - Required checks: `ci / quality`, `ci / smoke`
   - Require branches to be up to date before merging
4. Plesk: Git-Deployment auf Branch `deploy` (Prod) bzw. `preview` (Staging)

## 7. Krüger-Ausnahme (Strato SFTP)

Prod-Deploy bleibt im Site-Repo als `deploy-strato-ftps.yml` (self-hosted Runner). Preview + CI über Toolkit.

## 8. TKA-Ausnahme

In `deploy.yml` / `deploy-preview.yml`:

```yaml
with:
  webhook_skip_if_empty: true
```

## Versionierung

Toolkit-Updates: neues Tag (`v2`) setzen, Site-Repos pinnt `@v2` wenn bereit.
