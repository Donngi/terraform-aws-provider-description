#-------
# AWS EC2 Transit Gateway Default Route Table Association
#-------
# 用途: Transit Gatewayのデフォルトルートテーブル関連付けを管理
# 説明: Transit Gatewayに新しいデフォルトルートテーブルを設定し、アタッチメントの自動関連付け先を変更します
# ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_transit_gateway_default_route_table_association
# 料金: https://aws.amazon.com/transit-gateway/pricing/
# Generated: 2025-02-15
# Provider Version: 6.28.0
# NOTE: 検証日 2025-02-15
#-------

#-------
# Transit Gateway デフォルトルートテーブル関連付け設定
#-------
resource "aws_ec2_transit_gateway_default_route_table_association" "example" {
  #-------
  # 必須パラメータ
  #-------
  # 設定内容: Transit Gateway ID
  # 説明: デフォルトルートテーブルを設定するTransit GatewayのID
  transit_gateway_id = "tgw-1234567890abcdef0"

  # 設定内容: デフォルトルートテーブル ID
  # 説明: 新しいデフォルトルートテーブルとして設定するルートテーブルのID
  # 補足: 以降、新しいアタッチメントはこのルートテーブルに自動的に関連付けられます
  transit_gateway_route_table_id = "tgw-rtb-1234567890abcdef0"

  #-------
  # リージョン設定
  #-------
  # 設定内容: リソースを管理するリージョン
  # 説明: このリソースが管理されるAWSリージョンを指定します
  # 省略時: プロバイダー設定のリージョンが使用されます
  region = "us-east-1"

  #-------
  # タイムアウト設定
  #-------
  # timeouts {
  #   # 設定内容: 作成タイムアウト時間
  #   # 設定可能な値: "30s", "5m", "1h" など
  #   # 省略時: デフォルト値が使用されます
  #   create = "10m"
  #
  #   # 設定内容: 更新タイムアウト時間
  #   # 設定可能な値: "30s", "5m", "1h" など
  #   # 省略時: デフォルト値が使用されます
  #   update = "10m"
  #
  #   # 設定内容: 削除タイムアウト時間
  #   # 設定可能な値: "30s", "5m", "1h" など
  #   # 省略時: デフォルト値が使用されます
  #   delete = "10m"
  # }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースでは以下の属性を参照できます:
#
# id                                  - リソースID（Transit Gateway IDと同じ値）
# original_default_route_table_id     - 変更前のデフォルトルートテーブルID
# region                              - リソースが管理されているリージョン
# transit_gateway_id                  - Transit Gateway ID
# transit_gateway_route_table_id      - デフォルトルートテーブルID
#-------
