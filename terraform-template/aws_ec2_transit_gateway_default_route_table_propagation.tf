###################################################################################
# Terraform AWS Resource Template
###################################################################################
# リソース: aws_ec2_transit_gateway_default_route_table_propagation
# 用途: Transit Gatewayのデフォルト伝播ルートテーブルを管理
# Terraform AWS Provider Version: 6.28.0
# Generated: 2026-02-15
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_transit_gateway_default_route_table_propagation
#
# このリソースは、Transit Gatewayに対して、アタッチメントが作成された際に
# ルートを自動的に伝播するデフォルトのルートテーブルを設定します。
# Transit Gatewayのデフォルト動作では、新しいアタッチメント（VPC、VPN、Direct Connect
# など）が作成されると、そのルートが指定されたルートテーブルに自動的に伝播されます。
#
# NOTE:
# - このリソースは既存のTransit Gatewayの設定を変更します
# - デフォルトの伝播ルートテーブルを変更すると、既存のアタッチメントの動作に影響します
# - Transit Gatewayごとに1つのデフォルト伝播ルートテーブルのみ設定可能です
# - 元のデフォルトルートテーブルIDは計算属性として参照できます
#
# 関連リソース:
# - aws_ec2_transit_gateway: Transit Gatewayの作成
# - aws_ec2_transit_gateway_route_table: ルートテーブルの作成
# - aws_ec2_transit_gateway_route_table_propagation: 個別の伝播設定
# - aws_ec2_transit_gateway_vpc_attachment: VPCアタッチメントの作成
#
###################################################################################

#-------
# Transit Gatewayデフォルト伝播ルートテーブル設定
#-------
resource "aws_ec2_transit_gateway_default_route_table_propagation" "example" {
  #-------
  # Transit Gateway設定
  #-------
  # 設定内容: デフォルト伝播ルートテーブルを変更するTransit GatewayのID
  # 必須項目: はい
  # 形式: tgw-xxxxxxxxxxxxxxxxx
  # 注意事項:
  # - 既存のTransit GatewayのIDを指定する必要があります
  # - Transit Gatewayは事前に作成されている必要があります
  # - IDの変更は新しいリソースの再作成を引き起こします
  transit_gateway_id = "tgw-0123456789abcdef0"

  #-------
  # デフォルト伝播ルートテーブル設定
  #-------
  # 設定内容: デフォルトの伝播ルートテーブルとして使用するルートテーブルのID
  # 必須項目: はい
  # 形式: tgw-rtb-xxxxxxxxxxxxxxxxx
  # 注意事項:
  # - 指定するルートテーブルは同じTransit Gatewayに関連付けられている必要があります
  # - このルートテーブルに新しいアタッチメントのルートが自動的に伝播されます
  # - IDの変更は新しいリソースの再作成を引き起こします
  transit_gateway_route_table_id = "tgw-rtb-0123456789abcdef0"

  #-------
  # リージョン設定（オプション）
  #-------
  # 設定内容: このリソースを管理するAWSリージョン
  # 必須項目: いいえ
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 形式: us-east-1, ap-northeast-1など
  # 注意事項:
  # - 通常はプロバイダー設定のリージョンを使用するため、明示的な指定は不要です
  # - マルチリージョン構成の場合にのみ使用します
  region = "ap-northeast-1"

  #-------
  # タイムアウト設定
  #-------
  # 設定内容: リソース操作のタイムアウト時間
  # 必須項目: いいえ
  # 注意事項:
  # - デフォルト値で通常は十分ですが、大規模環境では調整が必要な場合があります
  # - 時間の単位: s(秒), m(分), h(時間)
  # timeouts {
  #   # 作成時のタイムアウト
  #   # 省略時: 10m
  #   create = "10m"
  #
  #   # 更新時のタイムアウト
  #   # 省略時: 10m
  #   update = "10m"
  #
  #   # 削除時のタイムアウト
  #   # 省略時: 10m
  #   delete = "10m"
  # }
}

###################################################################################
# 出力値の例
###################################################################################

#-------
# リソースID
#-------
# 説明: リソースの一意識別子（transit_gateway_id,transit_gateway_route_table_id形式）
# 用途: 他のリソースからの参照、インポート操作
output "transit_gateway_default_route_table_propagation_id" {
  description = "Transit Gatewayデフォルト伝播ルートテーブルのID"
  value       = aws_ec2_transit_gateway_default_route_table_propagation.example.id
}

#-------
# 元のデフォルトルートテーブルID
#-------
# 説明: 変更前のデフォルト伝播ルートテーブルID
# 用途: ロールバック時の参照、監査ログ
output "original_default_route_table_id" {
  description = "変更前のデフォルト伝播ルートテーブルID"
  value       = aws_ec2_transit_gateway_default_route_table_propagation.example.original_default_route_table_id
}

###################################################################################
# Attributes Reference
###################################################################################
# このリソースでは以下の属性が参照可能です:
#
# - id
#   リソースの一意識別子
#   形式: {transit_gateway_id},{transit_gateway_route_table_id}
#
# - original_default_route_table_id
#   変更前のデフォルト伝播ルートテーブルID
#   用途: 設定変更前の状態を追跡
#   注意: 初回作成時はTransit Gateway作成時に自動生成されたルートテーブルIDが格納されます
#
# - region
#   リソースが管理されているAWSリージョン
#   省略時はプロバイダー設定のリージョンが自動設定されます
#
# - transit_gateway_id
#   設定したTransit GatewayのID
#
# - transit_gateway_route_table_id
#   デフォルト伝播ルートテーブルとして設定したルートテーブルID
#
###################################################################################
