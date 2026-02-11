#---------------------------------------------------------------
# AWS AMI Launch Permission
#---------------------------------------------------------------
#
# Amazon Machine Image (AMI) の起動権限を管理するリソースです。
# 特定のAWSアカウント、AWS Organizations、または組織単位（OU）に対して
# AMIの起動権限を付与できます。また、AMIを一般公開することも可能です。
#
# AWS公式ドキュメント:
#   - AMIを特定のAWSアカウントと共有: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-explicit.html
#   - AMIを組織またはOUと共有: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/share-amis-org-ou-manage.html
#   - AMIの公開: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-intro.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_launch_permission
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ami_launch_permission" "example" {
  #-------------------------------------------------------------
  # AMI設定（必須）
  #-------------------------------------------------------------

  # image_id (Required)
  # 設定内容: 起動権限を付与するAMIのIDを指定します。
  # 設定可能な値: 有効なAMI ID（例: ami-12345678, ami-0abcdef1234567890）
  # 注意: 起動権限を付与するには、このAMIを所有している必要があります。
  image_id = "ami-0abcdef1234567890"

  #-------------------------------------------------------------
  # 共有先設定（以下のいずれか1つを指定）
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: AMIの起動権限を付与するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（例: 123456789012）
  # 関連機能: AMIの明示的共有
  #   特定のAWSアカウントにのみAMIを共有する方法。
  #   共有されたアカウントはインスタンスの起動のみが可能で、
  #   AMIの削除、共有、変更はできません。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-explicit.html
  # 注意: group, organization_arn, organizational_unit_arn と排他的
  account_id = "123456789012"

  # group (Optional)
  # 設定内容: AMIの起動権限を付与するグループを指定します。
  # 設定可能な値:
  #   - "all": AMIを一般公開し、すべてのAWSアカウントが起動可能にします
  # 関連機能: AMIの公開
  #   AMIを一般公開すると、すべてのAWSアカウントがそのAMIを使用して
  #   インスタンスを起動できるようになります。公開AMIは2年後に自動的に
  #   非推奨となり、6ヶ月間インスタンスが起動されない場合は削除される可能性があります。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-intro.html
  # 注意: account_id, organization_arn, organizational_unit_arn と排他的
  #       暗号化されたボリュームを含むAMIは公開できません。
  group = null

  # organization_arn (Optional)
  # 設定内容: AMIの起動権限を付与するAWS Organizations組織のARNを指定します。
  # 設定可能な値: 有効な組織ARN（例: arn:aws:organizations::123456789012:organization/o-example）
  # 関連機能: 組織単位でのAMI共有
  #   組織全体にAMIを共有することで、組織内のすべてのアカウントが
  #   AMIを使用してインスタンスを起動できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/share-amis-org-ou-manage.html
  # 注意: account_id, group, organizational_unit_arn と排他的
  organization_arn = null

  # organizational_unit_arn (Optional)
  # 設定内容: AMIの起動権限を付与するAWS Organizations組織単位（OU）のARNを指定します。
  # 設定可能な値: 有効なOU ARN（例: arn:aws:organizations::123456789012:ou/o-example/ou-example）
  # 関連機能: 組織単位（OU）でのAMI共有
  #   特定のOUにAMIを共有することで、そのOU内のアカウントのみが
  #   AMIを使用してインスタンスを起動できます。組織全体への共有よりも
  #   きめ細かなアクセス制御が可能です。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/share-amis-org-ou-manage.html
  # 注意: account_id, group, organization_arn と排他的
  organizational_unit_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: AMIはリージョナルリソースです。異なるリージョンでAMIを共有する場合は、
  #       まずAMIをそのリージョンにコピーしてから共有する必要があります。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 起動権限のID
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 例1: 特定のAWSアカウントにAMIを共有
#
# resource "aws_ami_launch_permission" "account" {
#   image_id   = "ami-12345678"
#   account_id = "123456789012"
# }
#
# 例2: AMIを一般公開
#
# resource "aws_ami_launch_permission" "public" {
#   image_id = "ami-12345678"
#   group    = "all"
# }
#
#---------------------------------------------------------------
