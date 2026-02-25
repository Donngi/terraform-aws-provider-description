#---------------------------------------------------------------
# Amazon Inspector Classic Resource Group
#---------------------------------------------------------------
#
# Amazon Inspector Classic のリソースグループをプロビジョニングするリソースです。
# リソースグループはタグを使用してEC2インスタンスを選択するグループで、
# Inspector Classic の評価ターゲット（assessment target）に紐付けて使用します。
#
# 注意: Amazon Inspector Classic は2026年5月20日にサポート終了予定です。
#       新規アカウントおよび6ヶ月以内に評価を実施していないアカウントは
#       利用できません。
#
# AWS公式ドキュメント:
#   - Amazon Inspector Classic リソースグループ: https://docs.aws.amazon.com/inspector/v1/APIReference/API_CreateResourceGroup.html
#   - Amazon Inspector Classic ARN形式: https://docs.aws.amazon.com/inspector/v1/userguide/inspector-arns-resources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_resource_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector_resource_group" "example" {
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
  # タグ設定（評価対象EC2インスタンスの選択条件）
  #-------------------------------------------------------------

  # tags (Required)
  # 設定内容: リソースグループを構成するEC2インスタンスを選択するためのタグのマップを指定します。
  #           このタグと一致するEC2インスタンスが、評価ターゲット（assessment target）の対象となります。
  # 設定可能な値: キーと値のペアのマップ。タグは1〜10個まで指定可能。
  # 参考: https://docs.aws.amazon.com/inspector/v1/APIReference/API_CreateResourceGroup.html
  tags = {
    Name = "example"
    Env  = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リソースグループのAmazon Resource Name (ARN)
#        形式: arn:aws:inspector:{region}:{account-id}:resourcegroup/{ID}
#---------------------------------------------------------------
