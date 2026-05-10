# dotfiles（Nix flake）

Nix を使って、よく使うコマンドラインツールを **まとめて入れる**ための設定です（`neovim` や `git` など。このリポジトリの「入れる物のリスト」が Nix の flake になっています）。

## 共通の前提

- パソコンに [Nix](https://nixos.org/download/) が入っていること
- 下のコマンドをそのまま打てない場合は、先頭に  
  `nix --extra-experimental-features 'nix-command flakes' `  
  を付けて試してください（Nix の「実験的機能」を一度オンにするイメージです）。

---

## 利用者向け（ツールを自分の環境に入れる）

**どこで**: 普段使っているターミナル（自分の Mac、Codespace のターミナルなど）。**このリポジトリを clone している必要はありません**（GitHub 上の flake を URL で指定します）。

### Install

GitHub 上のこのリポジトリを指定して、**ツール一式をあなたのユーザー向けの環境に登録**します。登録が終わると、通常はターミナルからそのコマンドが使えるようになります。

```bash
nix profile add github:XNCOAISN/dotfiles
```

### Upgrade

**すでに登録したセットを、いまの GitHub 上の最新内容で入れ直す**操作です。

`github:…` で入れた flake は、Nix が **GitHub の tarball をしばらくキャッシュ**します（設定 `tarball-ttl`、既定はだいたい 1 時間）。そのため **`nix profile upgrade` だけだと、push 直後にまだ古いコミットのまま**になることがあります。

**push したあとすぐ反映したいときは `--refresh` を付けます**（キャッシュを古いとみなして取り直す指定です）。

```bash
nix profile list
nix profile upgrade <Name> --refresh
```

急がない場合は TTL が切れるまで待てば、**`--refresh` なしでも**新しい tarball を取りに行くことが多いです。いつもすぐ取り直したい場合は `nix.conf` の `tarball-ttl` を短くする方法もあります。

### Uninstall

**登録したセットをやめる**操作です。

```bash
nix profile list
nix profile remove <Name>
```

---

## 開発者向け

**どこで**: **このリポジトリを clone したディレクトリ**（`flake.nix` がある場所）。`flake.nix` や `flake.lock` を編集し、**GitHub に push する**のはこちらの作業です。push されて初めて、**利用者向けの `nix profile upgrade` が新しい内容を取りに行けます**。

### `flake.lock`

**何を固定しているか**: `flake.lock` は **`inputs`（このリポジトリでは `nixpkgs` の取得先と rev）** を記録します。`flake.nix` の **`outputs` 側だけ**（入れるパッケージの列など）を変えただけなら、**ロックは変わらなくてよい**ことが多いです。

**いつ更新するか（更新した方がよいとき）**

- `inputs` に **新しい入力を足した**／**URL や branch を変えた**
- **同じブランチのまま `nixpkgs` の先頭を取り直したい**（ツールの版も追従させたい）

**いつ必須ではないか**

- **`outputs` のパッケージ一覧だけ**変えた（いまの `nixpkgs` の範囲で足りる変更）

**更新のしかた**（clone したリポジトリのルートで）

```bash
nix flake update
```

入力を一つだけ上げる例:

```bash
nix flake update nixpkgs
```

変更した `flake.lock` は **Git にコミットして push** しておくと、他のマシンや CI でも **同じ `nixpkgs` の版**で再現しやすくなります。
