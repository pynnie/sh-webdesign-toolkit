# sh-webdesign-toolkit

Zentralisierte Build- und Deploy-Toolchain für alle SH WebDesign Website-Repos (Next.js Static Export).

## Enthalten

| Pfad | Zweck |
|------|-------|
| `.github/workflows/deploy-static-next.yml` | Prod: build → `deploy` → Webhook |
| `.github/workflows/deploy-preview-static-next.yml` | Preview: build → `preview` → Webhook |
| `.github/workflows/ci-next.yml` | lint + typecheck + build (+ optional Smoke) |
| `.github/workflows/smoke-playwright.yml` | Playwright gegen Static Export |
| `.github/dependabot.yml` | Dependabot-Config des Toolkits (nur github-actions) |
| `.github/templates/` | Dünne Workflows + `dependabot.yml` zum Kopieren in Site-Repos |
| `docs/onboarding-new-site.md` | Neue Site anlegen |
| `docs/github-settings.md` | Manuelle GitHub-Einstellungen |

## Site-Repo einbinden

```yaml
# .github/workflows/deploy.yml
jobs:
  deploy:
    uses: pynnie/sh-webdesign-toolkit/.github/workflows/deploy-static-next.yml@v1
    secrets: inherit
```

Siehe [docs/onboarding-new-site.md](docs/onboarding-new-site.md).

## Versionierung

Breaking Changes: neues Tag (`v2`). Sites pinnt `@v1` bis Migration.
