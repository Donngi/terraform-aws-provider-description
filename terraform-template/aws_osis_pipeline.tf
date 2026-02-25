#---------------------------------------------------------------
# AWS OpenSearch Ingestion Pipeline
#---------------------------------------------------------------
#
# Amazon OpenSearch Ingestion のパイプラインをプロビジョニングするリソースです。
# パイプラインはデータのソースからシンク（OpenSearch Service ドメインや
# OpenSearch Serverless コレクション）への取り込み・変換・ルーティングを管理します。
# Data Prepper を基盤として動作し、YAML 形式でパイプライン設定を記述します。
#
# AWS公式ドキュメント:
#   - OpenSearch Ingestion パイプラインの作成: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/creating-pipeline.html
#   - パイプライン機能の概要: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/osis-features-overview.html
#   - パイプラインの主要概念: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ingestion-process.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/osis_pipeline
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_osis_pipeline" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # pipeline_name (Required, Forces new resource)
  # 設定内容: OpenSearch Ingestion パイプラインの名前を指定します。
  # 設定可能な値: AWSアカウント内のリージョンで一意の文字列
  # 注意: パイプライン名は作成後に変更できません。
  pipeline_name = "example-pipeline"

  # pipeline_configuration_body (Required)
  # 設定内容: YAML 形式のパイプライン設定を文字列として指定します。
  # 設定可能な値: Data Prepper パイプライン設定を記述した YAML 文字列、
  #               またはファイルパス（file() 関数使用時）
  # 注意: 文字列として指定する場合、改行は \n でエスケープが必要です。
  #       file() 関数を使用して外部 YAML ファイルを参照することも可能です。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/creating-pipeline.html
  pipeline_configuration_body = <<-EOT
    version: "2"
    example-pipeline:
      source:
        http:
          path: "/example"
      sink:
        - opensearch:
            hosts:
              - "https://example.ap-northeast-1.es.amazonaws.com"
            index: "example-index"
            aws:
              sts_role_arn: "arn:aws:iam::123456789012:role/example-pipeline-role"
              region: "ap-northeast-1"
  EOT

  # min_units (Required)
  # 設定内容: パイプラインの最小キャパシティを Ingestion Compute Units (ICU) で指定します。
  # 設定可能な値: 1 以上の整数。max_units 以下の値を指定してください。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/creating-pipeline.html
  min_units = 1

  # max_units (Required)
  # 設定内容: パイプラインの最大キャパシティを Ingestion Compute Units (ICU) で指定します。
  # 設定可能な値: min_units 以上の整数
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/creating-pipeline.html
  max_units = 4

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # pipeline_role_arn (Optional)
  # 設定内容: パイプラインが AWS リソースにアクセスするための IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロール ARN。
  #               ロールの信頼ポリシーに osis-pipelines.amazonaws.com を許可する必要があります。
  # 省略時: Terraform が自動的に管理します（computed）。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/pipeline-collection-access.html
  pipeline_role_arn = "arn:aws:iam::123456789012:role/example-pipeline-role"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # バッファ設定
  #-------------------------------------------------------------

  # buffer_options (Optional)
  # 設定内容: パイプラインの永続バッファ設定ブロックです。
  # 関連機能: OpenSearch Ingestion 永続バッファ
  #   複数のアベイラビリティーゾーンにまたがるディスクベースのバッファにデータを保存します。
  #   最大 72 時間のデータ保持が可能で、耐久性が向上します。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/osis-features-overview.html
  buffer_options {

    # persistent_buffer_enabled (Required)
    # 設定内容: 永続バッファを有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: 永続バッファを有効化。データをディスクに保存し耐障害性を向上させます
    #   - false: 永続バッファを無効化。インメモリバッファを使用します
    persistent_buffer_enabled = true
  }

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_at_rest_options (Optional)
  # 設定内容: 永続バッファに書き込まれるデータの暗号化設定ブロックです。
  # 注意: buffer_options で永続バッファを有効にした場合にのみ有効です。
  # 関連機能: OpenSearch Ingestion 保存時暗号化
  #   KMS キーを使用して永続バッファ内のデータを暗号化します。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/osis-features-overview.html
  encryption_at_rest_options {

    # kms_key_arn (Required)
    # 設定内容: データの暗号化に使用する KMS キーの ARN を指定します。
    # 設定可能な値: 有効な AWS KMS キー ARN
    # 省略時: AWS マネージドキーが使用されます。
    kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # ログ出力設定
  #-------------------------------------------------------------

  # log_publishing_options (Optional)
  # 設定内容: パイプラインのログを Amazon CloudWatch Logs に出力する設定ブロックです。
  # 関連機能: OpenSearch Ingestion ログ発行
  #   パイプラインの処理ログを CloudWatch Logs に送信してモニタリングできます。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/osis-best-practices.html
  log_publishing_options {

    # is_logging_enabled (Optional)
    # 設定内容: ログの発行を有効にするかどうかを指定します。
    # 設定可能な値:
    #   - true: ログ発行を有効化
    #   - false: ログ発行を無効化
    # 省略時: ログ発行は無効となります。
    is_logging_enabled = true

    # cloudwatch_log_destination (Optional)
    # 設定内容: CloudWatch Logs へのログ送信先設定ブロックです。
    # 注意: is_logging_enabled が true の場合は必須です。
    cloudwatch_log_destination {

      # log_group (Required)
      # 設定内容: パイプラインログの送信先 CloudWatch Logs グループ名を指定します。
      # 設定可能な値: 既存または新規作成する CloudWatch Logs グループ名
      # 参考: グループ名の例: /aws/OpenSearchService/IngestionService/my-pipeline
      log_group = "/aws/OpenSearchService/IngestionService/example-pipeline"
    }
  }

  #-------------------------------------------------------------
  # VPCアクセス設定
  #-------------------------------------------------------------

  # vpc_options (Optional)
  # 設定内容: パイプラインの VPC アクセスを設定するブロックです。
  # 省略時: OpenSearch Ingestion はパブリックエンドポイントでパイプラインを作成します。
  # 関連機能: OpenSearch Ingestion VPCアクセス
  #   VPC 内のリソースへプライベートアクセスが可能になります。
  #   高可用性のため、複数のサブネットを指定することが推奨されます。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/osis-best-practices.html
  vpc_options {

    # subnet_ids (Required)
    # 設定内容: VPC エンドポイントに関連付けるサブネット ID のリストを指定します。
    # 設定可能な値: 有効なサブネット ID のリスト
    # 注意: 高可用性のため、複数のアベイラビリティーゾーンにまたがるサブネットを指定することを推奨します。
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # security_group_ids (Optional)
    # 設定内容: VPC エンドポイントに関連付けるセキュリティグループ ID のリストを指定します。
    # 設定可能な値: 有効なセキュリティグループ ID のリスト
    # 省略時: デフォルトのセキュリティグループが使用されます。
    security_group_ids = ["sg-12345678"]

    # vpc_endpoint_management (Optional)
    # 設定内容: VPC エンドポイントの管理者を指定します。
    # 設定可能な値:
    #   - "CUSTOMER": ユーザーが VPC エンドポイントを作成・管理します
    #   - "SERVICE": Amazon OpenSearch Ingestion サービスが VPC エンドポイントを作成・管理します
    # 省略時: サービスがデフォルトの管理方式を使用します。
    vpc_endpoint_management = "SERVICE"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など、数値と時間単位（s/m/h）の組み合わせ
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など、数値と時間単位（s/m/h）の組み合わせ
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" など、数値と時間単位（s/m/h）の組み合わせ
    # 省略時: プロバイダーのデフォルトタイムアウトを使用します。
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし。プロバイダーの default_tags が設定されている場合はそちらが適用されます。
  tags = {
    Name        = "example-pipeline"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: パイプラインの一意な識別子
# - pipeline_arn: パイプラインの Amazon Resource Name (ARN)
# - ingest_endpoint_urls: パイプラインへのデータ送信に使用するエンドポイント URL のリスト
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
