#---------------------------------------
# AWS EC2 アベイラビリティゾーングループ
#---------------------------------------
# AWS EC2におけるアベイラビリティゾーングループのオプトイン状態を管理します。
# Local Zone、Wavelength Zoneなどの特定のゾーングループを有効化または無効化できます。
#
# 主な用途:
# - Local Zoneの有効化によるエンドユーザーに近いリソース配置
# - Wavelength Zoneの有効化による5Gネットワークエッジでの低レイテンシアプリケーション展開
# - 特定ゾーングループへのアクセス制御
#
# 前提条件:
# - ゾーングループを有効化する前に、親リージョンが有効化されている必要があります
# - 無効化する場合は、事前にゾーン内のすべてのリソースを削除する必要があります
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_availability_zone_group
#
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマに基づいて生成されています。
#       実際の使用時には、最新のプロバイダーバージョンとの互換性を確認してください。
#
# 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html

resource "aws_ec2_availability_zone_group" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: ゾーングループの名前
  # 設定可能な値: us-west-2-lax-1, ap-northeast-1-wl1-nrt-wlzなどのゾーングループ名
  # 補足事項:
  #   - Local Zoneの場合: {region}-{city}-{number} (例: us-west-2-lax-1)
  #   - Wavelength Zoneの場合: {region}-wl1-{city}-wlz (例: ap-northeast-1-wl1-nrt-wlz)
  #   - DescribeAvailabilityZones APIで利用可能なゾーングループを確認できます
  group_name = "us-west-2-lax-1"

  # 設定内容: ゾーングループのオプトイン状態
  # 設定可能な値:
  #   - opted-in: ゾーングループを有効化
  #   - not-opted-in: ゾーングループを無効化
  # 補足事項:
  #   - opted-inに変更すると、該当ゾーンでリソースを作成できるようになります
  #   - not-opted-inに変更する前に、ゾーン内のすべてのリソースを削除する必要があります
  #   - 変更には数分かかる場合があります
  opt_in_status = "opted-in"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1などのリージョンコード
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 補足事項: 通常は省略してプロバイダー設定を使用することを推奨します
  region = "us-west-2"
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# - id: ゾーングループ名（group_nameと同じ値）
# - group_name: ゾーングループの名前
# - opt_in_status: ゾーングループの現在のオプトイン状態
# - region: リソースが管理されているAWSリージョン
