#---------------------------------------------------------------
# AWS RDS Reserved DB Instance
#---------------------------------------------------------------
#
# Amazon RDS のリザーブドDBインスタンスを購入・管理するリソースです。
# リザーブドDBインスタンスは、1年または3年の期間でDBインスタンスを予約することで、
# オンデマンド料金と比較して最大69%のコスト削減が可能な課金割引です。
# リザーブドDBインスタンスは物理的なインスタンスではなく、特定のオンデマンドDB
# インスタンスに適用される課金割引です。
#
# 注意: 一度作成したリザーブドDBインスタンスは、offering_idで指定した期間中有効であり、
# 削除することはできません。terraform destroyを実行してもAWSリソースは削除されず、
# Terraform stateからのみ削除されます。
#
# AWS公式ドキュメント:
#   - RDS リザーブドDBインスタンス概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithReservedDBInstances.html
#   - リザーブドDBインスタンスの購入: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithReservedDBInstances.WorkingWith.html
#   - PurchaseReservedDBInstancesOffering API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_PurchaseReservedDBInstancesOffering.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_reserved_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_reserved_instance" "example" {
  #-------------------------------------------------------------
  # オファリング設定
  #-------------------------------------------------------------

  # offering_id (Required, Forces new resource)
  # 設定内容: 購入するリザーブドDBインスタンスオファリングのIDを指定します。
  # 設定可能な値: 有効なオファリングID文字列
  # 注意: offering_idを確認するには aws_rds_reserved_instance_offering データソースを使用してください。
  #   オファリングIDはDBインスタンスクラス・期間・マルチAZ・オファリングタイプ・
  #   データベースエンジンの組み合わせにより一意に決まります。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_DescribeReservedDBInstancesOfferings.html
  offering_id = "438012d3-4052-4cc7-b2e3-8d3372e0e706"

  #-------------------------------------------------------------
  # リザベーション識別子設定
  #-------------------------------------------------------------

  # reservation_id (Optional, Forces new resource)
  # 設定内容: リザベーションを追跡するためのカスタム識別子を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: AWSが自動的に一意の識別子を生成します。
  # 注意: 指定した場合、このIDはTerraformのリソースIDとしても使用されます。
  reservation_id = null

  #-------------------------------------------------------------
  # インスタンス数設定
  #-------------------------------------------------------------

  # instance_count (Optional, Forces new resource)
  # 設定内容: リザーブするDBインスタンスの数を指定します。
  # 設定可能な値: 1以上の整数
  # 省略時: 1
  instance_count = 1

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リザーブドDBインスタンスに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-rds-reserved-instance"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リザーブドDBインスタンス作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルト値
    create = "30m"

    # update (Optional)
    # 設定内容: リザーブドDBインスタンス更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルト値
    update = "10m"

    # delete (Optional)
    # 設定内容: リザーブドDBインスタンス削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルト値
    # 注意: リザーブドDBインスタンスはAWSから実際には削除できないため、
    #       このタイムアウトはstate削除操作に対して適用されます。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リザーブドDBインスタンスのARN
# - currency_code: リザーブドDBインスタンスの通貨コード
# - db_instance_class: リザーブドDBインスタンスのDBインスタンスクラス
# - duration: リザベーションの期間（秒単位）
# - fixed_price: このリザーブドDBインスタンスに課金される固定料金
# - lease_id: リザーブドDBインスタンスに関連するリースの一意の識別子
# - multi_az: リザベーションがマルチAZデプロイメントに適用されるかどうか
# - offering_type: このリザーブドDBインスタンスのオファリングタイプ
# - product_description: リザーブドDBインスタンスの説明
# - recurring_charges: リザーブドDBインスタンスの実行に課金される定期料金のリスト
# - start_time: リザベーションの開始時刻
# - state: リザーブドDBインスタンスの状態
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグのマップ
# - usage_price: このリザーブドDBインスタンスの時間当たりの料金
#---------------------------------------------------------------
