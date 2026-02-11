#---------------------------------------------------------------
# AWS X-Ray Resource Policy
#---------------------------------------------------------------
#
# AWS X-Rayのリソースベースポリシーをプロビジョニングするリソースです。
# リソースポリシーは、1つ以上のAWSサービスやアカウントに対して
# X-Rayへのアクセス権限を付与します。各AWSアカウントには最大5つの
# リソースポリシーを設定でき、各ポリシー名はアカウント内で一意である
# 必要があります。
#
# AWS公式ドキュメント:
#   - X-Rayリソースベースポリシー: https://docs.aws.amazon.com/xray/latest/devguide/security_iam_service-with-iam.html
#   - PutResourcePolicy API: https://docs.aws.amazon.com/xray/latest/api/API_PutResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/xray_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_xray_resource_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # policy_name (Required)
  # 設定内容: リソースポリシーの名前を指定します。
  # 設定可能な値: 1-128文字の文字列（パターン: [\w+=,.@-]+）
  # 注意: AWSアカウント内で一意である必要があります
  # 参考: https://docs.aws.amazon.com/xray/latest/api/API_PutResourcePolicy.html
  policy_name = "example-xray-resource-policy"

  # policy_document (Required)
  # 設定内容: リソースポリシーのJSON形式のポリシードキュメントを指定します。
  # 設定可能な値: 最大5KBのJSON文字列
  # 関連機能: X-Rayリソースベースポリシー
  #   AWSサービス（Amazon SNS等）がX-Rayにトレースデータを送信するための
  #   権限を付与するために使用します。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/security_iam_service-with-iam.html
  # 注意: jsonencode関数の使用を推奨します
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SNSAccess"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = [
          "xray:PutTraceSegments",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "123456789012"
          }
          StringLike = {
            "aws:SourceArn" = "arn:aws:sns:ap-northeast-1:123456789012:my-topic"
          }
        }
      }
    ]
  })

  #-------------------------------------------------------------
  # ポリシーリビジョン設定
  #-------------------------------------------------------------

  # policy_revision_id (Optional)
  # 設定内容: 特定のポリシーリビジョンを指定し、アトミックな作成操作を保証します。
  # 設定可能な値: リビジョンIDの文字列
  # 省略時: リソースポリシーが存在しない場合は新規作成され、
  #         存在する場合はインクリメントされたリビジョンIDで更新されます。
  # 注意: 指定したリビジョンIDが最新のリビジョンIDと一致しない場合、
  #       InvalidPolicyRevisionIdException例外が発生します。
  #       値に0を指定した場合、同名のポリシーが既に存在すると
  #       InvalidPolicyRevisionIdException例外が発生します。
  # 参考: https://docs.aws.amazon.com/xray/latest/api/API_PutResourcePolicy.html
  policy_revision_id = null

  #-------------------------------------------------------------
  # ロックアウト防止設定
  #-------------------------------------------------------------

  # bypass_policy_lockout_check (Optional)
  # 設定内容: リソースポリシーのロックアウト安全チェックをバイパスするかを指定します。
  # 設定可能な値:
  #   - true: ロックアウト安全チェックをバイパスします。
  #           リクエスト元のプリンシパルが以降のPutResourcePolicyリクエストを
  #           実行できなくなるリスクがあります。
  #   - false (デフォルト): ロックアウト安全チェックを実行します
  # 注意: trueに設定すると、ポリシーが管理不能になるリスクが増加します。
  #       リクエストにポリシーを含め、かつリクエスト元のプリンシパルが
  #       以降のPutResourcePolicyリクエストを実行できないようにする場合にのみ使用してください。
  # 参考: https://docs.aws.amazon.com/xray/latest/api/API_PutResourcePolicy.html
  bypass_policy_lockout_check = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - last_updated_time: ポリシーが最後に更新された時刻（Unix時間秒）
#
# - policy_revision_id: このポリシー名の現在のポリシーリビジョンID
#---------------------------------------------------------------
