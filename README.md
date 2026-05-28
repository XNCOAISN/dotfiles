# dotfiles（Nix flake + Home Manager）

[Home Manager](https://github.com/nix-community/home-manager) で、CLI ツール、`bash` / `zsh`、starship を宣言的に管理します。

## 前提

- [Nix](https://nixos.org/download/) が入っていること
- この README の `nix …` は、環境によっては先頭に次を付けてください。  
  `nix --extra-experimental-features 'nix-command flakes'`

---

## 利用者向け

**どこで**: いつものターミナル（Mac など）。**clone は不要**（`github:…` で取ります）。

### 適用（一発・推奨）

**Apple Silicon（aarch64-darwin）** の Mac では、次のどちらかで Home Manager の適用まで行えます（事前に `home-manager` をプロファイルへ入れる必要はありません）。

```bash
nix run github:XNCOAISN/dotfiles
```

```bash
nix run github:XNCOAISN/dotfiles#switch
```

**Intel Mac（x86_64-darwin）** では、このリポジトリの [flake.nix](flake.nix) では `homeConfigurations` が **`te@mac-intel`** になっています。`nix run` は同じコマンドで、flake が選ぶ `apps` 側で `#te@mac-intel` に向きます。

`nix run …#switch` では、Home Manager が上書きしそうな既存ファイルを **`*.hm-backup`** に退避してから置き換えます（`home-manager switch -b hm-backup` 相当）。

`github:…` の tarball キャッシュ（TTL）の注意: **push 直後すぐ反映したい**ときは、Nix 側の tarball 取り直し（例: `nix run` / `nix build` に **`--refresh`**）や、しばらく待つ、などの扱いが必要になることがあります。

### 代替（`home-manager` を常に PATH に置きたい場合）

```bash
nix profile install nixpkgs#home-manager
home-manager switch -b hm-backup --flake github:XNCOAISN/dotfiles#te@mac
```

Intel の場合は `#te@mac-intel` に読み替えてください。

### 別ユーザー・別ホーム

[hosts/*/default.nix](hosts/mac/default.nix) の `home.username` / `home.homeDirectory` と、[flake.nix](flake.nix) の `homeConfigurations` / `mkSwitchApp` の属性名を自分用に変えてから使います。

### devcontainer（VS Code）

**どこで**: devcontainer 内のターミナル（[.devcontainer/devcontainer.json](.devcontainer/devcontainer.json) で Nix を有効化）。

clone 済みのリポジトリルートで:

```bash
nix run .#switch
```

リモートから取る場合:

```bash
nix run github:XNCOAISN/dotfiles#switch
```

**x86_64-linux** では `#vscode@devcontainer`、**aarch64-linux** では `#vscode@devcontainer-arm64` が選ばれます（`nix run` は flake の `apps` 側で自動選択）。

明示的に指定する場合:

```bash
home-manager switch -b hm-backup --flake .#vscode@devcontainer
```

arm64 コンテナでは `#vscode@devcontainer-arm64` に読み替えてください。

### アンインストール

```bash
home-manager uninstall
```

（環境によってコマンド名が異なる場合は [Home Manager のマニュアル](https://nix-community.github.io/home-manager/)を参照してください。）

---

## 開発者向け

**どこで**: **clone 先のリポジトリルート**（`flake.nix` があるディレクトリ）。

### 動作確認（push 前）

```bash
cd /path/to/dotfiles
git add -A
```

activation のみビルド（適用はしない）:

```bash
nix build ".#homeConfigurations.te@mac.activationPackage" --no-link
```

Intel 用の構成を試す場合は `te@mac-intel` に読み替えてください。未追跡ファイルだけがあると、flake が Git から読む設定では評価に失敗することがあるため、**評価前に `git add`** しておくと確実です。

devcontainer 用（**Linux 上でのみ**ビルド可能。Mac からは platform mismatch になります）:

```bash
nix build ".#homeConfigurations.vscode@devcontainer.activationPackage" --no-link
```

arm64 用:

```bash
nix build ".#homeConfigurations.vscode@devcontainer-arm64.activationPackage" --no-link
```

### `flake.lock`

| 内容 | 説明 |
|------|------|
| 固定するもの | **`inputs`**（`nixpkgs` / `home-manager` の rev など） |
| 更新が主に不要な変更 | **`outputs` のモジュール中身だけ**（同じ lock の範囲） |
| 更新した方がよい変更 | **`inputs` の追加・follows 変更**、`nixpkgs` / `home-manager` を進めたいとき |

clone 先のルートで:

```bash
nix flake update
```

`nixpkgs` だけ:

```bash
nix flake update nixpkgs
```

`flake.lock` を変えたら **コミットして push** し、再現性を揃えます。
