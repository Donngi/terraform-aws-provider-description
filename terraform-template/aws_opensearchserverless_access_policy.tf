#---------------------------------------------------------------
# Amazon OpenSearch Serverless Access Policy
#---------------------------------------------------------------
#
# Amazon OpenSearch Serverlessのデータアクセスポリシーをプロビジョニングするリソースです。
# アクセスポリシーはコレクションおよびインデックスへのデータアクセスを制御し、
# IAMロールやSAMLアイデンティティに対してOpenSearch API操作の権限を付与します。
# IAMポリシーとは独立して機能し、データ操作レベルのアクセス制御を提供します。
#
# AWS公式ドキュメント:
#   - データアクセスコントロール: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-data-access.html
#   - セキュリティ概要: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-security.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_access_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearchserverless_access_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アクセスポリシーの名前を指定します。
  # 設定可能な値: 3〜32文字の小文字英数字またはハイフン（パターン: [a-z][a-z0-9-]+）
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_AccessPolicyDetail.html
  name = "example-access-policy"

  # type (Required)
  # 設定内容: アクセスポリシーのタイプを指定します。
  # 設定可能な値:
  #   - "data": データアクセスポリシー（現在このタイプのみサポート）
  type = "data"

  # description (Optional)
  # 設定内容: ポリシーの説明を指定します。主にポリシーで定義されたアクセス権限の
  #           説明を格納するために使用します。
  # 設定可能な値: 0〜1000文字の文字列
  # 省略時: 説明なし
  description = "コレクションおよびインデックスへの読み書き権限を付与するポリシー"

  #-------------------------------------------------------------
  # ポリシードキュメント設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: アクセスポリシーのコンテンツとして使用するJSONポリシードキュメントを指定します。
  #           ポリシーはルールの配列で構成され、各ルールにリソースタイプ・リソース・
  #           権限・プリンシパルを定義します。
  # 設定可能な値: 有効なJSONポリシードキュメント文字列
  #   ルールの構成要素:
  #   - ResourceType: "collection" または "index"
  #   - Resource: リソース名またはワイルドカードパターン
  #     - コレクション: "collection/<名前>" または "collection/*"
  #     - インデックス: "index/<コレクション名>/<インデックス名>" または "index/<コレクション名>/*"
  #   - Permission: 付与するaoss:* 形式の権限リスト
  #     - コレクション権限例: "aoss:CreateCollectionItems", "aoss:DescribeCollectionItems", "aoss:DeleteCollectionItems"
  #     - インデックス権限例: "aoss:ReadDocument", "aoss:WriteDocument", "aoss:DescribeIndex", "aoss:CreateIndex", "aoss:DeleteIndex"
  #     - すべての権限: "aoss:*"
  #   - Principal: IAMロールARN、IAMユーザーARN、またはSAMLアイデンティティ
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-data-access.html#serverless-data-supported-permissions
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/example-collection/*"
          ]
          Permission = [
            "aoss:*"
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/example-collection"
          ]
          Permission = [
            "aoss:*"
          ]
        }
      ]
      Principal = [
        "arn:aws:iam::123456789012:role/example-role"
      ]
    }
  ])

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーの識別子
# - policy_version: ポリシーのバージョン文字列（20〜36文字）
#---------------------------------------------------------------
