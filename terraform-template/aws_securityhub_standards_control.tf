#---------------------------------------------------------------
# AWS Security Hub Standards Control
#---------------------------------------------------------------
#
# AWS Security Hubのセキュリティ標準コントロールを有効化または無効化するリソースです。
# このリソースはTerraformが新規作成するのではなく、既存のコントロールを管理下に
# 取り込む（adopt）動作をします。設定を削除するとTerraformはリソースをstateから
# 削除するのみで、実際のコントロール設定はそのまま残ります。
#
# AWS公式ドキュメント:
#   - セキュリティコントロールの理解: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-view-manage.html
#   - 特定の標準でコントロールを無効化: https://docs.aws.amazon.com/securityhub/latest/userguide/disable-controls-standard.html
#   - 特定の標準でコントロールを有効化: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-configure.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_control
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_standards_control" "example" {
  #-------------------------------------------------------------
  # コントロール識別設定
  #-------------------------------------------------------------

  # standards_control_arn (Required)
  # 設定内容: 管理対象のセキュリティ標準コントロールのARNを指定します。
  # 設定可能な値: 有効なSecurity HubコントロールARN
  #   ARNの形式: arn:aws:securityhub:<region>:<account-id>:control/<standards>/<version>/<control-id>
  # 参考: 既存コントロールのARN一覧はAWS CLIで取得可能
  #   get-enabled-standards: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/securityhub/get-enabled-standards.html
  #   describe-standards-controls: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/securityhub/describe-standards-controls.html
  standards_control_arn = "arn:aws:securityhub:us-east-1:123456789012:control/cis-aws-foundations-benchmark/v/1.2.0/1.10"

  #-------------------------------------------------------------
  # コントロールステータス設定
  #-------------------------------------------------------------

  # control_status (Required)
  # 設定内容: セキュリティ標準コントロールの有効/無効状態を指定します。
  # 設定可能な値:
  #   - "ENABLED": コントロールを有効化。セキュリティチェックが実行されます
  #   - "DISABLED": コントロールを無効化。disabled_reasonの指定が必要です
  # 注意: "DISABLED"を指定する場合はdisabled_reason引数の指定が必須です
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-configure.html
  control_status = "ENABLED"

  # disabled_reason (Optional)
  # 設定内容: コントロールを無効化する理由の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: control_statusが"ENABLED"の場合は不要
  # 注意: この属性を指定すると、control_statusは自動的に"DISABLED"に設定されます
  #       control_statusが"DISABLED"の場合は必ず指定してください
  disabled_reason = null

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
# - id: セキュリティ標準コントロールのARN（standards_control_arnと同一）
# - control_id: セキュリティ標準コントロールの識別子
# - control_status_updated_at: コントロールステータスが最後に更新された日時
# - description: コントロールの詳細説明。コントロールが何を確認するかの情報を含む
# - related_requirements: このコントロールに関連する要件のリスト
# - remediation_url: Security Hubユーザードキュメント内のコントロール修復情報へのリンク
# - severity_rating: このセキュリティ標準コントロールから生成されるファインディングの重大度
# - title: セキュリティ標準コントロールのタイトル
#---------------------------------------------------------------
