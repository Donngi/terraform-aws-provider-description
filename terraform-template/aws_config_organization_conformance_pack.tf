#---------------------------------------
# AWS Config Organization Conformance Pack
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-13
#
# 説明: AWS Config Organization Conformance Packは組織全体でConfig Rulesと修復アクションを一元管理するためのリソースです。
#       複数のAWSアカウントに対して統一的なコンプライアンスポリシーを適用し、組織全体のガバナンスを強化できます。
#       Conformance Packテンプレートを使用してConfig Rulesのセットを定義し、組織内の全アカウントまたは特定のOUに展開します。
#
# ユースケース:
#   - 組織全体でのセキュリティベースラインの適用
#   - コンプライアンス標準（CIS、PCI-DSS等）の一括適用
#   - 複数アカウントにわたる構成管理ポリシーの統一
#   - 監査要件への対応とレポート生成の自動化
#
# 主な機能:
#   - 組織レベルでのConformance Pack展開
#   - S3バケットへの評価結果の配信
#   - 特定アカウントの除外設定
#   - カスタムパラメータによるルールの調整
#   - テンプレートベースの管理（インラインまたはS3）
#
# 関連リソース:
#   - aws_config_conformance_pack: 個別アカウント用のConformance Pack
#   - aws_config_configuration_recorder: Config評価の記録設定
#   - aws_organizations_organization: AWS Organizations組織
#   - aws_s3_bucket: 評価結果の配信先バケット
#
# 参考ドキュメント:
#   - https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html
#   - https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-config.html
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_conformance_pack
#
# NOTE: Organization Conformance Packを使用するには、AWS OrganizationsでAWS Configの信頼されたアクセスを有効化する必要があります。
#       また、組織の管理アカウントまたは委任された管理者アカウントから実行する必要があります。

#---------------------------------------
# Organization Conformance Pack基本設定
#---------------------------------------

resource "aws_config_organization_conformance_pack" "example" {
  # 設定内容: Organization Conformance Packの名前
  # 補足: 組織内で一意である必要があります。最大128文字まで指定可能で、英数字とハイフンが使用できます。
  name = "organization-conformance-pack-example"

  #---------------------------------------
  # テンプレート設定
  #---------------------------------------

  # 設定内容: Conformance Packテンプレートの本文（YAMLまたはJSON形式）
  # 補足: インラインでテンプレートを定義する場合に使用します。最大51,200文字まで指定可能です。
  #       template_s3_uriと同時に指定することはできません。
  template_body = <<-YAML
    Resources:
      S3BucketEncryptionEnabled:
        Type: AWS::Config::ConfigRule
        Properties:
          ConfigRuleName: s3-bucket-encryption-enabled
          Source:
            Owner: AWS
            SourceIdentifier: S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED
  YAML

  # 設定内容: S3に保存されたConformance Packテンプレートのパス
  # 補足: S3バケットに配置したテンプレートファイルを参照する場合に使用します。
  #       形式は s3://bucket-name/key-name で、template_bodyと同時に指定することはできません。
  template_s3_uri = "s3://example-bucket/conformance-pack-template.yaml"

  #---------------------------------------
  # 配信設定
  #---------------------------------------

  # 設定内容: Conformance Pack評価結果の配信先S3バケット名
  # 補足: 組織内の全アカウントからの評価結果がこのバケットに配信されます。
  #       バケットポリシーでAWS Configからの書き込みを許可する必要があります。
  delivery_s3_bucket = "organization-config-conformance-pack-delivery"

  # 設定内容: S3バケット内の配信先プレフィックス
  # 補足: 評価結果を保存するS3キーのプレフィックスを指定します。
  #       複数のConformance Packを使用する場合の整理に便利です。
  delivery_s3_key_prefix = "conformance-packs/"

  #---------------------------------------
  # アカウント除外設定
  #---------------------------------------

  # 設定内容: Conformance Pack適用から除外するAWSアカウントIDのリスト
  # 補足: 組織内の特定アカウントをConformance Pack適用対象から除外できます。
  #       最大1,000個のアカウントIDを指定可能です。
  excluded_accounts = [
    "123456789012",
    "234567890123"
  ]

  #---------------------------------------
  # パラメータ設定
  #---------------------------------------

  # 設定内容: Conformance Packテンプレートに渡すカスタムパラメータ
  # 補足: テンプレート内で定義されたパラメータに値を設定します。最大60個まで指定可能です。
  #       パラメータを使用することでルールの動作を柔軟にカスタマイズできます。
  input_parameter {
    parameter_name  = "AccessKeysRotatedParameterMaxAccessKeyAge"
    parameter_value = "90"
  }

  input_parameter {
    parameter_name  = "S3BucketLoggingEnabledParameterTargetBucket"
    parameter_value = "centralized-logging-bucket"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 補足: Organization Conformance Packを作成するリージョンを指定します。
  #       省略時はプロバイダーに設定されたリージョンが使用されます。
  region = "us-east-1"

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # 設定内容: リソース操作のタイムアウト時間
  # 補足: Organization Conformance Packの作成、更新、削除にかかる最大待機時間を設定します。
  timeouts {
    create = "10m"
    update = "10m"
    delete = "20m"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照可能な主要属性:
#
# - id: Organization Conformance PackのID（名前と同じ値）
# - arn: Organization Conformance PackのARN
#       形式: arn:aws:config:region:account-id:organization-conformance-pack/name
#       他のリソースでの参照やIAMポリシーでの権限設定に使用
#
# 参照方法:
#   aws_config_organization_conformance_pack.example.id
#   aws_config_organization_conformance_pack.example.arn
