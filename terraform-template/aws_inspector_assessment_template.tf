#---------------------------------------------------------------
# AWS Inspector Classic Assessment Template
#---------------------------------------------------------------
#
# Amazon Inspector Classicの評価テンプレートをプロビジョニングするリソースです。
# 評価テンプレートは、評価実行時に使用する設定（ルールパッケージ、実行時間、
# SNS通知設定、タグ）を定義します。評価実行は、このテンプレートに基づいて
# 評価ターゲット（EC2インスタンス群）のセキュリティ状態を評価します。
#
# 注意: Amazon Inspector Classicは2026年5月20日にサポート終了予定です。
#       新規アカウントでは既に利用できません。
#       新規の場合は、Amazon Inspector v2の利用を推奨します。
#
# AWS公式ドキュメント:
#   - Inspector Classic概要: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_concepts.html
#   - 評価テンプレートと評価実行: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
#   - ルールパッケージ: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_rule-packages.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_assessment_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector_assessment_template" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 評価テンプレートの名前を指定します。
  # 設定可能な値: 文字列（1文字以上）
  # 関連機能: Assessment Template
  #   評価実行に使用されるテンプレートを識別するための名前。
  #   作成後は変更できないため、わかりやすい命名規則を使用してください。
  #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
  name = "security-assessment-template"

  # target_arn (Required)
  # 設定内容: 評価対象（Assessment Target）のARNを指定します。
  # 設定可能な値: 有効な評価ターゲットのARN
  # 関連機能: Assessment Target
  #   評価対象は、特定のタグを持つEC2インスタンスの集合です。
  #   事前にaws_inspector_assessment_targetリソースで作成する必要があります。
  #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_concepts.html
  target_arn = aws_inspector_assessment_target.example.arn

  #-------------------------------------------------------------
  # 評価実行設定
  #-------------------------------------------------------------

  # duration (Required)
  # 設定内容: 評価実行の継続時間を秒単位で指定します。
  # 設定可能な値:
  #   - 最小値: 180秒（3分）
  #   - 最大値: 86400秒（24時間/1日）
  #   - デフォルト推奨値: 3600秒（1時間）
  # 関連機能: Assessment Run Duration
  #   評価実行中、Inspector Classicエージェントがテレメトリデータを収集し、
  #   指定されたルールパッケージに対して分析を実行します。
  #   長時間の実行により、より多くのテレメトリデータを収集できますが、
  #   コストも増加します。
  #   - https://docs.aws.amazon.com/inspector/v1/APIReference/API_AssessmentTemplate.html
  duration = 3600

  # rules_package_arns (Required)
  # 設定内容: 評価実行中に使用するルールパッケージのARNリストを指定します。
  # 設定可能な値:
  #   有効なルールパッケージARNの配列（最大50個）
  #   ※ルールパッケージARNはリージョンごとに異なります
  #
  # 主要なルールパッケージ（us-east-1の例）:
  #   - Common Vulnerabilities and Exposures (CVE)
  #     arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7
  #   - CIS Operating System Security Configuration Benchmarks
  #     arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8
  #   - Security Best Practices
  #     arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q
  #   - Network Reachability
  #     arn:aws:inspector:us-east-1:316112463485:rulespackage/0-PmNV0Tcd
  #
  # 関連機能: Rules Packages
  #   ルールパッケージは、特定のセキュリティ目標に対応するルールの集合です。
  #   各ルールは、評価実行中に実行されるセキュリティチェックで、
  #   潜在的なセキュリティ問題を検出するとファインディングを生成します。
  #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_rule-packages.html
  # 注意:
  #   - リージョンごとにARNが異なるため、使用するリージョンに応じて変更が必要です
  #   - 複数のルールパッケージを指定することで、包括的なセキュリティ評価が可能です
  rules_package_arns = [
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p", # CVE
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-H5hpSawc", # CIS Benchmarks
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-JJOtZiqQ", # Security Best Practices
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-vg5GGHSD", # Network Reachability
  ]

  #-------------------------------------------------------------
  # イベント通知設定
  #-------------------------------------------------------------

  # event_subscription (Optional)
  # 設定内容: 評価テンプレートに関連する特定のイベントが発生した際に、
  #           指定したSNSトピックへ通知を送信する設定を行います。
  # 関連機能: Event Notifications
  #   Amazon SNSを使用して、評価実行の開始、完了、状態変更、
  #   ファインディング報告などのイベント通知を受け取ることができます。
  #   通知を受け取るには、事前にSNSトピックを作成し、必要な権限を設定する必要があります。
  #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
  # 注意: 複数のイベントタイプに対して通知を設定する場合は、
  #       複数のevent_subscriptionブロックを定義できます。

  event_subscription {
    # event (Required)
    # 設定内容: 通知を受け取りたいイベントタイプを指定します。
    # 設定可能な値:
    #   - "ASSESSMENT_RUN_STARTED": 評価実行が開始されたとき
    #   - "ASSESSMENT_RUN_COMPLETED": 評価実行が完了したとき
    #   - "ASSESSMENT_RUN_STATE_CHANGED": 評価実行の状態が変更されたとき
    #   - "FINDING_REPORTED": ファインディングが報告されたとき
    event = "ASSESSMENT_RUN_COMPLETED"

    # topic_arn (Required)
    # 設定内容: 通知を送信するSNSトピックのARNを指定します。
    # 設定可能な値: 有効なSNSトピックARN
    # 注意:
    #   - SNSトピックには、Inspector Classicからメッセージを発行できるよう
    #     適切なアクセス権限を設定する必要があります
    #   - Confused Deputy攻撃を防ぐため、IAMロールやKMSキーに条件を追加することを推奨します
    #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
    topic_arn = aws_sns_topic.example.arn
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意:
  #   - ルールパッケージARNはリージョンごとに異なるため、
  #     リージョンを変更する場合はrules_package_arnsも合わせて変更が必要です
  # region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
  tags = {
    Name        = "security-assessment"
    Environment = "production"
    Purpose     = "security-compliance-check"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 評価テンプレートのAmazon Resource Name (ARN)
#        評価実行を開始する際や、他のリソースから参照する際に使用します。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用上の注意事項
#---------------------------------------------------------------
# 1. サポート終了について:
#    - Amazon Inspector Classicは2026年5月20日にサポート終了予定です
#    - 新規アカウントでは既に利用できません
#    - 既存ユーザーは Amazon Inspector v2 への移行を検討してください
#
# 2. テンプレートの変更:
#    - 評価テンプレートは作成後に変更できません
#    - 設定を変更する場合は、新しいテンプレートを作成する必要があります
#
# 3. AWS アカウント制限:
#    - 1つのAWSアカウントにつき最大500個の評価テンプレートを作成可能
#    - 1つのAWSアカウントにつき最大50,000個の評価実行を実行可能
#
# 4. 評価実行の制限:
#    - 同じテンプレートを使用して複数の評価実行を開始できます
#    - ただし、評価ターゲットに重複するEC2インスタンスが含まれていない場合のみ
#
# 5. 削除時の動作:
#    - 評価テンプレートを削除すると、関連する全ての評価実行、ファインディング、
#      レポートバージョンも削除されます
#
# 6. ルールパッケージARN:
#    - ルールパッケージのARNはリージョンごとに異なります
#    - 使用するリージョンに対応したARNを指定する必要があります
#    - 主要リージョンのARN一覧は公式ドキュメントを参照してください
#
# 7. 自動評価実行のスケジューリング:
#    - 定期的な評価実行を自動化する場合は、AWS Lambdaと
#      CloudWatch Eventsを組み合わせて使用します
#    - Lambda関数でStartAssessmentRun APIを呼び出し、
#      CloudWatch Eventsでトリガーを設定します
#---------------------------------------------------------------
