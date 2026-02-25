#######################################################################
# VPC Flow Log
#######################################################################
# VPC、サブネット、ENI、Transit Gateway、Transit Gateway Attachmentの
# ネットワークトラフィックをキャプチャしてログ記録するためのリソース。
# ログはCloudWatch Logs、S3、またはKinesis Data Firehoseへ送信可能。
#
# 主な用途:
# - ネットワークトラフィックの可視化と分析
# - セキュリティ監視とインシデント調査
# - トラブルシューティングとパフォーマンス分析
# - コンプライアンス要件への対応
#
# 参考: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/flow_log
#
# NOTE: このテンプレートの属性は実際の要件に応じてコメントを外して使用してください
#-----------------------------------------------------------------------

resource "aws_flow_log" "example" {
  #-----------------------------------------------------------------------
  # 監視対象リソースの指定
  #-----------------------------------------------------------------------
  # 以下のいずれか1つを指定する必要があります

  # VPCのフローログを有効化
  # 設定内容: VPC全体のトラフィックを監視
  # 省略時: 他のリソースIDが必要
  vpc_id = aws_vpc.example.id

  # サブネットのフローログを有効化
  # 設定内容: 特定サブネットのトラフィックを監視
  # 省略時: 他のリソースIDが必要
  subnet_id = aws_subnet.example.id

  # ENI（Elastic Network Interface）のフローログを有効化
  # 設定内容: 特定のネットワークインターフェイスを監視
  # 省略時: 他のリソースIDが必要
  eni_id = aws_network_interface.example.id

  # Transit Gatewayのフローログを有効化
  # 設定内容: Transit Gateway全体のトラフィックを監視
  # 省略時: 他のリソースIDが必要
  transit_gateway_id = aws_ec2_transit_gateway.example.id

  # Transit Gateway Attachmentのフローログを有効化
  # 設定内容: 特定のアタッチメントのトラフィックを監視
  # 省略時: 他のリソースIDが必要
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id

  # Regional NAT Gatewayのフローログを有効化
  # 設定内容: リージョナルNATゲートウェイのトラフィックを監視
  # 省略時: 他のリソースIDが必要
  regional_nat_gateway_id = aws_nat_gateway.example.id

  #-----------------------------------------------------------------------
  # トラフィック種別の設定
  #-----------------------------------------------------------------------

  # キャプチャするトラフィックの種類
  # 設定内容: 記録対象となるトラフィックの種別
  # 設定可能な値:
  #   - ACCEPT: 許可されたトラフィックのみ
  #   - REJECT: 拒否されたトラフィックのみ
  #   - ALL: すべてのトラフィック（許可・拒否両方）
  # 注意: eni_id、regional_nat_gateway_id、subnet_id、vpc_idを
  #       指定する場合は必須
  traffic_type = "ALL"

  #-----------------------------------------------------------------------
  # ログ送信先の設定
  #-----------------------------------------------------------------------

  # ログの送信先タイプ
  # 設定内容: フローログの保存先サービス
  # 設定可能な値:
  #   - cloud-watch-logs: CloudWatch Logsへ送信
  #   - s3: S3バケットへ送信
  #   - kinesis-data-firehose: Kinesis Data Firehoseへ送信
  # 省略時: cloud-watch-logs
  log_destination_type = "cloud-watch-logs"

  # ログ送信先のARN
  # 設定内容:
  #   - CloudWatch Logs: ロググループのARN
  #   - S3: バケットのARN
  #   - Kinesis Data Firehose: 配信ストリームのARN
  # 省略時: 自動計算
  log_destination = aws_cloudwatch_log_group.example.arn

  #-----------------------------------------------------------------------
  # IAMロールの設定
  #-----------------------------------------------------------------------

  # フローログ配信用のIAMロールARN
  # 設定内容: ログ配信権限を持つIAMロールのARN
  # 用途: CloudWatch Logsへの書き込み権限を提供
  # 注意: CloudWatch Logs送信先の場合に必要
  # APIパラメータ: DeliverLogsPermissionArn
  iam_role_arn = aws_iam_role.flow_log.arn

  # クロスアカウント配信用のIAMロールARN
  # 設定内容: 別アカウントへログを配信する際のロール
  # 用途: クロスアカウントでのフローログ配信
  # 注意: ロール名は"AWSLogDeliveryFirehoseCrossAccountRole"で開始する必要がある
  deliver_cross_account_role = aws_iam_role.destination_account_role.arn

  #-----------------------------------------------------------------------
  # ログフォーマットの設定
  #-----------------------------------------------------------------------

  # ログレコードのフィールド形式
  # 設定内容: カスタムログフォーマットの定義
  # フォーマット例: "$${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport}"
  # 利用可能なフィールド: account-id, action, bytes, dstaddr, dstport, end,
  #                       interface-id, log-status, packets, pkt-dstaddr,
  #                       pkt-srcaddr, protocol, srcaddr, srcport, start,
  #                       tcp-flags, type, version, vpc-id, subnet-id など
  # 省略時: デフォルトフォーマット
  log_format = "$${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport}"

  # ログの集約間隔
  # 設定内容: フローログレコードの最大集約時間（秒）
  # 設定可能な値:
  #   - 60: 1分間隔
  #   - 600: 10分間隔
  # 省略時: 600
  # 注意: transit_gateway_idまたはtransit_gateway_attachment_id指定時は
  #       60秒（1分）を指定する必要がある
  max_aggregation_interval = 600

  #-----------------------------------------------------------------------
  # S3送信先のオプション設定
  #-----------------------------------------------------------------------

  # S3へのログ保存時の詳細オプション
  destination_options {
    # ファイルフォーマット
    # 設定内容: S3に保存するログファイルの形式
    # 設定可能な値:
    #   - plain-text: プレーンテキスト形式
    #   - parquet: Apache Parquet形式（列指向、圧縮効率高）
    # 省略時: plain-text
    file_format = "plain-text"

    # Hive互換パーティション
    # 設定内容: S3プレフィックスをHive互換形式にするか
    # 設定可能な値: true / false
    # 用途: Amazon Athenaなどでのクエリを効率化
    # 省略時: false
    hive_compatible_partitions = false

    # 時間別パーティション
    # 設定内容: ログを1時間ごとにパーティション分割するか
    # 設定可能な値: true / false
    # 用途: クエリコストと応答時間の削減
    # 省略時: false
    per_hour_partition = false
  }

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # リソース管理リージョン
  # 設定内容: フローログリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # リソースタグ
  # 設定内容: フローログに付与するタグ（キー・バリューペア）
  # 用途: リソース管理、コスト配分、アクセス制御
  # 注意: プロバイダーのdefault_tagsと重複するキーは上書きされる
  tags = {
    Name        = "example-flow-log"
    Environment = "production"
    Purpose     = "network-monitoring"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#   フローログのID
#
# - arn
#   フローログのARN
#
# - tags_all
#   リソースに割り当てられたすべてのタグ
#   （プロバイダーのdefault_tagsから継承されたタグを含む）
#-----------------------------------------------------------------------
