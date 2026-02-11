#---------------------------------------------------------------
# AWS Network Firewall Transit Gateway Attachment Accepter
#---------------------------------------------------------------
#
# クロスアカウント環境でTransit Gateway経由のNetwork Firewallアタッチメントを
# 承認するためのリソース。
#
# クロスアカウント構成（リクエスターのAWSアカウントとアクセプターのAWSアカウントが
# 異なる構成）において、リクエスター側がTransit Gateway IDを指定して
# aws_networkfirewall_firewallを作成すると、アクセプター側のアカウントに
# EC2 Transit Gateway VPCアタッチメントリソースが自動的に作成される。
# アクセプター側はこのリソースを使用して接続の自分側を管理下に置く（adopt）ことができる。
#
# 注意: aws_networkfirewall_firewallリソースでtransit_gateway_id引数を使用して
# クロスアカウント構成でFirewallをTransit Gatewayにアタッチする場合
# （Auto accept shared attachmentsが無効の場合）、Transit Gatewayアタッチメントが
# Pending Acceptance状態でFirewallがProvisioning状態の時点でリソースは作成済みとなる。
# この時点で本リソースを使用してNetwork Firewallのデプロイを完了できる。
# Transit Gatewayアタッチメントが Available状態になると、Firewallの状態はReadyになる。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_transit_gateway_attachment_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkfirewall_firewall_transit_gateway_attachment_accepter" "this" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # transit_gateway_attachment_id (Required, string)
  # 承認するTransit Gatewayアタッチメントの一意識別子
  # このIDはTransit Gateway接続型のFirewallを作成する際のレスポンスで返される
  # 例: aws_networkfirewall_firewall.example.firewall_status[0].transit_gateway_attachment_sync_state[0].attachment_id
  transit_gateway_attachment_id = "tgw-attach-xxxxxxxxxxxxxxxxx"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # region (Optional, string)
  # このリソースが管理されるリージョン
  # 省略した場合はプロバイダー設定で指定されたリージョンがデフォルトで使用される
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  # リソースの作成・削除操作のタイムアウト値をカスタマイズ可能
  # 値は "30s"、"2h45m" のような形式で指定（s=秒、m=分、h=時間）

  # timeouts {
  #   # create (Optional, string)
  #   # リソース作成のタイムアウト値
  #   # デフォルト値はプロバイダーにより設定される
  #   create = "30m"
  #
  #   # delete (Optional, string)
  #   # リソース削除のタイムアウト値
  #   # 削除操作のタイムアウト設定は、destroy操作の前に状態が保存された場合にのみ適用される
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# このリソースはArgument以外に追加のAttributeをエクスポートしません。
# スキーマで定義された属性は全て入力可能な属性として上記に記載されています。
