#---------------------------------------------------------------
# AWS Systems Manager Incident Manager Response Plan
#---------------------------------------------------------------
#
# AWS Systems Manager Incident Managerのレスポンスプランをプロビジョニングするリソースです。
# レスポンスプランは、インシデント対応のテンプレートとして機能し、
# インシデント発生時の初期対応を自動化します。エンゲージメントの設定、
# 重大度、自動ランブック、監視するメトリクスなどを定義できます。
#
# AWS公式ドキュメント:
#   - Response Plans概要: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
#   - CreateResponsePlan API: https://docs.aws.amazon.com/incident-manager/latest/APIReference/API_CreateResponsePlan.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_response_plan
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssmincidents_response_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: レスポンスプランの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: この名前は一意である必要があります。
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/APIReference/API_CreateResponsePlan.html
  name = "my-response-plan"

  # display_name (Optional)
  # 設定内容: レスポンスプランの表示名を指定します（長い形式の名前）。
  # 設定可能な値: スペースを含む文字列
  # 省略時: nameの値がUIに表示されます
  # 用途: コンソール上での可読性を向上させるため
  display_name = "My Response Plan"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # インシデントテンプレート設定（必須ブロック）
  #-------------------------------------------------------------

  # incident_template (Required, max_items: 1)
  # 設定内容: インシデント発生時に作成されるインシデントレコードのデフォルト値を定義します。
  # 注意: このブロックは必須で、1つだけ指定可能です。
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
  incident_template {
    # title (Required)
    # 設定内容: 生成されるインシデントのタイトルを指定します。
    # 設定可能な値: 文字列
    # 用途: インシデントの内容を簡潔に表す
    title = "Incident Title"

    # impact (Required)
    # 設定内容: 生成されるインシデントの影響度を指定します。
    # 設定可能な値:
    #   - 1: Severe Impact（重大な影響）
    #   - 2: High Impact（高い影響）
    #   - 3: Medium Impact（中程度の影響）
    #   - 4: Low Impact（低い影響）
    #   - 5: No Impact（影響なし）
    # 用途: インシデントの優先度付けとトリアージに使用
    impact = 3

    # summary (Optional)
    # 設定内容: インシデントの概要を指定します。
    # 設定可能な値: 文字列
    # 省略時: 概要なしでインシデントが作成されます
    # 用途: インシデントの詳細な説明
    summary = "This is an incident summary"

    # dedupe_string (Optional)
    # 設定内容: 同じインシデントに対して複数のインシデントレコードが作成されるのを防ぐための文字列を指定します。
    # 設定可能な値: 文字列
    # 省略時: 重複排除は行われません
    # 用途: 同一の問題に対して重複したインシデントが作成されるのを防ぐ
    dedupe_string = "unique-dedupe-string"

    # incident_tags (Optional)
    # 設定内容: インシデントテンプレートに割り当てるタグを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: タグなしでインシデントが作成されます
    # 用途: インシデント開始時に、テンプレートで指定されたタグがインシデントに割り当てられます
    incident_tags = {
      Environment = "production"
      Team        = "ops"
    }

    # notification_target (Optional)
    # 設定内容: インシデント更新時に通知するAmazon SNSトピックを指定します。
    # 注意: 複数のnotification_targetブロックを定義可能です
    # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
    notification_target {
      # sns_topic_arn (Required)
      # 設定内容: Amazon SNSトピックのARNを指定します。
      # 設定可能な値: 有効なSNSトピックARN
      # 用途: インシデントの更新を受け取るための通知先
      sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:incident-notifications"
    }
  }

  #-------------------------------------------------------------
  # コラボレーション設定
  #-------------------------------------------------------------

  # chat_channel (Optional)
  # 設定内容: インシデント時のコラボレーションに使用するChatbotチャットチャネルを指定します。
  # 設定可能な値: 文字列のセット（SNSトピックARN）
  # 省略時: チャットチャネルなしでインシデントが作成されます
  # 用途: AWS ChatbotでSlackやAmazon Chimeとの統合に使用
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
  chat_channel = ["arn:aws:sns:us-east-1:123456789012:chat-channel"]

  # engagements (Optional)
  # 設定内容: レスポンスプランがインシデント発生時にエンゲージする連絡先とエスカレーションプランのARNを指定します。
  # 設定可能な値: 文字列のセット（AWS Systems Manager連絡先またはエスカレーションプランのARN）
  # 省略時: エンゲージメントなしでインシデントが作成されます
  # 用途: インシデント対応者の自動通知と参加
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
  engagements = [
    "arn:aws:ssm-contacts:us-east-1:123456789012:contact/on-call-engineer"
  ]

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # action (Optional, max_items: 1)
  # 設定内容: インシデント開始時に実行するアクションを定義します。
  # 注意: 1つのアクションブロックのみ指定可能です
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
  action {
    # ssm_automation (Optional)
    # 設定内容: インシデント開始時のランブックとして実行するSystems Manager Automationドキュメントを指定します。
    # 用途: インシデント軽減のための自動化されたワークフローを実行
    ssm_automation {
      # document_name (Required)
      # 設定内容: Automationドキュメントの名前を指定します。
      # 設定可能な値: 有効なSSM Automationドキュメント名
      # 用途: 実行するランブックの指定
      document_name = "AWS-RestartEC2Instance"

      # role_arn (Required)
      # 設定内容: Automationドキュメントがコマンドを実行する際に引き受けるIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      # 注意: このロールには、Automationドキュメントで実行されるアクションに必要な権限が必要です
      role_arn = "arn:aws:iam::123456789012:role/incident-automation-role"

      # document_version (Optional)
      # 設定内容: 実行時に使用するAutomationドキュメントのバージョンを指定します。
      # 設定可能な値: ドキュメントのバージョン番号（文字列）
      # 省略時: デフォルトバージョンが使用されます
      document_version = "1"

      # target_account (Optional)
      # 設定内容: Automationドキュメントを実行するアカウントを指定します。
      # 設定可能な値:
      #   - "RESPONSE_PLAN_OWNER_ACCOUNT": レスポンスプランを所有するアカウント
      #   - "IMPACTED_ACCOUNT": 影響を受けたアカウント
      # 省略時: レスポンスプランを所有するアカウントで実行されます
      # 用途: マネジメントアカウントまたはアプリケーションアカウントでの実行を選択
      target_account = "RESPONSE_PLAN_OWNER_ACCOUNT"

      # dynamic_parameters (Optional)
      # 設定内容: Systems Manager Automationランブックを処理する際に動的パラメータ値を解決するためのキーと値のペアを指定します。
      # 設定可能な値:
      #   - "INVOLVED_RESOURCES": インシデントに関与するリソース
      #   - "INCIDENT_RECORD_ARN": インシデントレコードのARN
      # 省略時: 動的パラメータは使用されません
      # 用途: ランブック実行時にインシデント固有の情報を渡す
      dynamic_parameters = {
        IncidentId = "INCIDENT_RECORD_ARN"
      }

      # parameter (Optional)
      # 設定内容: Automationドキュメント実行時に使用するキーと値のペアのパラメータを指定します。
      # 注意: 複数のparameterブロックを定義可能です
      parameter {
        # name (Required)
        # 設定内容: パラメータの名前を指定します。
        # 設定可能な値: Automationドキュメントで定義されたパラメータ名
        name = "InstanceId"

        # values (Required)
        # 設定内容: 関連するパラメータ名の値を指定します。
        # 設定可能な値: 文字列のセット
        # 注意: 複数の値を指定可能です
        values = ["i-1234567890abcdef0"]
      }
    }
  }

  #-------------------------------------------------------------
  # 統合設定
  #-------------------------------------------------------------

  # integration (Optional, max_items: 1)
  # 設定内容: レスポンスプランに統合されるサードパーティサービスに関する情報を指定します。
  # 注意: 1つの統合ブロックのみ指定可能です
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
  integration {
    # pagerduty (Optional)
    # 設定内容: レスポンスプランのPagerDuty設定の詳細を指定します。
    # 用途: Incident Managerのインシデントに関連付けられたPagerDutyインシデントを作成
    pagerduty {
      # name (Required)
      # 設定内容: PagerDuty設定の名前を指定します。
      # 設定可能な値: 文字列
      # 用途: 統合の識別
      name = "pagerduty-integration"

      # service_id (Required)
      # 設定内容: レスポンスプランが起動時にインシデントと関連付けるPagerDutyサービスのIDを指定します。
      # 設定可能な値: PagerDutyサービスID
      # 用途: インシデントを作成するPagerDutyサービスの指定
      service_id = "PXXXXXX"

      # secret_id (Required)
      # 設定内容: PagerDutyキーとその他のユーザー認証情報を保存するAWS Secrets ManagerシークレットのIDを指定します。
      # 設定可能な値: AWS Secrets ManagerシークレットID（General Access REST API KeyまたはUser Token REST API Key）
      # 注意: シークレットには有効なPagerDuty APIキーが含まれている必要があります
      # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/response-plans.html
      secret_id = "arn:aws:secretsmanager:us-east-1:123456789012:secret:pagerduty-api-key-AbCdEf"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: レスポンスプランに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは割り当てられません
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # 依存関係の注意
  # レスポンスプランは暗黙的にレプリケーションセットに依存します。
  # Terraformでレプリケーションセットを設定した場合は、depends_on引数に追加することを推奨します。
  # 例: depends_on = [aws_ssmincidents_replication_set.example]
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: レスポンスプランのAmazon Resource Name (ARN)
#
# - id: レスポンスプランの一意の識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
