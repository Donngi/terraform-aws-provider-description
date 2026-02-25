#---------------------------------------------------------------
# AWS License Manager Grant Accepter
#---------------------------------------------------------------
#
# AWS License Managerのグラント承認をプロビジョニングするリソースです。
# 他のAWSアカウントから共有されたライセンスグラントを承認することで、
# グラントされたライセンスを使用可能な状態にします。
# グラントの承認者はグラントのARNを指定してアクティブ化します。
#
# AWS公式ドキュメント:
#   - License Managerのグラント承認: https://docs.aws.amazon.com/license-manager/latest/userguide/granted-licenses.html
#   - AcceptGrant API: https://docs.aws.amazon.com/license-manager/latest/APIReference/API_AcceptGrant.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/licensemanager_grant_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_licensemanager_grant_accepter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # grant_arn (Required)
  # 設定内容: 承認するグラントのARNを指定します。
  #           グラントの共有者が作成したaws_licensemanager_grantリソースのARNを指定します。
  # 設定可能な値: 有効なLicense Managerグラント ARN
  # 参考: https://docs.aws.amazon.com/license-manager/latest/APIReference/API_AcceptGrant.html
  grant_arn = "arn:aws:license-manager::111111111111:grant:g-exampleARN"

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
# - id: グラントのARN
# - allowed_operations: グラントで許可されている操作のセット
# - home_region: グラントのホームリージョン
# - license_arn: グラントに関連付けられたライセンスのARN
# - name: グラントの名前
# - parent_arn: 親グラントのARN
# - principal: グラント付与先のプリンシパルARN
# - status: グラント承認のステータス
# - version: グラント承認のバージョン番号
#---------------------------------------------------------------
