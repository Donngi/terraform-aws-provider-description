#---------------------------------------------------------------
# AWS EC2 Key Pair
#---------------------------------------------------------------
#
# Amazon EC2のキーペアをプロビジョニングするリソースです。
# キーペアは、EC2インスタンスへのSSHログインアクセスを制御するために使用されます。
# 公開鍵と秘密鍵のペアで構成され、公開鍵がAWSに登録され、
# 対応する秘密鍵を使用してインスタンスに安全に接続できます。
#
# AWS公式ドキュメント:
#   - Amazon EC2 キーペアとインスタンス: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
#   - キーペアの作成: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_key_pair" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # key_name (Optional, Forces new resource)
  # 設定内容: キーペアの名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: key_name_prefixも未指定の場合、Terraformが "terraform-" プレフィックスで
  #         一意の名前を自動生成します。
  # 注意: key_name_prefixと排他的（どちらか一方のみ指定可能）
  key_name = "my-key-pair"

  # key_name_prefix (Optional, Forces new resource)
  # 設定内容: キーペア名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加して一意の名前を生成します。
  # 省略時: key_nameも未指定の場合、"terraform-" がプレフィックスとして使用されます。
  # 注意: key_nameと排他的（どちらか一方のみ指定可能）
  key_name_prefix = null

  #-------------------------------------------------------------
  # 公開鍵設定
  #-------------------------------------------------------------

  # public_key (Required)
  # 設定内容: EC2に登録する公開鍵の素材を指定します。
  # 設定可能な値: 以下のいずれかの形式の公開鍵文字列
  #   - OpenSSH公開鍵形式（~/.ssh/authorized_keysの形式）
  #   - Base64エンコードされたDER形式
  #   - RFC4716で規定されたSSH公開鍵ファイル形式
  # 関連機能: EC2 キーペア
  #   既存のユーザー提供のキーペアの公開鍵をAWSに登録し、
  #   EC2インスタンスへのログインを許可します。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
  # 注意: 秘密鍵はAWSに保存されないため、紛失した場合に復元する方法はありません。
  #       安全な場所に保管してください。
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQ... email@example.com"

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
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-key-pair"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: キーペアのAmazon Resource Name (ARN)
#
# - fingerprint: RFC 4716のセクション4で規定されたMD5公開鍵フィンガープリント
#
# - id: キーペアの名前
#
# - key_pair_id: キーペアのID
#
# - key_type: キーペアの種類
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
