# action-sync

This Github Action checks if an upstream repository has a release with a tag higher than the latest local tag and creates a branch and pull request for syncing.

## Setup

- In the repo settings, go to "Actions" -> "General":
    - Check "Allow onfocusio actions and reusable workflows"
    - Check "Read and write permissions" under "Workflow permissions"
    - Check "Allow GitHub Actions to create and approve pull requests"

```yml
name: Sync PR

env:
  GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

# This runs every day on 7am UTC
on:
  schedule:
    - cron: '0 7 * * *'
  # Allows manual workflow run (must in default branch to work)
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Create sync PR
        uses: onfocusio/action-sync@v0.1.8
        with:
          upstream_repo: "owner/repo"
          target_branch: "main"
```
