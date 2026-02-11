# ============================================================================
# AWS Customer Profiles Domain - Annotated Template
# ============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: This template was generated at a specific point in time.
# Always refer to the official documentation for the most up-to-date information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customerprofiles_domain
# https://docs.aws.amazon.com/connect/latest/APIReference/API_connect-customer-profiles_CreateDomain.html
# ============================================================================

# Amazon Connect Customer Profiles ドメインを管理するリソース
# ドメインは、顧客プロファイル属性、オブジェクトタイプ、プロファイルキー、暗号化キーなど、
# すべての顧客データのコンテナとして機能します。
resource "aws_customerprofiles_domain" "example" {
  # ============================================================================
  # Required Arguments
  # ============================================================================

  # domain_name - ドメインの一意な名前
  # 型: string (required)
  # 制約: 1-64文字、英数字、ハイフン、アンダースコアのみ使用可能
  # 説明: AWS アカウント内で一意である必要があります
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_connect-customer-profiles_CreateDomain.html
  domain_name = "example-domain"

  # default_expiration_days - ドメイン内のデータが期限切れになるまでのデフォルトの日数
  # 型: number (required)
  # 制約: 1-1098 (約3年間)
  # 説明: ドメイン内のすべてのデータに適用されるデータ保持期間を定義します
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_connect-customer-profiles_CreateDomain.html
  default_expiration_days = 365

  # ============================================================================
  # Optional Arguments - Basic Configuration
  # ============================================================================

  # dead_letter_queue_url - SQSデッドレターキューのURL
  # 型: string (optional)
  # 制約: 0-255文字
  # 説明: サードパーティアプリケーションからのデータ取り込みに関連するエラーを報告するために使用されます
  #       SQSキューには、Customer Profilesサービスプリンシパルがメッセージを送信できるように
  #       適切なポリシーを設定する必要があります
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/enable-customer-profiles.html
  dead_letter_queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/customer-profiles-dlq"

  # default_encryption_key - デフォルトの暗号化キー
  # 型: string (optional)
  # 制約: 0-255文字
  # 説明: データが永続的または半永続的ストレージに配置される前に暗号化するために使用される
  #       AWS管理キーまたはカスタマー管理のKMSキーARNを指定できます
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/enable-customer-profiles.html
  default_encryption_key = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # region - このリソースが管理されるリージョン
  # 型: string (optional, computed)
  # 説明: 指定しない場合、プロバイダー設定で設定されたリージョンにデフォルト設定されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - ドメインに適用するタグ
  # 型: map(string) (optional)
  # 制約: 最大50個、キー1-128文字、値0-256文字
  # 説明: リソースの整理、追跡、またはアクセス制御に使用されます
  #       provider default_tags設定ブロックと併用可能です
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Application = "customer-profiles"
  }

  # ============================================================================
  # Optional Block: matching
  # ============================================================================
  # Machine Learning ベースの Identity Resolution を設定するブロック
  # enabled = true に設定すると、毎週のバッチプロセス(Identity Resolution Job)が開始され、
  # 重複プロファイルの検出とマージが行われます
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/enable-identity-resolution.html

  matching {
    # enabled - マッチングプロセスを有効化するフラグ
    # 型: bool (required)
    # 説明: trueに設定すると、毎週土曜日12AM UTCにIdentity Resolution Jobが実行されます
    enabled = true

    # --------------------------------------------------------------------------
    # Nested Block: auto_merging
    # --------------------------------------------------------------------------
    # 重複プロファイルの自動マージプロセスを設定するブロック
    # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/machine-learning-identity-resolution-customer-profiles.html

    auto_merging {
      # enabled - 自動マージを有効化するフラグ
      # 型: bool (required)
      # 説明: trueに設定すると、マッチング条件を満たすプロファイルが自動的にマージされます
      enabled = true

      # min_allowed_confidence_score_for_merging - マージに必要な最小信頼スコア
      # 型: number (optional)
      # 制約: 0.0-1.0の範囲
      # 説明: マッチンググループ内のプロファイルをマージするために必要な最小の信頼スコア
      #       高いスコアはマージに高い類似性が必要であることを意味します
      min_allowed_confidence_score_for_merging = 0.7

      # ------------------------------------------------------------------------
      # Nested Block: conflict_resolution
      # ------------------------------------------------------------------------
      # プロファイル間の競合を解決する方法を指定するブロック
      # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/how-identity-resolution-works.html

      conflict_resolution {
        # conflict_resolving_model - 競合解決モデル
        # 型: string (required)
        # 有効な値: "RECENCY" (最新のレコードを選択) または "SOURCE" (特定のデータソースを優先)
        # 説明: プロファイルマージ時の競合解決方法を指定します
        conflict_resolving_model = "RECENCY"

        # source_name - 競合解決に使用するObjectType名
        # 型: string (optional)
        # 説明: conflict_resolving_model = "SOURCE" の場合に使用されます
        #       特定のObjectTypeからのデータを優先します
        # source_name = "Salesforce-Account"
      }

      # ------------------------------------------------------------------------
      # Nested Block: consolidation
      # ------------------------------------------------------------------------
      # プロファイルをマージするための一致基準のリストを指定するブロック
      # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/how-identity-resolution-works.html

      consolidation {
        # matching_attributes_list - マッチング属性のリスト
        # 型: list(list(string)) (required)
        # 説明: 2つのプロファイルが一致属性リストの少なくとも1つの要件を満たす場合、
        #       それらはマージされます。各内部リストは1つのマッチング基準を表します
        matching_attributes_list = [
          ["Email", "PhoneNumber"],
          ["FirstName", "LastName", "Address"]
        ]
      }
    }

    # --------------------------------------------------------------------------
    # Nested Block: exporting_config
    # --------------------------------------------------------------------------
    # Identity Resolution Jobの結果をエクスポートする設定

    exporting_config {
      # ------------------------------------------------------------------------
      # Nested Block: s3_exporting
      # ------------------------------------------------------------------------
      # S3へのエクスポート設定

      s3_exporting {
        # s3_bucket_name - 結果ファイルを書き込むS3バケット名
        # 型: string (required)
        # 説明: Identity Resolution Jobの結果が保存されるS3バケット
        #       バケットには適切なポリシーが必要です
        s3_bucket_name = "customer-profiles-results"

        # s3_key_name - 結果ファイルのS3キー名(プレフィックス)
        # 型: string (optional)
        # 説明: 結果ファイルの保存先パスを指定します
        s3_key_name = "identity-resolution/results"
      }
    }

    # --------------------------------------------------------------------------
    # Nested Block: job_schedule
    # --------------------------------------------------------------------------
    # Identity Resolution Jobの実行スケジュールを設定するブロック

    job_schedule {
      # day_of_the_week - Identity Resolution Jobを実行する曜日
      # 型: string (required)
      # 有効な値: SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
      # 説明: 毎週この曜日にジョブが実行されます
      day_of_the_week = "SUNDAY"

      # time - Identity Resolution Jobを実行する時刻
      # 型: string (required)
      # 形式: HH:MM (24時間形式)
      # 説明: 指定された曜日のこの時刻にジョブが実行されます
      time = "02:00"
    }
  }

  # ============================================================================
  # Optional Block: rule_based_matching
  # ============================================================================
  # ルールベースマッチングを使用した重複プロファイルの照合プロセスを設定するブロック
  # ML-basedマッチングとは異なり、ユーザー定義のルールに基づいてプロファイルをマッチングします
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/enable-identity-resolution.html

  rule_based_matching {
    # enabled - ルールベースマッチングを有効化するフラグ
    # 型: bool (required)
    # 説明: trueに設定すると、RuleBasedMatchingRequestの設定に従って
    #       プロファイルのマッチングとマージが開始されます
    enabled = true

    # max_allowed_rule_level_for_matching - マッチングに許可される最大ルールレベル
    # 型: number (optional)
    # 説明: マッチング時に評価される最大のルールレベルを指定します
    max_allowed_rule_level_for_matching = 3

    # max_allowed_rule_level_for_merging - マージに許可される最大ルールレベル
    # 型: number (optional)
    # 説明: マージ時に使用される最大のルールレベルを指定します
    max_allowed_rule_level_for_merging = 2

    # --------------------------------------------------------------------------
    # Nested Block: attribute_types_selector
    # --------------------------------------------------------------------------
    # ルールベースのIdentity Resolutionがプロファイルをマッチングするために使用する
    # 属性タイプを設定するブロック

    attribute_types_selector {
      # attribute_matching_model - 属性マッチングモデル
      # 型: string (required)
      # 有効な値: "ONE_TO_ONE" または "MANY_TO_MANY"
      # 説明: ONE_TO_ONE - 1対1のマッチング
      #       MANY_TO_MANY - 多対多のマッチング
      attribute_matching_model = "ONE_TO_ONE"

      # address - 住所タイプのリスト
      # 型: list(string) (optional)
      # 有効な値: "Address", "BusinessAddress", "MailingAddress", "ShippingAddress"
      # 説明: マッチングに使用する住所タイプを指定します
      address = ["Address", "BusinessAddress"]

      # email_address - メールアドレスタイプのリスト
      # 型: list(string) (optional)
      # 有効な値: "EmailAddress", "BusinessEmailAddress", "PersonalEmailAddress"
      # 説明: マッチングに使用するメールアドレスタイプを指定します
      email_address = ["EmailAddress", "PersonalEmailAddress"]

      # phone_number - 電話番号タイプのリスト
      # 型: list(string) (optional)
      # 有効な値: "PhoneNumber", "HomePhoneNumber", "MobilePhoneNumber"
      # 説明: マッチングに使用する電話番号タイプを指定します
      phone_number = ["PhoneNumber", "MobilePhoneNumber"]
    }

    # --------------------------------------------------------------------------
    # Nested Block: conflict_resolution
    # --------------------------------------------------------------------------
    # プロファイル間の競合を解決する方法を指定するブロック

    conflict_resolution {
      # conflict_resolving_model - 競合解決モデル
      # 型: string (required)
      # 有効な値: "RECENCY" または "SOURCE"
      # 説明: ルールベースマッチングでの競合解決方法を指定します
      conflict_resolving_model = "RECENCY"

      # source_name - 競合解決に使用するObjectType名
      # 型: string (optional)
      # 説明: conflict_resolving_model = "SOURCE" の場合に必要です
      # source_name = "Zendesk-User"
    }

    # --------------------------------------------------------------------------
    # Nested Block: exporting_config
    # --------------------------------------------------------------------------
    # ルールベースマッチング結果をエクスポートする設定

    exporting_config {
      # ------------------------------------------------------------------------
      # Nested Block: s3_exporting
      # ------------------------------------------------------------------------
      s3_exporting {
        # s3_bucket_name - 結果ファイルを書き込むS3バケット名
        # 型: string (required)
        s3_bucket_name = "customer-profiles-rule-based-results"

        # s3_key_name - 結果ファイルのS3キー名(プレフィックス)
        # 型: string (optional)
        s3_key_name = "rule-based-matching/results"
      }
    }

    # --------------------------------------------------------------------------
    # Nested Block: matching_rules (set)
    # --------------------------------------------------------------------------
    # ルールベースマッチングプロセスがプロファイルをマッチングする方法を設定するブロック
    # 最大15個のルールを指定できます

    matching_rules {
      # rule - マッチングルールの定義
      # 型: list(string) (required)
      # 説明: ルールベースマッチングのルールを定義します
      #       各文字列は属性名を表し、これらの属性が一致する場合にプロファイルがマッチします
      rule = ["EmailAddress"]
    }

    matching_rules {
      rule = ["PhoneNumber", "LastName"]
    }

    matching_rules {
      rule = ["FirstName", "LastName", "Address"]
    }
  }
}

# ============================================================================
# Computed Attributes (参考情報 - 設定不要)
# ============================================================================
# 以下の属性は Terraform によって自動的に計算され、output で参照可能です:
#
# - arn (string): Customer Profiles Domain の Amazon Resource Name (ARN)
#   例: aws_customerprofiles_domain.example.arn
#
# - id (string): Customer Profiles Domain の識別子
#   例: aws_customerprofiles_domain.example.id
#
# - tags_all (map(string)): プロバイダーの default_tags から継承されたものを含む、
#   リソースに割り当てられたすべてのタグのマップ
#   例: aws_customerprofiles_domain.example.tags_all
# ============================================================================
