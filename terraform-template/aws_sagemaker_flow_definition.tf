################################################################################
# SageMaker Flow Definition
################################################################################
#
# 概要:
#   Amazon SageMaker AI Flow Definitionは、Amazon Augmented AI (A2I)を使用して
#   機械学習の予測に対する人間によるレビューワークフローを定義します。
#   人間のレビューが必要な条件、タスクの送信先となるワークチーム、
#   ワーカータスクテンプレート、出力データの保存場所を指定します。
#
# 主要なユースケース:
#   - Amazon Rekognitionの画像モデレーションレビュー
#   - Amazon Textractのドキュメント分析レビュー
#   - カスタムMLモデルの予測レビュー
#   - コンテンツモデレーションと品質保証
#   - データラベリングと検証ワークフロー
#
# 統合サービス:
#   - Amazon Rekognition (画像モデレーション)
#   - Amazon Textract (フォーム・ドキュメント分析)
#   - SageMaker Human Task UI
#   - SageMaker Workteam
#   - Amazon S3 (出力データストレージ)
#   - AWS KMS (暗号化)
#
# 参考:
#   - https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-create-flow-definition.html
#   - https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-getting-started-core-components.html
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_flow_definition

################################################################################
# Basic Configuration
################################################################################

resource "aws_sagemaker_flow_definition" "this" {
  # 必須: Flow Definitionの名前
  # 制約: 英数字とハイフンのみ使用可能、最大63文字
  # 注意: 作成後は変更できません(置き換えが必要)
  flow_definition_name = "example-flow-definition"

  # 必須: 他のAWSサービスを呼び出すためのIAMロールARN
  # 必要な権限:
  #   - S3への書き込み権限(出力結果保存用)
  #   - SageMaker APIの実行権限
  #   - Human Task UIへのアクセス権限
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-permissions-security.html
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-flow-definition-role"

  # オプション: タグを使用したリソース管理
  # ベストプラクティス: 環境、プロジェクト、コストセンターなどでタグ付け
  tags = {
    Environment = "production"
    Project     = "ml-review-workflow"
    ManagedBy   = "terraform"
  }

  ################################################################################
  # Human Loop Configuration (Required)
  ################################################################################
  #
  # 人間のレビュータスクの設定を定義します。
  # これは必須のブロックで、ワーカーがどのようにタスクを実行するかを指定します。

  human_loop_config {
    # 必須: Human Task UIのARN
    # Worker UI/UXを定義するテンプレート
    # SageMaker Human Task UIリソースまたはカスタムUIで作成
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-instructions-overview.html
    human_task_ui_arn = "arn:aws:sagemaker:us-east-1:123456789012:human-task-ui/example-ui"

    # 必須: タスクのタイトル
    # ワーカーに表示されるタイトル(簡潔で説明的に)
    # 最大128文字
    task_title = "Review ML Prediction"

    # 必須: タスクの説明
    # ワーカーに表示される詳細な説明
    # レビューの目的と期待される結果を明確に記述
    # 最大255文字
    task_description = "Review the machine learning model prediction and verify accuracy"

    # 必須: タスクを実行するワーカーの数
    # 範囲: 1-3
    # 複数のワーカーを指定すると、多数決や合意形成が可能
    # ベストプラクティス: 重要な判断には2-3人のレビュワーを設定
    task_count = 1

    # 必須: ワークチームのARN
    # タスクが送信されるワークチームを指定
    #
    # ワークチームの種類:
    # 1. Private Workforce: 組織内のワーカー
    #    arn:aws:sagemaker:region:account-id:workteam/private-crowd/team-name
    #
    # 2. Vendor Workforce: AWSが管理するベンダーのワーカー
    #    arn:aws:sagemaker:region:vendor-id:workteam/vendor-crowd/team-name
    #
    # 3. Amazon Mechanical Turk (Public): パブリッククラウドワーカー
    #    arn:aws:sagemaker:region:394669845002:workteam/public-crowd/default
    #    注意: 機密データには使用しないでください
    #
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-management.html
    workteam_arn = "arn:aws:sagemaker:us-east-1:123456789012:workteam/private-crowd/my-team"

    # オプション: タスクの利用可能期間(秒)
    # 範囲: 1-864000 (最大10日間)
    # この期間内にワーカーがタスクを完了しない場合、タスクは期限切れになります
    # デフォルト: 未設定の場合、タスクは無期限に利用可能
    # ベストプラクティス: 緊急度に応じて設定(例: 24時間 = 86400秒)
    task_availability_lifetime_in_seconds = 86400

    # オプション: タスクの制限時間(秒)
    # ワーカーが個々のタスクを完了するまでの最大時間
    # デフォルト: 3600秒(1時間)
    # 範囲: 30-28800
    # ベストプラクティス: タスクの複雑さに応じて調整
    task_time_limit_in_seconds = 3600

    # オプション: タスク検索用キーワード
    # ワーカーがタスクを見つけやすくするためのキーワード配列
    # Public Workforceで特に有用
    # 最大5個のキーワード、各キーワードは最大30文字
    task_keywords = [
      "image-review",
      "moderation",
      "ml-verification"
    ]

    ################################################################################
    # Public Workforce Task Price (Public Workforceの場合のみ)
    ################################################################################
    #
    # Amazon Mechanical Turkのパブリックワーカーに支払う報酬を定義します。
    # Private WorkforceやVendor Workforceを使用する場合は不要です。
    #
    # 注意: このブロックはworkteam_arnがPublic Workforceの場合のみ使用

    # public_workforce_task_price {
    #   amount_in_usd {
    #     # オプション: ドルの整数部分
    #     # 範囲: 0-2 (最大$2.00)
    #     dollars = 0
    #
    #     # オプション: セントの部分
    #     # 範囲: 0-99
    #     cents = 10
    #
    #     # オプション: セントの10分の1
    #     # 範囲: 0-9
    #     # 例: 2 = 0.002ドル
    #     tenth_fractions_of_a_cent = 5
    #   }
    # }
    #
    # 価格設定のベストプラクティス:
    # - タスクの複雑さと所要時間に基づいて設定
    # - 米国の最低賃金を参考に適切な報酬を設定
    # - 低すぎる報酬は品質の低下やワーカー不足を招く可能性
    # - 一般的な範囲: $0.01-$0.50/タスク
  }

  ################################################################################
  # Output Configuration (Required)
  ################################################################################
  #
  # 人間のレビュー結果の保存場所を指定します。
  # レビューが完了すると、結果はJSON形式でS3に保存されます。

  output_config {
    # 必須: S3出力パス
    # 人間のレビュー結果が保存されるS3パス
    # 形式: s3://bucket-name/prefix/
    # 注意: 末尾のスラッシュを含めることを推奨
    #
    # 出力ファイル構造:
    # s3://bucket-name/prefix/flow-definition-name/year/month/day/hour/
    #   - iteration-id/output.json (レビュー結果)
    #   - iteration-id/metadata.json (メタデータ)
    s3_output_path = "s3://my-sagemaker-bucket/human-review-output/"

    # オプション: KMS暗号化キーID
    # 出力データをサーバー側で暗号化するためのKMSキーARN
    # 未指定の場合、S3のデフォルト暗号化が使用されます
    #
    # ベストプラクティス:
    # - 機密データを扱う場合は必ず指定
    # - キーポリシーでSageMakerサービスロールに暗号化/復号化権限を付与
    #
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-permissions-security.html
    kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  ################################################################################
  # Human Loop Request Source (Built-in Task Typesの場合)
  ################################################################################
  #
  # Amazon RekognitionまたはAmazon Textractとの統合時に使用します。
  # カスタムタスクタイプの場合は不要です。
  #
  # 対応する統合ソース:
  # - AWS/Rekognition/DetectModerationLabels/Image/V3 (画像モデレーション)
  # - AWS/Textract/AnalyzeDocument/Forms/V1 (フォーム分析)
  #
  # 注意: このブロックはhuman_loop_activation_configと組み合わせて使用

  # human_loop_request_source {
  #   aws_managed_human_loop_request_source = "AWS/Textract/AnalyzeDocument/Forms/V1"
  # }

  ################################################################################
  # Human Loop Activation Config (Conditional Review)
  ################################################################################
  #
  # 人間のレビューがトリガーされる条件を定義します。
  # Built-in task types (Rekognition/Textract) でのみ使用可能です。
  #
  # ユースケース:
  # - 信頼度スコアが特定の範囲内の予測のみレビュー
  # - ランダムサンプリングによる品質チェック
  # - 特定のラベルや条件に基づく選択的レビュー
  #
  # カスタムタスクタイプの場合:
  # - このブロックは使用不可
  # - 代わりにアプリケーション側で条件判定を実装し、
  #   Amazon A2I Runtime APIを使用してHuman Loopを開始

  # human_loop_activation_config {
  #   human_loop_activation_conditions_config {
  #     # 必須: Human Loop起動条件(JSON形式)
  #     #
  #     # 条件タイプ:
  #     # 1. Sampling: ランダムサンプリング
  #     #    - ランダムに指定した割合のタスクを人間レビューに送信
  #     #    - パラメータ: RandomSamplingPercentage (1-100)
  #     #
  #     # 2. ImportantFormKeyConfidenceCheck (Textract用):
  #     #    - 重要なフォームキーの信頼度チェック
  #     #    - パラメータ: ImportantFormKey, KeyValueBlockConfidenceLessThan
  #     #
  #     # 3. ModerationLabelConfidenceCheck (Rekognition用):
  #     #    - モデレーションラベルの信頼度チェック
  #     #    - パラメータ: ModerationLabel, ConfidenceGreaterThan, ConfidenceLessThan
  #     #
  #     # 条件は複数組み合わせ可能(OR条件)
  #     #
  #     # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-human-fallback-conditions-json-schema.html
  #
  #     human_loop_activation_conditions = jsonencode({
  #       Conditions = [
  #         # 例1: 5%のランダムサンプリング
  #         {
  #           ConditionType = "Sampling"
  #           ConditionParameters = {
  #             RandomSamplingPercentage = 5
  #           }
  #         },
  #         # 例2: Textractの信頼度チェック
  #         # 重要なフィールドの信頼度が90%未満の場合にレビュー
  #         # {
  #         #   ConditionType = "ImportantFormKeyConfidenceCheck"
  #         #   ConditionParameters = {
  #         #     ImportantFormKey = "Mail address"
  #         #     KeyValueBlockConfidenceLessThan = 90
  #         #   }
  #         # },
  #         # 例3: Rekognitionの信頼度範囲チェック
  #         # "Suggestive"ラベルの信頼度が50-98%の範囲の場合にレビュー
  #         # {
  #         #   ConditionType = "ModerationLabelConfidenceCheck"
  #         #   ConditionParameters = {
  #         #     ModerationLabel = "Suggestive"
  #         #     ConfidenceGreaterThan = 50
  #         #     ConfidenceLessThan = 98
  #         #   }
  #         # }
  #       ]
  #     })
  #   }
  # }

  ################################################################################
  # Regional Configuration
  ################################################################################

  # オプション: リージョン指定
  # このリソースを管理するAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンが使用されます
  #
  # 注意点:
  # - Human Task UI、Workteam、S3バケットは同じリージョンに配置することを推奨
  # - クロスリージョンアクセスはレイテンシーとコストが増加
  # region = "us-east-1"
}

################################################################################
# Outputs
################################################################################

# Flow DefinitionのARN
# 他のリソースやAPI呼び出しで参照する際に使用
output "flow_definition_arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Flow Definition"
  value       = aws_sagemaker_flow_definition.this.arn
}

# Flow Definitionの名前
output "flow_definition_name" {
  description = "The name of the Flow Definition"
  value       = aws_sagemaker_flow_definition.this.flow_definition_name
}

# Flow DefinitionのID
output "flow_definition_id" {
  description = "The ID of the Flow Definition (same as name)"
  value       = aws_sagemaker_flow_definition.this.id
}

################################################################################
# 使用例とベストプラクティス
################################################################################

# 使用例1: Amazon Textractとの統合
#
# resource "aws_sagemaker_flow_definition" "textract_review" {
#   flow_definition_name = "textract-document-review"
#   role_arn             = aws_iam_role.a2i_role.arn
#
#   human_loop_config {
#     human_task_ui_arn                     = aws_sagemaker_human_task_ui.textract_ui.arn
#     task_count                            = 1
#     task_description                      = "Review key-value pairs extracted from the document"
#     task_title                            = "Document Review"
#     workteam_arn                          = aws_sagemaker_workteam.private_team.arn
#     task_availability_lifetime_in_seconds = 86400
#     task_time_limit_in_seconds            = 1800
#   }
#
#   human_loop_request_source {
#     aws_managed_human_loop_request_source = "AWS/Textract/AnalyzeDocument/Forms/V1"
#   }
#
#   human_loop_activation_config {
#     human_loop_activation_conditions_config {
#       human_loop_activation_conditions = jsonencode({
#         Conditions = [
#           {
#             ConditionType = "ImportantFormKeyConfidenceCheck"
#             ConditionParameters = {
#               ImportantFormKey               = "Invoice Number"
#               KeyValueBlockConfidenceLessThan = 95
#             }
#           }
#         ]
#       })
#     }
#   }
#
#   output_config {
#     s3_output_path = "s3://${aws_s3_bucket.review_results.id}/textract-output/"
#     kms_key_id     = aws_kms_key.review_encryption.arn
#   }
# }

# 使用例2: Amazon Rekognitionとの統合(Public Workforce)
#
# resource "aws_sagemaker_flow_definition" "image_moderation" {
#   flow_definition_name = "image-content-moderation"
#   role_arn             = aws_iam_role.a2i_role.arn
#
#   human_loop_config {
#     human_task_ui_arn  = aws_sagemaker_human_task_ui.image_review_ui.arn
#     task_count         = 2  # 2人のレビュワーで品質向上
#     task_description   = "Review the image and verify if it contains inappropriate content"
#     task_title         = "Image Content Moderation"
#     task_keywords      = ["image", "moderation", "content-safety"]
#     workteam_arn       = "arn:aws:sagemaker:us-east-1:394669845002:workteam/public-crowd/default"
#
#     task_availability_lifetime_in_seconds = 43200  # 12時間
#     task_time_limit_in_seconds            = 600    # 10分
#
#     public_workforce_task_price {
#       amount_in_usd {
#         dollars                   = 0
#         cents                     = 5
#         tenth_fractions_of_a_cent = 0
#       }
#     }
#   }
#
#   human_loop_request_source {
#     aws_managed_human_loop_request_source = "AWS/Rekognition/DetectModerationLabels/Image/V3"
#   }
#
#   human_loop_activation_config {
#     human_loop_activation_conditions_config {
#       human_loop_activation_conditions = jsonencode({
#         Conditions = [
#           {
#             ConditionType = "ModerationLabelConfidenceCheck"
#             ConditionParameters = {
#               ModerationLabel      = "Suggestive"
#               ConfidenceGreaterThan = 50
#               ConfidenceLessThan    = 98
#             }
#           }
#         ]
#       })
#     }
#   }
#
#   output_config {
#     s3_output_path = "s3://${aws_s3_bucket.review_results.id}/image-moderation/"
#   }
# }

# 使用例3: カスタムMLモデル用(シンプルな構成)
#
# resource "aws_sagemaker_flow_definition" "custom_ml_review" {
#   flow_definition_name = "custom-prediction-review"
#   role_arn             = aws_iam_role.a2i_role.arn
#
#   human_loop_config {
#     human_task_ui_arn                     = aws_sagemaker_human_task_ui.custom_ui.arn
#     task_count                            = 1
#     task_description                      = "Review the ML model prediction and provide feedback"
#     task_title                            = "ML Prediction Review"
#     workteam_arn                          = aws_sagemaker_workteam.ml_team.arn
#     task_availability_lifetime_in_seconds = 172800  # 2日間
#     task_time_limit_in_seconds            = 3600    # 1時間
#   }
#
#   output_config {
#     s3_output_path = "s3://${aws_s3_bucket.review_results.id}/custom-ml-output/"
#     kms_key_id     = aws_kms_key.review_encryption.arn
#   }
#
#   tags = {
#     Environment = "production"
#     Team        = "data-science"
#     Purpose     = "ml-quality-assurance"
#   }
# }

################################################################################
# ベストプラクティス
################################################################################

# 1. IAMロールの権限設定
#    - S3バケットへの書き込み権限
#    - SageMaker APIの実行権限
#    - 必要に応じてKMSキーへのアクセス権限
#    - 最小権限の原則に従う
#
# 2. セキュリティ
#    - 機密データを扱う場合は必ずKMS暗号化を使用
#    - Public Workforceは機密データには使用しない
#    - Private Workforceを使用してアクセスを制限
#    - VPC内でのワークフロー実行を検討
#
# 3. コスト最適化
#    - Human Loop起動条件を適切に設定して不要なレビューを削減
#    - ランダムサンプリングで品質をモニタリング
#    - タスクの複雑さに応じた適切な報酬設定
#    - task_countは必要最小限に(レビュワー数=コスト)
#
# 4. パフォーマンス
#    - 適切なtask_time_limit_in_secondsでワーカーの効率を向上
#    - task_availability_lifetime_in_secondsで緊急度を明示
#    - 明確なtask_descriptionとtask_titleでワーカーの理解を促進
#
# 5. モニタリング
#    - CloudWatch EventsでHuman Loopの完了を監視
#    - S3出力バケットのアクセスログを有効化
#    - レビュー結果の品質メトリクスを定期的に分析
#
# 6. 依存リソース管理
#    - Human Task UIは事前に作成
#    - Workteamは事前に設定
#    - S3バケットとIAMロールの準備
#    - 適切なdepends_onで依存関係を明示
#
# 7. ライフサイクル管理
#    - flow_definition_nameは変更不可(置き換えが必要)
#    - 変更前に既存のHuman Loopの完了を確認
#    - 本番環境での変更は慎重に実施
#    - バージョニング戦略を計画

################################################################################
# トラブルシューティング
################################################################################

# 問題1: Human Loopが開始されない
# 原因と対策:
#   - human_loop_activation_conditionsの条件を確認
#   - IAMロールの権限不足をチェック
#   - CloudWatch Logsでエラーメッセージを確認
#   - API呼び出し時のHumanLoopConfigパラメータを検証
#
# 問題2: レビュー結果がS3に保存されない
# 原因と対策:
#   - S3バケットポリシーとIAMロール権限を確認
#   - s3_output_pathの形式を検証(末尾スラッシュ)
#   - KMS暗号化キーのポリシーを確認
#   - S3バケットのバージョニングと暗号化設定
#
# 問題3: ワーカーがタスクを表示できない
# 原因と対策:
#   - Workteamの設定とメンバーシップを確認
#   - Human Task UIテンプレートの構文エラーをチェック
#   - ワーカーのアクセス権限を検証
#   - ブラウザのコンソールエラーを確認
#
# 問題4: 高コスト
# 原因と対策:
#   - 不要なHuman Loop起動を削減
#   - サンプリング率を調整
#   - task_countを最適化
#   - より精度の高いMLモデルで条件付きレビューを削減

################################################################################
# 関連リソース
################################################################################

# 必要な依存リソース:
# - aws_sagemaker_human_task_ui: ワーカーUIテンプレート
# - aws_sagemaker_workteam: ワークチーム
# - aws_iam_role: サービスロール
# - aws_s3_bucket: 出力データストレージ
# - aws_kms_key: 暗号化キー(オプション)
#
# 統合サービス:
# - Amazon Rekognition: DetectModerationLabels API
# - Amazon Textract: AnalyzeDocument API
# - Amazon A2I Runtime API: StartHumanLoop, DescribeHumanLoop
#
# モニタリングツール:
# - Amazon CloudWatch Events: Human Loop状態変化の通知
# - AWS CloudTrail: API呼び出しの監査
# - Amazon S3: レビュー結果の保存と分析
