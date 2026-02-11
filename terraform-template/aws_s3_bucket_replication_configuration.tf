#---------------------------------------------------------------
# S3 Bucket Replication Configuration
#---------------------------------------------------------------
#
# S3バケットのレプリケーション設定を管理するリソース。
# Cross-Region Replication (CRR)またはSame-Region Replication (SRR)を構成し、
# S3オブジェクトを異なるリージョンまたは同一リージョン内の別バケットに自動的にレプリケーションします。
#
# 主な用途:
# - コンプライアンス要件を満たすための地理的冗長性の確保
# - レイテンシー最小化のための複数リージョンでのデータ配置
# - ディザスタリカバリ対策
# - 異なるアカウント間でのデータ同期
#
# AWS公式ドキュメント:
#   - Replicating objects: https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html
#   - Replication requirements: https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-requirements.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_replication_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # bucket - (Required) レプリケーション元となるS3バケットの名前
  # Amazon S3が監視するソースバケットを指定します。
  # バケットにはバージョニングが有効化されている必要があります。
  bucket = "source-bucket-name"

  # role - (Required) レプリケーションに使用するIAMロールのARN
  # Amazon S3がオブジェクトをレプリケーションする際に使用するIAMロールのARNです。
  # このロールには、ソースバケットからの読み取りと宛先バケットへの書き込み権限が必要です。
  #
  # 必要な権限:
  # - s3:GetReplicationConfiguration (ソースバケット)
  # - s3:ListBucket (ソースバケット)
  # - s3:GetObjectVersionForReplication (ソースオブジェクト)
  # - s3:GetObjectVersionAcl (ソースオブジェクト)
  # - s3:GetObjectVersionTagging (ソースオブジェクト)
  # - s3:ReplicateObject (宛先バケット)
  # - s3:ReplicateDelete (宛先バケット)
  # - s3:ReplicateTags (宛先バケット)
  role = "arn:aws:iam::123456789012:role/replication-role"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # id - (Optional) リソースのID
  # 指定しない場合は自動的に計算されます。通常は明示的に設定する必要はありません。
  # id = "example-replication-config"

  # region - (Optional) このリソースが管理されるリージョン
  # 指定しない場合は、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # Provider Version 6以降で利用可能な機能です。
  # region = "us-east-1"

  # token - (Optional) Object Lockが有効なバケットでレプリケーションを許可するためのトークン
  # Object Lockが有効化されたバケットでレプリケーションを有効にする場合に必要です。
  # バケットの「Object Lock token」を取得するには、AWSサポートへの問い合わせが必要です。
  # 詳細: https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-managing.html#object-lock-managing-replication
  #
  # この値はsensitiveとして扱われます。
  # token = "example-token"

  #---------------------------------------------------------------
  # レプリケーションルール (Required)
  #---------------------------------------------------------------
  # rule - (Required) レプリケーションを管理するルールの設定ブロック
  # 最大1000個のルールを設定可能です。
  # 各ルールは、どのオブジェクトをどこにレプリケーションするかを定義します。

  rule {
    #---------------------------------------------------------------
    # rule - 必須パラメータ
    #---------------------------------------------------------------

    # status - (Required) ルールのステータス
    # "Enabled" または "Disabled" を指定します。
    # ステータスが "Enabled" でない場合、ルールは無視されます。
    status = "Enabled"

    #---------------------------------------------------------------
    # rule - オプションパラメータ
    #---------------------------------------------------------------

    # id - (Optional) ルールの一意な識別子
    # 255文字以内で指定する必要があります。
    # 指定しない場合は自動的に生成されます。
    id = "example-rule"

    # prefix - (Optional, Deprecated) ルールが適用されるオブジェクトキーのプレフィックス
    # 非推奨: filterとの併用はできません。新しい設定ではfilterの使用を推奨します。
    # 1024文字以内で指定する必要があります。
    # filterが指定されていない場合、デフォルトは空文字列("")です。
    # prefix = "documents/"

    # priority - (Optional) ルールに関連付けられた優先度
    # filterが設定されている場合にのみ設定すべきです。
    # 指定しない場合のデフォルトは0です。
    # 複数のルール間で優先度は一意である必要があります。
    priority = 1

    #---------------------------------------------------------------
    # destination - (Required) レプリケーション先の設定
    #---------------------------------------------------------------

    destination {
      #---------------------------------------------------------------
      # destination - 必須パラメータ
      #---------------------------------------------------------------

      # bucket - (Required) レプリケーション先のバケットARN
      # Amazon S3が結果を保存する先のバケットのARNを指定します。
      bucket = "arn:aws:s3:::destination-bucket-name"

      #---------------------------------------------------------------
      # destination - オプションパラメータ
      #---------------------------------------------------------------

      # account - (Optional) レプリカの所有権を指定するアカウントID
      # クロスアカウントシナリオ(ソースと宛先バケットの所有者が異なる場合)で、
      # レプリカの所有権を宛先バケットを所有するAWSアカウントに変更する場合に使用します。
      # access_control_translationと併用する必要があります。
      # account = "123456789012"

      # storage_class - (Optional) オブジェクトの保存に使用されるストレージクラス
      # デフォルトでは、Amazon S3はソースオブジェクトのストレージクラスを使用してレプリカを作成します。
      #
      # 有効な値:
      # - STANDARD
      # - REDUCED_REDUNDANCY
      # - STANDARD_IA
      # - ONEZONE_IA
      # - INTELLIGENT_TIERING
      # - GLACIER
      # - DEEP_ARCHIVE
      # - GLACIER_IR
      #
      # 詳細: https://docs.aws.amazon.com/AmazonS3/latest/API/API_Destination.html#AmazonS3-Type-Destination-StorageClass
      # storage_class = "STANDARD_IA"

      #---------------------------------------------------------------
      # access_control_translation - (Optional) レプリカの所有権オーバーライド設定
      #---------------------------------------------------------------
      # クロスアカウントシナリオで、レプリカの所有権を変更する場合に使用します。
      # accountパラメータと併用する必要があります。
      # 指定しない場合、レプリカはソースオブジェクトと同じAWSアカウントが所有します。

      # access_control_translation {
      #   # owner - (Required) レプリカの所有権を指定
      #   # 有効な値: "Destination"
      #   # 詳細: https://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketPUTreplication.html
      #   owner = "Destination"
      # }

      #---------------------------------------------------------------
      # encryption_configuration - (Optional) 暗号化に関する設定
      #---------------------------------------------------------------
      # source_selection_criteriaが指定されている場合は、この要素も指定する必要があります。

      # encryption_configuration {
      #   # replica_kms_key_id - (Required) 宛先バケット用のKMSキーのID
      #   # AWS Key Management Service (KMS)に保存されている顧客管理KMSキーのID(Key ARNまたはAlias ARN)です。
      #   replica_kms_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
      # }

      #---------------------------------------------------------------
      # metrics - (Optional) レプリケーションメトリクス設定
      #---------------------------------------------------------------
      # レプリケーションメトリクスとイベントを有効化する設定です。

      # metrics {
      #   # status - (Required) Destination Metricsのステータス
      #   # "Enabled" または "Disabled" を指定します。
      #   status = "Enabled"
      #
      #   # event_threshold - (Optional) s3:Replication:OperationMissedThresholdイベントを発行する時間閾値
      #   event_threshold {
      #     # minutes - (Required) 時間(分単位)
      #     # 有効な値: 15
      #     minutes = 15
      #   }
      # }

      #---------------------------------------------------------------
      # replication_time - (Optional) S3 Replication Time Control (S3 RTC)設定
      #---------------------------------------------------------------
      # S3 Replication Time Control (S3 RTC)を指定します。
      # すべてのオブジェクトとオブジェクトに対する操作を特定の時間内にレプリケーション完了させます。
      # metricsと併用する必要があります。

      # replication_time {
      #   # status - (Required) Replication Time Controlのステータス
      #   # "Enabled" または "Disabled" を指定します。
      #   status = "Enabled"
      #
      #   # time - (Required) レプリケーションを完了すべき時間の設定
      #   time {
      #     # minutes - (Required) 時間(分単位)
      #     # 有効な値: 15
      #     minutes = 15
      #   }
      # }
    }

    #---------------------------------------------------------------
    # delete_marker_replication - (Optional) 削除マーカーのレプリケーション設定
    #---------------------------------------------------------------
    # 削除マーカーをレプリケーションするかどうかを指定します。
    # この引数はV2レプリケーション設定(つまり、filterが使用されている場合)でのみ有効です。

    # delete_marker_replication {
    #   # status - (Required) 削除マーカーをレプリケーションするかどうか
    #   # "Enabled" または "Disabled" を指定します。
    #   status = "Enabled"
    # }

    #---------------------------------------------------------------
    # existing_object_replication - (Optional) 既存オブジェクトのレプリケーション設定
    #---------------------------------------------------------------
    # ルール設定に従って、ソースバケット内の既存オブジェクトをレプリケーションします。

    # existing_object_replication {
    #   # status - (Required) 既存オブジェクトをレプリケーションするかどうか
    #   # "Enabled" または "Disabled" を指定します。
    #   status = "Enabled"
    # }

    #---------------------------------------------------------------
    # filter - (Optional) レプリケーションルールが適用されるオブジェクトのフィルター
    #---------------------------------------------------------------
    # prefixとの併用はできません。
    # 指定しない場合、ルールはデフォルトでprefixを使用します。

    filter {
      # prefix - (Optional) ルールが適用されるオブジェクトキーのプレフィックス
      # 1024文字以内で指定する必要があります。
      prefix = "documents/"

      #---------------------------------------------------------------
      # and - (Optional) 複数のフィルター条件を指定する設定ブロック
      #---------------------------------------------------------------
      # 複数のフィルターを指定する場合にのみ必要です。

      # and {
      #   # prefix - (Optional) ルールが適用されるオブジェクトキーのプレフィックス
      #   # 1024文字以内で指定する必要があります。
      #   prefix = "documents/"
      #
      #   # tags - (Optional, prefixが設定されている場合は必須) ルールが適用されるオブジェクトを識別するタグのマップ
      #   # ルールは、タグセット内のすべてのタグを持つオブジェクトにのみ適用されます。
      #   tags = {
      #     Environment = "production"
      #     Department  = "engineering"
      #   }
      # }

      #---------------------------------------------------------------
      # tag - (Optional) タグのキーと値を指定する設定ブロック
      #---------------------------------------------------------------

      # tag {
      #   # key - (Required) オブジェクトキーの名前
      #   key = "Environment"
      #
      #   # value - (Required) タグの値
      #   value = "production"
      # }
    }

    #---------------------------------------------------------------
    # source_selection_criteria - (Optional) 特別なオブジェクト選択条件
    #---------------------------------------------------------------

    # source_selection_criteria {
    #   #---------------------------------------------------------------
    #   # replica_modifications - (Optional) レプリカに対する変更の選択設定
    #   #---------------------------------------------------------------
    #   # Amazon S3はデフォルトではレプリカの変更をレプリケーションしません。
    #   # 最新バージョンのレプリケーション設定(filterが指定されている場合)では、
    #   # この要素を指定してステータスをEnabledに設定することで、レプリカの変更をレプリケーションできます。
    #
    #   # replica_modifications {
    #   #   # status - (Required) レプリカの変更をレプリケーションするかどうか
    #   #   # "Enabled" または "Disabled" を指定します。
    #   #   status = "Enabled"
    #   # }
    #
    #   #---------------------------------------------------------------
    #   # sse_kms_encrypted_objects - (Optional) AWS KMSで暗号化されたS3オブジェクトのフィルター情報
    #   #---------------------------------------------------------------
    #   # 指定した場合、destinationのencryption_configurationでreplica_kms_key_idも指定する必要があります。
    #
    #   # sse_kms_encrypted_objects {
    #   #   # status - (Required) KMS暗号化オブジェクトをレプリケーションするかどうか
    #   #   # "Enabled" または "Disabled" を指定します。
    #   #   status = "Enabled"
    #   # }
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id - S3ソースバケット名
#
# これらの属性は computed のみであり、設定では指定できません。
#---------------------------------------------------------------
