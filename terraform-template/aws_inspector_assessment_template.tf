#---------------------------------------------------------------
# AWS Inspector Classic Assessment Template
#---------------------------------------------------------------
#
# Amazon Inspector Classic（旧Inspector）のアセスメントテンプレートをプロビジョニングするリソースです。
# アセスメントテンプレートは、セキュリティ評価の実行設定（評価対象、ルールパッケージ、実行時間、
# SNS通知等）を定義します。テンプレートをもとにアセスメントランを開始し、EC2インスタンスの
# 潜在的なセキュリティ問題を検出できます。
#
# 注意: Amazon Inspector Classicは2026年5月20日にサポート終了予定です。
#       新規アカウントでは利用不可となっています。
#
# AWS公式ドキュメント:
#   - アセスメントテンプレートとアセスメントラン: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
#   - Inspector Classicの概念: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_concepts.html
#   - ルールパッケージとルール: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_rule-packages.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_assessment_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
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
  # 設定内容: アセスメントテンプレートの名前を指定します。
  # 設定可能な値: 1-140文字の文字列
  name = "example-assessment-template"

  # target_arn (Required)
  # 設定内容: テンプレートを関連付けるアセスメントターゲットのARNを指定します。
  # 設定可能な値: 有効なaws_inspector_assessment_targetリソースのARN
  # 参考: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
  target_arn = aws_inspector_assessment_target.example.arn

  #-------------------------------------------------------------
  # 実行設定
  #-------------------------------------------------------------

  # duration (Required)
  # 設定内容: アセスメントランの実行時間を秒単位で指定します。
  # 設定可能な値: 180（3分）〜86400（24時間）の整数
  #   - 180: 3分（最短）
  #   - 3600: 1時間（推奨）
  #   - 86400: 24時間（最長）
  # 参考: https://docs.aws.amazon.com/inspector/v1/APIReference/API_AssessmentTemplate.html
  duration = 3600

  # rules_package_arns (Required)
  # 設定内容: アセスメントランで使用するルールパッケージのARNセットを指定します。
  # 設定可能な値: 有効なInspector Classicルールパッケージのセット（最大50件）
  #   ap-northeast-1（東京）のルールパッケージARN例:
  #   - CVE: arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-gHP9oWNT
  #   - CIS Benchmarks: arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-7WNjqgGu
  #   - Security Best Practices: arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-bBUQnxMq
  #   - Network Reachability: arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-YI95DVd7
  # 参考: https://docs.aws.amazon.com/inspector/v1/userguide/inspector_rule-packages.html
  rules_package_arns = [
    "arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-gHP9oWNT",
    "arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-7WNjqgGu",
    "arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-bBUQnxMq",
    "arn:aws:inspector:ap-northeast-1:406045910587:rulespackage/0-YI95DVd7",
  ]

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
  # SNS通知設定
  #-------------------------------------------------------------

  # event_subscription (Optional)
  # 設定内容: 指定したアセスメントテンプレートのイベントをSNSトピックに通知する設定ブロックです。
  #           複数のイベントサブスクリプションを設定できます。
  # 関連機能: Inspector Classic SNS通知
  #   アセスメントランの開始・完了・状態変更、および検出事項の報告をSNS経由で通知。
  #   - https://docs.aws.amazon.com/inspector/v1/userguide/inspector_assessments.html
  event_subscription {

    # event (Required)
    # 設定内容: SNS通知を送信するイベントの種類を指定します。
    # 設定可能な値:
    #   - "ASSESSMENT_RUN_STARTED": アセスメントランが開始されたとき
    #   - "ASSESSMENT_RUN_COMPLETED": アセスメントランが完了したとき
    #   - "ASSESSMENT_RUN_STATE_CHANGED": アセスメントランの状態が変化したとき
    #   - "FINDING_REPORTED": 検出事項が報告されたとき
    event = "ASSESSMENT_RUN_COMPLETED"

    # topic_arn (Required)
    # 設定内容: 通知の送信先となるSNSトピックのARNを指定します。
    # 設定可能な値: 有効なAmazon SNSトピックのARN
    # 注意: SNSトピックにInspector Classicからのパブリッシュ権限を付与する必要があります
    topic_arn = aws_sns_topic.example.arn
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーのdefault_tags設定ブロックで定義されたタグと一致するキーを持つタグは
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-assessment-template"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アセスメントテンプレートのARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
