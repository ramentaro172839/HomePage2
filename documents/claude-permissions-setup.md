# Claude Code権限制限設定 (permissions.deny)

## 概要
Claude Codeの`permissions.deny`機能を使用して、AIによる意図しない破壊的な操作や機密情報へのアクセスを防ぐ設定を追加しました。

## 設定ファイル
`.claude/settings.local.json`

## 制限内容

### 1. 危険なBash操作の禁止
- `sudo:*` - 管理者権限での操作
- `rm:*` - ファイル削除操作
- `git push:*`, `git commit:*`, `git reset:*` - Git操作（意図しないコミット・プッシュを防止）
- `git rebase:*`, `git branch -D:*` - 危険なGit操作

### 2. 機密ファイルへのアクセス制限
以下のパターンを含むファイルの読み取り・編集・作成を禁止：
- `.env*` - 環境変数ファイル
- `*id_rsa*` - SSH秘密鍵
- `*private*key*` - プライベートキー
- `*secret*` - シークレットファイル
- `*token*` - トークンファイル
- `*credential*` - 認証情報ファイル
- `*password*` - パスワードファイル

### 3. 外部通信コマンドの禁止
- `curl:*`, `wget:*` - HTTP/HTTPSリクエスト
- `nc:*`, `netcat:*` - ネットワーク接続
- `ssh:*`, `scp:*`, `rsync:*` - リモート接続・ファイル転送
- `ftp:*`, `sftp:*` - ファイル転送プロトコル

### 4. データベース操作の禁止
- `psql:*` - PostgreSQL
- `mysql:*` - MySQL
- `mongod:*`, `mongo:*` - MongoDB
- `redis-cli:*` - Redis
- `sqlite3:*` - SQLite

### 5. インフラストラクチャ操作の禁止
- `docker exec:*` - Docker実行
- `kubectl:*`, `helm:*` - Kubernetes操作
- `terraform:*` - Terraform
- `aws:*`, `gcloud:*`, `az:*` - クラウドプロバイダCLI
- `heroku:*`, `firebase:*` - PaaSプラットフォーム

### 6. パッケージインストールの禁止
- `npm publish:*`, `yarn publish:*` - パッケージ公開
- `pip install:*`, `gem install:*` - パッケージインストール
- `go install:*`, `cargo install:*` - 言語固有インストール
- `brew install:*`, `apt install:*`, `yum install:*` - システムパッケージ
- `pacman -S:*`, `apk add:*`, `dnf install:*`, `zypper install:*` - その他パッケージマネージャー

### 7. システム制御操作の禁止
- `shutdown:*`, `reboot:*`, `halt:*`, `poweroff:*` - システム停止・再起動
- `systemctl:*`, `service:*` - サービス制御
- `kill:*`, `killall:*`, `pkill:*` - プロセス終了

### 8. システム監視コマンドの禁止
- `ps aux:*`, `top:*`, `htop:*` - プロセス監視
- `netstat:*`, `ss:*`, `lsof:*` - ネットワーク・ファイル監視
- `tcpdump:*`, `wireshark:*`, `nmap:*` - ネットワーク解析
- `ping:*`, `traceroute:*`, `dig:*`, `nslookup:*`, `host:*`, `whois:*` - ネットワーク診断

## 効果
- 意図しないファイル削除や システム変更を防止
- 機密情報の漏洩リスクを軽減
- 外部への不正な通信を防止
- データベースへの意図しないアクセスを防止
- システムレベルでの破壊的操作を防止

## カスタマイズ
必要に応じて`.claude/settings.local.json`のdeny配列に項目を追加・削除してプロジェクトに適合させることができます。

## 参考
この設定は [izanami.devの記事](https://izanami.dev/post/d6f25eec-71aa-4746-8c0d-80c67a1459be) を参考に実装されました。