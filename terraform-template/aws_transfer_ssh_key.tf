#---------------------------------------------------------------
# AWS Transfer Family SSH Key
#---------------------------------------------------------------
#
# AWS Transfer FamilyサーバーのユーザーにSSH公開鍵を関連付けるリソースです。
# SFTP認証において、ユーザーがSSH秘密鍵を使用してサーバーに
# 接続するための公開鍵を登録します。
#
# AWS公式ドキュメント:
#   - Transfer FamilyユーザーへのSSHキー追加: https://docs.aws.amazon.com/transfer/latest/userguide/key-management.html
#   - Transfer Familyの概要: https://docs.aws.amazon.com/transfer/latest/userguide/what-is-aws-transfer-family.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_ssh_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # server_id (Required)
  # 設定内容: SSH公開鍵を関連付けるTransfer FamilyサーバーのIDを指定します。
  # 設定可能な値: Transfer ServerのID（例: s-12345678abcdefgh）
  # 関連機能: AWS Transfer Family サーバー
  #   SSH公開鍵は特定のTransfer Familyサーバー上のユーザーに紐付けられます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/create-server.html
  server_id = "s-12345678abcdefgh"

  # user_name (Required)
  # 設定内容: SSH公開鍵を追加するTransfer Familyユーザーの名前を指定します。
  # 設定可能な値: 既存のTransfer Familyユーザー名（3-100文字の英数字、ハイフン、アンダースコア）
  # 関連機能: AWS Transfer Family ユーザー
  #   ユーザーは事前にaws_transfer_userリソースで作成されている必要があります。
  #   1ユーザーに最大50個のSSH公開鍵を登録できます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/create-user.html
  user_name = "tftestuser"

  # body (Required)
  # 設定内容: ユーザーの認証に使用するSSH公開鍵の内容を指定します。
  # 設定可能な値: OpenSSH形式のSSH公開鍵文字列
  #   - RSA（2048ビット以上推奨）: "ssh-rsa AAAA..."
  #   - ECDSA: "ecdsa-sha2-nistp256 AAAA..."
  #   - Ed25519: "ssh-ed25519 AAAA..."
  # 関連機能: SSH公開鍵認証
  #   この公開鍵に対応する秘密鍵を持つクライアントがSFTPサーバーに接続できます。
  #   Transfer Familyはパスワード認証ではなく公開鍵認証をサポートしています。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/key-management.html
  body = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMC6D6hen2NSZWR3Y79UFIJ3GxS sample-key"

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
# - id: サーバーID、ユーザー名、SSHキーIDで構成される識別子
#       （形式: s-12345678abcdefgh/tftestuser/key-12345678abcdefgh）
#
# - ssh_key_id: Transfer Familyが割り当てたSSH公開鍵の識別子
#---------------------------------------------------------------
