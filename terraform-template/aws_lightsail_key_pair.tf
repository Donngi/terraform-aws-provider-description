#---------------------------------------------------------------
# AWS Lightsail Key Pair
#---------------------------------------------------------------
#
# Amazon Lightsail のキーペアをプロビジョニングするリソースです。
# Lightsail インスタンスへの SSH アクセスに使用するキーペアを作成または
# インポートします。Lightsail のキーペアは EC2 のキーペアとは別に管理されます。
#
# 注意: Lightsail はサポートされている AWS リージョンが限られています。
#       利用可能なリージョンについては AWS 公式ドキュメントを参照してください。
#
# AWS公式ドキュメント:
#   - Amazon Lightsail キーペア: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-ssh-in-amazon-lightsail.html
#   - Lightsail のリージョンと可用性ゾーン: https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_key_pair
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_key_pair" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: Lightsail キーペアの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: Terraform がランダムな一意の名前を生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  name = "example"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: キーペア名のプレフィックスを指定します。Terraform が後ろに一意のサフィックスを追加します。
  # 設定可能な値: 任意の文字列
  # 省略時: name が使用されます。
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #-------------------------------------------------------------
  # キーマテリアル設定
  #-------------------------------------------------------------

  # public_key (Optional, Forces new resource)
  # 設定内容: インポートする既存の公開鍵マテリアルを指定します。
  # 設定可能な値: RSA 公開鍵文字列（PEM 形式）
  # 省略時: Terraform が新しいキーペアを生成します。
  # 注意: 指定した場合、pgp_key は無視されます。
  public_key = null

  # pgp_key (Optional)
  # 設定内容: 生成された秘密鍵マテリアルの暗号化に使用する PGP キーを指定します。
  # 設定可能な値:
  #   - "keybase:{ユーザー名}": Keybase.io のユーザー名を使用して公開鍵を取得
  #   - base64 エンコードされた PGP 公開鍵文字列
  # 省略時: 秘密鍵はプレーンテキストのまま Terraform の state に保存されます。
  # 注意: 新しいキーペアを作成する場合のみ有効。public_key を指定した場合は無視されます。
  #       セキュリティのため、pgp_key の指定を強く推奨します。
  pgp_key = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: Lightsail がサポートする有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。キーのみのタグを作成するには値に空文字列を使用します。
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Lightsail キーペアの ARN
#
# - fingerprint: RFC 4716 第 4 節で規定された MD5 公開鍵フィンガープリント
#
# - private_key: base64 エンコードされた秘密鍵。新しいキーを作成し、pgp_key を
#                指定しない場合のみ設定されます。
#
# - encrypted_fingerprint: 暗号化された秘密鍵の MD5 公開鍵フィンガープリント
#
# - encrypted_private_key: base64 エンコードおよび pgp_key で暗号化された秘密鍵
#                          マテリアル。新しいキーを作成し、pgp_key を指定した場合
#                          のみ設定されます。
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
