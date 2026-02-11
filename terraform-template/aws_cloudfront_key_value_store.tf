#---------------------------------------------------------------
# AWS CloudFront Key Value Store
#---------------------------------------------------------------
#
# Amazon CloudFront KeyValueStoreをプロビジョニングするリソースです。
# KeyValueStoreは、CloudFrontエッジロケーションで高度なカスタマイズロジックを
# 実現するための、セキュアでグローバルかつ低レイテンシーなキー・バリューデータストアです。
# CloudFront Functionsと組み合わせて、URLリライト、A/Bテスト、アクセス認可などに活用できます。
#
# AWS公式ドキュメント:
#   - CloudFront KeyValueStore: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions.html
#   - KeyValueStoreの作成: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/kvs-with-functions-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_key_value_store
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_key_value_store" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: CloudFront KeyValueStoreの一意な名前を指定します。
  # 設定可能な値: 文字列
  # 用途: CloudFront FunctionsからKeyValueStoreを参照する際の識別子として使用
  name = "ExampleKeyValueStore"

  #-------------------------------------------------------------
  # コメント設定
  #-------------------------------------------------------------

  # comment (Optional)
  # 設定内容: KeyValueStoreに関するコメントや説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: なし
  # 用途: KeyValueStoreの用途や目的を記録するために使用
  comment = "This is an example key value store"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: KeyValueStoreの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間単位を含む文字列（例: "30s", "2h45m"）
    #   有効な時間単位: "s" (秒), "m" (分), "h" (時間)
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: CloudFront KeyValueStoreを識別するAmazon Resource Name (ARN)
#
# - etag: KeyValueStoreのETagハッシュ
#
# - id: KeyValueStoreの一意な識別子
#
# - last_modified_time: KeyValueStoreが最後に変更された時刻
#---------------------------------------------------------------
