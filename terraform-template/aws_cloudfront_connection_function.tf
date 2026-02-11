#---------------------------------------------------------------
# AWS CloudFront Connection Function
#---------------------------------------------------------------
#
# Amazon CloudFront Connection Functionをプロビジョニングするリソースです。
# Connection Functionは、mTLS（相互TLS）接続確立時にTLSハンドシェイク中に
# 実行される軽量なJavaScript関数で、クライアント証明書の検証や
# カスタム認証ロジックを実装できます。
#
# AWS公式ドキュメント:
#   - CloudFront Connection Functions概要: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/customize-connections-validation-with-connection-functions.html
#   - Connection Functionコードの記述: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/write-connection-function-code.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_connection_function
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_connection_function" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: Connection Functionの名前を指定します。
  # 設定可能な値: 1-64文字の文字列（英字、数字、ハイフン、アンダースコアが使用可能）
  # 注意: 変更すると新しいリソースが強制的に作成されます
  name = "example-connection-function"

  # connection_function_code (Required)
  # 設定内容: Connection Functionのコードを指定します。
  # 設定可能な値: 最大40960文字のJavaScriptコード
  # 関連機能: CloudFront Connection Functions
  #   TLSハンドシェイク中に実行されるJavaScript関数。クライアント証明書情報や
  #   接続情報にアクセスでき、connection.allow()またはconnection.deny()で
  #   接続の許可/拒否を決定します。ECMAScript 2020をサポートし、
  #   KeyValueStoreとの連携も可能です。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/write-connection-function-code.html
  connection_function_code = <<-EOF
async function connectionHandler(event) {
  const connection = event.connection;

  // クライアント証明書情報を取得
  const clientCert = connection.clientCertificate;

  if (!clientCert) {
    // 証明書がない場合は拒否
    return connection.deny("No client certificate provided");
  }

  // 証明書の検証ロジックを実装
  // 例: 証明書のサブジェクトを確認
  if (clientCert.subject && clientCert.subject.includes("O=MyOrganization")) {
    return connection.allow();
  }

  return connection.deny("Certificate validation failed");
}
EOF

  #-------------------------------------------------------------
  # 関数設定ブロック
  #-------------------------------------------------------------

  # connection_function_config (Required)
  # 設定内容: Connection Functionの設定情報を指定します。
  connection_function_config {
    # comment (Required)
    # 設定内容: 関数を説明するコメントを指定します。
    # 設定可能な値: 文字列
    comment = "Example connection function for mTLS certificate validation"

    # runtime (Required)
    # 設定内容: 関数のランタイム環境を指定します。
    # 設定可能な値:
    #   - "cloudfront-js-1.0": JavaScript runtime 1.0
    #   - "cloudfront-js-2.0": JavaScript runtime 2.0（推奨、Connection Functionで必須）
    # 関連機能: CloudFront Functions JavaScript ランタイム
    #   Connection Functionはcloudfront-js-2.0のみをサポートします。
    #   ECMAScript 2020構文、async/await、KeyValueStoreへのアクセスが可能です。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/connection-functions-overview.html
    runtime = "cloudfront-js-2.0"

    #-------------------------------------------------------------
    # Key Value Store関連付け（オプション）
    #-------------------------------------------------------------

    # key_value_store_association (Optional)
    # 設定内容: Key Value Storeとの関連付けを指定します。
    # 関連機能: CloudFront KeyValueStore
    #   Connection FunctionからKeyValueStoreにアクセスして、証明書失効リスト、
    #   デバイス許可リスト、テナント設定などの検証データを参照できます。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/write-connection-function-code.html
    key_value_store_association {
      # key_value_store_arn (Required)
      # 設定内容: Key Value StoreのARNを指定します。
      # 設定可能な値: 有効なCloudFront KeyValueStore ARN
      key_value_store_arn = "arn:aws:cloudfront::123456789012:key-value-store/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
  }

  #-------------------------------------------------------------
  # 公開設定
  #-------------------------------------------------------------

  # publish (Optional)
  # 設定内容: 作成または更新後に関数をLIVEステージに公開するかを指定します。
  # 設定可能な値:
  #   - true: 関数をLIVEステージに公開し、本番トラフィックで使用可能にする
  #   - false (デフォルト): DEVELOPMENTステージのみで、テスト用
  # 関連機能: CloudFront Functions ライフサイクル
  #   Connection Functionは2つのステージを持ちます:
  #   - DEVELOPMENT: 編集・テスト・更新が可能
  #   - LIVE: 本番トラフィックを処理（読み取り専用）
  #   関数をディストリビューションに関連付けるには、LIVEステージに公開する必要があります。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/connection-functions-overview.html
  publish = true

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-connection-function"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - connection_function_arn: Connection FunctionのAmazon Resource Name (ARN)
#
# - etag: Connection Functionの現在のバージョンのETag
#
# - id: Connection FunctionのID
#
# - live_stage_etag: 関数のLIVEステージのETag。
#                    関数が公開されていない場合は空になります。
#
# - status: Connection Functionのステータス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
