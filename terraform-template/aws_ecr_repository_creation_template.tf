#---------------------------------------
# リソース名: aws_ecr_repository_creation_template
#---------------------------------------
# Amazon ECRリポジトリ作成テンプレート
#
# プルスルーキャッシュ、レプリケーション、プッシュ時作成などで自動作成されるECRリポジトリの設定を
# テンプレートとして事前定義できるリソースです。名前空間プレフィックスに基づいて、リポジトリ作成時に
# 暗号化設定、タグの可変性、ライフサイクルポリシー、リソースタグなどを自動適用します。
#
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_creation_template
# AWS Provider Version: 6.28.0
# Resource Version: 0
# Generated: 2026-02-17
#
# NOTE: このテンプレートで作成されたリポジトリのみに設定が適用されます。既存リポジトリには影響しません。
#
#---------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_ecr_repository_creation_template" "example" {
  # 設定内容: テンプレートを適用するECRリポジトリ作成シナリオのリスト
  # 設定可能な値:
  #   - REPLICATION: レプリケーションアクション時に作成されるリポジトリに適用
  #   - PULL_THROUGH_CACHE: プルスルーキャッシュルールで作成されるリポジトリに適用
  #   - CREATE_ON_PUSH: プッシュ時作成で作成されるリポジトリに適用
  # 省略時: 設定必須（複数選択可能）
  applied_for = ["REPLICATION", "PULL_THROUGH_CACHE"]

  # 設定内容: このテンプレートを適用するリポジトリ名前空間プレフィックス
  # 設定可能な値:
  #   - 名前空間プレフィックス（例: prod、prod/team）
  #   - ROOT: テンプレートが割り当てられていない全リポジトリに適用
  # 省略時: 設定必須
  # 補足: プレフィックスには自動的に末尾に / が追加される
  prefix = "prod"

  #---------------------------------------
  # リポジトリ設定
  #---------------------------------------

  # 設定内容: リポジトリの説明文
  # 設定可能な値: 最大256文字の文字列
  # 省略時: 説明なし
  description = "Production repositories for container images"

  # 設定内容: イメージタグの可変性設定
  # 設定可能な値:
  #   - MUTABLE: タグの上書きを許可（デフォルト）
  #   - IMMUTABLE: 全タグを不変にする
  #   - IMMUTABLE_WITH_EXCLUSION: 除外フィルタを使用して一部タグのみ可変にする
  #   - MUTABLE_WITH_EXCLUSION: 除外フィルタを使用して一部タグのみ不変にする
  # 省略時: MUTABLE
  image_tag_mutability = "IMMUTABLE"

  # 設定内容: カスタムIAMロールのARN
  # 設定可能な値: ECRがリポジトリ作成時に引き受けるIAMロールのARN（最大2048文字）
  # 省略時: ECRのサービスリンクロールを使用
  # 補足: resource_tagsやKMS暗号化を使用する場合は必須
  custom_role_arn = "arn:aws:iam::123456789012:role/ECRRepositoryCreationRole"

  # 設定内容: リポジトリに適用するリソースタグ
  # 設定可能な値: キーと値のペアで指定（キー最大128文字、値最大256文字）
  # 省略時: タグなし
  # 補足: タグを使用する場合はcustom_role_arnの指定が必要
  resource_tags = {
    Environment = "Production"
    Team        = "Platform"
    ManagedBy   = "Terraform"
  }

  # 設定内容: リポジトリのAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダーに設定されたリージョン
  region = "us-east-1"

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------

  encryption_configuration {
    # 設定内容: 暗号化タイプ
    # 設定可能な値:
    #   - AES256: AES256暗号化を使用（デフォルト）
    #   - KMS: AWS KMSカスタマーマネージドキーを使用
    # 省略時: AES256
    encryption_type = "KMS"

    # 設定内容: KMSキーのARNまたはエイリアス
    # 設定可能な値:
    #   - KMSキーARN
    #   - KMSキーエイリアス（例: alias/ecr-key）
    # 省略時: encryption_type=KMSの場合はAWS管理のECR用KMSキーを使用
    # 補足: KMS使用時はcustom_role_arnの指定が必要
    kms_key = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #---------------------------------------
  # タグ可変性除外フィルタ設定
  #---------------------------------------
  # 補足: 最大5個まで設定可能

  image_tag_mutability_exclusion_filter {
    # 設定内容: 除外対象のタグを指定するフィルタパターン
    # 設定可能な値: タグパターン文字列
    # 省略時: 設定必須
    # 補足: filter_typeと組み合わせて使用
    filter = "latest"

    # 設定内容: フィルタのタイプ
    # 設定可能な値: フィルタタイプを指定
    # 省略時: 設定必須
    filter_type = "TAG_PREFIX_LIST"
  }

  image_tag_mutability_exclusion_filter {
    filter      = "v*"
    filter_type = "TAG_PREFIX_LIST"
  }

  #---------------------------------------
  # ポリシー設定
  #---------------------------------------

  # 設定内容: リポジトリポリシー（IAMポリシー形式のJSON）
  # 設定可能な値: IAMポリシードキュメント（最大10240文字）
  # 省略時: ポリシーなし
  # 補足: リポジトリへのアクセス権限を制御するリソースベースポリシー
  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPull"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:role/ECRPullRole"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })

  # 設定内容: ライフサイクルポリシー（JSON形式）
  # 設定可能な値: ECRライフサイクルポリシールールを定義したJSON（最大30720文字）
  # 省略時: ライフサイクルポリシーなし
  # 補足: イメージの自動削除ルールを定義
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 30 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only 10 most recent tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: テンプレートのプレフィックス値
# - registry_id: リポジトリ作成テンプレートが関連付けられているレジストリのID（12桁の数字）
# - region: リソースが管理されているAWSリージョン（省略時はプロバイダー設定のリージョン）
#
# エクスポート例:
# output "template_id" {
#   value = aws_ecr_repository_creation_template.example.id
# }
#
# output "registry_id" {
#   value = aws_ecr_repository_creation_template.example.registry_id
# }
