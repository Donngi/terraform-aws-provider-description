# =====================================================================================================================
# AWS Data Exchange Event Action - Annotated Template
# =====================================================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_event_action
# =====================================================================================================================

# AWS Data Exchange Event Action は、データセットに新しいリビジョンが公開されたときに
# 自動的にアクションを実行するためのリソースです。主な用途は、新しいリビジョンを
# 自動的にS3バケットにエクスポートすることです。
#
# AWS公式ドキュメント:
# - Event Actions概要: https://docs.aws.amazon.com/data-exchange/latest/userguide/auto-export-rev-s3-console-sub.html
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_event_action

resource "aws_dataexchange_event_action" "example" {

  # =====================================================================================================================
  # Optional Attributes
  # =====================================================================================================================

  # region - (Optional) リソースを管理するAWSリージョン
  # デフォルトではプロバイダー設定で指定されたリージョンが使用されます。
  # 異なるリージョンでこのリソースを管理する場合にのみ指定してください。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # Default: Provider configuration region
  region = "us-east-1"

  # =====================================================================================================================
  # Required Blocks - event
  # =====================================================================================================================
  # イベントトリガーの設定
  # データセットに新しいリビジョンが公開されたときに実行するイベントを定義します。

  event {
    # revision_published - (Required) リビジョン公開イベントの設定
    # 指定したデータセットに新しいリビジョンが公開されたときにアクションをトリガーします。
    revision_published {
      # data_set_id - (Required) 監視対象のデータセットID
      # このデータセットに新しいリビジョンが公開されたときにイベントがトリガーされます。
      # 注意: この値を変更すると、リソースが再作成されます。
      # Type: string
      data_set_id = "example-dataset-id"
    }
  }

  # =====================================================================================================================
  # Required Blocks - action
  # =====================================================================================================================
  # イベント発生時に実行するアクションの設定

  action {
    # export_revision_to_s3 - (Required) S3へのリビジョンエクスポート設定
    # 新しいリビジョンを自動的にS3バケットにエクスポートする設定を定義します。
    # 最大5つのS3バケットへの自動エクスポートが可能です。
    export_revision_to_s3 {

      # revision_destination - (Required) エクスポート先S3バケットの設定
      # リビジョンがエクスポートされるS3バケットの詳細を指定します。
      revision_destination {
        # bucket - (Required) エクスポート先のS3バケット名
        # リビジョンがエクスポートされるS3バケットを指定します。
        # 注意: バケットには適切なバケットポリシーが必要です（dataexchange.amazonaws.comからの
        #       s3:PutObject および s3:PutObjectAcl アクションを許可）
        # Type: string
        bucket = "example-bucket-name"

        # key_pattern - (Optional) S3オブジェクトキーのパターン
        # エクスポートされるリビジョンの命名パターンを定義します。
        # 使用可能な変数:
        #   - ${Revision.CreatedAt} - リビジョンの作成日時
        #   - ${Asset.Name} - アセット名
        #   - ${Revision.Id} - リビジョンID
        # デフォルト値: "${Revision.CreatedAt}/${Asset.Name}"
        # 参考: https://docs.aws.amazon.com/data-exchange/latest/userguide/revision-export-keypatterns.html
        # Type: string
        # Default: "${Revision.CreatedAt}/${Asset.Name}"
        key_pattern = "${Revision.CreatedAt}/${Asset.Name}"
      }

      # encryption - (Optional) エクスポートされるリビジョンのサーバーサイド暗号化設定
      # S3バケットにエクスポートされるオブジェクトの暗号化方法を指定します。
      encryption {
        # type - (Optional) サーバーサイド暗号化のタイプ
        # 有効な値:
        #   - "aws:kms" - AWS KMS管理キーを使用した暗号化
        #   - "aws:s3"  - S3管理キー(SSE-S3)を使用した暗号化
        # Type: string
        # Valid values: "aws:kms", "aws:s3"
        type = "aws:kms"

        # kms_key_arn - (Optional) 暗号化に使用するKMSキーのARN
        # type = "aws:kms" の場合に使用されます。
        # 注意: 自動エクスポートジョブを設定するユーザーは、KMSキーに対する
        #       CreateGrant 権限が必要です。
        # Type: string
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      }
    }
  }
}

# =====================================================================================================================
# Computed Attributes (読み取り専用 - 出力のみ)
# =====================================================================================================================
# 以下の属性は AWS によって自動的に設定され、Terraform の outputs で参照できます:
#
# - arn         : Event ActionのAmazon Resource Name (ARN)
# - id          : Event Actionの一意の識別子
# - created_at  : リソースが作成された日時（ISO 8601形式）
# - updated_at  : リソースが最後に更新された日時（ISO 8601形式）

# =====================================================================================================================
# 使用例 - 出力値の参照
# =====================================================================================================================
output "event_action_arn" {
  description = "Event ActionのARN"
  value       = aws_dataexchange_event_action.example.arn
}

output "event_action_id" {
  description = "Event ActionのID"
  value       = aws_dataexchange_event_action.example.id
}

# =====================================================================================================================
# 前提条件とベストプラクティス
# =====================================================================================================================
#
# 1. S3バケットポリシー:
#    エクスポート先のS3バケットには、以下のポリシーが必要です:
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "dataexchange.amazonaws.com"
#      },
#      "Action": [
#        "s3:PutObject",
#        "s3:PutObjectAcl"
#      ],
#      "Resource": "arn:aws:s3:::<BUCKET-NAME>/*",
#      "Condition": {
#        "StringEquals": {
#          "aws:SourceAccount": "<AWS-ACCOUNT-ID>"
#        }
#      }
#    }
#
# 2. KMS暗号化を使用する場合:
#    - S3バケットがSSE-KMS暗号化を使用している場合、自動エクスポートジョブを
#      設定するユーザーはKMSキーに対するCreateGrant権限が必要です
#
# 3. テストオブジェクト:
#    - 前提条件が満たされているか確認するため、自動エクスポート設定時に
#      "_ADX-TEST-ACCOUNTID#" という名前のテストオブジェクトがS3バケットに追加されます
#
# 4. エクスポート制限:
#    - 1つのデータセットにつき、最大5つのS3バケットへの自動エクスポートが可能です
#
# 5. リージョン考慮事項:
#    - Data Exchangeは特定のリージョンでのみ利用可能です
#    - S3バケットとData Exchangeリソースは同じリージョンである必要はありません
