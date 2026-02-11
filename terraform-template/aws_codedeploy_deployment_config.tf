#================================================================================
# AWS CodeDeploy Deployment Config - Annotated Template
#================================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: このテンプレートは生成時点の仕様に基づいています。
#       最新の仕様については公式ドキュメントを必ず確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config
#
# Description:
#   CodeDeployのデプロイメント設定を定義するリソースです。
#   デプロイ中に維持すべき最小ヘルシーホスト数や、Lambda/ECSのトラフィックルーティング戦略を設定できます。
#================================================================================

resource "aws_codedeploy_deployment_config" "example" {
  #------------------------------------------------------------------------------
  # Required Arguments
  #------------------------------------------------------------------------------

  # デプロイメント設定の名前
  # - 一意である必要があります
  # - 使用例: "MyApp-Deployment-Config"
  # AWS Docs: https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html
  deployment_config_name = "example-deployment-config"

  #------------------------------------------------------------------------------
  # Optional Arguments
  #------------------------------------------------------------------------------

  # コンピュートプラットフォームの指定
  # - 有効な値: "Server" (デフォルト), "Lambda", "ECS"
  # - Server: EC2/オンプレミスインスタンス向け
  # - Lambda: Lambda関数のトラフィックシフト向け
  # - ECS: ECSサービスのBlue/Greenデプロイメント向け
  # AWS Docs: https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html
  compute_platform = "Server"

  # リソースID（通常は自動生成されるため、明示的な設定は不要）
  # - Terraformによって自動的に計算されます
  # - 通常は deployment_config_name と同じ値になります
  # - インポート時など特殊なケースでのみ使用
  # id = "example-deployment-config"

  # このリソースが管理されるAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - 例: "us-east-1", "ap-northeast-1"
  # AWS Docs: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #------------------------------------------------------------------------------
  # Block: minimum_healthy_hosts
  #------------------------------------------------------------------------------
  # デプロイ中に維持する必要がある最小ヘルシーインスタンス数
  # - compute_platform が "Server" の場合に必須
  # - デプロイの成功/失敗を判断する基準として使用されます
  # AWS Docs: https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-health.html
  #           https://docs.aws.amazon.com/codedeploy/latest/APIReference/API_MinimumHealthyHosts.html

  minimum_healthy_hosts {
    # ヘルシーホストの指定タイプ
    # - 有効な値: "HOST_COUNT", "FLEET_PERCENT"
    # - HOST_COUNT: 絶対数で指定（例: 最低3台）
    # - FLEET_PERCENT: パーセンテージで指定（例: 最低50%）
    type = "HOST_COUNT"

    # ヘルシーホストの値
    # - type が "HOST_COUNT" の場合: 絶対数（例: 2 = 最低2台必要）
    # - type が "FLEET_PERCENT" の場合: パーセンテージ（例: 75 = 最低75%必要）
    #
    # 例: 9台のインスタンスがあり、HOST_COUNTが6の場合:
    #   - CodeDeployは最大3台ずつデプロイ
    #   - 6台以上が正常にデプロイされれば成功
    #
    # 例: 9台のインスタンスがあり、FLEET_PERCENTが40の場合:
    #   - CodeDeployは最大5台ずつデプロイ
    #   - 4台以上が正常にデプロイされれば成功（40% = 3.6台 → 切り上げで4台）
    value = 2
  }

  #------------------------------------------------------------------------------
  # Block: traffic_routing_config
  #------------------------------------------------------------------------------
  # トラフィックルーティング設定（Lambda/ECS向け）
  # - compute_platform が "Lambda" または "ECS" の場合に使用
  # - Blue/Greenデプロイメント時のトラフィックシフト戦略を定義
  # AWS Docs: https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html

  traffic_routing_config {
    # トラフィックルーティングのタイプ
    # - 有効な値: "TimeBasedCanary", "TimeBasedLinear", "AllAtOnce"
    # - TimeBasedCanary: 最初に一部、その後残り全てをシフト（カナリアデプロイメント）
    # - TimeBasedLinear: 段階的に均等にシフト（リニアデプロイメント）
    # - AllAtOnce: 一度に全トラフィックをシフト
    type = "TimeBasedLinear"

    #--------------------------------------------------------------------------
    # Nested Block: time_based_canary
    #--------------------------------------------------------------------------
    # カナリアデプロイメント設定
    # - type が "TimeBasedCanary" の場合に使用
    # - 最初に一部のトラフィックをシフトし、一定時間後に残りをシフト

    # time_based_canary {
    #   # 最初と2回目のトラフィックシフト間の待機時間（分）
    #   # - 例: 10 = 最初のシフト後10分待機してから残りをシフト
    #   interval = 10
    #
    #   # 最初のシフトで移行するトラフィックの割合（パーセント）
    #   # - 例: 10 = 最初に10%のトラフィックを新バージョンにシフト
    #   # - 残りの90%は interval 分後にシフトされる
    #   percentage = 10
    # }

    #--------------------------------------------------------------------------
    # Nested Block: time_based_linear
    #--------------------------------------------------------------------------
    # リニアデプロイメント設定
    # - type が "TimeBasedLinear" の場合に使用
    # - 一定間隔で均等にトラフィックをシフト

    time_based_linear {
      # 各トラフィックシフト間の待機時間（分）
      # - 例: 10 = 10分ごとにトラフィックをシフト
      interval = 10

      # 各シフトで移行するトラフィックの割合（パーセント）
      # - 例: 10 = 10分ごとに10%ずつシフト（合計10回で完了）
      # - 1回目: 10%, 2回目: 20%, ..., 10回目: 100%
      percentage = 10
    }
  }

  #------------------------------------------------------------------------------
  # Block: zonal_config
  #------------------------------------------------------------------------------
  # ゾーン設定（複数のAvailability Zoneへのデプロイ制御）
  # - Availability Zone単位でのデプロイ制御を行う場合に使用
  # - 各AZ間でのデプロイペースや最小ヘルシーホスト数を制御
  # AWS Docs: https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-health.html

  zonal_config {
    # 最初のAvailability Zoneへのデプロイ完了後の待機時間（秒）
    # - 2つ目のAZへのデプロイを開始する前に待機する時間
    # - 指定しない場合、monitor_duration_in_seconds の値が使用される
    # - 例: 300 = 最初のAZへのデプロイ後5分待機
    first_zone_monitor_duration_in_seconds = 300

    # 各Availability Zoneへのデプロイ完了後の待機時間（秒）
    # - 次のAZへのデプロイを開始する前に待機する時間
    # - 指定しない場合、即座に次のAZへのデプロイが開始される
    # - 例: 180 = 各AZへのデプロイ後3分待機
    monitor_duration_in_seconds = 180

    #--------------------------------------------------------------------------
    # Nested Block: minimum_healthy_hosts_per_zone
    #--------------------------------------------------------------------------
    # Availability Zone毎の最小ヘルシーホスト数
    # - 各AZ内で維持する必要がある最小ヘルシーインスタンス数
    # - 指定しない場合、デフォルトは0%

    minimum_healthy_hosts_per_zone {
      # ヘルシーホストの指定タイプ
      # - 有効な値: "HOST_COUNT", "FLEET_PERCENT"
      # - HOST_COUNT: 絶対数で指定（例: 各AZで最低2台）
      # - FLEET_PERCENT: パーセンテージで指定（例: 各AZで最低50%）
      type = "FLEET_PERCENT"

      # ヘルシーホストの値
      # - type が "HOST_COUNT" の場合: 各AZ内での絶対数
      # - type が "FLEET_PERCENT" の場合: 各AZ内でのパーセンテージ
      #
      # 例: あるAZに6台のインスタンスがあり、FLEET_PERCENTが50の場合:
      #   - そのAZ内で最低3台（50% = 3台）がヘルシーである必要がある
      #   - CodeDeployは最大3台ずつそのAZ内でデプロイ
      value = 50
    }
  }
}

#================================================================================
# Outputs (参考用)
#================================================================================

# output "deployment_config_arn" {
#   description = "デプロイメント設定のARN"
#   value       = aws_codedeploy_deployment_config.example.arn
# }
#
# output "deployment_config_id" {
#   description = "デプロイメント設定のID（設定名と同じ）"
#   value       = aws_codedeploy_deployment_config.example.id
# }
#
# output "deployment_config_deployment_config_id" {
#   description = "AWSが割り当てたデプロイメント設定ID"
#   value       = aws_codedeploy_deployment_config.example.deployment_config_id
# }

#================================================================================
# 主要な参考資料
#================================================================================
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config
#
# - AWS CodeDeploy User Guide - Deployment Configurations:
#   https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html
#
# - AWS CodeDeploy User Guide - Instance Health:
#   https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-health.html
#
# - AWS CodeDeploy API Reference - CreateDeploymentConfig:
#   https://docs.aws.amazon.com/codedeploy/latest/APIReference/API_CreateDeploymentConfig.html
#
# - AWS CodeDeploy API Reference - MinimumHealthyHosts:
#   https://docs.aws.amazon.com/codedeploy/latest/APIReference/API_MinimumHealthyHosts.html
#================================================================================
