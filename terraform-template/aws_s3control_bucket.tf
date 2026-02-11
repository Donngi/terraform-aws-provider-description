#---------------------------------------------------------------
# AWS S3 Control Bucket
#---------------------------------------------------------------
#
# S3 Control Bucketは、AWS Outposts上でS3バケットを管理するための
# リソースです。このリソースを使用することで、オンプレミス環境で
# S3互換のオブジェクトストレージを利用できます。
#
# 重要な注意事項:
# このリソースはS3 on Outpostsの管理専用です。
# 通常のAWSリージョン内のS3バケットを管理する場合は、
# aws_s3_bucketリソースを使用してください。
#
# S3 on Outpostsの主な特徴:
#   - オンプレミス環境でのオブジェクトストレージ
#   - データレジデンシー要件への対応
#   - 低レイテンシーなローカルデータアクセス
#   - S3 APIとの互換性
#
# AWS公式ドキュメント:
#   - S3 on Outposts: https://docs.aws.amazon.com/AmazonS3/latest/dev/S3onOutposts.html
#   - S3 on Outpostsバケットの操作: https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsWorkingBuckets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3control_bucket
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_bucket" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: バケットの名前を指定します。
  # 設定可能な値: 3-63文字の文字列。小文字、数字、ハイフン(-)のみ使用可能
  # 注意: Outpost内で一意である必要があります。DNS準拠の命名規則に従います。
  #       変更するとリソースの再作成が必要です。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = "example"

  # outpost_id (Required, Forces new resource)
  # 設定内容: このバケットを配置するOutpostの識別子を指定します。
  # 設定可能な値: Outpost ID（形式: op-xxxxxxxxxxxxxxxxx）
  # 注意: OutpostはS3 on Outposts機能をサポートしている必要があります。
  #       変更するとリソースの再作成が必要です。
  #       aws_outposts_outpostデータソースから取得できます。
  # 参考: https://docs.aws.amazon.com/outposts/latest/userguide/what-is-outposts.html
  outpost_id = "op-1234567890abcdef0"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Outpostが配置されているリージョンと一致させる必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのキーバリューマップを指定します。
  # 設定可能な値: 文字列をキーと値とするマップ
  # 注意: プロバイダーのdefault_tags設定ブロックが構成されている場合、
  #       一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  # tags = {
  #   Environment = "production"
  #   Project     = "outposts-storage"
  #   ManagedBy   = "terraform"
  # }

  #-------------------------------------------------------------
  # 計算属性（自動設定される値）
  #-------------------------------------------------------------
  # 以下の属性はAWSによって自動的に設定され、参照可能です。
  # 直接設定することはできません。
  #
  # arn (Computed)
  # 説明: バケットのAmazon Resource Name (ARN)
  # 形式: arn:aws:s3-outposts:<region>:<account-id>:outpost/<outpost-id>/bucket/<bucket-name>
  # 使用方法: aws_s3control_bucket.example.arn
  #
  # creation_date (Computed)
  # 説明: バケットの作成日時（UTC）
  # 形式: RFC3339形式（例: 2024-01-15T10:30:00Z）
  # 参考: https://tools.ietf.org/html/rfc3339#section-5.8
  # 使用方法: aws_s3control_bucket.example.creation_date
  #
  # id (Computed)
  # 説明: バケットのAmazon Resource Name (ARN)
  # 形式: arn属性と同じ
  # 使用方法: aws_s3control_bucket.example.id
  #
  # public_access_block_enabled (Computed)
  # 説明: パブリックアクセスブロックが有効かどうかを示すブール値
  # 設定可能な値: true/false
  # 注意: S3 on Outpostsでは通常true（推奨）
  # 使用方法: aws_s3control_bucket.example.public_access_block_enabled
  #
  # tags_all (Computed)
  # 説明: プロバイダーのdefault_tagsから継承されたタグを含む、
  #       リソースに割り当てられたすべてのタグのマップ
  # 使用方法: aws_s3control_bucket.example.tags_all
  #-------------------------------------------------------------
}

#---------------------------------------------------------------
# 出力例
#---------------------------------------------------------------
# 以下は、このリソースから取得できる属性の出力例です。
# 必要に応じてコメントを外して使用してください。

# output "s3control_bucket_arn" {
#   description = "S3 Control BucketのARN"
#   value       = aws_s3control_bucket.example.arn
# }

# output "s3control_bucket_id" {
#   description = "S3 Control BucketのID（ARN）"
#   value       = aws_s3control_bucket.example.id
# }

# output "s3control_bucket_creation_date" {
#   description = "バケットの作成日時（RFC3339形式）"
#   value       = aws_s3control_bucket.example.creation_date
# }

# output "s3control_bucket_public_access_block_enabled" {
#   description = "パブリックアクセスブロックが有効かどうか"
#   value       = aws_s3control_bucket.example.public_access_block_enabled
# }

# output "s3control_bucket_tags_all" {
#   description = "プロバイダーデフォルトを含むすべてのタグ"
#   value       = aws_s3control_bucket.example.tags_all
# }

#---------------------------------------------------------------
# 使用例 - データソースと組み合わせた使用
#---------------------------------------------------------------
# Outpost情報をデータソースから取得する例

# data "aws_outposts_outpost" "example" {
#   name = "my-outpost-name"
# }
#
# resource "aws_s3control_bucket" "example_with_datasource" {
#   bucket     = "example-with-datasource"
#   outpost_id = data.aws_outposts_outpost.example.id
#
#   tags = {
#     Name      = "example-with-datasource"
#     ManagedBy = "terraform"
#   }
# }

#---------------------------------------------------------------
# 完全なセットアップ例
#---------------------------------------------------------------
# S3 on Outpostsの完全な構成例（バケット、アクセスポイント、エンドポイント）

# # ステップ1: Outpost情報の取得
# data "aws_outposts_outpost" "example" {
#   name = "my-outpost"
# }
#
# # ステップ2: VPCインフラストラクチャの作成
# resource "aws_vpc" "outposts" {
#   cidr_block = "10.0.0.0/16"
#
#   tags = {
#     Name = "outposts-vpc"
#   }
# }
#
# resource "aws_subnet" "outposts" {
#   vpc_id            = aws_vpc.outposts.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = data.aws_outposts_outpost.example.availability_zone
#
#   tags = {
#     Name = "outposts-subnet"
#   }
# }
#
# # ステップ3: エンドポイント用セキュリティグループの作成
# resource "aws_security_group" "s3_endpoint" {
#   name        = "outposts-s3-endpoint-sg"
#   description = "Security group for S3 on Outposts endpoint"
#   vpc_id      = aws_vpc.outposts.id
#
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.outposts.cidr_block]
#     description = "Allow HTTPS from VPC"
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound"
#   }
#
#   tags = {
#     Name = "outposts-s3-endpoint-sg"
#   }
# }
#
# # ステップ4: S3 Control Bucketの作成
# resource "aws_s3control_bucket" "main" {
#   bucket     = "my-outposts-bucket"
#   outpost_id = data.aws_outposts_outpost.example.id
#
#   tags = {
#     Name        = "my-outposts-bucket"
#     Environment = "production"
#     Purpose     = "local-data-processing"
#     ManagedBy   = "terraform"
#   }
# }
#
# # ステップ5: アクセスポイントの作成
# resource "aws_s3control_access_point" "main" {
#   name   = "my-access-point"
#   bucket = aws_s3control_bucket.main.arn
#
#   vpc_configuration {
#     vpc_id = aws_vpc.outposts.id
#   }
#
#   public_access_block_configuration {
#     block_public_acls       = true
#     block_public_policy     = true
#     ignore_public_acls      = true
#     restrict_public_buckets = true
#   }
# }
#
# # ステップ6: S3 Outpostsエンドポイントの作成
# resource "aws_s3outposts_endpoint" "main" {
#   outpost_id        = data.aws_outposts_outpost.example.id
#   security_group_id = aws_security_group.s3_endpoint.id
#   subnet_id         = aws_subnet.outposts.id
#   access_type       = "Private"
# }

#---------------------------------------------------------------
# ベストプラクティスと考慮事項
#---------------------------------------------------------------
#
# 【命名規則】
# - 小文字、数字、ハイフン(-)のみを使用
# - バケット名はOutpost内で一意である必要がある
# - 説明的で一貫性のある命名標準を維持
# - SSL証明書の問題を避けるためピリオド(.)の使用は避ける
# - 例: prod-outpost-data-bucket
#
# 【Outpostの要件】
# - バケット作成前にアクティブなAWS Outpostが必要
# - Outpost IDが正しくアクセス可能であることを確認
# - Outpostの容量とリソース制限を確認
# - OutpostがS3 on Outposts機能をサポートしていることを確認
# - バケット作成には最大5分かかる場合がある
#
# 【アクセス設定】
# - S3 on Outpostsにはアクセスポイントとエンドポイントが必要
# - バケットアクセスにaws_s3control_access_pointを作成
# - VPC接続にaws_s3outposts_endpointを作成
# - アクセスはVPCエンドポイント経由でのみ可能
# - AWSマネジメントコンソールではオブジェクト操作不可
#
# 【セキュリティ】
# - パブリックアクセスブロックはデフォルトで有効（推奨）
# - VPCエンドポイントでプライベートネットワークへのアクセスを制限
# - 最小権限のIAMポリシーを実装
# - 保存時の暗号化を有効化（デフォルトで有効）
# - 転送時の暗号化（HTTPS）を使用
# - 追加のアクセス制御にバケットポリシーを検討
# - 監査証跡のためアクセスログを有効化
#
# 【タグ付け戦略】
# - コスト追跡と組織化のため一貫したタグを適用
# - 共通タグにはプロバイダーレベルのdefault_tagsを使用
# - 必須タグの例: Environment、Project、Owner
# - データ分類タグの検討（Public/Internal/Confidential）
# - 請求配分のためCostCenterタグを使用
# - タグ構造の例:
#   tags = {
#     Environment        = "production"
#     Project            = "data-processing"
#     Owner              = "platform-team"
#     CostCenter         = "engineering"
#     DataClassification = "internal"
#     ManagedBy          = "terraform"
#   }
#
# 【ストレージの考慮事項】
# - S3 on OutpostsはOUTPOSTSストレージクラスを使用
# - 標準S3ストレージクラス（STANDARD、GLACIER）は使用不可
# - データはOutpost上に留まり外部には出ない
# - データレジデンシーとコンプライアンス要件に有用
# - 容量を慎重に計画（Outpostあたり26TB、48TB、96TB、240TB、380TB）
#
# 【容量制限】
# - AWSアカウントあたり最大100個のバケット
# - ストレージ容量はOutpost構成に依存
# - 容量問題を避けるため使用量を監視
# - ストレージ効率管理のためライフサイクルポリシーを使用
#
# 【APIの違い】
# - S3 on Outpostsは拡張されたAPI操作を使用
# - リクエストにはx-amz-outpost-idヘッダーが必要
# - リクエスト署名には適切なARN形式を使用
# - AWSコンソールではオブジェクトのアップロード/管理不可
# - 代わりにAWS CLI、SDK、REST APIを使用
#
# 【高可用性】
# - OutpostバケットはOutpostにローカル
# - 重要なデータのレプリケーションを検討
# - Outpostのメンテナンスウィンドウを計画
# - 適切なバックアップ戦略を実装
# - データ転送にはAWS DataSyncを使用
#
# 【パフォーマンス最適化】
# - データ転送削減のためローカル処理を最大化
# - データ処理にEMR on Outpostsの使用を検討
# - 認証と承認のキャッシングを活用
# - 最初のバイトのレイテンシーを最適化
# - 可能な場合は並列操作を使用
#
# 【コスト最適化】
# - 必要な容量を事前に見積もり
# - ストレージの過剰プロビジョニングを避ける
# - 古いオブジェクト削除のためライフサイクルポリシーを実装
# - データ転送パターンを最適化
# - 容量共有にAWS Resource Access Managerを使用
# - 使用パターンを監視・分析
#
# 【モニタリングとログ記録】
# - バケット操作のためCloudWatchアラームを設定
# - Outpostの容量とパフォーマンスを監視
# - バケットアクセスパターンを追跡
# - S3アクセスログを有効化
# - API呼び出し追跡のためCloudTrailを使用
# - Outpostへのネットワーク接続を監視
#
# 【ディザスタリカバリ】
# - Outpost障害シナリオを計画
# - AWSリージョンへの定期的なバックアップを実装
# - リカバリ手順を文書化
# - フェイルオーバープロセスを定期的にテスト
# - バックアップにAWS DataSyncの使用を検討
#
#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
#
# S3 on Outpostsを完全に構成するための関連リソース:
#
# 1. aws_s3control_access_point
#    - Outpostバケットのアクセスポイントを作成
#    - VPCベースのアクセスを提供
#    - バケットアクセスに必須
#
# 2. aws_s3outposts_endpoint
#    - Outpostへのエンドポイントを作成
#    - アクセスポイントへのリクエストをルーティング
#    - VPC接続を有効化
#
# 3. data "aws_outposts_outpost"
#    - Outpost情報を取得
#    - Outpost IDとアベイラビリティーゾーンを提供
#    - 設定に使用
#
# 4. aws_s3control_bucket_lifecycle_configuration
#    - バケットライフサイクルポリシーを管理
#    - オブジェクト有効期限ルールを設定
#    - ストレージ使用量を最適化
#
# 5. aws_s3control_bucket_policy
#    - バケットポリシーを設定
#    - アクセス制御を管理
#    - 権限を定義
#
# 6. aws_vpc
#    - VPCエンドポイント接続に必須
#    - ネットワーク分離を提供
#
# 7. aws_subnet
#    - エンドポイント配置に必須
#    - Outpostのアベイラビリティーゾーンに配置必要
#
# 8. aws_security_group
#    - エンドポイントアクセスを制御
#    - ネットワークルールを定義
#
#---------------------------------------------------------------
# トラブルシューティング
#---------------------------------------------------------------
#
# 【バケット作成の失敗】
# - Outpost IDが正しいことを確認
# - OutpostがS3 on Outpostsをサポートしていることを確認
# - バケット名がDNS準拠規則に従っていることを確認
# - アカウントが100個のバケット制限に達していないことを確認
# - バケット作成完了を待機（最大5分）
#
# 【アクセスエラー】
# - アクセスポイントとエンドポイントが構成されていることを確認
# - VPCとセキュリティグループ設定を確認
# - IAM権限が正しいことを確認
# - リクエストにx-amz-outpost-idヘッダーが含まれることを確認
# - API呼び出しのARN形式を確認
#
# 【接続の問題】
# - Outpostとリージョンのネットワーク接続を確認
# - VPCエンドポイントのステータスを確認
# - DNS解決が機能していることを確認
# - セキュリティグループルールをテスト
# - ルートテーブルとNACLを確認
#
# 【パフォーマンスの問題】
# - ローカル処理のためEMR on Outpostsの使用を検討
# - 認証/承認キャッシングを活用
# - 最初のバイトのレイテンシーを最適化
# - 並列操作を使用
# - Outpost容量を監視
#
# 【容量の問題】
# - ストレージ使用量を定期的に監視
# - クリーンアップのためライフサイクルポリシーを実装
# - 不要なオブジェクトを確認して削除
# - Outpostへのストレージ容量追加を検討
# - 共有のためAWS Resource Access Managerを使用
#
#---------------------------------------------------------------
# 追加リファレンス
#---------------------------------------------------------------
#
# AWSドキュメント:
# - S3 on Outpostsユーザーガイド: https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/
# - バケットの操作: https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3OutpostsWorkingBuckets.html
# - APIリファレンス: https://docs.aws.amazon.com/AmazonS3/latest/API/
# - AWS Outposts: https://aws.amazon.com/outposts/
#
# Terraformドキュメント:
# - aws_s3control_bucket: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_bucket
# - aws_s3control_access_point: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_point
# - aws_s3outposts_endpoint: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3outposts_endpoint
#
#---------------------------------------------------------------
