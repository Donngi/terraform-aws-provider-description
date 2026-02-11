#---------------------------------------------------------------
# AWS Bedrock Agent Data Source
#---------------------------------------------------------------
#
# Amazon Bedrock Knowledge Base用のデータソースをプロビジョニングするリソースです。
# データソースは、Knowledge Baseが検索対象とするデータの保存場所を定義します。
# S3、Web、Confluence、Salesforce、SharePointなど様々なソースタイプに対応しています。
#
# AWS公式ドキュメント:
#   - Bedrock Knowledge Bases概要: https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html
#   - データソースの設定: https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-data-source.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_data_source
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_data_source" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # knowledge_base_id (Required)
  # 設定内容: このデータソースが属するKnowledge BaseのIDを指定します。
  # 設定可能な値: 有効なKnowledge Base ID
  knowledge_base_id = "EMDPPAYPZI"

  # name (Required, Forces new resource)
  # 設定内容: データソースの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: 変更時はリソースが再作成されます。
  name = "example-data-source"

  # description (Optional)
  # 設定内容: データソースの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "Example data source for Bedrock Knowledge Base"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # data_deletion_policy (Optional)
  # 設定内容: データソース削除時のデータ削除ポリシーを指定します。
  # 設定可能な値:
  #   - "RETAIN": データソース削除時にデータを保持
  #   - "DELETE": データソース削除時にデータも削除
  data_deletion_policy = "RETAIN"

  #-------------------------------------------------------------
  # データソース設定
  #-------------------------------------------------------------

  # data_source_configuration (Required)
  # 設定内容: データソースの保存場所に関する詳細設定を指定します。
  data_source_configuration {
    # type (Required)
    # 設定内容: データソースのストレージタイプを指定します。
    # 設定可能な値:
    #   - "S3": Amazon S3バケット
    #   - "WEB": Webサイト（URLクローリング）
    #   - "CONFLUENCE": Atlassian Confluence
    #   - "SALESFORCE": Salesforce
    #   - "SHAREPOINT": Microsoft SharePoint
    #   - "CUSTOM": カスタムデータソース
    #   - "REDSHIFT_METADATA": Amazon Redshiftメタデータ
    type = "S3"

    #-----------------------------------------------------------
    # S3データソース設定
    #-----------------------------------------------------------
    # typeが"S3"の場合に設定

    # s3_configuration (Optional)
    # 設定内容: S3データソースの設定を指定します。
    s3_configuration {
      # bucket_arn (Required)
      # 設定内容: データソースを含むS3バケットのARNを指定します。
      # 設定可能な値: 有効なS3バケットARN
      bucket_arn = "arn:aws:s3:::example-bucket"

      # bucket_owner_account_id (Optional)
      # 設定内容: S3バケットの所有者アカウントIDを指定します。
      # 設定可能な値: 12桁のAWSアカウントID
      # 用途: クロスアカウントアクセスの場合に指定
      bucket_owner_account_id = null

      # inclusion_prefixes (Optional)
      # 設定内容: データソースを含むオブジェクトを定義するS3プレフィックスのリストを指定します。
      # 設定可能な値: S3プレフィックスの文字列リスト
      # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-prefixes.html
      inclusion_prefixes = ["documents/", "knowledge/"]
    }

    #-----------------------------------------------------------
    # Webデータソース設定
    #-----------------------------------------------------------
    # typeが"WEB"の場合に設定

    # web_configuration (Optional)
    # 設定内容: Webデータソースの設定を指定します。
    # web_configuration {
    #   # source_configuration (Required)
    #   # 設定内容: WebデータソースのエンドポイントURLの設定を指定します。
    #   source_configuration {
    #     # url_configuration (Required)
    #     # 設定内容: WebデータソースのURL設定を指定します。
    #     url_configuration {
    #       # seed_urls (Optional)
    #       # 設定内容: クロールするシードURLのリストを指定します。
    #       seed_urls {
    #         # url (Optional)
    #         # 設定内容: シードまたは開始点のURLを指定します。
    #         # 設定可能な値: ^https?://[A-Za-z0-9][^\s]*$ パターンに一致するURL
    #         url = "https://example.com"
    #       }
    #     }
    #   }
    #
    #   # crawler_configuration (Optional)
    #   # 設定内容: Webクローラーの設定を指定します。
    #   crawler_configuration {
    #     # scope (Optional)
    #     # 設定内容: URLのクロール範囲を指定します。
    #     # 設定可能な値: クロール範囲（例: HOST_ONLY, SUBDOMAINS）
    #     scope = null
    #
    #     # user_agent (Optional)
    #     # 設定内容: クローラーがWebサーバーにアクセスする際の識別文字列を指定します。
    #     # 省略時: bedrockbot_UUID
    #     user_agent = null
    #
    #     # inclusion_filters (Optional)
    #     # 設定内容: 含めるオブジェクトタイプの正規表現パターンリストを指定します。
    #     inclusion_filters = null
    #
    #     # exclusion_filters (Optional)
    #     # 設定内容: 除外するオブジェクトタイプの正規表現パターンリストを指定します。
    #     exclusion_filters = null
    #
    #     # crawler_limits (Optional)
    #     # 設定内容: WebURLのクロール制限設定を指定します。
    #     crawler_limits {
    #       # max_pages (Optional)
    #       # 設定内容: ソースURLからクロールするWebページの最大数を指定します。
    #       # 設定可能な値: 最大25,000ページまで
    #       max_pages = 1000
    #
    #       # rate_limit (Optional)
    #       # 設定内容: ページをクロールする最大レートを指定します。
    #       # 設定可能な値: ホストあたり最大300ページ/分
    #       rate_limit = 100
    #     }
    #   }
    # }

    #-----------------------------------------------------------
    # Confluenceデータソース設定
    #-----------------------------------------------------------
    # typeが"CONFLUENCE"の場合に設定

    # confluence_configuration (Optional)
    # 設定内容: Confluenceデータソースの設定を指定します。
    # confluence_configuration {
    #   # source_configuration (Required)
    #   # 設定内容: Confluenceインスタンスへの接続エンドポイント情報を指定します。
    #   source_configuration {
    #     # auth_type (Required)
    #     # 設定内容: Confluenceインスタンスへの認証タイプを指定します。
    #     # 設定可能な値:
    #     #   - "BASIC": 基本認証
    #     #   - "OAUTH2_CLIENT_CREDENTIALS": OAuth2クライアント認証情報
    #     auth_type = "BASIC"
    #
    #     # credentials_secret_arn (Required)
    #     # 設定内容: 認証情報を保存するSecrets ManagerシークレットのARNを指定します。
    #     # 設定可能な値: ^arn:aws(|-cn|-us-gov):secretsmanager:[a-z0-9-]{1,20}:([0-9]{12}|):secret:[a-zA-Z0-9!/_+=.@-]{1,512}$
    #     credentials_secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:confluence-credentials"
    #
    #     # host_type (Required)
    #     # 設定内容: ホストタイプを指定します。
    #     # 設定可能な値:
    #     #   - "SAAS": クラウド/オンラインインスタンス
    #     host_type = "SAAS"
    #
    #     # host_url (Required)
    #     # 設定内容: ConfluenceのホストURLまたはインスタンスURLを指定します。
    #     # 設定可能な値: ^https://[A-Za-z0-9][^\s]*$ パターンに一致するURL
    #     host_url = "https://your-domain.atlassian.net/wiki"
    #   }
    #
    #   # crawler_configuration (Optional)
    #   # 設定内容: Confluenceコンテンツのクローラー設定を指定します。
    #   crawler_configuration {
    #     # filter_configuration (Optional)
    #     # 設定内容: コンテンツのフィルタリング設定を指定します。
    #     filter_configuration {
    #       # type (Required)
    #       # 設定内容: フィルタリングのタイプを指定します。
    #       # 設定可能な値: "PATTERN"（正規表現パターン）
    #       type = "PATTERN"
    #
    #       # pattern_object_filter (Optional)
    #       # 設定内容: 特定のオブジェクトまたはコンテンツタイプのフィルタリング設定を指定します。
    #       pattern_object_filter {
    #         # filters (Required)
    #         # 設定内容: データソースコンテンツに適用する特定のフィルター設定を指定します。
    #         # 注意: 最小1、最大25のフィルター
    #         filters {
    #           # object_type (Required)
    #           # 設定内容: データソースのオブジェクトタイプまたはコンテンツタイプを指定します。
    #           object_type = "Page"
    #
    #           # inclusion_filters (Optional)
    #           # 設定内容: 含めるオブジェクトタイプの正規表現パターンリストを指定します。
    #           inclusion_filters = [".*important.*"]
    #
    #           # exclusion_filters (Optional)
    #           # 設定内容: 除外するオブジェクトタイプの正規表現パターンリストを指定します。
    #           exclusion_filters = [".*draft.*"]
    #         }
    #       }
    #     }
    #   }
    # }

    #-----------------------------------------------------------
    # Salesforceデータソース設定
    #-----------------------------------------------------------
    # typeが"SALESFORCE"の場合に設定

    # salesforce_configuration (Optional)
    # 設定内容: Salesforceデータソースの設定を指定します。
    # salesforce_configuration {
    #   # source_configuration (Required)
    #   # 設定内容: Salesforceインスタンスへの接続エンドポイント情報を指定します。
    #   source_configuration {
    #     # auth_type (Required)
    #     # 設定内容: Salesforceインスタンスへの認証タイプを指定します。
    #     # 設定可能な値:
    #     #   - "OAUTH2_CLIENT_CREDENTIALS": OAuth2クライアント認証情報
    #     auth_type = "OAUTH2_CLIENT_CREDENTIALS"
    #
    #     # credentials_secret_arn (Required)
    #     # 設定内容: 認証情報を保存するSecrets ManagerシークレットのARNを指定します。
    #     # 設定可能な値: ^arn:aws(|-cn|-us-gov):secretsmanager:[a-z0-9-]{1,20}:([0-9]{12}|):secret:[a-zA-Z0-9!/_+=.@-]{1,512}$
    #     credentials_secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:salesforce-credentials"
    #
    #     # host_url (Required)
    #     # 設定内容: SalesforceのホストURLまたはインスタンスURLを指定します。
    #     # 設定可能な値: ^https://[A-Za-z0-9][^\s]*$ パターンに一致するURL
    #     host_url = "https://your-domain.salesforce.com"
    #   }
    #
    #   # crawler_configuration (Optional)
    #   # 設定内容: Salesforceコンテンツのクローラー設定を指定します。
    #   crawler_configuration {
    #     # filter_configuration (Optional)
    #     # 設定内容: Salesforce標準オブジェクトのフィルタリング設定を指定します。
    #     filter_configuration {
    #       type = "PATTERN"
    #       pattern_object_filter {
    #         filters {
    #           object_type = "Account"
    #           inclusion_filters = [".*"]
    #         }
    #       }
    #     }
    #   }
    # }

    #-----------------------------------------------------------
    # SharePointデータソース設定
    #-----------------------------------------------------------
    # typeが"SHAREPOINT"の場合に設定

    # share_point_configuration (Optional)
    # 設定内容: SharePointデータソースの設定を指定します。
    # share_point_configuration {
    #   # source_configuration (Required)
    #   # 設定内容: SharePointサイトへの接続エンドポイント情報を指定します。
    #   source_configuration {
    #     # auth_type (Required)
    #     # 設定内容: SharePointサイトへの認証タイプを指定します。
    #     # 設定可能な値:
    #     #   - "OAUTH2_CLIENT_CREDENTIALS": OAuth2クライアント認証情報
    #     #   - "OAUTH2_SHAREPOINT_APP_ONLY_CLIENT_CREDENTIALS": SharePointアプリ専用OAuth2クライアント認証情報
    #     auth_type = "OAUTH2_CLIENT_CREDENTIALS"
    #
    #     # credentials_secret_arn (Required)
    #     # 設定内容: 認証情報を保存するSecrets ManagerシークレットのARNを指定します。
    #     # 設定可能な値: ^arn:aws(|-cn|-us-gov):secretsmanager:[a-z0-9-]{1,20}:([0-9]{12}|):secret:[a-zA-Z0-9!/_+=.@-]{1,512}$
    #     credentials_secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:sharepoint-credentials"
    #
    #     # domain (Required)
    #     # 設定内容: SharePointインスタンスまたはサイトURLのドメインを指定します。
    #     domain = "your-domain"
    #
    #     # host_type (Required)
    #     # 設定内容: ホストタイプを指定します。
    #     # 設定可能な値:
    #     #   - "ONLINE": オンライン/クラウドインスタンス
    #     host_type = "ONLINE"
    #
    #     # site_urls (Required)
    #     # 設定内容: 1つ以上のSharePointサイトURLのリストを指定します。
    #     site_urls = ["https://your-domain.sharepoint.com/sites/example"]
    #
    #     # tenant_id (Optional)
    #     # 設定内容: Microsoft 365テナントの識別子を指定します。
    #     tenant_id = null
    #   }
    #
    #   # crawler_configuration (Optional)
    #   # 設定内容: SharePointコンテンツのクローラー設定を指定します。
    #   crawler_configuration {
    #     filter_configuration {
    #       type = "PATTERN"
    #       pattern_object_filter {
    #         filters {
    #           object_type = "File"
    #           inclusion_filters = [".*\\.pdf$"]
    #         }
    #       }
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # サーバーサイド暗号化設定
  #-------------------------------------------------------------

  # server_side_encryption_configuration (Optional)
  # 設定内容: サーバーサイド暗号化の設定を指定します。
  server_side_encryption_configuration {
    # kms_key_arn (Optional)
    # 設定内容: リソースの暗号化に使用するAWS KMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # ベクトルインジェスト設定
  #-------------------------------------------------------------

  # vector_ingestion_configuration (Optional, Forces new resource)
  # 設定内容: ベクトルインジェストの設定を指定します。
  # 注意: 変更時はリソースが再作成されます。
  vector_ingestion_configuration {
    #-----------------------------------------------------------
    # チャンク設定
    #-----------------------------------------------------------

    # chunking_configuration (Optional, Forces new resource)
    # 設定内容: データソースのドキュメントをチャンクに分割する方法の設定を指定します。
    # チャンクとは、Knowledge Baseがクエリされた際に返されるデータソースからの抜粋です。
    chunking_configuration {
      # chunking_strategy (Required, Forces new resource)
      # 設定内容: ソースデータのチャンク化オプションを指定します。
      # 設定可能な値:
      #   - "FIXED_SIZE": 固定サイズでチャンク化
      #   - "HIERARCHICAL": 階層的にチャンク化
      #   - "SEMANTIC": セマンティック（意味的）にチャンク化
      #   - "NONE": チャンク化しない（1つのチャンクとして扱う）
      chunking_strategy = "FIXED_SIZE"

      # fixed_size_chunking_configuration (Optional, Forces new resource)
      # 設定内容: 固定サイズチャンク化の設定を指定します。
      # 注意: chunking_strategyが"FIXED_SIZE"の場合に指定
      fixed_size_chunking_configuration {
        # max_tokens (Required, Forces new resource)
        # 設定内容: チャンクに含める最大トークン数を指定します。
        # 設定可能な値: 正の整数
        max_tokens = 300

        # overlap_percentage (Required, Forces new resource)
        # 設定内容: データソースの隣接チャンク間のオーバーラップ率を指定します。
        # 設定可能な値: 0-99のパーセンテージ
        overlap_percentage = 20
      }

      # hierarchical_chunking_configuration (Optional, Forces new resource)
      # 設定内容: 階層的チャンク化の設定を指定します。
      # 注意: chunking_strategyが"HIERARCHICAL"の場合に指定
      # hierarchical_chunking_configuration {
      #   # overlap_tokens (Required, Forces new resource)
      #   # 設定内容: 同じレイヤー内のチャンク間で繰り返すトークン数を指定します。
      #   overlap_tokens = 60
      #
      #   # level_configuration (Required, Forces new resource)
      #   # 設定内容: 各レベルの設定を指定します。
      #   # 注意: 2つのlevel_configurationを指定する必要があります。
      #   level_configuration {
      #     # max_tokens (Required)
      #     # 設定内容: このレイヤーでチャンクが含むことができる最大トークン数を指定します。
      #     max_tokens = 1500
      #   }
      #   level_configuration {
      #     max_tokens = 300
      #   }
      # }

      # semantic_chunking_configuration (Optional, Forces new resource)
      # 設定内容: セマンティックチャンク化の設定を指定します。
      # 注意: chunking_strategyが"SEMANTIC"の場合に指定
      # semantic_chunking_configuration {
      #   # breakpoint_percentile_threshold (Required, Forces new resource)
      #   # 設定内容: チャンクを分割するための非類似度閾値を指定します。
      #   # 設定可能な値: 50-99のパーセンタイル
      #   breakpoint_percentile_threshold = 95
      #
      #   # buffer_size (Required, Forces new resource)
      #   # 設定内容: バッファサイズを指定します。
      #   # 設定可能な値: 0-1の整数
      #   buffer_size = 0
      #
      #   # max_token (Required, Forces new resource)
      #   # 設定内容: チャンクが含むことができる最大トークン数を指定します。
      #   max_token = 300
      # }
    }

    #-----------------------------------------------------------
    # カスタム変換設定
    #-----------------------------------------------------------

    # custom_transformation_configuration (Optional, Forces new resource)
    # 設定内容: カスタム変換の設定を指定します。
    # Lambda関数を使用してドキュメントを処理する場合に使用します。
    # custom_transformation_configuration {
    #   # intermediate_storage (Required, Forces new resource)
    #   # 設定内容: カスタム変換用の中間ストレージを指定します。
    #   intermediate_storage {
    #     # s3_location (Required, Forces new resource)
    #     # 設定内容: 中間ストレージのS3ロケーションを指定します。
    #     s3_location {
    #       # uri (Required, Forces new resource)
    #       # 設定内容: 中間ストレージのS3 URIを指定します。
    #       uri = "s3://example-bucket/intermediate/"
    #     }
    #   }
    #
    #   # transformation (Required)
    #   # 設定内容: データソースインジェストパイプラインを通過するドキュメントのカスタム処理ステップを指定します。
    #   transformation {
    #     # step_to_apply (Required, Forces new resource)
    #     # 設定内容: サービスが変換を適用するタイミングを指定します。
    #     # 設定可能な値:
    #     #   - "POST_CHUNKING": チャンク化後に適用
    #     step_to_apply = "POST_CHUNKING"
    #
    #     # transformation_function (Required)
    #     # 設定内容: ドキュメントを処理するLambda関数を指定します。
    #     transformation_function {
    #       # transformation_lambda_configuration (Required, Forces new resource)
    #       # 設定内容: Lambda関数の設定を指定します。
    #       transformation_lambda_configuration {
    #         # lambda_arn (Required, Forces new resource)
    #         # 設定内容: カスタム変換に使用するLambdaのARNを指定します。
    #         lambda_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:document-processor"
    #       }
    #     }
    #   }
    # }

    #-----------------------------------------------------------
    # パース設定
    #-----------------------------------------------------------

    # parsing_configuration (Optional, Forces new resource)
    # 設定内容: データソースドキュメントのカスタムパースの設定を指定します。
    # parsing_configuration {
    #   # parsing_strategy (Required)
    #   # 設定内容: パース戦略を指定します。
    #   # 設定可能な値:
    #   #   - "BEDROCK_FOUNDATION_MODEL": Bedrock Foundation Modelを使用してパース
    #   parsing_strategy = "BEDROCK_FOUNDATION_MODEL"
    #
    #   # bedrock_foundation_model_configuration (Optional)
    #   # 設定内容: データソースのドキュメントをパースするために使用する基盤モデルの設定を指定します。
    #   bedrock_foundation_model_configuration {
    #     # model_arn (Required)
    #     # 設定内容: ドキュメントのパースに使用するモデルのARNを指定します。
    #     model_arn = "arn:aws:bedrock:ap-northeast-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0"
    #
    #     # parsing_prompt (Optional)
    #     # 設定内容: ドキュメントの内容を解釈するための指示を指定します。
    #     parsing_prompt {
    #       # parsing_prompt_string (Required)
    #       # 設定内容: ドキュメントの内容を解釈するための指示文字列を指定します。
    #       parsing_prompt_string = "Please extract key information from this document."
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除時のタイムアウト設定を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 注意: 削除操作のタイムアウト設定は、削除操作が発生する前に変更がstateに保存される場合にのみ適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - data_source_id: データソースの一意識別子
#
# - id: データソースIDとKnowledge Base IDで構成される識別子
#
#---------------------------------------------------------------
