################################################################################
# CloudFront Key Group
################################################################################
# CloudFront Key Groupは、署名付きURLや署名付きCookieの検証に使用する公開鍵のセットを管理します。
# 信頼できる署名者として使用され、コンテンツへのアクセス制御を実現します。
#
# 主な用途:
# - 署名付きURL/Cookieによるコンテンツアクセス制御
# - 複数の公開鍵の一元管理
# - 鍵のローテーション（複数鍵の同時有効化が可能）
#
# プロバイダーバージョン: 6.28.0
# 参照: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_key_group
################################################################################

resource "aws_cloudfront_key_group" "example" {
  # ------------------------------------------------------------------------------
  # 必須パラメータ
  # ------------------------------------------------------------------------------

  # name - Key Groupの名前
  # - 用途: Key Groupを識別するための名前
  # - 制約: CloudFront内で一意である必要があります
  # - 命名規則: 英数字、ハイフン、アンダースコアが使用可能
  # - 例: "my-key-group", "production-signing-keys"
  name = "example-key-group"

  # items - 公開鍵のIDリスト
  # - 用途: このKey Groupに含める公開鍵（aws_cloudfront_public_key）のIDを指定
  # - 制約: 最低1つの公開鍵が必要
  # - 推奨: 鍵ローテーションのため、複数の公開鍵を設定することを推奨
  # - 注意: 公開鍵は事前にaws_cloudfront_public_keyリソースで作成が必要
  # - 例: [aws_cloudfront_public_key.primary.id, aws_cloudfront_public_key.backup.id]
  items = [
    # aws_cloudfront_public_key.example.id  # 公開鍵リソースへの参照
  ]

  # ------------------------------------------------------------------------------
  # オプションパラメータ
  # ------------------------------------------------------------------------------

  # comment - Key Groupの説明
  # - 用途: Key Groupの目的や用途を説明
  # - 推奨: 環境や用途を明記（例: "本番環境用署名鍵グループ"）
  # - 例: "Production signing key group for premium content"
  comment = "Example key group for CloudFront signed URLs"

  # ------------------------------------------------------------------------------
  # タグ（オプション）
  # ------------------------------------------------------------------------------
  # tags = {
  #   Name        = "example-key-group"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  #   Purpose     = "signed-url-validation"
  # }
}

################################################################################
# 出力値（Attributes）
################################################################################
# このリソースは以下の属性を提供します:
#
# - id: Key GroupのID
#   用途: 他のリソース（CloudFront Distribution等）から参照
#   例: aws_cloudfront_key_group.example.id
#
# - etag: Key Groupのバージョン識別子
#   用途: 更新検出や条件付き更新に使用
#   例: aws_cloudfront_key_group.example.etag

################################################################################
# 使用例: CloudFront Distributionとの連携
################################################################################
# resource "aws_cloudfront_distribution" "example" {
#   # ... 他の設定 ...
#
#   default_cache_behavior {
#     # ... 他の設定 ...
#
#     trusted_key_groups = [aws_cloudfront_key_group.example.id]
#   }
# }

################################################################################
# 使用例: 公開鍵リソースの定義
################################################################################
# resource "aws_cloudfront_public_key" "primary" {
#   comment     = "Primary public key for content signing"
#   encoded_key = file("${path.module}/keys/public_key_primary.pem")
#   name        = "primary-key"
# }
#
# resource "aws_cloudfront_public_key" "backup" {
#   comment     = "Backup public key for key rotation"
#   encoded_key = file("${path.module}/keys/public_key_backup.pem")
#   name        = "backup-key"
# }

################################################################################
# ベストプラクティス
################################################################################
# 1. 鍵のローテーション:
#    - 複数の公開鍵を items に設定し、段階的に鍵をローテーション
#    - 新しい鍵を追加 → 署名を新鍵で生成 → 古い鍵を削除
#
# 2. 鍵の管理:
#    - 公開鍵ファイルは Git に含めず、別途セキュアに管理
#    - AWS Secrets Manager や Parameter Store に保存することを推奨
#
# 3. 環境分離:
#    - 環境ごとに異なる Key Group を使用
#    - 本番環境と開発環境で鍵を分離
#
# 4. モニタリング:
#    - CloudWatch Logs でアクセス失敗をモニタリング
#    - 不正な署名によるアクセス試行を検知
#
# 5. 命名規則:
#    - 環境やアプリケーション名を含める
#    - 例: "{environment}-{application}-key-group"

################################################################################
# 注意事項
################################################################################
# 1. 削除保護:
#    - 使用中の Key Group は CloudFront Distribution から削除が必要
#    - Distribution が参照している間は削除不可
#
# 2. 更新時の影響:
#    - items の変更は即座に反映されます
#    - 既存の署名付きURLの有効性に影響する可能性があります
#
# 3. 公開鍵の形式:
#    - PEM形式の公開鍵が必要
#    - RSA 2048ビット以上を推奨
#
# 4. 制限事項:
#    - AWS アカウントあたりの Key Group 数に制限あり（デフォルト: 10）
#    - Key Group あたりの公開鍵数に制限あり（最大: 5）
#
# 5. コスト:
#    - Key Group 自体に追加料金は発生しません
#    - CloudFront の署名付きURL機能の使用には通常の転送料金が適用されます

################################################################################
# 関連リソース
################################################################################
# - aws_cloudfront_public_key: 公開鍵の管理
# - aws_cloudfront_distribution: CloudFront Distribution
# - aws_cloudfront_cache_policy: キャッシュポリシー
# - aws_cloudfront_origin_request_policy: オリジンリクエストポリシー

################################################################################
# Import
################################################################################
# 既存の CloudFront Key Group をインポートする場合:
# terraform import aws_cloudfront_key_group.example <key-group-id>
#
# Key Group ID の確認方法:
# aws cloudfront list-key-groups --query "KeyGroupList.Items[].KeyGroup.Id"
