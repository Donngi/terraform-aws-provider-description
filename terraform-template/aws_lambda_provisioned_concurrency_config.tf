#---------------------------------------------------------------
# Lambda Provisioned Concurrency Configuration
#---------------------------------------------------------------
#
# Manages AWS Lambda Provisioned Concurrency Configuration.
# Use this resource to configure provisioned concurrency for Lambda functions.
#
# Provisioned concurrency は、Lambda 関数に事前初期化された実行環境を割り当てる機能です。
# これにより、コールドスタートのレイテンシーを削減し、ミリ秒単位の応答時間を実現します。
# プロビジョニングされた同時実行は追加料金が発生しますが、対話型ワークロード（Web/モバイル
# アプリケーション）など、レイテンシーに敏感なアプリケーションに有効です。
#
# AWS公式ドキュメント:
#   - Configuring provisioned concurrency: https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html
#   - PutProvisionedConcurrencyConfig API: https://docs.aws.amazon.com/lambda/latest/api/API_PutProvisionedConcurrencyConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_provisioned_concurrency_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_provisioned_concurrency_config" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # function_name - (Required) Lambda関数の名前またはARN
  # Lambda関数の名前、または完全なARNを指定します。
  # 例: "my-function" または "arn:aws:lambda:us-east-1:123456789012:function:my-function"
  # この設定は、どの関数にプロビジョニングされた同時実行を設定するかを識別します。
  function_name = "my-function"

  # provisioned_concurrent_executions - (Required) 割り当てる同時実行数
  # プロビジョニングされた同時実行環境の数を指定します。1以上の値が必要です。
  # この数値は、常に事前初期化された状態で待機する実行環境の数を表します。
  #
  # 推奨設定方法:
  # - CloudWatch メトリクス ConcurrentExecutions で関数の同時実行数を確認
  # - (平均リクエスト/秒) × (平均リクエスト処理時間) で計算
  # - ピーク時の同時実行数 + 10% のバッファを設定することを推奨
  #
  # 例: 関数が通常20の同時リクエストでピークする場合、22 (20 + 10%) を設定
  #
  # 制限事項:
  # - アカウントの未予約同時実行数 - 100 が上限
  # - 予約済み同時実行数を設定している場合、その値を超えることはできない
  provisioned_concurrent_executions = 1

  # qualifier - (Required) Lambda関数のバージョンまたはエイリアス名
  # プロビジョニングされた同時実行を設定するバージョン番号またはエイリアス名を指定します。
  #
  # 注意:
  # - $LATEST バージョンには設定できません
  # - 数値のバージョン番号（例: "1", "2"）またはエイリアス名（例: "BLUE", "prod"）を指定
  # - イベントソースがある場合、イベントソースが正しいエイリアス/バージョンを指している
  #   ことを確認してください。そうでないと、プロビジョニングされた環境が使用されません
  #
  # エイリアスを使用する例: aws_lambda_alias.example.name
  # バージョンを使用する例: aws_lambda_function.example.version
  qualifier = "prod"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # region - (Optional) リソースを管理するAWSリージョン
  # このリソースがデプロイされるリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # この設定は、マルチリージョン構成で異なるリージョンにリソースを作成する場合に便利です。
  # プロバイダーのデフォルトリージョンと異なるリージョンにリソースを作成したい場合に指定します。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # skip_destroy - (Optional) 削除時にプロビジョニング済み同時実行設定を保持するか
  # デフォルト: false
  #
  # true に設定すると、terraform destroy を実行しても、プロビジョニングされた同時実行設定は
  # 削除されません。設定は Terraform の管理外となり、AWS アカウントに残り続けます。
  # これにより追加料金が発生し続ける可能性があることに注意してください。
  #
  # このオプションは、誤って削除されることを防ぎたい重要な本番環境の設定などに使用します。
  # true に設定した場合、リソースは Terraform の状態からのみ削除され、AWS 上の実際の
  # 設定は保持されます。
  #
  # 使用例:
  # - 本番環境の重要な関数で、プロビジョニングされた同時実行を常に維持したい場合
  # - Terraform での管理を終了するが、設定は残しておきたい場合
  # skip_destroy = false

  #---------------------------------------------------------------
  # Timeouts Block (Optional)
  #---------------------------------------------------------------

  # timeouts - (Optional) タイムアウト設定
  # プロビジョニングされた同時実行設定の作成・更新時のタイムアウト時間を指定します。
  # 指定しない場合は、デフォルトのタイムアウト値が使用されます。
  #
  # プロビジョニングされた同時実行の割り当ては非同期で行われ、完了までに時間がかかる場合が
  # あります。大量の同時実行数を設定する場合や、Lambda の初期化が複雑な場合は、
  # タイムアウト時間を延長することを検討してください。
  #
  # timeouts {
  #   # create - (Optional) 作成操作のタイムアウト時間
  #   # プロビジョニングされた同時実行設定を作成する際の最大待機時間を指定します。
  #   # フォーマット: "15m", "1h" など（m=分, h=時間）
  #   # create = "15m"
  #
  #   # update - (Optional) 更新操作のタイムアウト時間
  #   # プロビジョニングされた同時実行数を変更する際の最大待機時間を指定します。
  #   # フォーマット: "15m", "1h" など（m=分, h=時間）
  #   # update = "15m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - id - Lambda関数名とqualifierをカンマ区切りで結合した値（例: "my-function,prod"）
#
# これらの属性は読み取り専用で、Terraform によって自動的に設定されます。
# 他のリソースで参照する場合は、以下のように使用できます:
#   aws_lambda_provisioned_concurrency_config.example.id
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 例1: エイリアスを使用したプロビジョニング済み同時実行設定
# resource "aws_lambda_provisioned_concurrency_config" "with_alias" {
#   function_name                     = aws_lambda_alias.example.function_name
#   provisioned_concurrent_executions = 1
#   qualifier                         = aws_lambda_alias.example.name
# }

# 例2: バージョンを使用したプロビジョニング済み同時実行設定
# resource "aws_lambda_provisioned_concurrency_config" "with_version" {
#   function_name                     = aws_lambda_function.example.function_name
#   provisioned_concurrent_executions = 10
#   qualifier                         = aws_lambda_function.example.version
# }

# 例3: 削除保護を有効にした設定
# resource "aws_lambda_provisioned_concurrency_config" "protected" {
#   function_name                     = aws_lambda_alias.prod.function_name
#   provisioned_concurrent_executions = 100
#   qualifier                         = aws_lambda_alias.prod.name
#   skip_destroy                      = true
# }

# 例4: タイムアウト設定をカスタマイズした例
# resource "aws_lambda_provisioned_concurrency_config" "with_timeouts" {
#   function_name                     = aws_lambda_alias.example.function_name
#   provisioned_concurrent_executions = 50
#   qualifier                         = aws_lambda_alias.example.name
#
#   timeouts {
#     create = "20m"
#     update = "20m"
#   }
# }

#---------------------------------------------------------------
# 重要な考慮事項
#---------------------------------------------------------------
#
# 1. コスト
#    - プロビジョニングされた同時実行は、使用しない場合でも課金されます
#    - 料金は、プロビジョニングされた環境の数と時間に基づいて計算されます
#    - CloudWatch メトリクスで実際の使用状況を監視し、適切な数を設定してください
#
# 2. 同時実行の制限
#    - アカウントレベルの同時実行制限に影響します
#    - 他の関数で使用可能な同時実行プールが減少します
#    - 例: アカウント制限が1000で、100をプロビジョニングすると、他の関数は900を共有
#
# 3. 予約済み同時実行との関係
#    - 同じ関数に予約済み同時実行とプロビジョニング済み同時実行の両方を設定可能
#    - プロビジョニング済み同時実行は、予約済み同時実行の値を超えることはできません
#
# 4. Application Auto Scaling との連携
#    - プロビジョニング済み同時実行は Application Auto Scaling で自動管理可能
#    - スケジュールベース（特定時間帯のみプロビジョニング）
#    - ターゲット追跡スケーリング（使用率に基づいた自動調整）
#
# 5. $LATEST バージョンの制限
#    - $LATEST バージョンにはプロビジョニング済み同時実行を設定できません
#    - 必ずバージョン番号またはエイリアスを使用してください
#
# 6. イベントソースとの整合性
#    - イベントソース（EventBridge、SQSなど）が正しいエイリアス/バージョンを参照している
#      ことを確認してください
#    - イベントソースが異なるバージョンを参照していると、プロビジョニングされた環境が
#      使用されず、コールドスタートが発生します
#
# 7. 初期化コードの最適化
#    - プロビジョニング済み同時実行を使用する場合、初期化コードはハンドラーの外に移動
#    - ライブラリのロード、クライアントの初期化などは割り当て時に実行されます
#    - 環境変数 AWS_LAMBDA_INITIALIZATION_TYPE で初期化タイプを確認可能
#
# 8. スピルオーバーメカニズム
#    - プロビジョニングされた環境数を超えるリクエストは、通常の同時実行プールから
#      動的に割り当てられます
#    - トラフィックスパイクに対して高い復元性を持ちます
#
#---------------------------------------------------------------
