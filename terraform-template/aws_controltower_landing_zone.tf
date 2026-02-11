# ============================================================================
# AWS Control Tower Landing Zone
# ============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/controltower_landing_zone
# ============================================================================

resource "aws_controltower_landing_zone" "example" {
  # ============================================================================
  # 必須項目 (Required)
  # ============================================================================

  # manifest_json - (必須) ランディングゾーンの構成を記述するマニフェストJSONファイル
  # AWSリソースを記述したテキストファイル。AWS Control Towerの環境設定を定義します。
  # マニフェストには以下のセクションが含まれます:
  #   - governedRegions: AWS Control Towerで管理するリージョンのリスト
  #   - organizationStructure: セキュリティおよびサンドボックスOUの名前
  #   - centralizedLogging: CloudTrailの設定（アカウントID、保持期間、KMSキーARNなど）
  #   - securityRoles: ログリソースをデプロイするAWSアカウントの指定
  #   - accessManagement: アクセス管理の有効化設定
  #   - backup: AWS Backupの設定（アカウントID、KMSキーARN、有効化フラグ）
  # 参考: https://docs.aws.amazon.com/controltower/latest/userguide/lz-api-launch.html
  # 参考: https://docs.aws.amazon.com/controltower/latest/userguide/lz-manifest-file.html
  manifest_json = file("${path.module}/LandingZoneManifest.json")

  # version - (必須) ランディングゾーンのバージョン
  # デプロイするランディングゾーンのバージョンを指定します。
  # 形式: "X.Y" （例: "3.2", "4.0"）
  # 最小長: 3文字、最大長: 10文字
  # パターン: \d+\.\d+
  # 参考: https://docs.aws.amazon.com/controltower/latest/APIReference/API_LandingZoneDetail.html
  version = "3.2"

  # ============================================================================
  # オプション項目 (Optional)
  # ============================================================================

  # id - (オプション/Computed) ランディングゾーンの識別子
  # 通常は設定不要です。Terraformが自動的に生成します。
  # リソースのインポート時など特殊なケースでのみ使用します。
  # このフィールドは省略可能で、設定しない場合はAWSが自動的に割り当てます。
  # id = null

  # region - (オプション/Computed) このリソースが管理されるリージョン
  # デフォルトでは、プロバイダー設定で指定されたリージョンが使用されます。
  # 明示的にリージョンを指定する場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  # tags - (オプション) ランディングゾーンに適用するタグ
  # キーと値のペアで、リソースの分類や管理に使用します。
  # プロバイダーのdefault_tags設定ブロックと併用可能です。
  # マッチするキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all - (オプション/Computed) 全てのタグのマップ
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、全てのタグのマップ。
  # 通常は設定不要です。Terraformがtagsとdefault_tagsをマージして自動的に管理します。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags_all = {}

  # ============================================================================
  # タイムアウト設定 (Timeouts)
  # ============================================================================

  timeouts {
    # create - (オプション) ランディングゾーンの作成タイムアウト
    # デフォルト: 通常のタイムアウト値
    # 形式: "60m", "2h" など
    create = null

    # update - (オプション) ランディングゾーンの更新タイムアウト
    # デフォルト: 通常のタイムアウト値
    # 形式: "60m", "2h" など
    update = null

    # delete - (オプション) ランディングゾーンの削除タイムアウト
    # デフォルト: 通常のタイムアウト値
    # 形式: "60m", "2h" など
    delete = null
  }
}

# ============================================================================
# 出力例 (Computed Attributes)
# ============================================================================
# 以下の属性は読み取り専用で、リソース作成後に参照できます:
#
# - id                        : ランディングゾーンの識別子
# - arn                       : ランディングゾーンのARN (Amazon Resource Name)
# - drift_status              : ランディングゾーンのドリフトステータスサマリー
#   - drift_status[].status   : ドリフトのステータス
# - latest_available_version  : 利用可能な最新バージョン
# - tags_all                  : プロバイダーのdefault_tagsから継承されたタグを含む、全てのタグのマップ
#
# 使用例:
# output "landing_zone_arn" {
#   value = aws_controltower_landing_zone.example.arn
# }
# ============================================================================

# ============================================================================
# 重要な注意事項
# ============================================================================
# 1. AWS Control Towerのランディングゾーンを作成すると、管理アカウントに
#    マネージドリソースが作成されます。ランディングゾーンの整合性を保つため、
#    これらのリソースを変更または削除しないでください。
#
# 2. マニフェストファイルには、以下の主要な設定が含まれます:
#    - アクセス管理 (accessManagement)
#    - バックアップ設定 (backup)
#    - 集中ログ記録 (centralizedLogging)
#    - AWS Config統合 (config)
#    - 管理対象リージョン (governedRegions)
#    - セキュリティロール (securityRoles)
#
# 3. ランディングゾーンバージョン4.0へのアップグレードでは、
#    organizationStructure定義が削除され、各サービス統合設定を
#    明示的に有効/無効にする必要があります。
#
# 4. AWS Config統合を無効にする場合、関連する統合（セキュリティロール、
#    アクセス管理など）も無効にする必要があります。
#
# 参考リンク:
# - ランディングゾーンの仕組み: https://docs.aws.amazon.com/controltower/latest/userguide/how-control-tower-works.html
# - APIを使用したランディングゾーンの起動: https://docs.aws.amazon.com/controltower/latest/userguide/lz-api-launch.html
# - ランディングゾーンの設定: https://docs.aws.amazon.com/prescriptive-guidance/latest/designing-control-tower-landing-zone/setup.html
# ============================================================================
