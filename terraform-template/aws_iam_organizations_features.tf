#---------------------------------------------------------------
# AWS IAM Organizations Features
#---------------------------------------------------------------
#
# AWS Organizations内のメンバーアカウントに対する、ルートアクセス管理機能を
# 一元的に有効化するリソースです。
# 組織全体でルート認証情報の管理とルートセッションによる特権タスクの実行を
# セキュアに制御できます。
#
# AWS公式ドキュメント:
#   - ルートアクセスの一元管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user-centralized-access.html
#   - AWS Organizations統合: https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_organizations_features
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_organizations_features" "example" {
  #-------------------------------------------------------------
  # 機能有効化設定
  #-------------------------------------------------------------

  # enabled_features (Required)
  # 設定内容: AWS Organizations内で有効化するルートアクセス管理機能を指定します。
  # 設定可能な値:
  #   - "RootCredentialsManagement": ルート認証情報の一元管理機能
  #       メンバーアカウントの長期的なルート認証情報（パスワード、アクセスキー、
  #       署名証明書）を削除・監視し、認証情報の復旧を防止できます。
  #       新規作成されるアカウントはデフォルトでルート認証情報を持たず、
  #       セキュアバイデフォルトのアカウントプロビジョニングと
  #       コンプライアンス維持を支援します。
  #   - "RootSessions": ルートセッション機能
  #       管理アカウントまたは委任された管理者アカウントから、
  #       メンバーアカウントに対して一時的かつタスク範囲を限定した
  #       ルートアクセスを提供します。長期的な認証情報なしで
  #       特権タスク（S3バケットのロック解除、SQSキューの管理等）を
  #       セキュアに実行できます。一時認証情報の有効期間は限定的で、
  #       AWS CLI、AWS SDK、またはIAMコンソールから使用可能です。
  # 関連機能: IAM Centralized Root Access Management
  #   セキュリティチームがAWS Organizations内のメンバーアカウントに対する
  #   ルートアクセスを一元管理できる機能です。ルート認証情報の数を削減し、
  #   大規模環境でのルートアクセスに関連するリスクを軽減します。
  #   MFAコンプライアンス要件の達成が容易になり、監査と統制も簡素化されます。
  #   - https://aws.amazon.com/blogs/aws/centrally-managing-root-access-for-customers-using-aws-organizations/
  #   - https://aws.amazon.com/blogs/security/secure-root-user-access-for-member-accounts-in-aws-organizations/
  # 注意:
  #   - この機能を使用するには、アカウントがAWS Organizationsで管理されており、
  #     AWS OrganizationsでIAMの信頼されたアクセス（Trusted Access）が
  #     有効化されている必要があります
  #   - 管理アカウントまたは委任された管理者アカウントからのみ実行可能です
  #   - すべてのAWSリージョンで利用可能です（AWS GovCloud (US)および
  #     AWS中国リージョンを含む）
  #   - この機能の使用に追加料金はかかりません
  #   - 機能を無効化すると、メンバーアカウントのルート認証情報管理は
  #     各アカウントに戻りますが、既に削除された認証情報は自動復旧されません
  # 参考: https://docs.aws.amazon.com/IAM/latest/APIReference/API_EnableOrganizationsRootCredentialsManagement.html
  #       https://docs.aws.amazon.com/IAM/latest/APIReference/API_EnableOrganizationsRootSessions.html
  enabled_features = [
    "RootCredentialsManagement",
    "RootSessions"
  ]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 組織のID（OrganizationId）
#       形式: "o-" で始まる最大34文字の一意の識別子
#
#---------------------------------------------------------------
