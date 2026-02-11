#---------------------------------------------------------------
# Amazon OpenSearch Ingestion Pipeline
#---------------------------------------------------------------
#
# OpenSearch Ingestion パイプラインを作成します。
# パイプラインはデータソース（S3、Fluent Bit、OpenTelemetry Collector等）から
# データを取得し、Amazon OpenSearch Service ドメインまたは OpenSearch Serverless
# コレクションに送信するメカニズムです。
#
# 主な用途:
#   - ログ、メトリクス、トレースデータの取り込み
#   - データの変換・フィルタリング・エンリッチメント
#   - リアルタイムデータストリーミング処理
#
# AWS公式ドキュメント:
#   - OpenSearch Ingestion パイプラインの作成: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/creating-pipeline.html
#   - OpenSearch Ingestion スケーリング: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ingestion-scaling.html
#   - OpenSearch Ingestion API リファレンス: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_osis_CreatePipeline.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/osis_pipeline
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_osis_pipeline" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # パイプライン名（一意な識別子）
  # AWS リージョン内のアカウントで一意である必要があります
  # 命名規則: 英数字とハイフン、アンダースコアが使用可能
  pipeline_name = "example-pipeline"

  # パイプライン設定（YAML形式）
  # Data Prepper の設定を YAML 形式で指定します
  # - version: Data Prepper のメジャーバージョン（例: "2"）
  # - source: データソースの設定（http, s3, otel-trace, otel-metrics 等）
  # - processor: データ変換・フィルタリング設定（任意）
  # - sink: データの送信先設定（OpenSearch ドメインまたは Serverless コレクション）
  #
  # ファイルから読み込む場合: file("pipeline.yaml")
  # インラインで指定する場合は各行を \n でエスケープ
  pipeline_configuration_body = <<-EOT
    version: "2"
    example-pipeline:
      source:
        http:
          path: "/log/ingest"
      sink:
        - opensearch:
            hosts: ["https://example-domain.us-east-1.es.amazonaws.com"]
            aws:
              sts_role_arn: "arn:aws:iam::123456789012:role/pipeline-role"
              region: "us-east-1"
            index: "logs"
  EOT

  # 最大容量（Ingestion Compute Units）
  # パイプラインがスケールアウトできる最大の ICU 数
  # 各 ICU は約 15 GiB のメモリと 2 vCPU を提供
  # 標準的なログパイプラインでは 1 ICU あたり約 2 MiB/秒を処理可能
  # 範囲: 1-384 ICU
  max_units = 4

  # 最小容量（Ingestion Compute Units）
  # パイプラインの初期容量および最小容量
  # ステートレスパイプライン: 最小 1 ICU
  # プッシュベースソース: 最小 2 ICU
  # 永続バッファリング有効時: 最小 2 ICU
  # 高可用性のため 2 ICU 以上を推奨（99.9% SLA）
  min_units = 2

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # パイプラインロール ARN
  # OpenSearch Ingestion が AWS リソースにアクセスするための IAM ロール
  # 未指定の場合は自動的に作成される場合があります
  # このロールには以下の権限が必要:
  #   - OpenSearch ドメイン/コレクションへの書き込み権限
  #   - S3 バケットへのアクセス権限（S3 ソース使用時）
  #   - CloudWatch Logs への書き込み権限（ログ公開時）
  #   - KMS キーの使用権限（暗号化有効時）
  pipeline_role_arn = "arn:aws:iam::123456789012:role/pipeline-role"

  # リージョン設定
  # このリソースが管理されるリージョン
  # 未指定の場合はプロバイダー設定のリージョンが使用されます
  region = "us-east-1"

  # タグ
  # パイプラインに割り当てるタグのマップ
  # コスト配分、リソース管理、アクセス制御に使用可能
  tags = {
    Environment = "production"
    Application = "logging"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # バッファオプション
  #---------------------------------------------------------------
  # 永続バッファリングの設定
  # データ損失を防ぐためにディスクにデータを永続化します
  #
  # 有効にすると:
  #   - データは処理前にディスクに書き込まれます
  #   - パイプライン障害時でもデータが保持されます
  #   - レイテンシーとコストが増加する可能性があります
  #   - 最小 2 ICU が必要です

  buffer_options {
    # 永続バッファリングの有効化
    # true: バッファリングを有効化
    # false: バッファリングを無効化（メモリのみ使用）
    persistent_buffer_enabled = true
  }

  #---------------------------------------------------------------
  # 保管時の暗号化オプション
  #---------------------------------------------------------------
  # 永続バッファに書き込まれるデータの暗号化設定
  # 永続バッファが有効な場合のみ使用可能

  encryption_at_rest_options {
    # KMS キー ARN
    # データ暗号化に使用する AWS KMS カスタマーマネージドキー
    # 未指定の場合は AWS 所有のキーが使用されます
    #
    # 注意事項:
    #   - パイプラインロールに kms:Decrypt, kms:GenerateDataKey 権限が必要
    #   - KMS キーポリシーでパイプラインロールの使用を許可する必要があります
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #---------------------------------------------------------------
  # ログ公開オプション
  #---------------------------------------------------------------
  # パイプラインログを Amazon CloudWatch Logs に送信する設定

  log_publishing_options {
    # ログ公開の有効化
    # true: CloudWatch Logs にログを送信
    # false: ログを送信しない
    is_logging_enabled = true

    # CloudWatch Logs 送信先設定
    cloudwatch_log_destination {
      # ログを送信する CloudWatch Logs ロググループ名
      # 既存のロググループを指定するか、新規作成が必要
      # 命名例: /aws/OpenSearchService/IngestionService/my-pipeline
      #
      # 注意事項:
      #   - パイプラインロールに logs:PutLogEvents 権限が必要
      #   - ロググループに適切なリソースポリシーを設定
      log_group = "/aws/opensearch-ingestion/example-pipeline"
    }
  }

  #---------------------------------------------------------------
  # VPC オプション
  #---------------------------------------------------------------
  # パイプラインを VPC 内に配置する設定
  # 指定しない場合はパブリックエンドポイントが作成されます
  #
  # VPC 配置の利点:
  #   - プライベートネットワーク経由でのデータ送信
  #   - セキュリティグループによるアクセス制御
  #   - VPC 内のリソースとの直接通信
  #
  # 注意事項:
  #   - 最初のパイプライン作成時に Service Linked Role が必要
  #   - サブネットは異なる Availability Zone に配置することを推奨

  vpc_options {
    # サブネット ID のリスト（必須）
    # パイプラインの VPC エンドポイントを配置するサブネット
    # 高可用性のため複数の AZ にまたがるサブネットを指定することを推奨
    # 最低 2 つのサブネットが推奨されます
    subnet_ids = [
      "subnet-12345678",
      "subnet-87654321"
    ]

    # セキュリティグループ ID のリスト（任意）
    # VPC エンドポイントに適用するセキュリティグループ
    #
    # 推奨設定:
    #   - インバウンド: データソースからの通信を許可
    #   - アウトバウンド: OpenSearch ドメインへの通信を許可
    security_group_ids = [
      "sg-12345678"
    ]

    # VPC エンドポイント管理（任意）
    # VPC エンドポイントの作成・管理方法を指定
    #
    # 設定値:
    #   - "CUSTOMER": お客様が VPC エンドポイントを作成・管理
    #   - "SERVICE": OpenSearch Ingestion サービスが作成・管理（デフォルト）
    #
    # CUSTOMER を選択した場合:
    #   - 事前に VPC エンドポイントを作成する必要があります
    #   - より細かい制御が可能です
    vpc_endpoint_management = "SERVICE"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------
  # Terraform のリソース操作タイムアウト設定
  # パイプラインの作成・更新・削除には時間がかかる場合があります

  timeouts {
    # 作成タイムアウト
    # デフォルト: 45 分
    create = "45m"

    # 更新タイムアウト
    # デフォルト: 45 分
    update = "45m"

    # 削除タイムアウト
    # デフォルト: 45 分
    delete = "45m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に設定され、参照のみ可能です。
# これらは resource ブロック内で設定することはできません。
#
# - id
#     パイプラインの一意な識別子
#     値: pipeline_name と同じ
#
# - pipeline_arn
#     パイプラインの Amazon Resource Name (ARN)
#     形式: arn:aws:osis:region:account-id:pipeline/pipeline-name
#     用途: IAM ポリシー、リソースタグ付け、クロスアカウントアクセス
#
# - ingest_endpoint_urls
#     データ送信用のエンドポイント URL のリスト
#     形式: ["https://pipeline-name-xxxxx.region.osis.amazonaws.com"]
#     用途: クライアントアプリケーションの設定
#     注意: パイプライン設定の path オプションと組み合わせて使用
#
# - tags_all
#     プロバイダーの default_tags とリソースの tags をマージした全タグ
#     用途: タグの完全なリストを参照する場合に使用
#
#---------------------------------------------------------------
# 使用例: 参照専用属性の利用
#---------------------------------------------------------------
# output "pipeline_arn" {
#   description = "OpenSearch Ingestion パイプラインの ARN"
#   value       = aws_osis_pipeline.example.pipeline_arn
# }
#
# output "ingest_endpoints" {
#   description = "データ送信用のエンドポイント URL"
#   value       = aws_osis_pipeline.example.ingest_endpoint_urls
# }
#
# # 他のリソースでの参照例
# resource "aws_iam_policy" "pipeline_access" {
#   name = "pipeline-access-policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "osis:Ingest"
#         ]
#         Resource = aws_osis_pipeline.example.pipeline_arn
#       }
#     ]
#   })
# }
#---------------------------------------------------------------
