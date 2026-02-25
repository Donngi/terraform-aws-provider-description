#---------------------------------------------------------------
# Amazon OpenSearch Service Inbound Connection Accepter
#---------------------------------------------------------------
#
# Amazon OpenSearch Serviceのインバウンド接続リクエストを承認するリソースです。
# クロスクラスター検索を有効にするために、リモートアカウントやリージョンから
# 送られてくる接続リクエストを受け入れる際に使用します。
#
# AWS公式ドキュメント:
#   - クロスクラスター検索: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cross-cluster-search.html
#   - AcceptInboundConnection API: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_AcceptInboundConnection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_inbound_connection_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_inbound_connection_accepter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # connection_id (Required)
  # 設定内容: 受け入れるインバウンド接続のIDを指定します。
  # 設定可能な値: aws_opensearch_outbound_connection リソースの connection_id 属性などを参照
  # 用途: アウトバウンド側で作成された接続リクエストのIDを指定して承認を行います。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/APIReference/API_AcceptInboundConnection.html
  connection_id = "abc12345678"

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

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略可能: このブロックは省略可能です。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成（接続承認）のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = "5m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列（例: "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 接続のID（connection_id と同一の値）
#
# - connection_status: 接続の現在のステータス
#        承認後のステータスを示します（例: ACTIVE, PENDING_ACCEPTANCE 等）
#---------------------------------------------------------------
