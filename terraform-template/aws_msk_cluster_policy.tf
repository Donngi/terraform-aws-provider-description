#---------------------------------------------------------------
# AWS MSK Cluster Policy
#---------------------------------------------------------------
#
# Amazon Managed Streaming for Apache Kafka (MSK) クラスターに対して
# リソースベースのポリシーを管理するリソースです。
# クラスターポリシーを使用すると、他のAWSアカウントやIAMプリンシパルに対して
# MSKクラスターへのアクセス権限をリソースベースポリシーで付与できます。
# クロスアカウントアクセスや、特定のKafka操作へのアクセス制御に使用します。
#
# 注意: MSKクラスターポリシーは、Apache Kafka ACLとは異なる仕組みです。
#       IAMを使用したアクセス制御を行う場合に使用します。
#
# AWS公式ドキュメント:
#   - MSKクラスターポリシー: https://docs.aws.amazon.com/msk/latest/developerguide/security_iam_resource-based-policy-examples.html
#   - MSKのIAMアクセスコントロール: https://docs.aws.amazon.com/msk/latest/developerguide/iam-access-control.html
#   - クロスアカウントアクセス: https://docs.aws.amazon.com/msk/latest/developerguide/cross-account-access.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_cluster_policy" "example" {
  #-------------------------------------------------------------
  # クラスター識別設定
  #-------------------------------------------------------------

  # cluster_arn (Required)
  # 設定内容: ポリシーを適用するMSKクラスターのARNを指定します。
  # 設定可能な値: 有効なMSKクラスターのARN文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  cluster_arn = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/example-cluster/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-x"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: MSKクラスターに適用するリソースベースのIAMポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメントのJSON文字列
  # 注意: jsonencode()関数を使用してTerraformのマップ構造からJSON文字列に変換できます。
  #       ポリシーで指定できるアクション例:
  #         - kafka:Describe*: クラスターの詳細情報の参照
  #         - kafka:Get*: クラスター情報の取得
  #         - kafka:CreateVpcConnection: VPC接続の作成
  #         - kafka:GetBootstrapBrokers: ブートストラップブローカーの取得
  #         - kafka:ListClusters: クラスター一覧の取得
  # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/security_iam_id-based-policy-examples.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ExampleMskClusterPolicy"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "kafka:Describe*",
          "kafka:Get*",
          "kafka:CreateVpcConnection",
          "kafka:GetBootstrapBrokers",
        ]
        Resource = "arn:aws:kafka:ap-northeast-1:123456789012:cluster/example-cluster/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-x"
      }
    ]
  })

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: クラスターのARN（cluster_arnと同じ値）
#
# - current_version: クラスターポリシーの現在のバージョン。
#   ポリシーの更新時に楽観的ロック制御に使用されます。
#---------------------------------------------------------------
