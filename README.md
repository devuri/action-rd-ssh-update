# Rd SSH Updates

Update Composer dependencies over SSH with logging and send a notification to Slack.

## Description

This GitHub Action allows you to update Composer dependencies on a remote server via SSH. It includes logging and notifies a Slack channel upon completion.

## Inputs

| Input            | Description                          | Required | Default  |
|------------------|--------------------------------------|----------|----------|
| `web_app_path`   | Path to the web application.         | Yes      | N/A      |
| `ssh_host`       | SSH host.                            | Yes      | N/A      |
| `ssh_username`   | SSH username.                        | Yes      | N/A      |
| `ssh_password`   | SSH password.                        | Yes      | N/A      |
| `ssh_port`       | SSH port.                            | Yes      | N/A      |
| `slack_webhook`  | Slack Webhook URL.                   | Yes      | N/A      |
| `slack_channel`  | The Slack channel for updates.       | No       | `general`|

## Usage

To use this action in your GitHub workflow, include a step that references this action and provides the necessary inputs.

### Example Workflow

```yaml
name: Update Website

on:
  pull_request:
    types:
      - closed
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * 0' # Runs at 00:00 UTC every Sunday

env:
  WEB_APP_PATH: "/srv/users/uwilson/apps/uwilson"

jobs:
  update:
    name: "Update Web Application"
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Update and Backup Dependencies
        uses: ./.github/actions/rd-ssh-updates
        with:
          web_app_path: ${{ env.WEB_APP_PATH }}
          ssh_host: ${{ secrets.SSH_HOST }}
          ssh_username: ${{ secrets.SSH_USERNAME }}
          ssh_password: ${{ secrets.SSH_PASSWORD }}
          ssh_port: ${{ secrets.SSH_PORT }}
          slack_webhook: ${{ secrets.SLACK_WEBHOOK }}
          slack_channel: "general"
```

## Secrets

Ensure the following secrets are added to your repository settings:

- `SSH_HOST`
- `SSH_USERNAME`
- `SSH_PASSWORD`
- `SSH_PORT`
- `SLACK_WEBHOOK`

This action will perform the following steps:

1. Connect to the remote server via SSH.
2. Backup the `composer.lock` file.
3. Run `composer update` to update dependencies.
4. Log the update process.
5. Notify the specified Slack channel of the update status.
