#---------------------------------------------------------------
# Amazon Managed Service for Prometheus (AMP) Workspace
#---------------------------------------------------------------
#
# Amazon Managed Service for Prometheus (AMP) のワークスペースを
# プロビジョニングするリソースです。ワークスペースは Prometheus メトリクス
# データの取り込み・クエリ・アラート評価を行う論理的な空間です。
#
# AWS公式ドキュメント:
#   - AMP ワークスペースの作成: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-create-workspace.html
#   - AMP での保存時暗号化: https://docs.aws.amazon.com/prometheus/latest/userguide/encryption-at-rest-Amazon-Service-Prometheus.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_prometheus_workspace" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # alias (Optional)
  # 設定内容: ワークスペースのエイリアス（表示名）を指定します。
  # 設定可能な値: 文字列（人間が読みやすい名前）
  # 省略時: エイリアスは設定されません。
  # 参考: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-create-workspace.html
  alias = "example-workspace"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional)
  # 設定内容: ワークスペースのデータ暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMS CMKのARN
  # 省略時: AWSが管理するデフォルトの暗号化キーを使用してデータを暗号化します。
  # 参考: https://docs.aws.amazon.com/prometheus/latest/userguide/encryption-at-rest-Amazon-Service-Prometheus.html
  kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_configuration (Optional)
  # 設定内容: ワークスペースのロギング設定ブロックです。
  # 設定可能な値: 以下のサブ属性を持つブロック
  # 関連機能: AMP CloudWatchロギング
  #   AMP ワークスペースへのベンドログを CloudWatch Logs グループに
  #   発行する機能です。
  logging_configuration {

    # log_group_arn (Required)
    # 設定内容: ベンドログデータの発行先となる CloudWatch Logs グループのARNを指定します。
    # 設定可能な値: 有効な CloudWatch Logs グループのARN。ARNの末尾は `:*` で終わる必要があります。
    # 注意: 指定するロググループは事前に存在している必要があります。ARNの末尾に `:*` を付与してください。
    log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:example:*"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-amp-workspace"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ワークスペースの Amazon Resource Name (ARN)
# - id: ワークスペースの識別子
# - prometheus_endpoint: このワークスペースで利用可能な Prometheus エンドポイント URL
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
