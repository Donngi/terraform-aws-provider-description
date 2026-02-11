#---------------------------------------------------------------
# AWS AppConfig Extension Association
#---------------------------------------------------------------
#
# AWS AppConfigのエクステンションをアプリケーション、設定プロファイル、
# または環境に関連付けるリソースです。エクステンションアソシエーションを
# 作成すると、設定のデプロイ時などのワークフローでエクステンションが
# 自動的に呼び出されます。
#
# AWS公式ドキュメント:
#   - AppConfigエクステンションの概要: https://docs.aws.amazon.com/appconfig/latest/userguide/working-with-appconfig-extensions-about.html
#   - エクステンションアソシエーションの作成: https://docs.aws.amazon.com/appconfig/latest/userguide/working-with-appconfig-extensions-creating-custom-association.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_extension_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_extension_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # extension_arn (Required)
  # 設定内容: 関連付けるエクステンションのARNを指定します。
  # 設定可能な値: 有効なAppConfigエクステンションのARN
  # 関連機能: AppConfig エクステンション
  #   エクステンションはAppConfigワークフロー中に特定のアクションポイント
  #   （PRE_CREATE_HOSTED_CONFIGURATION_VERSION、ON_DEPLOYMENT_COMPLETEなど）
  #   で実行されるカスタムロジックを定義します。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/working-with-appconfig-extensions-about.html
  extension_arn = "arn:aws:appconfig:ap-northeast-1:123456789012:extension/abc12345/1"

  # resource_arn (Required)
  # 設定内容: エクステンションを関連付けるAppConfigリソースのARNを指定します。
  # 設定可能な値: 以下のいずれかのリソースのARN
  #   - アプリケーション: arn:aws:appconfig:{region}:{account-id}:application/{application-id}
  #   - 設定プロファイル: arn:aws:appconfig:{region}:{account-id}:application/{application-id}/configurationprofile/{profile-id}
  #   - 環境: arn:aws:appconfig:{region}:{account-id}:application/{application-id}/environment/{environment-id}
  # 注意: アプリケーションに関連付けると、そのアプリケーション配下の
  #       すべてのリソースのワークフローでエクステンションが呼び出されます。
  resource_arn = "arn:aws:appconfig:ap-northeast-1:123456789012:application/abc12345"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: エクステンションに渡すパラメータの名前と値を指定します。
  # 設定可能な値: キーと値のペアのマップ（文字列のマップ）
  # 関連機能: AppConfig エクステンションパラメータ
  #   エクステンションで定義されたパラメータに値を設定できます。
  #   例: S3バケットARN、SNSトピックARN、Lambda関数ARNなど
  #   エクステンションが必要とするパラメータはエクステンション定義で確認してください。
  parameters = {
    S3BucketArn = "arn:aws:s3:::my-backup-bucket"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: エクステンションアソシエーションのAmazon Resource Name (ARN)
#
# - id: エクステンションアソシエーションのID
#
# - extension_version: アソシエーションで定義されたエクステンションの
#                      バージョン番号
#---------------------------------------------------------------
