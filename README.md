# dotfiles

This repo contains the basic configuration for my machines. This uses [Chezmoi](https://chezmoi.io), to pull my dotfiles and run a setup script and ansible play-book.

## How to run

```shell
export GITHUB_USERNAME=nkamenar
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

## Without script execution

```shell
export GITHUB_USERNAME=nkamenar
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --exclude=scripts --apply $GITHUB_USERNAME
```