#---------------------------------------------------------------
# AWS S3 Bucket Website Configuration
#---------------------------------------------------------------
#
# Amazon S3バケットの静的ウェブサイトホスティング設定をプロビジョニングするリソースです。
# インデックスドキュメント・エラードキュメントの指定や、リクエストのリダイレクト設定が可能です。
# このリソースはS3ディレクトリバケットでは使用できません。
#
# AWS公式ドキュメント:
#   - S3静的ウェブサイトホスティング: https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html
#   - ウェブサイトエンドポイント: https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteEndpoints.html
#   - ウェブホスティング有効化: https://docs.aws.amazon.com/AmazonS3/latest/userguide/EnableWebsiteHosting.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_website_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required, Forces new resource)
  # 設定内容: ウェブサイトホスティングを設定するS3バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  bucket = "my-static-website-bucket"

  # expected_bucket_owner (Optional, Forces new resource)
  # 設定内容: バケットを所有すると期待するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: バケット所有者の確認を行いません。
  # 注意: このパラメータは非推奨（Deprecated）です。将来のバージョンで削除される予定です。
  expected_bucket_owner = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # インデックスドキュメント設定
  #-------------------------------------------------------------

  # index_document (Optional)
  # 設定内容: ウェブサイトのインデックスドキュメントの設定ブロックです。
  # 注意: redirect_all_requests_to を指定しない場合は必須です。
  #       redirect_all_requests_to、routing_rule と同時指定不可。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/IndexDocumentSupport.html
  index_document {

    # suffix (Required)
    # 設定内容: ウェブサイトエンドポイントへのリクエストがディレクトリに対して行われた
    #          場合に追加するサフィックスを指定します。
    #          例: suffix が index.html で samplebucket/images/ へリクエストされた場合、
    #          images/index.html のオブジェクトが返されます。
    # 設定可能な値: 空文字・スラッシュを含まない文字列
    suffix = "index.html"
  }

  #-------------------------------------------------------------
  # エラードキュメント設定
  #-------------------------------------------------------------

  # error_document (Optional)
  # 設定内容: 4XXクラスのエラーが発生した際に返すエラードキュメントの設定ブロックです。
  # 注意: redirect_all_requests_to と同時指定不可。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/CustomErrorDocSupport.html
  error_document {

    # key (Required)
    # 設定内容: 4XXクラスのエラー発生時に使用するオブジェクトのキー名を指定します。
    # 設定可能な値: 有効なS3オブジェクトキー名（例: error.html）
    key = "error.html"
  }

  #-------------------------------------------------------------
  # 全リクエストリダイレクト設定
  #-------------------------------------------------------------

  # redirect_all_requests_to (Optional)
  # 設定内容: このバケットのウェブサイトエンドポイントへの全リクエストをリダイレクトする
  #          設定ブロックです。
  # 注意: index_document を指定しない場合は必須です。
  #       error_document、index_document、routing_rule と同時指定不可。
  # redirect_all_requests_to {

    # host_name (Required)
    # 設定内容: リダイレクト先のホスト名を指定します。
    # 設定可能な値: 有効なホスト名（例: example.com）
    # host_name = "example.com"

    # protocol (Optional)
    # 設定内容: リダイレクト時に使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "http": HTTPプロトコルを使用
    #   - "https": HTTPSプロトコルを使用
    # 省略時: 元のリクエストで使用されたプロトコルを使用します。
    # protocol = "https"
  # }

  #-------------------------------------------------------------
  # ルーティングルール設定
  #-------------------------------------------------------------

  # routing_rule (Optional)
  # 設定内容: リダイレクトを適用するタイミングとリダイレクト動作を定義するルールの
  #          リストを指定する設定ブロックです。
  # 注意: redirect_all_requests_to および routing_rules と同時指定不可。
  routing_rule {

    #-------------------------------------------------------------
    # ルーティング条件設定
    #-------------------------------------------------------------

    # condition (Optional)
    # 設定内容: リダイレクトを適用するための条件を記述する設定ブロックです。
    condition {

      # http_error_code_returned_equals (Optional)
      # 設定内容: リダイレクトを適用するHTTPエラーコードを指定します。
      # 設定可能な値: 有効なHTTPエラーコードの文字列（例: "404"）
      # 省略時: key_prefix_equals が必須となります。
      # 注意: key_prefix_equals と組み合わせた場合、両方の条件が真の場合にリダイレクトが適用されます。
      http_error_code_returned_equals = null

      # key_prefix_equals (Optional)
      # 設定内容: リダイレクトを適用するオブジェクトキー名のプレフィックスを指定します。
      # 設定可能な値: 有効なS3オブジェクトキープレフィックスの文字列（例: "docs/"）
      # 省略時: http_error_code_returned_equals が必須となります。
      # 注意: http_error_code_returned_equals と組み合わせた場合、両方の条件が真の場合にリダイレクトが適用されます。
      key_prefix_equals = "docs/"
    }

    #-------------------------------------------------------------
    # リダイレクト先設定
    #-------------------------------------------------------------

    # redirect (Required)
    # 設定内容: リダイレクト先の情報を記述する設定ブロックです。
    redirect {

      # host_name (Optional)
      # 設定内容: リダイレクトリクエストで使用するホスト名を指定します。
      # 設定可能な値: 有効なホスト名の文字列
      # 省略時: 元のリクエストのホスト名を使用します。
      host_name = null

      # http_redirect_code (Optional)
      # 設定内容: レスポンスで使用するHTTPリダイレクトコードを指定します。
      # 設定可能な値: 有効なHTTPリダイレクトコードの文字列（例: "301", "302"）
      # 省略時: AWSのデフォルトリダイレクトコードが使用されます。
      http_redirect_code = null

      # protocol (Optional)
      # 設定内容: リダイレクトリクエストで使用するプロトコルを指定します。
      # 設定可能な値:
      #   - "http": HTTPプロトコルを使用
      #   - "https": HTTPSプロトコルを使用
      # 省略時: 元のリクエストで使用されたプロトコルを使用します。
      protocol = null

      # replace_key_prefix_with (Optional)
      # 設定内容: リダイレクトリクエストで使用するオブジェクトキープレフィックスを指定します。
      # 設定可能な値: 有効なS3オブジェクトキープレフィックスの文字列
      # 省略時: 元のキープレフィックスが使用されます。
      # 注意: replace_key_with と同時指定不可。
      replace_key_prefix_with = "documents/"

      # replace_key_with (Optional)
      # 設定内容: リダイレクトリクエストで使用する特定のオブジェクトキーを指定します。
      # 設定可能な値: 有効なS3オブジェクトキーの文字列（例: "error.html"）
      # 省略時: 元のオブジェクトキーが使用されます。
      # 注意: replace_key_prefix_with と同時指定不可。
      replace_key_with = null
    }
  }

  #-------------------------------------------------------------
  # ルーティングルールJSON設定
  #-------------------------------------------------------------

  # routing_rules (Optional)
  # 設定内容: リダイレクト動作とリダイレクト適用条件を記述するルーティングルールの
  #          JSON配列を指定します。
  #          ルーティングルールに空文字列（""）を含む場合はこのパラメータを使用します。
  # 設定可能な値: 有効なルーティングルールのJSON文字列
  # 省略時: ルーティングルールは設定されません。
  # 注意: routing_rule および redirect_all_requests_to と同時指定不可。
  # 参考: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration-routingrules.html
  routing_rules = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バケット名、またはexpected_bucket_ownerが指定された場合は
#       バケット名とアカウントIDをカンマ区切りで結合した値
#
# - website_domain: ウェブサイトエンドポイントのドメイン名。
#                   Route 53エイリアスレコードの作成に使用します。
#
# - website_endpoint: ウェブサイトエンドポイントのURL。
#---------------------------------------------------------------
