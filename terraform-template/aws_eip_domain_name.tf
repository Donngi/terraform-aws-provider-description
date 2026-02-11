#---------------------------------------------------------------
# AWS EIP Domain Name
#---------------------------------------------------------------
#
# Elastic IPアドレスに静的な逆引きDNSレコード（PTRレコード）を割り当てるリソースです。
# 主にEC2インスタンスからメールを送信する際に、スパムとしてフラグ付けされることを
# 避けるために使用されます。逆引きDNSレコードを設定することで、メール受信サーバーが
# IPアドレスからドメイン名への逆引き検証を行う際に、正当な送信元として認識されます。
#
# 重要な考慮事項:
#   - 逆引きDNSレコードを設定する前に、対応する正引きDNSレコード（Aレコード）を
#     設定しておく必要があります。
#   - 逆引きDNSレコードが関連付けられているElastic IPアドレスは、アカウントに
#     ロックされ、レコードを削除するまで解放できなくなります。
#   - AWS GovCloud (US) リージョンでは、逆引きDNSレコードを作成できません。
#
# AWS公式ドキュメント:
#   - Elastic IPの逆引きDNSの使用: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#Using_Elastic_Addressing_Reverse_DNS
#   - Elastic IPアドレス: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
#   - メールアプリケーション向け逆引きDNS: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Elastic_Addressing_Reverse_DNS.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_domain_name
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_eip_domain_name" "example" {
  #-------------------------------------------------------------
  # Elastic IP設定 (Required)
  #-------------------------------------------------------------

  # allocation_id (Required)
  # 設定内容: 逆引きDNSレコードを設定するElastic IPのアロケーションIDを指定します。
  # 設定可能な値: Elastic IPアドレスのアロケーションID（例: eipalloc-12345678）
  # 取得方法: aws_eipリソースのallocation_id属性から取得できます。
  # 用途: このElastic IPアドレスに対して逆引きDNSレコード（PTRレコード）を設定します。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
  allocation_id = aws_eip.example.allocation_id

  #-------------------------------------------------------------
  # ドメイン名設定 (Required)
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: IPアドレスに割り当てるドメイン名（FQDN）を指定します。
  # 設定可能な値: 完全修飾ドメイン名（FQDN）
  # 前提条件:
  #   - このドメイン名を指すRoute 53などのDNSレコード（Aレコード）が事前に
  #     設定されている必要があります。
  #   - 正引きDNS（ドメイン名→IPアドレス）が正しく解決できることを確認してください。
  # 用途: メール送信時のスパムフィルター対策として、IPアドレスからドメイン名への
  #       逆引き検証（PTRレコード確認）を通過するために使用します。
  # 推奨事項: メール送信サーバーとして使用する場合は、正引きと逆引きの整合性を
  #           必ず確認してください。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Elastic_Addressing_Reverse_DNS.html
  domain_name = aws_route53_record.example.fqdn

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 用途: マルチリージョン構成で特定のリージョンでリソースを管理する場合に使用します。
  # 注意事項: AWS GovCloud (US) リージョンでは逆引きDNSレコードを作成できません。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = null

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    update = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 注意事項: 削除操作はステートに変更が保存された後に発生する場合のみ適用されます。
    # 参考: https://pkg.go.dev/time#ParseDuration
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#       形式: Elastic IPのアロケーションID
#
# - ptr_record: IPアドレスに対するDNSポインター（PTR）レコード
#       内容: 設定された逆引きDNSレコードの値
#       用途: 逆引きDNS検証の確認に使用できます
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_eip" "mail_server" {
#   domain = "vpc"
#   tags = {
#     Name = "mail-server-eip"
#   }
# }
#
# resource "aws_route53_record" "mail_server" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "mail"
#---------------------------------------------------------------
