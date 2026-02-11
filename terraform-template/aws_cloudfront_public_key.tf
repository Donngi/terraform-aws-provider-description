# ================================================================================
# Terraform AWS Provider - aws_cloudfront_public_key Resource Template
# ================================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-18)の情報に基づいています。
#       最新の仕様については、必ず公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key
# ================================================================================

# aws_cloudfront_public_key
# CloudFront Public Keyリソース - 署名付きURL/Cookie、およびフィールドレベル暗号化で使用する公開鍵を管理
#
# AWS公式ドキュメント:
# - CloudFront フィールドレベル暗号化: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/field-level-encryption.html
# - CloudFront PublicKeyConfig API: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_PublicKeyConfig.html
# - CloudFront PublicKey API: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_PublicKey.html
#
# サポートされる鍵タイプ:
# - 署名付きURL/Cookie: RSA 2048またはECDSA 256
# - フィールドレベル暗号化: RSA 2048のみ

resource "aws_cloudfront_public_key" "example" {
  # ================================================================================
  # Required Attributes
  # ================================================================================

  # encoded_key - (Required) CloudFrontに追加するエンコードされた公開鍵
  # タイプ: string
  #
  # フィールドレベル暗号化などの機能で使用する公開鍵を指定します。
  # PEM形式の公開鍵を指定する必要があります。
  #
  # 重要: encoded_keyの値を設定する際、文字列の最後に改行が必要です。
  #       改行がない場合、Terraformの複数回の実行でリソースの再作成が発生します。
  #
  # サポート:
  # - 署名付きURL/Cookie: RSA 2048、ECDSA 256
  # - フィールドレベル暗号化: RSA 2048のみ
  #
  # 例: file("public_key.pem")を使用してPEMファイルから読み込む
  #
  # AWS公式ドキュメント:
  # - https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_PublicKeyConfig.html
  encoded_key = file("public_key.pem")

  # ================================================================================
  # Optional Attributes
  # ================================================================================

  # comment - (Optional) 公開鍵に関するオプションのコメント
  # タイプ: string
  # デフォルト: なし
  # 最大長: 128文字
  #
  # 公開鍵の説明やメモを記載できます。公開鍵の用途や管理情報を
  # 記録する際に便利です。
  #
  # AWS公式ドキュメント:
  # - https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_PublicKeyConfig.html
  comment = "test public key"

  # id - (Optional) リソースのID
  # タイプ: string
  # デフォルト: 自動生成
  #
  # リソースの識別子を指定します。通常は指定せず、CloudFrontによって
  # 自動生成されたIDを使用します。
  # 例: "K3D5EWEUDCCXON"
  #
  # 注意: 明示的に指定することも可能ですが、通常は自動生成に任せることを推奨します。
  #
  # AWS公式ドキュメント:
  # - https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_PublicKey.html
  # id = "K3D5EWEUDCCXON"

  # name - (Optional) 公開鍵の名前
  # タイプ: string
  # デフォルト: Terraformによって自動生成
  #
  # 公開鍵を識別するための名前を指定します。
  # 指定しない場合、Terraformが自動的に名前を生成します。
  # name_prefixとは競合するため、どちらか一方のみを使用してください。
  #
  # AWS公式ドキュメント:
  # - https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_PublicKeyConfig.html
  name = "test_key"

  # name_prefix - (Optional) 公開鍵の名前プレフィックス
  # タイプ: string
  # デフォルト: なし
  #
  # 公開鍵名のプレフィックスを指定します。残りの名前は自動生成されます。
  # nameとは競合するため、どちらか一方のみを使用してください。
  #
  # AWS公式ドキュメント:
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key
  # name_prefix = "test-key-"

  # ================================================================================
  # Computed Attributes (Read-Only)
  # ================================================================================
  # 以下の属性は自動的に計算され、参照のみ可能です:
  #
  # - id (string)
  #   公開鍵の識別子
  #   例: "K3D5EWEUDCCXON"
  #
  # - caller_reference (string)
  #   CloudFrontが内部で使用する値。公開鍵設定の将来の更新を可能にします
  #
  # - etag (string)
  #   公開鍵の現在のバージョン
  #   例: "E2QWRUHAPOMQZL"
  # ================================================================================
}

# ================================================================================
# 使用例
# ================================================================================
# output "public_key_id" {
#   description = "The identifier for the public key"
#   value       = aws_cloudfront_public_key.example.id
# }
#
# output "public_key_etag" {
#   description = "The current version of the public key"
#   value       = aws_cloudfront_public_key.example.etag
# }
#
# output "caller_reference" {
#   description = "Internal value used by CloudFront"
#   value       = aws_cloudfront_public_key.example.caller_reference
# }
