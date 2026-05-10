# dotfiles（Nix flake）

Nix を使って、よく使うコマンドラインツールを **まとめて入れる**ための設定です（`neovim` や `git` など。このリポジトリの「入れる物のリスト」が Nix の flake になっています）。

## 前提

- パソコンに [Nix](https://nixos.org/download/) が入っていること
- 下のコマンドをそのまま打てない場合は、先頭に  
  `nix --extra-experimental-features 'nix-command flakes' `  
  を付けて試してください（Nix の「実験的機能」を一度オンにするイメージです）。

## Install

GitHub 上のこのリポジトリを指定して、**ツール一式をあなたのユーザー向けの環境に登録**します。登録が終わると、通常はターミナルからそのコマンドが使えるようになります。

```bash
nix profile add github:XNCOAISN/dotfiles
```

## Upgrade

**すでに登録したセットを、いまの GitHub 上の最新内容で入れ直す**操作です。

```bash
nix profile list
nix profile upgrade <Name>
```

## Uninstall

**登録したセットをやめる**操作です。

```bash
nix profile list
nix profile remove <Name>
```
