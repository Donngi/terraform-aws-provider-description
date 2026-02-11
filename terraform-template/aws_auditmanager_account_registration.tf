#---------------------------------------------------------------
# AWS Audit Manager Account Registration
#---------------------------------------------------------------
#
# AWS Audit Managerのアカウント登録を管理するリソースです。
# Audit Managerを使用するには、まずアカウントを登録する必要があります。
# このリソースにより、Audit Managerの有効化と設定を行います。
#
# AWS公式ドキュメント:
#   - Audit Manager概要: https://docs.aws.amazon.com/audit-manager/latest/userguide/what-is.html
#   - Audit Managerのセットアップ: https://docs.aws.amazon.com/audit-manager/latest/userguide/setting-up.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_account_registration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_account_registration" "example" {
  #-------------------------------------------------------------
  # 委任管理者設定
  #-------------------------------------------------------------

  # delegated_admin_account (Optional)
  # 設定内容: 委任管理者アカウントの識別子を指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: 現在のアカウントがAudit Managerの管理アカウントとして登録されます。
  # 関連機能: AWS Organizations委任管理者
  #   AWS Organizations環境で、メンバーアカウントをAudit Managerの
  #   委任管理者として指定することができます。委任管理者は組織内の
  #   他のアカウントの監査データを管理できます。
  #   - https://docs.aws.amazon.com/audit-manager/latest/userguide/using-service-linked-roles.html
  delegated_admin_account = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key (Optional)
  # 設定内容: Audit Managerデータの暗号化に使用するKMSキーの識別子を指定します。
  # 設定可能な値: KMSキーID、KMSキーARN、またはエイリアスARN
  # 省略時: AWS管理のキーを使用してデータが暗号化されます。
  # 関連機能: Audit Manager データ暗号化
  #   Audit Managerは、収集した証拠やアセスメントレポートを暗号化します。
  #   カスタマー管理のKMSキーを使用することで、暗号化キーを自身で管理できます。
  #   - https://docs.aws.amazon.com/audit-manager/latest/userguide/data-protection.html
  kms_key = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: Audit Managerの登録はリージョン単位で行われます。
  region = null

  #-------------------------------------------------------------
  # 破棄時の動作設定
  #-------------------------------------------------------------

  # deregister_on_destroy (Optional)
  # 設定内容: Terraform destroy時にAudit Managerの登録を解除するかを指定します。
  # 設定可能な値:
  #   - true: destroy時にアカウントからAudit Managerの登録を解除
  #   - false (デフォルト): destroy時にAudit Managerはアクティブなまま
  #     （このリソースがTerraform stateから削除されても登録は維持）
  # 用途: 既存のアセスメントや証拠データを保護したい場合はfalseを維持。
  #       完全なクリーンアップが必要な場合はtrueを設定。
  # 注意: 登録解除すると、そのリージョンのすべてのAudit Managerデータが
  #       アクセス不可能になる可能性があります。
  deregister_on_destroy = false
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アカウント登録の一意識別子。登録はリージョン単位で適用されるため、
#       アクティブなリージョン名になります（例: us-east-1）。
#       注意: この属性は非推奨です。
#
# - status: アカウント登録リクエストのステータス。
#           例: "ACTIVE", "INACTIVE", "PENDING_ACTIVATION"
#---------------------------------------------------------------
