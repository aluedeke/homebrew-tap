# aluedeke/homebrew-tap

Homebrew formulae for [tenx](https://github.com/aluedeke/tenx), a task manager on top of tmux for working on many tasks in parallel, each with its own git worktrees and its own Claude Code agent.

```sh
brew install aluedeke/tap/tenx
```

`Formula/tenx.rb` is written by tenx's release workflow ([cargo-dist](https://axodotdev.github.io/cargo-dist/)) on every release. Nothing in it is edited by hand; changes go to the tenx repository.

`Formula/tenx-agent.rb` is tenx's voice assistant, written by hand. It has no releases: it installs the newest commit on `main`, over SSH, from a private repository, so only on a Mac whose SSH key can read it.

```sh
brew install --HEAD aluedeke/tap/tenx-agent
brew services start tenx-agent
brew upgrade --fetch-HEAD tenx-agent && brew services restart tenx-agent   # a newer main
```
