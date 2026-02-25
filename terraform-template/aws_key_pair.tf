#---------------------------------------------------------------
# AWS EC2 Key Pair
#---------------------------------------------------------------
#
# Amazon EC2インスタンスへのSSHログインアクセスを制御するキーペアを
# プロビジョニングするリソースです。既存のユーザー提供の公開鍵マテリアルを
# AWSに登録し、EC2インスタンスへのアクセスを可能にします。
#
# AWS公式ドキュメント:
#   - EC2キーペアの概要: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_key_pair" "example" {
  #-------------------------------------------------------------
  # 公開鍵設定
  #-------------------------------------------------------------

  # public_key (Required)
  # 設定内容: 登録する公開鍵マテリアルを指定します。
  # 設定可能な値:
  #   - OpenSSH公開鍵フォーマット（~/.ssh/authorized_keys の形式）
  #   - Base64エンコードされたDERフォーマット
  #   - RFC4716で規定されたSSH公開鍵ファイルフォーマット
  # 注意: インポート時はAWSがサポートする任意のフォーマットを使用可能
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 user@example.com"

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # key_name (Optional)
  # 設定内容: キーペアの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: key_name_prefixも省略した場合、Terraformが "terraform-" プレフィックスで一意の名前を生成します。
  # 注意: key_name_prefixと排他的（どちらか一方のみ指定可能）
  key_name = "deployer-key"

  # key_name_prefix (Optional)
  # 設定内容: キーペア名のプレフィックスを指定します。Terraformが後ろにランダムなサフィックスを追加します。
  # 設定可能な値: 文字列
  # 省略時: key_nameも省略した場合、Terraformが "terraform-" プレフィックスで一意の名前を生成します。
  # 注意: key_nameと排他的（どちらか一方のみ指定可能）
  key_name_prefix = null

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
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーのdefault_tags設定ブロックと一致するキーを持つタグは、
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "deployer-key"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: キーペアのAmazon Resource Name (ARN)
# - key_pair_id: キーペアID
# - key_type: キーペアのタイプ（例: rsa, ed25519）
# - fingerprint: RFC 4716のセクション4で規定されたDERエンコード秘密鍵のMD5公開鍵フィンガープリント
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
