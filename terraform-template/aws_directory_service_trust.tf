#----------------------------------------------------------------
# AWS Directory Service Trust - Terraform Template
#----------------------------------------------------------------
# Generated: 2026-01-22
# Provider Version: hashicorp/aws 6.28.0
#
# Note: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/directory_service_trust
#----------------------------------------------------------------

resource "aws_directory_service_trust" "example" {
  #----------------------------------------------------------------
  # Required Arguments
  #----------------------------------------------------------------

  # (Required) ID of the AWS Managed Microsoft AD Directory
  # AWS Directory Service のディレクトリ ID を指定します。
  # この値は、Trust を作成する AWS 側のディレクトリを識別します。
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_setup_trust.html
  directory_id = "d-1234567890"

  # (Required) Fully qualified domain name of the remote Directory
  # Trust 先のディレクトリの完全修飾ドメイン名（FQDN）を指定します。
  # 例: "corp.example.com" のような形式で指定します。
  # AWS Managed Microsoft AD と外部ドメイン間の Trust を作成する際に必要です。
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/devguide/API_CreateTrust.html
  remote_domain_name = "corp.example.com"

  # (Required) The direction of the Trust relationship
  # Trust の方向を指定します。
  # 有効な値:
  #   - "One-Way: Outgoing": AWS ディレクトリから外部ドメインへの一方向 Trust
  #   - "One-Way: Incoming": 外部ドメインから AWS ディレクトリへの一方向 Trust
  #   - "Two-Way": 双方向 Trust（相互に認証が可能）
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_setup_trust.html
  trust_direction = "Two-Way"

  # (Required) Password for the Trust relationship
  # Trust 関係のパスワードを指定します。
  # このパスワードは、いずれかのディレクトリのパスワードと一致する必要はありません。
  # 要件:
  #   - 大文字・小文字・数字・句読点文字を含めることができます
  #   - 最大 128 文字まで設定可能
  # セキュリティのため、sensitive = true を設定することを推奨します。
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/devguide/API_CreateTrust.html
  trust_password = "YourSecureTrustPassword123"

  #----------------------------------------------------------------
  # Optional Arguments
  #----------------------------------------------------------------

  # (Optional) Set of IPv4 addresses for the DNS server associated with the remote Directory
  # リモートディレクトリに関連付けられた DNS サーバーの IPv4 アドレスのセットを指定します。
  # 1 ～ 4 個の値を含めることができます。
  # Conditional Forwarder として機能し、リモートドメインの名前解決を可能にします。
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_setup_trust.html
  conditional_forwarder_ip_addrs = [
    "10.0.1.10",
    "10.0.2.10",
  ]

  # (Optional) Whether to delete the conditional forwarder when deleting the Trust relationship
  # Trust 関係を削除する際に、条件付きフォワーダーも削除するかどうかを指定します。
  # true の場合、Trust 削除時に関連する条件付きフォワーダーも自動的に削除されます。
  # false の場合、条件付きフォワーダーは保持されます。
  # デフォルト値は false です。
  delete_associated_conditional_forwarder = true

  # (Optional) Region where this resource will be managed
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) Whether to enable selective authentication
  # 選択的認証を有効にするかどうかを指定します。
  # 有効な値:
  #   - "Enabled": 選択的認証を有効化（特定のリソースへのアクセスを制御）
  #   - "Disabled": 選択的認証を無効化（デフォルト値）
  # 選択的認証により、Trust されたドメインのユーザーが AWS リソースに
  # アクセスする際の制御を細かく設定できます。
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/devguide/API_Trust.html
  selective_auth = "Disabled"

  # (Optional) Type of the Trust relationship
  # Trust 関係のタイプを指定します。
  # 有効な値:
  #   - "Forest": フォレスト Trust（デフォルト値）
  #                複数のドメインツリーを含むフォレスト間の Trust
  #   - "External": 外部 Trust
  #                 単一のドメイン間の Trust
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/devguide/API_CreateTrust.html
  trust_type = "Forest"

  #----------------------------------------------------------------
  # Computed Attributes (Read-Only)
  #----------------------------------------------------------------
  # 以下の属性は Terraform によって自動的に計算され、参照のみ可能です:
  #
  # - id: Trust 識別子
  # - created_date_time: Trust が作成された日時
  # - last_updated_date_time: Trust が最後に更新された日時
  # - state_last_updated_date_time: trust_state が最後に更新された日時
  # - trust_state: Trust 関係の状態
  #     - Created, VerifyFailed, Verified, UpdateFailed, Updated, Deleted, Failed のいずれか
  #     - Trust が片側のみで作成された場合は "VerifyFailed" 状態になります
  #     - 両側で Trust を作成すると、正しい状態に更新されます
  # - trust_state_reason: trust_state の理由を説明する文字列
  #
  # 参考: https://docs.aws.amazon.com/directoryservice/latest/devguide/API_Trust.html
  #----------------------------------------------------------------
}

#----------------------------------------------------------------
# Usage Example: Two-Way Trust
#----------------------------------------------------------------
# resource "aws_directory_service_trust" "one" {
#   directory_id = aws_directory_service_directory.one.id
#
#   remote_domain_name = aws_directory_service_directory.two.name
#   trust_direction    = "Two-Way"
#   trust_password     = "SecurePassword123\!"
#
#   conditional_forwarder_ip_addrs = aws_directory_service_directory.two.dns_ip_addresses
# }
#
# resource "aws_directory_service_trust" "two" {
#   directory_id = aws_directory_service_directory.two.id
#
#   remote_domain_name = aws_directory_service_directory.one.name
#   trust_direction    = "Two-Way"
#   trust_password     = "SecurePassword123\!"
#
#   conditional_forwarder_ip_addrs = aws_directory_service_directory.one.dns_ip_addresses
# }

#----------------------------------------------------------------
# Usage Example: One-Way Trust
#----------------------------------------------------------------
# resource "aws_directory_service_trust" "incoming" {
#   directory_id = aws_directory_service_directory.one.id
#
#   remote_domain_name = aws_directory_service_directory.two.name
#   trust_direction    = "One-Way: Incoming"
#   trust_password     = "SecurePassword123\!"
#
#   conditional_forwarder_ip_addrs = aws_directory_service_directory.two.dns_ip_addresses
# }
#
# resource "aws_directory_service_trust" "outgoing" {
#   directory_id = aws_directory_service_directory.two.id
#
#   remote_domain_name = aws_directory_service_directory.one.name
#   trust_direction    = "One-Way: Outgoing"
#   trust_password     = "SecurePassword123\!"
#
#   conditional_forwarder_ip_addrs = aws_directory_service_directory.one.dns_ip_addresses
# }

#----------------------------------------------------------------
# Additional References
#----------------------------------------------------------------
# - AWS Directory Service Trust Setup Guide:
#   https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_setup_trust.html
#
# - CreateTrust API Reference:
#   https://docs.aws.amazon.com/directoryservice/latest/devguide/API_CreateTrust.html
#
# - Trust Data Type Reference:
#   https://docs.aws.amazon.com/directoryservice/latest/devguide/API_Trust.html
#
# - AWS Managed Microsoft AD Best Practices:
#   https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_best_practices.html
#----------------------------------------------------------------
