#---------------------------------------
# AWS ECR Repository Policy
#---------------------------------------
# Amazon ECRリポジトリに対するアクセス制御ポリシーを設定するリソース
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# 【主な用途】
# - 他のAWSアカウントへのイメージ共有
# - AWS CodeBuildなどのサービスへのアクセス許可
# - 特定のIPアドレスからのアクセス制限
# - IAMユーザー・ロールへの詳細な権限設定
#
# 【重要な注意事項】
# - 1つのリポジトリに設定できるポリシーは1つのみ
# - ポリシーとIAMポリシーは併用され、両方で許可が必要
# - ecr:GetAuthorizationTokenは別途IAMポリシーで許可が必要
# - パブリックリポジトリへのアクセス拒否ポリシーは未サポート
#
# 【ベストプラクティス】
# - aws_iam_policy_documentデータソースでポリシーを定義
# - 最小権限の原則に従い必要最小限のアクションを許可
# - クロスアカウントアクセスではConditionでaws:SourceArnを制限
# - IPアドレス制限にはConditionでaws:SourceIpを使用
#
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマから自動生成されています
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ecr_repository_policy

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_ecr_repository_policy" "example" {
  # repository: ポリシーを適用するリポジトリ名
  # 設定内容: ECRリポジトリの名前を指定
  # 設定可能な値: 既存のECRリポジトリ名（aws_ecr_repository.name参照を推奨）
  # 補足: リポジトリ削除時にポリシーも自動削除される
  repository = "my-repository"

  # policy: リポジトリポリシードキュメント
  # 設定内容: JSON形式のIAMポリシードキュメント
  # 設定可能な値: IAMポリシーJSON（aws_iam_policy_document.jsonの使用を推奨）
  # 補足: Principal、Action、Effectを含む標準IAMポリシー形式
  # 一般的なアクション:
  #   - ecr:GetDownloadUrlForLayer: レイヤーダウンロード
  #   - ecr:BatchGetImage: イメージ取得
  #   - ecr:BatchCheckLayerAvailability: レイヤー存在確認
  #   - ecr:PutImage: イメージプッシュ
  #   - ecr:InitiateLayerUpload: レイヤーアップロード開始
  #   - ecr:UploadLayerPart: レイヤー部分アップロード
  #   - ecr:CompleteLayerUpload: レイヤーアップロード完了
  #   - ecr:DescribeRepositories: リポジトリ情報取得
  #   - ecr:ListImages: イメージ一覧取得
  #   - ecr:DeleteRepository: リポジトリ削除
  #   - ecr:BatchDeleteImage: イメージ削除
  # 条件キー例:
  #   - aws:SourceIp: 送信元IPアドレス制限
  #   - aws:SourceArn: 送信元ARN制限（CodeBuild等）
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPull"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # region: リソースを管理するAWSリージョン
  # 設定内容: このリソースが作成されるリージョンを明示的に指定
  # 設定可能な値: AWSリージョンコード（us-east-1、ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  # 補足: マルチリージョン構成で明示的な制御が必要な場合に使用
  region = null
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースから参照可能な属性
#
# - id: リポジトリ名（repositoryと同じ値）
# - repository: ポリシーが適用されているリポジトリ名
# - registry_id: リポジトリが作成されたレジストリID（AWSアカウントID）
# - region: リソースが管理されているリージョン
#
# 参照例:
#   aws_ecr_repository_policy.example.registry_id
#   aws_ecr_repository_policy.example.repository
