#---------------------------------------------------------------
# AWS Network Manager Connection
#---------------------------------------------------------------
#
# AWS Network Manager内のグローバルネットワークにおいて、
# 2つのデバイス間の接続（Connection）を作成・管理するリソース。
# オンプレミスネットワークやブランチオフィス間の論理的な接続を
# 定義し、ネットワークトポロジーを可視化・管理するために使用する。
#
# AWS公式ドキュメント:
#   - Create a connection using AWS Network Manager: https://docs.aws.amazon.com/network-manager/latest/tgwnm/creating-a-connection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_connection" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # global_network_id (Required, string)
  # -----------------------------------------
  # 接続を作成するグローバルネットワークのID。
  # aws_networkmanager_global_network リソースで作成したグローバルネットワークの
  # IDを指定する。
  global_network_id = null # 例: aws_networkmanager_global_network.example.id

  # device_id (Required, string)
  # -----------------------------------------
  # 接続における最初のデバイス（接続元デバイス）のID。
  # aws_networkmanager_device リソースで作成したデバイスのIDを指定する。
  device_id = null # 例: aws_networkmanager_device.example1.id

  # connected_device_id (Required, string)
  # -----------------------------------------
  # 接続における2番目のデバイス（接続先デバイス）のID。
  # device_id とは異なるデバイスを指定する必要がある。
  connected_device_id = null # 例: aws_networkmanager_device.example2.id

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description (Optional, string)
  # -----------------------------------------
  # 接続の説明文。
  # 接続の目的や用途を識別するための説明を記載できる。
  # description = "Connection between Tokyo office and Osaka office"

  # link_id (Optional, string)
  # -----------------------------------------
  # 最初のデバイス（device_id で指定したデバイス）に関連付けるリンクのID。
  # aws_networkmanager_link リソースで作成したリンクのIDを指定する。
  # リンクはデバイスとサイト間の物理的な接続を表す。
  # link_id = aws_networkmanager_link.example1.id

  # connected_link_id (Optional, string)
  # -----------------------------------------
  # 2番目のデバイス（connected_device_id で指定したデバイス）に関連付けるリンクのID。
  # aws_networkmanager_link リソースで作成したリンクのIDを指定する。
  # connected_link_id = aws_networkmanager_link.example2.id

  # tags (Optional, map of string)
  # -----------------------------------------
  # 接続に付与するタグのキーと値のマップ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはこのリソースで定義された値で上書きされる。
  # tags = {
  #   Name        = "tokyo-osaka-connection"
  #   Environment = "production"
  # }

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  #---------------------------------------------------------------
  # リソースの作成、更新、削除操作のタイムアウト時間を設定する。
  # デフォルト値で問題がある場合にのみ設定する。
  #
  # timeouts {
  #   # create (Optional, string)
  #   # -----------------------------------------
  #   # リソース作成時のタイムアウト時間。
  #   # 形式: "60m"（60分）、"1h"（1時間）など。
  #   # create = "10m"
  #
  #   # update (Optional, string)
  #   # -----------------------------------------
  #   # リソース更新時のタイムアウト時間。
  #   # update = "10m"
  #
  #   # delete (Optional, string)
  #   # -----------------------------------------
  #   # リソース削除時のタイムアウト時間。
  #   # delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能（computed）。
# Terraform設定内で直接値を設定することはできない。
#
# - arn        : 接続のAmazon Resource Name (ARN)
# - id         : 接続のID
# - tags_all   : プロバイダーレベルの default_tags を含む全タグのマップ
#---------------------------------------------------------------
