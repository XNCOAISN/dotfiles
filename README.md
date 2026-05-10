# dotfiles（Nix flake）

Nix の flake で、普段使う CLI ツール（`neovim` や `git` など）をまとめて提供します。

## 前提

- [Nix](https://nixos.org/download/) が入っていること
- この README の `nix …` は、環境によっては先頭に次を付けてください。  
  `nix --extra-experimental-features 'nix-command flakes'`

---

## 利用者向け

**どこで**: いつものターミナル（Mac / Codespace など）。**clone は不要**（`github:…` で取ります）。

### Install

GitHub 上の flake を指定し、ツール一式を **ユーザーの Nix プロファイル**に登録します。

```bash
nix profile add github:XNCOAISN/dotfiles
```

### Upgrade

登録済みの一式を、**GitHub のいまの default ブランチ**に合わせて入れ直します。

`github:…` は tarball をキャッシュします（`tarball-ttl`、多くの環境で既定は **約 1 時間**）。そのため **push 直後は `upgrade` だけだと古いコミットのまま**になることがあります。**すぐ反映したいときは `--refresh`** を付けます。

```bash
nix profile list
nix profile upgrade <Name> --refresh
```

`<Name>` は `nix profile list` の **`Name:`** の右の文字列に置き換えます。

急がない場合は TTL 経過後に **`--refresh` なし**でも取り直されることが多いです。常にすぐ取り直したい場合は `nix.conf` の `tarball-ttl` を短くしてください。

### Uninstall

プロファイルから項目を外します。`<Name>` は上と同様です。

```bash
nix profile list
nix profile remove <Name>
```

---

## 開発者向け

**どこで**: **clone 先のリポジトリルート**（`flake.nix` があるディレクトリ）。変更は **GitHub に push されてから**、利用者側の `nix profile upgrade` で取り込まれます。

### 動作確認（push 前）

clone 先のルートで、GitHub を経由せず **いまの作業ツリー**（未コミット含む）を評価できます。

初回:

```bash
cd /path/to/dotfiles
nix profile add path:$(pwd)
```

すでに **同じ `path:` で**入っているとき（例: `warning: 'dotfiles' is already added`）は **`add` ではなく `upgrade`** します。

```bash
nix profile list
nix profile upgrade <Name>
```

`<Name>` は `nix profile list` の **`Name:`** の右（多くは `dotfiles`）。`github:` のときの tarball キャッシュは関係しません。

すでに **`github:XNCOAISN/dotfiles` で**入れている場合は、`github:` と `path:` が **別項目**になることがあるため、`nix profile list` で確認し、必要なら `nix profile remove <Name>` してから入れ直すと取り違えにくいです。

### `flake.lock`

| 内容 | 説明 |
|------|------|
| 固定するもの | **`inputs`**（このリポジトリでは **`nixpkgs` の rev**） |
| 更新が主に不要な変更 | **`outputs` だけ**（パッケージ列の追加・削除など。同じ `nixpkgs` で足りる範囲） |
| 更新した方がよい変更 | **`inputs` の追加・URL/branch 変更**、**`nixpkgs` を先頭まで進めたい**とき |

clone 先のルートで:

```bash
nix flake update
```

`nixpkgs` だけ:

```bash
nix flake update nixpkgs
```

`flake.lock` を変えたら **コミットして push** し、再現性を揃えます。
