#---------------------------------------------------------------
# CloudFront KeyValueStore Keys Exclusive
#---------------------------------------------------------------
#
# CloudFront KeyValueStoreのキー値ペアを排他的に管理するリソースです。
# このリソースはKeyValueStore内の全てのキー値ペアの排他的所有権を持ち、
# Terraform設定に含まれないキー値ペアは自動的に削除されます。
#
# 主な用途:
#   - CloudFront Function用のキー値データの集中管理
#   - URL書き換えやリダイレクト設定のデータ保持
#   - A/Bテストやフィーチャーフラグの設定保存
#   - アクセス認可情報の保持
#
# 重要な注意事項:
#   - このリソースはKeyValueStore内のキー値ペアを排他的に管理します
#   - aws_cloudfrontkeyvaluestore_keyと併用する場合は、resource_key_value_pair引数で
#     同等のキー値ペアを定義する必要があります（ドリフト防止のため）
#   - リソースを削除しても、KeyValueStore内のキー値ペアは削除されません
#
# AWS公式ドキュメント:
#   - CloudFront KeyValueStore概要: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions.html
#   - API操作: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_Operations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfrontkeyvaluestore_keys_exclusive
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfrontkeyvaluestore_keys_exclusive" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # key_value_store_arn (Required)
  # 設定内容: Key Value StoreのAmazon Resource Name (ARN)を指定します。
  # 注意: リソース作成後の変更はできません（Forces new resource）
  key_value_store_arn = aws_cloudfront_key_value_store.example.arn

  #-------------------------------------------------------------
  # パフォーマンス設定
  #-------------------------------------------------------------

  # max_batch_size (Optional)
  # 設定内容: 単一のAPIリクエストで更新する最大キー値ペア数を指定します。
  # 設定可能な値: 1〜50の整数
  # 省略時: 50
  # 備考: AWSのデフォルトクォータは50キーまたは3MBペイロード（先に到達した方）です
  max_batch_size = 50

  #-------------------------------------------------------------
  # キー値ペア設定
  #-------------------------------------------------------------

  # resource_key_value_pair (Optional)
  # 設定内容: KeyValueStoreに関連付けられる全てのキー値ペアのリストを指定します。
  # 備考: このブロックを省略すると、全てのキー値ペアが削除された状態になります
  resource_key_value_pair {
    # key (Required)
    # 設定内容: キーの名前を指定します。
    # 備考: CloudFront Functionのコード内でこの名前を参照します
    key = "redirect_url"

    # value (Required)
    # 設定内容: キーに対応する値を指定します。
    # 設定可能な値: 文字列、バイトエンコード文字列、またはJSON形式
    # 備考: 値は暗号化された状態で保存され、転送中も暗号化されます
    value = "https://example.com/new-path"
  }

  # 複数のキー値ペアを設定する場合は、ブロックを追加します
  resource_key_value_pair {
    key   = "feature_flag"
    value = "enabled"
  }

  resource_key_value_pair {
    key = "config_data"
    value = jsonencode({
      timeout = 30
      retries = 3
    })
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - total_size_in_bytes: Key Value Storeの合計サイズ（バイト単位）
#
# 関連機能: CloudFront Function
#   KeyValueStoreを使用するには、CloudFront FunctionでJavaScript runtime 2.0を
#   使用する必要があります。キー値は全てのエッジロケーションでグローバルに
#   低レイテンシでアクセス可能です。
#   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions-tutorial-kvs.html
#---------------------------------------------------------------
