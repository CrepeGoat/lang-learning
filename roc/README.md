# install Roc via `nix flakes`

```sh
nix --extra-experimental-features nix-command --extra-experimental-features flakes shell github:roc-lang/roc
```

- `--extra-experimental-features nix-command` - allows for `nix shell` command (as opposed to `nix-shell`)
- `--extra-experimental-features flakes` - allows processing a `flakes.nix` file
- `nix shell github:roc-lang/roc` - read `flakes.nix` file from the GitHub repo `roc-lang/roc` & generate environment
