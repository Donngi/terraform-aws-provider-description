#---------------------------------------------------------------
# AWS AppConfig Extension
#---------------------------------------------------------------
#
# AWS AppConfigのExtension（拡張機能）をプロビジョニングするリソースです。
# Extensionは、AppConfigのワークフロー中に特定のアクションを実行する機能を提供します。
# アクションポイント（例: デプロイ開始時、完了時）を定義し、Lambda関数、SNSトピック、
# SQSキュー、EventBridgeなどと連携できます。
#
# AWS公式ドキュメント:
#   - AppConfig Extensions概要: https://docs.aws.amazon.com/appconfig/latest/userguide/working-with-appconfig-extensions-about.html
#   - カスタムExtensionの作成: https://docs.aws.amazon.com/appconfig/latest/userguide/working-with-appconfig-extensions-creating-custom.html
#   - Action API Reference: https://docs.aws.amazon.com/appconfig/2019-10-09/APIReference/API_Action.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_extension
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_extension" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Extensionの名前を指定します。
  # 設定可能な値: 文字列。アカウント内で一意である必要があります。
  # 注意: Extensionのバージョンは同じ名前を使用します。
  name = "my-appconfig-extension"

  # description (Optional)
  # 設定内容: Extensionに関する説明を指定します。
  # 設定可能な値: 文字列
  description = "Custom AppConfig extension for deployment notifications"

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
  # アクションポイント設定
  #-------------------------------------------------------------
  # action_point (Required)
  # 設定内容: Extensionで定義されるアクションポイントを指定します。
  # 複数のaction_pointブロックを定義可能です。
  # 関連機能: AppConfig Extension Action Points
  #   アクションポイントは、AppConfigワークフローの特定のタイミングで
  #   Extensionを呼び出すトリガーを定義します。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/working-with-appconfig-extensions-about.html

  action_point {
    # point (Required)
    # 設定内容: 定義されたアクションを実行するポイントを指定します。
    # 設定可能な値:
    #   - "PRE_CREATE_HOSTED_CONFIGURATION_VERSION": ホスト構成バージョン作成前
    #     リクエスト検証後、構成バージョン作成前に実行。構成内容の変更やエラー時の中止が可能。
    #   - "PRE_START_DEPLOYMENT": デプロイ開始前
    #     デプロイ開始前に実行。エラー発生時はデプロイを中止可能。
    #   - "AT_DEPLOYMENT_TICK": デプロイ中の各ティック
    #     デプロイ中に定期的に実行。同期的かつ並列に実行。エラー時はロールバック。
    #   - "ON_DEPLOYMENT_START": デプロイ開始時
    #     デプロイ開始時に非同期で実行。構成内容は受信しない。エラーは無視される。
    #   - "ON_DEPLOYMENT_STEP": デプロイステップ時
    #     各デプロイステップで非同期に実行。エラーは無視される。
    #   - "ON_DEPLOYMENT_BAKING": デプロイベイキング時
    #     デプロイのベイキング期間中に非同期で実行。エラーは無視される。
    #   - "ON_DEPLOYMENT_COMPLETE": デプロイ完了時
    #     デプロイ完了後に非同期で実行。エラーは無視される。
    #   - "ON_DEPLOYMENT_ROLLED_BACK": デプロイロールバック時
    #     デプロイがロールバックされた時に非同期で実行。エラーは無視される。
    point = "ON_DEPLOYMENT_COMPLETE"

    # action (Required)
    # 設定内容: このアクションポイントで実行するアクションを定義します。
    # 複数のactionブロックを定義可能です（少なくとも1つ必要）。
    action {
      # name (Required)
      # 設定内容: アクションの名前を指定します。
      # 設定可能な値: 最大64文字の文字列
      name = "send-notification"

      # uri (Required)
      # 設定内容: アクションポイントに関連付けるExtension URIを指定します。
      # 設定可能な値: 以下のいずれかのAmazon Resource Name (ARN)
      #   - Lambda関数のARN
      #   - Amazon SQSキューのARN
      #   - Amazon SNSトピックのARN
      #   - Amazon EventBridgeのデフォルトイベントバスのARN
      # 制約: 最小1文字、最大2048文字
      uri = "arn:aws:sns:ap-northeast-1:123456789012:appconfig-notifications"

      # role_arn (Optional)
      # 設定内容: IAM Assume RoleのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      # 制約: 最小20文字、最大2048文字
      # 用途: AppConfigがExtensionを呼び出す際に使用するロール
      # 注意: Lambda関数をURIとして使用する場合、role_arnまたはLambdaリソースポリシーが必要
      role_arn = "arn:aws:iam::123456789012:role/appconfig-extension-role"

      # description (Optional)
      # 設定内容: アクションに関する説明を指定します。
      # 設定可能な値: 最大1024文字の文字列
      description = "Send SNS notification when deployment completes"
    }
  }

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------
  # parameter (Optional)
  # 設定内容: Extensionが受け入れるパラメータを定義します。
  # パラメータ値はCreateExtensionAssociation APIで指定します。
  # Lambda Extensionアクションの場合、これらのパラメータはLambdaリクエストオブジェクトに含まれます。
  # 複数のparameterブロックを定義可能です。

  parameter {
    # name (Required)
    # 設定内容: パラメータの名前を指定します。
    # 設定可能な値: 文字列
    name = "S3BucketArn"

    # required (Optional)
    # 設定内容: Extension関連付け時にパラメータ値の指定が必須かどうかを指定します。
    # 設定可能な値:
    #   - true: パラメータ値の指定が必須
    #   - false: パラメータ値の指定は任意
    required = true

    # description (Optional)
    # 設定内容: パラメータに関する説明を指定します。
    # 設定可能な値: 文字列
    description = "ARN of the S3 bucket for configuration backup"
  }

  parameter {
    name        = "NotificationEmail"
    required    = false
    description = "Email address for optional notifications"
  }

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
    Name        = "my-appconfig-extension"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AppConfig ExtensionのAmazon Resource Name (ARN)
#
# - id: AppConfig ExtensionのID
#
# - version: Extensionのバージョン番号
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
