# ========================================
# Terraform AWS Resource Template
# ========================================
# Resource: aws_cloudfrontkeyvaluestore_key
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-18)の情報です。
# 最新の仕様や詳細は公式ドキュメントを確認してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfrontkeyvaluestore_key
# ========================================

# ========================================
# CloudFront KeyValueStore Key
# ========================================
# CloudFront KeyValueStoreの個別キーバリューペアを管理するリソース
#
# 重要な注意事項:
# このリソースは個別のキーバリューペアを管理します。多数のキーバリューペアを
# 定義すると、CloudFront KeyValueStore APIへのアクセスに高いコストが発生する
# 可能性があります。大規模なキーバリューストアの場合は、API呼び出し回数を
# 最小限に抑えるため、aws_cloudfrontkeyvaluestore_keys_exclusive リソースの
# 使用を検討してください。
#
# CloudFront KeyValueStoreは、CloudFrontエッジロケーションで高度な
# カスタマイズ可能なロジックを実現する、セキュアでグローバルな
# 低レイテンシのキーバリューデータストアです。
# コード変更をデプロイすることなくデータを更新でき、関数コードを簡素化します。
#
# 関連ドキュメント:
# - AWS公式: CloudFront KeyValueStore概要
#   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions.html
# - AWS API: KeyValueStore
#   https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_KeyValueStore.html
# - AWS API: PutKey操作
#   https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_Operations_Amazon_CloudFront_KeyValueStore.html
# ========================================

resource "aws_cloudfrontkeyvaluestore_key" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # key_value_store_arn - (必須) KeyValueStoreのAmazon Resource Name (ARN)
  # タイプ: string
  #
  # CloudFront KeyValueStoreのARNを指定します。
  # このARNは、aws_cloudfront_key_value_storeリソースから取得できます。
  #
  # 形式例: arn:aws:cloudfront::123456789012:key-value-store/EXXXXXXXXXXXXXXX
  #
  # 関連ドキュメント:
  # - KeyValueStore ARN
  #   https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_KeyValueStore.html
  key_value_store_arn = "arn:aws:cloudfront::123456789012:key-value-store/EXXXXXXXXXXXXXXX"

  # key - (必須) 格納するキー
  # タイプ: string
  #
  # KeyValueStoreに格納するキーの名前を指定します。
  # このキーは、CloudFront Functionsのコード内で参照され、
  # 対応する値に置き換えられます。
  #
  # キーバリューペアは、URL書き換えやリダイレクト、A/Bテスト、
  # 機能フラグ、アクセス認証などに使用できます。
  #
  # 注意: 同一のKeyValueStore内でキー名は一意である必要があります。
  #
  # 関連ドキュメント:
  # - KeyValueStoreの使用方法
  #   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions-tutorial-kvs.html
  key = "example-key"

  # value - (必須) 格納する値
  # タイプ: string
  #
  # 指定したキーに対応する値を指定します。
  # 値は文字列、バイトエンコードされた文字列、またはJSON形式で
  # 格納できます。
  #
  # CloudFront Functionが実行されると、CloudFrontはエッジロケーションの
  # メモリ内で各キーバリューペアを復号化します。
  # キーバリューストアは保存時および転送中に暗号化されます。
  #
  # 関連ドキュメント:
  # - KeyValueStoreのデータ形式
  #   https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions.html
  value = "example-value"

  # ========================================
  # 計算専用属性 (Computed Only)
  # ========================================
  # 以下の属性はTerraformによって自動的に設定されるため、
  # テンプレートには含めません:
  #
  # - id: キーバリューペアを一意に識別するID
  #       形式: key_value_store_arn,key の組み合わせ
  #
  # - total_size_in_bytes: KeyValueStoreの合計サイズ(バイト単位)
  #       この値は読み取り専用で、AWS側で計算されます
  # ========================================
}
