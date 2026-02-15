################################################################################
# CloudFront Field Level Encryption Profile
################################################################################
# CloudFrontのフィールドレベル暗号化プロファイルを管理するリソース
# 機密データを暗号化してオリジンに送信するための設定を定義
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_field_level_encryption_profile
# Generated: 2026-02-12
#
# NOTE:
# - 暗号化エンティティは必須で1つのみ設定可能
# - 各アイテムには必ずfield_patternsが必要
# - 既存のCloudFront公開鍵リソースが必要
#
# 関連リソース:
# - aws_cloudfront_public_key: 暗号化に使用する公開鍵
# - aws_cloudfront_field_level_encryption_config: 暗号化設定の適用
# - aws_cloudfront_distribution: CloudFrontディストリビューション

  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------

  # 設定内容: 暗号化プロファイルの一意な名前
  # 制約: CloudFront内でユニークである必要がある
  name = "example-encryption-profile"

  #-----------------------------------------------------------------------
  # 追加設定
  #-----------------------------------------------------------------------

  # 設定内容: プロファイルの説明やメモ
  # 用途: 管理目的での識別情報
  # 省略時: コメントなしで作成される
  comment = "Production user data encryption profile"

  #-----------------------------------------------------------------------
  # 暗号化エンティティ設定
  #-----------------------------------------------------------------------

  # 暗号化対象フィールドとその暗号化方法を定義
  # 必須設定、1つのみ指定可能
  encryption_entities {
    # フィールド暗号化の個別設定（複数指定可能）
    items {
      # 設定内容: 暗号化プロバイダーの一意な識別子
      # 用途: 複数のプロバイダーを区別するための名前
      provider_id = "example-provider"

      # 設定内容: 暗号化に使用する公開鍵のID
      # 制約: 事前に作成されたaws_cloudfront_public_keyリソースのIDを指定
      public_key_id = "K2EXAMPLE123456"

      # 暗号化対象フィールドのパターン設定
      field_patterns {
        # 設定内容: 暗号化するフィールド名のパターンリスト
        # 形式: HTTPリクエストボディ内のフィールド名を指定
        # 例: クレジットカード番号、個人情報などの機密フィールド
        # 省略時: すべてのフィールドが暗号化対象外となる
        # items = [
        #   "CreditCardNumber",
        #   "SSN",
        #   "DateOfBirth",
        # ]
      }
    }

    # 複数の暗号化プロバイダーを使用する場合
    # items {
    #   provider_id   = "backup-provider"
    #   public_key_id = "K2EXAMPLE789012"
    #
    #   field_patterns {
    #     items = [
    #       "BackupData",
    #     ]
    #   }
    # }
  }

################################################################################
# Attributes Reference
################################################################################
# このリソースは以下の属性をエクスポートします:
#
# - id                 - プロファイルのID（CloudFrontが自動生成）
# - arn                - プロファイルのAmazon Resource Name
# - etag               - プロファイルの現在のバージョンを示すETag値
#                        更新時の整合性チェックに使用
# - caller_reference   - プロファイル作成時のタイムスタンプベースの一意な識別子
#                        CloudFrontによって自動生成される
