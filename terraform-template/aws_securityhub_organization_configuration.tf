#---------------------------------------------------------------
# AWS Security Hub Organization Configuration
#---------------------------------------------------------------
#
# AWS Security Hubの組織設定を管理するリソースです。
# 組織内の新しいアカウントに対してSecurity Hubを自動的に有効化したり、
# ローカル設定またはセントラル設定を使用して組織全体のSecurity Hub設定を
# 制御したりする際に使用します。
#
# 注意: このリソースを使用するには aws_securityhub_organization_admin_account が
# 設定されている必要があります。また、セントラル設定を使用する場合は
# aws_securityhub_finding_aggregator の設定も必要です。
#
# AWS公式ドキュメント:
#   - Security Hub 組織設定: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-accounts-orgs.html
#   - セントラル設定: https://docs.aws.amazon.com/securityhub/latest/userguide/central-configuration-intro.html
#   - 自動有効化: https://docs.aws.amazon.com/securityhub/latest/userguide/accounts-orgs-auto-enable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_organization_configuration" "example" {
  #-------------------------------------------------------------
  # 自動有効化設定
  #-------------------------------------------------------------

  # auto_enable (Required)
  # 設定内容: 組織に新しいアカウントが追加された際に、Security Hubを自動的に
  #           有効化するかどうかを指定します。
  # 設定可能な値:
  #   - true: 新しいメンバーアカウントに自動的にSecurity Hubを有効化
  #   - false: 自動有効化を無効にする
  # 注意: organization_configuration.configuration_type が "CENTRAL" の場合、
  #       このフィールドは false に設定する必要があります。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/accounts-orgs-auto-enable.html
  auto_enable = true

  # auto_enable_standards (Optional)
  # 設定内容: 組織に新しいメンバーアカウントが追加された際に、Security Hubの
  #           デフォルトセキュリティ標準を自動的に有効化するかどうかを指定します。
  # 設定可能な値:
  #   - "DEFAULT": デフォルトのSecurity Hub標準（AWS Foundational Security Best Practices、
  #                CIS AWS Foundations Benchmark v1.2.0）を新しいメンバーアカウントに
  #                自動的に有効化します（デフォルト値）
  #   - "NONE": 新しいメンバーアカウントでのデフォルト標準の自動有効化を無効にします
  # 省略時: "DEFAULT"（新しいメンバーアカウントにデフォルト標準が自動的に有効化される）
  # 注意: organization_configuration.configuration_type が "CENTRAL" の場合、
  #       このフィールドは "NONE" に設定する必要があります。
  auto_enable_standards = "DEFAULT"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 組織設定
  #-------------------------------------------------------------

  # organization_configuration (Optional)
  # 設定内容: Security Hubの組織設定方式を指定するブロックです。
  #           ローカル設定またはセントラル設定を選択できます。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/central-configuration-intro.html
  organization_configuration {

    # configuration_type (Required)
    # 設定内容: 組織がローカル設定またはセントラル設定のどちらを使用するかを指定します。
    # 設定可能な値:
    #   - "LOCAL": ローカル設定。Security Hub委任管理者は各AWSリージョンで
    #              個別にSecurity Hubとデフォルトセキュリティ標準を有効化できます。
    #              auto_enable を true、auto_enable_standards を "DEFAULT" に
    #              設定することで新しい組織アカウントへの自動有効化が可能です。
    #   - "CENTRAL": セントラル設定。委任管理者が複数のアカウントおよびリージョンに
    #                わたってSecurity Hub、セキュリティ標準、セキュリティコントロールを
    #                設定ポリシーで管理できます。この場合、delegated adminは管理アカウント
    #                ではなくメンバーアカウントである必要があります。
    # 注意: "CENTRAL" を使用する場合、auto_enable を false に、
    #       auto_enable_standards を "NONE" に設定する必要があります。
    #       また、aws_securityhub_finding_aggregator の設定が必要です。
    # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/start-central-configuration.html
    configuration_type = "LOCAL"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントID
#---------------------------------------------------------------
