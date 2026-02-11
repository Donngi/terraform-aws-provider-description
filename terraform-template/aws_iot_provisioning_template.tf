#---------------------------------------------------------------
# AWS IoT Fleet Provisioning Template
#---------------------------------------------------------------
#
# AWS IoT Fleet Provisioningテンプレートを管理するリソースです。
# Fleet Provisioningにより、デバイスが初回接続時に自動的に証明書とポリシーを
# プロビジョニングし、AWS IoT Coreに登録することができます。
#
# AWS公式ドキュメント:
#   - Fleet provisioning: https://docs.aws.amazon.com/iot/latest/developerguide/provision-wo-cert.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_provisioning_template
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_provisioning_template" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # テンプレート名
  # Fleet Provisioningテンプレートの一意な名前を指定します。
  # この名前はテンプレートの識別に使用されます。
  name = "FleetTemplate"

  # プロビジョニングロールARN
  # デバイスをプロビジョニングする権限を持つIAMロールのARNを指定します。
  # このロールには、証明書の作成、IoTポリシーのアタッチ、Thing の作成などの
  # 権限が必要です。通常は AWSIoTThingsRegistration マネージドポリシーを
  # アタッチしたロールを使用します。
  provisioning_role_arn = "arn:aws:iam::123456789012:role/IoTProvisioningServiceRole"

  # テンプレート本体
  # Fleet ProvisioningテンプレートのJSON形式の内容を指定します。
  # テンプレートには、Parameters（デバイスから受け取るパラメータ）と
  # Resources（作成するIoTリソース）を定義します。
  #
  # 例: デバイスのシリアル番号をパラメータとして受け取り、
  #     証明書とポリシーを作成するテンプレート
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
          PolicyName = "DevicePolicy"
        }
        Type = "AWS::IoT::Policy"
      }
    }
  })

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # 説明
  # Fleet Provisioningテンプレートの説明を指定します。
  # テンプレートの目的や用途を記述すると管理しやすくなります。
  description = "My fleet provisioning template"

  # 有効化フラグ
  # テンプレートを有効にするかどうかを指定します。
  # true: テンプレートが有効で、デバイスがプロビジョニングに使用できる
  # false: テンプレートが無効で、プロビジョニングに使用できない
  # デフォルト: false
  enabled = true

  # リージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 指定しない場合はプロバイダー設定のリージョンが使用されます。
  # 通常は明示的に指定する必要はありません。
  # region = "us-east-1"

  # タグ
  # リソースに割り当てるタグのマップを指定します。
  # タグを使用してリソースを分類・管理できます。
  # プロバイダーの default_tags 設定がある場合、
  # そこで定義されたタグとマージされます。
  tags = {
    Environment = "production"
    Project     = "IoT-Fleet"
  }

  # タイプ
  # プロビジョニングテンプレートのタイプを指定します。
  # 指定可能な値:
  #   - FLEET_PROVISIONING (デフォルト)
  #   - JITP (Just-In-Time Provisioning)
  # 通常は指定不要で、デフォルト値が使用されます。
  # type = "FLEET_PROVISIONING"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # プレプロビジョニングフック
  # デバイスがプロビジョニングされる前に実行されるLambda関数を定義します。
  # フックを使用して、デバイスの検証やカスタムロジックの実行、
  # プロビジョニングの承認/拒否が可能です。
  pre_provisioning_hook {
    # ターゲットARN (必須)
    # プレプロビジョニングフックとして実行されるLambda関数のARNを指定します。
    # この関数は、デバイスからのプロビジョニングリクエストを検証し、
    # 承認または拒否を返すことができます。
    target_arn = "arn:aws:lambda:us-east-1:123456789012:function:PreProvisioningHook"

    # ペイロードバージョン (任意)
    # ターゲット関数に送信されるペイロードのバージョンを指定します。
    # 有効な値は "2020-04-01" のみで、これがデフォルト値です。
    # 通常は明示的に指定する必要はありません。
    # payload_version = "2020-04-01"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn: プロビジョニングテンプレートを識別するARN
#   例: arn:aws:iot:us-east-1:123456789012:provisioningtemplate/FleetTemplate
#
# - default_version_id: Fleet Provisioningテンプレートのデフォルトバージョンの数値ID
#   テンプレートを更新するたびに新しいバージョンが作成されます。
#
# - id: リソースの識別子（テンプレート名と同じ値）
#
# - tags_all: リソースに割り当てられた全タグのマップ
#   プロバイダーの default_tags で定義されたタグを含みます。
#
# これらの属性は出力として参照できます:
# output "template_arn" {
#   value = aws_iot_provisioning_template.example.arn
# }
#---------------------------------------------------------------
