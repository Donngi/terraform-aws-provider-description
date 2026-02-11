#---------------------------------------------------------------
# AWS AppConfig Configuration Profile
#---------------------------------------------------------------
#
# AWS AppConfigの設定プロファイルをプロビジョニングするリソースです。
# 設定プロファイルは、AWS AppConfigが設定ソースにアクセスするための情報を定義します。
# ホステッド設定ストア、SSMパラメータストア、S3、Secrets Manager、CodePipelineなど、
# 様々な設定ソースから設定データを取得できます。
#
# AWS公式ドキュメント:
#   - AWS AppConfig概要: https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html
#   - 設定プロファイルの作成: https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-configuration-and-profile.html
#   - CreateConfigurationProfile API: https://docs.aws.amazon.com/appconfig/2019-10-09/APIReference/API_CreateConfigurationProfile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_configuration_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appconfig_configuration_profile" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # application_id (Required, Forces new resource)
  # 設定内容: 設定プロファイルを作成するAppConfigアプリケーションのIDを指定します。
  # 設定可能な値: 4〜7文字の英小文字・数字で構成されるアプリケーションID
  application_id = aws_appconfig_application.example.id

  # name (Required)
  # 設定内容: 設定プロファイルの名前を指定します。
  # 設定可能な値: 1〜128文字の文字列
  name = "example-configuration-profile"

  # location_uri (Required, Forces new resource)
  # 設定内容: 設定データの場所を示すURIを指定します。
  # 設定可能な値:
  #   - "hosted": AppConfigホステッド設定ストアまたはフィーチャーフラグ用
  #   - "ssm-parameter://<parameter_name>": SSMパラメータストアのパラメータ名
  #   - "ssm-parameter://<parameter_arn>": SSMパラメータストアのARN
  #   - "ssm-document://<document_name>": SSMドキュメント名
  #   - "ssm-document://<document_arn>": SSMドキュメントのARN
  #   - "s3://<bucket>/<objectKey>": S3オブジェクトのURI
  #   - "codepipeline://<pipeline_name>": CodePipelineパイプライン名
  #   - "secretsmanager://<secret_name>": Secrets Managerシークレット名
  # 関連機能: AWS AppConfig 設定ソース
  #   様々なAWSサービスから設定データを取得可能。ホステッド設定ストアは
  #   AppConfig内で直接設定を管理する最も簡単な方法です。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-configuration-and-profile.html
  location_uri = "hosted"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: 設定プロファイルの説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  description = "Example configuration profile for demonstration"

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
  # 設定タイプ
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: プロファイルに含まれる設定のタイプを指定します。
  # 設定可能な値:
  #   - "AWS.AppConfig.FeatureFlags": フィーチャーフラグ用（機能の有効/無効切り替え）
  #   - "AWS.Freeform" (デフォルト): 自由形式の設定データ用
  # 関連機能: AWS AppConfig 設定タイプ
  #   フィーチャーフラグは新機能の有効/無効を制御するのに最適。
  #   フリーフォーム設定は任意の設定データ配布に使用します。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-configuration-and-profile.html
  type = "AWS.Freeform"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # retrieval_role_arn (Optional)
  # 設定内容: 指定したlocation_uriの設定データにアクセスする権限を持つIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN（20〜2048文字）
  # 注意:
  #   - AppConfigホステッド設定ストア（location_uri = "hosted"）の場合は不要
  #   - CodePipelineの場合は不要
  #   - その他すべてのソース（S3、SSM、Secrets Managerなど）では必須
  # 関連機能: AWS AppConfig IAMアクセス
  #   設定データソースへのアクセスに必要な権限を付与するロール。
  #   S3やSSMパラメータストアなど外部ソースを使用する場合に設定します。
  retrieval_role_arn = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_identifier (Optional)
  # 設定内容: AppConfigホステッド設定ストアで新しい設定データバージョンを暗号化するためのKMSキー識別子を指定します。
  # 設定可能な値:
  #   - KMSキーID
  #   - KMSキーエイリアス
  #   - KMSキーIDまたはエイリアスのARN
  # 注意: ホステッド設定タイプ（location_uri = "hosted"）でのみ使用されます。
  #       他の設定ストア（S3、SSMなど）での暗号化は、それぞれのサービスでKMSキーを指定してください。
  # 関連機能: AWS AppConfig 暗号化
  #   AWS KMSを使用して保存時の設定データを暗号化。
  #   機密性の高い設定データを保護するために使用します。
  kms_key_identifier = null

  #-------------------------------------------------------------
  # バリデーション設定
  #-------------------------------------------------------------

  # validator (Optional)
  # 設定内容: 設定データを検証するためのバリデーターを指定します。
  # 最大2つまで設定可能です。
  # 関連機能: AWS AppConfig 設定バリデーション
  #   デプロイ前に設定データの構文や内容を検証。
  #   JSON SchemaまたはLambda関数を使用した検証が可能です。
  #   - https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-configuration-and-profile.html

  validator {
    # type (Required)
    # 設定内容: バリデーターのタイプを指定します。
    # 設定可能な値:
    #   - "JSON_SCHEMA": JSON Schemaを使用した検証
    #   - "LAMBDA": Lambda関数を使用した検証
    type = "JSON_SCHEMA"

    # content (Optional, Required when type is "LAMBDA")
    # 設定内容: JSON SchemaコンテンツまたはLambda関数のARNを指定します。
    # 設定可能な値:
    #   - type = "JSON_SCHEMA" の場合: JSON Schema文字列
    #   - type = "LAMBDA" の場合: Lambda関数のARN
    # 注意: この属性はsensitiveとしてマークされています
    content = jsonencode({
      "$schema" = "http://json-schema.org/draft-07/schema#"
      type      = "object"
      properties = {
        feature_enabled = {
          type = "boolean"
        }
        max_items = {
          type    = "integer"
          minimum = 1
          maximum = 100
        }
      }
      required = ["feature_enabled"]
    })
  }

  # Lambda バリデーターの例（コメントアウト）
  # validator {
  #   type    = "LAMBDA"
  #   content = aws_lambda_function.config_validator.arn
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50個）
  #   - キー: 1〜128文字
  #   - 値: 最大256文字
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-configuration-profile"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AppConfig設定プロファイルのAmazon Resource Name (ARN)
#
# - configuration_profile_id: 設定プロファイルのID
#
# - id: AppConfig設定プロファイルIDとアプリケーションIDをコロン（:）で
#       連結した値
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
