#---------------------------------------------------------------
# AWS S3 Storage Lens Configuration
#---------------------------------------------------------------
#
# Amazon S3 Storage Lensの設定をプロビジョニングするリソースです。
# S3 Storage Lensは、オブジェクトストレージの使用状況とアクティビティに関する
# 組織全体の可視性を提供するクラウドストレージ分析機能です。
# ストレージコストの最適化、データ保護のベストプラクティスの適用、
# アプリケーションパフォーマンスの向上のための推奨事項を提供します。
#
# AWS公式ドキュメント:
#   - S3 Storage Lens概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens.html
#   - S3 Storage Lensの理解: https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_basics_metrics_recommendations.html
#   - メトリクスの表示: https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_view_metrics.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_storage_lens_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_storage_lens_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # config_id (Required)
  # 設定内容: S3 Storage Lens設定のIDを指定します。
  # 設定可能な値: 1-64文字の文字列
  # 注意: 設定IDはダッシュボード名として表示されます。
  config_id = "example-storage-lens-config"

  # account_id (Optional)
  # 設定内容: S3 Storage Lens設定を作成するAWSアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: Terraform AWSプロバイダーで自動的に決定されるアカウントIDを使用
  account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: ホームリージョンとして指定されたリージョンに全てのメトリクスが保存されます。
  region = null

  #-------------------------------------------------------------
  # Storage Lens設定
  #-------------------------------------------------------------

  storage_lens_configuration {
    # enabled (Required)
    # 設定内容: S3 Storage Lensダッシュボードを有効化するかを指定します。
    # 設定可能な値:
    #   - true: ダッシュボードを有効化し、メトリクスの収集と表示を開始
    #   - false: ダッシュボードを無効化
    # 注意: 無効化してもhistoricデータは保持期間内アクセス可能です。
    enabled = true

    #-----------------------------------------------------------
    # アカウントレベル設定
    #-----------------------------------------------------------

    account_level {
      #---------------------------------------------------------
      # アカウントレベルのメトリクス設定
      #---------------------------------------------------------

      # activity_metrics (Optional)
      # 設定内容: アカウントレベルでのアクティビティメトリクスの有効化を指定します。
      # 関連機能: アクティビティメトリクス
      #   リクエストカウントや転送データ量などのアクティビティ情報を収集します。
      #   無料メトリクスに含まれる基本的なアクティビティメトリクスを提供します。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_basics_metrics_recommendations.html
      activity_metrics {
        # enabled (Optional)
        # 設定内容: アクティビティメトリクスを有効にするかを指定します。
        # 設定可能な値:
        #   - true: アクティビティメトリクスを有効化
        #   - false: アクティビティメトリクスを無効化
        # 省略時: false
        enabled = true
      }

      # advanced_cost_optimization_metrics (Optional)
      # 設定内容: 高度なコスト最適化メトリクスの有効化を指定します。
      # 関連機能: 高度なコスト最適化メトリクス（有料）
      #   ライフサイクルルール数など、より詳細なコスト最適化メトリクスを提供します。
      #   無料メトリクスより詳細な情報を含む高度な分析機能です。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-lens-use-cases.html
      # 注意: 高度なメトリクスには追加料金が発生します。
      advanced_cost_optimization_metrics {
        # enabled (Optional)
        # 設定内容: 高度なコスト最適化メトリクスを有効にするかを指定します。
        # 設定可能な値:
        #   - true: 高度なコスト最適化メトリクスを有効化
        #   - false: 高度なコスト最適化メトリクスを無効化
        # 省略時: false
        enabled = false
      }

      # advanced_data_protection_metrics (Optional)
      # 設定内容: 高度なデータ保護メトリクスの有効化を指定します。
      # 関連機能: 高度なデータ保護メトリクス（有料）
      #   レプリケーションルール数など、より詳細なデータ保護メトリクスを提供します。
      #   無料メトリクスより詳細なデータ保護関連の分析機能です。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-lens-use-cases.html
      # 注意: 高度なメトリクスには追加料金が発生します。
      advanced_data_protection_metrics {
        # enabled (Optional)
        # 設定内容: 高度なデータ保護メトリクスを有効にするかを指定します。
        # 設定可能な値:
        #   - true: 高度なデータ保護メトリクスを有効化
        #   - false: 高度なデータ保護メトリクスを無効化
        # 省略時: false
        enabled = false
      }

      # detailed_status_code_metrics (Optional)
      # 設定内容: 詳細なステータスコードメトリクスの有効化を指定します。
      # 関連機能: 詳細なステータスコードメトリクス（有料）
      #   HTTPステータスコード別の詳細なメトリクスを提供します。
      #   アクセス問題やパフォーマンス問題のトラブルシューティングに有用です。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-lens-use-cases.html
      # 注意: 高度なメトリクスには追加料金が発生します。
      detailed_status_code_metrics {
        # enabled (Optional)
        # 設定内容: 詳細なステータスコードメトリクスを有効にするかを指定します。
        # 設定可能な値:
        #   - true: 詳細なステータスコードメトリクスを有効化
        #   - false: 詳細なステータスコードメトリクスを無効化
        # 省略時: false
        enabled = false
      }

      #---------------------------------------------------------
      # バケットレベル設定
      #---------------------------------------------------------

      bucket_level {
        # activity_metrics (Optional)
        # 設定内容: バケットレベルでのアクティビティメトリクスの有効化を指定します。
        # 関連機能: バケットレベルアクティビティメトリクス
        #   バケット単位でのリクエストカウントや転送データ量などを収集します。
        #   無料メトリクスに含まれ、バケットレベルまで集計されます。
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_basics_metrics_recommendations.html
        activity_metrics {
          # enabled (Optional)
          # 設定内容: バケットレベルアクティビティメトリクスを有効にするかを指定します。
          # 設定可能な値:
          #   - true: バケットレベルアクティビティメトリクスを有効化
          #   - false: バケットレベルアクティビティメトリクスを無効化
          # 省略時: false
          enabled = true
        }

        # advanced_cost_optimization_metrics (Optional)
        # 設定内容: バケットレベルでの高度なコスト最適化メトリクスの有効化を指定します。
        # 関連機能: バケットレベル高度なコスト最適化メトリクス（有料）
        #   バケット単位での詳細なコスト最適化メトリクスを提供します。
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-lens-use-cases.html
        # 注意: 高度なメトリクスには追加料金が発生します。
        advanced_cost_optimization_metrics {
          # enabled (Optional)
          # 設定内容: バケットレベル高度なコスト最適化メトリクスを有効にするかを指定します。
          # 設定可能な値:
          #   - true: バケットレベル高度なコスト最適化メトリクスを有効化
          #   - false: バケットレベル高度なコスト最適化メトリクスを無効化
          # 省略時: false
          enabled = false
        }

        # advanced_data_protection_metrics (Optional)
        # 設定内容: バケットレベルでの高度なデータ保護メトリクスの有効化を指定します。
        # 関連機能: バケットレベル高度なデータ保護メトリクス（有料）
        #   バケット単位での詳細なデータ保護メトリクスを提供します。
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-lens-use-cases.html
        # 注意: 高度なメトリクスには追加料金が発生します。
        advanced_data_protection_metrics {
          # enabled (Optional)
          # 設定内容: バケットレベル高度なデータ保護メトリクスを有効にするかを指定します。
          # 設定可能な値:
          #   - true: バケットレベル高度なデータ保護メトリクスを有効化
          #   - false: バケットレベル高度なデータ保護メトリクスを無効化
          # 省略時: false
          enabled = false
        }

        # detailed_status_code_metrics (Optional)
        # 設定内容: バケットレベルでの詳細なステータスコードメトリクスの有効化を指定します。
        # 関連機能: バケットレベル詳細なステータスコードメトリクス（有料）
        #   バケット単位でのHTTPステータスコード別の詳細なメトリクスを提供します。
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-lens-use-cases.html
        # 注意: 高度なメトリクスには追加料金が発生します。
        detailed_status_code_metrics {
          # enabled (Optional)
          # 設定内容: バケットレベル詳細なステータスコードメトリクスを有効にするかを指定します。
          # 設定可能な値:
          #   - true: バケットレベル詳細なステータスコードメトリクスを有効化
          #   - false: バケットレベル詳細なステータスコードメトリクスを無効化
          # 省略時: false
          enabled = false
        }

        #-------------------------------------------------------
        # プレフィックスレベル設定
        #-------------------------------------------------------

        # prefix_level (Optional)
        # 設定内容: プレフィックスレベルのメトリクス収集設定を指定します。
        # 関連機能: プレフィックス集計（有料）
        #   バケット内のプレフィックス（フォルダ構造）レベルでのメトリクスを収集します。
        #   高度なメトリクス機能の一部として提供されます。
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens.html
        # 注意: プレフィックス集計機能には追加料金が発生します。
        prefix_level {
          storage_metrics {
            # enabled (Optional)
            # 設定内容: プレフィックスレベルのストレージメトリクスを有効にするかを指定します。
            # 設定可能な値:
            #   - true: プレフィックスレベルのストレージメトリクスを有効化
            #   - false: プレフィックスレベルのストレージメトリクスを無効化
            # 省略時: false
            enabled = true

            # selection_criteria (Optional)
            # 設定内容: プレフィックスメトリクスの選択基準を指定します。
            # 関連機能: プレフィックス選択基準
            #   メトリクス収集対象のプレフィックスをフィルタリングする条件を設定します。
            #   delimiter、max_depth、min_storage_bytes_percentageで制御できます。
            #   - https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_SelectionCriteria.html
            selection_criteria {
              # delimiter (Optional)
              # 設定内容: オブジェクトキー内の階層レベルを区切る文字を指定します。
              # 設定可能な値: 1文字の文字列（通常は"/"）
              # 省略時: デフォルトのdelimiter設定を使用
              # 注意: S3 Storage Lensはこのdelimiterを使用してプレフィックスの深さを
              #       カウントし、階層レベルを分離します。
              delimiter = "/"

              # max_depth (Optional)
              # 設定内容: メトリクス収集対象とするプレフィックスの最大深さを指定します。
              # 設定可能な値: 1-10の整数
              # 省略時: プレフィックスの深さ制限なし
              # 例: max_depth=2の場合、"folder1/folder2/"までのプレフィックスが対象
              max_depth = 5

              # min_storage_bytes_percentage (Optional)
              # 設定内容: メトリクス収集対象とするプレフィックスの最小ストレージバイト数の
              #           パーセンテージを指定します。
              # 設定可能な値: 0.1-100の数値（1.0以上を推奨）
              # 省略時: ストレージサイズによるフィルタリングなし
              # 注意: バケット全体のストレージに対する割合で指定します。
              #       このパーセンテージ以上のストレージを占めるプレフィックスが対象になります。
              min_storage_bytes_percentage = 1.0
            }
          }
        }
      }
    }

    #-----------------------------------------------------------
    # AWS Organizations設定
    #-----------------------------------------------------------

    # aws_org (Optional)
    # 設定内容: AWS Organizations統合時の組織設定を指定します。
    # 関連機能: S3 Storage LensとAWS Organizations
    #   組織全体のストレージメトリクスとユーザーデータを収集する設定を行います。
    #   管理アカウントまたは委任された管理者アカウントで設定する必要があります。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_with_organizations.html
    # 注意: この設定を使用するには、事前にS3 Storage Lensの信頼されたアクセスを有効化する必要があります。
    # aws_org {
    #   # arn (Required)
    #   # 設定内容: AWS OrganizationのARNを指定します。
    #   # 設定可能な値: 有効なAWS Organization ARN
    #   # 形式: arn:aws:organizations::{account-id}:organization/o-{organization-id}
    #   arn = "arn:aws:organizations::123456789012:organization/o-example123"
    # }

    #-----------------------------------------------------------
    # データエクスポート設定
    #-----------------------------------------------------------

    # data_export (Optional)
    # 設定内容: S3 Storage Lensメトリクスのエクスポート設定を指定します。
    # 関連機能: メトリクスエクスポート
    #   メトリクスデータをS3バケットやCloudWatchにエクスポートする設定です。
    #   日次のメトリクスレポート生成やCloudWatch監視に使用できます。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_view_metrics_export.html
    data_export {
      # cloud_watch_metrics (Optional)
      # 設定内容: CloudWatchへのメトリクス送信設定を指定します。
      # 関連機能: CloudWatch統合
      #   S3 Storage LensメトリクスをAmazon CloudWatchに送信します。
      #   CloudWatchアラームの設定やダッシュボードでの監視が可能になります。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_StorageLensDataExport.html
      # 注意: CloudWatch送信には追加料金が発生します。
      cloud_watch_metrics {
        # enabled (Required)
        # 設定内容: CloudWatchメトリクス送信を有効にするかを指定します。
        # 設定可能な値:
        #   - true: CloudWatchへのメトリクス送信を有効化
        #   - false: CloudWatchへのメトリクス送信を無効化
        enabled = false
      }

      # s3_bucket_destination (Optional)
      # 設定内容: メトリクスエクスポートファイルの出力先S3バケット設定を指定します。
      # 関連機能: S3バケットへのエクスポート
      #   日次のメトリクスレポートをS3バケットに保存します。
      #   CSV形式またはParquet形式で出力でき、Amazon QuickSightやAmazon Athenaで分析可能です。
      #   - https://docs.aws.amazon.com/AmazonS3/latest/API/API_control_S3BucketDestination.html
      # 注意: 出力先バケットはStorage Lens設定と同じリージョンである必要があります。
      s3_bucket_destination {
        # account_id (Required)
        # 設定内容: 出力先バケットを所有するAWSアカウントIDを指定します。
        # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
        account_id = "123456789012"

        # arn (Required)
        # 設定内容: 出力先S3バケットのARNを指定します。
        # 設定可能な値: 有効なS3バケットARN
        # 形式: arn:aws:s3:::bucket-name
        arn = "arn:aws:s3:::my-storage-lens-exports"

        # format (Required)
        # 設定内容: エクスポートファイルのフォーマットを指定します。
        # 設定可能な値:
        #   - "CSV": カンマ区切り形式。人間が読みやすい形式
        #   - "Parquet": 列指向フォーマット。分析クエリのパフォーマンスに優れる
        format = "CSV"

        # output_schema_version (Required)
        # 設定内容: 出力スキーマのバージョンを指定します。
        # 設定可能な値: "V_1"（現在利用可能なバージョン）
        # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_whatis_metrics_export_manifest.html
        output_schema_version = "V_1"

        # prefix (Optional)
        # 設定内容: 出力先バケット内のプレフィックス（パス）を指定します。
        # 設定可能な値: 任意の文字列
        # 省略時: バケットのルートに出力
        # 例: "storage-lens-reports/"
        prefix = "storage-lens-exports/"

        #-------------------------------------------------------
        # 暗号化設定
        #-------------------------------------------------------

        # encryption (Optional)
        # 設定内容: エクスポートファイルの暗号化設定を指定します。
        # 関連機能: メトリクスエクスポートの暗号化
        #   エクスポートされるメトリクスファイルを暗号化します。
        #   SSE-S3またはSSE-KMSを使用できます。
        #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_view_metrics_export.html
        encryption {
          # sse_s3 (Optional)
          # 設定内容: S3マネージド暗号化キー（SSE-S3）を使用した暗号化を指定します。
          # 関連機能: SSE-S3暗号化
          #   AWSが管理する暗号化キーを使用してデータを暗号化します。
          #   追加設定不要で、追加コストもかかりません。
          #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingServerSideEncryption.html
          # 注意: sse_kmsと排他的（どちらか一方のみ指定可能）
          sse_s3 {}

          # sse_kms (Optional)
          # 設定内容: KMSカスタマー管理キー（SSE-KMS）を使用した暗号化を指定します。
          # 関連機能: SSE-KMS暗号化
          #   AWS KMSのカスタマー管理キーを使用してデータを暗号化します。
          #   キーのローテーションや詳細なアクセス制御が可能です。
          #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html
          # 注意: sse_s3と排他的（どちらか一方のみ指定可能）
          # sse_kms {
          #   # key_id (Required)
          #   # 設定内容: 使用するKMSキーのARNを指定します。
          #   # 設定可能な値: 有効なKMSキーARN
          #   # 形式: arn:aws:kms:region:account-id:key/key-id
          #   key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
          # }
        }
      }
    }

    #-----------------------------------------------------------
    # スコープ設定（除外）
    #-----------------------------------------------------------

    # exclude (Optional)
    # 設定内容: Storage Lens設定から除外するバケットやリージョンを指定します。
    # 関連機能: ダッシュボードスコープ設定
    #   特定のバケットやリージョンをメトリクス収集対象から除外します。
    #   includeと排他的で、どちらか一方のみ指定可能です。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_editing.html
    # 注意: excludeを指定する場合、includeは指定できません（空でない場合）
    # exclude {
    #   # buckets (Optional)
    #   # 設定内容: 除外するS3バケットのARNのセットを指定します。
    #   # 設定可能な値: S3バケットARNのセット
    #   # 形式: arn:aws:s3:::bucket-name
    #   buckets = [
    #     "arn:aws:s3:::excluded-bucket-1",
    #     "arn:aws:s3:::excluded-bucket-2"
    #   ]

    #   # regions (Optional)
    #   # 設定内容: 除外するAWSリージョンのセットを指定します。
    #   # 設定可能な値: 有効なAWSリージョンコードのセット
    #   # 例: ["ap-northeast-1", "us-east-1"]
    #   regions = [
    #     "us-west-1",
    #     "us-west-2"
    #   ]
    # }

    #-----------------------------------------------------------
    # スコープ設定（包含）
    #-----------------------------------------------------------

    # include (Optional)
    # 設定内容: Storage Lens設定に含めるバケットやリージョンを指定します。
    # 関連機能: ダッシュボードスコープ設定
    #   特定のバケットやリージョンのみをメトリクス収集対象とします。
    #   excludeと排他的で、どちらか一方のみ指定可能です。
    #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage_lens_editing.html
    # 注意: includeを指定する場合、excludeは指定できません（空でない場合）
    # include {
    #   # buckets (Optional)
    #   # 設定内容: 含めるS3バケットのARNのセットを指定します。
    #   # 設定可能な値: S3バケットARNのセット
    #   # 形式: arn:aws:s3:::bucket-name
    #   buckets = [
    #     "arn:aws:s3:::included-bucket-1",
    #     "arn:aws:s3:::included-bucket-2"
    #   ]

    #   # regions (Optional)
    #   # 設定内容: 含めるAWSリージョンのセットを指定します。
    #   # 設定可能な値: 有効なAWSリージョンコードのセット
    #   # 例: ["ap-northeast-1", "us-east-1"]
    #   regions = [
    #     "ap-northeast-1",
    #     "ap-northeast-3"
    #   ]
    # }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-storage-lens"
    Environment = "production"
    Purpose     = "storage-analytics"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: S3 Storage Lens設定のAmazon Resource Name (ARN)
#
# - id: S3 Storage Lens設定のID（account_id:config_id形式）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
