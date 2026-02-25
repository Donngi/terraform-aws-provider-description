#---------------------------------------------------------------
# AWS Lightsail Static IP Attachment
#---------------------------------------------------------------
#
# Amazon LightsailのスタティックIPアドレスをLightsailインスタンスに
# アタッチします。スタティックIPを使用することで、インスタンスの再起動や
# 停止・起動をまたいで変わらない固定のパブリックIPアドレスを提供できます。
# スタティックIPは1つのインスタンスにのみアタッチ可能です。
#
# AWS公式ドキュメント:
#   - Lightsailスタティック IP概要: https://docs.aws.amazon.com/lightsail/latest/userguide/lightsail-create-static-ip.html
#   - AttachStaticIp APIリファレンス: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_AttachStaticIp.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_static_ip_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_static_ip_attachment" "example" {
  #-------------------------------------------------------------
  # スタティックIP設定
  #-------------------------------------------------------------

  # static_ip_name (Required, Forces new resource)
  # 設定内容: アタッチするLightsailスタティックIPの名前を指定します。
  # 設定可能な値: 既存のLightsailスタティックIPの名前（文字列）
  # 注意: aws_lightsail_static_ip リソースで事前に作成する必要があります。
  #       1つのスタティックIPは同時に1つのインスタンスにのみアタッチ可能です。
  static_ip_name = "example-static-ip"

  #-------------------------------------------------------------
  # インスタンス設定
  #-------------------------------------------------------------

  # instance_name (Required, Forces new resource)
  # 設定内容: スタティックIPをアタッチするLightsailインスタンスの名前を指定します。
  # 設定可能な値: 既存のLightsailインスタンスの名前（文字列）
  # 注意: インスタンスとスタティックIPは同じAWSリージョンに存在する必要があります。
  #       インスタンスに既存のパブリックIPがある場合は置き換えられます。
  instance_name = "example-instance"

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
# - id: スタティックIP名（static_ip_nameと同じ値）
# - ip_address: アタッチされたスタティックIPアドレス（例: 192.0.2.0）
#---------------------------------------------------------------
