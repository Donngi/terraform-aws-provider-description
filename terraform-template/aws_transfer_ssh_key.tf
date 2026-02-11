#---------------------------------------------------------------
# AWS Transfer Family SSH Key
#---------------------------------------------------------------
#
# AWS Transfer Familyのユーザーに対してSSH公開鍵を登録するリソースです。
# SFTP/SFTPSプロトコルを使用したファイル転送において、鍵ベース認証を
# 実現するために使用します。
#
# AWS公式ドキュメント:
#   - Managing users for server endpoints: https://docs.aws.amazon.com/transfer/latest/userguide/create-user.html
#   - Managing SSH and PGP keys in Transfer Family: https://docs.aws.amazon.com/transfer/latest/userguide/key-management.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_ssh_key" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # SSH公開鍵の本体
  # RSA、ECDSA、ED25519形式のSSH公開鍵をOpenSSH形式で指定します。
  # 例: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
  #
  # サポートされるアルゴリズム:
  #   - RSA (推奨: 2048ビット以上)
  #   - ECDSA
  #   - ED25519
  #
  # 注意:
  #   - 秘密鍵はAWSに送信せず、ローカルで安全に保管してください
  #   - 公開鍵の形式はOpenSSH形式である必要があります
  #   - trimspace()関数を使用して先頭・末尾の空白を除去することを推奨
  body = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."

  # Transfer ServerのID
  # SSH公開鍵を登録するTransfer ServerのIDを指定します。
  # 形式: s-xxxxxxxxxxxxxxxxx
  #
  # 例: "s-12345678"
  #
  # 参照:
  #   - aws_transfer_server.example.id
  server_id = "s-12345678"

  # ユーザー名
  # SSH公開鍵を関連付けるTransfer Familyユーザーの名前を指定します。
  # 指定したユーザーは事前にaws_transfer_userリソースで作成されている必要があります。
  #
  # 制約:
  #   - 100文字以内
  #   - 英数字、ハイフン、アンダースコアのみ使用可能
  #
  # 参照:
  #   - aws_transfer_user.example.user_name
  user_name = "example-user"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リージョン
  # このリソースを管理するAWSリージョンを指定します。
  # 省略した場合、プロバイダー設定で指定したリージョンが使用されます。
  #
  # 用途:
  #   - マルチリージョン展開時に明示的にリージョンを指定する場合に使用
  #   - 通常は省略してプロバイダー設定に従うことを推奨
  #
  # 例: "us-east-1", "ap-northeast-1"
  #
  # 参照:
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # 注意: id属性について
  #---------------------------------------------------------------
  # id属性はoptionalかつcomputedですが、Terraformが自動的に生成するため
  # 通常は指定しません。明示的な指定が必要な特殊なケース以外は省略してください。
}

#---------------------------------------------------------------
# Attributes Reference (出力専用属性)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です。
# Terraform設定ファイルで指定することはできません。
#
# - id
#     リソースのID
#     形式: <server_id>/<user_name>/<ssh_key_id>
#
# - ssh_key_id
#     SSH公開鍵の一意な識別子
#     形式: key-xxxxxxxxxxxxxxxxx
#---------------------------------------------------------------
