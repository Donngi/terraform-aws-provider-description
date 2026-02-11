#---------------------------------------------------------------
# Amazon Kendra Index
#---------------------------------------------------------------
#
# Amazon Kendraのインデックスリソース。Kendraはドキュメントやデータを
# インデックス化し、機械学習を使用してインテリジェントな検索を提供する
# サービスです。インデックスを作成後、ドキュメントを直接追加するか
# データソースから更新することができます。
#
# AWS公式ドキュメント:
#   - Creating an index: https://docs.aws.amazon.com/kendra/latest/dg/create-index.html
#   - CreateIndex API Reference: https://docs.aws.amazon.com/kendra/latest/APIReference/API_CreateIndex.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_index
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_index" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # インデックスの名前
  # 1〜1000文字の長さで、英数字、アンダースコア、ハイフンを使用可能
  # パターン: [a-zA-Z0-9][a-zA-Z0-9_-]*
  name = "example-kendra-index"

  # IAMロールのARN
  # KendraがCloudWatchログとメトリクスにアクセスするために必要
  # また、BatchPutDocument APIでS3バケットからドキュメントをインデックス化する際にも使用
  # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html#iam-roles-index
  role_arn = "arn:aws:iam::123456789012:role/kendra-index-role"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # インデックスの説明
  # 0〜1000文字の長さで指定可能
  description = "Example Kendra index for intelligent search"

  # Kendraのエディション
  # - DEVELOPER_EDITION: 開発、テスト、概念実証用
  # - ENTERPRISE_EDITION: 本番環境用（デフォルト）
  # - GEN_AI_ENTERPRISE_EDITION: 生成AI アプリケーション用
  # 一度設定すると変更できないため注意
  # クォータの詳細: https://docs.aws.amazon.com/kendra/latest/dg/quotas.html
  edition = "ENTERPRISE_EDITION"

  # リージョンの指定
  # このリソースを管理するAWSリージョン
  # 未指定の場合はプロバイダー設定のリージョンがデフォルト
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # ユーザーコンテキストポリシー
  # - ATTRIBUTE_FILTER: 属性フィルタを使用してユーザーコンテキストによる検索結果のフィルタリングを行う（デフォルト）
  # - USER_TOKEN: トークンベースのアクセス制御を使用
  # 注意: GEN_AI_ENTERPRISE_EDITIONの場合はATTRIBUTE_FILTERのみ使用可能
  user_context_policy = "ATTRIBUTE_FILTER"

  # タグ
  # インデックスを分類・識別するためのキーバリューペア
  # プロバイダーのdefault_tagsと組み合わせて使用可能
  tags = {
    Environment = "production"
    Application = "search"
  }

  # 注意: 以下の属性はスキーマ上設定可能ですが、通常は設定を推奨しません
  # - id: Terraformの内部識別子として自動管理されるため明示的な設定は不要
  # - tags_all: プロバイダーのdefault_tagsとの統合用。通常はtags属性を使用

  #---------------------------------------------------------------
  # キャパシティユニット設定
  #---------------------------------------------------------------

  # インデックスのクエリ処理とストレージのキャパシティを設定
  # 最大1ブロック
  capacity_units {
    # クエリキャパシティユニット
    # インデックスとGetQuerySuggestionsのための追加クエリ処理能力
    # 詳細: https://docs.aws.amazon.com/kendra/latest/dg/API_CapacityUnitsConfiguration.html#Kendra-Type-CapacityUnitsConfiguration-QueryCapacityUnits
    query_capacity_units = 0

    # ストレージキャパシティユニット
    # インデックスのための追加ストレージ容量
    # 1ユニット = 30GB または 100,000ドキュメント（どちらか先に達した方）
    # 最小値: 0
    storage_capacity_units = 0
  }

  #---------------------------------------------------------------
  # サーバーサイド暗号化設定
  #---------------------------------------------------------------

  # Kendraによってインデックス化されたデータを暗号化するためのKMS CMKを指定
  # Amazon Kendraは非対称CMKをサポートしていないため注意
  # 最大1ブロック
  server_side_encryption_configuration {
    # AWS KMS顧客管理キー（CMK）の識別子
    # 非対称CMKは使用不可
    kms_key_id = null
  }

  #---------------------------------------------------------------
  # ユーザーグループ解決設定
  #---------------------------------------------------------------

  # AWS IAM Identity Center（旧AWS SSO）からユーザーとグループの
  # アクセスレベルを取得する設定
  # ユーザーコンテキストフィルタリングに使用され、ユーザーまたはグループの
  # ドキュメントアクセス権限に基づいて検索結果をフィルタリング
  # 注意: GEN_AI_ENTERPRISE_EDITIONではサポートされていない
  # 最大1ブロック
  user_group_resolution_configuration {
    # ユーザーグループ解決モード
    # - AWS_SSO: AWS IAM Identity Centerを使用
    # - NONE: 使用しない
    # AWS SSOモードを使用する場合、ユーザーとグループがAWS SSO IDソースに存在する必要がある
    user_group_resolution_mode = "AWS_SSO"
  }

  #---------------------------------------------------------------
  # ユーザートークン設定
  #---------------------------------------------------------------

  # ユーザートークンの設定
  # 注意: GEN_AI_ENTERPRISE_EDITIONではサポートされていない
  # 最大1ブロック
  user_token_configurations {
    # JSONトークンタイプ設定
    # 最大1ブロック
    json_token_type_configuration {
      # グループ属性フィールド
      # JSONトークン内のグループ情報を示すフィールド名
      # 長さ: 1〜2048文字
      group_attribute_field = "groups"

      # ユーザー名属性フィールド
      # JSONトークン内のユーザー名を示すフィールド名
      # 長さ: 1〜2048文字
      user_name_attribute_field = "username"
    }

    # JWTトークンタイプ設定
    # 最大1ブロック
    jwt_token_type_configuration {
      # キーの場所
      # - URL: 署名キーをURLから取得
      # - SECRET_MANAGER: AWS Secrets Managerから取得
      key_location = "URL"

      # 署名キーのURL
      # key_locationが"URL"の場合に指定
      # パターン: ^(https?|ftp|file):\/\/([^\s]*)
      url = "https://example.com/.well-known/jwks.json"

      # Secrets ManagerのARN
      # key_locationが"SECRET_MANAGER"の場合に指定
      secrets_manager_arn = null

      # トークンの発行者
      # 長さ: 1〜65文字
      issuer = null

      # クレームの正規表現
      # クレームを識別する正規表現パターン
      # 長さ: 1〜100文字
      claim_regex = null

      # グループ属性フィールド
      # JWTトークン内のグループ情報を示すフィールド名
      # 長さ: 1〜100文字
      group_attribute_field = null

      # ユーザー名属性フィールド
      # JWTトークン内のユーザー名を示すフィールド名
      # 長さ: 1〜100文字
      user_name_attribute_field = null
    }
  }

  #---------------------------------------------------------------
  # ドキュメントメタデータ設定
  #---------------------------------------------------------------

  # インデックス内のドキュメントに適用されるメタデータの設定
  # カスタムドキュメントフィールドを定義して検索の関連性をチューニング
  # 最小: 0ブロック、最大: 500ブロック
  # 注意: ブロックは削除できない（インデックスフィールドは削除不可のため）
  # 参考: https://docs.aws.amazon.com/kendra/latest/dg/hiw-index.html

  # 事前定義フィールドの設定例（_document_title）
  document_metadata_configuration_updates {
    # インデックスフィールドの名前
    # 長さ: 1〜30文字
    name = "_document_title"

    # フィールドのデータ型
    # - STRING_VALUE: 文字列値
    # - STRING_LIST_VALUE: 文字列リスト
    # - LONG_VALUE: 数値
    # - DATE_VALUE: 日付値
    type = "STRING_VALUE"

    # 検索設定
    # フィールドが検索中にどのように使用されるかを定義
    search {
      # 検索結果に表示するかどうか
      # デフォルト: true
      displayable = true

      # 検索ファセット（結果の各値のカウント）の作成に使用するかどうか
      # デフォルト: false
      facetable = false

      # 検索対象フィールドとして使用するかどうか
      # trueの場合、relevanceセクションで手動チューニング可能
      # デフォルト: string型はtrue、number型とdate型はfalse
      searchable = true

      # クエリ結果のソートに使用できるかどうか
      # falseのフィールドでソートを指定するとKendraは例外を返す
      # デフォルト: false
      sortable = true
    }

    # 関連性チューニング設定
    # 検索結果にフィールドがどう影響するかを手動調整
    relevance {
      # フィールドの相対的重要度
      # 大きな数値ほど検索結果への影響が大きい
      # 範囲: 1〜10
      importance = 2

      # 値の重要度マップ（STRING_VALUE型の場合に必須）
      # 特定の値が結果リストに表示される際の異なるブースト値
      # 参考: https://docs.aws.amazon.com/kendra/latest/dg/API_Relevance.html#Kendra-Type-Relevance-ValueImportanceMap
      values_importance_map = {}
    }
  }

  # カスタムフィールドの追加例（STRING_VALUE型）
  document_metadata_configuration_updates {
    name = "custom-department"
    type = "STRING_VALUE"

    search {
      displayable = true
      facetable   = true
      searchable  = true
      sortable    = true
    }

    relevance {
      importance = 1
      values_importance_map = {
        "engineering" = 3
        "sales"       = 2
        "marketing"   = 2
      }
    }
  }

  # LONG_VALUE型のカスタムフィールド例
  document_metadata_configuration_updates {
    name = "custom-priority"
    type = "LONG_VALUE"

    search {
      displayable = true
      facetable   = true
      searchable  = false
      sortable    = true
    }

    relevance {
      importance = 1
      # rank_order: 値の解釈方法（LONG_VALUE型またはDATE_VALUE型で必須）
      # - ASCENDING: 小さい値がより関連性が高い
      # - DESCENDING: 大きい値がより関連性が高い
      # 参考: https://docs.aws.amazon.com/kendra/latest/dg/API_Relevance.html#Kendra-Type-Relevance-RankOrder
      rank_order = "ASCENDING"
    }
  }

  # DATE_VALUE型のカスタムフィールド例
  document_metadata_configuration_updates {
    name = "custom-publish-date"
    type = "DATE_VALUE"

    search {
      displayable = true
      facetable   = true
      searchable  = false
      sortable    = true
    }

    relevance {
      importance = 1

      # freshness: ドキュメントの「新鮮さ」を決定するかどうか（DATE_VALUE型で必須）
      # 参考: https://docs.aws.amazon.com/kendra/latest/dg/API_Relevance.html#Kendra-Type-Relevance-Freshness
      freshness = true

      # duration: ブーストが適用される期間（DATE_VALUE型で必須）
      # 形式: ISO 8601期間形式（例: "P30D" = 30日間、"25920000s" = 300日間）
      # 参考: https://docs.aws.amazon.com/kendra/latest/dg/API_Relevance.html#Kendra-Type-Relevance-Duration
      duration = "25920000s"

      rank_order = "ASCENDING"
    }
  }

  # STRING_LIST_VALUE型のカスタムフィールド例
  document_metadata_configuration_updates {
    name = "custom-tags"
    type = "STRING_LIST_VALUE"

    search {
      displayable = true
      facetable   = true
      searchable  = true
      sortable    = false # STRING_LIST_VALUEはソート不可
    }

    relevance {
      importance = 1
      # STRING_LIST_VALUE型ではvalues_importance_mapは使用しない
    }
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # 作成時のタイムアウト
    # インデックス作成には時間がかかる場合があるため適切に設定
    create = "60m"

    # 更新時のタイムアウト
    update = "60m"

    # 削除時のタイムアウト
    # 削除は非同期操作で、全ての関連情報が削除されるまで
    # インデックスのステータスは"DELETING"になる
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用の出力属性）
#---------------------------------------------------------------
# これらの属性はリソース作成後に参照可能ですが、設定することはできません。
#
# - arn: インデックスのAmazon Resource Name (ARN)
# - created_at: インデックスが作成されたUnix日時
# - error_message: Statusフィールドの値が"FAILED"の場合のエラーメッセージ
# - id: インデックスの識別子
# - status: インデックスの現在のステータス
#   * CREATING: 作成中
#   * ACTIVE: アクティブ（使用可能）
#   * DELETING: 削除中
#   * FAILED: 失敗
#   * UPDATING: 更新中
#   * SYSTEM_UPDATING: システム更新中
# - updated_at: インデックスが最後に更新されたUnix日時
# - tags_all: リソースに割り当てられたタグのマップ
#   （プロバイダーのdefault_tagsから継承されたものを含む）
# - index_statistics: インデックス内のFAQとテキストドキュメントの統計情報
#   * faq_statistics: FAQの統計
#     - indexed_question_answers_count: インデックス化されたFAQ質問と回答の総数
#   * text_document_statistics: テキストドキュメントの統計
#     - indexed_text_bytes: インデックス化されたドキュメントの合計サイズ（バイト）
#     - indexed_text_documents_count: インデックス化されたテキストドキュメントの数
#
#---------------------------------------------------------------

# 出力例
output "kendra_index_id" {
  description = "The ID of the Kendra index"
  value       = aws_kendra_index.example.id
}

output "kendra_index_arn" {
  description = "The ARN of the Kendra index"
  value       = aws_kendra_index.example.arn
}

output "kendra_index_status" {
  description = "The status of the Kendra index"
  value       = aws_kendra_index.example.status
}
