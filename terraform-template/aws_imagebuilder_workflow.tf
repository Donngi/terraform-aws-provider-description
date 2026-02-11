#---------------------------------------------------------------
# AWS EC2 Image Builder Workflow
#---------------------------------------------------------------
#
# AWS EC2 Image Builder Workflowリソースを管理します。
# ワークフローはイメージビルドプロセスの各段階（BUILD、TEST）で実行される
# 自動化ステップを定義します。YAMLフォーマットで記述されたワークフロー定義を
# 使用して、イメージビルドやテストの自動化を実現します。
#
# 注意: Image Builderはディストリビューション段階のワークフローを管理するため、
#       DISTRIBUTIONワークフロータイプを使用するとエラーが発生します。
#
# AWS公式ドキュメント:
#   - Image Builder概要: https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html
#   - Workflow概要: https://docs.aws.amazon.com/imagebuilder/latest/userguide/workflows.html
#   - Workflow定義: https://docs.aws.amazon.com/imagebuilder/latest/userguide/workflow-document.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_workflow
#
# Provider Version: 6.28.0
# Generated: 2025-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_workflow" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ワークフローの名前を指定します。
  # 設定可能な値: 文字列
  # 制約: Image Builder内でワークフローを識別する名前
  name = "example-workflow"

  # version (Required)
  # 設定内容: ワークフローのバージョンを指定します。
  # 設定可能な値: セマンティックバージョニング形式の文字列（例: "1.0.0"）
  # 注意: バージョン管理により、ワークフローの変更履歴を追跡できます
  version = "1.0.0"

  # type (Required)
  # 設定内容: ワークフローのタイプを指定します。
  # 設定可能な値:
  #   - "BUILD": ビルドフェーズで実行されるワークフロー
  #   - "TEST": テストフェーズで実行されるワークフロー
  # 注意: "DISTRIBUTION"タイプは使用できません（Image Builderが自動管理）
  type = "TEST"

  #-------------------------------------------------------------
  # ワークフロー定義（dataまたはuriのいずれか必須）
  #-------------------------------------------------------------

  # data (Optional)
  # 設定内容: インラインYAML形式でワークフロー定義を指定します。
  # 設定可能な値: YAML形式のワークフロー定義文字列
  # 注意: dataとuriは排他的（どちらか一方のみ指定）
  # 関連機能:
  #   - ワークフローはAWSS Systems Manager Automation形式で記述
  #   - name、description、schemaVersion、steps等を含むYAMLドキュメント
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/workflow-document.html
  data = <<-EOT
  name: example
  description: Workflow to test an image
  schemaVersion: 1.0

  parameters:
    - name: waitForActionAtEnd
      type: boolean

  steps:
    - name: LaunchTestInstance
      action: LaunchInstance
      onFailure: Abort
      inputs:
        waitFor: "ssmAgent"

    - name: TerminateTestInstance
      action: TerminateInstance
      onFailure: Continue
      inputs:
        instanceId.$: "$.stepOutputs.LaunchTestInstance.instanceId"

    - name: WaitForActionAtEnd
      action: WaitForAction
      if:
        booleanEquals: true
        value: "$.parameters.waitForActionAtEnd"
  EOT

  # uri (Optional)
  # 設定内容: S3に保存されたワークフロー定義のURIを指定します。
  # 設定可能な値: S3 URI形式の文字列（例: s3://bucket-name/workflow.yaml）
  # 注意: dataとuriは排他的（どちらか一方のみ指定）
  # 使用例: 大規模なワークフロー定義や複数リソース間で共有する場合に便利
  # uri = "s3://my-bucket/workflows/test-workflow.yaml"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ワークフローの説明を指定します。
  # 設定可能な値: 文字列
  description = "Example workflow for testing EC2 Image Builder images"

  # change_description (Optional)
  # 設定内容: ワークフローの変更内容の説明を指定します。
  # 設定可能な値: 文字列
  # 用途: バージョン更新時の変更点を記録
  change_description = "Initial version of the workflow"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: ワークフローを暗号化するためのKMSキーのARNを指定します。
  # 設定可能な値: KMSキーのAmazon Resource Name (ARN)
  # 省略時: AWS管理のキーで暗号化
  # 注意: カスタムKMSキーを使用する場合は、Image Builderサービスに
  #       キーの使用権限を付与する必要があります
  # 例: "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  # kms_key_id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: ワークフローに付与するタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: プロバイダーのdefault_tags設定ブロックと組み合わせて使用可能
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-workflow"
    Environment = "development"
    ManagedBy   = "terraform"
  }

  # tags_all (Computed)
  # 説明: リソースに割り当てられた全てのタグ（プロバイダーのdefault_tagsを含む）
  # 参照のみ: このパラメータは自動的に計算され、参照のみ可能です
  # 用途: プロバイダー設定のdefault_tagsとリソース固有のtagsの統合結果を確認
}

#---------------------------------------------------------------
# Computed Attributes（参照専用の出力値）
#---------------------------------------------------------------
#
# 以下の属性は、リソース作成後にTerraformによって自動的に設定されます。
# これらの値は他のリソースで参照することができます。
#
# - id: ワークフローのAmazon Resource Name (ARN)
#   例: aws_imagebuilder_workflow.example.id
#
# - arn: ワークフローのAmazon Resource Name (ARN)
#   例: aws_imagebuilder_workflow.example.arn
#
# - date_created: ワークフローが作成された日時
#   例: aws_imagebuilder_workflow.example.date_created
#
# - owner: ワークフローの所有者（AWS アカウントID）
#   例: aws_imagebuilder_workflow.example.owner
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: ワークフローの参照
#---------------------------------------------------------------
#
# Image Builderのイメージレシピやコンポーネントと組み合わせて使用：
#
# resource "aws_imagebuilder_image_recipe" "example" {
#   name         = "example-recipe"
#   parent_image = "arn:aws:imagebuilder:ap-northeast-1:aws:image/amazon-linux-2-x86/x.x.x"
#   version      = "1.0.0"
#
#   component {
#     component_arn = aws_imagebuilder_component.example.arn
#   }
#
#   # ワークフローを関連付け（Image Pipelineレベルで設定）
#   # workflow {
#   #   workflow_arn = aws_imagebuilder_workflow.example.arn
#   # }
# }
#
# resource "aws_imagebuilder_image_pipeline" "example" {
#   name                             = "example-pipeline"
#   image_recipe_arn                 = aws_imagebuilder_image_recipe.example.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn
#
#   workflow {
#     workflow_arn = aws_imagebuilder_workflow.example.arn
#     # パラメータの指定
#     parameter {
#       name  = "waitForActionAtEnd"
#       value = "true"
#     }
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import（既存リソースのインポート）
#---------------------------------------------------------------
#
# 既存のImage Builder WorkflowをTerraformで管理する場合：
#
# terraform import aws_imagebuilder_workflow.example arn:aws:imagebuilder:ap-northeast-1:123456789012:workflow/test/example/1.0.0
#
# ARN形式: arn:aws:imagebuilder:<region>:<account-id>:workflow/<type>/<name>/<version>
#
#---------------------------------------------------------------
