#---------------------------------------------------------------
# AWS Transfer Family サーバーホストキー
#---------------------------------------------------------------
#
# AWS Transfer Family の SFTP 対応サーバーに追加のホストキーを
# プロビジョニングするリソースです。
# ホストキーはサーバーの一意性を識別するために使用され、クライアントが
# 接続先サーバーの正当性を確認する際に使用されます。
# 複数のキータイプ（RSA、ECDSA、ED25519）を追加することで、
# 幅広いクライアントとの互換性を確保できます。
#
# AWS公式ドキュメント:
#   - サーバーホストキーの管理: https://docs.aws.amazon.com/transfer/latest/userguide/configuring-servers-change-host-key.html
#   - 追加ホストキーの追加: https://docs.aws.amazon.com/transfer/latest/userguide/server-host-key-add.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_host_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_host_key" "example" {
  #-------------------------------------------------------------
  # サーバー設定
  #-------------------------------------------------------------

  # server_id (Required)
  # 設定内容: ホストキーを追加する Transfer Family サーバーの ID を指定します。
  # 設定可能な値: aws_transfer_server リソースの id 属性（例: s-xxxxxxxxxxxxxxxxxxxx）
  server_id = aws_transfer_server.example.id

  #-------------------------------------------------------------
  # ホストキー設定
  #-------------------------------------------------------------

  # host_key_body (Optional)
  # 設定内容: SSH キーペアのプライベートキー部分を指定します。
  #   RSA、ECDSA、ED25519 の各キータイプに対応しています。
  #   このフィールドはセンシティブ属性であり、Terraform の状態ファイルに
  #   暗号化されずに保存されます。状態ファイルへの保存を避けたい場合は
  #   host_key_body_wo を使用してください。
  #   host_key_body または host_key_body_wo のいずれか一方を設定してください。
  # 設定可能な値: PEM 形式のプライベートキー文字列（パスフレーズなし）
  # 省略時: ホストキーの指定なし
  # 注意: キー作成時は -N "" オプションでパスフレーズなしを指定してください
  host_key_body = null

  # host_key_body_wo (Optional)
  # 設定内容: SSH キーペアのプライベートキー部分を write-only で指定します。
  #   host_key_body と同じ用途ですが、プランや状態ファイルへの書き込みが保証されない
  #   write-only 引数であるため、機密情報の漏洩リスクを低減できます。
  #   host_key_body または host_key_body_wo のいずれか一方を設定してください。
  # 設定可能な値: PEM 形式のプライベートキー文字列（パスフレーズなし）
  # 省略時: ホストキーの指定なし
  # 参考: https://developer.hashicorp.com/terraform/language/manage-sensitive-data/ephemeral#write-only-arguments
  host_key_body_wo = null

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ホストキーの説明テキストを指定します。
  #   複数のホストキーを管理する際に識別しやすくするために使用します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "example additional host key"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
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
  # 参考: プロバイダーレベルの default_tags 設定と一致するキーのタグは、
  #       プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-transfer-host-key"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ホストキーの Amazon Resource Name (ARN)
#
# - host_key_fingerprint: ホストキーの公開鍵フィンガープリント
#
# - host_key_id: ホストキーの ID
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
