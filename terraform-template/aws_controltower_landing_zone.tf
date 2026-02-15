#---------------------------------------
# AWS Control Tower Landing Zone
#---------------------------------------
# AWS Control TowerのLanding Zoneを作成・管理するリソース
# Landing Zoneは組織全体のマルチアカウント環境のベースラインを提供
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# NOTE:
# 【主な機能】
# - Landing Zoneのバージョン管理とアップデート
# - マニフェストJSONによる設定管理
# - ドリフト検出とステータス監視
# - タグベースのリソース管理
#
# 【前提条件】
# - AWS Organizations が有効であること
# - 管理アカウントで実行すること
# - 必要なサービスへのアクセス許可があること
#
# 【制約事項】
# - Landing Zoneは組織ごとに1つのみ作成可能
# - 削除には通常60分以上かかる場合がある
# - バージョンのダウングレードは非サポート
#
# 参照: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/controltower_landing_zone

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_controltower_landing_zone" "example" {
  # Landing Zoneのバージョン
  # 設定内容: Control TowerのLanding Zoneバージョン（例: "3.0", "3.1"）
  # 設定可能な値: AWS Control Towerでサポートされているバージョン番号
  # 注意: アップグレードは可能だがダウングレードは不可
  version = "3.0"

  # Landing Zone設定マニフェスト
  # 設定内容: Landing Zoneの設定を定義するJSON形式の文字列
  # 必須項目: governedRegions, organizationStructure, centralizedLogging, securityRoles等
  # 注意: JSON構文エラーがあると作成に失敗する
  manifest_json = jsonencode({
    governedRegions = [
      "ap-northeast-1",
      "us-east-1"
    ]
    organizationStructure = {
      security = {
        name = "Security"
      }
      sandbox = {
        name = "Sandbox"
      }
    }
    centralizedLogging = {
      accountId = "123456789012"
      configurations = {
        loggingBucket = {
          retentionDays = 365
        }
        accessLoggingBucket = {
          retentionDays = 3650
        }
      }
      enabled = true
    }
    securityRoles = {
      accountId = "123456789012"
    }
    accessManagement = {
      enabled = true
    }
  })

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # Landing Zoneを管理するリージョン
  # 設定内容: Landing Zoneのホームリージョンを指定
  # 省略時: プロバイダーで設定されたリージョンが使用される
  # 注意: 作成後のリージョン変更には再作成が必要
  region = "ap-northeast-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # リソースタグ
  # 設定内容: Landing Zoneに付与するタグのマップ
  # 用途: コスト配分、リソース管理、アクセス制御
  # 注意: tags_allにはプロバイダーレベルのdefault_tagsもマージされる
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "landing-zone-management"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # 操作タイムアウト設定
  # 作成・更新・削除の各操作のタイムアウト時間を設定
  # 省略時: create=60m, update=120m, delete=120m
  timeouts {
    # Landing Zone作成のタイムアウト
    # 設定内容: 作成処理の最大待機時間
    # 推奨値: 60分以上（初回作成には時間がかかる）
    create = "90m"

    # Landing Zone更新のタイムアウト
    # 設定内容: 更新処理の最大待機時間
    # 推奨値: 120分以上（バージョンアップグレードには時間がかかる）
    update = "150m"

    # Landing Zone削除のタイムアウト
    # 設定内容: 削除処理の最大待機時間
    # 推奨値: 120分以上（削除には通常60分以上かかる）
    delete = "180m"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn - Landing ZoneのARN
# - drift_status - ドリフトステータス情報のリスト
#   - status - ドリフトステータス（IN_SYNC, DRIFTED等）
# - id - Landing ZoneのID（ARNと同値）
# - latest_available_version - 利用可能な最新バージョン
# - tags_all - tagsとプロバイダーdefault_tagsを統合したタグマップ
# - region - Landing Zoneが管理されているリージョン
