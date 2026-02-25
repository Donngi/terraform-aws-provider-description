#---------------------------------------------------------------
# AWS Kendra Data Source
#---------------------------------------------------------------
#
# Amazon Kendra のデータソースコネクターをプロビジョニングするリソースです。
# データソースは Amazon Kendra インデックスに接続するリポジトリを表し、
# S3、Web クローラー、カスタムコネクター、テンプレートベースのコネクターなど
# 複数のタイプをサポートします。インデックス同期のスケジュール設定や
# カスタムドキュメントエンリッチメントも設定できます。
#
# AWS公式ドキュメント:
#   - Amazon Kendra データソースコネクター: https://docs.aws.amazon.com/kendra/latest/dg/data-sources.html
#   - カスタムデータソースコネクター: https://docs.aws.amazon.com/kendra/latest/dg/data-source-custom.html
#   - IAMロール: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_data_source
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_data_source" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # index_id (Required, Forces new resource)
  # 設定内容: データソースを関連付ける Amazon Kendra インデックスの識別子を指定します。
  # 設定可能な値: 有効な Kendra インデックス ID
  index_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # name (Required)
  # 設定内容: データソースコネクターの名前を指定します。
  # 設定可能な値: 1〜1000 文字の文字列
  name = "example-data-source"

  # type (Required, Forces new resource)
  # 設定内容: データソースリポジトリのタイプを指定します。
  # 設定可能な値:
  #   - "CUSTOM": カスタムデータソース。configuration ブロックは指定不可。role_arn も指定不可
  #   - "S3": Amazon S3 バケット（非推奨。代わりに TEMPLATE タイプの使用を推奨）
  #   - "WEBCRAWLER": Web クローラー（非推奨。代わりに TEMPLATE タイプの使用を推奨）
  #   - "TEMPLATE": テンプレートベースのコネクター。各種コネクタータイプに対応
  #   その他の有効な値については公式ドキュメントを参照:
  #   https://docs.aws.amazon.com/kendra/latest/dg/API_CreateDataSource.html#Kendra-CreateDataSource-request-Type
  type = "CUSTOM"

  # description (Optional)
  # 設定内容: データソースコネクターの説明を指定します。
  # 設定可能な値: 最大 1000 文字の文字列
  # 省略時: 説明なし
  description = "example data source"

  # language_code (Optional)
  # 設定内容: データソース内のすべてのドキュメントをサポートする言語コードを指定します。
  # 設定可能な値: BCP-47 言語コード（例: "en"（英語）, "ja"（日本語）, "fr"（フランス語）等）
  #   サポートされている言語コードの一覧:
  #   https://docs.aws.amazon.com/kendra/latest/dg/in-adding-languages.html
  # 省略時: "en"（英語）
  language_code = "ja"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # role_arn (Optional)
  # 設定内容: データソースコネクターへのアクセス権限を持つ IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロール ARN
  # 省略時: null（type が "CUSTOM" の場合は指定不可。それ以外のタイプでは必須）
  # 注意: type が "CUSTOM" の場合はこの引数を指定できません
  # 参考: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
  role_arn = null

  # schedule (Optional)
  # 設定内容: Amazon Kendra がデータソースリポジトリのドキュメントを確認してインデックスを更新する
  #   頻度（スケジュール）を設定します。
  # 設定可能な値: cron 式の文字列（例: "cron(9 10 1 * ? *)"）
  # 省略時: スケジュールなし。StartDataSourceSyncJob API を呼び出して手動で更新する必要があります
  schedule = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-data-source"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # データソース設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: データソースリポジトリへの接続情報を設定するブロックです。
  #   type が "CUSTOM" の場合はこのブロックを指定できません。
  #   s3_configuration、template_configuration、web_crawler_configuration のいずれかを指定します。
  configuration {

    #-----------------------------------------------------------
    # テンプレート設定（type = "TEMPLATE" の場合に使用）
    #-----------------------------------------------------------

    # template_configuration (Required if type = "TEMPLATE")
    # 設定内容: テンプレートベースのデータソースコネクターの設定ブロックです。
    #   template_configuration と s3_configuration、web_crawler_configuration は排他的です。
    # 参考: https://docs.aws.amazon.com/kendra/latest/dg/ds-schemas.html
    template_configuration {

      # template (Required)
      # 設定内容: データソーステンプレートスキーマを含む JSON 文字列を指定します。
      #   jsonencode() 関数を使用してオブジェクトを JSON 文字列に変換できます。
      # 設定可能な値: データソーステンプレートスキーマに準拠した JSON 文字列
      # 参考: https://docs.aws.amazon.com/kendra/latest/dg/ds-schemas.html
      template = jsonencode({
        connectionConfiguration = {
          repositoryEndpointMetadata = {
            seedUrlConnections = [
              {
                seedUrl = "https://example.com"
              }
            ]
          }
        }
        version  = "1.0.0"
        syncMode = "FULL_CRAWL"
        type     = "WEBCRAWLERV2"
      })
    }

    #-----------------------------------------------------------
    # S3 設定（非推奨。type = "S3" の場合に使用）
    #-----------------------------------------------------------

    # s3_configuration (Deprecated, Required if type = "S3")
    # 設定内容: Amazon S3 バケットへの接続情報を設定するブロックです。
    # 注意: このブロックは非推奨です。type = "TEMPLATE" と template_configuration の使用を推奨します
    # s3_configuration {

    #   # bucket_name (Required)
    #   # 設定内容: ドキュメントが格納されている S3 バケット名を指定します。
    #   bucket_name = "example-kendra-documents"

    #   # exclusion_patterns (Optional)
    #   # 設定内容: インデックスに追加しないドキュメントの glob パターンのリストを指定します。
    #   # 設定可能な値: glob パターンの文字列セット（最大 100 項目）
    #   # 省略時: 除外パターンなし
    #   exclusion_patterns = ["*.tmp", "*.log"]

    #   # inclusion_patterns (Optional)
    #   # 設定内容: インデックスに追加するドキュメントの glob パターンのリストを指定します。
    #   # 設定可能な値: glob パターンの文字列セット（最大 100 項目）
    #   # 省略時: 包含パターンなし
    #   inclusion_patterns = ["*.pdf", "*.docx"]

    #   # inclusion_prefixes (Optional)
    #   # 設定内容: インデックスに追加するドキュメントの S3 プレフィックスのリストを指定します。
    #   # 設定可能な値: S3 プレフィックスの文字列セット
    #   # 省略時: プレフィックスフィルターなし
    #   inclusion_prefixes = ["documents/", "reports/"]

    #   # access_control_list_configuration (Optional)
    #   # 設定内容: データソースのユーザーコンテキストフィルタリングファイルが含まれる
    #   #   S3 バケットへのパスを指定するブロックです。
    #   # 参考: https://docs.aws.amazon.com/kendra/latest/dg/s3-acl.html
    #   access_control_list_configuration {
    #     # key_path (Optional)
    #     # 設定内容: ACL ファイルが含まれている S3 バケットへのパスを指定します。
    #     key_path = "s3://example-kendra-documents/acl/"
    #   }

    #   # documents_metadata_configuration (Optional)
    #   # 設定内容: ドキュメントのアクセス制御情報やカスタム属性などのメタデータファイルの
    #   #   定義を指定するブロックです。
    #   documents_metadata_configuration {
    #     # s3_prefix (Optional)
    #     # 設定内容: AWS S3 バケット内のメタデータ設定ファイルのフィルタリングに使用する
    #     #   プレフィックスを指定します。
    #     s3_prefix = "metadata/"
    #   }
    # }

    #-----------------------------------------------------------
    # Web クローラー設定（非推奨。type = "WEBCRAWLER" の場合に使用）
    #-----------------------------------------------------------

    # web_crawler_configuration (Deprecated, Required if type = "WEBCRAWLER")
    # 設定内容: Web クローラーの設定ブロックです。
    # 注意: このブロックは非推奨です。type = "TEMPLATE" と template_configuration の使用を推奨します
    # web_crawler_configuration {

    #   # urls (Required)
    #   # 設定内容: クロールする Web サイトのシード URL またはサイトマップ URL を指定するブロックです。
    #   urls {

    #     # seed_url_configuration (Optional)
    #     # 設定内容: クロールする Web サイトのシード URL の設定ブロックです。
    #     seed_url_configuration {
    #       # seed_urls (Required)
    #       # 設定内容: クロール開始点となる URL のリストを指定します。最大 100 件。
    #       seed_urls = ["https://example.com"]

    #       # web_crawler_mode (Optional)
    #       # 設定内容: クローラーが URL を展開するモードを指定します。
    #       # 設定可能な値:
    #       #   - "HOST_ONLY": シード URL と同一ホスト名のみクロール（デフォルト）
    #       #   - "SUBDOMAINS": ホスト名とサブドメインをクロール
    #       #   - "EVERYTHING": ホスト名、サブドメイン、リンク先のドメインをクロール
    #       web_crawler_mode = "HOST_ONLY"
    #     }

    #     # site_maps_configuration (Optional)
    #     # 設定内容: クロールする Web サイトのサイトマップ URL の設定ブロックです。最大 3 件。
    #     site_maps_configuration {
    #       # site_maps (Required)
    #       # 設定内容: クロールする Web サイトのサイトマップ URL のリストを指定します。
    #       site_maps = ["https://example.com/sitemap.xml"]
    #     }
    #   }

    #   # crawl_depth (Optional)
    #   # 設定内容: クロールする Web サイトのレベル数を指定します。
    #   # 設定可能な値: 0〜10 の整数
    #   # 省略時: 2
    #   crawl_depth = 2

    #   # max_content_size_per_page_in_mega_bytes (Optional)
    #   # 設定内容: クロールする Web ページや添付ファイルの最大サイズ（MB）を指定します。
    #   #   この値より大きいファイルはスキップされます。
    #   # 設定可能な値: 0.000001〜50 の数値
    #   # 省略時: 50
    #   max_content_size_per_page_in_mega_bytes = 50

    #   # max_links_per_page (Optional)
    #   # 設定内容: Web ページをクロールするときに含める URL の最大数を指定します。
    #   # 設定可能な値: 1〜1000 の整数
    #   # 省略時: 100
    #   max_links_per_page = 100

    #   # max_urls_per_minute_crawl_rate (Optional)
    #   # 設定内容: Web サイトホストごとに 1 分間にクロールする URL の最大数を指定します。
    #   # 設定可能な値: 1〜300 の整数
    #   # 省略時: 300
    #   max_urls_per_minute_crawl_rate = 300

    #   # url_exclusion_patterns (Optional)
    #   # 設定内容: クロールから除外する URL の正規表現パターンのリストを指定します。
    #   # 設定可能な値: 正規表現文字列のセット（最大 100 項目、各最大 150 文字）
    #   url_exclusion_patterns = [".*\\.pdf$"]

    #   # url_inclusion_patterns (Optional)
    #   # 設定内容: クロールに含める URL の正規表現パターンのリストを指定します。
    #   # 設定可能な値: 正規表現文字列のセット（最大 100 項目、各最大 150 文字）
    #   url_inclusion_patterns = ["https://example\\.com/.*"]

    #   # authentication_configuration (Optional)
    #   # 設定内容: 基本認証を使用して Web サイトに接続するための設定ブロックです。
    #   authentication_configuration {
    #     # basic_authentication (Optional)
    #     # 設定内容: 基本認証の設定ブロックです。最大 10 件指定可能。
    #     basic_authentication {
    #       # credentials (Required)
    #       # 設定内容: 基本認証の認証情報を格納する AWS Secrets Manager シークレットの ARN を指定します。
    #       credentials = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:kendra-webcrawler-credentials"

    #       # host (Required)
    #       # 設定内容: 接続する Web サイトのホスト名を指定します。
    #       host = "a.example.com"

    #       # port (Required)
    #       # 設定内容: 接続する Web サイトのポート番号を指定します。
    #       # 設定可能な値: 1〜65535 の整数
    #       port = 443
    #     }
    #   }

    #   # proxy_configuration (Optional)
    #   # 設定内容: 内部 Web サイトへの接続に使用する Web プロキシの設定ブロックです。
    #   proxy_configuration {
    #     # host (Required)
    #     # 設定内容: Web プロキシサーバーのホスト名を指定します。
    #     host = "proxy.example.com"

    #     # port (Required)
    #     # 設定内容: Web プロキシサーバーのポート番号を指定します。
    #     # 設定可能な値: 1〜65535 の整数
    #     port = 8080

    #     # credentials (Optional)
    #     # 設定内容: Web プロキシの認証情報を格納する AWS Secrets Manager シークレットの ARN を指定します。
    #     # 省略時: プロキシ認証なし
    #     credentials = null
    #   }
    # }
  }

  #-------------------------------------------------------------
  # カスタムドキュメントエンリッチメント設定
  #-------------------------------------------------------------

  # custom_document_enrichment_configuration (Optional)
  # 設定内容: ドキュメントの取り込み処理中にドキュメントのメタデータとコンテンツを
  #   変更するための設定ブロックです。
  # 参考: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html
  custom_document_enrichment_configuration {

    # role_arn (Optional)
    # 設定内容: pre_extraction_hook_configuration および post_extraction_hook_configuration を
    #   実行するための権限を持つ IAM ロールの ARN を指定します。
    # 設定可能な値: 有効な IAM ロール ARN
    # 省略時: null
    # 参考: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
    role_arn = null

    #-----------------------------------------------------------
    # インライン設定
    #-----------------------------------------------------------

    # inline_configurations (Optional)
    # 設定内容: Amazon Kendra へのドキュメント取り込み時にドキュメント属性またはメタデータ
    #   フィールドおよびコンテンツを変更するための設定ブロックです。最大 100 件。
    inline_configurations {

      # document_content_deletion (Optional)
      # 設定内容: ターゲット属性に使用される条件が満たされた場合にコンテンツを削除するかを指定します。
      # 設定可能な値:
      #   - true: 条件が満たされた場合にコンテンツを削除
      #   - false: コンテンツを削除しない
      # 省略時: false
      document_content_deletion = false

      # condition (Optional)
      # 設定内容: ドキュメントの取り込み時にターゲットドキュメント属性またはメタデータフィールドに
      #   使用する条件の設定ブロックです。
      condition {

        # condition_document_attribute_key (Required)
        # 設定内容: 条件に使用するドキュメント属性の識別子を指定します。
        # 設定可能な値: "_source_uri" 等の属性キー文字列。"_document_body" は現在サポート外
        condition_document_attribute_key = "_source_uri"

        # operator (Required)
        # 設定内容: 条件の演算子を指定します。
        # 設定可能な値:
        #   - "GreaterThan": より大きい
        #   - "GreaterThanOrEquals": 以上
        #   - "LessThan": より小さい
        #   - "LessThanOrEquals": 以下
        #   - "Equals": 等しい
        #   - "NotEquals": 等しくない
        #   - "Contains": 含む
        #   - "NotContains": 含まない
        #   - "Exists": 存在する
        #   - "NotExists": 存在しない
        #   - "BeginsWith": から始まる
        operator = "Contains"

        # condition_on_value (Optional)
        # 設定内容: 演算子が使用する値の設定ブロックです。
        condition_on_value {

          # string_value (Optional)
          # 設定内容: 文字列値を指定します。
          # 設定可能な値: 文字列
          string_value = "example"

          # string_list_value (Optional)
          # 設定内容: 文字列のリストを指定します。
          # 設定可能な値: 文字列のセット
          # 省略時: null
          string_list_value = null

          # long_value (Optional)
          # 設定内容: 長整数値を指定します。
          # 設定可能な値: 整数
          # 省略時: null
          long_value = null

          # date_value (Optional)
          # 設定内容: ISO 8601 形式の日付文字列を指定します。タイムゾーンの含めることが重要です。
          # 設定可能な値: ISO 8601 形式の日付時刻文字列（例: "2024-01-01T00:00:00+00:00"）
          # 省略時: null
          date_value = null
        }
      }

      # target (Optional)
      # 設定内容: Amazon Kendra へのドキュメント取り込み時のターゲットドキュメント属性または
      #   メタデータフィールドの設定ブロックです。
      target {

        # target_document_attribute_key (Optional)
        # 設定内容: ターゲットドキュメント属性またはメタデータフィールドの識別子を指定します。
        # 設定可能な値: 属性キー文字列（例: "Department"）
        # 省略時: null
        target_document_attribute_key = "Department"

        # target_document_attribute_value_deletion (Optional)
        # 設定内容: 指定したターゲット属性キーの既存の値を削除するかを指定します。
        # 設定可能な値:
        #   - true: 既存の値を削除（target_document_attribute_value との同時指定は不可）
        #   - false: 値を削除しない
        # 省略時: false
        target_document_attribute_value_deletion = false

        # target_document_attribute_value (Optional)
        # 設定内容: ターゲット属性に設定する値の設定ブロックです。
        target_document_attribute_value {

          # string_value (Optional)
          # 設定内容: 文字列値を指定します。
          # 設定可能な値: 文字列（例: "Finance"）
          string_value = "Engineering"

          # string_list_value (Optional)
          # 設定内容: 文字列のリストを指定します。
          # 設定可能な値: 文字列のセット
          # 省略時: null
          string_list_value = null

          # long_value (Optional)
          # 設定内容: 長整数値を指定します。
          # 設定可能な値: 整数
          # 省略時: null
          long_value = null

          # date_value (Optional)
          # 設定内容: ISO 8601 形式の日付文字列を指定します。
          # 設定可能な値: ISO 8601 形式の日付時刻文字列（例: "2024-01-01T00:00:00+00:00"）
          # 省略時: null
          date_value = null
        }
      }
    }

    #-----------------------------------------------------------
    # 抽出後フック設定
    #-----------------------------------------------------------

    # post_extraction_hook_configuration (Optional)
    # 設定内容: メタデータとテキストが抽出された構造化ドキュメントに対して AWS Lambda 関数を
    #   呼び出すための設定ブロックです。ドキュメントメタデータとコンテンツの高度な
    #   作成・変更・削除ロジックを適用できます。
    # 参考: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html#advanced-data-manipulation
    post_extraction_hook_configuration {

      # lambda_arn (Required)
      # 設定内容: ドキュメントメタデータフィールドや属性、コンテンツを操作できる
      #   Lambda 関数の ARN を指定します。
      lambda_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:kendra-post-extraction"

      # s3_bucket (Required)
      # 設定内容: Lambda 関数の処理前後の元のドキュメントまたは構造化ドキュメントを
      #   保存する S3 バケット名を指定します。
      # 参考: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html#cde-data-contracts-lambda
      s3_bucket = "example-kendra-enrichment-bucket"

      # invocation_condition (Optional)
      # 設定内容: Lambda 関数を呼び出す条件の設定ブロックです。
      invocation_condition {

        # condition_document_attribute_key (Required)
        # 設定内容: 条件に使用するドキュメント属性の識別子を指定します。
        condition_document_attribute_key = "_source_uri"

        # operator (Required)
        # 設定内容: 条件の演算子を指定します。
        # 設定可能な値: "GreaterThan" | "GreaterThanOrEquals" | "LessThan" | "LessThanOrEquals" |
        #   "Equals" | "NotEquals" | "Contains" | "NotContains" | "Exists" | "NotExists" | "BeginsWith"
        operator = "Exists"

        # condition_on_value (Optional)
        # 設定内容: 演算子が使用する値の設定ブロックです。
        condition_on_value {

          # string_value (Optional)
          # 設定内容: 文字列値を指定します。
          string_value = null

          # string_list_value (Optional)
          # 設定内容: 文字列のリストを指定します。
          # 省略時: null
          string_list_value = null

          # long_value (Optional)
          # 設定内容: 長整数値を指定します。
          # 省略時: null
          long_value = null

          # date_value (Optional)
          # 設定内容: ISO 8601 形式の日付文字列を指定します。
          # 省略時: null
          date_value = null
        }
      }
    }

    #-----------------------------------------------------------
    # 抽出前フック設定
    #-----------------------------------------------------------

    # pre_extraction_hook_configuration (Optional)
    # 設定内容: メタデータとテキストを抽出する前の元のドキュメントに対して AWS Lambda 関数を
    #   呼び出すための設定ブロックです。ドキュメントメタデータとコンテンツの高度な
    #   作成・変更・削除ロジックを適用できます。
    # 参考: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html#advanced-data-manipulation
    pre_extraction_hook_configuration {

      # lambda_arn (Required)
      # 設定内容: ドキュメントメタデータフィールドや属性、コンテンツを操作できる
      #   Lambda 関数の ARN を指定します。
      lambda_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:kendra-pre-extraction"

      # s3_bucket (Required)
      # 設定内容: Lambda 関数の処理前後の元のドキュメントまたは構造化ドキュメントを
      #   保存する S3 バケット名を指定します。
      s3_bucket = "example-kendra-enrichment-bucket"

      # invocation_condition (Optional)
      # 設定内容: Lambda 関数を呼び出す条件の設定ブロックです。
      invocation_condition {

        # condition_document_attribute_key (Required)
        # 設定内容: 条件に使用するドキュメント属性の識別子を指定します。
        condition_document_attribute_key = "_source_uri"

        # operator (Required)
        # 設定内容: 条件の演算子を指定します。
        # 設定可能な値: "GreaterThan" | "GreaterThanOrEquals" | "LessThan" | "LessThanOrEquals" |
        #   "Equals" | "NotEquals" | "Contains" | "NotContains" | "Exists" | "NotExists" | "BeginsWith"
        operator = "Exists"

        # condition_on_value (Optional)
        # 設定内容: 演算子が使用する値の設定ブロックです。
        condition_on_value {

          # string_value (Optional)
          # 設定内容: 文字列値を指定します。
          string_value = null

          # string_list_value (Optional)
          # 設定内容: 文字列のリストを指定します。
          # 省略時: null
          string_list_value = null

          # long_value (Optional)
          # 設定内容: 長整数値を指定します。
          # 省略時: null
          long_value = null

          # date_value (Optional)
          # 設定内容: ISO 8601 形式の日付文字列を指定します。
          # 省略時: null
          date_value = null
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: データソースの Amazon Resource Name (ARN)
# - created_at: データソースが作成された Unix タイムスタンプ
# - data_source_id: データソースの一意の識別子
# - error_message: status が "FAILED" の場合に失敗の原因となったエラーの説明
# - id: データソースの一意識別子とインデックス ID をスラッシュ (/) で結合した値
# - status: データソースの現在のステータス（"ACTIVE", "FAILED" 等）
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグのマップ
# - updated_at: データソースが最後に更新された Unix タイムスタンプ
#---------------------------------------------------------------
