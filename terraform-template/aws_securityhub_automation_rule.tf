#---------------------------------------------------------------
# AWS Security Hub Automation Rule
#---------------------------------------------------------------
#
# AWS Security Hubの自動化ルールをプロビジョニングするリソースです。
# 自動化ルールを使用することで、指定された条件に一致するFindingに対して、
# フィールド更新やサードパーティ統合へのチケット作成などのアクションを
# 自動的に実行できます。
#
# AWS公式ドキュメント:
#   - Automation rules in Security Hub: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-v2-automation-rules.html
#   - Creating automation rules: https://docs.aws.amazon.com/securityhub/latest/userguide/securithub-v2-automation-rules-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_automation_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securityhub_automation_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # rule_name (Required)
  # 設定内容: 自動化ルールの名前を指定します。
  # 設定可能な値: 文字列
  # 用途: ルールを識別するための名称
  rule_name = "Elevate severity of findings that relate to important resources"

  # description (Required)
  # 設定内容: 自動化ルールの説明を指定します。
  # 設定可能な値: 文字列
  # 用途: ルールの目的や条件を説明
  description = "Elevate finding severity to CRITICAL when specific resources such as an S3 bucket is at risk"

  # rule_order (Required)
  # 設定内容: ルールの適用順序を指定します。
  # 設定可能な値: 1から1000の整数
  # 注意: 複数のルールが同じFindingに適用される場合、数値が低いルールから順に適用されます。
  #       最も高い数値を持つルールのアクションが最終的な値を決定します。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-v2-automation-rules.html#automation-rules-order
  rule_order = 1

  #-------------------------------------------------------------
  # ルールステータス設定
  #-------------------------------------------------------------

  # rule_status (Optional)
  # 設定内容: ルール作成後にルールをアクティブにするかを指定します。
  # 設定可能な値:
  #   - "ENABLED": ルールを有効化
  #   - "DISABLED": ルールを無効化
  # 省略時: デフォルトで有効化されます
  rule_status = "ENABLED"

  # is_terminal (Optional)
  # 設定内容: このルールがFindingに適用される最後のルールであるかを指定します。
  # 設定可能な値:
  #   - true: このルールの後に他のルールを適用しない
  #   - false (デフォルト): このルールの後に他のルールも適用する
  # 省略時: false
  # 注意: trueに設定した場合、rule_orderがより高いルールがあってもそれらは適用されません
  is_terminal = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-automation-rule"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # actions (Required)
  # 設定内容: Findingが条件に一致した場合に実行するアクションを指定します。
  # 注意: 複数のactionsブロックを定義可能
  actions {
    # type (Optional)
    # 設定内容: アクションのタイプを指定します。
    # 設定可能な値:
    #   - "FINDING_FIELDS_UPDATE": Findingのフィールドを更新
    type = "FINDING_FIELDS_UPDATE"

    # finding_fields_update (Optional)
    # 設定内容: Findingのフィールド更新内容を指定します。
    finding_fields_update {
      # confidence (Optional)
      # 設定内容: Findingの信頼度スコアを更新します。
      # 設定可能な値: 0から100の数値（0: 0%の信頼度、100: 100%の信頼度）
      confidence = null

      # criticality (Optional)
      # 設定内容: Findingに関連するリソースの重要度レベルを更新します。
      # 設定可能な値: 数値
      criticality = null

      # types (Optional)
      # 設定内容: Findingのタイプを更新します。
      # 設定可能な値: Findingタイプの文字列リスト
      #   形式: "namespace/category/classifier"
      types = ["Software and Configuration Checks/Industry and Regulatory Standards"]

      # user_defined_fields (Optional)
      # 設定内容: ユーザー定義フィールドを更新します。
      # 設定可能な値: キーと値のペアのマップ
      user_defined_fields = {
        key = "value"
      }

      # verification_state (Optional)
      # 設定内容: Findingの検証状態を更新します。
      # 設定可能な値:
      #   - "UNKNOWN": 不明
      #   - "TRUE_POSITIVE": 真陽性
      #   - "FALSE_POSITIVE": 偽陽性
      #   - "BENIGN_POSITIVE": 良性陽性
      verification_state = null

      # note (Optional)
      # 設定内容: Findingに追加するノートを指定します。
      note {
        # text (Required)
        # 設定内容: ノートのテキスト内容を指定します。
        # 設定可能な値: 文字列
        text = "This is a critical resource. Please review ASAP."

        # updated_by (Required)
        # 設定内容: ノートを更新したプリンシパルを指定します。
        # 設定可能な値: 文字列
        updated_by = "sechub-automation"
      }

      # related_findings (Optional)
      # 設定内容: 関連するFindingを指定します。
      # 注意: 複数のrelated_findingsブロックを定義可能
      # related_findings {
      #   # id (Required)
      #   # 設定内容: 関連するFindingのプロダクト固有の識別子を指定します。
      #   # 設定可能な値: 文字列
      #   id = "arn:aws:securityhub:us-east-1:123456789012:subscription/cis-aws-foundations-benchmark/v/1.2.0/1.1/finding/12345678-1234-1234-1234-123456789012"
      #
      #   # product_arn (Required)
      #   # 設定内容: 関連するFindingを生成したプロダクトのARNを指定します。
      #   # 設定可能な値: プロダクトARN文字列
      #   product_arn = "arn:aws:securityhub:us-east-1::product/aws/securityhub"
      # }

      # severity (Optional)
      # 設定内容: Findingの深刻度情報を更新します。
      severity {
        # label (Optional)
        # 設定内容: Findingの深刻度ラベルを指定します。
        # 設定可能な値:
        #   - "INFORMATIONAL": 情報
        #   - "LOW": 低
        #   - "MEDIUM": 中
        #   - "HIGH": 高
        #   - "CRITICAL": 重大
        label = "CRITICAL"

        # product (Optional)
        # 設定内容: AWSサービスまたは統合パートナープロダクトによって定義されたネイティブの深刻度を指定します。
        # 設定可能な値: 文字列
        product = "0.0"
      }

      # workflow (Optional)
      # 設定内容: Findingの調査ステータスに関する情報を更新します。
      # workflow {
      #   # status (Optional)
      #   # 設定内容: ワークフローステータスを指定します。
      #   # 設定可能な値:
      #   #   - "NEW": 新規
      #   #   - "NOTIFIED": 通知済み
      #   #   - "RESOLVED": 解決済み
      #   #   - "SUPPRESSED": 抑制済み
      #   status = "NOTIFIED"
      # }
    }
  }

  #-------------------------------------------------------------
  # 条件設定（Criteria）
  #-------------------------------------------------------------

  # criteria (Required)
  # 設定内容: Security HubがFindingをフィルタリングするために使用する
  #           ASFF Findingフィールド属性と期待値のセットを指定します。
  # 注意: criteriaブロック内の各フィルターは複数定義可能です。
  #       複数のフィルターを定義した場合、それらはAND条件として評価されます。
  # 参考: https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-v2-automation-rules.html#automation-rules-criteria
  criteria {
    # aws_account_id (Optional)
    # 設定内容: Findingが生成されたAWSアカウントIDでフィルタリングします。
    # 注意: 複数のaws_account_idブロックを定義可能
    # aws_account_id {
    #   # comparison (Required)
    #   # 設定内容: 文字列値に適用する条件を指定します。
    #   # 設定可能な値:
    #   #   - "EQUALS": 完全一致
    #   #   - "PREFIX": 前方一致
    #   #   - "NOT_EQUALS": 不一致
    #   #   - "PREFIX_NOT_EQUALS": 前方不一致
    #   #   - "CONTAINS": 含む
    #   #   - "NOT_CONTAINS": 含まない
    #   comparison = "EQUALS"
    #
    #   # value (Required)
    #   # 設定内容: フィルター値を指定します。
    #   # 設定可能な値: 文字列（大文字小文字を区別）
    #   value = "123456789012"
    # }

    # aws_account_name (Optional)
    # 設定内容: Findingが生成されたアカウント名でフィルタリングします。
    # 注意: 複数のaws_account_nameブロックを定義可能
    # aws_account_name {
    #   comparison = "EQUALS"
    #   value      = "production-account"
    # }

    # company_name (Optional)
    # 設定内容: Findingを生成したプロダクトの企業名でフィルタリングします。
    # 注意: コントロールベースのFindingの場合、企業名はAWSです。
    # 注意: 複数のcompany_nameブロックを定義可能
    # company_name {
    #   comparison = "EQUALS"
    #   value      = "AWS"
    # }

    # compliance_associated_standards_id (Optional)
    # 設定内容: コントロールが有効化されている標準の一意識別子でフィルタリングします。
    # 注意: 複数のcompliance_associated_standards_idブロックを定義可能
    # compliance_associated_standards_id {
    #   comparison = "EQUALS"
    #   value      = "standards/aws-foundational-security-best-practices/v/1.0.0"
    # }

    # compliance_security_control_id (Optional)
    # 設定内容: Findingが生成されたセキュリティコントロールIDでフィルタリングします。
    # 注意: セキュリティコントロールIDは標準間で共通です。
    # 注意: 複数のcompliance_security_control_idブロックを定義可能
    # compliance_security_control_id {
    #   comparison = "EQUALS"
    #   value      = "S3.1"
    # }

    # compliance_status (Optional)
    # 設定内容: セキュリティチェックの結果でフィルタリングします。
    # 注意: このフィールドはコントロールから生成されたFindingにのみ使用されます。
    # 注意: 複数のcompliance_statusブロックを定義可能
    # compliance_status {
    #   comparison = "EQUALS"
    #   value      = "FAILED"
    # }

    # confidence (Optional)
    # 設定内容: Findingが特定した動作や問題を正確に識別する可能性でフィルタリングします。
    # 注意: 0-100のスケールで評価されます（0: 0%の信頼度、100: 100%の信頼度）
    # 注意: 複数のconfidenceブロックを定義可能
    # confidence {
    #   # eq (Optional)
    #   # 設定内容: 等しい条件を指定します。
    #   # 設定可能な値: 文字列として提供される数値
    #   eq = "100"
    #
    #   # gte (Optional)
    #   # 設定内容: 以上の条件を指定します。
    #   # 設定可能な値: 文字列として提供される数値
    #   gte = null
    #
    #   # lte (Optional)
    #   # 設定内容: 以下の条件を指定します。
    #   # 設定可能な値: 文字列として提供される数値
    #   lte = null
    # }

    # created_at (Optional)
    # 設定内容: Findingレコードが作成された日時でフィルタリングします。
    # 注意: 複数のcreated_atブロックを定義可能
    # created_at {
    #   # start (Optional)
    #   # 設定内容: 開始日を指定します。
    #   # 設定可能な値: ISO 8601形式の日時文字列
    #   # 注意: date_rangeが指定されていない場合、endと共に必須
    #   start = "2024-01-01T00:00:00Z"
    #
    #   # end (Optional)
    #   # 設定内容: 終了日を指定します。
    #   # 設定可能な値: ISO 8601形式の日時文字列
    #   # 注意: date_rangeが指定されていない場合、startと共に必須
    #   end = "2024-12-31T23:59:59Z"
    #
    #   # date_range (Optional)
    #   # 設定内容: 日付範囲を指定します。
    #   # date_range {
    #   #   # unit (Required)
    #   #   # 設定内容: 日付範囲の単位を指定します。
    #   #   # 設定可能な値: "DAYS"
    #   #   unit = "DAYS"
    #   #
    #   #   # value (Required)
    #   #   # 設定内容: 日付範囲の値を指定します。
    #   #   # 設定可能な値: 整数
    #   #   value = 7
    #   # }
    # }

    # criticality (Optional)
    # 設定内容: Findingに関連するリソースに割り当てられた重要度レベルでフィルタリングします。
    # 注意: 複数のcriticalityブロックを定義可能
    # criticality {
    #   eq  = null
    #   gte = null
    #   lte = null
    # }

    # description (Optional)
    # 設定内容: Findingの説明でフィルタリングします。
    # 注意: 複数のdescriptionブロックを定義可能
    # description {
    #   comparison = "CONTAINS"
    #   value      = "S3 bucket"
    # }

    # first_observed_at (Optional)
    # 設定内容: セキュリティ上の問題が最初に観測された日時でフィルタリングします。
    # 注意: 複数のfirst_observed_atブロックを定義可能
    # first_observed_at {
    #   start = "2024-01-01T00:00:00Z"
    #   end   = "2024-12-31T23:59:59Z"
    # }

    # generator_id (Optional)
    # 設定内容: Findingを生成したソリューション固有のコンポーネントの識別子でフィルタリングします。
    # 注意: 複数のgenerator_idブロックを定義可能
    # generator_id {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0/rule/1.1"
    # }

    # id (Optional)
    # 設定内容: Findingのプロダクト固有の識別子でフィルタリングします。
    # 注意: 複数のidブロックを定義可能
    # id {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:securityhub:us-east-1:123456789012:subscription/cis-aws-foundations-benchmark/v/1.2.0/1.1/finding/12345678-1234-1234-1234-123456789012"
    # }

    # last_observed_at (Optional)
    # 設定内容: セキュリティ上の問題が最後に観測された日時でフィルタリングします。
    # 注意: 複数のlast_observed_atブロックを定義可能
    # last_observed_at {
    #   start = "2024-01-01T00:00:00Z"
    #   end   = "2024-12-31T23:59:59Z"
    # }

    # note_text (Optional)
    # 設定内容: Findingに追加されたユーザー定義ノートのテキストでフィルタリングします。
    # 注意: 複数のnote_textブロックを定義可能
    # note_text {
    #   comparison = "CONTAINS"
    #   value      = "critical"
    # }

    # note_updated_at (Optional)
    # 設定内容: ノートが更新された日時でフィルタリングします。
    # 注意: 複数のnote_updated_atブロックを定義可能
    # note_updated_at {
    #   start = "2024-01-01T00:00:00Z"
    #   end   = "2024-12-31T23:59:59Z"
    # }

    # note_updated_by (Optional)
    # 設定内容: ノートを作成したプリンシパルでフィルタリングします。
    # 注意: 複数のnote_updated_byブロックを定義可能
    # note_updated_by {
    #   comparison = "EQUALS"
    #   value      = "sechub-automation"
    # }

    # product_arn (Optional)
    # 設定内容: Security HubでFindingを生成したサードパーティプロダクトのARNでフィルタリングします。
    # 注意: 複数のproduct_arnブロックを定義可能
    # product_arn {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:securityhub:us-east-1::product/aws/guardduty"
    # }

    # product_name (Optional)
    # 設定内容: Findingを生成したプロダクト名でフィルタリングします。
    # 注意: コントロールベースのFindingの場合、プロダクト名はSecurity Hubです。
    # 注意: 複数のproduct_nameブロックを定義可能
    # product_name {
    #   comparison = "EQUALS"
    #   value      = "Security Hub"
    # }

    # record_state (Optional)
    # 設定内容: Findingの現在の状態でフィルタリングします。
    # 注意: 複数のrecord_stateブロックを定義可能
    # record_state {
    #   comparison = "EQUALS"
    #   value      = "ACTIVE"
    # }

    # related_findings_id (Optional)
    # 設定内容: 関連するFindingのプロダクト固有の識別子でフィルタリングします。
    # 注意: 複数のrelated_findings_idブロックを定義可能
    # related_findings_id {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:securityhub:us-east-1:123456789012:subscription/cis-aws-foundations-benchmark/v/1.2.0/1.1/finding/12345678-1234-1234-1234-123456789012"
    # }

    # related_findings_product_arn (Optional)
    # 設定内容: 関連するFindingを生成したプロダクトのARNでフィルタリングします。
    # 注意: 複数のrelated_findings_product_arnブロックを定義可能
    # related_findings_product_arn {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:securityhub:us-east-1::product/aws/securityhub"
    # }

    # resource_application_arn (Optional)
    # 設定内容: Findingに関連するアプリケーションのARNでフィルタリングします。
    # 注意: 複数のresource_application_arnブロックを定義可能
    # resource_application_arn {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:servicecatalog:us-east-1:123456789012:/applications/0123456789abcdef0"
    # }

    # resource_application_name (Optional)
    # 設定内容: Findingに関連するアプリケーション名でフィルタリングします。
    # 注意: 複数のresource_application_nameブロックを定義可能
    # resource_application_name {
    #   comparison = "EQUALS"
    #   value      = "my-application"
    # }

    # resource_details_other (Optional)
    # 設定内容: Findingに関連するリソースのカスタムフィールドと値でフィルタリングします。
    # 注意: 複数のresource_details_otherブロックを定義可能
    # resource_details_other {
    #   # comparison (Required)
    #   # 設定内容: マップフィルターに適用する条件を指定します。
    #   # 設定可能な値:
    #   #   - "EQUALS": 完全一致
    #   #   - "NOT_EQUALS": 不一致
    #   comparison = "EQUALS"
    #
    #   # key (Required)
    #   # 設定内容: マップフィルターのキーを指定します。
    #   # 設定可能な値: 文字列
    #   key = "customField"
    #
    #   # value (Required)
    #   # 設定内容: マップフィルターのキーに対する値を指定します。
    #   # 設定可能な値: 文字列（大文字小文字を区別）
    #   value = "customValue"
    # }

    # resource_id (Optional)
    # 設定内容: リソースタイプの識別子でフィルタリングします。
    # 注意: ARNで識別されるAWSリソースの場合はARN、それ以外はリソースを作成したAWSサービスが定義する識別子
    # 注意: 複数のresource_idブロックを定義可能
    resource_id {
      comparison = "EQUALS"
      value      = "arn:aws:s3:::examplebucket/*"
    }

    # resource_partition (Optional)
    # 設定内容: Findingに関連するリソースが配置されているパーティションでフィルタリングします。
    # 注意: パーティションはAWSリージョンのグループです。各AWSアカウントは1つのパーティションにスコープされます。
    # 注意: 複数のresource_partitionブロックを定義可能
    # resource_partition {
    #   comparison = "EQUALS"
    #   value      = "aws"
    # }

    # resource_region (Optional)
    # 設定内容: Findingに関連するリソースが配置されているAWSリージョンでフィルタリングします。
    # 注意: 複数のresource_regionブロックを定義可能
    # resource_region {
    #   comparison = "EQUALS"
    #   value      = "us-east-1"
    # }

    # resource_tags (Optional)
    # 設定内容: Finding処理時にリソースに関連付けられたAWSタグでフィルタリングします。
    # 注意: 複数のresource_tagsブロックを定義可能
    # resource_tags {
    #   comparison = "EQUALS"
    #   key        = "Environment"
    #   value      = "production"
    # }

    # resource_type (Optional)
    # 設定内容: Findingに関連するリソースタイプでフィルタリングします。
    # 注意: 複数のresource_typeブロックを定義可能
    # resource_type {
    #   comparison = "EQUALS"
    #   value      = "AwsS3Bucket"
    # }

    # severity_label (Optional)
    # 設定内容: Findingの深刻度値でフィルタリングします。
    # 注意: 複数のseverity_labelブロックを定義可能
    # severity_label {
    #   comparison = "EQUALS"
    #   value      = "HIGH"
    # }

    # source_url (Optional)
    # 設定内容: Findingプロダクトで現在のFindingに関するページへのリンクURLでフィルタリングします。
    # 注意: 複数のsource_urlブロックを定義可能
    # source_url {
    #   comparison = "EQUALS"
    #   value      = "https://example.com/findings/12345"
    # }

    # title (Optional)
    # 設定内容: Findingのタイトルでフィルタリングします。
    # 注意: 複数のtitleブロックを定義可能
    # title {
    #   comparison = "CONTAINS"
    #   value      = "S3"
    # }

    # type (Optional)
    # 設定内容: Findingタイプでフィルタリングします。
    # 注意: 形式は "namespace/category/classifier"
    # 注意: 複数のtypeブロックを定義可能
    # type {
    #   comparison = "EQUALS"
    #   value      = "Software and Configuration Checks/AWS Security Best Practices"
    # }

    # updated_at (Optional)
    # 設定内容: Findingレコードが最後に更新された日時でフィルタリングします。
    # 注意: 複数のupdated_atブロックを定義可能
    # updated_at {
    #   start = "2024-01-01T00:00:00Z"
    #   end   = "2024-12-31T23:59:59Z"
    # }

    # user_defined_fields (Optional)
    # 設定内容: Findingに追加されたユーザー定義の名前と値のペアでフィルタリングします。
    # 注意: 複数のuser_defined_fieldsブロックを定義可能
    # user_defined_fields {
    #   comparison = "EQUALS"
    #   key        = "customKey"
    #   value      = "customValue"
    # }

    # verification_state (Optional)
    # 設定内容: Findingの真正性でフィルタリングします。
    # 注意: 複数のverification_stateブロックを定義可能
    # verification_state {
    #   comparison = "EQUALS"
    #   value      = "TRUE_POSITIVE"
    # }

    # workflow_status (Optional)
    # 設定内容: Findingの調査ステータスに関する情報でフィルタリングします。
    # 注意: 複数のworkflow_statusブロックを定義可能
    # workflow_status {
    #   comparison = "EQUALS"
    #   value      = "NEW"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Security Hub自動化ルールのID（arnと同じ値）
#
# - arn: Security Hub自動化ルールのARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
