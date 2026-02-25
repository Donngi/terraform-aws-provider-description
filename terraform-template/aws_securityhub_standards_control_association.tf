#---------------------------------------------------------------
# AWS Security Hub Standards Control Association
#---------------------------------------------------------------
#
# AWS Security Hubのセキュリティ基準（スタンダード）内の個別コントロールの
# 有効/無効状態を管理するリソースです。特定のセキュリティ基準において、
# 組織の要件に合わせてコントロールを選択的に無効化（または再有効化）することが
# できます。例えば、特定のコントロールが組織の環境に適用されない場合や、
# 代替の緩和策が存在する場合に使用します。
#
# AWS公式ドキュメント:
#   - Security Hub コントロールの管理: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-standards-enable-disable-controls.html
#   - 統合コントロール検出結果: https://docs.aws.amazon.com/securityhub/latest/userguide/controls-findings-create-update.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_control_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_standards_control_association" "example" {
  #-------------------------------------------------------------
  # コントロール識別設定
  #-------------------------------------------------------------

  # security_control_id (Required)
  # 設定内容: 有効/無効を設定するセキュリティコントロールのIDを指定します。
  # 設定可能な値: Security Hubのコントロール識別子（例: "S3.1", "EC2.2", "IAM.1"）
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-controls-reference.html
  security_control_id = "S3.1"

  # standards_arn (Required)
  # 設定内容: コントロールの関連付けを変更するセキュリティ基準のARNを指定します。
  # 設定可能な値: 有効化済みセキュリティ基準のARN。主な値は以下の通りです:
  #   - AWS Foundational Security Best Practices:
  #     arn:aws:securityhub:REGION::standards/aws-foundational-security-best-practices/v/1.0.0
  #   - CIS AWS Foundations Benchmark v1.2.0:
  #     arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0
  #   - CIS AWS Foundations Benchmark v1.4.0:
  #     arn:aws:securityhub:REGION::standards/cis-aws-foundations-benchmark/v/1.4.0
  #   - PCI DSS v3.2.1:
  #     arn:aws:securityhub:REGION::standards/pci-dss/v/3.2.1
  #   - NIST SP 800-53 Rev. 5:
  #     arn:aws:securityhub:REGION::standards/nist-800-53/v/5.0.0
  # 注意: 対象の基準があらかじめaws_securityhub_standards_subscriptionで
  #       サブスクライブされている必要があります。
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"

  #-------------------------------------------------------------
  # 関連付け状態設定
  #-------------------------------------------------------------

  # association_status (Required)
  # 設定内容: 指定した基準におけるコントロールの有効/無効状態を指定します。
  # 設定可能な値:
  #   - "ENABLED": コントロールを有効化し、セキュリティチェックを実行する
  #   - "DISABLED": コントロールを無効化し、セキュリティチェックを停止する
  # 注意: 無効化する場合はupdated_reasonで理由を明示することを推奨します。
  association_status = "ENABLED"

  #-------------------------------------------------------------
  # 変更理由設定
  #-------------------------------------------------------------

  # updated_reason (Optional)
  # 設定内容: コントロールの有効/無効状態を変更した理由を記載します。
  # 設定可能な値: 理由を説明する任意の文字列
  # 省略時: 理由なしで状態変更が適用される
  # 注意: association_statusをDISABLEDに設定する際は、
  #       監査証跡のため理由を明記することが推奨されます。
  updated_reason = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
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
# - id: リソースの一意識別子（standards_arnとsecurity_control_idの複合値）
#---------------------------------------------------------------
