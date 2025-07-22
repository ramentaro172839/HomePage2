#!/bin/bash

# hook_stop_words.sh - 禁止ワードチェックフック
# Claude Codeの最終メッセージ内容をチェックして、禁止ワードが含まれていないかを検証

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$SCRIPT_DIR/rules/hook_stop_words_rules.json"

# 引数の確認
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <message_content>"
    exit 1
fi

MESSAGE_CONTENT="$1"

# ルールファイルの存在確認
if [ ! -f "$RULES_FILE" ]; then
    echo "Error: Rules file not found: $RULES_FILE"
    exit 1
fi

# 禁止ワードをJSONファイルから読み込んで検査
STOP_WORDS=$(cat "$RULES_FILE" | grep -o '"[^"]*"' | sed 's/"//g')

for word in $STOP_WORDS; do
    if echo "$MESSAGE_CONTENT" | grep -q "$word"; then
        echo "Error: 禁止ワード「$word」が検出されました。"
        echo "メッセージを修正してください。"
        exit 1
    fi
done

echo "メッセージは禁止ワードチェックを通過しました。"
exit 0