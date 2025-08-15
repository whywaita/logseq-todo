# tagpr Setup Guide

## Overview
This repository uses [tagpr](https://github.com/Songmu/tagpr) for automated release management via pull requests.

## How It Works
1. When changes are merged to the `main` branch, tagpr creates/updates a release PR
2. The release PR automatically updates version tags and generates changelogs
3. Merging the release PR creates a new GitHub release with the appropriate version tag

## Repository Setup
The following files have been configured:

### `.github/workflows/tagpr.yml`
- Runs on pushes to the `main` branch
- Uses the default `GITHUB_TOKEN` for authentication

### `.tagpr`
Configuration file with:
- `vPrefix = true`: Version tags use "v" prefix (e.g., v1.0.0)
- `releaseBranch = main`: Releases are created from the main branch
- `release = true`: Automatically creates GitHub releases
- `changelog = true`: Generates changelog from commit messages

## Required GitHub Settings

### 1. Allow GitHub Actions to Create Pull Requests
Go to **Settings** → **Actions** → **General** and ensure:
- "Allow GitHub Actions to create and approve pull requests" is enabled

### 2. Branch Protection (if enabled)
If you have branch protection on `main`, ensure GitHub Actions can:
- Create pull requests
- Push to the repository

## Usage

### Normal Development
1. Create feature branches and merge to `main` as usual
2. tagpr automatically creates/updates a release PR after each merge

### Creating a Release
1. Review the auto-generated release PR
2. The PR will contain:
   - Version bump information
   - Generated changelog
3. Merge the PR to create a new release

### Version Bumping
tagpr determines version bumps based on:
- Conventional commit messages (feat:, fix:, etc.)
- PR labels (if configured)
- Manual version specification in commit messages

## Troubleshooting

### Release PR Not Created
- Check GitHub Actions logs for errors
- Verify permissions are correctly set
- Ensure `.tagpr` configuration is valid

### Permission Errors
If you see permission errors, verify:
1. GitHub Actions has write permissions
2. The workflow is using the correct token
3. Branch protection rules allow Actions to create PRs

## Additional Resources
- [tagpr Documentation](https://github.com/Songmu/tagpr)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)