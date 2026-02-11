# ==============================================================================
# AWS Config Conformance Pack - Annotated Template
# ==============================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# Note: このテンプレートは生成時点(2026-01-19)の情報です。
#       最新の仕様は公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_conformance_pack
# ==============================================================================

resource "aws_config_conformance_pack" "example" {
  # ==============================================================================
  # 必須パラメータ
  # ==============================================================================

  # name - (Required, Forces new resource)
  # Conformance Packの名前。
  # - 文字で始まる必要がある
  # - 1〜256文字の英数字とハイフンを含むことができる
  # - この値を変更するとリソースが再作成される
  # 参考: https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html
  name = "example-conformance-pack"

  # ==============================================================================
  # オプションパラメータ - テンプレート設定
  # ==============================================================================

  # template_body - (Optional)
  # Conformance Packテンプレートの完全な本文を含む文字列。
  # - 最大長: 51200文字
  # - CloudFormationテンプレート形式でConfig Rulesと修復アクションを定義
  # - template_s3_uriが提供されない場合は必須
  # - このパラメータではドリフト検出が不可能
  # 注意: template_bodyとtemplate_s3_uriの両方が指定された場合、
  #       AWS Configはtemplate_s3_uriを使用しtemplate_bodyは無視される
  # サンプルテンプレート: https://github.com/awslabs/aws-config-rules/tree/master/aws-config-conformance-packs
  template_body = <<-EOT
    Parameters:
      AccessKeysRotatedParameterMaxAccessKeyAge:
        Type: String
    Resources:
      IAMPasswordPolicy:
        Properties:
          ConfigRuleName: IAMPasswordPolicy
          Source:
            Owner: AWS
            SourceIdentifier: IAM_PASSWORD_POLICY
        Type: AWS::Config::ConfigRule
  EOT

  # template_s3_uri - (Optional)
  # テンプレート本文を含むファイルの場所（例: s3://bucketname/prefix）。
  # - 最大長: 1024文字
  # - URIはConformance Packと同じリージョンのS3バケット内のテンプレートを指す必要がある
  # - template_bodyが提供されない場合は必須
  # - このパラメータではドリフト検出が不可能
  # 注意: template_bodyとtemplate_s3_uriの両方が指定された場合、
  #       AWS Configはtemplate_s3_uriを使用しtemplate_bodyは無視される
  # template_s3_uri = "s3://my-bucket/conformance-pack-template.yaml"

  # ==============================================================================
  # オプションパラメータ - 配信設定
  # ==============================================================================

  # delivery_s3_bucket - (Optional)
  # AWS ConfigがConformance Packテンプレートを保存するAmazon S3バケット。
  # - 最大長: 63文字
  # - Conformance Packの評価結果もこのバケットに配信される
  # delivery_s3_bucket = "config-conformance-pack-delivery-bucket"

  # delivery_s3_key_prefix - (Optional)
  # Amazon S3バケットのプレフィックス。
  # - 最大長: 1024文字
  # - S3バケット内でConformance Pack配信ファイルを整理するために使用
  # delivery_s3_key_prefix = "conformance-packs/"

  # ==============================================================================
  # オプションパラメータ - リージョン設定
  # ==============================================================================

  # region - (Optional)
  # このリソースが管理されるリージョン。
  # - 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトとなる
  # - マルチリージョン展開時に有用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  # region = "us-east-1"

  # id - (Optional)
  # Terraformリソース識別子。
  # - 通常は明示的に設定する必要はない
  # - AWSが自動的に生成・管理する
  # id = null

  # ==============================================================================
  # ネストブロック - input_parameter
  # ==============================================================================
  # Conformance Packテンプレートに渡す入力パラメータを記述する設定ブロック。
  # - 最大60個まで設定可能
  # - パラメータは template_body または template_s3_uri のテンプレート内でも定義されている必要がある
  # - テンプレート内のConfig Rulesの動作をカスタマイズするために使用
  # ==============================================================================

  input_parameter {
    # parameter_name - (Required)
    # 入力パラメータのキー（名前）。
    # - テンプレート内のParametersセクションで定義されたパラメータ名と一致する必要がある
    parameter_name = "AccessKeysRotatedParameterMaxAccessKeyAge"

    # parameter_value - (Required)
    # 入力パラメータの値。
    # - テンプレート内のパラメータ型に応じた適切な値を設定
    # - 例: 日数、文字列、ブール値など
    parameter_value = "90"
  }

  # 複数のパラメータを設定する例
  # input_parameter {
  #   parameter_name  = "RequiredTagKey"
  #   parameter_value = "Environment"
  # }

  # ==============================================================================
  # 依存関係の注意事項
  # ==============================================================================
  # Conformance Packを正常に作成・更新するには、アカウントに適切なIAM権限を持つ
  # Configuration Recorderが必要です。
  #
  # depends_on = [aws_config_configuration_recorder.example]
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder
  # ==============================================================================

  # ==============================================================================
  # Computed Attributes (Read-Only)
  # ==============================================================================
  # 以下の属性はAWSによって自動的に設定され、参照のみ可能です:
  #
  # - arn: Conformance PackのAmazon Resource Name (ARN)
  # ==============================================================================
}
