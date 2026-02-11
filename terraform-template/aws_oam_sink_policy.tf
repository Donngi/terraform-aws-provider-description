#---------------------------------------------------------------
# AWS CloudWatch Observability Access Manager Sink Policy
#---------------------------------------------------------------
#
# CloudWatch Observability Access Manager (OAM) の Sink Policy を管理する
# Terraformリソース。
#
# OAM Sink Policy は、他のAWSアカウント（ソースアカウント）がモニタリング
# アカウントの Sink にリンクを作成することを許可するリソースベースのポリシー。
# このポリシーにより、クロスアカウントでのメトリクス、ログ、トレースの
# 共有が可能になる。
#
# AWS公式ドキュメント:
#   - CloudWatch cross-account observability:
#     https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Unified-Cross-Account.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/oam_sink_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_oam_sink_policy" "this" {
  #---------------------------------------------------------------
  # 必須パラメータ（Required）
  #---------------------------------------------------------------

  # sink_identifier - (必須) ポリシーをアタッチする Sink の ARN
  # このポリシーが適用される OAM Sink を指定する。
  # aws_oam_sink リソースの ARN を参照するのが一般的。
  # 型: string
  sink_identifier = aws_oam_sink.example.arn

  # policy - (必須) 使用するJSONポリシー
  # IAMポリシーと同様の形式でリソースベースのポリシーを定義する。
  # 既存のポリシーを更新する場合、ここで指定した内容で完全に置き換えられる。
  #
  # 主要なアクション:
  #   - oam:CreateLink: ソースアカウントからリンクの作成を許可
  #   - oam:UpdateLink: 既存リンクの更新を許可
  #
  # 主要なリソースタイプ（oam:ResourceTypes条件キー）:
  #   - AWS::CloudWatch::Metric: CloudWatchメトリクスの共有
  #   - AWS::Logs::LogGroup: CloudWatch Logsの共有
  #   - AWS::XRay::Trace: X-Rayトレースの共有
  #   - AWS::ApplicationInsights::Application: Application Insightsの共有
  #   - AWS::InternetMonitor::Monitor: Internet Monitorの共有
  #
  # 型: string (JSON形式)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["oam:CreateLink", "oam:UpdateLink"]
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          # 特定のAWSアカウントIDを指定
          "AWS" = ["111111111111", "222222222222"]
        }
        Condition = {
          # 共有を許可するリソースタイプを制限
          "ForAllValues:StringEquals" = {
            "oam:ResourceTypes" = [
              "AWS::CloudWatch::Metric",
              "AWS::Logs::LogGroup"
            ]
          }
        }
      }
    ]
  })

  #---------------------------------------------------------------
  # オプションパラメータ（Optional）
  #---------------------------------------------------------------

  # region - (オプション) このリソースを管理するリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # タイムアウト設定（Optional）
  #---------------------------------------------------------------

  # timeouts - (オプション) リソース操作のタイムアウト設定
  # 各操作（作成、更新、削除）のタイムアウト時間を個別に設定可能。
  # 指定する場合は "30m"（30分）や "1h"（1時間）のような形式で記述。
  # timeouts {
  #   # create - リソース作成時のタイムアウト
  #   # 型: string
  #   create = "30m"
  #
  #   # update - リソース更新時のタイムアウト
  #   # 型: string
  #   update = "30m"
  #
  #   # delete - リソース削除時のタイムアウト
  #   # 型: string
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性は Terraform によって自動的に設定され、参照のみ可能。
#
# arn       - Sink の ARN
#             例: arn:aws:oam:us-east-1:123456789012:sink/abcd1234-abcd-1234-abcd-1234abcd1234
#
# sink_id   - Sink ARN の一部として AWS が生成したID文字列
#             例: abcd1234-abcd-1234-abcd-1234abcd1234
#
# id        - リソースの識別子（sink_identifier と同じ）
#
#---------------------------------------------------------------
