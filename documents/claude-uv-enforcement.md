# Claude Code UV強制設定

## 概要
Python環境管理をuvに統一するためのPreToolUseフック設定を追加しました。pipコマンドの使用を禁止し、uvの使用を強制します。

## 設定されたファイル

### `.claude/hooks/enforce-uv.sh`
Bashコマンド実行前にチェックを行い、Python関連のコマンドをuvに統一するスクリプト

### `.claude/settings.json`
PreToolUseフック設定を追加：
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "hooks/enforce-uv.sh"
          }
        ]
      }
    ]
  }
}
```

## 強制される変換ルール

### 1. パッケージインストール
- `pip install package` → `uv add package`
- `pip install --dev package` → `uv add --dev package`
- `pip install -r requirements.txt` → `uv add -r requirements.txt`

### 2. Python実行（推奨提示）
- `python script.py` → `uv run python script.py`
- `python3 script.py` → `uv run python script.py`
- `python -m module` → `uv run python -m module`

### 3. 仮想環境管理（推奨提示）
- `python -m venv` → `uv init` + `uv venv`
- `virtualenv` → `uv venv`

### 4. 依存関係管理（推奨提示）
- `pip freeze > requirements.txt` → `uv export --format requirements-txt --output-file requirements.txt`

## 動作仕様

### エラーで停止するコマンド
- `pip install` 系のコマンド → uvの代替コマンドを提示して実行停止

### 警告のみで実行継続するコマンド
- `python` / `python3` 実行コマンド → 推奨コマンドを提示して実行継続
- 仮想環境関連コマンド → uvの推奨方法を提示して実行継続
- `pip freeze` → uvの代替方法を提示して実行継続

## 設定の統合状況

### `.claude/settings.json`
- 既存のフック設定（pre_command, stop_words）と併用
- PreToolUseフックを新規追加

### `.claude/settings.local.json`
- 権限制限（permissions.deny）設定は維持
- `Bash(pip install:*)` が既に禁止設定に含まれているため、二重の保護体制

## 効果
- pipコマンドの意図しない使用を防止
- Python環境管理をuvに統一
- 仮想環境の適切な使用を促進
- プロジェクトの依存関係管理の一貫性を確保

## カスタマイズ
`enforce-uv.sh`スクリプトを編集することで、チェックルールや推奨コマンドをプロジェクトに応じてカスタマイズできます。

## 参考
この設定は [Zennの記事](https://zenn.dev/gotalab/articles/2fe8d7a15409c8#%E5%AE%9F%E9%9A%9B%E3%81%AEhooks%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%EF%BC%88%E5%85%A8%E5%85%AC%E9%96%8B%EF%BC%89) を参考に実装されました。