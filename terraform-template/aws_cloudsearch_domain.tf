#-------
# Amazon CloudSearch ドメイン
#-------
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudsearch_domain
# Generated: 2026-02-12
#
# NOTE: このテンプレートは汎用的な構成例です。実際の使用時は要件に応じて調整してください。
#
# Amazon CloudSearchは、完全マネージド型の検索サービスです。
# ドメインは検索可能なデータのコレクションであり、インデックスフィールドの設定、
# スケーリングオプション、エンドポイントオプションを含みます。
#
# 主な用途:
# - アプリケーション内の全文検索機能の実装
# - 構造化データに対するファセット検索
# - 地理空間検索やオートコンプリート機能の実装
# - カスタマイズ可能な関連性ランキング
#
# 動作概要:
# 1. 検索ドメインを作成し、インデックスフィールドを定義
# 2. データをアップロードしてインデックスを構築
# 3. 検索クエリを送信してデータを検索・取得
# 4. トラフィックとデータ量に応じて自動スケーリング
#
# 制約事項:
# - フィールド名は小文字の英字で始まり、3～64文字の長さが必要
# - 最大200個のフィールド定義が可能
# - インデックスフィールドの追加・変更後は明示的な再インデックスが必要
# - インスタンスタイプとレプリケーション数の変更はコストに大きく影響

resource "aws_cloudsearch_domain" "example" {
  #-------
  # 基本設定
  #-------
  # 設定内容: CloudSearchドメインの名前
  # 制約: 小文字の英数字とハイフンのみ使用可能（3～28文字）
  # 注意: ドメイン名は作成後に変更できません
  name = "example-search-domain"

  # 設定内容: Multi-AZ配置の有効化
  # 設定可能な値: true（有効）、false（無効）
  # 省略時: デフォルトの動作（単一AZ）
  # 注意: Multi-AZを有効にすると可用性が向上しますが、コストが増加します
  multi_az = false

  # 設定内容: ドメインを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: リージョンの変更はリソースの再作成が必要です
  region = "ap-northeast-1"

  #-------
  # インデックスフィールド設定
  #-------
  # インデックスフィールドは検索可能なデータ構造を定義します。
  # 各ドキュメントは一意のIDと1つ以上のフィールドを持ちます。

  # テキストフィールドの例（全文検索用）
  index_field {
    # 設定内容: フィールドの名前
    # 制約: 小文字で始まり、3～64文字、小文字・数字・アンダースコアのみ
    name = "title"

    # 設定内容: フィールドのデータ型
    # 設定可能な値: text, literal, int, double, date, latlon, text-array, literal-array, int-array, double-array, date-array
    # 注意: textは全文検索、literalは完全一致検索に使用
    type = "text"

    # 設定内容: 検索対象として有効化
    # 設定可能な値: true（検索可能）、false（検索不可）
    # 省略時: false
    search = true

    # 設定内容: 検索結果に含めることを有効化
    # 設定可能な値: true（返却可能）、false（返却不可）
    # 省略時: false
    return = true

    # 設定内容: ハイライト表示の有効化
    # 設定可能な値: true（有効）、false（無効）
    # 省略時: false
    # 注意: textフィールドでのみ使用可能
    highlight = true

    # 設定内容: ソート対象として有効化
    # 設定可能な値: true（ソート可能）、false（ソート不可）
    # 省略時: false
    # 注意: textフィールドではソートは通常使用しません
    # sort = false

    # 設定内容: ファセット検索の有効化
    # 設定可能な値: true（有効）、false（無効）
    # 省略時: false
    # 注意: textフィールドではファセットは通常使用しません
    # facet = false

    # 設定内容: テキスト解析スキーム名
    # 注意: 事前に解析スキームを定義する必要があります（別途API呼び出しが必要）
    # analysis_scheme = "ja_analyzer"

    # 設定内容: フィールドのデフォルト値
    # 注意: ドキュメントにフィールドが存在しない場合に使用されます
    # default_value = "N/A"

    # 設定内容: フィールドのソースとなる他のフィールド名
    # 注意: 複数フィールドの内容を集約する場合に使用します
    # source_fields = "title,description"
  }

  # リテラルフィールドの例（完全一致検索・ファセット用）
  index_field {
    name   = "category"
    type   = "literal"
    search = true
    return = true
    facet  = true
  }

  # 整数フィールドの例（数値範囲検索・ソート用）
  index_field {
    name   = "price"
    type   = "int"
    search = true
    return = true
    sort   = true
  }

  # 日付フィールドの例（日付範囲検索・ソート用）
  index_field {
    name   = "published_date"
    type   = "date"
    search = true
    return = true
    sort   = true
  }

  # 配列フィールドの例（複数値フィールド）
  index_field {
    name   = "tags"
    type   = "literal-array"
    search = true
    return = true
    facet  = true
  }

  #-------
  # エンドポイントセキュリティ設定
  #-------
  endpoint_options {
    # 設定内容: HTTPS通信の強制
    # 設定可能な値: true（HTTPSのみ）、false（HTTP/HTTPS両方）
    # 省略時: false
    # 推奨: セキュリティのため常にtrueに設定
    enforce_https = true

    # 設定内容: TLSセキュリティポリシー
    # 設定可能な値: Policy-Min-TLS-1-0-2019-07, Policy-Min-TLS-1-2-2019-07
    # 省略時: Policy-Min-TLS-1-0-2019-07
    # 推奨: Policy-Min-TLS-1-2-2019-07（TLS 1.2以上）
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  #-------
  # スケーリング設定
  #-------
  scaling_parameters {
    # 設定内容: 希望するインスタンスタイプ
    # 設定可能な値: search.small, search.medium, search.large, search.xlarge, search.2xlarge, search.previousgeneration.small, search.previousgeneration.large
    # 省略時: 自動選択（データ量に基づいて最適なタイプを選択）
    # 注意: インスタンスタイプの変更はコストに大きく影響します
    # desired_instance_type = "search.small"

    # 設定内容: 希望するレプリケーション数
    # 設定可能な値: 1～5
    # 省略時: 1
    # 注意: レプリケーション数を増やすと検索パフォーマンスが向上しますが、コストが増加します
    # desired_replication_count = 1

    # 設定内容: 希望するパーティション数
    # 設定可能な値: 1～10
    # 省略時: 自動選択（データ量に基づいて最適な数を選択）
    # 注意: 通常は自動スケーリングに任せることを推奨
    # desired_partition_count = 1
  }

  #-------
  # タイムアウト設定
  #-------
  timeouts {
    # 設定内容: ドメイン作成時のタイムアウト時間
    # 省略時: 30m
    # create = "30m"

    # 設定内容: ドメイン更新時のタイムアウト時間
    # 省略時: 30m
    # update = "30m"

    # 設定内容: ドメイン削除時のタイムアウト時間
    # 省略時: 20m
    # delete = "20m"
  }
}

#-------
# Attributes Reference
#-------
# arn                       - CloudSearchドメインのARN
# domain_id                 - ドメインの内部ID
# document_service_endpoint - ドキュメントサービスのエンドポイントURL（データアップロード用）
# search_service_endpoint   - 検索サービスのエンドポイントURL（検索クエリ用）

#-------
# 出力例
#-------
output "cloudsearch_domain_arn" {
  description = "CloudSearchドメインのARN"
  value       = aws_cloudsearch_domain.example.arn
}

output "cloudsearch_domain_id" {
  description = "CloudSearchドメインのID"
  value       = aws_cloudsearch_domain.example.domain_id
}

output "cloudsearch_document_endpoint" {
  description = "ドキュメントサービスエンドポイント（データアップロード用）"
  value       = aws_cloudsearch_domain.example.document_service_endpoint
}

output "cloudsearch_search_endpoint" {
  description = "検索サービスエンドポイント（検索クエリ用）"
  value       = aws_cloudsearch_domain.example.search_service_endpoint
}
