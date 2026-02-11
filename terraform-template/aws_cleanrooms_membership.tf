#---------------------------------------------------------------
# AWS Clean Rooms Membership
#---------------------------------------------------------------
#
# AWS Clean Roomsのメンバーシップをプロビジョニングするリソースです。
# メンバーシップは、招待されたメンバーがClean Roomsコラボレーションに
# 参加するために使用されます。コラボレーションに参加することで、
# メンバーは安全な環境でデータ分析とクエリの実行が可能になります。
#
# AWS公式ドキュメント:
#   - AWS Clean Rooms概要: https://docs.aws.amazon.com/clean-rooms/latest/userguide/what-is.html
#   - Membership API: https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_Membership.html
#   - クエリログの受信: https://docs.aws.amazon.com/clean-rooms/latest/userguide/receiving-query-logs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cleanrooms_membership
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cleanrooms_membership" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # collaboration_id (Required, Forces new resource)
  # 設定内容: メンバーが招待されたコラボレーションのIDを指定します。
  # 設定可能な値: UUID形式の36文字の文字列（例: "1234abcd-12ab-34cd-56ef-1234567890ab"）
  # パターン: [0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
  # 注意: この属性を変更すると、リソースが再作成されます。
  collaboration_id = "1234abcd-12ab-34cd-56ef-1234567890ab"

  # query_log_status (Required)
  # 設定内容: メンバーシップに対してクエリログが有効化または無効化されているかを示します。
  # 設定可能な値:
  #   - "ENABLED": クエリログを有効化。AWS Clean Roomsはこのコラボレーション内で実行された
  #                クエリの詳細をログに記録し、Amazon CloudWatch Logsで確認できます。
  #   - "DISABLED": クエリログを無効化（デフォルト値）
  # 関連機能: AWS Clean Rooms クエリログ機能
  #   コラボレーションメンバーがクエリを実行すると、各メンバーシップの作成後に
  #   自動的にログループが作成されます。クエリを実行できるメンバー、結果を受け取れるメンバー、
  #   および設定テーブルが参照されたメンバーがログを受信します。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/userguide/receiving-query-logs.html
  query_log_status = "DISABLED"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: メンバーシップに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの整理、コスト配分、アクセス制御などに使用
  tags = {
    Project     = "DataCollaboration"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # デフォルト結果設定
  #-------------------------------------------------------------

  # default_result_configuration (Optional)
  # 設定内容: 結果を受け取ることができるメンバーによって指定される、
  #          デフォルトの保護されたクエリ結果の設定を定義します。
  # 関連機能: AWS Clean Rooms 結果設定
  #   クエリ結果の出力先やフォーマットを制御します。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_MembershipProtectedQueryResultConfiguration.html
  default_result_configuration {
    # role_arn (Optional)
    # 設定内容: AWS Clean Roomsが保護されたクエリ結果を結果の場所に書き込むために
    #          使用するIAMロールのARNを指定します。
    # 設定可能な値: IAMロールのARN
    # 長さ制限: 最小32文字、最大512文字
    # パターン: arn:aws:[\w]+:[\w]{2}-[\w]{4,9}-[\d]:[\d]{12}:.*
    role_arn = "arn:aws:iam::123456789012:role/cleanrooms-results-role"

    # output_configuration (Required for default_result_configuration)
    # 設定内容: 保護されたクエリ結果の出力先設定を定義します。
    output_configuration {
      # s3 (Required for output_configuration)
      # 設定内容: S3への出力設定を定義します。
      s3 {
        # bucket (Required)
        # 設定内容: クエリ結果を保存するS3バケット名を指定します。
        # 設定可能な値: 有効なS3バケット名
        bucket = "cleanrooms-query-results"

        # result_format (Required)
        # 設定内容: クエリ結果のフォーマットを指定します。
        # 設定可能な値:
        #   - "PARQUET": Apache Parquet形式（列指向データフォーマット）
        #   - "CSV": カンマ区切り値形式
        result_format = "PARQUET"

        # key_prefix (Optional)
        # 設定内容: クエリ結果のS3キープレフィックスを指定します。
        # 設定可能な値: 任意の文字列（S3オブジェクトキーのプレフィックスとして使用）
        # 用途: 結果を整理したり、特定のフォルダ構造を作成する際に使用
        key_prefix = "results/"
      }
    }
  }

  #-------------------------------------------------------------
  # 支払い設定
  #-------------------------------------------------------------

  # payment_configuration (Optional)
  # 設定内容: コラボレーションメンバーが受け入れた支払い責任を定義します。
  # 関連機能: AWS Clean Rooms 支払い設定
  #   クエリ計算、ジョブ計算、機械学習のコストに対する支払い責任を設定します。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_MembershipPaymentConfiguration.html
  payment_configuration {
    # query_compute (Required for payment_configuration)
    # 設定内容: クエリ計算コストに対する支払い責任を定義します。
    # 関連機能: クエリ計算コストの支払い責任
    #   コラボレーション作成者がクエリ計算コストの支払い者を指定していない場合、
    #   クエリを実行できるメンバーがデフォルトの支払い者になります。
    #   - https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_MembershipQueryComputePaymentConfig.html
    query_compute {
      # is_responsible (Required)
      # 設定内容: メンバーがクエリ計算コストの支払いに同意したかを示します。
      # 設定可能な値:
      #   - true: メンバーがクエリ計算コストの支払いに同意
      #   - false: メンバーがクエリ計算コストの支払いに同意していない
      # 注意: メンバーが支払い責任者であるにもかかわらずfalseを設定した場合、または
      #      支払い責任者でないにもかかわらずtrueを設定した場合、エラーが返されます。
      is_responsible = false
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: メンバーシップのAmazon Resource Name (ARN)
#
# - collaboration_arn: 参加したコラボレーションのARN
#
# - collaboration_creator_account_id: コラボレーション作成者のアカウントID
#
# - collaboration_creator_display_name: コラボレーション作成者の表示名
#
# - collaboration_name: 参加したコラボレーションの名前
#
# - create_time: メンバーシップが作成された日時
#
# - id: メンバーシップのID
#
# - member_abilities: 招待されたメンバーに付与された能力のリスト
#   有効な値: CAN_QUERY, CAN_RECEIVE_RESULTS, CAN_RUN_JOB
#
# - status: メンバーシップのステータス
#   有効な値: ACTIVE, REMOVED, COLLABORATION_DELETED
#
#---------------------------------------------------------------
