#---------------------------------------------------------------
# Amazon Kendra Data Source
#---------------------------------------------------------------
#
# Amazon Kendra Data Sourceは、Amazon Kendraインデックスに接続するデータリポジトリ
# または場所を管理するリソースです。S3バケット、Microsoft SharePoint、Webクローラー
# など、様々なデータソースからドキュメントやコンテンツをインデックス化できます。
# データソースを自動的に同期することで、追加・更新・削除されたドキュメントを
# インデックスに反映させることができます。
#
# AWS公式ドキュメント:
#   - Data sources: https://docs.aws.amazon.com/kendra/latest/dg/hiw-data-source.html
#   - CreateDataSource API: https://docs.aws.amazon.com/kendra/latest/dg/API_CreateDataSource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_data_source
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_data_source" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # index_id - Amazon Kendraインデックスの識別子
  # このデータソースが接続されるKendraインデックスのIDを指定します。
  # この値を変更すると、リソースが再作成されます（Forces new resource）。
  index_id = "your-kendra-index-id"

  # name - データソースコネクタの名前
  # データソースを識別するための名前を指定します。
  name = "example-data-source"

  # type - データソースリポジトリのタイプ
  # サポートされているタイプ: S3, WEBCRAWLER, TEMPLATE, CUSTOM など
  # 詳細は以下を参照:
  # https://docs.aws.amazon.com/kendra/latest/dg/API_CreateDataSource.html#Kendra-CreateDataSource-request-Type
  # この値を変更すると、リソースが再作成されます（Forces new resource）。
  type = "S3"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # description - データソースコネクタの説明
  # データソースの用途や内容を説明するテキストを指定します。
  description = "Example data source for Kendra"

  # language_code - 言語コード
  # データソース作成時にすべてのドキュメントに対してサポートする言語を指定します。
  # 英語はデフォルトでサポートされています。
  # サポートされている言語とコードの詳細:
  # https://docs.aws.amazon.com/kendra/latest/dg/in-adding-languages.html
  # 未指定の場合は計算された値が使用されます。
  language_code = "en"

  # region - リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 未指定の場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # role_arn - IAMロールのARN
  # データソースコネクタへのアクセス権限を持つIAMロールのARNを指定します。
  # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
  # 注意: typeがCUSTOMの場合、このパラメータは指定できません。
  # その他のすべてのデータソースでは必須です。
  role_arn = "arn:aws:iam::123456789012:role/KendraDataSourceRole"

  # schedule - 同期スケジュール
  # Amazon Kendraがデータソースリポジトリのドキュメントをチェックし、
  # インデックスを更新する頻度を設定します。
  # cron式で指定します。例: "cron(9 10 1 * ? *)"
  # 指定しない場合、定期的な更新は行われません。
  # StartDataSourceSyncJob APIを使用して手動で更新できます。
  schedule = null

  # tags - リソースタグ
  # リソースに付与するタグのキー・バリューマップ。
  # プロバイダーのdefault_tagsと組み合わせて使用されます。
  tags = {
    Environment = "production"
    Project     = "search-platform"
  }

  #---------------------------------------------------------------
  # configuration ブロック
  #---------------------------------------------------------------
  # データソースリポジトリに接続するための設定情報を指定します。
  # typeがCUSTOMの場合、このブロックは指定できません。

  configuration {
    #---------------------------------------------------------------
    # s3_configuration ブロック (非推奨: Deprecated)
    #---------------------------------------------------------------
    # typeがS3の場合に必須。
    # Amazon S3バケットをデータソースとして接続するための設定。
    # 注意: このブロックは非推奨です。代わりにtemplate_configurationの使用を検討してください。

    s3_configuration {
      # bucket_name - バケット名（必須）
      # ドキュメントを含むS3バケットの名前を指定します。
      bucket_name = "your-s3-bucket-name"

      # exclusion_patterns - 除外パターン
      # インデックス化すべきでないドキュメントのglobパターンのリスト。
      # 包含プレフィックスまたは包含パターンに一致するドキュメントでも、
      # 除外パターンに一致する場合はインデックス化されません。
      # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/API_S3DataSourceConfiguration.html#Kendra-Type-S3DataSourceConfiguration-ExclusionPatterns
      exclusion_patterns = ["*.tmp", "temp/*"]

      # inclusion_patterns - 包含パターン
      # インデックス化すべきドキュメントのglobパターンのリスト。
      # 除外パターンにも一致する場合は、除外が優先されます。
      # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/API_S3DataSourceConfiguration.html#Kendra-Type-S3DataSourceConfiguration-InclusionPatterns
      inclusion_patterns = ["documents/*.pdf", "*.docx"]

      # inclusion_prefixes - 包含プレフィックス
      # インデックスに含めるべきドキュメントのS3プレフィックスのリスト。
      inclusion_prefixes = ["documents/", "public/"]

      #---------------------------------------------------------------
      # access_control_list_configuration ブロック
      #---------------------------------------------------------------
      # ユーザーコンテキストフィルタリングファイルを含むS3バケットへのパスを指定します。
      # ファイル形式の詳細: https://docs.aws.amazon.com/kendra/latest/dg/s3-acl.html

      access_control_list_configuration {
        # key_path - ACLファイルのパス
        # ACLファイルを含むAWS S3バケットへのパスを指定します。
        key_path = "s3://your-s3-bucket-name/acl/"
      }

      #---------------------------------------------------------------
      # documents_metadata_configuration ブロック
      #---------------------------------------------------------------
      # ドキュメントアクセス制御情報、ソースURI、ドキュメント作成者、
      # カスタム属性などの情報を含むドキュメントメタデータファイルを定義します。
      # 各メタデータファイルには、単一のドキュメントに関するメタデータが含まれます。

      documents_metadata_configuration {
        # s3_prefix - メタデータファイルのプレフィックス
        # AWS S3バケット内のメタデータ設定ファイルをフィルタリングするために使用されるプレフィックス。
        # S3バケットには複数のメタデータファイルが含まれる場合があります。
        # s3_prefixを使用して、必要なメタデータファイルのみを含めます。
        s3_prefix = "metadata/"
      }
    }

    #---------------------------------------------------------------
    # template_configuration ブロック
    #---------------------------------------------------------------
    # typeがTEMPLATEの場合に必須。
    # Amazon Kendra Web Crawlerなどに必要な設定情報を提供します。

    # template_configuration {
    #   # template - データソーステンプレートスキーマ（必須）
    #   # データソーステンプレートスキーマを含むJSON文字列。
    #   # スキーマの詳細: https://docs.aws.amazon.com/kendra/latest/dg/ds-schemas.html
    #   template = jsonencode({
    #     connectionConfiguration = {
    #       repositoryEndpointMetadata = {
    #         seedUrlConnections = [
    #           {
    #             seedUrl = "https://example.com"
    #           }
    #         ]
    #       }
    #     }
    #     additionalProperties = {
    #       inclusionURLIndexPatterns = [
    #         "https://example\\.com/.*"
    #       ]
    #     }
    #     version  = "1.0.0"
    #     syncMode = "FULL_CRAWL"
    #     type     = "WEBCRAWLERV2"
    #   })
    # }

    #---------------------------------------------------------------
    # web_crawler_configuration ブロック (非推奨: Deprecated)
    #---------------------------------------------------------------
    # typeがWEBCRAWLERの場合に必須。
    # Amazon Kendra Web Crawlerに必要な設定情報を提供します。
    # 注意: このブロックは非推奨です。代わりにtemplate_configurationの使用を検討してください。

    # web_crawler_configuration {
    #   # crawl_depth - クロール深度
    #   # ウェブサイトでクロールするレベル数を指定します。
    #   # 最初のレベルは、ウェブサイトのシードまたは開始点URLから始まります。
    #   # 例: ウェブサイトに3つのレベル（インデックスレベル、セクションレベル、
    #   # サブセクションレベル）がある場合、セクションレベル（レベル0-1）までの
    #   # 情報のみをクロールしたい場合は、深度を1に設定できます。
    #   # デフォルトのクロール深度は2に設定されています。
    #   # 最小値: 0、最大値: 10
    #   crawl_depth = 2
    #
    #   # max_content_size_per_page_in_mega_bytes - ページあたりの最大コンテンツサイズ
    #   # クロールするウェブページまたは添付ファイルの最大サイズ（MB単位）。
    #   # このサイズ（MB単位）より大きいファイルはスキップ/クロールされません。
    #   # デフォルトの最大サイズは50 MBに設定されています。
    #   # 最小値: 1.0e-06、最大値: 50
    #   max_content_size_per_page_in_mega_bytes = 50
    #
    #   # max_links_per_page - ページあたりの最大リンク数
    #   # ウェブサイトをクロールする際にウェブページに含める最大URL数。
    #   # この数はウェブページごとです。ウェブサイトのウェブページがクロールされると、
    #   # ウェブページがリンクしているURLもクロールされます。
    #   # ウェブページ上のURLは出現順にクロールされます。
    #   # デフォルトのページあたりの最大リンク数は100です。
    #   # 最小値: 1、最大値: 1000
    #   max_links_per_page = 100
    #
    #   # max_urls_per_minute_crawl_rate - 分あたりの最大URL数
    #   # ウェブサイトホストごとに1分間にクロールされる最大URL数。
    #   # デフォルトの最大URL数は300です。
    #   # 最小値: 1、最大値: 300
    #   max_urls_per_minute_crawl_rate = 300
    #
    #   # url_exclusion_patterns - URL除外パターン
    #   # クロールから除外する特定のURLの正規表現パターンのリスト。
    #   # パターンに一致するURLはインデックスから除外されます。
    #   # 包含パターンと除外パターンの両方に一致する場合、除外パターンが優先され、
    #   # URLファイルはインデックスに含まれません。
    #   # 配列メンバー: 最小0項目、最大100項目
    #   # 長さの制約: 最小長1、最大長150
    #   url_exclusion_patterns = [".*\\.pdf$", ".*private.*"]
    #
    #   # url_inclusion_patterns - URL包含パターン
    #   # クロールに含める特定のURLの正規表現パターンのリスト。
    #   # パターンに一致するURLはインデックスに含まれます。
    #   # 包含パターンと除外パターンの両方に一致する場合、除外パターンが優先され、
    #   # URLファイルはインデックスに含まれません。
    #   # 配列メンバー: 最小0項目、最大100項目
    #   # 長さの制約: 最小長1、最大長150
    #   url_inclusion_patterns = ["https://example\\.com/docs/.*"]
    #
    #   #---------------------------------------------------------------
    #   # authentication_configuration ブロック
    #   #---------------------------------------------------------------
    #   # 認証を使用してウェブサイトに接続するために必要な設定情報。
    #   # ユーザー名とパスワードの基本認証を使用してウェブサイトに接続できます。
    #   # AWS Secrets Managerのシークレットを使用して認証資格情報を保存します。
    #   # ウェブサイトのホスト名とポート番号を提供する必要があります。
    #
    #   # authentication_configuration {
    #   #   #---------------------------------------------------------------
    #   #   # basic_authentication ブロック
    #   #   #---------------------------------------------------------------
    #   #   # 基本認証資格情報を使用してウェブサイトホストに接続し、クロールするために
    #   #   # 必要な設定情報のリスト。このリストには、ウェブサイトホストの名前と
    #   #   # ポート番号が含まれます。
    #   #   # 最大10項目まで指定可能。
    #   #
    #   #   basic_authentication {
    #   #     # credentials - シークレットARN（必須）
    #   #     # AWS Secrets Managerで作成できるシークレットARN。
    #   #     # ウェブサイトへの接続に基本認証資格情報が必要な場合にシークレットを使用します。
    #   #     # シークレットには、ユーザー名とパスワードの資格情報が保存されます。
    #   #     credentials = "arn:aws:secretsmanager:region:account-id:secret:secret-name"
    #   #
    #   #     # host - ホスト名（必須）
    #   #     # 認証資格情報を使用して接続するウェブサイトホストの名前。
    #   #     # 例: https://a.example.com/page1.htmlのホスト名は"a.example.com"です。
    #   #     host = "a.example.com"
    #   #
    #   #     # port - ポート番号（必須）
    #   #     # 認証資格情報を使用して接続するウェブサイトホストのポート番号。
    #   #     # 例: https://a.example.com/page1.htmlのポートは443（HTTPSの標準ポート）です。
    #   #     port = 443
    #   #   }
    #   # }
    #
    #   #---------------------------------------------------------------
    #   # proxy_configuration ブロック
    #   #---------------------------------------------------------------
    #   # Webプロキシサーバー経由で内部ウェブサイトに接続するために必要な設定情報。
    #   # ウェブサイトのホスト名とポート番号を提供する必要があります。
    #   # Webプロキシ資格情報はオプションで、基本認証を必要とするWebプロキシサーバーに
    #   # 接続するために使用できます。Webプロキシ資格情報を保存するには、
    #   # AWS Secrets Managerでシークレットを使用します。
    #
    #   # proxy_configuration {
    #   #   # credentials - シークレットARN
    #   #   # AWS Secrets Managerで作成できるシークレットARN。
    #   #   # 資格情報はオプションです。ウェブサイトホストへの接続に
    #   #   # Webプロキシ資格情報が必要な場合にシークレットを使用します。
    #   #   # 現在、Amazon Kendraは基本認証をサポートしてWebプロキシサーバーに接続します。
    #   #   # シークレットには資格情報が保存されます。
    #   #   credentials = "arn:aws:secretsmanager:region:account-id:secret:secret-name"
    #   #
    #   #   # host - ホスト名（必須）
    #   #   # Webプロキシサーバー経由で接続するウェブサイトホストの名前。
    #   #   # 例: https://a.example.com/page1.htmlのホスト名は"a.example.com"です。
    #   #   host = "proxy.example.com"
    #   #
    #   #   # port - ポート番号（必須）
    #   #   # Webプロキシサーバー経由で接続するウェブサイトホストのポート番号。
    #   #   # 例: https://a.example.com/page1.htmlのポートは443（HTTPSの標準ポート）です。
    #   #   port = 8080
    #   # }
    #
    #   #---------------------------------------------------------------
    #   # urls ブロック（必須）
    #   #---------------------------------------------------------------
    #   # クロールするウェブサイトのシードまたは開始点URL、またはクロールする
    #   # ウェブサイトのサイトマップURLを指定します。ウェブサイトのサブドメインを
    #   # 含めることができます。最大100個のシードURLと最大3個のサイトマップURLを
    #   # リストできます。安全な通信プロトコル、Hypertext Transfer Protocol Secure（HTTPS）を
    #   # 使用するウェブサイトのみをクロールできます。
    #   # ウェブサイトのクロール時にエラーが発生した場合、ウェブサイトがクロールから
    #   # ブロックされている可能性があります。
    #   # インデックス化するウェブサイトを選択する際は、Amazon Acceptable Use Policyおよび
    #   # その他すべてのAmazon条件を遵守する必要があります。
    #   # Amazon Kendra Web Crawlerは、自分のウェブページ、または
    #   # インデックス化する権限があるウェブページのみをインデックス化するために使用してください。
    #   # https://aws.amazon.com/aup/
    #
    #   # urls {
    #   #   #---------------------------------------------------------------
    #   #   # seed_url_configuration ブロック
    #   #   #---------------------------------------------------------------
    #   #   # クロールするウェブサイトのシードまたは開始点URLの設定を指定します。
    #   #   # ウェブサイトホスト名のみをクロールするか、サブドメインを含むウェブサイトホスト名、
    #   #   # またはウェブページがリンクする他のドメインを含むウェブサイトホスト名を
    #   #   # クロールするかを選択できます。最大100個のシードURLをリストできます。
    #   #
    #   #   seed_url_configuration {
    #   #     # seed_urls - シードURL（必須）
    #   #     # クロールするウェブサイトのシードまたは開始点URLのリスト。
    #   #     # リストには最大100個のシードURLを含めることができます。
    #   #     # 配列メンバー: 最小0項目、最大100項目
    #   #     # 長さの制約: 最小長1、最大長2048
    #   #     seed_urls = [
    #   #       "https://example.com",
    #   #       "https://docs.example.com"
    #   #     ]
    #   #
    #   #     # web_crawler_mode - Webクローラーモード
    #   #     # デフォルトモードはHOST_ONLYに設定されています。
    #   #     # 以下のモードのいずれかを選択できます:
    #   #     # - HOST_ONLY: ウェブサイトホスト名のみをクロールします。
    #   #     #   例: シードURLが"abc.example.com"の場合、ホスト名"abc.example.com"のURLのみがクロールされます。
    #   #     # - SUBDOMAINS: サブドメインを含むウェブサイトホスト名をクロールします。
    #   #     #   例: シードURLが"abc.example.com"の場合、"a.abc.example.com"と"b.abc.example.com"もクロールされます。
    #   #     # - EVERYTHING: サブドメインおよびウェブページがリンクする他のドメインを含む
    #   #     #   ウェブサイトホスト名をクロールします。
    #   #     web_crawler_mode = "HOST_ONLY"
    #   #   }
    #   #
    #   #   #---------------------------------------------------------------
    #   #   # site_maps_configuration ブロック
    #   #   #---------------------------------------------------------------
    #   #   # クロールするウェブサイトのサイトマップURLの設定を指定します。
    #   #   # 同じウェブサイトホスト名に属するURLのみがクロールされます。
    #   #   # 最大3個のサイトマップURLをリストできます。
    #   #
    #   #   # site_maps_configuration {
    #   #   #   # site_maps - サイトマップURL（必須）
    #   #   #   # クロールするウェブサイトのサイトマップURLのリスト。
    #   #   #   # リストには最大3個のサイトマップURLを含めることができます。
    #   #   #   site_maps = [
    #   #   #     "https://example.com/sitemap.xml"
    #   #   #   ]
    #   #   # }
    #   # }
    # }
  }

  #---------------------------------------------------------------
  # custom_document_enrichment_configuration ブロック
  #---------------------------------------------------------------
  # ドキュメント取り込みプロセス中にドキュメントメタデータとコンテンツを変更するための
  # 設定情報。Amazon Kendraにドキュメントを取り込む際に、ドキュメントメタデータを
  # 作成、変更、削除する方法、またはその他のコンテンツの変更を行う方法の詳細:
  # https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html

  # custom_document_enrichment_configuration {
  #   # role_arn - IAMロールのARN
  #   # ドキュメント取り込みプロセス中にドキュメントメタデータとコンテンツを変更するための
  #   # pre_extraction_hook_configurationおよびpost_extraction_hook_configurationを
  #   # 実行する権限を持つIAMロールのARN。
  #   # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
  #   role_arn = "arn:aws:iam::123456789012:role/KendraEnrichmentRole"
  #
  #   #---------------------------------------------------------------
  #   # inline_configurations ブロック
  #   #---------------------------------------------------------------
  #   # Amazon Kendraにドキュメントを取り込む際にドキュメント属性またはメタデータフィールドと
  #   # コンテンツを変更するための設定。
  #   # 最小0項目、最大100項目。
  #
  #   # inline_configurations {
  #   #   # document_content_deletion - ドキュメントコンテンツ削除
  #   #   # ターゲット属性に使用される条件が満たされた場合、コンテンツを削除する場合はTRUE。
  #   #   document_content_deletion = false
  #   #
  #   #   #---------------------------------------------------------------
  #   #   # condition ブロック
  #   #   #---------------------------------------------------------------
  #   #   # ドキュメントをAmazon Kendraに取り込む際に、ターゲットドキュメント属性または
  #   #   # メタデータフィールドに使用される条件の設定。
  #   #
  #   #   condition {
  #   #     # condition_document_attribute_key - 条件ドキュメント属性キー（必須）
  #   #     # 条件に使用されるドキュメント属性の識別子。
  #   #     # 例: _source_uriは、ドキュメントに関連付けられたソースURIを含む
  #   #     # 属性またはメタデータフィールドの識別子になります。
  #   #     # Amazon Kendraは現在、条件のキーとして_document_bodyをサポートしていません。
  #   #     condition_document_attribute_key = "_source_uri"
  #   #
  #   #     # operator - 演算子（必須）
  #   #     # 条件演算子。例: Containsを使用して文字列を部分的に一致させることができます。
  #   #     # 有効な値: GreaterThan | GreaterThanOrEquals | LessThan | LessThanOrEquals |
  #   #     # Equals | NotEquals | Contains | NotContains | Exists | NotExists | BeginsWith
  #   #     operator = "Contains"
  #   #
  #   #     #---------------------------------------------------------------
  #   #     # condition_on_value ブロック
  #   #     #---------------------------------------------------------------
  #   #     # 演算子によって使用される値。例: _source_uriフィールド内の文字列に対して
  #   #     # 部分的に一致またはこの値を含む'financial'という値を指定できます。
  #   #
  #   #     # condition_on_value {
  #   #     #   # date_value - 日付値
  #   #     #   # ISO 8601文字列として表現された日付。
  #   #     #   # タイムゾーンをISO 8601日時形式に含めることが重要です。
  #   #     #   # この記述時点では、UTCのみがサポートされています。
  #   #     #   # 例: 2012-03-25T12:30:10+00:00
  #   #     #   date_value = "2012-03-25T12:30:10+00:00"
  #   #     #
  #   #     #   # long_value - 整数値
  #   #     #   # 長整数値。
  #   #     #   long_value = 12345
  #   #     #
  #   #     #   # string_list_value - 文字列リスト値
  #   #     #   # 文字列のリスト。
  #   #     #   string_list_value = ["value1", "value2"]
  #   #     #
  #   #     #   # string_value - 文字列値
  #   #     #   # 文字列。例: "department"
  #   #     #   string_value = "financial"
  #   #     # }
  #   #   }
  #   #
  #   #   #---------------------------------------------------------------
  #   #   # target ブロック
  #   #   #---------------------------------------------------------------
  #   #   # ドキュメントをAmazon Kendraに取り込む際のターゲットドキュメント属性または
  #   #   # メタデータフィールドの設定。値を含めることもできます。
  #   #
  #   #   # target {
  #   #   #   # target_document_attribute_key - ターゲットドキュメント属性キー
  #   #   #   # ターゲット属性またはメタデータフィールドの識別子。
  #   #   #   # 例: 'Department'は、ドキュメントに関連付けられた部門名を含む
  #   #   #   # ターゲット属性またはメタデータフィールドの識別子になります。
  #   #   #   target_document_attribute_key = "Department"
  #   #   #
  #   #   #   # target_document_attribute_value_deletion - ターゲット属性値削除
  #   #   #   # 指定したターゲット属性キーの既存のターゲット値を削除する場合はTRUE。
  #   #   #   # ターゲット値を作成してこれをTRUEに設定することはできません。
  #   #   #   # ターゲット値（TargetDocumentAttributeValue）を作成するには、これをFALSEに設定します。
  #   #   #   target_document_attribute_value_deletion = false
  #   #   #
  #   #   #   #---------------------------------------------------------------
  #   #   #   # target_document_attribute_value ブロック
  #   #   #   #---------------------------------------------------------------
  #   #   #   # ターゲット属性に作成するターゲット値。
  #   #   #   # 例: 'Finance'は、ターゲット属性キー'Department'のターゲット値になります。
  #   #   #
  #   #   #   # target_document_attribute_value {
  #   #   #   #   # date_value - 日付値
  #   #   #   #   # ISO 8601文字列として表現された日付。
  #   #   #   #   # タイムゾーンをISO 8601日時形式に含めることが重要です。
  #   #   #   #   # この記述時点では、UTCのみがサポートされています。
  #   #   #   #   # 例: 2012-03-25T12:30:10+00:00
  #   #   #   #   date_value = "2012-03-25T12:30:10+00:00"
  #   #   #   #
  #   #   #   #   # long_value - 整数値
  #   #   #   #   # 長整数値。
  #   #   #   #   long_value = 100
  #   #   #   #
  #   #   #   #   # string_list_value - 文字列リスト値
  #   #   #   #   # 文字列のリスト。
  #   #   #   #   string_list_value = ["Finance", "Accounting"]
  #   #   #   #
  #   #   #   #   # string_value - 文字列値
  #   #   #   #   # 文字列。例: "department"
  #   #   #   #   string_value = "Finance"
  #   #   #   # }
  #   #   # }
  #   # }
  #
  #   #---------------------------------------------------------------
  #   # pre_extraction_hook_configuration ブロック
  #   #---------------------------------------------------------------
  #   # メタデータとテキストを抽出する前に、元のまたは生のドキュメントに対して
  #   # AWS LambdaでLambda関数を呼び出すための設定。Lambda関数を使用して、
  #   # ドキュメントメタデータとコンテンツの作成、変更、削除に関する高度なロジックを
  #   # 適用できます。
  #   # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html#advanced-data-manipulation
  #
  #   # pre_extraction_hook_configuration {
  #   #   # lambda_arn - Lambda ARN（必須）
  #   #   # ドキュメントメタデータフィールドまたは属性とコンテンツを操作できる
  #   #   # Lambda関数のARN。
  #   #   lambda_arn = "arn:aws:lambda:region:account-id:function:function-name"
  #   #
  #   #   # s3_bucket - S3バケット（必須）
  #   #   # 変更前と変更後の元の生のドキュメントまたは構造化された解析済みドキュメントを保存します。
  #   #   # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html#cde-data-contracts-lambda
  #   #   s3_bucket = "your-enrichment-bucket"
  #   #
  #   #   #---------------------------------------------------------------
  #   #   # invocation_condition ブロック
  #   #   #---------------------------------------------------------------
  #   #   # Lambda関数を呼び出すタイミングの条件を指定します。
  #   #   # 例: 空の日時値がある場合、現在の日時を挿入する関数を呼び出すように
  #   #   # Amazon Kendraに指定する条件を指定できます。
  #   #
  #   #   # invocation_condition {
  #   #   #   # condition_document_attribute_key - 条件ドキュメント属性キー（必須）
  #   #   #   # 条件に使用されるドキュメント属性の識別子。
  #   #   #   # 例: _source_uriは、ドキュメントに関連付けられたソースURIを含む
  #   #   #   # 属性またはメタデータフィールドの識別子になります。
  #   #   #   # Amazon Kendraは現在、条件のキーとして_document_bodyをサポートしていません。
  #   #   #   condition_document_attribute_key = "_created_at"
  #   #   #
  #   #   #   # operator - 演算子（必須）
  #   #   #   # 条件演算子。例: Containsを使用して文字列を部分的に一致させることができます。
  #   #   #   # 有効な値: GreaterThan | GreaterThanOrEquals | LessThan | LessThanOrEquals |
  #   #   #   # Equals | NotEquals | Contains | NotContains | Exists | NotExists | BeginsWith
  #   #   #   operator = "NotExists"
  #   #   #
  #   #   #   # condition_on_value ブロック
  #   #   #   # 演算子によって使用される値。
  #   #   #   # condition_on_value {
  #   #   #   #   date_value     = null
  #   #   #   #   long_value     = null
  #   #   #   #   string_list_value = null
  #   #   #   #   string_value   = null
  #   #   #   # }
  #   #   # }
  #   # }
  #
  #   #---------------------------------------------------------------
  #   # post_extraction_hook_configuration ブロック
  #   #---------------------------------------------------------------
  #   # メタデータとテキストが抽出された構造化ドキュメントに対して
  #   # AWS LambdaでLambda関数を呼び出すための設定。Lambda関数を使用して、
  #   # ドキュメントメタデータとコンテンツの作成、変更、削除に関する高度なロジックを
  #   # 適用できます。
  #   # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html#advanced-data-manipulation
  #
  #   # post_extraction_hook_configuration {
  #   #   # lambda_arn - Lambda ARN（必須）
  #   #   # ドキュメントメタデータフィールドまたは属性とコンテンツを操作できる
  #   #   # Lambda関数のARN。
  #   #   lambda_arn = "arn:aws:lambda:region:account-id:function:function-name"
  #   #
  #   #   # s3_bucket - S3バケット（必須）
  #   #   # 変更前と変更後の元の生のドキュメントまたは構造化された解析済みドキュメントを保存します。
  #   #   # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/custom-document-enrichment.html#cde-data-contracts-lambda
  #   #   s3_bucket = "your-enrichment-bucket"
  #   #
  #   #   # invocation_condition ブロック（構造はpre_extraction_hook_configurationと同じ）
  #   #   # invocation_condition {
  #   #   #   condition_document_attribute_key = "_language_code"
  #   #   #   operator                         = "Equals"
  #   #   #   # condition_on_value {
  #   #   #   #   string_value = "en"
  #   #   #   # }
  #   #   # }
  #   # }
  # }

  #---------------------------------------------------------------
  # timeouts ブロック
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定

  # timeouts {
  #   # create - 作成タイムアウト
  #   # リソース作成操作のタイムアウト時間を指定します。
  #   create = "30m"
  #
  #   # update - 更新タイムアウト
  #   # リソース更新操作のタイムアウト時間を指定します。
  #   update = "30m"
  #
  #   # delete - 削除タイムアウト
  #   # リソース削除操作のタイムアウト時間を指定します。
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（Computed Only - 入力不可）:
#
# - arn - データソースのARN
# - created_at - データソースが作成されたUnixタイムスタンプ
# - data_source_id - データソースの一意の識別子
# - error_message - Statusフィールドの値がFAILEDの場合、データソースが失敗した原因のエラーの説明を含む
# - id - データソースとインデックスの一意の識別子をスラッシュ（/）で区切った値
# - status - データソースの現在のステータス。ステータスがACTIVEの場合、データソースは使用可能。
#          ステータスがFAILEDの場合、error_messageフィールドにデータソースが失敗した理由が含まれる
# - updated_at - データソースが最後に更新されたUnixタイムスタンプ
# - tags_all - プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたタグのマップ
#---------------------------------------------------------------
