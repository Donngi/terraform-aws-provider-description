#---------------------------------------------------------------
# AWS Athena Capacity Reservation
#---------------------------------------------------------------
#
# Amazon Athenaのキャパシティ予約をプロビジョニングするリソースです。
# キャパシティ予約により、Athenaクエリ用の専用サーバーレス処理能力を確保し、
# ワークロード管理機能を活用して重要なワークロードの優先順位付け、制御、
# スケーリングが可能になります。
#
# AWS公式ドキュメント:
#   - キャパシティ予約の管理: https://docs.aws.amazon.com/athena/latest/ug/capacity-management.html
#   - キャパシティ予約の作成: https://docs.aws.amazon.com/athena/latest/ug/capacity-management-creating-capacity-reservations.html
#   - キャパシティ予約API: https://docs.aws.amazon.com/athena/latest/APIReference/API_CapacityReservation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_capacity_reservation
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_athena_capacity_reservation" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: キャパシティ予約の名前を指定します。
  # 設定可能な値: 一意の文字列
  # 注意: 予約名はアカウント・リージョン内で一意である必要があります。
  name = "example-reservation"

  # target_dpus (Required)
  # 設定内容: 要求するデータ処理ユニット（DPU）の数を指定します。
  # 設定可能な値: 24以上の整数
  # 関連機能: Athena DPU (Data Processing Units)
  #   DPUはAthenaがデータにアクセスし処理するために使用するサーバーレスの
  #   コンピュートとメモリリソースを表します。1 DPUは通常4 vCPUと16 GBの
  #   メモリを提供します。保持するDPUの数により、同時実行可能なクエリ数が
  #   決まります。最小予約サイズは24 DPUで、最小課金期間は1時間です。
  #   - https://docs.aws.amazon.com/athena/latest/ug/capacity-management.html
  # 注意:
  #   - DMLクエリは複雑さに応じて4〜124 DPUを消費します
  #   - DDLクエリは各4 DPUを消費します
  #   - アカウント・リージョンあたり最大100予約、合計1,000 DPUまで
  target_dpus = 24

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: キャパシティ予約は特定のリージョンでのみ利用可能です。
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-capacity-reservation"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトをカスタマイズします。
  # 関連機能: Terraformタイムアウト設定
  #   キャパシティの割り当てには時間がかかる場合があり、特に大量のDPUを
  #   リクエストした場合は最大30分かかることがあります。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な単位: "s"（秒）, "m"（分）, "h"（時間）
    # 注意: 削除操作時には予約のキャンセルと削除の両方が行われます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - allocated_dpus: 現在割り当てられているDPUの数。
#                   予約作成後、Athenaが要求された量に達するまでDPUを割り当てます。
#
# - arn: キャパシティ予約のAmazon Resource Name (ARN)。
#
# - status: キャパシティ予約のステータス。
#           有効な値: PENDING, ACTIVE, FAILED, UPDATE_PENDING, CANCELLING, CANCELLED
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
