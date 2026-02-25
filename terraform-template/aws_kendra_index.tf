#---------------------------------------------------------------
# AWS Kendra Index
#---------------------------------------------------------------
#
# Amazon Kendra インデックスをプロビジョニングするリソースです。
# Amazon Kendra は機械学習を活用したインテリジェント検索サービスであり、
# インデックスはドキュメントの検索基盤となるコアコンポーネントです。
# ドキュメントを取り込んだり、クエリを受け付けたりするためのエンドポイントです。
#
# 主なユースケース:
#   - 社内ナレッジベース・ドキュメント管理システムへの自然言語検索
#   - FAQ・サポートドキュメントへのインテリジェント検索
#   - S3、SharePoint、Confluence等の多様なデータソースの横断検索
#   - チャットボットや仮想アシスタントのバックエンド検索エンジン
#
# 重要な注意事項:
#   - インデックスの作成・削除には数分かかるため、タイムアウト設定の調整を推奨します。
#   - DEVELOPER_EDITION は評価・開発用途向けで容量制限があります。
#   - ENTERPRISE_EDITION は本番環境向けで、容量ユニットによるスケール調整が可能です。
#   - インデックスには IAM ロールが必要で、CloudWatch Logs への書き込み権限が必要です。
#   - document_metadata_configuration_updates で組み込みフィールドのカスタマイズも可能です。
#
# AWS公式ドキュメント:
#   - Amazon Kendra 概要: https://docs.aws.amazon.com/kendra/latest/dg/what-is-kendra.html
#   - インデックス作成: https://docs.aws.amazon.com/kendra/latest/dg/create-index.html
#   - エディション比較: https://docs.aws.amazon.com/kendra/latest/dg/index-editions.html
#   - ドキュメントメタデータ: https://docs.aws.amazon.com/kendra/latest/dg/custom-attributes.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/kendra_index
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_index" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Required)
  # 設定内容: Kendra インデックスの名前を指定します。
  # 設定可能な値: 1〜1000文字の文字列
  # 省略時: 省略不可
  name = "example-kendra-index"

  # role_arn (Required)
  # 設定内容: Kendra がインデックス操作に使用する IAM ロールの ARN を指定します。
  # 設定可能な値: IAM ロールの ARN 文字列
  # 省略時: 省略不可
  #
  # IAM ロールには以下の権限が必要です:
  #   - cloudwatch:PutMetricData（メトリクス送信）
  #   - logs:DescribeLogGroups, logs:CreateLogGroup, logs:DescribeLogStreams,
  #     logs:CreateLogStream, logs:PutLogEvents（CloudWatch Logs への書き込み）
  #   - s3:GetObject（S3 データソース使用時）
  role_arn = "arn:aws:iam::123456789012:role/example-kendra-role"

  #---------------------------------------------------------------
  # エディション・説明設定
  #---------------------------------------------------------------

  # edition (Optional)
  # 設定内容: Kendra インデックスのエディションを指定します。
  # 設定可能な値:
  #   - "DEVELOPER_EDITION"  : 開発・評価用。容量制限あり（ドキュメント数・クエリ数）
  #   - "ENTERPRISE_EDITION" : 本番環境用。容量ユニットでのスケールアウトが可能
  # 省略時: "ENTERPRISE_EDITION"
  edition = "DEVELOPER_EDITION"

  # description (Optional)
  # 設定内容: インデックスの説明文を指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明なし
  description = "Example Kendra index for intelligent search"

  # user_context_policy (Optional)
  # 設定内容: ユーザーコンテキストポリシーを指定します。検索結果のアクセス制御に使用します。
  # 設定可能な値:
  #   - "ATTRIBUTE_FILTER" : ドキュメントメタデータ属性によるフィルタリング（デフォルト）
  #   - "USER_TOKEN"       : ユーザートークンによるアクセス制御（user_token_configurations が必要）
  # 省略時: "ATTRIBUTE_FILTER"
  user_context_policy = "ATTRIBUTE_FILTER"

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #---------------------------------------------------------------
  # 容量設定（ENTERPRISE_EDITION のみ有効）
  #---------------------------------------------------------------

  # capacity_units ブロック (Optional)
  # 設定内容: インデックスの容量ユニットを指定します。ENTERPRISE_EDITION のみ有効です。
  # 省略時: デフォルト容量（自動設定）
  capacity_units {
    # query_capacity_units (Optional)
    # 設定内容: クエリ処理のための追加容量ユニット数を指定します。
    # 設定可能な値: 0以上の整数（1ユニット = 0.1 クエリ/秒の追加処理能力）
    # 省略時: AWSが適切な値を自動設定
    query_capacity_units = 0

    # storage_capacity_units (Optional)
    # 設定内容: ドキュメントストレージのための追加容量ユニット数を指定します。
    # 設定可能な値: 0以上の整数（1ユニット = 100,000 ドキュメントの追加ストレージ）
    # 省略時: AWSが適切な値を自動設定
    storage_capacity_units = 0
  }

  #---------------------------------------------------------------
  # サーバーサイド暗号化設定
  #---------------------------------------------------------------

  # server_side_encryption_configuration ブロック (Optional)
  # 設定内容: インデックスデータのサーバーサイド暗号化を設定します。
  # 省略時: AWSが管理するキー（aws/kendra）で暗号化
  server_side_encryption_configuration {
    # kms_key_id (Optional)
    # 設定内容: 暗号化に使用するKMSキーのIDまたはARNを指定します。
    # 設定可能な値: KMSキーID、KMSキーARN、またはKMSキーエイリアスのARN
    # 省略時: AWSが管理するデフォルトキー（aws/kendra）を使用
    kms_key_id = null # "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
  }

  #---------------------------------------------------------------
  # ドキュメントメタデータ設定
  #---------------------------------------------------------------

  # document_metadata_configuration_updates ブロック (Optional)
  # 設定内容: インデックスのドキュメントメタデータフィールド（カスタム属性）を定義・更新します。
  # 省略時: 組み込みフィールドのデフォルト設定のみ使用
  #
  # 最大500個まで設定可能。組み込みフィールドの上書きも可能です。
  # 組み込みフィールド例: _category, _created_at, _document_title, _file_type, _last_updated_at,
  #                        _source_uri, _version, _view_count
  document_metadata_configuration_updates {
    # name (Required)
    # 設定内容: メタデータフィールドの名前を指定します。
    # 設定可能な値: 組み込みフィールド名（_で始まる）またはカスタムフィールド名（1〜30文字）
    # 省略時: 省略不可
    name = "example_custom_field"

    # type (Required)
    # 設定内容: メタデータフィールドのデータ型を指定します。
    # 設定可能な値:
    #   - "STRING_VALUE"      : 文字列型
    #   - "STRING_LIST_VALUE" : 文字列リスト型
    #   - "LONG_VALUE"        : 数値型（Long）
    #   - "DATE_VALUE"        : 日時型
    # 省略時: 省略不可
    type = "STRING_VALUE"

    # relevance ブロック (Optional)
    # 設定内容: フィールドの検索結果ランキングへの影響を設定します。
    # 省略時: デフォルトの関連性設定を使用
    relevance {
      # duration (Optional)
      # 設定内容: DATE_VALUE フィールドにおける「鮮度」を計算するための期間を指定します。
      # 設定可能な値: "1 DAY", "1 WEEK", "1 MONTH", "3 MONTHS", "6 MONTHS", "1 YEAR" など
      # 省略時: AWSが適切な値を自動設定
      duration = null

      # freshness (Optional)
      # 設定内容: DATE_VALUE フィールドをドキュメントの「鮮度」として使用するかを指定します。
      # 設定可能な値: true / false
      # 省略時: AWSが適切な値を自動設定
      freshness = null

      # importance (Optional)
      # 設定内容: 検索スコアリングにおけるこのフィールドの重要度を指定します。
      # 設定可能な値: 1〜10 の整数（数値が高いほど重要度が高い）
      # 省略時: AWSが適切な値を自動設定
      importance = null

      # rank_order (Optional)
      # 設定内容: 数値・日付フィールドのランキング順序を指定します。
      # 設定可能な値: "ASCENDING" / "DESCENDING"
      # 省略時: AWSが適切な値を自動設定
      rank_order = null

      # values_importance_map (Optional)
      # 設定内容: STRING_VALUE フィールドの特定の値に対する重要度のマッピングを指定します。
      # 設定可能な値: キーが文字列値、値が 1〜10 の整数のマップ
      # 省略時: AWSが適切な値を自動設定
      values_importance_map = {}
    }

    # search ブロック (Optional)
    # 設定内容: フィールドの検索・表示に関する設定を行います。
    # 省略時: デフォルトの検索設定を使用
    search {
      # displayable (Optional)
      # 設定内容: 検索結果においてこのフィールドを表示するかを指定します。
      # 設定可能な値: true / false
      # 省略時: AWSが適切な値を自動設定
      displayable = true

      # facetable (Optional)
      # 設定内容: このフィールドをファセット（絞り込み条件）として使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: AWSが適切な値を自動設定
      facetable = false

      # searchable (Optional)
      # 設定内容: このフィールドの値を全文検索の対象にするかを指定します。STRING_VALUE のみ有効。
      # 設定可能な値: true / false
      # 省略時: AWSが適切な値を自動設定
      searchable = true

      # sortable (Optional)
      # 設定内容: このフィールドを検索結果のソートキーとして使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: AWSが適切な値を自動設定
      sortable = false
    }
  }

  #---------------------------------------------------------------
  # ユーザーグループ解決設定
  #---------------------------------------------------------------

  # user_group_resolution_configuration ブロック (Optional)
  # 設定内容: ユーザーグループのメンバーシップ解決方法を設定します。
  # 省略時: ユーザーグループ解決を使用しない
  user_group_resolution_configuration {
    # user_group_resolution_mode (Required)
    # 設定内容: ユーザーグループの解決モードを指定します。
    # 設定可能な値:
    #   - "AWS_SSO"  : AWS IAM Identity Center（旧SSO）からグループメンバーシップを取得
    #   - "NONE"     : ユーザーグループ解決を無効化
    # 省略時: 省略不可
    user_group_resolution_mode = "NONE"
  }

  #---------------------------------------------------------------
  # ユーザートークン設定
  #---------------------------------------------------------------

  # user_token_configurations ブロック (Optional)
  # 設定内容: user_context_policy が "USER_TOKEN" の場合のトークン設定を指定します。
  # 省略時: トークン認証を使用しない
  #
  # json_token_type_configuration と jwt_token_type_configuration のいずれか一方のみ設定可能です。
  user_token_configurations {
    # json_token_type_configuration ブロック (Optional)
    # 設定内容: JSON 形式のトークンを使用する場合の設定を指定します。
    # 省略時: JWT トークン設定を使用
    json_token_type_configuration {
      # group_attribute_field (Required)
      # 設定内容: JSON トークン内のグループ情報を含むフィールド名を指定します。
      # 設定可能な値: JSON フィールド名の文字列
      # 省略時: 省略不可
      group_attribute_field = "groups"

      # user_name_attribute_field (Required)
      # 設定内容: JSON トークン内のユーザー名情報を含むフィールド名を指定します。
      # 設定可能な値: JSON フィールド名の文字列
      # 省略時: 省略不可
      user_name_attribute_field = "username"
    }

    # jwt_token_type_configuration ブロック (Optional)
    # 設定内容: JWT 形式のトークンを使用する場合の設定を指定します。
    # 省略時: JSON トークン設定を使用
    #
    # jwt_token_type_configuration {
    #   # key_location (Required)
    #   # 設定内容: JWT の公開鍵の場所を指定します。
    #   # 設定可能な値:
    #   #   - "URL"             : URL エンドポイントから公開鍵を取得
    #   #   - "SECRET_MANAGER"  : AWS Secrets Manager から公開鍵を取得
    #   # 省略時: 省略不可
    #   key_location = "URL"
    #
    #   # url (Optional)
    #   # 設定内容: key_location が "URL" の場合の公開鍵エンドポイント URL を指定します。
    #   # 設定可能な値: HTTPS URL 文字列
    #   # 省略時: Secrets Manager から取得
    #   url = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_example/.well-known/jwks.json"
    #
    #   # secrets_manager_arn (Optional)
    #   # 設定内容: key_location が "SECRET_MANAGER" の場合の Secrets Manager シークレット ARN を指定します。
    #   # 設定可能な値: Secrets Manager シークレットの ARN 文字列
    #   # 省略時: URL から取得
    #   secrets_manager_arn = null
    #
    #   # issuer (Optional)
    #   # 設定内容: JWT トークンの発行者（iss クレーム）を指定します。
    #   # 設定可能な値: 発行者を表す文字列
    #   # 省略時: 発行者検証なし
    #   issuer = null
    #
    #   # claim_regex (Optional)
    #   # 設定内容: JWT クレームから値を抽出するための正規表現を指定します。
    #   # 設定可能な値: 正規表現文字列
    #   # 省略時: クレーム全体をそのまま使用
    #   claim_regex = null
    #
    #   # group_attribute_field (Optional)
    #   # 設定内容: JWT クレーム内のグループ情報を含むフィールド名を指定します。
    #   # 設定可能な値: JWT クレームフィールド名の文字列
    #   # 省略時: AWSが適切な値を自動設定
    #   group_attribute_field = null
    #
    #   # user_name_attribute_field (Optional)
    #   # 設定内容: JWT クレーム内のユーザー名情報を含むフィールド名を指定します。
    #   # 設定可能な値: JWT クレームフィールド名の文字列
    #   # 省略時: AWSが適切な値を自動設定
    #   user_name_attribute_field = null
    # }
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts ブロック (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略時: Terraform のデフォルトタイムアウトを使用
  #
  # Kendra インデックスは作成・更新・削除に時間がかかるため、適切な設定を推奨します。
  timeouts {
    # create (Optional)
    # 設定内容: インデックス作成のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "2h" などの時間文字列
    # 省略時: デフォルトタイムアウト
    create = "60m"

    # update (Optional)
    # 設定内容: インデックス更新のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "2h" などの時間文字列
    # 省略時: デフォルトタイムアウト
    update = "60m"

    # delete (Optional)
    # 設定内容: インデックス削除のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "2h" などの時間文字列
    # 省略時: デフォルトタイムアウト
    delete = "60m"
  }

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグをキーと値のペアで指定します。
  # 設定可能な値: 最大50個のキーと値のペア。キーは最大128文字、値は最大256文字
  # 省略時: タグなし
  tags = {
    Name        = "example-kendra-index"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn
#     インデックスの ARN
#
# - id
#     インデックスの一意のID（インデックスID）
#
# - created_at
#     インデックスが作成された日時（RFC3339形式）
#
# - updated_at
#     インデックスが最後に更新された日時（RFC3339形式）
#
# - status
#     インデックスの現在のステータス
#     値: CREATING / ACTIVE / DELETING / FAILED / UPDATING / SYSTEM_UPDATING
#
# - error_message
#     ステータスが FAILED の場合のエラーメッセージ
#
# - index_statistics
#     インデックスの統計情報（FAQとテキストドキュメントの件数・バイト数）
#
# - tags_all
#     プロバイダーのデフォルトタグを含む全タグのマップ
#
