#---------------------------------------------------------------
# AWS Bedrock Agent Knowledge Base
#---------------------------------------------------------------
#
# Amazon Bedrock Knowledge Baseをプロビジョニングするリソースです。
# Knowledge Baseは、Retrieval Augmented Generation（RAG）を実現するための
# データストアであり、プライベートデータを基盤モデルと統合して
# より正確で関連性の高い応答を生成することができます。
#
# Knowledge Baseは以下の3種類のタイプをサポートしています:
#   - VECTOR: ベクトルデータベースを使用した非構造化データの検索
#   - KENDRA: Amazon Kendraインデックスを使用した検索
#   - SQL: Amazon Redshiftなどの構造化データストアへのクエリ
#
# AWS公式ドキュメント:
#   - Knowledge Bases概要: https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html
#   - Knowledge Basesの仕組み: https://docs.aws.amazon.com/bedrock/latest/userguide/kb-how-it-works.html
#   - データソースのセットアップ: https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_knowledge_base
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrockagent_knowledge_base" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Knowledge Baseの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-knowledge-base"

  # role_arn (Required)
  # 設定内容: Knowledge BaseでAPI操作を実行する権限を持つIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このロールには、選択したベクトルストア、埋め込みモデル、
  #       データソースへのアクセス権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/BedrockKnowledgeBaseRole"

  # description (Optional)
  # 設定内容: Knowledge Baseの説明を指定します。
  # 設定可能な値: 文字列
  description = "Example knowledge base for RAG applications"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Knowledge Base設定 (knowledge_base_configuration)
  #-------------------------------------------------------------
  # Knowledge Baseの種類と埋め込みモデルの設定を行います。
  # このブロックは必須で、リソース作成後は変更できません（Forces new resource）。

  knowledge_base_configuration {
    # type (Required)
    # 設定内容: Knowledge Baseのタイプを指定します。
    # 設定可能な値:
    #   - "VECTOR": ベクトルデータベースを使用（非構造化データ向け）
    #   - "KENDRA": Amazon Kendraインデックスを使用
    #   - "SQL": 構造化データストア（Amazon Redshift等）を使用
    type = "VECTOR"

    #-----------------------------------------------------------
    # VECTORタイプ用設定 (vector_knowledge_base_configuration)
    #-----------------------------------------------------------
    # typeが"VECTOR"の場合に使用します。
    # 埋め込みモデルとその設定を指定します。

    vector_knowledge_base_configuration {
      # embedding_model_arn (Required)
      # 設定内容: ベクトル埋め込みを作成するモデルのARNを指定します。
      # 設定可能な値: 有効なBedrock埋め込みモデルARN
      # 例:
      #   - amazon.titan-embed-text-v1
      #   - amazon.titan-embed-text-v2:0
      #   - cohere.embed-english-v3
      #   - cohere.embed-multilingual-v3
      embedding_model_arn = "arn:aws:bedrock:us-west-2::foundation-model/amazon.titan-embed-text-v2:0"

      # embedding_model_configuration (Optional)
      # 設定内容: 埋め込みモデルの詳細設定を行います。
      embedding_model_configuration {
        bedrock_embedding_model_configuration {
          # dimensions (Optional)
          # 設定内容: ベクトルの次元数を指定します。
          # 設定可能な値: モデルがサポートする次元数
          # 注意: モデルによってサポートされる次元数が異なります。
          #       Titan Embed V2は256, 512, 1024をサポート。
          dimensions = 1024

          # embedding_data_type (Optional)
          # 設定内容: ベクトルのデータ型を指定します。
          # 設定可能な値:
          #   - "FLOAT32": 32ビット浮動小数点（高精度、大容量）
          #   - "BINARY": バイナリ形式（省ストレージ、やや低精度）
          embedding_data_type = "FLOAT32"
        }
      }

      # supplemental_data_storage_configuration (Optional)
      # 設定内容: マルチモーダルコンテンツから抽出した画像の保存設定を行います。
      # 関連機能: マルチモーダルKnowledge Base
      #   マルチモーダルドキュメントから抽出した画像を保存するためのS3ロケーションを指定します。
      supplemental_data_storage_configuration {
        storage_location {
          # type (Required)
          # 設定内容: ストレージサービスのタイプを指定します。
          # 設定可能な値: "S3"（現在唯一の有効な値）
          type = "S3"

          s3_location {
            # uri (Required)
            # 設定内容: 抽出した画像を保存するS3 URIを指定します。
            # 設定可能な値: 有効なS3 URI（s3://bucket-name/prefix/形式）
            uri = "s3://my-bucket/extracted-images/"
          }
        }
      }
    }

    #-----------------------------------------------------------
    # KENDRAタイプ用設定 (kendra_knowledge_base_configuration)
    #-----------------------------------------------------------
    # typeが"KENDRA"の場合に使用します。
    # 以下は設定例です（vector_knowledge_base_configurationと排他的）。

    # kendra_knowledge_base_configuration {
    #   # kendra_index_arn (Required)
    #   # 設定内容: Amazon KendraインデックスのARNを指定します。
    #   # 設定可能な値: 有効なKendraインデックスARN
    #   kendra_index_arn = "arn:aws:kendra:us-east-1:123456789012:index/example-index-id"
    # }

    #-----------------------------------------------------------
    # SQLタイプ用設定 (sql_knowledge_base_configuration)
    #-----------------------------------------------------------
    # typeが"SQL"の場合に使用します。
    # 構造化データストア（Amazon Redshift）への接続設定を行います。
    # 以下は設定例です（vector_knowledge_base_configurationと排他的）。

    # sql_knowledge_base_configuration {
    #   # type (Required)
    #   # 設定内容: SQLデータベースのタイプを指定します。
    #   # 設定可能な値: "REDSHIFT"
    #   type = "REDSHIFT"
    #
    #   redshift_configuration {
    #     #---------------------------------------------------------
    #     # クエリエンジン設定 (query_engine_configuration)
    #     #---------------------------------------------------------
    #     query_engine_configuration {
    #       # type (Required)
    #       # 設定内容: クエリエンジンのタイプを指定します。
    #       # 設定可能な値:
    #       #   - "PROVISIONED": プロビジョンドRedshiftクラスター
    #       #   - "SERVERLESS": Redshift Serverless
    #       type = "PROVISIONED"
    #
    #       # provisioned_configuration (Optional)
    #       # typeが"PROVISIONED"の場合に使用します。
    #       provisioned_configuration {
    #         # cluster_identifier (Required)
    #         # 設定内容: RedshiftクラスターのIDを指定します。
    #         cluster_identifier = "my-redshift-cluster"
    #
    #         auth_configuration {
    #           # type (Required)
    #           # 設定内容: 認証タイプを指定します。
    #           # 設定可能な値:
    #           #   - "IAM": IAM認証
    #           #   - "USERNAME_PASSWORD": ユーザー名/パスワード認証
    #           #   - "USERNAME": データベースユーザー認証
    #           type = "USERNAME"
    #
    #           # database_user (Optional)
    #           # 設定内容: データベースユーザー名を指定します（typeがUSERNAMEの場合）。
    #           database_user = "admin"
    #
    #           # username_password_secret_arn (Optional)
    #           # 設定内容: Secrets ManagerシークレットのARNを指定します（typeがUSERNAME_PASSWORDの場合）。
    #           username_password_secret_arn = null
    #         }
    #       }
    #
    #       # serverless_configuration (Optional)
    #       # typeが"SERVERLESS"の場合に使用します。
    #       # serverless_configuration {
    #       #   # workgroup_arn (Required)
    #       #   # 設定内容: Redshift ServerlessワークグループのARNを指定します。
    #       #   workgroup_arn = "arn:aws:redshift-serverless:us-west-2:123456789012:workgroup/example-workgroup"
    #       #
    #       #   auth_configuration {
    #       #     # type (Required)
    #       #     # 設定内容: 認証タイプを指定します。
    #       #     # 設定可能な値:
    #       #     #   - "IAM": IAM認証
    #       #     #   - "USERNAME_PASSWORD": ユーザー名/パスワード認証
    #       #     type = "IAM"
    #       #
    #       #     # username_password_secret_arn (Optional)
    #       #     # 設定内容: Secrets ManagerシークレットのARNを指定します。
    #       #     username_password_secret_arn = null
    #       #   }
    #       # }
    #     }
    #
    #     #---------------------------------------------------------
    #     # ストレージ設定 (storage_configuration)
    #     #---------------------------------------------------------
    #     storage_configuration {
    #       # type (Required)
    #       # 設定内容: データストレージサービスを指定します。
    #       # 設定可能な値:
    #       #   - "REDSHIFT": Amazon Redshift
    #       #   - "AWS_DATA_CATALOG": AWS Glue Data Catalog
    #       type = "REDSHIFT"
    #
    #       redshift_configuration {
    #         # database_name (Required)
    #         # 設定内容: Redshiftデータベース名を指定します。
    #         database_name = "my_database"
    #       }
    #
    #       # aws_data_catalog_configuration (Optional)
    #       # typeが"AWS_DATA_CATALOG"の場合に使用します。
    #       # aws_data_catalog_configuration {
    #       #   # table_names (Required)
    #       #   # 設定内容: 使用するテーブル名のリストを指定します。
    #       #   table_names = ["table1", "table2"]
    #       # }
    #     }
    #
    #     #---------------------------------------------------------
    #     # クエリ生成設定 (query_generation_configuration) (Optional)
    #     #---------------------------------------------------------
    #     query_generation_configuration {
    #       # execution_timeout_seconds (Optional)
    #       # 設定内容: クエリ生成のタイムアウト秒数を指定します。
    #       execution_timeout_seconds = 60
    #
    #       generation_context {
    #         # curated_query (Optional)
    #         # 設定内容: クエリエンジンがSQLクエリを生成するための例示クエリを指定します。
    #         curated_query {
    #           # natural_language (Required)
    #           # 設定内容: 自然言語でのクエリ例を指定します。
    #           natural_language = "Show me the top 5 customers by total purchase amount"
    #
    #           # sql (Required)
    #           # 設定内容: natural_languageに対応するSQLクエリを指定します。
    #           sql = "SELECT customer_id, SUM(amount) as total FROM orders GROUP BY customer_id ORDER BY total DESC LIMIT 5"
    #         }
    #
    #         # table (Optional)
    #         # 設定内容: クエリ生成に使用するテーブル情報を指定します。
    #         table {
    #           # name (Required)
    #           # 設定内容: テーブル名を指定します。
    #           name = "orders"
    #
    #           # description (Optional)
    #           # 設定内容: テーブルの説明を指定します。
    #           description = "Customer orders table"
    #
    #           # inclusion (Optional)
    #           # 設定内容: クエリ生成時にこのテーブルを含めるか除外するかを指定します。
    #           # 設定可能な値:
    #           #   - "INCLUDE": テーブルを含める
    #           #   - "EXCLUDE": テーブルを除外する
    #           inclusion = "INCLUDE"
    #
    #           # column (Optional)
    #           # 設定内容: テーブル内のカラム情報を指定します。
    #           column {
    #             # name (Optional)
    #             # 設定内容: カラム名を指定します。
    #             name = "customer_id"
    #
    #             # description (Optional)
    #             # 設定内容: カラムの説明を指定します。
    #             description = "Unique customer identifier"
    #
    #             # inclusion (Optional)
    #             # 設定内容: クエリ生成時にこのカラムを含めるか除外するかを指定します。
    #             # 設定可能な値:
    #             #   - "INCLUDE": カラムを含める
    #             #   - "EXCLUDE": カラムを除外する
    #             inclusion = "INCLUDE"
    #           }
    #         }
    #       }
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # ストレージ設定 (storage_configuration)
  #-------------------------------------------------------------
  # Knowledge Baseのベクトルデータを保存するストレージの設定を行います。
  # このブロックはオプションですが、VECTORタイプでは通常必要です。
  # リソース作成後は変更できません（Forces new resource）。

  storage_configuration {
    # type (Required)
    # 設定内容: ベクトルストアサービスを指定します。
    # 設定可能な値:
    #   - "OPENSEARCH_SERVERLESS": Amazon OpenSearch Serverless
    #   - "OPENSEARCH_MANAGED_CLUSTER": Amazon OpenSearch Service Managed Cluster
    #   - "PINECONE": Pinecone
    #   - "REDIS_ENTERPRISE_CLOUD": Redis Enterprise Cloud
    #   - "RDS": Amazon RDS（PostgreSQL）
    #   - "MONGO_DB_ATLAS": MongoDB Atlas
    #   - "NEPTUNE_ANALYTICS": Amazon Neptune Analytics
    #   - "S3_VECTORS": Amazon S3 Vectors
    type = "OPENSEARCH_SERVERLESS"

    #-----------------------------------------------------------
    # OpenSearch Serverless設定 (opensearch_serverless_configuration)
    #-----------------------------------------------------------

    opensearch_serverless_configuration {
      # collection_arn (Required)
      # 設定内容: OpenSearch ServerlessコレクションのARNを指定します。
      # 設定可能な値: 有効なOpenSearch Serverless コレクションARN
      collection_arn = "arn:aws:aoss:us-west-2:123456789012:collection/142bezjddq707i5stcrf"

      # vector_index_name (Required)
      # 設定内容: ベクトルインデックスの名前を指定します。
      # 設定可能な値: 有効なインデックス名
      vector_index_name = "bedrock-knowledge-base-default-index"

      field_mapping {
        # vector_field (Required)
        # 設定内容: ベクトル埋め込みを保存するフィールド名を指定します。
        vector_field = "bedrock-knowledge-base-default-vector"

        # text_field (Required)
        # 設定内容: 生テキストを保存するフィールド名を指定します。
        text_field = "AMAZON_BEDROCK_TEXT_CHUNK"

        # metadata_field (Required)
        # 設定内容: メタデータを保存するフィールド名を指定します。
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }

    #-----------------------------------------------------------
    # OpenSearch Managed Cluster設定 (opensearch_managed_cluster_configuration)
    #-----------------------------------------------------------
    # typeが"OPENSEARCH_MANAGED_CLUSTER"の場合に使用します。

    # opensearch_managed_cluster_configuration {
    #   # domain_arn (Required)
    #   # 設定内容: OpenSearchドメインのARNを指定します。
    #   domain_arn = "arn:aws:es:us-west-2:123456789012:domain/example-domain"
    #
    #   # domain_endpoint (Required)
    #   # 設定内容: OpenSearchドメインのエンドポイントURLを指定します。
    #   domain_endpoint = "https://search-example-domain.us-west-2.es.amazonaws.com"
    #
    #   # vector_index_name (Required)
    #   # 設定内容: ベクトルインデックスの名前を指定します。
    #   vector_index_name = "example-index"
    #
    #   field_mapping {
    #     # vector_field (Required)
    #     # 設定内容: ベクトル埋め込みを保存するフィールド名を指定します。
    #     vector_field = "embedding"
    #
    #     # text_field (Required)
    #     # 設定内容: 生テキストを保存するフィールド名を指定します。
    #     text_field = "chunks"
    #
    #     # metadata_field (Required)
    #     # 設定内容: メタデータを保存するフィールド名を指定します。
    #     metadata_field = "metadata"
    #   }
    # }

    #-----------------------------------------------------------
    # Pinecone設定 (pinecone_configuration)
    #-----------------------------------------------------------
    # typeが"PINECONE"の場合に使用します。

    # pinecone_configuration {
    #   # connection_string (Required)
    #   # 設定内容: Pineconeインデックス管理ページのエンドポイントURLを指定します。
    #   connection_string = "https://example-index-12345.svc.pinecone.io"
    #
    #   # credentials_secret_arn (Required)
    #   # 設定内容: PineconeのAPIキーを含むSecrets ManagerシークレットのARNを指定します。
    #   credentials_secret_arn = "arn:aws:secretsmanager:us-west-2:123456789012:secret:pinecone-api-key"
    #
    #   # namespace (Optional)
    #   # 設定内容: データを書き込むPinecone名前空間を指定します。
    #   namespace = "my-namespace"
    #
    #   field_mapping {
    #     # text_field (Required)
    #     # 設定内容: 生テキストを保存するフィールド名を指定します。
    #     text_field = "text"
    #
    #     # metadata_field (Required)
    #     # 設定内容: メタデータを保存するフィールド名を指定します。
    #     metadata_field = "metadata"
    #   }
    # }

    #-----------------------------------------------------------
    # RDS設定 (rds_configuration)
    #-----------------------------------------------------------
    # typeが"RDS"の場合に使用します（PostgreSQLのpgvector拡張）。

    # rds_configuration {
    #   # resource_arn (Required)
    #   # 設定内容: RDSクラスターまたはインスタンスのARNを指定します。
    #   resource_arn = "arn:aws:rds:us-west-2:123456789012:cluster:my-aurora-cluster"
    #
    #   # credentials_secret_arn (Required)
    #   # 設定内容: データベース認証情報を含むSecrets ManagerシークレットのARNを指定します。
    #   credentials_secret_arn = "arn:aws:secretsmanager:us-west-2:123456789012:secret:rds-credentials"
    #
    #   # database_name (Required)
    #   # 設定内容: データベース名を指定します。
    #   database_name = "bedrock_kb"
    #
    #   # table_name (Required)
    #   # 設定内容: ベクトルデータを保存するテーブル名を指定します。
    #   table_name = "bedrock_integration.bedrock_kb"
    #
    #   field_mapping {
    #     # primary_key_field (Required)
    #     # 設定内容: プライマリキーフィールド名を指定します。
    #     primary_key_field = "id"
    #
    #     # vector_field (Required)
    #     # 設定内容: ベクトル埋め込みを保存するフィールド名を指定します。
    #     vector_field = "embedding"
    #
    #     # text_field (Required)
    #     # 設定内容: 生テキストを保存するフィールド名を指定します。
    #     text_field = "chunks"
    #
    #     # metadata_field (Required)
    #     # 設定内容: メタデータを保存するフィールド名を指定します。
    #     metadata_field = "metadata"
    #
    #     # custom_metadata_field (Optional)
    #     # 設定内容: カスタムメタデータを保存するフィールド名を指定します。
    #     custom_metadata_field = "custom_metadata"
    #   }
    # }

    #-----------------------------------------------------------
    # Redis Enterprise Cloud設定 (redis_enterprise_cloud_configuration)
    #-----------------------------------------------------------
    # typeが"REDIS_ENTERPRISE_CLOUD"の場合に使用します。

    # redis_enterprise_cloud_configuration {
    #   # endpoint (Required)
    #   # 設定内容: Redis Enterprise CloudデータベースのエンドポイントURLを指定します。
    #   endpoint = "redis-12345.c1.us-west-2.ec2.cloud.redislabs.com:12345"
    #
    #   # credentials_secret_arn (Required)
    #   # 設定内容: Redis認証情報を含むSecrets ManagerシークレットのARNを指定します。
    #   credentials_secret_arn = "arn:aws:secretsmanager:us-west-2:123456789012:secret:redis-credentials"
    #
    #   # vector_index_name (Required)
    #   # 設定内容: ベクトルインデックスの名前を指定します。
    #   vector_index_name = "bedrock-kb-index"
    #
    #   field_mapping {
    #     # vector_field (Optional)
    #     # 設定内容: ベクトル埋め込みを保存するフィールド名を指定します。
    #     vector_field = "embedding"
    #
    #     # text_field (Optional)
    #     # 設定内容: 生テキストを保存するフィールド名を指定します。
    #     text_field = "text"
    #
    #     # metadata_field (Optional)
    #     # 設定内容: メタデータを保存するフィールド名を指定します。
    #     metadata_field = "metadata"
    #   }
    # }

    #-----------------------------------------------------------
    # MongoDB Atlas設定 (mongo_db_atlas_configuration)
    #-----------------------------------------------------------
    # typeが"MONGO_DB_ATLAS"の場合に使用します。

    # mongo_db_atlas_configuration {
    #   # endpoint (Required)
    #   # 設定内容: MongoDB Atlasクラスターのエンドポイントを指定します。
    #   endpoint = "mongodb+srv://cluster0.example.mongodb.net"
    #
    #   # credentials_secret_arn (Required)
    #   # 設定内容: MongoDB認証情報を含むSecrets ManagerシークレットのARNを指定します。
    #   credentials_secret_arn = "arn:aws:secretsmanager:us-west-2:123456789012:secret:mongodb-credentials"
    #
    #   # database_name (Required)
    #   # 設定内容: データベース名を指定します。
    #   database_name = "bedrock_kb"
    #
    #   # collection_name (Required)
    #   # 設定内容: コレクション名を指定します。
    #   collection_name = "bedrock_collection"
    #
    #   # vector_index_name (Required)
    #   # 設定内容: ベクトルインデックスの名前を指定します。
    #   vector_index_name = "bedrock_vector_index"
    #
    #   # endpoint_service_name (Optional)
    #   # 設定内容: AWS PrivateLink経由で接続する場合のエンドポイントサービス名を指定します。
    #   endpoint_service_name = null
    #
    #   # text_index_name (Optional)
    #   # 設定内容: テキストインデックスの名前を指定します。
    #   text_index_name = null
    #
    #   field_mapping {
    #     # vector_field (Required)
    #     # 設定内容: ベクトル埋め込みを保存するフィールド名を指定します。
    #     vector_field = "embedding"
    #
    #     # text_field (Required)
    #     # 設定内容: 生テキストを保存するフィールド名を指定します。
    #     text_field = "text"
    #
    #     # metadata_field (Required)
    #     # 設定内容: メタデータを保存するフィールド名を指定します。
    #     metadata_field = "metadata"
    #   }
    # }

    #-----------------------------------------------------------
    # Neptune Analytics設定 (neptune_analytics_configuration)
    #-----------------------------------------------------------
    # typeが"NEPTUNE_ANALYTICS"の場合に使用します。
    # GraphRAGアプリケーションの構築に使用します。

    # neptune_analytics_configuration {
    #   # graph_arn (Required)
    #   # 設定内容: Neptune Analyticsグラフ（ベクトルストア）のARNを指定します。
    #   graph_arn = "arn:aws:neptune-graph:us-west-2:123456789012:graph/g-12345678"
    #
    #   field_mapping {
    #     # text_field (Required)
    #     # 設定内容: 生テキストを保存するフィールド名を指定します。
    #     text_field = "text"
    #
    #     # metadata_field (Required)
    #     # 設定内容: メタデータを保存するフィールド名を指定します。
    #     metadata_field = "metadata"
    #   }
    # }

    #-----------------------------------------------------------
    # S3 Vectors設定 (s3_vectors_configuration)
    #-----------------------------------------------------------
    # typeが"S3_VECTORS"の場合に使用します。
    # Amazon S3 Vectorsを使用したベクトルストレージ設定です。

    # s3_vectors_configuration {
    #   # index_arn (Optional)
    #   # 設定内容: S3 VectorsインデックスのARNを指定します。
    #   # 注意: index_name/vector_bucket_arnと排他的
    #   index_arn = "arn:aws:s3vectors:us-west-2:123456789012:bucket/example-bucket/index/example-index"
    #
    #   # index_name (Optional)
    #   # 設定内容: S3 Vectorsインデックスの名前を指定します。
    #   # 注意: vector_bucket_arnと一緒に指定。index_arnと排他的
    #   # index_name = "example-index"
    #
    #   # vector_bucket_arn (Optional)
    #   # 設定内容: S3 VectorsベクトルバケットのARNを指定します。
    #   # 注意: index_nameと一緒に指定。index_arnと排他的
    #   # vector_bucket_arn = "arn:aws:s3vectors:us-west-2:123456789012:bucket/example-bucket"
    # }
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (timeouts)
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    delete = "30m"
  }

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
    Name        = "example-knowledge-base"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Knowledge BaseのAmazon Resource Name (ARN)
#
# - id: Knowledge Baseの一意の識別子
#
# - created_at: Knowledge Baseが作成された日時
#
# - updated_at: Knowledge Baseが最後に更新された日時
#
# - failure_reasons: Knowledge Baseの作成または更新が失敗した場合の理由のリスト
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
