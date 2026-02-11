#---------------------------------------------------------------
# AWS Network Manager Connect Attachment
#---------------------------------------------------------------
#
# AWS Network Manager のConnect Attachmentを作成するリソース。
#
# Connect Attachmentは、Core NetworkエッジとAmazon VPCで実行される
# サードパーティ仮想アプライアンス（SD-WANアプライアンスなど）間の
# 接続を確立するために使用される。GREトンネルプロトコルまたは
# Tunnel-less Connectプロトコルをサポートし、動的ルーティングには
# BGPを使用する。
#
# Connect Attachmentを作成した後、Connect Peer（GREまたはTunnel-less
# Connectトンネル）を作成してCore NetworkエッジとサードパーティSDWAN
# アプライアンス間を接続できる。
#
# 重要な注意事項:
#   - Connect AttachmentはCore Networkを所有するAWSアカウントと同じ
#     アカウントで作成する必要がある
#   - 既存のVPC Attachmentをトランスポートメカニズムとして使用する
#   - Tunnel-less ConnectはVPC Connect Attachmentでのみサポート
#   - 同じVPCにConnect (GRE)とConnect (Tunnel-less)の両方が共存可能
#     だが、Tunnel-less Attachmentは1VPCに1つまで
#
# AWS公式ドキュメント:
#   - Connect attachments and Connect peers in AWS Cloud WAN:
#     https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-connect-attachment.html
#   - Create a Connect attachment:
#     https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-connect-attachment-add.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/networkmanager_connect_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_connect_attachment" "example" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # core_network_id (必須, string)
  # Connect Attachmentを作成するCore NetworkのID。
  # Core NetworkはAWS Cloud WANの中核となるネットワークリソースで、
  # グローバルなネットワーク接続を管理する。
  core_network_id = "core-network-0123456789abcdef0"

  # edge_location (必須, string)
  # エッジが配置されているAWSリージョン。
  # Connect AttachmentはCore Network Edgeが存在するリージョンに
  # 作成される。Transport Attachmentと同じedge_locationを指定する
  # ことが一般的。
  # 例: "us-east-1", "ap-northeast-1"
  edge_location = "ap-northeast-1"

  # transport_attachment_id (必須, string)
  # トランスポートアタッチメントのID。
  # Connect Attachmentは既存のVPC AttachmentまたはTransit Gateway
  # Attachmentをトランスポートメカニズムとして使用する。
  # 通常はaws_networkmanager_vpc_attachmentリソースのIDを指定する。
  transport_attachment_id = "attachment-0123456789abcdef0"

  #---------------------------------------------------------------
  # options ブロック (必須)
  #---------------------------------------------------------------
  # Connect Attachmentの設定オプション。
  # このブロックは必須で、1つだけ指定可能。

  options {
    # protocol (オプション, string)
    # アタッチメント接続に使用するプロトコル。
    # 有効な値:
    #   - "GRE": Generic Routing Encapsulation。トンネルベースの接続。
    #           最大5Gbpsのスループットをサポート。
    #   - "NO_ENCAP": Tunnel-less Connect。トンネルなしの接続。
    #           IPsecやGREトンネルを必要とせず、BGPのみで接続。
    #           オーバーヘッドがないため、より高いパフォーマンスと
    #           ピーク帯域幅を提供。VPC Attachment帯域幅全体を利用可能。
    # デフォルト: 未指定の場合はGREが使用される（プロバイダー依存）
    protocol = "GRE"
  }

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # routing_policy_label (オプション, string)
  # トラフィックルーティング決定のためにConnect Attachmentに適用する
  # ルーティングポリシーラベル。
  # 最大256文字。この値を変更するとリソースが再作成される。
  # ルーティングポリシーラベルを使用して、アタッチメントを特定の
  # ルーティングポリシーに関連付けることができる。
  # routing_policy_label = "production"

  # tags (オプション, map(string))
  # アタッチメントに割り当てるキーバリューのタグ。
  # プロバイダーレベルの default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを
  # 上書きする。
  # tags = {
  #   Name        = "example-connect-attachment"
  #   Environment = "production"
  # }

  #---------------------------------------------------------------
  # timeouts ブロック (オプション)
  #---------------------------------------------------------------
  # リソースの作成・削除操作のタイムアウト設定。
  # Connect Attachmentは非同期で作成・削除されるため、
  # 完了までに時間がかかる場合がある。

  # timeouts {
  #   # create (オプション, string)
  #   # リソース作成のタイムアウト時間。
  #   # 形式: "30m", "1h" など（GoのDuration形式）
  #   # デフォルト: プロバイダーのデフォルト値
  #   create = "30m"
  #
  #   # delete (オプション, string)
  #   # リソース削除のタイムアウト時間。
  #   # 形式: "30m", "1h" など（GoのDuration形式）
  #   # デフォルト: プロバイダーのデフォルト値
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能（設定不可）:
#
# arn                           - Connect AttachmentのARN
# attachment_id                 - AttachmentのID
# attachment_policy_rule_number - Attachmentに関連付けられたポリシールール番号
# attachment_type               - Attachmentのタイプ（"CONNECT"）
# core_network_arn              - Core NetworkのARN
# id                            - AttachmentのID（attachment_idと同じ）
# owner_account_id              - Attachment所有者のAWSアカウントID
# resource_arn                  - AttachmentリソースのARN
# segment_name                  - セグメントAttachment名
# state                         - Attachmentの状態
#                                 （CREATING, AVAILABLE, PENDING_ATTACHMENT_ACCEPTANCE,
#                                   PENDING_NETWORK_UPDATE, DELETING, FAILED等）
# tags_all                      - プロバイダーのdefault_tagsから継承された
#                                 タグを含む、すべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: VPC Attachmentと組み合わせた基本構成
#---------------------------------------------------------------
#
# # 前提: VPC Attachmentが作成済み
# resource "aws_networkmanager_vpc_attachment" "example" {
#   subnet_arns     = aws_subnet.example[*].arn
#   core_network_id = awscc_networkmanager_core_network.example.id
#   vpc_arn         = aws_vpc.example.arn
# }
#
# # Connect Attachmentの作成
# resource "aws_networkmanager_connect_attachment" "example" {
#   core_network_id         = awscc_networkmanager_core_network.example.id
#   transport_attachment_id = aws_networkmanager_vpc_attachment.example.id
#   edge_location           = aws_networkmanager_vpc_attachment.example.edge_location
#   options {
#     protocol = "GRE"
#   }
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Attachment Accepterとの組み合わせ
#---------------------------------------------------------------
#
# # VPC Attachmentの作成
# resource "aws_networkmanager_vpc_attachment" "example" {
#   subnet_arns     = aws_subnet.example[*].arn
#   core_network_id = awscc_networkmanager_core_network.example.id
#   vpc_arn         = aws_vpc.example.arn
# }
#
# # VPC Attachmentの承認
# resource "aws_networkmanager_attachment_accepter" "vpc" {
#   attachment_id   = aws_networkmanager_vpc_attachment.example.id
#   attachment_type = aws_networkmanager_vpc_attachment.example.attachment_type
# }
#
# # Connect Attachmentの作成（VPC Attachment承認後）
# resource "aws_networkmanager_connect_attachment" "example" {
#   core_network_id         = awscc_networkmanager_core_network.example.id
#   transport_attachment_id = aws_networkmanager_vpc_attachment.example.id
#   edge_location           = aws_networkmanager_vpc_attachment.example.edge_location
#   options {
#     protocol = "GRE"
#   }
#   depends_on = [
#     aws_networkmanager_attachment_accepter.vpc
#   ]
# }
#
# # Connect Attachmentの承認
# resource "aws_networkmanager_attachment_accepter" "connect" {
#   attachment_id   = aws_networkmanager_connect_attachment.example.id
#   attachment_type = aws_networkmanager_connect_attachment.example.attachment_type
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Tunnel-less Connect（NO_ENCAP）
#---------------------------------------------------------------
#
# resource "aws_networkmanager_connect_attachment" "tunnel_less" {
#   core_network_id         = awscc_networkmanager_core_network.example.id
#   transport_attachment_id = aws_networkmanager_vpc_attachment.example.id
#   edge_location           = aws_networkmanager_vpc_attachment.example.edge_location
#   options {
#     protocol = "NO_ENCAP"
#   }
#   routing_policy_label = "sdwan-segment"
#   tags = {
#     Name = "tunnel-less-connect"
#   }
# }
#---------------------------------------------------------------
