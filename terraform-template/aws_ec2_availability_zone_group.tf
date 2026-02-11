#---------------------------------------------------------------
# EC2 Availability Zone Group
#---------------------------------------------------------------
#
# EC2 Availability Zone Group（アベイラビリティゾーングループ）の
# オプトインステータスを管理するリソースです。
# Local ZoneやWavelength Zoneなどの特別なゾーングループを
# アカウントで有効化・無効化する際に使用します。
#
# NOTE: これは高度なTerraformリソースです。Terraformは自動的に
#       EC2 Availability Zone Groupの管理を引き受け、
#       設定から削除してもアクションは実行されません。
#
# AWS公式ドキュメント:
#   - ModifyAvailabilityZoneGroup: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyAvailabilityZoneGroup.html
#   - DescribeAvailabilityZones: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeAvailabilityZones.html
#   - Available Local Zones: https://docs.aws.amazon.com/local-zones/latest/ug/available-local-zones.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_availability_zone_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_availability_zone_group" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # group_name (Required)
  # 設定内容: Availability Zone グループの名前を指定します。
  # 設定可能な値:
  #   - Availability Zone group、Local Zone group、または Wavelength Zone group の名前
  #   - 例: us-west-2-lax-1 (Los Angeles Local Zone)
  #   - 例: us-east-1-wl1 (Wavelength Zone)
  #   - 例: ap-northeast-1-tpe-1 (台北 Local Zone)
  # 関連機能: AWS Local Zones / Wavelength Zones
  #   Local ZoneやWavelength Zoneは、AWSのコンピューティング、ストレージ、データベースなどの
  #   サービスをエンドユーザーの近くに配置するための特別なゾーンです。
  #   利用可能なグループ名はDescribeAvailabilityZones APIで確認できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeAvailabilityZones.html
  group_name = "us-west-2-lax-1"

  # opt_in_status (Required)
  # 設定内容: ゾーングループのオプトインステータスを指定します。
  # 設定可能な値:
  #   - "opted-in": ゾーングループを有効化（オプトイン）
  #   - "not-opted-in": ゾーングループを無効化（オプトアウト）
  # 関連機能: Availability Zone Group オプトイン管理
  #   Local ZoneやWavelength Zoneを利用するには、まずゾーングループにオプトインする必要があります。
  #   オプトインすることで、そのゾーン内でEC2インスタンスなどのリソースを起動できるようになります。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyAvailabilityZoneGroup.html
  # 注意: Local ZoneやWavelength Zoneグループからオプトアウトするには、AWS Supportへの連絡が必要です。
  #       Terraformでの変更のみではオプトアウトできない場合があります。
  opt_in_status = "opted-in"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトとして使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: 通常は明示的な指定は不要です。マルチリージョン構成で特定のリージョンを
  #       指定したい場合にのみ使用してください。
  # region = "us-west-2"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Availability Zone Groupの名前（group_nameと同じ値）
#---------------------------------------------------------------
