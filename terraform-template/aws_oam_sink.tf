#---------------------------------------------------------------
# AWS CloudWatch Observability Access Manager Sink
#---------------------------------------------------------------
#
# CloudWatch Observability Access Manager (OAM) のSinkを作成する。
# Sinkはモニタリングアカウントにおけるアタッチメントポイントとして機能し、
# ソースアカウントがオブザーバビリティデータ（メトリクス、ログ、トレース等）を
# 送信するための接続先となる。
#
# 各AWSアカウントは、リージョンごとに1つのSinkのみ作成可能。
# Sink作成後、ソースアカウントがアタッチできるようにするには
# aws_oam_sink_policyリソースでポリシーを設定する必要がある。
#
# AWS公式ドキュメント:
#   - CloudWatch OAM概要: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Unified-Cross-Account.html
#   - CreateSink API: https://docs.aws.amazon.com/OAM/latest/APIReference/API_CreateSink.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/oam_sink
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_oam_sink" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # name (Required, string)
  # Sinkの名前。
  # 命名規則: 英数字、アンダースコア(_)、ピリオド(.)、ハイフン(-)が使用可能。
  # 長さは1〜255文字。
  # 同一リージョン内でSinkを削除した場合、同じ名前で新しいSinkを作成可能。
  name = "example-monitoring-sink"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # region (Optional, string)
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  # tags (Optional, map of string)
  # Sinkに割り当てるタグのマップ。
  # キーと値のペアでリソースを分類・整理できる。
  # IAMポリシーでタグに基づくアクセス制御も可能。
  # 最大50個のタグを設定可能。
  # キー: 最大128文字、値: 最大256文字。
  # provider設定のdefault_tagsブロックで定義されたタグは、
  # 同じキーを持つ場合このtagsの値で上書きされる。
  tags = {
    Environment = "production"
    Purpose     = "centralized-monitoring"
  }

  # tags_all (Optional, map of string)
  # provider設定のdefault_tagsで定義されたタグを含む、
  # リソースに割り当てられた全タグのマップ。
  # 通常は直接設定せず、tagsとdefault_tagsから自動計算される。
  # 明示的に設定する場合は、default_tagsとの整合性に注意。
  # tags_all = {}

  #---------------------------------------------------------------
  # timeoutsブロック (Optional)
  #---------------------------------------------------------------
  # リソースの作成・更新・削除操作のタイムアウト値を設定する。
  # デフォルト値で問題がある場合にのみ設定を推奨。

  timeouts {
    # create (Optional, string)
    # リソース作成のタイムアウト時間。
    # 形式: "60m"（60分）、"1h"（1時間）など。
    # create = "1m"

    # update (Optional, string)
    # リソース更新のタイムアウト時間。
    # 形式: "60m"（60分）、"1h"（1時間）など。
    # update = "1m"

    # delete (Optional, string)
    # リソース削除のタイムアウト時間。
    # 形式: "60m"（60分）、"1h"（1時間）など。
    # delete = "1m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートする:
#
# arn (string)
#   SinkのARN。
#   形式: arn:aws:oam:region:account-id:sink/sink-id
#   例: arn:aws:oam:ap-northeast-1:123456789012:sink/abc123def456
#
# sink_id (string)
#   AWSがSink ARNの一部として生成したID文字列。
#   ARNの末尾部分に含まれる一意識別子。
#
# id (string)
#   SinkのARN。arnと同じ値。
#   非推奨: 代わりにarn属性を使用することを推奨。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Sinkとポリシーの組み合わせ
#---------------------------------------------------------------
#
# Sinkを作成した後、ソースアカウントがアタッチできるように
# aws_oam_sink_policyでポリシーを設定する必要がある。
#
# resource "aws_oam_sink_policy" "example" {
#   sink_identifier = aws_oam_sink.example.arn
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = { AWS = ["arn:aws:iam::111111111111:root"] }
#         Action    = ["oam:CreateLink", "oam:UpdateLink"]
#         Resource  = "*"
#         Condition = {
#           "ForAllValues:StringEquals" = {
#             "oam:ResourceTypes" = [
#               "AWS::CloudWatch::Metric",
#               "AWS::Logs::LogGroup",
#               "AWS::XRay::Trace"
#             ]
#           }
#         }
#       }
#     ]
#   })
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
#
# 既存のSinkをTerraform管理下にインポートする場合:
#
# terraform import aws_oam_sink.example arn:aws:oam:ap-northeast-1:123456789012:sink/abc123def456
#
#---------------------------------------------------------------
