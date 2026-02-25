#---------------------------------------------------------------
# AWS OAM Sink Policy
#---------------------------------------------------------------
#
# CloudWatch Observability Access Manager (OAM) シンクポリシーを
# プロビジョニングするリソースです。
# OAM シンクポリシーは、どのソースアカウントがシンクにリンクして
# オブザーバビリティデータを共有できるかを定義します。
# モニタリングアカウントにシンクポリシーをアタッチすることで、
# クロスアカウントのメトリクス・ログ・トレース共有を制御します。
#
# AWS公式ドキュメント:
#   - OAM の概要: https://docs.aws.amazon.com/OAM/latest/APIReference/Welcome.html
#   - シンクポリシーの管理: https://docs.aws.amazon.com/OAM/latest/APIReference/API_PutSinkPolicy.html
#   - クロスアカウントオブザーバビリティの設定: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Unified-Cross-Account.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/oam_sink_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_oam_sink_policy" "example" {
  #---------------------------------------------------------------
  # シンク識別子設定
  #---------------------------------------------------------------

  # sink_identifier (Required)
  # 設定内容: ポリシーをアタッチするOAMシンクのARNまたはIDを指定します。
  # 設定可能な値: シンクのARN文字列またはシンクID文字列
  #   例: "arn:aws:oam:us-east-1:123456789012:sink/abcdefgh-1234-5678-abcd-ef0123456789"
  # 注意: 対象のシンクは aws_oam_sink リソースで事前に作成しておく必要があります。
  sink_identifier = aws_oam_sink.example.arn

  #---------------------------------------------------------------
  # ポリシードキュメント設定
  #---------------------------------------------------------------

  # policy (Required)
  # 設定内容: シンクに対するリソースベースポリシーをJSON形式の文字列で指定します。
  #   ポリシーはどのソースアカウント・組織がシンクにリンクできるかを定義します。
  # 設定可能な値: 有効なOAMシンクポリシードキュメントのJSON文字列
  # 注意: jsonencode() 関数の使用を推奨します。
  #   Principal にはソースアカウントIDまたは AWS Organizations の組織ARNを指定します。
  #   Action には "oam:CreateLink" または "oam:UpdateLink" を指定します。
  # 参考: https://docs.aws.amazon.com/OAM/latest/APIReference/API_PutSinkPolicy.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::111122223333:root"
        }
        Action   = ["oam:CreateLink", "oam:UpdateLink"]
        Resource = "*"
        Condition = {
          ForAllValues:StringEquals = {
            "oam:ResourceTypes" = [
              "AWS::CloudWatch::Metric",
              "AWS::Logs::LogGroup",
              "AWS::XRay::Trace",
            ]
          }
        }
      },
    ]
  })

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード文字列（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "2h" などの期間文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "2h" などの期間文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "2h" などの期間文字列
    # 省略時: プロバイダーのデフォルトタイムアウト
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: シンクのARN（sink_identifier と同じ値）
#
# - arn: シンクのARN
#
# - sink_id: シンクの一意識別子（UUID形式）
#---------------------------------------------------------------
