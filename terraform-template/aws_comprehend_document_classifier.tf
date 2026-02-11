# ==========================================
# Terraform AWS Resource Template
# ==========================================
# Resource: aws_comprehend_document_classifier
# Provider Version: 6.28.0
# Generated: 2026-01-19
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の情報に基づいています
# - 最新の仕様や詳細は公式ドキュメントを必ず確認してください
# - 全てのオプション属性を含む完全なリファレンスです
# ==========================================

# Terraform resource for managing an AWS Comprehend Document Classifier.
# Amazon Comprehend のカスタムドキュメント分類器を作成・管理します。
#
# 公式ドキュメント:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/comprehend_document_classifier
# - AWS: https://docs.aws.amazon.com/comprehend/latest/dg/how-document-classification.html

resource "aws_comprehend_document_classifier" "example" {
  # ==========================================
  # 必須パラメータ (Required)
  # ==========================================

  # (必須) ドキュメント分類器の名前
  # - 最大63文字
  # - 英大文字・小文字、数字、ハイフン(-)が使用可能
  # Type: string
  name = "example-classifier"

  # (必須) Comprehend がトレーニングおよびテストデータを読み取るための IAM Role ARN
  # - S3 バケットへのアクセス権限が必要
  # - Comprehend サービスが assume できる必要あり
  # Type: string
  data_access_role_arn = "arn:aws:iam::123456789012:role/ComprehendDataAccessRole"

  # (必須) 言語コード(2文字)
  # - 使用可能な値: en (英語), es (スペイン語), fr (フランス語), it (イタリア語), de (ドイツ語), pt (ポルトガル語)
  # Type: string
  language_code = "en"

  # ==========================================
  # オプションパラメータ (Optional)
  # ==========================================

  # (オプション) ドキュメント分類モード
  # - デフォルト: MULTI_CLASS
  # - 使用可能な値:
  #   - MULTI_CLASS: 単一ラベル分類 (AWS Console では "Single Label")
  #   - MULTI_LABEL: 複数ラベル分類
  # Type: string
  mode = "MULTI_CLASS"

  # (オプション) トレーニング済みドキュメント分類器の暗号化に使用する KMS キー
  # - KMS Key ID または KMS Key ARN を指定可能
  # Type: string
  # model_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # (オプション) このリソースが管理されるリージョン
  # - 未指定の場合、プロバイダー設定のリージョンを使用
  # - 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string
  # region = "us-east-1"

  # (オプション) リソースに割り当てるタグのマップ
  # - provider の default_tags と統合されます
  # Type: map(string)
  tags = {
    Environment = "production"
    Application = "document-classification"
  }

  # (オプション) プロバイダーレベルのタグを含む全てのタグ
  # - 通常は computed 値として使用されますが、明示的に設定も可能
  # - provider の default_tags との統合結果
  # Type: map(string)
  # tags_all = {}

  # (オプション) ドキュメント分類器バージョンの名前
  # - 各バージョンは分類器内で一意の名前が必要
  # - 省略時、Terraform がランダムな一意の名前を割り当て
  # - 明示的に "" を設定すると、バージョン名なし
  # - 最大63文字
  # - 英大文字・小文字、数字、ハイフン(-)が使用可能
  # - version_name_prefix と競合
  # Type: string
  # version_name = "v1"

  # (オプション) 指定したプレフィックスで始まる一意のバージョン名を作成
  # - 最大37文字
  # - 英大文字・小文字、数字、ハイフン(-)が使用可能
  # - version_name と競合
  # Type: string
  # version_name_prefix = "classifier-"

  # (オプション) ジョブ処理中のストレージボリューム暗号化に使用する KMS キー
  # - KMS Key ID または KMS Key ARN を指定可能
  # Type: string
  # volume_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # ==========================================
  # 必須ブロック: input_data_config
  # ==========================================
  # (必須) トレーニングおよびテストデータの設定
  # - トレーニングデータの形式と場所を指定

  input_data_config {
    # (オプション) トレーニングデータの形式
    # - デフォルト: COMPREHEND_CSV
    # - 使用可能な値:
    #   - COMPREHEND_CSV: 標準的な CSV 形式
    #   - AUGMENTED_MANIFEST: Amazon SageMaker Ground Truth 形式
    # Type: string
    data_format = "COMPREHEND_CSV"

    # (オプション) 複数ラベル分類器のトレーニング時のラベル区切り文字
    # - デフォルト: |
    # - 使用可能な値: |, ~, !, @, #, $, %, ^, *, -, _, +, =, \, :, ;, >, ?, /, <space>, <tab>
    # - MULTI_LABEL モード時に使用
    # Type: string
    # label_delimiter = "|"

    # (オプション) トレーニングドキュメントの S3 URI
    # - data_format が COMPREHEND_CSV の場合に使用
    # Type: string
    s3_uri = "s3://my-bucket/training-data/documents.csv"

    # (オプション) テストドキュメントの S3 URI
    # - モデルの評価に使用
    # Type: string
    # test_s3_uri = "s3://my-bucket/test-data/documents.csv"

    # ==========================================
    # オプションブロック: augmented_manifests
    # ==========================================
    # (オプション) Amazon SageMaker Ground Truth が生成したトレーニングデータセット
    # - data_format が AUGMENTED_MANIFEST の場合に使用
    # - 複数指定可能

    # augmented_manifests {
    #   # (オプション) アノテーションファイルの S3 URI
    #   # Type: string
    #   # annotation_data_s3_uri = "s3://my-bucket/annotations/"
    #
    #   # (必須) トレーニングドキュメントのアノテーションを含む JSON 属性
    #   # Type: list(string)
    #   attribute_names = ["class"]
    #
    #   # (オプション) 拡張マニフェストのタイプ
    #   # - デフォルト: PLAIN_TEXT_DOCUMENT
    #   # - 使用可能な値:
    #   #   - PLAIN_TEXT_DOCUMENT: プレーンテキスト
    #   #   - SEMI_STRUCTURED_DOCUMENT: 半構造化ドキュメント
    #   # Type: string
    #   # document_type = "PLAIN_TEXT_DOCUMENT"
    #
    #   # (必須) 拡張マニフェストファイルの S3 URI
    #   # Type: string
    #   s3_uri = "s3://my-bucket/augmented-manifest/manifest.jsonl"
    #
    #   # (オプション) ソース PDF ファイルの S3 URI
    #   # - SEMI_STRUCTURED_DOCUMENT 使用時に指定
    #   # Type: string
    #   # source_documents_s3_uri = "s3://my-bucket/source-pdfs/"
    #
    #   # (オプション) 拡張マニフェスト内のデータの目的
    #   # - デフォルト: TRAIN
    #   # - 使用可能な値:
    #   #   - TRAIN: トレーニング用
    #   #   - TEST: テスト用
    #   # Type: string
    #   # split = "TRAIN"
    # }
  }

  # ==========================================
  # オプションブロック: output_data_config
  # ==========================================
  # (オプション) トレーニング結果の出力設定
  # - トレーニング結果の保存先を指定

  # output_data_config {
  #   # (オプション) 出力ドキュメントの暗号化に使用する KMS キー
  #   # - KMS Key ID、KMS Key ARN、KMS Alias 名、KMS Alias ARN を指定可能
  #   # Type: string
  #   # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  #
  #   # (必須) 出力ドキュメントの保存先パス
  #   # - 完全な出力ファイルパスは output_s3_uri 属性で取得可能
  #   # Type: string
  #   s3_uri = "s3://my-bucket/output/"
  # }

  # ==========================================
  # オプションブロック: vpc_config
  # ==========================================
  # (オプション) ドキュメント分類器リソースを含む VPC の設定パラメータ
  # - VPC 内でのプライベート処理が必要な場合に使用

  # vpc_config {
  #   # (必須) セキュリティグループ ID のリスト
  #   # - VPC 内でのネットワークアクセスを制御
  #   # Type: set(string)
  #   security_group_ids = [
  #     "sg-12345678",
  #     "sg-87654321",
  #   ]
  #
  #   # (必須) VPC サブネットのリスト
  #   # - 少なくとも2つの異なる Availability Zone のサブネットを推奨
  #   # Type: set(string)
  #   subnets = [
  #     "subnet-12345678",
  #     "subnet-87654321",
  #   ]
  # }

  # ==========================================
  # オプションブロック: timeouts
  # ==========================================
  # (オプション) リソース操作のタイムアウト設定

  # timeouts {
  #   # (オプション) 作成時のタイムアウト
  #   # - デフォルト: 60m
  #   # Type: string
  #   # create = "60m"
  #
  #   # (オプション) 更新時のタイムアウト
  #   # - デフォルト: 60m
  #   # Type: string
  #   # update = "60m"
  #
  #   # (オプション) 削除時のタイムアウト
  #   # - デフォルト: 30m
  #   # Type: string
  #   # delete = "30m"
  # }
}

# ==========================================
# 出力例 (Computed Attributes)
# ==========================================
# リソース作成後に参照可能な属性

# output "classifier_arn" {
#   description = "ドキュメント分類器バージョンの ARN"
#   value       = aws_comprehend_document_classifier.example.arn
# }
#
# output "classifier_id" {
#   description = "ドキュメント分類器の ID"
#   value       = aws_comprehend_document_classifier.example.id
# }
#
# output "output_s3_uri" {
#   description = "出力ドキュメントの完全パス (output_data_config 使用時)"
#   value       = aws_comprehend_document_classifier.example.output_data_config[0].output_s3_uri
# }
