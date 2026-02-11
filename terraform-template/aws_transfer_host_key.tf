#---------------------------------------------------------------
# AWS Transfer Family ホストキー
#---------------------------------------------------------------
#
# AWS Transfer FamilyサーバーのSSHホストキーを管理します。
# これは追加のサーバーホストキーです。
# サーバーに複数のホストキーを設定することで、異なるキータイプをサポートできます。
#
# AWS公式ドキュメント:
#   - 追加サーバーホストキー: https://docs.aws.amazon.com/transfer/latest/userguide/server-host-key-add.html
#   - AWS Transfer Family ユーザーガイド: https://docs.aws.amazon.com/transfer/latest/userguide/what-is-aws-transfer-family.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_host_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_host_key" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # AWS Transfer Familyサーバーのサーバー ID
  # 説明: このホストキーを関連付けるサーバーのID
  # 制約: 既存のTransferサーバーのIDを指定する必要があります
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server
  server_id = "s-1234567890abcdef0"


  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ホストキーの説明
  # 説明: このホストキーを識別するためのテキスト説明
  # 用途: 管理やドキュメント目的で使用
  # 例: "Production server RSA host key", "example additional host key"
  description = null

  # SSHキーペアの秘密鍵部分
  # 説明: サーバーホストキーとして使用するSSH秘密鍵（PEM形式）
  # 制約: host_key_body または host_key_body_wo のいずれか一方を指定する必要があります
  # 注意: この値はTerraformのstateファイルに保存されます
  # センシティブ: true
  # 形式: PEM形式の秘密鍵
  # 例: ssh-keygenコマンドで生成したRSA、ECDSA、ED25519キー
  host_key_body = null

  # SSHキーペアの秘密鍵部分（書き込み専用）
  # 説明: Terraformのplan/stateに書き込まれないことが保証されている秘密鍵
  # 制約: host_key_body または host_key_body_wo のいずれか一方を指定する必要があります
  # 用途: より高いセキュリティが必要な場合に使用
  # センシティブ: true
  # Write-only: true（planやstate artifactsに書き込まれません）
  # 形式: PEM形式の秘密鍵
  # 推奨: セキュリティを重視する場合は host_key_body ではなくこちらを使用
  # 参考: https://developer.hashicorp.com/terraform/language/manage-sensitive-data/ephemeral#write-only-arguments
  host_key_body_wo = null

  # AWSリージョン
  # 説明: このリソースを管理するリージョン
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 用途: マルチリージョン構成でリージョンを明示的に指定する場合
  region = null

  # タグ
  # 説明: リソースに割り当てるタグのマップ
  # 用途: リソースの分類、コスト配分、管理に使用
  # 注意: プロバイダーの default_tags と重複するキーは上書きされます
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    # Name        = "example-host-key"
    # Environment = "production"
    # ManagedBy   = "terraform"
  }
}


#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です（設定不可）
#
# arn                   - ホストキーのAmazon Resource Name (ARN)
# host_key_id           - ホストキーのID
# host_key_fingerprint  - 公開鍵のフィンガープリント
# tags_all              - プロバイダーの default_tags を含む全てのタグ
#---------------------------------------------------------------
