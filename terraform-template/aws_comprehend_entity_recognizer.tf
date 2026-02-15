#---------------------------------------
# Comprehend カスタムエンティティ認識器
#---------------------------------------
# Amazon Comprehend のカスタムエンティティ認識器を定義するリソース。
# 独自の機械学習モデルをトレーニングして、テキスト内の特定のエンティティタイプを
# 識別できるようになる。
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# 主な用途:
# - カスタムエンティティ（製品名、企業固有の用語など）の抽出
# - 業界固有のNLP（自然言語処理）タスク
# - テキスト分類・分析の精度向上
#
# 制約事項:
# - トレーニングには大量の注釈付きデータまたはエンティティリストが必要
# - 対応言語は language_code で指定した言語のみ
# - トレーニング完了まで時間がかかる（数時間～数日）
# - 同時にトレーニングできる認識器数に制限あり
#
# NOTE: version_name と version_name_prefix は同時に使用不可
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/comprehend_entity_recognizer
#---------------------------------------

resource "aws_comprehend_entity_recognizer" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: エンティティ認識器の名前
  # 省略時: 指定必須
  name = "example-entity-recognizer"

  # 設定内容: エンティティ認識器がトレーニングする言語コード
  # 設定可能な値: en（英語）、es（スペイン語）、fr（フランス語）、de（ドイツ語）、
  #               it（イタリア語）、pt（ポルトガル語）、ar（アラビア語）、
  #               hi（ヒンディー語）、ja（日本語）、ko（韓国語）、zh（中国語）、zh-TW（繁体字中国語）
  # 省略時: 指定必須
  language_code = "en"

  # 設定内容: Comprehend がトレーニングデータと出力結果にアクセスするための IAM ロール ARN
  # 省略時: 指定必須
  # 注意: S3 バケットへの読み取り・書き込み権限が必要
  data_access_role_arn = "arn:aws:iam::123456789012:role/ComprehendDataAccessRole"

  #---------------------------------------
  # トレーニングデータ設定
  #---------------------------------------
  # 設定内容: エンティティ認識器のトレーニングデータ設定
  # 省略時: 指定必須
  input_data_config {
    # 設定内容: トレーニングデータのフォーマット
    # 設定可能な値: COMPREHEND_CSV（注釈付きCSV）、AUGMENTED_MANIFEST（拡張マニフェスト）
    # 省略時: COMPREHEND_CSV
    data_format = "COMPREHEND_CSV"

    # 設定内容: 認識対象のエンティティタイプ定義（1～25個）
    # 省略時: 指定必須（最低1つ）
    entity_types {
      # 設定内容: エンティティタイプ名（例: PRODUCT、ORGANIZATION、PERSON など）
      # 省略時: 指定必須
      type = "PRODUCT"
    }

    entity_types {
      type = "ORGANIZATION"
    }

    # 設定内容: 注釈付きトレーニングデータの場所
    # 省略時: documents、entity_list、augmented_manifests のいずれかが必須
    # 注意: annotations を使用する場合は entity_list も必要
    annotations {
      # 設定内容: 注釈ファイルが格納された S3 URI
      # 省略時: 指定必須
      s3_uri = "s3://example-bucket/annotations/train.csv"

      # 設定内容: テスト用注釈ファイルの S3 URI
      # 省略時: トレーニングデータのみ使用
      # test_s3_uri = "s3://example-bucket/annotations/test.csv"
    }

    # 設定内容: エンティティリストファイルの場所
    # 省略時: annotations を使用する場合は必須
    entity_list {
      # 設定内容: エンティティリストファイルの S3 URI
      # 省略時: 指定必須
      s3_uri = "s3://example-bucket/entity-list.csv"
    }

    # 設定内容: プレーンテキストドキュメントの場所
    # 省略時: annotations、augmented_manifests のいずれかと併用
    # documents {
    #   # 設定内容: ドキュメントファイルの S3 URI
    #   # 省略時: 指定必須
    #   s3_uri = "s3://example-bucket/documents/"
    #
    #   # 設定内容: ドキュメントの入力フォーマット
    #   # 設定可能な値: ONE_DOC_PER_FILE、ONE_DOC_PER_LINE
    #   # 省略時: ONE_DOC_PER_FILE
    #   input_format = "ONE_DOC_PER_LINE"
    #
    #   # 設定内容: テスト用ドキュメントの S3 URI
    #   # 省略時: トレーニングデータのみ使用
    #   test_s3_uri = "s3://example-bucket/test-documents/"
    # }

    # 設定内容: 拡張マニフェスト形式のトレーニングデータ
    # 省略時: 他のデータソースを使用
    # 注意: data_format = "AUGMENTED_MANIFEST" の場合に使用
    # augmented_manifests {
    #   # 設定内容: 拡張マニフェストファイルの S3 URI
    #   # 省略時: 指定必須
    #   s3_uri = "s3://example-bucket/augmented-manifest.jsonl"
    #
    #   # 設定内容: エンティティ注釈を含む属性名のリスト
    #   # 省略時: 指定必須
    #   attribute_names = ["entities"]
    #
    #   # 設定内容: ドキュメントタイプ
    #   # 設定可能な値: PLAIN_TEXT_DOCUMENT、SEMI_STRUCTURED_DOCUMENT
    #   # 省略時: PLAIN_TEXT_DOCUMENT
    #   document_type = "PLAIN_TEXT_DOCUMENT"
    #
    #   # 設定内容: データ分割（トレーニング/テスト）
    #   # 設定可能な値: TRAIN、TEST
    #   # 省略時: TRAIN
    #   split = "TRAIN"
    #
    #   # 設定内容: 注釈データの S3 URI（別ファイルの場合）
    #   # 省略時: マニフェスト内の注釈を使用
    #   annotation_data_s3_uri = "s3://example-bucket/annotations/"
    #
    #   # 設定内容: ソースドキュメントの S3 URI（別ファイルの場合）
    #   # 省略時: マニフェスト内のドキュメントを使用
    #   source_documents_s3_uri = "s3://example-bucket/source-documents/"
    # }
  }

  #---------------------------------------
  # セキュリティ・暗号化設定
  #---------------------------------------
  # 設定内容: モデルデータの暗号化に使用する KMS キー ID
  # 省略時: AWS 管理キーで暗号化
  model_kms_key_id = null
  # model_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # 設定内容: トレーニング中のストレージボリューム暗号化に使用する KMS キー ID
  # 省略時: AWS 管理キーで暗号化
  volume_kms_key_id = null
  # volume_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #---------------------------------------
  # VPC 設定
  #---------------------------------------
  # 設定内容: VPC 内でトレーニングジョブを実行する際の VPC 設定
  # 省略時: VPC 外で実行
  # 注意: プライベートサブネット内のデータにアクセスする場合に使用
  # vpc_config {
  #   # 設定内容: トレーニングジョブに関連付けるセキュリティグループ ID のリスト
  #   # 省略時: 指定必須（vpc_config 使用時）
  #   security_group_ids = ["sg-12345678"]
  #
  #   # 設定内容: トレーニングジョブを実行するサブネット ID のリスト
  #   # 省略時: 指定必須（vpc_config 使用時）
  #   subnets = ["subnet-12345678", "subnet-87654321"]
  # }

  #---------------------------------------
  # バージョン管理
  #---------------------------------------
  # 設定内容: エンティティ認識器のバージョン名
  # 省略時: 自動生成される
  # 注意: version_name と version_name_prefix は同時に使用不可
  version_name = null
  # version_name = "v1.0"

  # 設定内容: バージョン名のプレフィックス
  # 省略時: 指定なし
  # 注意: Terraform が残りのバージョン名を自動生成
  version_name_prefix = null
  # version_name_prefix = "v1-"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: エンティティ認識器を管理するリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = null
  # region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: エンティティ認識器に付与するタグ
  # 省略時: タグなし
  tags = {
    Name        = "example-entity-recognizer"
    Environment = "production"
    Purpose     = "custom-entity-detection"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  # 設定内容: リソース操作のタイムアウト時間
  # 省略時: create=60m、update=60m、delete=60m
  # timeouts {
  #   create = "120m"
  #   update = "120m"
  #   delete = "30m"
  # }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートする:
#
# - id: エンティティ認識器の ARN
# - arn: エンティティ認識器の ARN
# - version_name: エンティティ認識器のバージョン名（自動生成または指定値）
# - tags_all: デフォルトタグを含む全てのタグ
# - region: エンティティ認識器が管理されているリージョン
