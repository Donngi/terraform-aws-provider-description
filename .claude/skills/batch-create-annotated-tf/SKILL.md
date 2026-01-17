---
name: batch-create-annotated-tf
description: target_resources.txt に記載された複数のTerraformリソースに対し、解説付きテンプレートを一括生成するスキル。内部で create-annotated-tf skill を繰り返し呼び出す。
---

# Batch Create Annotated Terraform Templates

`target_resources.txt` に記載された複数のAWSリソースに対し、解説付きテンプレートを**並列で**一括生成する。

## ワークフロー

### 1. リソースリストの読み込み

`${プロジェクトルート}/target_resources.txt` を読み込む。

**ファイルフォーマット:**
```
# コメント行（#で始まる行は無視）
aws_s3_bucket
aws_lambda_function
aws_iam_role
```

- 1行に1リソース名
- 空行は無視
- `#` で始まる行はコメントとして無視

### 2. AWS Providerバージョンの決定とスキーマ準備

バージョン指定がない場合は、Terraform Registry API から最新バージョンを取得:

```bash
curl -s "https://registry.terraform.io/v1/providers/hashicorp/aws" | jq -r '.version'
```

スキーマが未取得の場合は、`tmp/${provider_version}/` で `terraform init` と `terraform providers schema -json` を実行してスキーマを準備する。

### 3. 並列処理の実行（重要）

**Task tool を使用して全リソースを並列処理する。**

1つのメッセージ内で、リソース数分の Task tool 呼び出しを同時に行う:

```
# 例: 3リソースの場合、1つのメッセージで3つのTask呼び出しを並列実行

Task(
  subagent_type="general-purpose",
  description="Generate aws_s3_bucket template",
  prompt="Execute /create-annotated-tf aws_s3_bucket with provider version {version}. Output to terraform-template/aws_s3_bucket.tf"
)

Task(
  subagent_type="general-purpose",
  description="Generate aws_lambda_function template",
  prompt="Execute /create-annotated-tf aws_lambda_function with provider version {version}. Output to terraform-template/aws_lambda_function.tf"
)

Task(
  subagent_type="general-purpose",
  description="Generate aws_iam_role template",
  prompt="Execute /create-annotated-tf aws_iam_role with provider version {version}. Output to terraform-template/aws_iam_role.tf"
)
```

**並列実行のポイント:**
- 全てのTask呼び出しを**1つのレスポンス内**で行うこと
- これにより各エージェントが同時に起動し、並列処理される
- 各エージェントは独立してスキーマ解析・ドキュメント取得・テンプレート生成を行う

### 4. Task プロンプトのテンプレート

各 Task に渡すプロンプト:

```
あなたは Terraform テンプレート生成エージェントです。

## タスク
リソース「{resource_name}」の解説付きテンプレートを生成してください。

## 手順
1. /create-annotated-tf skill を実行: Skill(skill="create-annotated-tf", args="{resource_name}")
2. skill の指示に従ってテンプレートを生成
3. 出力先: ${プロジェクトルート}/terraform-template/{resource_name}.tf

## 制約
- Provider Version: {provider_version}
- スキーマファイル: ${プロジェクトルート}/tmp/{provider_version}/schema.json（存在する場合は再利用）
- 品質要件に従い、全属性を網羅すること

完了したら、生成したファイルパスと処理結果（成功/失敗）を報告してください。
```

### 5. 結果の収集

全ての Task が完了したら、各エージェントの結果を収集:

- 成功: 生成されたファイルパスを記録
- 失敗: エラー内容を記録

### 6. 結果サマリーの出力

全リソースの処理完了後、以下の形式でサマリーを出力:

```
## 処理結果サマリー

Provider Version: 6.x.x
処理対象: N リソース
実行方式: 並列処理

### 成功 (M件)
- aws_s3_bucket → terraform-template/aws_s3_bucket.tf
- aws_lambda_function → terraform-template/aws_lambda_function.tf

### 失敗 (K件)
- aws_xxx: エラー理由
```

## 使用例

```bash
# target_resources.txt を準備
echo "aws_s3_bucket
aws_lambda_function
aws_iam_role" > target_resources.txt

# skillを実行（並列処理）
/batch-create-annotated-tf
```

## 並列処理の利点

| 方式 | 3リソースの場合 | 10リソースの場合 |
|------|-----------------|------------------|
| 直列処理 | 約15分 | 約50分 |
| **並列処理** | **約5分** | **約5-10分** |

※ 時間は目安。並列処理により、リソース数が増えても処理時間の増加が緩やかになる。

## 注意事項

- 並列実行のため、一時的にリソース使用量が増加する
- エラーが発生しても他のリソースの処理は継続される
- 既存ファイルは上書きされる
- スキーマファイルは共有されるため、最初に準備しておくと効率的
