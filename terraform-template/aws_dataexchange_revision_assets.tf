#================================================================================
# AWS Data Exchange Revision Assets
#================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の情報に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_revision_assets
#================================================================================

#================================================================================
# リソース概要
#================================================================================
# AWS Data Exchange Revision Assetsリソースは、Data Exchangeのデータセットに
# 新しいリビジョンを作成し、関連するアセットを追加します。
#
# 注意: このリソースを削除すると、リビジョンとすべての関連アセットが削除されます。
#
# AWS Data Exchangeのデータ構造:
# - Assets: データそのもの（S3オブジェクト、API、Redshiftデータセットなど）
# - Revisions: 1つ以上のアセットを含むコンテナ
# - Data Sets: 時系列で変化する1つ以上のリビジョンのコレクション
#
# 公式ドキュメント:
# - https://docs.aws.amazon.com/data-exchange/latest/userguide/data-sets.html
# - https://docs.aws.amazon.com/data-exchange/latest/apireference/welcome.html
#================================================================================

resource "aws_dataexchange_revision_assets" "example" {
  #==============================================================================
  # 必須パラメータ
  #==============================================================================

  # data_set_id - (Required) データセットの一意の識別子
  # リビジョンが関連付けられるData Exchangeデータセットを指定します。
  # データセットIDは、AWS Data Exchange コンソールまたはAPIから取得できます。
  # 型: string
  data_set_id = "example-data-set-id"

  #==============================================================================
  # オプションパラメータ
  #==============================================================================

  # comment - (Optional) リビジョンに対するコメント
  # リビジョンの変更内容や目的を記述するために使用します。
  # 最大長: 16,348文字
  # 型: string
  # デフォルト: null
  comment = "Initial revision with sample data"

  # finalized - (Optional) リビジョンを最終化するかどうか
  # trueに設定すると、リビジョンがサブスクライバーに対して即座に利用可能になります。
  # 最終化されたリビジョンは変更や非最終化ができなくなります。
  # 最終化するには、少なくとも1つのアセットが含まれている必要があります。
  # 型: bool
  # デフォルト: false
  finalized = false

  # force_destroy - (Optional) 強制削除を有効にするかどうか
  # trueに設定すると、リビジョンとすべての関連アセットを強制的に削除できます。
  # 型: bool
  # デフォルト: false
  force_destroy = false

  # region - (Optional) リソースを管理するAWSリージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # tags - (Optional) リソースに割り当てるタグのマップ
  # リソースの分類、管理、コスト配分などに使用されます。
  # プロバイダーのdefault_tags設定がある場合、同じキーのタグは上書きされます。
  # 型: map(string)
  # デフォルト: {}
  tags = {
    Environment = "Production"
    Project     = "DataExchange"
  }

  #==============================================================================
  # asset ブロック - (Required) リビジョンに関連付けるアセット
  #==============================================================================
  # アセットタイプは以下のいずれか1つを指定する必要があります:
  # - create_s3_data_access_from_s3_bucket: S3バケットからS3データアクセスを作成
  # - import_assets_from_s3: S3からアセットをインポート
  # - import_assets_from_signed_url: 署名付きURLからアセットをインポート

  #------------------------------------------------------------------------------
  # パターン1: S3バケットからS3データアクセスを作成
  #------------------------------------------------------------------------------
  # サブスクライバーがプロバイダーのS3バケット内のデータに直接アクセスできるようにします。
  # データのコピーを作成・管理する必要がありません。
  asset {
    create_s3_data_access_from_s3_bucket {
      asset_source {
        # bucket - (Required) S3バケット名
        # データソースとなるS3バケットの名前を指定します。
        # 型: string
        bucket = "example-bucket"

        # keys - (Optional) S3バケット内のオブジェクトキーのリスト
        # 特定のS3オブジェクトを指定してアクセスを制限します。
        # key_prefixesと併用可能です。
        # 型: set(string)
        # デフォルト: null
        keys = ["data/file1.csv", "data/file2.csv"]

        # key_prefixes - (Optional) S3バケット内のキープレフィックスのリスト
        # 特定のプレフィックスでアクセスを制限します（例: "data/"）。
        # keysと併用可能です。
        # 型: set(string)
        # デフォルト: null
        key_prefixes = ["data/", "reports/"]

        # kms_keys_to_grant - (Optional) アクセス権を付与するKMSキー
        # S3オブジェクトが暗号化されている場合、サブスクライバーがデータにアクセス
        # できるようにKMSキーへのアクセス権を付与します。
        kms_keys_to_grant {
          # kms_key_arn - (Required) KMSキーのARN
          # アクセス権を付与するKMSキーのARNを指定します。
          # 型: string
          kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
        }
      }

      # 以下は computed 属性（読み取り専用）
      # access_point_alias - アクセスポイントのエイリアス（自動生成）
      # access_point_arn - アクセスポイントのARN（自動生成）
    }
  }

  #------------------------------------------------------------------------------
  # パターン2: S3からアセットをインポート
  #------------------------------------------------------------------------------
  # S3バケット内の特定のオブジェクトをData Exchangeアセットとしてインポートします。
  # データのスナップショットが作成され、サブスクライバーはコピーをエクスポートできます。
  # asset {
  #   import_assets_from_s3 {
  #     asset_source {
  #       # bucket - (Required) S3バケット名
  #       # インポート元のS3バケットの名前を指定します。
  #       # 型: string
  #       bucket = "example-source-bucket"
  #
  #       # key - (Required) S3オブジェクトキー
  #       # インポートするS3オブジェクトのキーを指定します。
  #       # 型: string
  #       key = "data/dataset.csv"
  #     }
  #   }
  # }

  #------------------------------------------------------------------------------
  # パターン3: 署名付きURLからアセットをインポート
  #------------------------------------------------------------------------------
  # AWS Data Exchangeが生成した署名付きURLを使用してアセットをアップロードします。
  # コンソールやAPIを通じてファイルを直接アップロードする際に使用されます。
  # asset {
  #   import_assets_from_signed_url {
  #     # filename - (Required) インポートするファイル名
  #     # アップロードされるファイルの名前を指定します。
  #     # 型: string
  #     filename = "dataset.csv"
  #   }
  #
  #   # 以下は computed 属性（読み取り専用）
  #   # arn - アセットのARN（自動生成）
  #   # created_at - アセットの作成日時（自動生成）
  #   # id - アセットの一意な識別子（自動生成）
  #   # name - アセット名（自動生成）
  #   # updated_at - アセットの最終更新日時（自動生成）
  # }

  #==============================================================================
  # timeouts ブロック - (Optional) タイムアウト設定
  #==============================================================================
  # リソース操作のタイムアウトを設定します。
  timeouts {
    # create - (Optional) 作成操作のタイムアウト
    # リソース作成時の最大待機時間を指定します。
    # 形式: "30s", "2h45m" など（s=秒, m=分, h=時間）
    # 型: string
    # デフォルト: デフォルトのタイムアウト値
    create = "30m"
  }
}

#================================================================================
# 出力例（Computed Attributes）
#================================================================================
# 以下の属性はリソース作成後に参照可能になります:
#
# - arn: Data Exchange Revision Assetsのリソース ARN
#   形式: arn:aws:dataexchange:{region}:{account-id}:data-sets/{data-set-id}/revisions/{revision-id}
#
# - id: リビジョンの一意な識別子
#
# - created_at: リビジョンの作成日時（RFC3339形式）
#
# - updated_at: リビジョンの最終更新日時（RFC3339形式）
#
# - tags_all: リソースに割り当てられたすべてのタグ
#   プロバイダーのdefault_tags設定から継承されたタグを含みます
#
# 使用例:
# output "revision_arn" {
#   value = aws_dataexchange_revision_assets.example.arn
# }
#
# output "revision_id" {
#   value = aws_dataexchange_revision_assets.example.id
# }
#================================================================================

#================================================================================
# 使用上の注意事項
#================================================================================
# 1. リビジョンの最終化:
#    - finalizedをtrueに設定する前に、すべてのアセットが正しいことを確認してください
#    - 最終化後は、リビジョンの変更や非最終化はできません
#    - 最終化されたリビジョンは、サブスクライバーに即座に利用可能になります
#
# 2. アセットタイプの選択:
#    - S3データアクセス: サブスクライバーがプロバイダーのS3バケットに直接アクセス
#    - S3インポート: データのスナップショットを作成し、サブスクライバーがコピーを取得
#    - 署名付きURL: コンソールやAPIを通じた直接アップロード
#
# 3. KMS暗号化:
#    - S3オブジェクトがKMSで暗号化されている場合、kms_keys_to_grantでアクセス権を付与
#    - サブスクライバーがデータにアクセスするために必要です
#
# 4. リソースの削除:
#    - このリソースを削除すると、リビジョンとすべての関連アセットが削除されます
#    - force_destroy = trueを設定すると、強制削除が可能になります
#
# 5. タグの継承:
#    - プロバイダーレベルのdefault_tagsは自動的に適用されます
#    - リソースレベルのtagsは、default_tagsの同じキーを上書きします
#
# 6. リージョン設定:
#    - データセット内のすべてのリビジョンは同じリージョンに存在する必要があります
#    - 単一のデータグラントまたは製品内のすべてのデータセットは同じリージョンである必要があります
#================================================================================

#================================================================================
# 参考リンク
#================================================================================
# - Terraform AWS Provider - aws_dataexchange_revision_assets:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dataexchange_revision_assets
#
# - AWS Data Exchange ユーザーガイド - データセット:
#   https://docs.aws.amazon.com/data-exchange/latest/userguide/data-sets.html
#
# - AWS Data Exchange API リファレンス:
#   https://docs.aws.amazon.com/data-exchange/latest/apireference/welcome.html
#
# - AWS Data Exchange API - ListRevisionAssets:
#   https://docs.aws.amazon.com/data-exchange/latest/apireference/API_ListRevisionAssets.html
#
# - AWS リージョナルエンドポイント:
#   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
#================================================================================
