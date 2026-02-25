#---------------------------------------------------------------
# AWS QuickSight IAM Policy Assignment
#---------------------------------------------------------------
#
# Amazon QuickSight の IAM ポリシーアサインメントをプロビジョニングするリソースです。
# QuickSight のユーザーまたはグループに IAM ポリシーを割り当て、
# アクセス権限を制御します。
#
# AWS公式ドキュメント:
#   - QuickSight IAM Policy Assignment: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateIAMPolicyAssignment.html
#   - QuickSight アクセス管理: https://docs.aws.amazon.com/quicksight/latest/user/security-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_iam_policy_assignment
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_iam_policy_assignment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # assignment_name (Required)
  # 設定内容: アサインメントの名前を指定します。
  # 設定可能な値: 文字列。AWSアカウントとQuickSightネームスペース内で一意である必要があります
  assignment_name = "example-assignment"

  # assignment_status (Required)
  # 設定内容: アサインメントのステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED": アサインメントを有効化し、ポリシーが適用されます
  #   - "DISABLED": アサインメントを無効化し、ポリシーが適用されません
  #   - "DRAFT": アサインメントを下書き状態に設定します
  assignment_status = "ENABLED"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_arn (Optional)
  # 設定内容: QuickSight のユーザーおよびグループに適用する IAM ポリシーの ARN を指定します。
  # 設定可能な値: 有効な IAM ポリシーの ARN
  # 省略時: ポリシーは割り当てられません
  policy_arn = "arn:aws:iam::123456789012:policy/example-quicksight-policy"

  #-------------------------------------------------------------
  # ID 設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: リソースを作成する AWS アカウント ID を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID
  # 省略時: Terraform AWS プロバイダーが自動的に判別したアカウント ID を使用します
  aws_account_id = "123456789012"

  # namespace (Optional)
  # 設定内容: アサインメントを含む QuickSight ネームスペースを指定します。
  # 設定可能な値: 有効な QuickSight ネームスペース名
  # 省略時: "default" ネームスペースが使用されます
  namespace = "default"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アイデンティティ設定
  #-------------------------------------------------------------

  # identities (Optional)
  # 設定内容: ポリシーを割り当てる QuickSight のユーザーまたはグループを指定するブロックです。
  # 関連機能: QuickSight IAM ポリシーアサインメント
  #   QuickSight のユーザーおよびグループに IAM ポリシーを関連付けることで
  #   きめ細かなアクセス制御が可能になります。
  #   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateIAMPolicyAssignment.html
  identities {

    # user (Optional)
    # 設定内容: ポリシーを割り当てる QuickSight ユーザー名のセットを指定します。
    # 設定可能な値: QuickSight ユーザー名の文字列セット
    # 省略時: ユーザーへの割り当ては行われません
    user = ["example-user"]

    # group (Optional)
    # 設定内容: ポリシーを割り当てる QuickSight グループ名のセットを指定します。
    # 設定可能な値: QuickSight グループ名の文字列セット
    # 省略時: グループへの割り当ては行われません
    group = ["example-group"]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - assignment_id: アサインメントの ID
# - id: AWSアカウントID、ネームスペース、アサインメント名をカンマで結合した文字列
#---------------------------------------------------------------
