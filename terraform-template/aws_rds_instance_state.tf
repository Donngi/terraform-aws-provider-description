#---------------------------------------------------------------
# AWS RDS Instance State
#---------------------------------------------------------------
#
# RDSデータベースインスタンスの状態を管理するリソースです。
# このリソースを使用することで、RDSインスタンスを起動（available）または
# 停止（stopped）状態に制御できます。
#
# 注意: このリソースの削除は何も行わず、インスタンスの状態は変更されません。
#       インスタンス自体を削除するには aws_db_instance リソースを使用してください。
#
# AWS公式ドキュメント:
#   - RDSインスタンスの停止: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_StopInstance.html
#   - RDSインスタンスの起動: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_StartInstance.html
#   - StopDBInstance API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StopDBInstance.html
#   - StartDBInstance API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartDBInstance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_instance_state
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_instance_state" "example" {
  #-------------------------------------------------------------
  # データベースインスタンス識別子 (Required)
  #-------------------------------------------------------------

  # identifier (Required)
  # 設定内容: 状態を管理するRDSデータベースインスタンスの識別子を指定します。
  # 設定可能な値: 既存のRDSインスタンスのDB Instance Identifier
  # 用途: aws_db_instance リソースで作成したインスタンスのidentifierを参照します。
  # 例: identifier = aws_db_instance.example.identifier
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.html
  identifier = "example-db-instance"

  #-------------------------------------------------------------
  # インスタンス状態設定 (Required)
  #-------------------------------------------------------------

  # state (Required)
  # 設定内容: データベースインスタンスの目標状態を指定します。
  # 設定可能な値:
  #   - "available": インスタンスを起動状態にします
  #   - "stopped": インスタンスを停止状態にします
  # 用途: インスタンスを停止することでコストを削減できます。
  #       停止したインスタンスは最大7日間停止状態を維持でき、
  #       その後自動的に起動されます。
  # 注意事項:
  #   - Multi-AZ配置のインスタンスは停止できません
  #   - リードレプリカを持つインスタンスは停止できません
  #   - リードレプリカ自体も停止できません
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_StopInstance.html
  state = "available"

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを明示的に指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 用途: マルチリージョン構成で特定のリージョンのリソースを
  #       明示的に管理する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: インスタンスの起動や停止に時間がかかる場合にタイムアウト時間を調整します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成（状態変更）操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h45m"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    create = null

    # update (Optional)
    # 設定内容: リソース更新（状態変更）操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "2h45m"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 参考: https://pkg.go.dev/time#ParseDuration
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - identifier: データベースインスタンスの識別子
# - state: データベースインスタンスの現在の状態
# - region: リソースが管理されているリージョン
#

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のRDSインスタンス状態リソースをインポートする場合:
#
#   terraform import aws_rds_instance_state.example example-db-instance
#
# インポート形式: {identifier}
#---------------------------------------------------------------
