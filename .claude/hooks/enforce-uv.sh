#!/bin/bash

# enforce-uv.sh - Python環境管理をuvに強制するフック
# pipコマンドをuvに置き換え、Python実行をuv run pythonで統一する

set -e

# 引数の確認
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

COMMAND="$1"

# pipコマンドのチェックと置換
if echo "$COMMAND" | grep -q "pip install"; then
    if echo "$COMMAND" | grep -q "\-\-dev\|\-e"; then
        # 開発依存関係の場合
        PACKAGE=$(echo "$COMMAND" | sed 's/.*pip install[[:space:]]*//' | sed 's/[[:space:]]*$//')
        NEW_COMMAND="uv add --dev $PACKAGE"
        echo "Error: pipコマンドが検出されました。"
        echo "代替コマンド: $NEW_COMMAND"
        echo "uvを使用してパッケージをインストールしてください。"
        exit 1
    elif echo "$COMMAND" | grep -q "\-r.*requirements"; then
        # requirements.txtからのインストール
        REQUIREMENTS_FILE=$(echo "$COMMAND" | sed 's/.*-r[[:space:]]*//' | sed 's/[[:space:]]*$//')
        NEW_COMMAND="uv add -r $REQUIREMENTS_FILE"
        echo "Error: pipコマンドが検出されました。"
        echo "代替コマンド: $NEW_COMMAND"
        echo "uvを使用してrequirementsファイルをインストールしてください。"
        exit 1
    else
        # 通常のパッケージインストール
        PACKAGE=$(echo "$COMMAND" | sed 's/.*pip install[[:space:]]*//' | sed 's/[[:space:]]*$//')
        NEW_COMMAND="uv add $PACKAGE"
        echo "Error: pipコマンドが検出されました。"
        echo "代替コマンド: $NEW_COMMAND"
        echo "uvを使用してパッケージをインストールしてください。"
        exit 1
    fi
fi

# pip以外のpipコマンドチェック
if echo "$COMMAND" | grep -q "^pip "; then
    echo "Error: pipコマンドの使用は禁止されています。"
    echo "uvを使用してください。"
    exit 1
fi

# python実行のチェックと置換提案
if echo "$COMMAND" | grep -q "^python "; then
    PYTHON_ARGS=$(echo "$COMMAND" | sed 's/^python[[:space:]]*//')
    NEW_COMMAND="uv run python $PYTHON_ARGS"
    echo "Info: pythonコマンドが検出されました。"
    echo "推奨コマンド: $NEW_COMMAND"
    echo "uvの仮想環境で実行することを推奨します。"
    # pythonコマンドは警告のみで実行を許可
    exit 0
fi

# python3実行のチェックと置換提案
if echo "$COMMAND" | grep -q "^python3 "; then
    PYTHON_ARGS=$(echo "$COMMAND" | sed 's/^python3[[:space:]]*//')
    NEW_COMMAND="uv run python $PYTHON_ARGS"
    echo "Info: python3コマンドが検出されました。"
    echo "推奨コマンド: $NEW_COMMAND"
    echo "uvの仮想環境で実行することを推奨します。"
    # python3コマンドは警告のみで実行を許可
    exit 0
fi

# python -mの実行チェック
if echo "$COMMAND" | grep -q "python -m\|python3 -m"; then
    MODULE_ARGS=$(echo "$COMMAND" | sed 's/.*python[0-9]* -m[[:space:]]*//')
    NEW_COMMAND="uv run python -m $MODULE_ARGS"
    echo "Info: Python モジュール実行が検出されました。"
    echo "推奨コマンド: $NEW_COMMAND"
    echo "uvの仮想環境で実行することを推奨します。"
    # python -mコマンドは警告のみで実行を許可
    exit 0
fi

# 仮想環境関連コマンドのチェック
if echo "$COMMAND" | grep -q "venv\|virtualenv"; then
    echo "Info: Python仮想環境コマンドが検出されました。"
    echo "推奨: uv init でプロジェクトを初期化し、uv venv で仮想環境を作成してください。"
    # 仮想環境コマンドは警告のみで実行を許可
    exit 0
fi

# requirements.txt生成のチェック
if echo "$COMMAND" | grep -q "freeze.*requirements"; then
    echo "Info: requirements.txt生成コマンドが検出されました。"
    echo "推奨: uv export --format requirements-txt --output-file requirements.txt"
    echo "uvを使用して依存関係をエクスポートすることを推奨します。"
    # freezeコマンドは警告のみで実行を許可
    exit 0
fi

# その他のコマンドは許可
echo "コマンド「$COMMAND」は実行許可されました。"
exit 0