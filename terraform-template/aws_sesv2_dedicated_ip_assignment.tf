#---------------------------------------------------------------
# AWS SESv2 Dedicated IP Assignment
#---------------------------------------------------------------
#
# Amazon SES (Simple Email Service) v2の専用IPアドレスを
# 指定した専用IPプールに割り当てるリソースです。
# アカウントに紐付いた専用IPを特定のIPプールへ移動させることで、
# 送信メールの種類（マーケティング、トランザクション等）ごとに
# 送信者レピュテーションを分離して管理できます。
# 割り当て前に対象のIPアドレスがアカウントに存在している必要があります。
#
# AWS公式ドキュメント:
#   - 専用IPアドレスの概要: https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip.html
#   - 専用IPプールへのIPの追加: https://docs.aws.amazon.com/ses/latest/dg/dedicated-ip-pools.html
#   - PutDedicatedIpInPool API: https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_PutDedicatedIpInPool.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_dedicated_ip_assignment
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sesv2_dedicated_ip_assignment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # ip (Required)
  # 設定内容: 割り当てる専用IPアドレスを指定します。
  # 設定可能な値: アカウントに紐付いた有効な専用IPアドレス文字列（例: "1.2.3.4"）
  # 注意: 事前にAmazon SESからプロビジョニングされた専用IPアドレスが必要です。
  ip = "1.2.3.4"

  # destination_pool_name (Required)
  # 設定内容: IPアドレスの割り当て先となる専用IPプールの名前を指定します。
  # 設定可能な値: アカウントに存在するSTANDARDスケーリングモードの専用IPプール名
  # 注意: MANAGEDスケーリングモードのプールへの割り当ては不可です。
  #       プールは aws_sesv2_dedicated_ip_pool リソースで事前に作成してください。
  destination_pool_name = "my-dedicated-ip-pool"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: IPアドレスと割り当て先プール名を組み合わせた識別子
#       フォーマット: "<ip>,<destination_pool_name>"
#---------------------------------------------------------------
