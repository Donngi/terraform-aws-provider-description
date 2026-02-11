#---------------------------------------------------------------
# AWS AppConfig Hosted Configuration Version
#---------------------------------------------------------------
#
# AWS AppConfigのホスト型設定バージョンをプロビジョニングするリソースです。
# AWS AppConfigホスト型設定ストアに設定データを保存し、バージョン管理を
# 行うことで、アプリケーションの設定変更を安全にデプロイできます。
#
# AWS公式ドキュメント:
#   - AppConfig概要: https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html
#   - CreateHostedConfigurationVersion API: https://docs.aws.amazon.com/appconfig/2019-10-09/APIReference/API_CreateHostedConfigurationVersion.html
#   - Feature Flags型リファレンス: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-type-reference-feature-flags.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_hosted_configuration_version
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_hosted_configuration_version" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # application_id (Required, Forces new resource)
  # 設定内容: 設定バージョンを作成するAppConfigアプリケーションのIDを指定します。
  # 設定可能な値: AppConfigアプリケーションのID（例: "abc1234"）
  # 関連機能: AWS AppConfig アプリケーション
  #   AppConfigでは、まずアプリケーションを作成し、その中に設定プロファイルを作成します。
  #   ホスト型設定バージョンはその設定プロファイルに関連付けられます。
  application_id = aws_appconfig_application.example.id

  # configuration_profile_id (Required, Forces new resource)
  # 設定内容: 設定バージョンを作成する設定プロファイルのIDを指定します。
  # 設定可能な値: AppConfig設定プロファイルのID（例: "ur8hx2f"）
  # 関連機能: AWS AppConfig 設定プロファイル
  #   設定プロファイルは、設定データの場所とバリデーション方法を定義します。
  #   ホスト型設定ストアを使用する場合、設定データはAWS内部に保存されます。
  configuration_profile_id = aws_appconfig_configuration_profile.example.configuration_profile_id

  # content (Required, Forces new resource, Sensitive)
  # 設定内容: 設定データまたは設定の内容を指定します。
  # 設定可能な値: 任意のテキストまたはバイナリデータ
  #   - JSON、YAML、TOMLなどのテキスト形式
  #   - Protocol Buffersや圧縮データなどのバイナリ形式
  # 注意: この属性はsensitiveとしてマークされており、Terraformのログや出力では
  #       マスクされます。
  # 関連機能: AWS AppConfig ホスト型設定ストア
  #   設定データはAppConfigに直接保存され、外部ストレージ（S3、Parameter Store等）
  #   を使用せずに設定管理が可能です。
  content = jsonencode({
    foo            = "bar"
    fruit          = ["apple", "pear", "orange"]
    isThingEnabled = true
  })

  # content_type (Required, Forces new resource)
  # 設定内容: 設定コンテンツの形式を示す標準MIMEタイプを指定します。
  # 設定可能な値: 有効なMIMEタイプ文字列（1-255文字）
  #   - "application/json": JSON形式の設定データ
  #   - "application/x-yaml": YAML形式の設定データ
  #   - "text/plain": プレーンテキスト形式
  #   - その他の有効なMIMEタイプ
  # 参考: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17
  content_type = "application/json"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: 設定の説明を指定します。
  # 設定可能な値: 0-1024文字の文字列
  # 注意: HTTPの制限により、ASCII文字のみがサポートされています。
  description = "Example Hosted Configuration Version"

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
  # ID設定（通常は省略）
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: アプリケーションID、設定プロファイルID、バージョン番号をスラッシュで
  #              区切った文字列（例: "abc1234/ur8hx2f/1"）
  # 省略時: Terraformが自動的に生成します。
  # 注意: 通常、この属性を明示的に設定する必要はありません。Terraformが内部で管理します。
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AppConfigホスト型設定バージョンのAmazon Resource Name (ARN)
#
# - id: AppConfigアプリケーションID、設定プロファイルID、およびバージョン番号を
#       スラッシュ（/）で区切った値
#       例: "abc1234/ur8hx2f/1"
#
# - version_number: ホスト型設定のバージョン番号
#       新しいバージョンが作成されるたびに自動的にインクリメントされます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# Feature Flagsを使用する場合は、以下のような構造でcontentを定義します:
#
# content = jsonencode({
#   flags = {
#     myFeature = {
#       name = "myFeature"
#     }
#   }
#   values = {
#---------------------------------------------------------------
