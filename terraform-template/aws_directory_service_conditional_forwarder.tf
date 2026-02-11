#---------------------------------------------------------------
# AWS Directory Service Conditional Forwarder
#---------------------------------------------------------------
#
# AWS Directory ServiceのManaged Microsoft AD用条件付きフォワーダーを
# プロビジョニングするリソースです。
#
# 条件付きフォワーダーは、特定のDNSドメイン名に対するDNSクエリを
# 指定されたDNSサーバーに転送するために使用されます。これにより、
# AWS Managed Microsoft ADと既存のオンプレミスDNSインフラストラクチャ間の
# 名前解決が可能になります。
#
# AWS公式ドキュメント:
#   - Directory Service概要: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html
#   - 条件付きフォワーダー: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_tutorial_setup_trust_prepare_mad.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_conditional_forwarder
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_directory_service_conditional_forwarder" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # directory_id (Required)
  # 設定内容: 条件付きフォワーダーを作成するディレクトリのIDを指定します。
  # 設定可能な値: 有効なAWS Directory Service ディレクトリID（例: d-1234567890）
  # 注意: Managed Microsoft AD または AD Connector のディレクトリIDを指定します。
  #       Simple AD では条件付きフォワーダーはサポートされていません。
  directory_id = aws_directory_service_directory.ad.id

  # remote_domain_name (Required)
  # 設定内容: フォワーダーを使用するリモートドメインの完全修飾ドメイン名（FQDN）を指定します。
  # 設定可能な値: 有効なFQDN（例: example.com, corp.example.com）
  # 注意: このドメインに対するDNSクエリが、指定されたDNSサーバーに転送されます。
  #       リソース作成後の変更は新しいリソースの作成を強制します（Forces new resource）。
  remote_domain_name = "example.com"

  # dns_ips (Required)
  # 設定内容: フォワーダーIPアドレスのリストを指定します。
  # 設定可能な値: 有効なIPv4アドレスのリスト
  # 注意: remote_domain_nameに対するDNSクエリがこれらのIPアドレスに転送されます。
  #       通常、オンプレミスのDNSサーバーまたはリモートドメインを解決可能な
  #       DNSサーバーのIPアドレスを指定します。
  #       高可用性のため、複数のDNSサーバーを指定することを推奨します。
  dns_ips = [
    "8.8.8.8",
    "8.8.4.4",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディレクトリIDとリモートドメイン名から構成される識別子
#       フォーマット: directory_id:remote_domain_name
#
#---------------------------------------------------------------
