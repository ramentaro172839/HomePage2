#!/bin/bash

# hook_pre_commands.sh - コマンド実行前チェックフック
# Claude Codeがコマンドを実行する前に、禁止コマンドが含まれていないかを検証

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$SCRIPT_DIR/rules/hook_pre_commands_rules.json"

# 引数の確認
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

COMMAND="$1"

# ルールファイルの存在確認
if [ ! -f "$RULES_FILE" ]; then
    echo "Error: Rules file not found: $RULES_FILE"
    exit 1
fi

# 禁止コマンドをJSONファイルから読み込んで検査
FORBIDDEN_COMMANDS=$(cat "$RULES_FILE" | grep -o '"[^"]*"' | sed 's/"//g')

for cmd in $FORBIDDEN_COMMANDS; do
    if echo "$COMMAND" | grep -q "$cmd"; then
        echo "Error: 禁止コマンド「$cmd」が検出されました。"
        echo "このコマンドの実行は許可されていません。"
        exit 1
    fi
done

echo "コマンド「$COMMAND」は実行許可されました。"
exit 0