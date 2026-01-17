---
name: create-annotated-tf
description: Terraform AWS Providerのリソースに対する解説付きサンプルテンプレートを生成するスキル。ユーザーがTerraformリソース名（例：aws_s3_bucket, aws_lambda_function）を指定した際に、全プロパティの詳細解説・AWS公式ドキュメントリンク付きのテンプレートを出力する。出力先は ${プロジェクトルート}/terraform-template/${リソース名}.tf
---

# Terraform AWS Resource Template Generator

AWS Providerのリソースに対し、全プロパティ網羅・解説付きのサンプルテンプレートを生成する。

## 重要な原則

**スキーマが信頼の源泉（Source of Truth）**

`terraform providers schema -json` から取得したスキーマを正とする。MCPツールのドキュメントはスキーマに含まれない補足情報（説明文、設定可能な値の詳細等）の取得に使用する。

## ワークフロー

### 1. 入力の確認

ユーザーから以下を取得:
- **リソース名** (必須): `aws_cloudwatch_log_group` など
- **AWS Providerバージョン** (任意): 指定がなければ最新バージョンを使用

バージョン未指定時は Terraform Registry API から最新バージョンを取得:
```bash
curl -s "https://registry.terraform.io/v1/providers/hashicorp/aws" | jq -r '.version'
```

### 2. スキーマの存在確認と取得

`${プロジェクトルート}/tmp/${provider_version}/schema.json` が既に存在するか確認:

```bash
SCHEMA_FILE="${PROJECT_ROOT}/tmp/${provider_version}/schema.json"
if [[ -f "$SCHEMA_FILE" ]]; then
  echo "✅ スキーマファイルが存在します。スキップします。"
else
  echo "📥 スキーマを取得します..."
  # 以下のステップ2a, 2bを実行
fi
```

#### 2a. スキーマ取得用Terraform設定の作成（スキーマが存在しない場合のみ）

`${プロジェクトルート}/tmp/${provider_version}/` ディレクトリにプロバイダー設定を作成:

```hcl
# ${プロジェクトルート}/tmp/${provider_version}/providers.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "{provider_version}"
    }
  }
}
```

注: `tmp/` は `.gitignore` に追加済み

#### 2b. プロバイダースキーマの取得（スキーマが存在しない場合のみ）

```bash
cd ${プロジェクトルート}/tmp/${provider_version}
terraform init
terraform providers schema -json > schema.json
```

### 3. スキーマからリソース情報を抽出

スキーマJSONから対象リソースの情報を抽出:

```bash
jq '.provider_schemas["registry.terraform.io/hashicorp/aws"].resource_schemas["{リソース名}"]' schema.json
```

抽出対象:
- `.block.attributes` - 通常の属性
- `.block.block_types` - ネストブロック（vpc_config等）

### 4. 属性の分類

スキーマの各属性を以下のルールで分類:

**テンプレートに含める属性（入力可能）:**
- `optional: true` を持つ属性

**テンプレートから除外する属性（computed only）:**
- `computed: true` かつ `optional` がない属性
- 例: `arn`, `id`, `tags_all`

分類確認コマンド:
```bash
# 入力可能な属性一覧
jq -r '.block.attributes | to_entries[] | select(.value.optional == true) | .key' <<< "$SCHEMA"

# computed only属性一覧
jq -r '.block.attributes | to_entries[] | select(.value.computed == true and .value.optional != true) | .key' <<< "$SCHEMA"
```

### 5. ドキュメント情報の取得

`SearchAwsProviderDocs` MCPツールで補足情報を取得:

```
SearchAwsProviderDocs(asset_name="{リソース名}", asset_type="resource")
```

注: MCPツールのドキュメントに含まれない属性がスキーマに存在する場合がある。その場合はAWS公式ドキュメントを検索して補完する。

### 6. AWS公式ドキュメントの補完

`aws___search_documentation` および `aws___read_documentation` MCPツールを使用:

```
aws___search_documentation(search_phrase="{関連キーワード}", topics=["general"])
aws___read_documentation(url="{ドキュメントURL}")
```

### 7. テンプレート生成

[references/template_example.md](references/template_example.md) のフォーマットに従いテンプレートを生成。

**必須要件:**
- スキーマから取得した入力可能な全属性を記載
- ネストブロック（block_types）も漏れなく記載
- 各プロパティにコメントで解説を記載
- AWS公式ドキュメントのURLは実在するもののみ記載
- 推測や誤った情報は絶対に記載しない
- ファイルヘッダーに以下の情報を含める:
  - テンプレート生成日（ISO 8601形式: YYYY-MM-DD）
  - Provider version
  - 注意書き: 生成時点の情報であることと、最新の仕様は公式ドキュメントを確認すべきことを明記

### 8. 抜け漏れ検証

スキーマの属性一覧と生成したテンプレートを照合:

```bash
# スキーマの入力可能属性一覧
jq -r '.provider_schemas["registry.terraform.io/hashicorp/aws"].resource_schemas["{リソース名}"].block.attributes | to_entries[] | select(.value.optional == true) | .key' schema.json | sort

# テンプレートに含まれる属性一覧
grep -E "^\s{2}[a-z_]+ =" {リソース名}.tf | sed 's/=.*//' | tr -d ' ' | sort
```

両者を比較し、差分がないことを確認。

### 9. ファイル出力

出力先: `${プロジェクトルート}/terraform-template/${リソース名}.tf`

例: `./terraform-template/aws_cloudwatch_log_group.tf`

## 品質要件

1. **正確性**: スキーマを信頼の源泉とし、MCPサーバーは補足情報として使用
2. **網羅性**: スキーマの全入力可能属性（attributes + block_types）を記載
3. **検証可能性**: 記載するURLは全て実在するものであること
4. **除外の明確性**: computed only属性は明確な基準で除外
