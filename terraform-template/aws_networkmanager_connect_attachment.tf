#---------------------------------------------------------------
# AWS Network Manager Connect Attachment
#---------------------------------------------------------------
#
# AWS Cloud WANのコアネットワークにConnectアタッチメントを作成・管理します。
# ConnectアタッチメントはトランスポートアタッチメントをベースとしてGREトンネルを
# 確立し、SD-WANソリューションやサードパーティのネットワーク仮想アプライアンスと
# コアネットワークを接続するために使用されます。
#
# AWS公式ドキュメント:
#   - AWS Cloud WAN: https://docs.aws.amazon.com/vpc/latest/cloudwan/what-is-cloudwan.html
#   - Connect Attachment: https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-attachments.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_connect_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_connect_attachment" "example" {
  #-------------------------------------------------------------
  # コアネットワーク設定
  #-------------------------------------------------------------

  # core_network_id (Required)
  # 設定内容: ConnectアタッチメントをアタッチするCloud WANコアネットワークのIDを指定します。
  # 設定可能な値: 有効なコアネットワークID
  # 関連機能: AWS Cloud WAN Core Network
  #   Cloud WANのグローバルネットワークの中心となるバックボーン。
  #   複数リージョンにまたがるネットワークを統合管理します。
  #   - https://docs.aws.amazon.com/vpc/latest/cloudwan/cloudwan-core-networks.html
  core_network_id = "core-network-0123456789abcdef0"

  # edge_location (Required)
  # 設定内容: Connectアタッチメントを作成するエッジロケーション（AWSリージョン）を指定します。
  # 設定可能な値: AWSリージョンコード（例: "ap-northeast-1"）
  # 省略時: 省略不可
  edge_location = "ap-northeast-1"

  # transport_attachment_id (Required)
  # 設定内容: ConnectアタッチメントのベースとなるトランスポートアタッチメントのIDを指定します。
  # 設定可能な値: 有効なVPCアタッチメントIDまたはTransit GatewayアタッチメントID
  # 関連機能: トランスポートアタッチメント
  #   ConnectアタッチメントはGREトンネルのオーバーレイであり、
  #   既存のVPCアタッチメントやTransit GatewayアタッチメントをトランスポートとしてGREを確立します。
  transport_attachment_id = "attachment-0123456789abcdef0"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # routing_policy_label (Optional)
  # 設定内容: ルーティングポリシーに使用するラベルを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: ラベルなし
  routing_policy_label = "connect-label"

  #-------------------------------------------------------------
  # プロトコル設定
  #-------------------------------------------------------------

  # options ブロック (Required)
  # 設定内容: Connectアタッチメントのプロトコルオプションを指定します。
  options {
    # protocol (Optional)
    # 設定内容: トンネルプロトコルを指定します。
    # 設定可能な値: "GRE"（Generic Routing Encapsulation）, "NO_ENCAP"（カプセル化なし）
    # 省略時: "GRE"
    #   GRE: SD-WANアプライアンスとの接続に使用する標準的なトンネルプロトコル。
    #   NO_ENCAP: カプセル化なしで直接接続します。
    protocol = "GRE"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式（例: "30m", "1h"）
    # 省略時: 30分
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのduration形式（例: "30m", "1h"）
    # 省略時: 30分
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Connectアタッチメントに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-connect-attachment"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ConnectアタッチメントのARN
# - attachment_id: アタッチメントのID
# - attachment_policy_rule_number: アタッチメントに関連付けられたポリシールール番号
# - attachment_type: アタッチメントのタイプ（常に "CONNECT"）
# - core_network_arn: コアネットワークのARN
# - id: Connectアタッチメントの一意識別子
# - owner_account_id: アタッチメントを所有するAWSアカウントID
# - resource_arn: トランスポートアタッチメントのリソースARN
# - segment_name: アタッチメントが属するコアネットワークセグメント名
# - state: アタッチメントの現在の状態（例: "AVAILABLE", "CREATING"）
# - tags_all: プロバイダーのdefault_tags設定を含むすべてのタグのマップ
#---------------------------------------------------------------
