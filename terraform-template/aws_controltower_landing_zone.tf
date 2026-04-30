#---------------------------------------------------------------
# AWS Control Tower Landing Zone
#---------------------------------------------------------------
#
# AWS Control TowerのLanding Zoneをプロビジョニング・管理するリソースです。
# Landing Zoneは、AWS Organizations配下のマルチアカウント環境に対し、
# セキュリティ・ガバナンス・運用のベースラインを提供する基盤環境です。
# マニフェストJSONによる宣言的な構成、ガバナンスリージョン、集約ロギング、
# セキュリティ用OU、アクセス管理、バックアップ等の構成要素を一括で管理します。
#
# AWS公式ドキュメント:
#   - AWS Control Tower 概要: https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html
#   - Landing Zone マニフェストファイル: https://docs.aws.amazon.com/controltower/latest/userguide/lz-manifest-file.html
#   - CreateLandingZone API: https://docs.aws.amazon.com/controltower/latest/APIReference/API_CreateLandingZone.html
#   - LandingZoneDetail データ型: https://docs.aws.amazon.com/controltower/latest/APIReference/API_LandingZoneDetail.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.43.0/docs/resources/controltower_landing_zone
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_controltower_landing_zone" "example" {
  #-------------------------------------------------------------
  # バージョン設定
  #-------------------------------------------------------------

  # version (Required)
  # 設定内容: デプロイするLanding Zoneのバージョンを指定します。
  # 設定可能な値: AWS Control Towerでサポートされているバージョン文字列
  #   形式: "\d+.\d+" (例: "3.3", "3.4")
  #   文字数: 3-10文字
  # 関連機能: Landing Zone バージョン管理
  #   バージョンを更新するとLanding Zone全体がアップグレードされます。
  #   利用可能な最新バージョンは latest_available_version 属性で確認できます。
  #   - https://docs.aws.amazon.com/controltower/latest/userguide/lz-versions.html
  # 注意: ダウングレードはサポートされません。アップグレード前にマニフェストを最新仕様に更新してください。
  version = "3.3"

  #-------------------------------------------------------------
  # マニフェスト設定
  #-------------------------------------------------------------

  # manifest_json (Required)
  # 設定内容: Landing Zoneの構成を定義するマニフェストファイルのJSON文字列を指定します。
  # 設定可能な値: 有効なJSON文字列（jsonencodeでの組み立てを推奨）
  #   主要セクション:
  #     - governedRegions: AWS Control Towerが統制するリージョンの配列
  #     - organizationStructure: Security/Sandbox OUの定義
  #     - centralizedLogging: CloudTrail/Configログ集約用バケット設定
  #     - securityRoles: 監査アカウントの指定
  #     - accessManagement: IAM Identity Centerによるアクセス管理の有効化
  #     - backup: AWS Backupによる集中バックアップ設定（任意）
  # 関連機能: Landing Zone マニフェストファイル
  #   宣言的にLanding Zoneの全構成を定義するファイル。AWS Control Tower環境の
  #   組成・更新・リセットに使用されます。
  #   - https://docs.aws.amazon.com/controltower/latest/userguide/lz-manifest-file.html
  # 注意: JSON構文エラーや必須キーの欠落があると作成に失敗します。
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

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Landing Zoneはホームリージョンに紐付くため、作成後の変更は再作成を伴います。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "ap-northeast-1"

  #-------------------------------------------------------------
  # 修復設定
  #-------------------------------------------------------------

  # remediation_types (Optional)
  # 設定内容: Landing Zone作成・更新時に適用する修復アクションタイプを指定します。
  # 設定可能な値: 文字列のセット（現時点でサポートされる値）
  #   - "INHERITANCE_DRIFT": OU継承制御のドリフトを自動修復
  # 省略時: 修復アクションは適用されません。
  # 関連機能: Landing Zone 修復タイプ
  #   Landing Zoneの作成・更新時に検出されたドリフトを自動的に修復するための設定。
  #   将来的に追加の修復タイプが提供される可能性があります。
  #   - https://docs.aws.amazon.com/controltower/latest/APIReference/API_CreateLandingZone.html
  remediation_types = ["INHERITANCE_DRIFT"]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Landing Zoneに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "primary-landing-zone"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 作成・更新・削除の各操作のタイムアウト時間を指定します。
  # 関連機能: Terraform Resource Timeouts
  #   Landing Zoneの作成・更新・削除は数十分から数時間を要する場合があるため、
  #   実運用に応じて適切なタイムアウトを設定してください。
  #   - https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {
    # create (Optional)
    # 設定内容: 作成処理の最大待機時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "60m", "2h"）
    # 省略時: プロバイダー既定値（通常60分）
    create = "120m"

    # update (Optional)
    # 設定内容: 更新処理の最大待機時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "120m", "3h"）
    # 省略時: プロバイダー既定値（通常120分）
    update = "120m"

    # delete (Optional)
    # 設定内容: 削除処理の最大待機時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "120m", "3h"）
    # 省略時: プロバイダー既定値（通常120分）
    delete = "120m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Landing ZoneのAmazon Resource Name (ARN)
# - id: Landing Zoneの識別子
# - drift_status: ドリフトステータス情報のリスト
#     - status: ドリフトの状態（IN_SYNC, DRIFTED）
# - latest_available_version: 利用可能な最新のLanding Zoneバージョン
# - tags_all: プロバイダーのdefault_tagsを含む全タグのマップ
#---------------------------------------------------------------
