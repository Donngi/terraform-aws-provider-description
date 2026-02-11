#---------------------------------------------------------------
# AWS AppSync Source API Association
#---------------------------------------------------------------
#
# AWS AppSyncのSource API Associationをプロビジョニングするリソースです。
# Source API AssociationはGraphQL API（Source API）をMerged APIにリンクする
# 設定で、複数のSource APIを1つのMerged APIに統合し、スキーマ・データソース・
# リゾルバーを組み合わせることができます。
#
# AWS公式ドキュメント:
#   - AppSync Merged APIs: https://docs.aws.amazon.com/appsync/latest/devguide/merged-api.html
#   - SourceApiAssociation API Reference: https://docs.aws.amazon.com/appsync/latest/APIReference/API_SourceApiAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_source_api_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appsync_source_api_association" "example" {
  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: マージされるSource APIの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = "My source API merged into the main merged API"

  #-------------------------------------------------------------
  # Merged API設定
  #-------------------------------------------------------------

  # merged_api_id (Optional)
  # 設定内容: Merged APIのIDを指定します。
  # 設定可能な値: AppSync GraphQL APIの有効なID
  # 注意: merged_api_arnまたはmerged_api_idのいずれか一方を指定する必要があります。
  merged_api_id = "gzos6bteufdunffzzifiowisoe"

  # merged_api_arn (Optional)
  # 設定内容: Merged APIのARNを指定します。
  # 設定可能な値: AppSync GraphQL APIの有効なARN
  # 注意: merged_api_arnまたはmerged_api_idのいずれか一方を指定する必要があります。
  merged_api_arn = null

  #-------------------------------------------------------------
  # Source API設定
  #-------------------------------------------------------------

  # source_api_id (Optional)
  # 設定内容: Source APIのIDを指定します。
  # 設定可能な値: AppSync GraphQL APIの有効なID
  # 注意: source_api_arnまたはsource_api_idのいずれか一方を指定する必要があります。
  source_api_id = "fzzifiowisoegzos6bteufdunf"

  # source_api_arn (Optional)
  # 設定内容: Source APIのARNを指定します。
  # 設定可能な値: AppSync GraphQL APIの有効なARN
  # 注意: source_api_arnまたはsource_api_idのいずれか一方を指定する必要があります。
  source_api_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Source API Association設定
  #-------------------------------------------------------------

  # source_api_association_config (Optional)
  # 設定内容: Source API Associationの設定を指定します。
  # マージタイプなど、Source APIとMerged APIの関連付けに関する設定を定義します。
  # 関連機能: AppSync Merged API
  #   複数のSource APIを1つのMerged APIに統合し、統一されたGraphQLエンドポイントを提供。
  #   - https://docs.aws.amazon.com/appsync/latest/devguide/merged-api.html
  source_api_association_config = [
    {
      # merge_type (Required within block)
      # 設定内容: Source API AssociationのマージタイプをSource API Association設定で指定します。
      # 設定可能な値:
      #   - "MANUAL_MERGE" (デフォルト): 手動マージ。Source APIの変更をMerged APIに手動で適用する必要があります。
      #   - "AUTO_MERGE": 自動マージ。Source APIの変更が自動的にMerged APIに反映されます。
      #                   MergedApiExecutionRoleArnを使用してマージ操作が実行されます。
      # 参考: https://docs.aws.amazon.com/appsync/latest/APIReference/API_SourceApiAssociationConfig.html
      merge_type = "MANUAL_MERGE"
    }
  ]

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト値を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト値を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト値を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "2h45m"）
    # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Source API AssociationのAmazon Resource Name (ARN)
#
# - association_id: Source API AssociationのID
#
# - id: Source API AssociationとMerged APIの複合ID
#---------------------------------------------------------------
