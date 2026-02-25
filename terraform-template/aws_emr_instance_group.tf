#---------------------------------------
# aws_emr_instance_group
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# 【リソース概要】
# EMRクラスターのインスタンスグループを構成するリソース
# インスタンスグループはEMRクラスター内でタスクを実行するEC2インスタンスの集合を管理
# CoreグループやTaskグループとして、データ処理のための計算リソースを提供
#
# NOTE: インスタンスグループはAPIやコンソールから削除できない（クラスター削除時に削除される）
# NOTE: Terraformでのdestroy時はインスタンス数を0にリサイズして対応
# NOTE: configurations_jsonはEMR 5.21以降でのみ変更可能
# NOTE: Masterノードグループには使用できない（CoreとTaskのみ）

# 【主な用途】
# - EMRクラスターへのタスク用インスタンスグループの追加
# - スポットインスタンスを使用したコスト最適化
# - オートスケーリングによる動的なキャパシティ調整
# - インスタンスグループごとの個別設定とEBS最適化

# 【前提条件】
# - 既存のEMRクラスターが必要
# - 適切なEC2インスタンスタイプの選択
# - スポットインスタンス使用時は入札価格の設定
# - EBS最適化インスタンスの場合はebs_optimized設定が必要

# 【参考ドキュメント】
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_instance_group

#-------
resource "aws_emr_instance_group" "example" {

  #---------------------------------------
  # クラスター接続設定
  #---------------------------------------
  # 設定内容: インスタンスグループを追加するEMRクラスターのID
  # 設定可能な値: 既存のEMRクラスターID（例: j-XXXXXXXXXXXXX）
  # 備考: このクラスターはRunningまたはWaiting状態である必要がある
  cluster_id = "j-XXXXXXXXXXXXX"

  #---------------------------------------
  # インスタンス基本設定
  #---------------------------------------
  # 設定内容: インスタンスグループで使用するEC2インスタンスタイプ
  # 設定可能な値: 任意のEC2インスタンスタイプ（例: m5.xlarge, c5.2xlarge, r5.large）
  # 備考: ワークロードに応じて適切なインスタンスファミリーを選択
  instance_type = "m5.xlarge"

  # 設定内容: インスタンスグループ内のインスタンス数
  # 設定可能な値: 正の整数
  # 省略時: 計算値（クラスターの状態に基づく）
  # 備考: オートスケーリング設定がある場合は自動調整される
  instance_count = 1

  # 設定内容: インスタンスグループの名前
  # 設定可能な値: 任意の文字列
  # 省略時: AWSが自動生成
  # 備考: クラスター内での識別に使用
  name = "my-instance-group"

  #---------------------------------------
  # コスト最適化設定
  #---------------------------------------
  # 設定内容: スポットインスタンスの最大入札価格（USD）
  # 設定可能な値: 数値文字列（例: "0.05", "0.10"）
  # 省略時: オンデマンドインスタンスとして起動
  # 備考: 設定するとスポットリクエストが自動作成される
  bid_price = "0.05"

  #---------------------------------------
  # ストレージ最適化設定
  #---------------------------------------
  # 設定内容: EBS最適化の有効化
  # 設定可能な値: true, false
  # 省略時: false
  # 備考: EBS最適化対応インスタンスタイプでのみ有効
  ebs_optimized = true

  #---------------------------------------
  # EBS設定（複数指定可能）
  #---------------------------------------
  # ebs_config {
  #   # 設定内容: EBSボリュームのタイプ
  #   # 設定可能な値: "gp2", "gp3", "io1", "io2", "standard"
  #   # 備考: ワークロードに応じてIOPS性能を選択
  #   type = "gp3"
  #
  #   # 設定内容: EBSボリュームのサイズ（GiB）
  #   # 設定可能な値: 1〜1024（EBS最適化の場合は最小10）
  #   # 備考: gp3の場合は基本性能が125MB/s、3000 IOPS
  #   size = 100
  #
  #   # 設定内容: プロビジョンドIOPS数
  #   # 設定可能な値: ボリュームタイプに応じた範囲（io1/io2: 100〜64000）
  #   # 省略時: ボリュームタイプのデフォルト値
  #   # 備考: io1/io2タイプでのみ有効
  #   # iops = 3000
  #
  #   # 設定内容: 各インスタンスにアタッチするEBSボリューム数
  #   # 設定可能な値: 正の整数
  #   # 省略時: 1
  #   # 備考: 複数ボリュームでストライピング構成も可能
  #   # volumes_per_instance = 1
  # }

  #---------------------------------------
  # オートスケーリング設定
  #---------------------------------------
  # 設定内容: オートスケーリングポリシーのJSON定義
  # 設定可能な値: EMRオートスケーリングポリシーのJSON文字列
  # 省略時: オートスケーリング無効
  # 備考: CloudWatchメトリクスに基づいて自動スケーリング
  autoscaling_policy = jsonencode({
    Constraints = {
      MinCapacity = 1
      MaxCapacity = 10
    }
    Rules = [
      {
        Name = "ScaleOutMemoryPercentage"
        Description = "Scale out if YARNMemoryAvailablePercentage is less than 15"
        Action = {
          SimpleScalingPolicyConfiguration = {
            AdjustmentType = "CHANGE_IN_CAPACITY"
            ScalingAdjustment = 1
            CoolDown = 300
          }
        }
        Trigger = {
          CloudWatchAlarmDefinition = {
            ComparisonOperator = "LESS_THAN"
            EvaluationPeriods = 1
            MetricName = "YARNMemoryAvailablePercentage"
            Namespace = "AWS/ElasticMapReduce"
            Period = 300
            Statistic = "AVERAGE"
            Threshold = 15.0
            Unit = "PERCENT"
          }
        }
      }
    ]
  })

  #---------------------------------------
  # インスタンス設定のカスタマイズ
  #---------------------------------------
  # 設定内容: インスタンスグループ固有の設定をJSON形式で指定
  # 設定可能な値: EMR設定分類のJSON配列
  # 省略時: クラスターレベルの設定を継承
  # 備考: EMR 5.21以降でのみ変更可能
  configurations_json = jsonencode([
    {
      Classification = "hadoop-env"
      Configurations = [
        {
          Classification = "export"
          Properties = {
            JAVA_HOME = "/usr/lib/jvm/java-1.8.0"
          }
        }
      ]
      Properties = {}
    }
  ])

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 任意のAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョン
  # 備考: 通常はプロバイダー設定に従うため省略推奨
  region = "ap-northeast-1"
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースの作成後に参照可能な属性
# 他のリソースやoutput値での参照に使用可能

# id
#   設定内容: EMRインスタンスグループのID
#   用途: 他のリソースからの参照や識別
#   形式: <cluster_id>:<instance_group_id>

# running_instance_count
#   設定内容: 現在実行中のインスタンス数
#   用途: モニタリングや条件分岐
#   備考: オートスケーリングにより変動する可能性あり

# status
#   設定内容: インスタンスグループの現在のステータス
#   用途: 状態確認やヘルスチェック
#   設定可能な値: PROVISIONING, BOOTSTRAPPING, RUNNING, RESIZING, SUSPENDED, TERMINATING, TERMINATED, ARRESTED
