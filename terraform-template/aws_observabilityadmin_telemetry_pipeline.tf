#---------------------------------------------------------------
# AWS CloudWatch Observability Admin テレメトリパイプライン
#---------------------------------------------------------------
#
# AWS CloudWatch Observability Adminのテレメトリパイプラインを
# プロビジョニングするリソースです。
# テレメトリパイプラインは、AWSサービスからのテレメトリデータの
# 収集、変換、ルーティングを定義します。パイプラインは
# ソース、オプションのプロセッサ、1つ以上のシンクで構成されます。
#
# 注意: データソースタイプごとにアカウントあたり1つのパイプラインのみ
#       許可されます。例えば、amazon_api_gateway/access用と
#       amazon_vpc/flow用に各1つ作成できますが、同じデータソースタイプで
#       2つのパイプラインは作成できません。
#
# AWS公式ドキュメント:
#   - Observability Admin概要: https://docs.aws.amazon.com/cloudwatch/latest/observabilityadmin/what-is-observabilityadmin.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/observabilityadmin_telemetry_pipeline
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_observabilityadmin_telemetry_pipeline" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: テレメトリパイプラインの名前を指定します。
  # 設定可能な値: 3〜28文字。小文字で始まり、小文字、数字、ハイフンのみ使用可能
  # 注意: リソース作成後の変更はできません（Forces new resource）
  name = "example-pipeline"

  #-------------------------------------------------------------
  # パイプライン構成設定
  #-------------------------------------------------------------

  # configuration (Required)
  # 設定内容: テレメトリパイプラインの構成ブロックです。
  # パイプラインのソース、プロセッサ、シンクをYAML形式で定義します。
  configuration {
    # body (Required)
    # 設定内容: パイプライン構成本体をYAMLエンコードされた文字列で指定します。
    #          データ処理ルールと変換を定義します。
    # 設定可能な値: YAML形式の文字列（最大24,000文字）
    # 構成要素:
    #   - source: データの取得元（CloudWatch Logs、S3など）。1つ必須
    #   - processor: データの変換・加工（オプション）。順番に適用
    #   - sink: 処理済みデータの送信先。1つ必須
    #   - extensions: 追加機能（AWS Secrets Manager連携など、オプション）
    body = yamlencode({
      pipeline = {
        source = {
          cloudwatch_logs = {
            aws = {
              sts_role_arn = "arn:aws:iam::123456789012:role/example-telemetry-pipeline"
            }
            log_event_metadata = {
              data_source_name = "amazon_api_gateway"
              data_source_type = "access"
            }
          }
        }
        sink = [{
          cloudwatch_logs = {
            log_group = "@original"
          }
        }]
      }
    })
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-pipeline"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h45m"）
    # 省略時: デフォルトのタイムアウトが適用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h45m"）
    # 省略時: デフォルトのタイムアウトが適用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h45m"）
    # 省略時: デフォルトのタイムアウトが適用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テレメトリパイプラインのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承された
#             タグを含む、リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
