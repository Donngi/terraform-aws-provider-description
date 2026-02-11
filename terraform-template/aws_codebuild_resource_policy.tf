#---------------------------------------------------------------
# AWS CodeBuild Resource Policy
#---------------------------------------------------------------
#
# AWS CodeBuildプロジェクトまたはレポートグループに対するリソースベースの
# ポリシーをプロビジョニングするリソースです。
# このポリシーを使用して、他のAWSアカウントやユーザーとCodeBuildリソースを
# 共有することができます。
#
# AWS公式ドキュメント:
#   - CodeBuildプロジェクトの共有: https://docs.aws.amazon.com/codebuild/latest/userguide/project-sharing.html
#   - レポートグループの共有: https://docs.aws.amazon.com/codebuild/latest/userguide/report-groups-sharing.html
#   - PutResourcePolicy API: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_PutResourcePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_resource_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codebuild_resource_policy" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: リソースポリシーを関連付けるProjectまたはReportGroupリソースのARNを指定します。
  # 設定可能な値: 有効なCodeBuildプロジェクトまたはレポートグループのARN
  # 関連機能: AWS CodeBuild リソース共有
  #   AWS Resource Access Manager (RAM) を使用して、CodeBuildリソースを
  #   他のAWSアカウントや組織ユニットと共有できます。
  #   - プロジェクト共有: https://docs.aws.amazon.com/codebuild/latest/userguide/project-sharing.html#project-sharing-share
  #   - レポートグループ共有: https://docs.aws.amazon.com/codebuild/latest/userguide/report-groups-sharing.html#report-groups-sharing-share
  resource_arn = "arn:aws:codebuild:ap-northeast-1:123456789012:report-group/example"

  # policy (Required)
  # 設定内容: JSON形式のリソースポリシーを指定します。
  # 設定可能な値: JSON形式のIAMポリシードキュメント
  # 注意: ポリシーには、Principal、Action、Effect、Resourceステートメントが含まれます。
  #       共有されたリソースに対して、コンシューマーは読み取り専用アクセスのみが許可されます。
  # 関連機能: AWS CodeBuild リソースポリシー
  #   プロジェクトの場合、コンシューマーはプロジェクトを表示できますが、
  #   編集や実行はできません。
  #   レポートグループの場合、コンシューマーはレポートグループ、レポート、
  #   テストケース結果を表示できますが、編集や新規レポート作成はできません。
  #   - プロジェクト共有権限: https://docs.aws.amazon.com/codebuild/latest/userguide/project-sharing.html
  #   - レポートグループ共有権限: https://docs.aws.amazon.com/codebuild/latest/userguide/report-groups-sharing-perms.html
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "default"
    Statement = [{
      Sid    = "AllowAccessToReportGroup"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::987654321098:root"
      }
      Action = [
        "codebuild:BatchGetReportGroups",
        "codebuild:BatchGetReports",
        "codebuild:ListReportsForReportGroup",
        "codebuild:DescribeTestCases",
      ]
      Resource = "arn:aws:codebuild:ap-northeast-1:123456789012:report-group/example"
    }]
  })

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 通常は指定不要。省略時はリソースのARNが自動的に設定されます。
  # 注意: このフィールドは主にTerraform内部で使用されるため、明示的に指定する必要はほぼありません。
  id = null

  # region (Optional, Computed)
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
# - id: リソースのARN
#
#---------------------------------------------------------------
