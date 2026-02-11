#---------------------------------------------------------------
# AWS CodeCommit Trigger
#---------------------------------------------------------------
#
# AWS CodeCommitリポジトリのトリガーをプロビジョニングするリソースです。
# トリガーを使用すると、特定のリポジトリイベント（プッシュ、ブランチ作成など）が
# 発生した際に、Amazon SNSトピックへの通知やAWS Lambda関数の呼び出しなどの
# アクションを実行できます。
#
# 注意: Terraformは現在、複数のaws_codecommit_triggerリソースを定義しても、
#       リポジトリごとに1つのトリガーしか作成できません。また、Terraformで
#       トリガーを作成すると、リポジトリ内の他のすべてのトリガー
#       （手動で作成されたトリガーを含む）が削除されます。
#
# AWS公式ドキュメント:
#   - CodeCommitトリガーの管理: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-notify.html
#   - RepositoryTrigger API: https://docs.aws.amazon.com/codecommit/latest/APIReference/API_RepositoryTrigger.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_trigger
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codecommit_trigger" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # repository_name (Required)
  # 設定内容: トリガーを設定するCodeCommitリポジトリの名前を指定します。
  # 設定可能な値: 100文字未満のリポジトリ名
  # 注意: この値を変更すると、リソースが再作成されます
  repository_name = "my-repository"

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 省略時: Terraformが自動的にIDを生成します
  # 注意: 通常は省略することを推奨します
  id = null

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
  # トリガー設定
  #-------------------------------------------------------------

  # trigger (Required, 最小: 1, 最大: 10)
  # 設定内容: CodeCommitリポジトリのトリガー設定を定義します。
  # 注意: リポジトリごとに最大10個のトリガーを作成できます
  trigger {
    # name (Required)
    # 設定内容: トリガーの名前を指定します。
    # 設定可能な値: トリガーを識別する一意の名前
    name = "trigger-all-events"

    # destination_arn (Required)
    # 設定内容: トリガーのターゲットとなるリソースのARNを指定します。
    # 設定可能な値:
    #   - Amazon SNSトピックのARN
    #   - AWS Lambda関数のARN（関数にCodeCommitからの呼び出し権限が必要）
    # 参考:
    #   - SNSトピックの例: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-notify-sns.html
    #   - Lambda関数の例: https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-notify-lambda.html
    destination_arn = "arn:aws:sns:ap-northeast-1:123456789012:my-topic"

    # events (Required)
    # 設定内容: トリガーを実行するリポジトリイベントのタイプを指定します。
    # 設定可能な値:
    #   - "all": すべてのリポジトリイベント
    #   - "updateReference": コミットがプッシュされた時（既存のブランチやタグの更新）
    #   - "createReference": 新しいブランチまたはタグが作成された時
    #   - "deleteReference": ブランチまたはタグが削除された時
    # 注意: "all"は他の値と組み合わせて使用できません
    # 参考: https://docs.aws.amazon.com/codecommit/latest/APIReference/API_RepositoryTrigger.html
    events = ["all"]

    # branches (Optional)
    # 設定内容: トリガー設定に含めるブランチを指定します。
    # 設定可能な値:
    #   - ブランチ名のリスト（例: ["main", "develop"]）
    #   - 空の配列または省略: すべてのブランチにトリガーが適用されます
    # 制約: 各ブランチ名は1〜256文字
    # 注意: 配列は必須ですが、内容は空でも構いません
    branches = []

    # custom_data (Optional)
    # 設定内容: トリガーのターゲットに送信される情報に含めるカスタムデータを指定します。
    # 設定可能な値: 任意の文字列（例: IRCチャンネル名、追加のメタデータなど）
    # 用途: トリガーのターゲット側で追加のコンテキスト情報が必要な場合に使用
    custom_data = null
  }

  # 追加のトリガー例（最大10個まで設定可能）
  # trigger {
  #   name            = "trigger-main-branch-only"
  #   destination_arn = "arn:aws:sns:ap-northeast-1:123456789012:my-topic"
  #   events          = ["updateReference", "createReference"]
  #   branches        = ["main"]
  #   custom_data     = "production-environment"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - configuration_id: システムが生成する一意の識別子
#
#---------------------------------------------------------------
