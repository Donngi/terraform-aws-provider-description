#---------------------------------------------------------------
# AWS CloudTrail Event Data Store
#---------------------------------------------------------------
#
# AWS CloudTrail Event Data Storeをプロビジョニングするリソースです。
# Event Data Storeは、CloudTrailイベントを保存・検索するためのデータストアであり、
# CloudTrail Lakeクエリ機能により、長期保管されたイベントに対してSQLライクな
# クエリを実行できます。
#
# AWS公式ドキュメント:
#   - Event Data Store User Guide: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/query-event-data-store.html
#   - CreateEventDataStore API: https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_CreateEventDataStore.html
#   - CloudTrail Lake: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-lake.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail_event_data_store
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudtrail_event_data_store" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Event Data Storeの名前を指定します。
  # 設定可能な値: 3-128文字の英数字、ドット、ハイフン、アンダースコア
  # パターン: ^[a-zA-Z0-9._\-]+$
  # 参考: https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_CreateEventDataStore.html
  name = "example-event-data-store"

  #-------------------------------------------------------------
  # 課金設定
  #-------------------------------------------------------------

  # billing_mode (Optional)
  # 設定内容: Event Data Storeの課金モードを指定します。
  # 設定可能な値:
  #   - "EXTENDABLE_RETENTION_PRICING" (デフォルト): 柔軟な保持期間（最大3653日/約10年）に対応。デフォルト保持期間は366日
  #   - "FIXED_RETENTION_PRICING": 月間25TB以上のイベント取り込みが想定される場合に推奨。最大2557日（約7年）の保持期間。デフォルト保持期間は2557日
  # 関連機能: CloudTrail Lake Pricing
  #   課金モードによりイベント取り込みコストと保持期間の上限・デフォルト値が決まります。
  #   - https://aws.amazon.com/cloudtrail/pricing/
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-lake-manage-costs.html
  billing_mode = "EXTENDABLE_RETENTION_PRICING"

  #-------------------------------------------------------------
  # 保持期間設定
  #-------------------------------------------------------------

  # retention_period (Optional)
  # 設定内容: イベントデータの保持期間を日数で指定します。
  # 設定可能な値:
  #   - billing_mode が "EXTENDABLE_RETENTION_PRICING" の場合: 7-3653日（最大約10年）
  #   - billing_mode が "FIXED_RETENTION_PRICING" の場合: 7-2557日（最大約7年）
  # 省略時: billing_modeに応じたデフォルト値（EXTENDABLE: 366日、FIXED: 2557日）
  # 関連機能: CloudTrail Lake Retention
  #   CloudTrail LakeはイベントのeventTimeが保持期間を超えたものを自動削除します。
  #   Trailイベントをコピーする場合、既存イベントの経過期間も考慮してください。
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_CreateEventDataStore.html
  retention_period = 366

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # multi_region_enabled (Optional)
  # 設定内容: 全リージョンのイベントを収集するか、作成リージョンのみかを指定します。
  # 設定可能な値:
  #   - true: 全リージョンのイベントを収集
  #   - false: Event Data Storeが作成されたリージョンのみのイベントを収集
  # 省略時: false
  # 関連機能: Multi-Region Event Data Store
  #   組織全体やグローバルなリソースの可視性を向上させる場合に有効化します。
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/userguide/query-event-data-store.html
  multi_region_enabled = true

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 組織設定
  #-------------------------------------------------------------

  # organization_enabled (Optional)
  # 設定内容: AWS Organizations組織全体のイベントを収集するかを指定します。
  # 設定可能な値:
  #   - true: 組織内の全アカウントのイベントを収集
  #   - false: 現在のアカウントのみのイベントを収集
  # 省略時: false
  # 注意: 組織Event Data Storeは管理アカウントで作成する必要があります。
  # 関連機能: Organization Event Data Store
  #   AWS Organizations全体の監査ログを一元管理する場合に有効化します。
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/userguide/query-event-data-store.html
  organization_enabled = false

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: イベントデータの暗号化に使用するAWS KMSキーIDを指定します。
  # 設定可能な値:
  #   - エイリアス名（例: alias/MyAliasName）
  #   - エイリアスARN（例: arn:aws:kms:us-east-2:123456789012:alias/MyAliasName）
  #   - キーARN（例: arn:aws:kms:us-east-2:123456789012:key/12345678-1234-1234-1234-123456789012）
  #   - キーID（例: 12345678-1234-1234-1234-123456789012）
  # 長さ制約: 1-350文字
  # パターン: ^[a-zA-Z0-9._/\-:]+$
  # 関連機能: CloudTrail Encryption with KMS
  #   KMSキーで暗号化することで、データの機密性を向上させます。
  #   KMSキーの無効化・削除・権限削除を行うと、イベントのログ記録とクエリができなくなります。
  #   Event Data Store作成後のKMSキー変更・削除はできません。
  #   マルチリージョンキーもサポートされています。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/multi-region-keys-overview.html
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # termination_protection_enabled (Optional)
  # 設定内容: Event Data Storeの削除保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化。明示的に無効化するまで削除できません
  #   - false: 削除保護を無効化
  # 省略時: false
  # 関連機能: Termination Protection
  #   監査ログやコンプライアンス要件のあるデータを保護する場合に有効化します。
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_CreateEventDataStore.html
  termination_protection_enabled = true

  #-------------------------------------------------------------
  # 取り込み制御
  #-------------------------------------------------------------

  # suspend (Optional)
  # 設定内容: イベントの取り込みを一時停止するかを指定します。
  # 設定可能な値: 文字列形式（詳細はドキュメント参照）
  # 関連機能: Stop and Start Event Ingestion
  #   Event Data Storeへのイベント取り込みを停止・再開できます。
  #   停止中もクエリは実行可能です。
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/userguide/query-eds-stop-ingestion.html
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/userguide/lake-cli-manage-eds.html
  suspend = null

  #-------------------------------------------------------------
  # Terraform固有設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: Terraformリソースの識別子（通常は自動設定されます）
  # 省略時: name属性の値が使用されます
  id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: Event Data Storeに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大200個）
  # 関連機能: Resource Tagging
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、このリソースで定義されたものが優先されます。
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_Tag.html
  tags = {
    Name        = "example-event-data-store"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む全タグのマップ
  # 省略時: tags属性とプロバイダーのdefault_tagsがマージされます
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  #-------------------------------------------------------------
  # 高度なイベントセレクター
  #-------------------------------------------------------------

  # advanced_event_selector (Optional)
  # 設定内容: Event Data Storeに記録するイベントを詳細に選択するための設定です。
  # 最大5個まで設定可能です。
  # 関連機能: Advanced Event Selectors
  #   管理イベント、データイベント、ネットワークアクティビティイベントを細かく制御できます。
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-data-events-with-cloudtrail.html#creating-data-event-selectors-advanced
  #   - https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_AdvancedEventSelector.html
  advanced_event_selector {
    # name (Optional, Computed)
    # 設定内容: 高度なイベントセレクターの説明的な名前を指定します。
    # 設定可能な値: 0-1000文字の文字列
    # 省略時: 自動生成されます
    name = "Log all management events"

    # field_selector (Required)
    # 設定内容: イベントを選択するためのフィールド条件を指定します。
    # 最低1個以上必要です。
    # サポートされるフィールド（管理イベント）:
    #   - eventCategory (必須)
    #   - eventSource
    #   - eventName (Event Data Storeのみ)
    #   - eventType (Event Data Storeのみ)
    #   - readOnly
    #   - sessionCredentialFromConsole (Event Data Storeのみ)
    #   - userIdentity.arn (Event Data Storeのみ)
    # サポートされるフィールド（データイベント）:
    #   - eventCategory (必須)
    #   - eventName
    #   - eventSource
    #   - eventType
    #   - resources.ARN
    #   - resources.type (必須)
    #   - readOnly
    #   - sessionCredentialFromConsole
    #   - userIdentity.arn
    # サポートされるフィールド（ネットワークアクティビティイベント）:
    #   - eventCategory (必須)
    #   - eventSource (必須)
    #   - eventName
    #   - errorCode（有効値: VpceAccessDenied）
    #   - vpcEndpointId
    # 参考: https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_AdvancedFieldSelector.html
    field_selector {
      # field (Optional, Computed)
      # 設定内容: 選択条件に使用するイベントフィールドを指定します。
      # 設定可能な値: 上記のサポートされるフィールド名
      field = "eventCategory"

      # equals (Optional, Computed)
      # 設定内容: フィールド値と完全一致する値のリストを指定します。
      # 設定可能な値: 文字列のリスト
      equals = ["Management"]

      # starts_with (Optional, Computed)
      # 設定内容: フィールド値が指定した文字列で始まるものを選択します。
      # 設定可能な値: 文字列のリスト
      starts_with = null

      # ends_with (Optional, Computed)
      # 設定内容: フィールド値が指定した文字列で終わるものを選択します。
      # 設定可能な値: 文字列のリスト
      ends_with = null

      # not_equals (Optional, Computed)
      # 設定内容: フィールド値と一致しないものを選択します。
      # 設定可能な値: 文字列のリスト
      not_equals = null

      # not_starts_with (Optional, Computed)
      # 設定内容: フィールド値が指定した文字列で始まらないものを選択します。
      # 設定可能な値: 文字列のリスト
      not_starts_with = null

      # not_ends_with (Optional, Computed)
      # 設定内容: フィールド値が指定した文字列で終わらないものを選択します。
      # 設定可能な値: 文字列のリスト
      not_ends_with = null
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraformリソース操作のタイムアウト時間を設定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Event Data StoreのAmazon Resource Name (ARN)
#
# - document_service_endpoint: Event Data Storeのドキュメントサービスエンドポイント
#
# - domain_id: Event Data StoreのドメインID
#
# - search_service_endpoint: Event Data Storeの検索サービスエンドポイント
#
#---------------------------------------------------------------
