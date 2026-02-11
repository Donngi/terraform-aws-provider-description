#---------------------------------------------------------------
# AWS App Runner Custom Domain Association
#---------------------------------------------------------------
#
# AWS App Runnerサービスにカスタムドメイン名を関連付けるリソースです。
# 独自のドメイン名をApp Runnerサービスのサブドメインにマッピングすることで、
# ユーザーはカスタムドメインを使用してアプリケーションにアクセスできます。
#
# 注意: リソース作成後、certificate_validation_recordsの情報を使用して
# DNSにCNAMEレコードを追加する必要があります。各マッピングされたドメインに対して、
# App Runnerサブドメイン（dns_target）へのマッピングと1つ以上の証明書検証レコードを追加します。
# App RunnerはDNS検証を実行し、ドメイン名の所有権または制御を確認します。
#
# AWS公式ドキュメント:
#   - App Runner カスタムドメインの管理: https://docs.aws.amazon.com/apprunner/latest/dg/manage-custom-domains.html
#   - AssociateCustomDomain API: https://docs.aws.amazon.com/apprunner/latest/api/API_AssociateCustomDomain.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_custom_domain_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_custom_domain_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # service_arn (Required)
  # 設定内容: カスタムドメイン名を関連付けるApp RunnerサービスのARNを指定します。
  # 設定可能な値: 有効なApp RunnerサービスのAmazon Resource Name (ARN)
  # 形式: arn:aws:apprunner:<region>:<account-id>:service/<service-name>/<service-id>
  service_arn = aws_apprunner_service.example.arn

  # domain_name (Required, Forces new resource)
  # 設定内容: 関連付けるカスタムドメインエンドポイントを指定します。
  # 設定可能な値:
  #   - ルートドメイン: example.com
  #   - サブドメイン: subdomain.example.com, admin.login.example.com
  #   - ワイルドカード: *.example.com
  # 制約: 1-255文字、パターン: [A-Za-z0-9*.-]{1,255}
  # 注意: 最大5つのカスタムドメインをサービスに関連付け可能
  domain_name = "example.com"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # enable_www_subdomain (Optional)
  # 設定内容: wwwサブドメイン（www.<domain_name>）もApp Runnerサービスに
  #          関連付けるかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): wwwサブドメインを関連付ける
  #     例: domain_nameが"example.com"の場合、"www.example.com"も関連付けられる
  #   - false: wwwサブドメインを関連付けない
  # 用途: ルートドメインとwwwサブドメインの両方で同じサービスにアクセスさせたい場合に有効
  enable_www_subdomain = true

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
# - id: domain_nameとservice_arnをカンマ（,）で連結した値
#
# - dns_target: App RunnerサービスのApp Runnerサブドメイン。
#               カスタムドメイン名がこのターゲット名にマッピングされます。
#               注意: リソースをTerraformで作成した場合のみ利用可能（インポート時は不可）
#
# - status: ドメイン名の関連付けの現在の状態
#           値: creating, pending_certificate_dns_validation, active, など
#
# - certificate_validation_records: ドメイン名に使用される証明書CNAMEレコードのセット
#   各レコードには以下が含まれます:
#   - name: 証明書CNAMEレコード名
#   - type: レコードタイプ（常に"CNAME"）
#   - value: 証明書CNAMEレコード値
#   - status: 証明書CNAMEレコード検証の現在の状態
#             App Runnerが検証完了後、"SUCCESS"に変わります
#
