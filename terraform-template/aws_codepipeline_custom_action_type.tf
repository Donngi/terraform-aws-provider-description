################################################################################
# aws_codepipeline_custom_action_type
################################################################################
# Generated: 2026-01-19
# Provider version: 6.28.0
#
# このテンプレートは生成時点での情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_custom_action_type
################################################################################

# Provides a CodePipeline CustomActionType
# Creates a custom action for activities not included in the default actions
# such as custom build, deploy, test, or invoke actions
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/codepipeline/latest/userguide/actions-create-custom-action.html
# https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_CreateCustomActionType.html

resource "aws_codepipeline_custom_action_type" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # (Required) The category of the custom action
  # Valid values: Source, Build, Deploy, Test, Invoke, Approval
  # 例: "Build" - ビルドアクション
  # 例: "Deploy" - デプロイアクション
  # 例: "Test" - テストアクション
  # 例: "Invoke" - 関数実行アクション
  category = "Build"

  # (Required) The provider of the service used in the custom action
  # カスタムアクションのプロバイダー名
  # 例: "MyCustomProvider", "Jenkins", "TeamCity"
  provider_name = "example"

  # (Required) The version identifier of the custom action
  # カスタムアクションのバージョン
  # 例: "1", "2", "1.0"
  version = "1"

  ################################################################################
  # Optional Arguments
  ################################################################################

  # (Optional) ID of the custom action
  # Composed of category, provider and version
  # 例: "Build:terraform:1"
  # デフォルトではTerraformが自動生成
  # id = "Build:example:1"

  # (Optional) Region where this resource will be managed
  # デフォルトではプロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) Map of tags to assign to this resource
  # プロバイダーのdefault_tagsブロックで定義されたタグと重複するキーは上書きされます
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-custom-action"
    Environment = "production"
  }

  # (Optional) タグの全マップ（プロバイダーのdefault_tagsから継承されたタグを含む）
  # 通常はTerraformが自動管理するため、明示的な設定は不要
  # tags_all = {}

  ################################################################################
  # Block: configuration_property (Optional)
  ################################################################################

  # (Optional) The configuration properties for the custom action
  # カスタムアクションの構成プロパティ（最大10個）
  # カスタムアクションをパイプラインに追加する際にユーザーが設定できるプロパティを定義
  configuration_property {
    # (Required) The name of the action configuration property
    # プロパティの名前
    name = "ProjectName"

    # (Required) Whether the configuration property is a key
    # プロパティがキーかどうか
    # キープロパティは、URLテンプレート内で{Config:name}形式で参照可能
    key = true

    # (Required) Whether the configuration property is a required value
    # プロパティが必須かどうか
    required = true

    # (Required) Whether the configuration property is secret
    # プロパティがシークレット（機密情報）かどうか
    # trueの場合、値は暗号化されて保存され、ログに表示されません
    secret = false

    # (Optional) The description of the action configuration property
    # プロパティの説明
    description = "The name of the build project"

    # (Optional) Indicates that the property will be used in conjunction with PollForJobs
    # PollForJobsと組み合わせて使用されるかどうか
    # trueの場合、ジョブワーカーがジョブをポーリングする際にこのプロパティでフィルタリング可能
    queryable = false

    # (Optional) The type of the configuration property
    # プロパティの型
    # 例: "String", "Number", "Boolean"
    type = "String"
  }

  ################################################################################
  # Block: input_artifact_details (Required)
  ################################################################################

  # (Required) The details of the input artifact for the action
  # アクションの入力アーティファクトの詳細
  input_artifact_details {
    # (Required) The minimum number of artifacts allowed for the action type
    # 許可される最小アーティファクト数
    # Min: 0, Max: 5
    minimum_count = 0

    # (Required) The maximum number of artifacts allowed for the action type
    # 許可される最大アーティファクト数
    # Min: 0, Max: 5
    maximum_count = 1
  }

  ################################################################################
  # Block: output_artifact_details (Required)
  ################################################################################

  # (Required) The details of the output artifact of the action
  # アクションの出力アーティファクトの詳細
  output_artifact_details {
    # (Required) The minimum number of artifacts allowed for the action type
    # 許可される最小アーティファクト数
    # Min: 0, Max: 5
    minimum_count = 0

    # (Required) The maximum number of artifacts allowed for the action type
    # 許可される最大アーティファクト数
    # Min: 0, Max: 5
    maximum_count = 1
  }

  ################################################################################
  # Block: settings (Optional)
  ################################################################################

  # (Optional) The settings for an action type
  # アクションタイプの設定（URLテンプレート）
  settings {
    # (Optional) The URL returned to the AWS CodePipeline console that provides
    # a deep link to the resources of the external system
    # 外部システムのリソースへのディープリンクを提供する静的URL
    # {Config:name}形式で必須かつ非シークレットの構成プロパティを参照可能
    # 例: "https://my-build-instance/job/{Config:ProjectName}/"
    entity_url_template = "https://example.com/project/{Config:ProjectName}/"

    # (Optional) The URL returned to the AWS CodePipeline console that contains
    # a link to the top-level landing page for the external system
    # 外部システムのトップレベルランディングページへのリンクを含む動的URL
    # {ExternalExecutionId}でジョブワーカーが提供する実行IDを参照可能
    # 例: "https://my-build-instance/job/{Config:ProjectName}/lastSuccessfulBuild/{ExternalExecutionId}/"
    execution_url_template = "https://example.com/execution/{ExternalExecutionId}/"

    # (Optional) The URL returned to the AWS CodePipeline console that contains
    # a link to the page where customers can update or change the configuration
    # of the external action
    # 外部アクションの設定を更新・変更できるページへのリンク
    revision_url_template = "https://example.com/revision/{Config:ProjectName}/"

    # (Optional) The URL of a sign-up page where users can sign up for an
    # external service and perform initial configuration of the action provided
    # by that service
    # ユーザーが外部サービスにサインアップし、初期設定を実行できるページのURL
    third_party_configuration_url = "https://example.com/signup"
  }
}

################################################################################
# Outputs (Computed Attributes)
################################################################################
# 以下の属性は、リソース作成後にTerraformによって計算されます

# arn - The action ARN
# アクションのARN
# 例: aws_codepipeline_custom_action_type.example.arn

# owner - The creator of the action being called
# アクションの作成者（常に "Custom"）
# 例: aws_codepipeline_custom_action_type.example.owner

# id - Composed of category, provider and version
# カテゴリ、プロバイダー、バージョンから構成されるID
# 例: "Build:example:1"
# 例: aws_codepipeline_custom_action_type.example.id

# tags_all - A map of tags assigned to the resource, including those inherited
# from the provider default_tags configuration block
# リソースに割り当てられた全タグのマップ（プロバイダーのdefault_tagsから継承されたものを含む）
# 例: aws_codepipeline_custom_action_type.example.tags_all
