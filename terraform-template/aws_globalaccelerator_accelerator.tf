###############################################################################################
# Terraform Template: aws_globalaccelerator_accelerator
###############################################################################################
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# 概要:
#   このリソースは、AWS Global Accelerator のアクセラレーターを作成します。
#   Global Accelerator はグローバルに分散したエンドポイントへのトラフィックを
#   AWS グローバルネットワーク経由でルーティングし、可用性とパフォーマンスを向上させます。
#
# 主な用途:
#   - マルチリージョンアプリケーションへのグローバルルーティング
#   - スタティック IP アドレスによるエンドポイントへのアクセス
#   - フェイルオーバーと負荷分散の実現
#   - フローログを使用したトラフィックの可視化と監査
#
# 制限事項:
#   - ip_addresses を指定する場合は BYOIP (Bring Your Own IP) の設定が必要
#   - ip_address_type が IPV4 の場合は 1 または 2 個の IPv4 アドレスを指定可能
#   - flow_logs_enabled が true の場合は flow_logs_s3_bucket と flow_logs_s3_prefix が必須
#
# 関連ドキュメント:
#   - https://docs.aws.amazon.com/global-accelerator/latest/dg/what-is-global-accelerator.html
#   - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_accelerator
#
# NOTE:
#   ip_addresses を省略した場合は AWS がスタティック IP アドレスを自動割り当てします。
#   BYOIP を利用する場合は事前に IP アドレスプロビジョニングが必要です。
#
###############################################################################################

#-------
# リソース定義
#-------
resource "aws_globalaccelerator_accelerator" "example" {

  #-------
  # 基本設定
  #-------
  # 設定内容: アクセラレーターの名前
  # 設定可能な値: 文字列（英数字、ハイフンを含む）
  # 省略時: 必須項目のため指定が必要
  name = "example-global-accelerator"

  #-------
  # IP アドレス設定
  #-------
  # 設定内容: アドレスタイプ（IP バージョン）
  # 設定可能な値: "IPV4"（IPv4 のみ）, "DUAL_STACK"（IPv4 と IPv6）
  # 省略時: "IPV4" が使用される
  ip_address_type = "IPV4"

  # 設定内容: BYOIP アクセラレーター用の静的 IP アドレスのリスト
  # 設定可能な値: IPv4 アドレスのリスト（1 または 2 個）
  # 省略時: AWS が自動的にスタティック IP アドレスを割り当てる
  ip_addresses = []

  #-------
  # 動作設定
  #-------
  # 設定内容: アクセラレーターの有効・無効
  # 設定可能な値: true（有効）, false（無効）
  # 省略時: true（有効）が使用される
  enabled = true

  #-------
  # フローログ設定
  #-------
  # 設定内容: アクセラレーターの属性設定（フローログ等）
  # 設定可能な値: attributes ブロック
  # 省略時: フローログは無効
  attributes {
    # 設定内容: フローログの有効・無効
    # 設定可能な値: true（有効）, false（無効）
    # 省略時: false（無効）が使用される
    flow_logs_enabled = true

    # 設定内容: フローログを保存する S3 バケット名
    # 設定可能な値: 有効な S3 バケット名（flow_logs_enabled が true の場合は必須）
    # 省略時: flow_logs_enabled が false の場合は不要
    flow_logs_s3_bucket = "example-flow-logs-bucket"

    # 設定内容: S3 バケット内のフローログ保存先プレフィックス
    # 設定可能な値: S3 オブジェクトキープレフィックスの文字列（flow_logs_enabled が true の場合は必須）
    # 省略時: flow_logs_enabled が false の場合は不要
    flow_logs_s3_prefix = "flow-logs/"
  }

  #-------
  # タグ設定
  #-------
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-global-accelerator"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # 設定内容: リソース作成のタイムアウト時間
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    create = "30m"

    # 設定内容: リソース更新のタイムアウト時間
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルト値を使用
    update = "30m"
  }
}

###############################################################################################
# Attributes Reference（参照可能な属性）
###############################################################################################
# このリソースでは以下の属性を参照できます:
#
# - id / arn
#   アクセラレーターの ARN
#
# - dns_name
#   アクセラレーターの DNS 名（例: a5d53ff5ee6bca4ce.awsglobalaccelerator.com）
#
# - dual_stack_dns_name
#   デュアルスタックアクセラレーターの DNS 名（DUAL_STACK タイプ時のみ）
#
# - hosted_zone_id
#   Route 53 エイリアスレコードで使用するホストゾーン ID（固定値: Z2BJ6XQ5FK7U4H）
#
# - ip_sets
#   アクセラレーターに割り当てられた IP アドレスセットのリスト
#
# - tags_all
#   プロバイダーの default_tags とマージされたすべてのタグ
#
###############################################################################################
