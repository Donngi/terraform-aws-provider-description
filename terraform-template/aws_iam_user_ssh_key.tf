#---------------------------------------------------------------
# AWS IAM User SSH Key
#---------------------------------------------------------------
#
# IAMユーザーにSSH公開鍵をアップロードし、関連付けるリソースです。
# アップロードされたSSH公開鍵は、AWS CodeCommitリポジトリへの
# SSH認証に使用できます。
#
# AWS公式ドキュメント:
#   - IAM SSH キー: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_ssh-keys.html
#   - UploadSSHPublicKey API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UploadSSHPublicKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_ssh_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_user_ssh_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # username (Required)
  # 設定内容: SSH公開鍵を関連付けるIAMユーザーの名前を指定します。
  # 設定可能な値: 1-64文字の英数字、+、=、,、.、@、- を含む文字列
  username = "example-user"

  # encoding (Required)
  # 設定内容: レスポンスで使用する公開鍵のエンコード形式を指定します。
  # 設定可能な値:
  #   - "SSH": ssh-rsa形式で公開鍵を取得する場合に指定
  #   - "PEM": PEM形式で公開鍵を取得する場合に指定
  # 注意: 公開鍵はssh-rsa形式またはPEM形式でエンコードされている必要があります。
  encoding = "SSH"

  # public_key (Required)
  # 設定内容: アップロードするSSH公開鍵を指定します。
  # 設定可能な値: ssh-rsa形式またはPEM形式でエンコードされた公開鍵文字列（1-16384文字）
  # 注意: 秘密鍵ではなく公開鍵のみを指定してください。
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 myuser@example.com"

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: SSH公開鍵に割り当てるステータスを指定します。
  # 設定可能な値:
  #   - "Active" (デフォルト): キーが有効。CodeCommitリポジトリへの認証に使用可能
  #   - "Inactive": キーが無効。CodeCommitリポジトリへの認証に使用不可
  # 省略時: "Active" として設定されます。
  # 参考: https://docs.aws.amazon.com/IAM/latest/APIReference/API_UpdateSSHPublicKey.html
  status = "Active"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - ssh_public_key_id: SSH公開鍵の一意の識別子（20-128文字）
#
# - fingerprint: SSH公開鍵のMD5メッセージダイジェスト（48文字）
#---------------------------------------------------------------
