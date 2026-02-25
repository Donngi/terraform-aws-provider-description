#---------------------------------------------------------------
# AWS Network Manager Direct Connect Gateway Attachment
#---------------------------------------------------------------
#
# AWS Cloud WANのコアネットワークにDirect Connect Gatewayアタッチメントを
# 作成・管理します。Direct Connect GatewayアタッチメントはAWS Direct Connect
# Gatewayをコアネットワークに接続し、オンプレミス環境とCloud WAN間の
# 専用線接続を実現します。
#
# AWS公式ドキュメント:
#   - AWS Cloud WAN: https://docs.aws.amazon.com/vpc/latest/cloudwan/what-is-cloudwan.html
#   - DX Gateway Attachment: https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-attachments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_dx_gateway_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_dx_gateway_attachment" "example" {
  #-------------------------------------------------------------
  # コアネットワーク設定
  #-------------------------------------------------------------

  # core_network_id (Required)
  # 設定内容: Direct Connect GatewayアタッチメントをアタッチするCloud WANコアネットワークのIDを指定します。
  # 設定可能な値: 有効なコアネットワークID（例: "core-network-0123456789abcdef0"）
  # 省略時: 省略不可
  core_network_id = "core-network-0123456789abcdef0"

  # direct_connect_gateway_arn (Required)
  # 設定内容: コアネットワークにアタッチするDirect Connect GatewayのARNを指定します。
  # 設定可能な値: 有効なDirect Connect GatewayのARN
  #   形式: "arn:aws:directconnect::123456789012:dx-gateway/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # 省略時: 省略不可
  direct_connect_gateway_arn = "arn:aws:directconnect::123456789012:dx-gateway/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # edge_locations (Required)
  # 設定内容: Direct Connect Gatewayアタッチメントを作成するエッジロケーション（AWSリージョン）の
  #   リストを指定します。コアネットワークの対応するエッジに接続します。
  # 設定可能な値: AWSリージョンコードのリスト（例: ["ap-northeast-1", "us-east-1"]）
  # 省略時: 省略不可
  edge_locations = ["ap-northeast-1"]

  #-------------------------------------------------------------
  # ルーティング設定
  #-------------------------------------------------------------

  # routing_policy_label (Optional)
  # 設定内容: アタッチメントに対してコアネットワークポリシーのルーティングポリシーを
  #   適用するためのラベルを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: ラベルなし
  routing_policy_label = "dx-label"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式（例: "30s", "2h45m"）。有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルト値
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式（例: "30s", "2h45m"）。有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルト値
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式（例: "30s", "2h45m"）。有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルト値
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Direct Connect Gatewayアタッチメントに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-dx-gateway-attachment"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Direct Connect GatewayアタッチメントのARN
# - attachment_policy_rule_number: アタッチメントに関連付けられたポリシールール番号
# - attachment_type: アタッチメントのタイプ（常に "DIRECT_CONNECT_GATEWAY"）
# - core_network_arn: コアネットワークのARN
# - id: アタッチメントの一意識別子
# - owner_account_id: アタッチメントを所有するAWSアカウントID
# - segment_name: アタッチメントが属するコアネットワークセグメント名
# - state: アタッチメントの現在の状態（例: "AVAILABLE", "CREATING"）
# - tags_all: プロバイダーのdefault_tags設定を含むすべてのタグのマップ
#---------------------------------------------------------------
