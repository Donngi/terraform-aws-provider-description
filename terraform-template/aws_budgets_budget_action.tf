#---------------------------------------------------------------
# AWS Budgets Budget Action
#---------------------------------------------------------------
#
# AWS Budgetsの予算アクションをプロビジョニングするリソースです。
# 予算アクションは、予算のしきい値を超えた際に自動的またはワークフローの承認
# プロセスを通じて実行されるコスト削減コントロールです。
#
# AWS公式ドキュメント:
#   - AWS Budgets概要: https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html
#   - 予算アクションの設定: https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-controls.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget_action
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_budgets_budget_action" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # budget_name (Required)
  # 設定内容: 予算の名前を指定します。
  # 設定可能な値: 既存の予算名を指定
  budget_name = aws_budgets_budget.example.name

  # account_id (Optional)
  # 設定内容: 予算対象のアカウントIDを指定します。
  # 省略時: 現在のユーザーのアカウントIDが使用されます。
  account_id = null

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # action_type (Required)
  # 設定内容: アクションの種類を指定します。実行可能なタスクの種類を定義します。
  # 設定可能な値:
  #   - "APPLY_IAM_POLICY": IAMポリシーを適用
  #   - "APPLY_SCP_POLICY": サービスコントロールポリシー（SCP）を適用
  #   - "RUN_SSM_DOCUMENTS": Systems Managerドキュメントを実行
  # 注意: 選択したaction_typeに応じてdefinitionブロック内の設定が変わります。
  action_type = "APPLY_IAM_POLICY"

  # approval_model (Required)
  # 設定内容: アクションの承認モデルを指定します。
  # 設定可能な値:
  #   - "AUTOMATIC": しきい値に達したら自動的にアクションを実行
  #   - "MANUAL": 手動承認後にアクションを実行
  approval_model = "AUTOMATIC"

  # execution_role_arn (Required)
  # 設定内容: アクションの実行および取り消しに使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールとアクションは同じアカウント内にある必要があります。
  #       budgets.amazonaws.comサービスプリンシパルが信頼されている必要があります。
  execution_role_arn = aws_iam_role.example.arn

  # notification_type (Required)
  # 設定内容: 通知のタイプを指定します。
  # 設定可能な値:
  #   - "ACTUAL": 実際のコスト/使用量に基づく通知
  #   - "FORECASTED": 予測されるコスト/使用量に基づく通知
  notification_type = "ACTUAL"

  #-------------------------------------------------------------
  # アクションしきい値 (必須ブロック)
  #-------------------------------------------------------------
  # アクションをトリガーするしきい値を定義します。

  action_threshold {
    # action_threshold_type (Required)
    # 設定内容: しきい値のタイプを指定します。
    # 設定可能な値:
    #   - "PERCENTAGE": パーセンテージ（例: 予算の90%）
    #   - "ABSOLUTE_VALUE": 絶対値（例: $100）
    action_threshold_type = "PERCENTAGE"

    # action_threshold_value (Required)
    # 設定内容: しきい値の数値を指定します。
    # 設定可能な値: 数値（typeがPERCENTAGEの場合は0-100、ABSOLUTE_VALUEの場合は任意の正数）
    action_threshold_value = 90
  }

  #-------------------------------------------------------------
  # 定義 (必須ブロック)
  #-------------------------------------------------------------
  # action_typeに応じた具体的なアクション定義を指定します。
  # 以下の3つのサブブロックから1つを選択して設定します。

  definition {
    #-----------------------------------------------------------
    # IAMアクション定義 (action_type = "APPLY_IAM_POLICY" の場合)
    #-----------------------------------------------------------
    # IAMポリシーを適用するアクションの詳細を指定します。

    iam_action_definition {
      # policy_arn (Required)
      # 設定内容: アタッチするIAMポリシーのARNを指定します。
      # 設定可能な値: 有効なIAMポリシーARN
      policy_arn = aws_iam_policy.example.arn

      # groups (Optional)
      # 設定内容: ポリシーをアタッチするIAMグループのリストを指定します。
      # 設定可能な値: IAMグループ名のセット
      # 注意: groups, roles, usersのうち少なくとも1つを指定する必要があります。
      groups = null

      # roles (Optional)
      # 設定内容: ポリシーをアタッチするIAMロールのリストを指定します。
      # 設定可能な値: IAMロール名のセット
      # 注意: groups, roles, usersのうち少なくとも1つを指定する必要があります。
      roles = [aws_iam_role.example.name]

      # users (Optional)
      # 設定内容: ポリシーをアタッチするIAMユーザーのリストを指定します。
      # 設定可能な値: IAMユーザー名のセット
      # 注意: groups, roles, usersのうち少なくとも1つを指定する必要があります。
      users = null
    }

    #-----------------------------------------------------------
    # SCPアクション定義 (action_type = "APPLY_SCP_POLICY" の場合)
    #-----------------------------------------------------------
    # サービスコントロールポリシーを適用するアクションの詳細を指定します。
    # 注意: 管理アカウントからのみ使用可能です。

    # scp_action_definition {
    #   # policy_id (Required)
    #   # 設定内容: アタッチするSCPポリシーのIDを指定します。
    #   # 設定可能な値: 有効なSCPポリシーID
    #   policy_id = "p-xxxxxxxx"
    #
    #   # target_ids (Required)
    #   # 設定内容: ポリシーを適用するターゲットID（アカウントまたはOU）のリストを指定します。
    #   # 設定可能な値: アカウントIDまたはOU IDのセット
    #   target_ids = ["123456789012"]
    # }

    #-----------------------------------------------------------
    # SSMアクション定義 (action_type = "RUN_SSM_DOCUMENTS" の場合)
    #-----------------------------------------------------------
    # Systems Managerドキュメントを実行するアクションの詳細を指定します。

    # ssm_action_definition {
    #   # action_sub_type (Required)
    #   # 設定内容: アクションのサブタイプを指定します。
    #   # 設定可能な値:
    #   #   - "STOP_EC2_INSTANCES": EC2インスタンスを停止
    #   #   - "STOP_RDS_INSTANCES": RDSインスタンスを停止
    #   action_sub_type = "STOP_EC2_INSTANCES"
    #
    #   # instance_ids (Required)
    #   # 設定内容: 対象のEC2またはRDSインスタンスIDのリストを指定します。
    #   # 設定可能な値: インスタンスIDのセット
    #   instance_ids = ["i-1234567890abcdef0"]
    #
    #   # region (Required)
    #   # 設定内容: SSMドキュメントを実行するリージョンを指定します。
    #   # 設定可能な値: 有効なAWSリージョンコード
    #   region = "ap-northeast-1"
    # }
  }

  #-------------------------------------------------------------
  # 購読者 (必須ブロック)
  #-------------------------------------------------------------
  # 予算アクションの通知を受け取る購読者を定義します。
  # 1つ以上11つ以下の購読者を指定できます。

  subscriber {
    # address (Required)
    # 設定内容: 通知の送信先アドレスを指定します。
    # 設定可能な値:
    #   - subscription_typeが"EMAIL"の場合: メールアドレス
    #   - subscription_typeが"SNS"の場合: SNSトピックARN
    address = "example@example.com"

    # subscription_type (Required)
    # 設定内容: 通知の種類を指定します。
    # 設定可能な値:
    #   - "EMAIL": メール通知
    #   - "SNS": SNS通知
    subscription_type = "EMAIL"
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
    Name        = "example-budget-action"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - action_id: 予算アクションのID
#
# - arn: 予算アクションのAmazon Resource Name (ARN)
#
# - status: 予算アクションのステータス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
