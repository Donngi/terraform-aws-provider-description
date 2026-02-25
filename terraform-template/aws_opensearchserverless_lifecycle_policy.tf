#---------------------------------------------------------------
# AWS OpenSearch Serverless Lifecycle Policy
#---------------------------------------------------------------
#
# Amazon OpenSearch Serverlessのライフサイクルポリシーをプロビジョニングするリソースです。
# ライフサイクルポリシーはインデックスの保持期間ルールを定義し、
# コレクション内のインデックスデータの自動管理を可能にします。
# 現在サポートされているポリシータイプは「retention」（保持）のみです。
#
# AWS公式ドキュメント:
#   - OpenSearch Serverless ライフサイクルポリシー: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-lifecycle.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_lifecycle_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearchserverless_lifecycle_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ライフサイクルポリシーの名前を指定します。
  # 設定可能な値: 3〜32文字の小文字英数字またはハイフン。先頭は英字
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-lifecycle.html
  name = "example-lifecycle-policy"

  # type (Required)
  # 設定内容: ライフサイクルポリシーのタイプを指定します。
  # 設定可能な値:
  #   - "retention": インデックスの保持期間を定義するポリシー（現在唯一サポートされているタイプ）
  type = "retention"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: ライフサイクルポリシーの内容をJSON形式で指定します。
  # 設定可能な値: JSON文字列。Rules配列に以下のルールを定義:
  #   - ResourceType: 対象リソースタイプ（"index" のみ）
  #   - Resource: 対象インデックスのパターン（"index/{collection}/{index}" 形式）
  #   - MinIndexRetention: インデックスの最小保持期間（例: "30d", "24h"）
  #   - NoMinIndexRetention: true の場合、最小保持期間なしでインデックスを削除可能にする
  # 注意: MinIndexRetention と NoMinIndexRetention はどちらか一方のみ指定可能
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-lifecycle.html
  policy = jsonencode({
    "Rules" : [
      {
        "ResourceType" : "index",
        "Resource" : ["index/my-collection/*"],
        "MinIndexRetention" : "30d"
      }
    ]
  })

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ライフサイクルポリシーの説明を指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明なし
  description = "インデックスの保持期間を管理するライフサイクルポリシー"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
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
# - id: ライフサイクルポリシーの識別子（name と type の組み合わせ）
#
# - policy_version: ライフサイクルポリシーのバージョン文字列
#---------------------------------------------------------------
