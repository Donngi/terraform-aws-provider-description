#---------------------------------------------------------------
# AWS Secrets Manager Secret Policy
#---------------------------------------------------------------
#
# AWS Secrets Managerのシークレットにリソースベースのポリシーを
# アタッチするためのリソースです。
# リソースベースポリシーにより、他のAWSアカウントやサービスがシークレットに
# アクセスできるようになります。
#
# AWS公式ドキュメント:
#   - Secrets Manager リソースベースポリシー: https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_resource-based-policies.html
#   - PutResourcePolicy API: https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_PutResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_secretsmanager_secret_policy" "example" {
  #-------------------------------------------------------------
  # シークレットARN設定
  #-------------------------------------------------------------

  # secret_arn (Required)
  # 設定内容: ポリシーを関連付けるSecrets ManagerのシークレットARNを指定します。
  # 設定可能な値: 有効なSecrets Manager シークレットのARN
  # 関連機能: AWS Secrets Manager
  #   Secrets Managerは、データベース認証情報、APIキー、その他のシークレットを
  #   安全に管理し、自動的にローテーションできるサービスです。
  #   リソースベースポリシーにより、他のアカウントやサービスからの
  #   シークレットアクセスを許可できます。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
  secret_arn = aws_secretsmanager_secret.example.arn

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: シークレットにアタッチするJSON形式のIAMポリシーを指定します。
  # 設定可能な値: 有効なJSON形式のIAMポリシードキュメント
  # 関連機能: Secrets Manager リソースベースポリシー
  #   リソースベースポリシーにより、以下のようなアクセス制御が可能です:
  #   - クロスアカウントでのシークレット読み取り許可
  #   - 特定のIAMロールやユーザーへのアクセス権限付与
  #   - AWS Organizations内のアカウントへのアクセス許可
  #   - サービスプリンシパルへのアクセス許可（Lambda、ECS等）
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_resource-based-policies.html
  # 注意: aws_secretsmanager_secretリソースとは異なり、空のポリシー"{}"を
  #       設定することはできません。policyは必須であり、有効なポリシーが必要です。
  # ポリシー検証設定
  #-------------------------------------------------------------

  # block_public_policy (Optional)
  # 設定内容: Zelkovaを使用してリソースポリシーを検証し、シークレットへの
  #           広範なアクセスを防ぎます。
  # 設定可能な値: true または false
  # 省略時: false（検証を実行しない）
  # 関連機能: ポリシー検証
  #   Zelkovaは、AWSのポリシー検証エンジンで、パブリックアクセスを許可する
  #   可能性のあるポリシーを検出します。trueに設定すると、パブリックアクセスを
  #   許可するポリシーがブロックされます。
  #   セキュリティ上の理由から、本番環境ではtrueに設定することを推奨します。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/userguide/block-public-policy.html
  block_public_policy = true

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
# IAMポリシードキュメントの例
#---------------------------------------------------------------
# 以下は、シークレットへのアクセスを許可するポリシーの例です。
# 実際の使用時は、適切なアカウントID、ARN、アクションを指定してください。
#---------------------------------------------------------------

data "aws_iam_policy_document" "example" {
  # ステートメント1: 他のAWSアカウントにシークレットの読み取りを許可
  statement {
    sid    = "EnableAnotherAWSAccountToReadTheSecret"
    effect = "Allow"

    principals {
      type = "AWS"
      # 例: 別のAWSアカウントのrootユーザーにアクセスを許可
      identifiers = ["arn:aws:iam::123456789012:root"]
    }

    # シークレット値の取得を許可
    actions = ["secretsmanager:GetSecretValue"]

    # このシークレットに対してのみアクセスを許可
    resources = ["*"]
  }

  # ステートメント2: 特定のIAMロールにシークレットの説明情報取得を許可（オプション）
  statement {
    sid    = "AllowRoleToDescribeSecret"
    effect = "Allow"

    principals {
      type = "AWS"
      # 例: 特定のIAMロールにアクセスを許可
      identifiers = ["arn:aws:iam::123456789012:role/MyApplicationRole"]
    }

    # シークレットのメタデータ取得を許可
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy"
    ]

    resources = ["*"]
  }
}

#---------------------------------------------------------------
# Secrets Managerシークレットの例
#---------------------------------------------------------------
# ポリシーをアタッチするシークレットの定義例
#---------------------------------------------------------------

resource "aws_secretsmanager_secret" "example" {
  name        = "example-secret"
  description = "Example secret with resource-based policy"

  # シークレットのローテーション設定（オプション）
  # rotation_lambda_arn = aws_lambda_function.rotation.arn
  # rotation_rules {
  #   automatically_after_days = 30
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: シークレットのAmazon Resource Name (ARN)
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# ユースケース例
#---------------------------------------------------------------
#
# 1. クロスアカウントアクセス:
#    - 開発環境から本番環境のシークレットへのアクセス許可
#    - パートナーアカウントへのAPIキー共有
#
# 2. サービスプリンシパルへのアクセス許可:
#    - Lambda関数がシークレットを読み取る
#    - ECSタスクがデータベース認証情報にアクセス
#
# 3. AWS Organizations統合:
#    - 組織内の全アカウントにシークレットへのアクセスを許可
#
# 4. セキュリティ制御:
#---------------------------------------------------------------
