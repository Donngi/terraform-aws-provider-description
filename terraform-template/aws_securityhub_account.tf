#---------------------------------------------------------------
# AWS Security Hub Account
#---------------------------------------------------------------
#
# AWSアカウントでSecurity Hubを有効化するリソースです。
# Security Hubは、セキュリティアラートを集約・整理し、
# AWSアカウントのセキュリティ状態を一元管理するサービスです。
# このリソースを削除するとアカウントのSecurity Hubが無効化されます。
#
# AWS公式ドキュメント:
#   - Security Hub概要: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-settingup.html
#   - Security Hub有効化: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-settingup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_account
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_account" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # デフォルト標準設定
  #-------------------------------------------------------------

  # enable_default_standards (Optional)
  # 設定内容: Security Hubが自動的に有効化するよう指定したセキュリティ標準を
  #           有効にするかどうかを指定します。
  #           対象標準: AWS Foundational Security Best Practices v1.0.0 および
  #           CIS AWS Foundations Benchmark v1.2.0
  # 設定可能な値:
  #   - true (デフォルト): デフォルトのセキュリティ標準を有効化
  #   - false: デフォルトのセキュリティ標準を有効化しない
  # 省略時: true（デフォルト標準を有効化）
  enable_default_standards = true

  #-------------------------------------------------------------
  # コントロール設定
  #-------------------------------------------------------------

  # auto_enable_controls (Optional)
  # 設定内容: 有効化されている標準に新しいコントロールが追加されたときに
  #           自動的に有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 新しいコントロールを自動的に有効化
  #   - false: 新しいコントロールを自動的に有効化しない
  # 省略時: true（自動有効化を行う）
  auto_enable_controls = true

  # control_finding_generator (Optional)
  # 設定内容: コントロールの検出結果生成方式（統合コントロール検出結果）を指定します。
  #           複数の有効化された標準にまたがるコントロールチェックの結果として、
  #           1つの検出結果を生成するか、標準ごとに個別の検出結果を生成するかを制御します。
  # 設定可能な値:
  #   - "SECURITY_CONTROL": 複数の標準に適用されるコントロールチェックに対して
  #                          1つの検出結果を生成（統合コントロール検出結果）
  #   - "STANDARD_CONTROL": 適用される各標準に対して個別の検出結果を生成
  # 省略時: アカウントの現在の設定を維持
  # 注意: 組織に属するアカウントの場合、この値は管理者アカウントからのみ更新可能です。
  control_finding_generator = "SECURITY_CONTROL"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アカウントに作成されたSecurity Hub Hubリソースの ARN
#
# - id: AWSアカウントID
#---------------------------------------------------------------
