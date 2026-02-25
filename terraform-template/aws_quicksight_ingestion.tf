#---------------------------------------------------------------
# AWS QuickSight Ingestion
#---------------------------------------------------------------
#
# Amazon QuickSightのSPICEデータセットに対してインジェスト（データ取り込み）を
# 開始するリソースです。フルリフレッシュまたは増分リフレッシュを実行し、
# SPICEに格納されたデータを最新の状態に更新します。
# インジェスト作成時にデータセットのタグを自動で引き継ぎます。
#
# AWS公式ドキュメント:
#   - CreateIngestion APIリファレンス: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateIngestion.html
#   - SPICEデータのリフレッシュ: https://docs.aws.amazon.com/quicksight/latest/user/refreshing-imported-data.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_ingestion
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_ingestion" "example" {
  #-------------------------------------------------------------
  # データセット設定
  #-------------------------------------------------------------

  # data_set_id (Required)
  # 設定内容: インジェスト対象のデータセットIDを指定します。
  # 設定可能な値: 文字列（QuickSightデータセットのID）
  data_set_id = "example-dataset-id"

  #-------------------------------------------------------------
  # インジェスト設定
  #-------------------------------------------------------------

  # ingestion_id (Required)
  # 設定内容: インジェストを識別するIDを指定します。
  # 設定可能な値: 1〜128文字の英数字、ハイフン、アンダースコアを含む文字列
  ingestion_id = "example-ingestion-id"

  # ingestion_type (Required)
  # 設定内容: 作成するインジェストの種類を指定します。
  # 設定可能な値:
  #   - "FULL_REFRESH": データセット全体を再取り込み（フルリフレッシュ）
  #   - "INCREMENTAL_REFRESH": 増分リフレッシュ。SQLベースのデータソース（Amazon Redshift、
  #     Amazon Athena、PostgreSQL、Snowflake等）で使用可能。
  #     指定ルックバックウィンドウ内の変更差分のみを取り込む。
  ingestion_type = "FULL_REFRESH"

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: QuickSightが属するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: インジェストのAmazon Resource Name (ARN)
#
# - id: AWSアカウントID、データセットID、インジェストIDをカンマ区切りで
#       結合した文字列
#
# - ingestion_status: インジェストの状態
#                     （INITIALIZED、QUEUED、RUNNING、FAILED、COMPLETED、CANCELLED）
#---------------------------------------------------------------
