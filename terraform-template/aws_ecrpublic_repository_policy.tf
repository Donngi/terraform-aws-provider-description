#---------------------------------------------------------------
# AWS ECR Public Repository Policy
#---------------------------------------------------------------
#
# Amazon Elastic Container Registry (ECR) Publicのリポジトリポリシーを
# プロビジョニングするリソースです。リポジトリポリシーは、誰が
# パブリックリポジトリのイメージにアクセスできるかを制御します。
#
# 重要:
#   - このリソースは us-east-1 リージョンでのみ使用可能です。
#   - 現在、1つのリポジトリに対して1つのポリシーのみ適用できます。
#
# AWS公式ドキュメント:
#   - ECR Public概要: https://docs.aws.amazon.com/AmazonECR/latest/public/what-is-ecr.html
#   - リポジトリポリシー: https://docs.aws.amazon.com/AmazonECR/latest/public/public-repository-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecrpublic_repository_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecrpublic_repository_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # repository_name (Required)
  # 設定内容: ポリシーを適用するリポジトリの名前を指定します。
  # 設定可能な値: 既存のECR Publicリポジトリ名
  # 関連機能: aws_ecrpublic_repository リソースと組み合わせて使用
  # 注意: 作成後の変更はリソースの再作成を伴います。
  repository_name = "my-public-repo"

  # policy (Required)
  # 設定内容: リポジトリに適用するポリシードキュメントを指定します。
  # 設定可能な値: JSON形式のIAMポリシードキュメント文字列
  # 関連機能: IAMポリシードキュメント
  #   - Terraformでのポリシードキュメント作成: https://learn.hashicorp.com/terraform/aws/iam-policy
  #   - aws_iam_policy_document データソースを使用すると、型安全なポリシー定義が可能です。
  # 用途:
  #   - 特定のAWSアカウントにイメージへのアクセス権限を付与
  #   - イメージのプル/プッシュ権限の制御
  #   - リポジトリの管理権限の制御
  # 例1: JSON文字列で直接指定
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "AllowPull"
  #       Effect = "Allow"
  #       Principal = {
  #         AWS = "arn:aws:iam::123456789012:root"
  #       }
  #       Action = [
  #         "ecr:GetDownloadUrlForLayer",
  #         "ecr:BatchGetImage",
  #         "ecr:BatchCheckLayerAvailability"
  #       ]
  #     }
  #   ]
  # })
  #
  # 例2: aws_iam_policy_document データソースを使用（推奨）
  policy = data.aws_iam_policy_document.ecr_policy.json

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: us-east-1（このリソースは us-east-1 でのみ利用可能）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 重要: ECR Publicはus-east-1リージョンでのみ利用可能なため、必ずus-east-1を指定してください。
  region = "us-east-1"
}

#---------------------------------------------------------------
# IAMポリシードキュメント例（data sourceとして定義）
#---------------------------------------------------------------
# aws_iam_policy_document データソースを使用してポリシーを定義する例です。
# この方法を使用すると、型安全で読みやすいポリシー定義が可能になります。

data "aws_iam_policy_document" "ecr_policy" {
  # ステートメント1: 特定のAWSアカウントにプル権限を付与
  statement {
    sid    = "AllowPull"
    effect = "Allow"

    principals {
      type = "AWS"
      # 設定可能な値:
      #   - AWSアカウントID: "123456789012"
      #   - ARN形式: "arn:aws:iam::123456789012:root"
      #   - 特定のIAMユーザー: "arn:aws:iam::123456789012:user/username"
      #   - 特定のIAMロール: "arn:aws:iam::123456789012:role/rolename"
      identifiers = ["123456789012"]
    }

    # イメージのダウンロードに必要な権限
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }

  # ステートメント2: 特定のアカウントに完全な管理権限を付与（オプション）
  # 注意: 本番環境では必要最小限の権限のみを付与してください
  statement {
    sid    = "AllowFullAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:root"]
    }

    # リポジトリの完全な管理権限
    # 注意: これらの権限は強力なため、慎重に付与してください
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

#---------------------------------------------------------------
# 一般的なECRアクション一覧（参考）
#---------------------------------------------------------------
# イメージのプル（読み取り）に必要なアクション:
#   - ecr:GetDownloadUrlForLayer
#   - ecr:BatchGetImage
#   - ecr:BatchCheckLayerAvailability
#   - ecr:DescribeRepositories (オプション)
#   - ecr:ListImages (オプション)
#
# イメージのプッシュ（書き込み）に必要なアクション:
#   - ecr:PutImage
#   - ecr:InitiateLayerUpload
#   - ecr:UploadLayerPart
#   - ecr:CompleteLayerUpload
#   - ecr:BatchCheckLayerAvailability
#
# リポジトリポリシーの管理に必要なアクション:
#   - ecr:GetRepositoryPolicy
#   - ecr:SetRepositoryPolicy
#   - ecr:DeleteRepositoryPolicy
#
# イメージの削除に必要なアクション:
#   - ecr:BatchDeleteImage
#
# リポジトリの削除に必要なアクション:
#   - ecr:DeleteRepository
#---------------------------------------------------------------

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リポジトリ名（repository_nameと同じ値）
#
# - registry_id: リポジトリが作成されたレジストリのID
#        AWSアカウントIDと同じ値になります
#
# - repository_name: ポリシーが適用されているリポジトリの名前
#
# - policy: 適用されているポリシードキュメント（JSON文字列）
#
# - region: リソースが管理されているリージョン
#        ECR Publicの場合は常に us-east-1
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_ecrpublic_repository" "example" {
#   repository_name = "my-public-repo"
#   region          = "us-east-1"
# }
#
# resource "aws_ecrpublic_repository_policy" "example" {
#---------------------------------------------------------------
