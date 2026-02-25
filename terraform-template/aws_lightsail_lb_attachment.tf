#---------------------------------------------------------------
# AWS Lightsail Load Balancer Attachment
#---------------------------------------------------------------
#
# Lightsail ロードバランサーに Lightsail インスタンスをアタッチする
# リソースです。複数のインスタンスにトラフィックを分散させることで
# 可用性とスケーラビリティを向上させます。
#
# 主なユースケース:
#   - Lightsail ロードバランサーへのインスタンス登録
#   - 複数インスタンスへのトラフィック分散構成
#   - Lightsail 環境における高可用性構成の実現
#
# 重要な注意事項:
#   - aws_lightsail_lb リソースと組み合わせて使用します
#   - aws_lightsail_instance リソースで作成したインスタンスを指定します
#   - 同一ロードバランサーへの複数インスタンス登録は、このリソースを複数定義します
#
# AWS公式ドキュメント:
#   - https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-load-balancing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_lb_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_lb_attachment" "example" {
  #---------------------------------------------------------------
  # ロードバランサー・インスタンス設定（必須）
  #---------------------------------------------------------------

  # lb_name (Required)
  # 設定内容: アタッチ先の Lightsail ロードバランサー名を指定します。
  # 設定可能な値: Lightsail ロードバランサーの名前文字列
  # 参考: aws_lightsail_lb リソースの name 属性を参照
  lb_name = aws_lightsail_lb.example.name

  # instance_name (Required)
  # 設定内容: ロードバランサーにアタッチする Lightsail インスタンス名を指定します。
  # 設定可能な値: Lightsail インスタンスの名前文字列
  # 参考: aws_lightsail_instance リソースの name 属性を参照
  instance_name = aws_lightsail_instance.example.name

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用されます
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#     ロードバランサー名とインスタンス名を組み合わせた一意の識別子
#     形式: lb_name,instance_name
#
