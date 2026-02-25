#---------------------------------------------------------------
# AWS Lightsail Static IP
#---------------------------------------------------------------
#
# Amazon Lightsail の静的IPアドレスをプロビジョニングするリソースです。
# 静的IPアドレスは固定されたパブリックIPアドレスであり、Lightsailインスタンスに
# アタッチすることで、インスタンスの停止・再起動後もIPアドレスが変わらなくなります。
# ドメイン名との関連付けを行う場合に特に有用です。
#
# AWS公式ドキュメント:
#   - Lightsail静的IPアドレスの概要: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-static-ip-addresses-in-amazon-lightsail.html
#   - 静的IPアドレスの作成とアタッチ: https://docs.aws.amazon.com/lightsail/latest/userguide/lightsail-create-static-ip.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_static_ip
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_static_ip" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: 割り当てる静的IPアドレスの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む一意の文字列
  # 注意: 同一リージョン内で一意の名前である必要があります。
  name = "example"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Lightsailは利用可能なリージョンが限定されています。
  # 参考: https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Lightsail静的IPアドレスのAmazon Resource Name (ARN)
#
# - ip_address: 割り当てられた静的IPアドレス
#
# - support_code: 静的IPのサポートコード。Lightsailに関する問い合わせ時に
#                 サポートチームへ提供することでLightsail情報を素早く特定できます。
#---------------------------------------------------------------
