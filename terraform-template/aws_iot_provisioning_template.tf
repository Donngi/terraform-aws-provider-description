#---------------------------------------------------------------
# AWS IoT Provisioning Template
#---------------------------------------------------------------
#
# AWS IoT Provisioning Templateをプロビジョニングするリソースです。
# IoTデバイスを自動的に登録・設定するためのテンプレートを定義します。
# Fleet Provisioningを使用することで、大量のデバイスを効率的に
# AWSアカウントに登録し、証明書・ポリシーなどを自動的に付与できます。
#
# 主な特徴:
# - Fleet Provisioning templateにより大量デバイスの自動登録が可能
# - プロビジョニング前にLambda関数で検証するpre_provisioning_hookを設定可能
# - テンプレートを有効/無効化することで登録フローを制御できます
# - CLAIMタイプとJIT_PROVISIONINGタイプをサポートします
#
# AWS公式ドキュメント:
#   - Fleet Provisioningの概要: https://docs.aws.amazon.com/iot/latest/developerguide/provision-wo-cert.html
#   - API リファレンス: https://docs.aws.amazon.com/iot/latest/apireference/API_CreateProvisioningTemplate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_provisioning_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_provisioning_template" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: Provisioning Templateの名前を指定します。
  # 設定可能な値: 英数字・アンダースコア・ハイフンを含む文字列（最大36文字）
  # 省略時: 省略不可
  name = "my_iot_provisioning_template"

  # provisioning_role_arn (Required)
  # 設定内容: プロビジョニング時にIoTサービスが引き受けるIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN文字列
  # 省略時: 省略不可
  # 注意: ロールにはAWSIoTThingsRegistrationなどの適切な権限が必要です
  provisioning_role_arn = "arn:aws:iam::123456789012:role/iot-provisioning-role"

  # template_body (Required)
  # 設定内容: デバイスのプロビジョニング内容を定義するJSONテンプレートを指定します。
  # 設定可能な値: AWS IoT Fleet Provisioning形式のJSON文字列
  # 省略時: 省略不可
  # 注意: テンプレートにはParameters・Resources・DeviceConfigurationセクションを含めます
  template_body = jsonencode({
    Parameters = {
      SerialNumber = { Type = "String" }
    }
    Resources = {
      certificate = {
        Properties = {
          CertificateId = { Ref = "AWS::IoT::Certificate::Id" }
          Status        = "Active"
        }
        Type = "AWS::IoT::Certificate"
      }
      policy = {
        Properties = {
          PolicyName = "iot-device-policy"
        }
        Type = "AWS::IoT::Policy"
      }
      thing = {
        OverrideSettings = {
          AttributePayload  = "MERGE"
          ThingGroups       = "DO_NOTHING"
          ThingTypeName     = "REPLACE"
        }
        Properties = {
          AttributePayload = {}
          SerialNumber     = { Ref = "SerialNumber" }
          ThingName        = { Ref = "AWS::IoT::Certificate::CommonName" }
        }
        Type = "AWS::IoT::Thing"
      }
    }
  })

  #-------------------------------------------------------------
  # テンプレート設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: Provisioning Templateの説明を指定します。
  # 設定可能な値: 任意の文字列（テンプレートの目的や用途を説明するテキスト）
  # 省略時: 説明なしで作成されます
  description = "Fleet provisioning template for production IoT devices"

  # enabled (Optional)
  # 設定内容: テンプレートを有効化するかどうかを指定します。
  # 設定可能な値: true（有効） / false（無効）
  # 省略時: false（無効状態で作成されます）
  enabled = true

  # type (Optional)
  # 設定内容: Provisioning Templateの種類を指定します。
  # 設定可能な値:
  #   - "FLEET_PROVISIONING": クレームベースのFleet Provisioningテンプレート（デフォルト）
  #   - "JITP": Just-In-Time Provisioningテンプレート
  # 省略時: "FLEET_PROVISIONING"が使用されます
  type = "FLEET_PROVISIONING"

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
  # プロビジョニング前フック設定
  #-------------------------------------------------------------

  # pre_provisioning_hook (Optional)
  # 設定内容: プロビジョニング前に呼び出すLambda関数を定義するブロックです。
  # 省略時: プロビジョニング前の検証なしでデバイスが登録されます
  # 注意: max 1ブロックまで指定可能です
  pre_provisioning_hook {
    # target_arn (Required)
    # 設定内容: プロビジョニング前に実行するLambda関数のARNを指定します。
    # 設定可能な値: Lambda関数のARN文字列
    # 省略時: 省略不可
    target_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:iot-pre-provisioning-hook"

    # payload_version (Optional)
    # 設定内容: Lambdaに送信されるペイロードのバージョンを指定します。
    # 設定可能な値: "2020-04-01"（現時点でサポートされるバージョン）
    # 省略時: デフォルトのペイロードバージョンが使用されます
    payload_version = "2020-04-01"
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
    Name        = "my-iot-provisioning-template"
    Environment = "production"
    Purpose     = "IoT fleet provisioning"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 作成されたProvisioning TemplateのARN
#
# - default_version_id: テンプレートのデフォルトバージョンID
#
# - id: Provisioning Templateの名前（nameと同一）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
