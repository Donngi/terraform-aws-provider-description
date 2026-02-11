#---------------------------------------------------------------
# AWS CloudWatch Observability Access Manager Link
#---------------------------------------------------------------
#
# CloudWatch Observability Access Manager (OAM) のリンクをプロビジョニングするリソースです。
# OAMリンクは、ソースアカウントとモニタリングアカウント間の接続を作成し、
# クロスアカウントでのメトリクス、ログ、トレースなどの観測データの共有を可能にします。
#
# AWS公式ドキュメント:
#   - CloudWatch クロスアカウント観測性: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Unified-Cross-Account.html
#   - OAM API リファレンス: https://docs.aws.amazon.com/OAM/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/oam_link
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_oam_link" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # label_template (Required)
  # 設定内容: モニタリングアカウントでデータを表示する際に、このソースアカウントを
  #          識別するために使用する人間が読みやすい名前のテンプレートを指定します。
  # 設定可能な値:
  #   - "$AccountName" - ソースアカウントの名前
  #   - "$AccountEmail" - ソースアカウントのメールアドレス
  #   - "$AccountEmailNoDomain" - ソースアカウントのメールアドレス（ドメインなし）
  # 注意: リンク作成後は変更できません（Forces new resource）
  label_template = "$AccountName"

  # resource_types (Required)
  # 設定内容: ソースアカウントがモニタリングアカウントと共有するデータのタイプを指定します。
  # 設定可能な値:
  #   - "AWS::CloudWatch::Metric" - CloudWatchメトリクス
  #   - "AWS::Logs::LogGroup" - CloudWatch Logsのロググループ
  #   - "AWS::XRay::Trace" - X-Rayトレース
  #   - "AWS::ApplicationInsights::Application" - Application Insightsアプリケーション
  #   - "AWS::InternetMonitor::Monitor" - Internet Monitorモニター
  # 注意: 複数のタイプを指定できます
  resource_types = [
    "AWS::CloudWatch::Metric",
    "AWS::Logs::LogGroup",
  ]

  # sink_identifier (Required)
  # 設定内容: このリンクの作成に使用するシンクの識別子を指定します。
  # 設定可能な値: シンクのARNまたは名前
  # 注意:
  #   - aws_oam_sink_policyがaws_oam_linkより先に作成されていないと失敗することがあります
  #   - depends_onメタ引数を使用して明示的な依存関係を宣言することを推奨します
  sink_identifier = aws_oam_sink.example.arn

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
    Name        = "example-oam-link"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # リンク設定 (link_configuration)
  #-------------------------------------------------------------

  # link_configuration (Optional)
  # 設定内容: ソースアカウントからモニタリングアカウントに共有する
  #          メトリクス名前空間またはロググループを指定するフィルターを作成するための設定です。
  # 注意:
  #   - log_group_configurationを使用する場合、resource_typesに "AWS::Logs::LogGroup" を含める必要があります
  #   - metric_configurationを使用する場合、resource_typesに "AWS::CloudWatch::Metric" を含める必要があります
  link_configuration {
    #-----------------------------------------------------------
    # ロググループ設定 (log_group_configuration)
    #-----------------------------------------------------------
    # ソースアカウントからモニタリングアカウントにログイベントを送信する
    # ロググループをフィルタリングするための設定です。

    # log_group_configuration (Optional)
    # 設定内容: 共有するロググループを指定するフィルター設定です。
    # 注意: 最大1つのブロックを指定できます
    log_group_configuration {
      # filter (Required)
      # 設定内容: モニタリングアカウントとログイベントを共有するロググループを
      #          指定するフィルター文字列です。
      # 設定可能な値:
      #   - LogGroupName を使用したフィルター式
      #   - LIKE 演算子でワイルドカードマッチング
      #   - OR/AND で複数条件の組み合わせ
      # 例:
      #   - "LogGroupName LIKE 'aws/lambda/%'" - Lambda関数のログ
      #   - "LogGroupName LIKE 'aws/lambda/%' OR LogGroupName LIKE 'AWSLogs%'"
      # 参考: https://docs.aws.amazon.com/OAM/latest/APIReference/API_LogGroupConfiguration.html
      filter = "LogGroupName LIKE 'aws/lambda/%' OR LogGroupName LIKE 'AWSLogs%'"
    }

    #-----------------------------------------------------------
    # メトリクス設定 (metric_configuration)
    #-----------------------------------------------------------
    # ソースアカウントからモニタリングアカウントに共有する
    # メトリクス名前空間をフィルタリングするための設定です。

    # metric_configuration (Optional)
    # 設定内容: 共有するメトリクス名前空間を指定するフィルター設定です。
    # 注意: 最大1つのブロックを指定できます
    metric_configuration {
      # filter (Required)
      # 設定内容: モニタリングアカウントと共有するメトリクスを指定するフィルター文字列です。
      # 設定可能な値:
      #   - Namespace を使用したフィルター式
      #   - IN 演算子で複数の名前空間を指定
      #   - LIKE 演算子でワイルドカードマッチング
      # 例:
      #   - "Namespace IN ('AWS/EC2', 'AWS/ELB', 'AWS/S3')"
      #   - "Namespace LIKE 'AWS/%'"
      # 参考: https://docs.aws.amazon.com/OAM/latest/APIReference/API_MetricConfiguration.html
      filter = "Namespace IN ('AWS/EC2', 'AWS/ELB', 'AWS/S3')"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "1m", "5m", "10m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "1m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "1m", "5m", "10m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "1m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "1m", "5m", "10m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = "1m"
  }

  #-------------------------------------------------------------
  # 依存関係
  #-------------------------------------------------------------
  # 注意: aws_oam_linkの作成は、接続先のaws_oam_sinkに対する
  #       aws_oam_sink_policyが作成されていないと失敗することがあります。
  #       depends_onメタ引数を使用して明示的な依存関係を宣言してください。
  depends_on = [
    aws_oam_sink_policy.example
  ]
}

#---------------------------------------------------------------
# 関連リソースの例
#---------------------------------------------------------------

# モニタリングアカウント側のシンク（参考）
# resource "aws_oam_sink" "example" {
#   name = "example-sink"
#   tags = {
#     Name = "example-sink"
#   }
# }

# シンクポリシー（参考）
# resource "aws_oam_sink_policy" "example" {
#   sink_identifier = aws_oam_sink.example.arn
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = { "AWS" = "arn:aws:iam::SOURCE_ACCOUNT_ID:root" }
#         Action    = ["oam:CreateLink", "oam:UpdateLink"]
#         Resource  = "*"
#         Condition = {
#           "ForAllValues:StringEquals" = {
#             "oam:ResourceTypes" = [
#               "AWS::CloudWatch::Metric",
#               "AWS::Logs::LogGroup"
#             ]
#           }
#         }
#       }
#     ]
#   })
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リンクのAmazon Resource Name (ARN)
#
# - id: リンクのARN（arnと同じ値。arnの使用を推奨）
#
# - label: このリンクに割り当てられたラベル
#
# - link_id: リンクARNの一部としてAWSが生成したID文字列
#
# - sink_arn: このリンクに使用されているシンクのARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
