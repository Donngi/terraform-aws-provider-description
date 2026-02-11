################################################################################
# AWS Comprehend Entity Recognizer
################################################################################
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# Note: このテンプレートは生成時点でのAWS Provider仕様に基づいています。
# 最新の仕様については公式ドキュメントを参照してください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/comprehend_entity_recognizer
################################################################################

resource "aws_comprehend_entity_recognizer" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # (Required) 名前
  # Amazon Comprehend Entity Recognizerの名前を指定します。
  # 最大63文字まで。大文字・小文字の英字、数字、ハイフン（-）が使用可能。
  # アカウント/リージョン内で一意である必要があります。
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
  name = "example-entity-recognizer"

  # (Required) データアクセスロールARN
  # Amazon ComprehendがトレーニングデータやテストデータにアクセスするためのIAMロールのARNを指定します。
  # S3バケットへの読み取り権限が必要です。
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
  data_access_role_arn = "arn:aws:iam::123456789012:role/comprehend-data-access-role"

  # (Required) 言語コード
  # エンティティ認識に使用する言語を2文字の言語コードで指定します。
  # 指定可能な値: en, es, fr, it, de, pt
  # PDF、Word、または画像ファイルを入力に使用する場合は英語（en）を指定する必要があります。
  # すべてのトレーニングドキュメントは同じ言語である必要があります。
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
  language_code = "en"

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # (Optional) モデル暗号化KMSキーID
  # トレーニング済みカスタムモデルの暗号化に使用するKMSキーのIDまたはARNを指定します。
  # KMSキーID形式: "1234abcd-12ab-34cd-56ef-1234567890ab"
  # ARN形式: "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
  model_kms_key_id = null

  # (Optional) リージョン
  # このリソースを管理するリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) タグ
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックと組み合わせて使用できます。
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/comprehend_entity_recognizer#tags
  tags = {
    Environment = "development"
    Project     = "ml-pipeline"
  }

  # (Optional) すべてのタグ（computed）
  # プロバイダーのdefault_tagsを含む、リソースに割り当てられたすべてのタグ。
  # このフィールドはcomputed属性のため、通常は設定しません。
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/comprehend_entity_recognizer#tags_all
  # tags_all = {}

  # (Optional) バージョン名
  # Entity Recognizerのバージョン名を指定します。
  # 各バージョンは、同じEntity Recognizer内で一意の名前を持つ必要があります。
  # 省略した場合、Terraformはランダムで一意なバージョン名を割り当てます。
  # 明示的に""（空文字）を設定すると、バージョン名は設定されません。
  # 最大63文字。大文字・小文字の英字、数字、ハイフン（-）が使用可能。
  # version_name_prefixとは競合します。
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
  version_name = "v1"

  # (Optional) バージョン名プレフィックス
  # 指定されたプレフィックスで始まる一意のバージョン名を作成します。
  # 最大37文字。大文字・小文字の英字、数字、ハイフン（-）が使用可能。
  # version_nameとは競合します。
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
  # version_name_prefix = "v1-"

  # (Optional) ボリューム暗号化KMSキーID
  # ジョブ処理中にMLコンピューティングインスタンスに接続されたストレージボリュームを暗号化するためのKMSキーのIDまたはARNを指定します。
  # KMSキーID形式: "1234abcd-12ab-34cd-56ef-1234567890ab"
  # ARN形式: "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
  volume_kms_key_id = null

  # ================================================================================
  # input_data_config Block (Required)
  # ================================================================================
  # トレーニングデータとテストデータの設定を指定します。
  # 入力データを含むS3バケットは、作成されるEntity Recognizerと同じリージョンに配置する必要があります。
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityRecognizerInputDataConfig.html

  input_data_config {
    # (Optional) データフォーマット
    # トレーニングデータのフォーマットを指定します。
    # 指定可能な値: COMPREHEND_CSV, AUGMENTED_MANIFEST
    # デフォルト: COMPREHEND_CSV
    # https://docs.aws.amazon.com/comprehend/latest/dg/prep-training-data-cer.html
    data_format = "COMPREHEND_CSV"

    # --------------------------------------------------------------------------------
    # entity_types Block (Required, Min: 1, Max: 25)
    # --------------------------------------------------------------------------------
    # 認識するエンティティタイプのセットを定義します。
    # 最大25個まで指定可能。
    # https://docs.aws.amazon.com/comprehend/latest/dg/custom-entity-recognition.html

    entity_types {
      # (Required) エンティティタイプ
      # Entity Recognizerによってマッチングされるエンティティタイプを指定します。
      # 改行（\n）、キャリッジリターン（\r）、タブ（\t）を含めることはできません。
      # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityTypesListItem.html
      type = "ENTITY_1"
    }

    entity_types {
      type = "ENTITY_2"
    }

    # --------------------------------------------------------------------------------
    # documents Block (Optional, Max: 1)
    # --------------------------------------------------------------------------------
    # トレーニングドキュメントのコレクションを指定します。
    # data_formatがCOMPREHEND_CSVの場合に使用します。
    # https://docs.aws.amazon.com/comprehend/latest/dg/prep-training-data-cer.html

    documents {
      # (Required) S3 URI
      # トレーニングドキュメントの場所を指定します。
      # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityRecognizerDocuments.html
      s3_uri = "s3://example-bucket/training-documents/"

      # (Optional) 入力フォーマット
      # 入力ファイルの処理方法を指定します。
      # 指定可能な値: ONE_DOC_PER_LINE, ONE_DOC_PER_FILE
      # デフォルト: ONE_DOC_PER_LINE
      # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityRecognizerDocuments.html
      input_format = "ONE_DOC_PER_LINE"

      # (Optional) テストS3 URI
      # テストドキュメントの場所を指定します。
      # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityRecognizerDocuments.html
      test_s3_uri = "s3://example-bucket/test-documents/"
    }

    # --------------------------------------------------------------------------------
    # entity_list Block (Optional, Max: 1)
    # --------------------------------------------------------------------------------
    # エンティティリストデータの場所を指定します。
    # annotationsまたはentity_listのいずれかが必須です。
    # https://docs.aws.amazon.com/comprehend/latest/dg/prep-training-data-cer.html

    entity_list {
      # (Required) S3 URI
      # エンティティリストの場所を指定します。
      # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityRecognizerEntityList.html
      s3_uri = "s3://example-bucket/entity-list.csv"
    }

    # --------------------------------------------------------------------------------
    # annotations Block (Optional, Max: 1)
    # --------------------------------------------------------------------------------
    # ドキュメントアノテーションデータの場所を指定します。
    # annotationsまたはentity_listのいずれかが必須です。
    # アノテーションは、ドキュメント内のエンティティの位置とコンテキストを提供し、より正確なモデルトレーニングを可能にします。
    # https://docs.aws.amazon.com/comprehend/latest/dg/prep-training-data-cer.html

    # annotations {
    #   # (Required) S3 URI
    #   # トレーニングアノテーションの場所を指定します。
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityRecognizerAnnotations.html
    #   s3_uri = "s3://example-bucket/annotations/"
    #
    #   # (Optional) テストS3 URI
    #   # テストアノテーションの場所を指定します。
    #   # テストデータセットには、作成リクエストで指定された各エンティティタイプに対して少なくとも1つのアノテーションが含まれている必要があります。
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_EntityRecognizerAnnotations.html
    #   test_s3_uri = "s3://example-bucket/test-annotations/"
    # }

    # --------------------------------------------------------------------------------
    # augmented_manifests Block (Optional)
    # --------------------------------------------------------------------------------
    # Amazon SageMaker Ground Truthによって生成されたトレーニングデータセットのリストを指定します。
    # data_formatがAUGMENTED_MANIFESTの場合に使用します。
    # https://docs.aws.amazon.com/comprehend/latest/dg/prep-training-data-cer.html

    # augmented_manifests {
    #   # (Required) S3 URI
    #   # 拡張マニフェストファイルの場所を指定します。
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_AugmentedManifestsListItem.html
    #   s3_uri = "s3://example-bucket/augmented-manifest.jsonl"
    #
    #   # (Required) 属性名
    #   # トレーニングドキュメントのアノテーションを含むJSON属性を指定します。
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_AugmentedManifestsListItem.html
    #   attribute_names = ["entity"]
    #
    #   # (Optional) アノテーションデータS3 URI
    #   # アノテーションファイルの場所を指定します。
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_AugmentedManifestsListItem.html
    #   annotation_data_s3_uri = "s3://example-bucket/annotation-data/"
    #
    #   # (Optional) ドキュメントタイプ
    #   # 拡張マニフェストのタイプを指定します。
    #   # 指定可能な値: PLAIN_TEXT_DOCUMENT, SEMI_STRUCTURED_DOCUMENT
    #   # デフォルト: PLAIN_TEXT_DOCUMENT
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_AugmentedManifestsListItem.html
    #   document_type = "PLAIN_TEXT_DOCUMENT"
    #
    #   # (Optional) ソースドキュメントS3 URI
    #   # ソースPDFファイルの場所を指定します。
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_AugmentedManifestsListItem.html
    #   source_documents_s3_uri = "s3://example-bucket/source-documents/"
    #
    #   # (Optional) スプリット
    #   # 拡張マニフェスト内のデータの目的を指定します。
    #   # 指定可能な値: TRAIN, TEST
    #   # デフォルト: TRAIN
    #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_AugmentedManifestsListItem.html
    #   split = "TRAIN"
    # }
  }

  # ================================================================================
  # vpc_config Block (Optional)
  # ================================================================================
  # Entity Recognizerリソースを含むVPCの設定パラメータを指定します。
  # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_VpcConfig.html

  # vpc_config {
  #   # (Required) セキュリティグループID
  #   # セキュリティグループIDのリストを指定します。
  #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_VpcConfig.html
  #   security_group_ids = ["sg-12345678"]
  #
  #   # (Required) サブネット
  #   # VPCサブネットのリストを指定します。
  #   # https://docs.aws.amazon.com/comprehend/latest/APIReference/API_VpcConfig.html
  #   subnets = ["subnet-12345678", "subnet-87654321"]
  # }

  # ================================================================================
  # timeouts Block (Optional)
  # ================================================================================
  # リソースの作成、更新、削除のタイムアウト設定を指定します。

  # timeouts {
  #   # (Optional) 作成タイムアウト
  #   # リソースの作成にかかる最大時間を指定します。
  #   # デフォルトは60分です。
  #   create = "60m"
  #
  #   # (Optional) 更新タイムアウト
  #   # リソースの更新にかかる最大時間を指定します。
  #   # デフォルトは60分です。
  #   update = "60m"
  #
  #   # (Optional) 削除タイムアウト
  #   # リソースの削除にかかる最大時間を指定します。
  #   # デフォルトは30分です。
  #   delete = "30m"
  # }
}

################################################################################
# Outputs
################################################################################

# ARN
# Entity Recognizerバージョンのアマゾンリソースネーム（ARN）
# https://docs.aws.amazon.com/comprehend/latest/APIReference/API_CreateEntityRecognizer.html
output "entity_recognizer_arn" {
  description = "ARN of the Comprehend Entity Recognizer"
  value       = aws_comprehend_entity_recognizer.example.arn
}
