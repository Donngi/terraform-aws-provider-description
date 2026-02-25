#---------------------------------------------------------------
# AWS Step Functions State Machine
#---------------------------------------------------------------
#
# AWS Step Functionsのステートマシンをプロビジョニングするリソースです。
# ワークフローをJSON/YAML形式のAmazon States Language（ASL）で定義し、
# AWSサービスを組み合わせたサーバーレスオーケストレーションを実現します。
#
# AWS公式ドキュメント:
#   - AWS Step Functions とは: https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html
#   - Amazon States Language: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-amazon-states-language.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sfn_state_machine" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # definition (Required)
  # 設定内容: Amazon States Language（ASL）形式のステートマシン定義をJSON文字列で指定します。
  # 設定可能な値: 有効なASL JSON文字列
  definition = jsonencode({
    Comment = "Example state machine"
    StartAt = "FirstState"
    States = {
      FirstState = {
        Type   = "Pass"
        Result = "Hello"
        End    = true
      }
    }
  })

  # role_arn (Required)
  # 設定内容: ステートマシンの実行ロールのARNを指定します。
  #           ステートマシンがAWSサービスにアクセスするために使用されます。
  # 設定可能な値: 有効なIAMロールARN
  role_arn = "arn:aws:iam::123456789012:role/sfn-execution-role"

  # name (Optional)
  # 設定内容: ステートマシンの名前を指定します。
  # 設定可能な値: 最大80文字。英数字、ハイフン、アンダースコアが使用可能
  # 省略時: name_prefix を指定するか、Terraformが自動生成します
  # 注意: name と name_prefix は同時に指定できません
  name = "example-state-machine"

  # name_prefix (Optional)
  # 設定内容: ステートマシン名のプレフィックスを指定します。
  # 設定可能な値: 有効な名前プレフィックス文字列
  # 省略時: name を指定するか、Terraformが自動生成します
  # 注意: name と name_prefix は同時に指定できません
  name_prefix = null

  # type (Optional)
  # 設定内容: ステートマシンのタイプを指定します。
  # 設定可能な値:
  #   - "STANDARD" (デフォルト): 長時間実行・1回の実行保証・高耐久性のワークフロー
  #   - "EXPRESS": 高スループット・短時間実行（最大5分）のワークフロー
  # 省略時: "STANDARD"
  type = "STANDARD"

  # publish (Optional)
  # 設定内容: 作成・変更時に新しいステートマシンバージョンを発行するかを指定します。
  # 設定可能な値:
  #   - true: バージョンを発行する
  #   - false (デフォルト): バージョンを発行しない
  # 省略時: false
  publish = false

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: ステートマシンデータの暗号化設定ブロックです。
  # 関連機能: Step Functions データ暗号化
  #   KMSキーを使用してステートマシンの実行データを暗号化します。
  #   - https://docs.aws.amazon.com/step-functions/latest/dg/encryption-at-rest.html
  encryption_configuration {

    # type (Optional)
    # 設定内容: 暗号化タイプを指定します。
    # 設定可能な値:
    #   - "AWS_OWNED_KEY": AWSが管理するキーを使用
    #   - "CUSTOMER_MANAGED_KMS_KEY": カスタマー管理KMSキーを使用
    # 省略時: "AWS_OWNED_KEY"
    type = "CUSTOMER_MANAGED_KMS_KEY"

    # kms_key_id (Optional)
    # 設定内容: 暗号化に使用するKMSキーのIDまたはARNを指定します。
    # 設定可能な値: 有効なKMSキーIDまたはARN
    # 省略時: type = "CUSTOMER_MANAGED_KMS_KEY" の場合は必須
    kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/example-key-id"

    # kms_data_key_reuse_period_seconds (Optional)
    # 設定内容: Step FunctionsがKMSに再度コールする前にデータキーを再利用できる秒数を指定します。
    # 設定可能な値: 60〜900 秒
    # 省略時: 300 秒
    kms_data_key_reuse_period_seconds = 300
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_configuration (Optional)
  # 設定内容: 実行ログの設定ブロックです。
  # 関連機能: Step Functions 実行ログ
  #   CloudWatch Logsへのログ出力を設定します。EXPRESSタイプでの使用を推奨します。
  #   - https://docs.aws.amazon.com/step-functions/latest/dg/cw-logs.html
  logging_configuration {

    # level (Optional)
    # 設定内容: ログ出力レベルを指定します。
    # 設定可能な値:
    #   - "OFF" (デフォルト): ロギング無効
    #   - "ERROR": エラー時のみログ出力
    #   - "ALL": 全ての実行でログ出力
    #   - "FATAL": 致命的エラー時のみログ出力
    # 省略時: "OFF"
    level = "ALL"

    # log_destination (Optional)
    # 設定内容: ログの送信先CloudWatch LogsグループのARNを指定します。
    # 設定可能な値: 有効なCloudWatch Logsグループ ARN（:* サフィックス付き）
    # 省略時: level = "OFF" 以外の場合は必須
    log_destination = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/states/example-state-machine:*"

    # include_execution_data (Optional)
    # 設定内容: ログに実行データ（入出力）を含めるかを指定します。
    # 設定可能な値:
    #   - true: 実行データをログに含める
    #   - false (デフォルト): 実行データをログに含めない
    # 省略時: false
    include_execution_data = false
  }

  #-------------------------------------------------------------
  # トレーシング設定
  #-------------------------------------------------------------

  # tracing_configuration (Optional)
  # 設定内容: AWS X-Rayトレーシングの設定ブロックです。
  # 関連機能: Step Functions X-Rayトレーシング
  #   分散トレーシングによりワークフローのパフォーマンス問題を特定できます。
  #   - https://docs.aws.amazon.com/step-functions/latest/dg/concepts-xray-tracing.html
  tracing_configuration {

    # enabled (Optional)
    # 設定内容: X-Rayトレーシングを有効にするかを指定します。
    # 設定可能な値:
    #   - true: X-Rayトレーシングを有効化
    #   - false (デフォルト): X-Rayトレーシングを無効化
    # 省略時: false
    enabled = false
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraform操作のタイムアウト時間の設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等のGo duration文字列
    # 省略時: プロバイダーデフォルト
    delete = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルの default_tags と一致するキーはプロバイダー定義を上書きします
  tags = {
    Name        = "example-state-machine"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ステートマシンのARN
# - arn: ステートマシンのARN
# - creation_date: ステートマシンの作成日時
# - description: ステートマシンの説明
# - revision_id: 現在のリビジョンID（publish = true の場合に更新）
# - state_machine_version_arn: 最新バージョンのARN（publish = true の場合）
# - status: ステートマシンのステータス（"ACTIVE" / "DELETING"）
# - version_description: 最新バージョンの説明
# - tags_all: プロバイダーのdefault_tagsを含む全タグマップ
#---------------------------------------------------------------
