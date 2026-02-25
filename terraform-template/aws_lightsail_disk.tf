#---------------------------------------------------------------
# Amazon Lightsail Disk
#---------------------------------------------------------------
#
# Amazon LightsailのブロックストレージディスクをプロビジョニングするTerraformリソースです。
# Lightsailインスタンスに追加のブロックストレージを提供し、インスタンスのストレージ容量を
# 拡張するために使用します。ディスクはSSDアーキテクチャで提供され、安定した低レイテンシの
# パフォーマンスを実現します。1ディスクあたり最大16TBまで設定可能で、1インスタンスに
# 最大15個のディスクをアタッチできます。ディスクはAZ内で自動的にレプリケートされ、
# 保存中および転送中のデータが暗号化されます。
#
# AWS公式ドキュメント:
#   - Amazon Lightsail ブロックストレージの概要: https://docs.aws.amazon.com/lightsail/latest/userguide/elastic-block-storage-and-ssd-disks-in-amazon-lightsail.html
#   - ブロックストレージのFAQ: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-block-storage.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_disk
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_disk" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ディスクの名前を指定します。
  # 設定可能な値: アルファベット文字で始まり、英数字・アンダースコア・ハイフン・ドットのみ使用可能な文字列
  name = "example-disk"

  # size_in_gb (Required, Forces new resource)
  # 設定内容: ディスクのサイズをGBで指定します。
  # 設定可能な値: 8以上の整数（最大16384 GB / 16 TB）
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/elastic-block-storage-and-ssd-disks-in-amazon-lightsail.html
  size_in_gb = 8

  #-------------------------------------------------------------
  # アベイラビリティゾーン設定
  #-------------------------------------------------------------

  # availability_zone (Required, Forces new resource)
  # 設定内容: ディスクを作成するアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なAWSアベイラビリティゾーン（例: ap-northeast-1a, us-east-1a）
  # 注意: ディスクはアタッチ先インスタンスと同じアベイラビリティゾーンに存在する必要があります。
  #       ディスクは一度に1つのインスタンスにのみアタッチできます。
  availability_zone = "ap-northeast-1a"

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。キーのみのタグを作成するには空文字列を値として使用
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-disk"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ディスクのAmazon Resource Name (ARN)
#
# - created_at: ディスクが作成された日時
#
# - id: ディスクの名前（nameと同じ値）
#
# - support_code: ディスクのサポートコード。Lightsailのディスクに関する
#                問い合わせ時にサポートへのメールに含めるコード
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
