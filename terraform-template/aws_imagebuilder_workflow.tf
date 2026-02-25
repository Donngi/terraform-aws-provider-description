#---------------------------------------------------------------
# AWS EC2 Image Builder Workflow
#---------------------------------------------------------------
#
# Amazon EC2 Image Builderのワークフローをプロビジョニングするリソースです。
# ワークフローはイメージ作成のビルドおよびテストステージで実行されるステップの
# シーケンスを定義し、イメージ作成プロセスの柔軟性・可視性・制御性を提供します。
# なお、DISTRIBUTIONタイプはImage Builderが内部管理するため、このリソースでは
# BUILD または TEST タイプのみ指定可能です。
#
# AWS公式ドキュメント:
#   - Image Builderワークフロー管理: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-image-workflows.html
#   - YAMLワークフロードキュメント作成: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-workflow-create-document.html
#   - ワークフローリソース作成: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-workflow-create-resource.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_workflow
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_workflow" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ワークフローの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-workflow"

  # type (Required)
  # 設定内容: ワークフローのタイプを指定します。
  # 設定可能な値:
  #   - "BUILD": ビルドステージで実行されるワークフロー。ベースイメージへの変更や
  #              スナップショット・コンテナイメージの作成を行うステップを定義します。
  #   - "TEST": テストステージで実行されるワークフロー。イメージの設定検証や
  #             動作確認を行うステップを定義します。
  # 注意: DISTRIBUTIONタイプはImage Builderが内部管理するため、指定するとエラーになります。
  type = "TEST"

  # version (Required)
  # 設定内容: ワークフローのバージョンを指定します。
  # 設定可能な値: セマンティックバージョン形式の文字列（例: "1.0.0"）
  version = "1.0.0"

  #-------------------------------------------------------------
  # ワークフロー定義設定
  #-------------------------------------------------------------

  # data (Optional)
  # 設定内容: ワークフロー定義をインラインYAML文字列で指定します。
  # 設定可能な値: YAMLフォーマットの文字列。schemaVersion、steps等を含むワークフロードキュメント。
  # 省略時: null（uriを指定する場合は省略してください）
  # 注意: dataとuriは排他的です。どちらか一方のみ指定できます。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-workflow-create-document.html
  data = <<-EOT
  name: example-workflow
  description: Example workflow to test an image
  schemaVersion: 1.0

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
  EOT

  # uri (Optional)
  # 設定内容: S3上のワークフロードキュメントのURIを指定します。
  # 設定可能な値: s3:// スキーマで始まる有効なS3 URIの文字列
  # 省略時: null（dataを指定する場合は省略してください）
  # 注意: dataとuriは排他的です。どちらか一方のみ指定できます。
  uri = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ワークフローの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: null（説明なし）
  description = "Example workflow for testing images"

  # change_description (Optional)
  # 設定内容: このバージョンに対する変更の説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: null（変更説明なし）
  change_description = "Initial version"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: ワークフローの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なAWS KMSキーのARN文字列
  # 省略時: null（デフォルトの暗号化を使用）
  kms_key_id = null

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: null（タグなし）
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-workflow"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ワークフローのAmazon Resource Name (ARN)
#
# - date_created: ワークフローが作成された日時
#
# - owner: ワークフローの所有者
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
