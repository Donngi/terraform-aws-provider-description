#---------------------------------------------------------------
# Amazon OpenSearch Package
#---------------------------------------------------------------
#
# Amazon OpenSearchドメインで使用するカスタムパッケージ（辞書ファイル、
# プラグイン、ライセンス、設定ファイル等）をプロビジョニングするリソースです。
# パッケージをS3バケットからインポートし、OpenSearchドメインに関連付けて
# 検索機能の拡張やカスタマイズを実現します。
#
# AWS公式ドキュメント:
#   - カスタムパッケージのインポートと管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-packages.html
#   - カスタムプラグインの管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-plugins.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_package
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_package" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # package_name (Required, Forces new resource)
  # 設定内容: パッケージの一意な名前を指定します。
  # 設定可能な値: 文字列（パッケージを識別するための名前）
  # 注意: 変更すると新しいリソースが作成されます（Forces new resource）
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-packages.html
  package_name = "example-dictionary"

  # package_type (Required, Forces new resource)
  # 設定内容: パッケージのタイプを指定します。
  # 設定可能な値:
  #   - "TXT-DICTIONARY": テキスト形式の辞書ファイル（カスタム辞書）
  #   - "ZIP-PLUGIN": ZIP形式のプラグインファイル（カスタムプラグイン）
  #   - "PACKAGE-LICENSE": プラグインのライセンスパッケージ（サードパーティプラグイン用）
  #   - "PACKAGE-CONFIG": プラグインの設定パッケージ（サードパーティプラグイン用）
  # 注意: 変更すると新しいリソースが作成されます（Forces new resource）
  # 関連機能: OpenSearch パッケージタイプ
  #   辞書ファイルはTXT-DICTIONARY、カスタムプラグインはZIP-PLUGIN、
  #   サードパーティプラグインにはPACKAGE-LICENSEとPACKAGE-CONFIGが必要です。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-packages.html
  package_type = "TXT-DICTIONARY"

  # package_description (Optional, Forces new resource)
  # 設定内容: パッケージの説明を指定します。
  # 設定可能な値: 文字列（パッケージの用途や内容の説明）
  # 省略時: 説明なしでパッケージが作成されます
  # 注意: 変更すると新しいリソースが作成されます（Forces new resource）
  package_description = "Custom dictionary for domain-specific terms"

  #-------------------------------------------------------------
  # エンジンバージョン設定
  #-------------------------------------------------------------

  # engine_version (Optional, Forces new resource)
  # 設定内容: パッケージが互換性を持つエンジンバージョンを指定します。
  # 設定可能な値: "OpenSearch_X.Y" または "Elasticsearch_X.Y" 形式の文字列
  #   例: "OpenSearch_2.15", "Elasticsearch_7.10"
  #   （X, Yはそれぞれメジャーバージョンとマイナーバージョン番号）
  # 省略時: パッケージタイプに応じて動作が異なります
  # 注意: package_typeが"ZIP-PLUGIN"の場合は必須かつ有効な引数です。
  #       その他のパッケージタイプでは不要です。
  #       変更すると新しいリソースが作成されます（Forces new resource）
  # 関連機能: OpenSearch カスタムプラグイン
  #   カスタムプラグイン（ZIP-PLUGIN）はOpenSearch 2.15以降のバージョンで
  #   サポートされており、エンジンバージョンとの互換性検証が行われます。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-plugins.html
  engine_version = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パッケージソース設定
  #-------------------------------------------------------------

  # package_source (Required, Forces new resource)
  # 設定内容: パッケージファイルのS3バケット上の場所を指定します。
  # 設定可能な値: package_sourceブロック（下記の属性を含む）
  # 注意: 変更すると新しいリソースが作成されます（Forces new resource）
  #       最小1個、最大1個のブロックを指定する必要があります
  # 関連機能: S3バケットからのパッケージインポート
  #   パッケージファイルは事前にS3バケットにアップロードしておく必要があります。
  #   OpenSearchサービスはこのS3の場所からパッケージを読み取ります。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/custom-packages.html
  package_source {
    # s3_bucket_name (Required, Forces new resource)
    # 設定内容: パッケージファイルが格納されているS3バケットの名前を指定します。
    # 設定可能な値: 有効なS3バケット名
    # 注意: 変更すると新しいリソースが作成されます（Forces new resource）
    s3_bucket_name = "my-opensearch-packages"

    # s3_key (Required, Forces new resource)
    # 設定内容: S3バケット内のパッケージファイルのキー（ファイル名/パス）を指定します。
    # 設定可能な値: 有効なS3オブジェクトキー
    # 注意: 変更すると新しいリソースが作成されます（Forces new resource）
    s3_key = "dictionaries/custom-terms.txt"
  }

  #-------------------------------------------------------------
  # ID設定（オプション）
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを明示的に指定します。
  # 設定可能な値: 文字列
  # 省略時: AWSによって自動的にIDが生成されます
  # 注意: 通常は省略してAWSに自動生成させることを推奨します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - package_id: パッケージのID。OpenSearchドメインへのパッケージ関連付け等で使用します。
#
# - available_package_version: パッケージの現在のバージョン。
#                               パッケージの更新状況を確認する際に使用します。
#---------------------------------------------------------------
