#---------------------------------------------------------------
# AWS Clean Rooms Collaboration
#---------------------------------------------------------------
#
# AWS Clean Roomsのコラボレーションをプロビジョニングするリソースです。
# コラボレーションは、複数の組織がデータを共有せずに安全にデータ分析を
# 行うためのセキュアなワークスペースを提供します。コラボレーション作成者は
# 他のメンバーを招待し、プライバシーを保護しながら共同でデータ分析を実行できます。
#
# AWS公式ドキュメント:
#   - AWS Clean Rooms概要: https://docs.aws.amazon.com/clean-rooms/latest/userguide/what-is.html
#   - CreateCollaboration API: https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_CreateCollaboration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cleanrooms_collaboration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cleanrooms_collaboration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コラボレーションの名前を指定します。
  # 設定可能な値: 1-100文字の文字列
  # 注意: コラボレーション名は一意である必要はありません。
  name = "terraform-example-collaboration"

  # description (Required)
  # 設定内容: コラボレーションの説明を指定します。
  # 設定可能な値: 1-255文字の文字列
  description = "This collaboration is created with Terraform for data analysis"

  #-------------------------------------------------------------
  # コラボレーション作成者設定
  #-------------------------------------------------------------

  # creator_display_name (Required, Forces new resource)
  # 設定内容: コラボレーション作成者のメンバーレコード名を指定します。
  # 設定可能な値: 1-100文字の文字列
  creator_display_name = "Creator Organization"

  # creator_member_abilities (Required, Forces new resource)
  # 設定内容: コラボレーション作成者に付与する権限のリストを指定します。
  # 設定可能な値:
  #   - "CAN_QUERY": コラボレーション内でクエリを実行できる権限
  #   - "CAN_RECEIVE_RESULTS": クエリ結果を受け取れる権限
  #   - "CAN_RUN_JOB": ジョブを実行できる権限（PySpark等）
  # 関連機能: メンバー権限
  #   コラボレーション内での各メンバーの操作権限を制御します。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_CreateCollaboration.html
  creator_member_abilities = ["CAN_QUERY", "CAN_RECEIVE_RESULTS"]

  #-------------------------------------------------------------
  # クエリログ設定
  #-------------------------------------------------------------

  # query_log_status (Required, Forces new resource)
  # 設定内容: コラボレーションメンバーがメンバーシップ内でクエリログを
  #           有効化できるかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLED": クエリログを有効化。AWS Clean Roomsが実行されたクエリの
  #                詳細をAmazon CloudWatch Logsに記録します
  #   - "DISABLED": クエリログを無効化
  # 関連機能: 分析ログ
  #   コラボレーション内で実行されたクエリを監査するためのログ機能。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/userguide/query-logs.html
  query_log_status = "DISABLED"

  #-------------------------------------------------------------
  # 分析エンジン設定
  #-------------------------------------------------------------

  # analytics_engine (Optional)
  # 設定内容: コラボレーションで使用する分析エンジンを指定します。
  # 設定可能な値:
  #   - "SPARK": Apache Sparkベースの分析エンジン。PySpark等を使用可能
  #   - "CLEAN_ROOMS_SQL": (非推奨) 2025年7月16日以降は使用不可
  # 省略時: デフォルトの分析エンジンが使用されます
  # 関連機能: PySpark分析
  #   Apache Sparkを使用したカスタムコードによるデータ処理・分析が可能。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/userguide/analysis-rules.html
  analytics_engine = "SPARK"

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
  # データ暗号化メタデータ設定 (オプション)
  #-------------------------------------------------------------
  # Cryptographic Computing for Clean Rooms (C3R)クライアントが
  # コラボレーション内でデータを暗号化する方法を制御する設定です。
  # 関連機能: Cryptographic Computing for Clean Rooms
  #   クエリ処理中もデータを暗号化したまま保持し、厳格なデータ処理ポリシーに準拠。
  #   - https://docs.aws.amazon.com/clean-rooms/latest/userguide/crypto-computing.html

  data_encryption_metadata {
    # allow_clear_text (Required, Forces new resource)
    # 設定内容: 暗号化されたテーブルにクリアテキストデータを含めることを
    #           許可するかどうかを指定します。
    # 設定可能な値:
    #   - true: クリアテキストデータを許可
    #   - false: クリアテキストデータを禁止
    allow_clear_text = true

    # allow_duplicates (Required, Forces new resource)
    # 設定内容: Fingerprint列に重複エントリを含めることを許可するかどうかを指定します。
    # 設定可能な値:
    #   - true: 重複エントリを許可
    #   - false: 重複エントリを禁止
    allow_duplicates = true

    # allow_joins_on_columns_with_different_names (Required, Forces new resource)
    # 設定内容: 異なる名前を持つFingerprint列同士のJOINを許可するかどうかを指定します。
    # 設定可能な値:
    #   - true: 異なる名前の列でのJOINを許可
    #   - false: 異なる名前の列でのJOINを禁止
    allow_joins_on_columns_with_different_names = true

    # preserve_nulls (Required, Forces new resource)
    # 設定内容: NULL値を暗号化されたテーブルにそのままNULLとしてコピーするか、
    #           暗号化処理を行うかを指定します。
    # 設定可能な値:
    #   - true: NULL値をそのままNULLとして保持
    #   - false: NULL値も暗号化処理を行う
    preserve_nulls = false
  }

  #-------------------------------------------------------------
  # メンバー設定 (オプション)
  #-------------------------------------------------------------
  # コラボレーション作成者以外のメンバーを招待します。
  # 招待されたメンバーはコラボレーションに参加してメンバーシップを作成できます。
  # 注意: このリストは不変です（作成後に変更できません）。

  member {
    # account_id (Required, Forces new resource)
    # 設定内容: 招待するメンバーのAWSアカウントIDを指定します。
    # 設定可能な値: 12桁のAWSアカウントID
    account_id = "123456789012"

    # display_name (Required, Forces new resource)
    # 設定内容: 招待するメンバーの表示名を指定します。
    # 設定可能な値: 1-100文字の文字列
    display_name = "Partner Organization"

    # member_abilities (Required, Forces new resource)
    # 設定内容: 招待するメンバーに付与する権限のリストを指定します。
    # 設定可能な値:
    #   - "CAN_QUERY": コラボレーション内でクエリを実行できる権限
    #   - "CAN_RECEIVE_RESULTS": クエリ結果を受け取れる権限
    #   - "CAN_RUN_JOB": ジョブを実行できる権限（PySpark等）
    #   - []: 空のリストを指定すると、データ提供のみの権限
    # 参考: https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_CreateCollaboration.html
    member_abilities = []
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (オプション)
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "10s" などの時間文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "10s" などの時間文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "10s" などの時間文字列
    # 省略時: デフォルトのタイムアウト時間が適用されます
    delete = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: 最大200個のキーと値のペアのマップ
  #   - キー: 1-128文字
  #   - 値: 0-256文字
  # 関連機能: AWSリソースタグ付け
  #   タグベースのアクセス制御（IAMポリシー）にも使用可能。
  tags = {
    Name        = "terraform-example-collaboration"
    Environment = "development"
    Project     = "data-collaboration"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コラボレーションのAmazon Resource Name (ARN)
#
# - id: コラボレーションのID
#
# - create_time: コラボレーションが作成された日時
#
# - update_time: コラボレーションが最後に更新された日時
#
# - member.status: 各メンバーのステータス
#   有効な値: INVITED, ACTIVE, LEFT, REMOVED
#   - https://docs.aws.amazon.com/clean-rooms/latest/apireference/API_MemberSummary.html
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
