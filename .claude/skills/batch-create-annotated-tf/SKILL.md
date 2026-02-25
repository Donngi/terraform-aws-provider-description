---
name: batch-create-annotated-tf
description: AWS Providerのバージョン差分を自動検出し、変更があったTerraformリソースに対して解説付きテンプレートを一括生成するスキル。前回処理バージョンとの差分のみを処理する。
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Task, Skill
---

# Batch Create Annotated Terraform Templates

AWS Providerバージョン差分を自動検出し、変更リソースのみ解説付きテンプレートを一括生成。

## 制約事項

### 絶対禁止
- **WebSearch / WebFetch** - 使用禁止
- エラー時もWeb検索にフォールバックしない

### サブエージェントの動作
- サブエージェント（`/terraform-aws-annotated-reference`）はWriteツールを使用可能
- 生成されたテンプレートは直接 `terraform-template/` に書き込まれる

## 処理フロー

```
1. 最新バージョン取得      → lib/01_fetch_latest_version.sh
2. 前回バージョン読込み    → lib/02_load_last_version.sh
3. バージョン比較（同一なら終了）
4. スキーマ準備            → lib/03_prepare_schema.sh
5. 差分検出                → lib/04_detect_changes.sh
6. テンプレート生成処理実行  → Task tool（同期実行）
   成功時: append_completed_resource.sh でチェックポイント更新
7. 削除リソースアーカイブ  → lib/05_archive_removed.sh
8. バージョンファイル更新  → lib/06_update_version_file.sh
9. 変更ログ生成            → lib/07_generate_changelog.sh
```

## テンプレート生成処理仕様

| 項目 | 値 |
|------|-----|
| 並列度 | 8 |
| run_in_background | false（同期実行） |

### 状態管理ファイル

```
.local/{version}/completed_resources.txt  # 処理済みリソース（1行1リソース）
.local/{version}/failed_resources.json    # 失敗リソース
```

## 実行フロー

### 再開処理

```
# completed_resources.txt が存在する場合、その内容を読み込み
# 処理対象から除外する
if completed_resources.txt exists:
    completed = completed_resources.txtから読み込み
    changed_resources = changed_resources - completed
```

### メインループ

```
# 処理対象リソースの準備
changed_resources = (added + changed) - completed_resources

# 進捗初期化
total = length(changed_resources)

# リソースを1つずつ処理
for i, resource in enumerate(changed_resources):
    # 進捗表示
    print "⏳ Processing {resource} ({i+1}/{total})..."

    # Task実行（同期実行）
    result = Task(
        subagent_type="general-purpose",
        description="Generate {resource} template",
        prompt="/terraform-aws-annotated-reference {resource} provider_version={version} output_dir=terraform-template

ツール使用ルール（厳守）:
- ファイルの作成・編集は必ずWriteツールまたはEditツールを使用すること
- Bashでのリダイレクト（>, >>）、tee、heredocによるファイル書き込みは禁止（フックでブロックされる）
- Bashツールの使用は以下の用途のみに限定:
  - terraform init / terraform providers schema -json > schema.json
  - jq（スキーマJSON解析）
  - bash validate_template.sh（テンプレート検証）
  - grep, wc, sort等の読み取り専用コマンド
- Python, node, npm, npxの実行は禁止（設定でブロック済み）
- WebSearch / WebFetchは使用禁止
- 必要な情報は全てプロバイダースキーマとMCPサーバーから取得してください
- ユーザーに確認を求めずに作業を完了してください

フォーマット厳守事項:
- 全コメントは日本語で記述（英語コメント禁止）
- 区切り線は #------- のみ使用（==== 禁止）
- プロパティコメントには 設定内容: / 設定可能な値: / 省略時: プレフィックスを使用（Description: / Valid values: / Default: 禁止）
- 機能カテゴリ別グルーピング（Required/Optionalグルーピング禁止）
- Attributes Referenceは25行以内、コード例禁止
- 使用例・ベストプラクティスセクション禁止

生成後の検証:
- 生成完了後に以下を実行し、全項目PASSになるまで修正を繰り返すこと:
  bash .claude/skills/terraform-aws-annotated-reference/lib/validate_template.sh <出力ファイル> <リソース名> <スキーマファイル>",
        max_turns=50,
        run_in_background=false
    )

    # チェックポイント更新（成功時のみ）
    # WriteツールやBashリダイレクト（>>）は使用禁止 → 必ずこのスクリプトを使うこと
    if result.success:
        Bash("bash .claude/skills/batch-create-annotated-tf/lib/append_completed_resource.sh {version} {resource}")
    else:
        # 失敗リソースとして記録
```

## サブエージェント呼び出し

### Task起動

```
Task(
    subagent_type="general-purpose",
    description="Generate {resource} template",
    prompt="/terraform-aws-annotated-reference {resource} provider_version={version} output_dir=terraform-template

ツール使用ルール（厳守）:
- ファイルの作成・編集は必ずWriteツールまたはEditツールを使用すること
- Bashでのリダイレクト（>, >>）、tee、heredocによるファイル書き込みは禁止（フックでブロックされる）
- Bashツールの使用は以下の用途のみに限定:
  - terraform init / terraform providers schema -json > schema.json
  - jq（スキーマJSON解析）
  - bash validate_template.sh（テンプレート検証）
  - grep, wc, sort等の読み取り専用コマンド
- Python, node, npm, npxの実行は禁止（設定でブロック済み）
- WebSearch / WebFetchは使用禁止
- 必要な情報は全てプロバイダースキーマとMCPサーバーから取得してください
- ユーザーに確認を求めずに作業を完了してください

フォーマット厳守事項:
- 全コメントは日本語で記述（英語コメント禁止）
- 区切り線は #------- のみ使用（==== 禁止）
- プロパティコメントには 設定内容: / 設定可能な値: / 省略時: プレフィックスを使用（Description: / Valid values: / Default: 禁止）
- 機能カテゴリ別グルーピング（Required/Optionalグルーピング禁止）
- Attributes Referenceは25行以内、コード例禁止
- 使用例・ベストプラクティスセクション禁止

生成後の検証:
- 生成完了後に以下を実行し、全項目PASSになるまで修正を繰り返すこと:
  bash .claude/skills/terraform-aws-annotated-reference/lib/validate_template.sh <出力ファイル> <リソース名> <スキーマファイル>",
        max_turns=50,
        run_in_background=false
)
```

## サブエージェント完了後のチェックポイント更新

Task実行が成功したら、**必ずこのコマンドでチェックポイントを更新すること**：

```bash
bash .claude/skills/batch-create-annotated-tf/lib/append_completed_resource.sh {version} {resource}
```

- Write ツールや Bash リダイレクト（`>>`）で直接書き込まない
- 重複チェック済みなので同一リソースを複数回呼んでも安全

## エラー理由

| 理由 | 説明 |
|------|------|
| success | 成功 |
| subagent_error | サブエージェント実行時のエラー |

## ファイル構成

```
プロジェクトルート/
├── processed_provider_version.json      # バージョン管理
├── .claude/skills/batch-create-annotated-tf/
│   ├── SKILL.md
│   └── lib/
│       ├── 01_fetch_latest_version.sh
│       ├── 02_load_last_version.sh
│       ├── 03_prepare_schema.sh
│       ├── 04_detect_changes.sh
│       ├── 05_archive_removed.sh
│       ├── 06_update_version_file.sh
│       └── 07_generate_changelog.sh
├── .local/
│   ├── {version}/
│   │   ├── schema.json                  # Provider schema
│   │   ├── completed_resources.txt      # 処理済みリソース
│   │   └── failed_resources.json        # 失敗リソース
└── terraform-template/
    ├── {resource}.tf                    # 最終出力
    └── archived/
```

## 処理結果サマリー

全バッチ完了後に報告:

```
📊 Processing Summary:
  Total: {total_count}
  Succeeded: {success_count}
  Failed: {failed_count}
```

失敗リソースは `.local/{version}/failed_resources.json` に記録。

## 注意事項

- **差分のみ処理**: 変更があったリソースのみ
- **初回実行**: 全リソースを処理
- **エラー継続**: 失敗しても他リソースは処理継続
- **並列実行**: 5リソースずつ並列処理
- **チェックポイント**: 各リソース完了時に `bash .claude/skills/batch-create-annotated-tf/lib/append_completed_resource.sh {version} {resource}` で記録（Write ツール・リダイレクト禁止）
- **中断・再開**: completed_resources.txtで進捗を維持
