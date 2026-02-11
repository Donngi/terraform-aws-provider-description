# =============================================================================
# Terraform AWS Provider Resource Template
# =============================================================================
# Resource: aws_cloudfrontkeyvaluestore_keys_exclusive
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# Note: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様については公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfrontkeyvaluestore_keys_exclusive
# =============================================================================

# -----------------------------------------------------------------------------
# aws_cloudfrontkeyvaluestore_keys_exclusive
# -----------------------------------------------------------------------------
# CloudFront KeyValueStore内のキーと値のペアの排他的管理を行うリソース
#
# 重要な注意事項:
# - このリソースはKeyValueStore内のキーと値のペアに対して排他的な所有権を持ちます
# - 明示的に設定されていないキーと値のペアは削除されます
# - aws_cloudfrontkeyvaluestore_keyリソースと併用する場合は、同等の
#   resource_key_value_pairを設定して永続的なドリフトを防いでください
# - このリソースを削除してもKeyValueStoreから設定済みのキーと値のペアは
#   削除されません（Terraformが管理しなくなるだけです）
#
# 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions.html
# API Reference: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_Operations_Amazon_CloudFront_KeyValueStore.html
# -----------------------------------------------------------------------------
resource "aws_cloudfrontkeyvaluestore_keys_exclusive" "example" {
  # ---------------------------------------------------------------------------
  # Required Arguments
  # ---------------------------------------------------------------------------

  # key_value_store_arn (必須)
  # Key Value StoreのAmazon Resource Name (ARN)
  # CloudFront KeyValueStoreの識別子として使用されます
  # 形式: arn:aws:cloudfront::account-id:key-value-store/resource-id
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_KeyValueStore.html
  key_value_store_arn = "arn:aws:cloudfront::123456789012:key-value-store/example-id"

  # ---------------------------------------------------------------------------
  # Optional Arguments
  # ---------------------------------------------------------------------------

  # max_batch_size (オプション)
  # 単一のAPIリクエストで更新される最大リソースキーと値のペア数
  # AWSのデフォルトクォータは50キーまたは3MBのペイロード（いずれか先に到達した方）
  # デフォルト値: 50
  # 設定可能範囲: AWSのクォータ制限内
  # 参考: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_Operations_Amazon_CloudFront_KeyValueStore.html
  max_batch_size = 50

  # ---------------------------------------------------------------------------
  # Nested Blocks
  # ---------------------------------------------------------------------------

  # resource_key_value_pair (オプション)
  # KeyValueStoreに関連付けられる全てのリソースキーと値のペアのリスト
  # 複数のキーと値のペアを定義できます
  # このブロックが空の場合、KeyValueStore内の全てのキーと値のペアが削除されます
  # 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions-tutorial-kvs.html
  resource_key_value_pair {
    # key (必須)
    # 保存するキー
    # CloudFront関数からこのキー名を使用してアクセスします
    # キー名は一意である必要があります
    key = "example-key-1"

    # value (必須)
    # 保存する値
    # 文字列、バイトエンコード文字列、またはJSON形式で保存できます
    # CloudFront関数の実行時にエッジロケーションのメモリ内で復号化されます
    # 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions.html
    value = "example-value-1"
  }

  # 複数のキーと値のペアを定義する例
  resource_key_value_pair {
    key   = "example-key-2"
    value = "example-value-2"
  }

  resource_key_value_pair {
    key   = "redirect-config"
    value = "{\"url\": \"https://example.com\", \"status\": 301}"
  }
}

# -----------------------------------------------------------------------------
# Computed Attributes (読み取り専用)
# -----------------------------------------------------------------------------
# 以下の属性は自動的に計算されます:
#
# - total_size_in_bytes: Key Value Storeの合計サイズ（バイト単位）
#
# 使用例:
# output "kvs_total_size" {
#   value = aws_cloudfrontkeyvaluestore_keys_exclusive.example.total_size_in_bytes
# }
# -----------------------------------------------------------------------------

# =============================================================================
# 使用例: URLリライトやリダイレクトの設定
# =============================================================================
# CloudFront KeyValueStoreは以下のような用途で使用できます:
# - URLリライトやリダイレクト
# - A/Bテストや機能フラグ
# - アクセス認証
#
# CloudFront関数（JavaScript runtime 2.0）と組み合わせて使用します
# 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions-associate.html
# =============================================================================
