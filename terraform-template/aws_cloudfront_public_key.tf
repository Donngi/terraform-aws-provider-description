#---------------------------------------------------------------
# Amazon CloudFront Public Key
#---------------------------------------------------------------
#
# CloudFront用の公開鍵を登録するリソースです。
# 署名付きURL/Cookie、フィールドレベル暗号化の両方に使用可能です。
#
# サポートされる公開鍵タイプ:
#   - RSA 2048: 署名付きURL/Cookie、フィールドレベル暗号化の両方に使用可能
#   - ECDSA 256: 署名付きURL/Cookie のみ使用可能
#
# 主なユースケース:
#   1. 署名付きURL/Cookieによるプライベートコンテンツ配信
#   2. フィールドレベル暗号化によるPOSTデータの機密情報保護
#   3. キーペアローテーション（複数公開鍵の登録による切り替え）
#
# 重要な制約事項:
#   - 公開鍵はPEM形式で指定（改行含む）
#   - フィールドレベル暗号化はRSA 2048のみ対応
#   - 削除時は関連リソース（Field-Level Encryption Profile等）を先に削除する必要があります
#
# AWS公式ドキュメント:
#   - フィールドレベル暗号化: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/field-level-encryption.html
#   - 署名付きURL/Cookie: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html
#   - PublicKeyConfig API: https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_PublicKeyConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 基本設定
#---------------------------------------------------------------

resource "aws_cloudfront_public_key" "example" {
  #---------------------------------------------------------------
  # 公開鍵設定
  #---------------------------------------------------------------

  # 公開鍵 (PEM形式)
  # 設定内容: RSA 2048またはECDSA 256の公開鍵をPEM形式で指定します
  # 設定可能な値:
  #   - RSA 2048: 署名付きURL/Cookie、フィールドレベル暗号化の両方に使用可能
  #   - ECDSA 256: 署名付きURL/Cookie のみ使用可能
  # 省略可否: 不可（必須項目）
  # 注意事項:
  #   - PEM形式には改行が含まれるため、heredoc構文またはfile()関数を使用してください
  #   - BEGIN PUBLIC KEY / END PUBLIC KEY のヘッダー/フッターを含める必要があります
  #   - フィールドレベル暗号化を使用する場合はRSA 2048を選択してください
  encoded_key = <<-EOT
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx...
-----END PUBLIC KEY-----
EOT

  # 別のファイルから読み込む場合:
  # encoded_key = file("${path.module}/keys/cloudfront_public_key.pem")

  #---------------------------------------------------------------
  # 識別設定
  #---------------------------------------------------------------

  # 公開鍵名
  # 設定内容: 公開鍵を識別するための名前を指定します
  # 省略時: name_prefix が指定されている場合は自動生成されます
  # 注意事項:
  #   - name と name_prefix は排他的（両方指定不可）
  #   - キーローテーション時は名前を変えて新規作成を推奨します
  name = "cloudfront-public-key-prod"

  # 公開鍵名プレフィックス
  # 設定内容: 公開鍵名の自動生成用プレフィックスを指定します
  # 省略時: プレフィックスなしの名前を使用します
  # 注意事項: name と name_prefix は排他的（両方指定不可）
  name_prefix = "cloudfront-key-"

  #---------------------------------------------------------------
  # メタデータ設定
  #---------------------------------------------------------------

  # コメント
  # 設定内容: 公開鍵の説明や用途を記述します
  # 設定可能な値: 最大128文字の文字列
  # 省略時: コメントなし
  # 設定例:
  #   - 用途の明示: "プレミアムコンテンツ配信用の公開鍵"
  #   - 有効期限の記載: "2024年12月まで有効"
  #   - 環境の明示: "本番環境用 (署名付きURL)"
  comment = "本番環境のプレミアムコンテンツ配信用公開鍵 (RSA 2048)"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースでは以下の属性を参照可能です:
#
# - id: 公開鍵ID（CloudFrontが自動生成する一意識別子）
# - caller_reference: リクエストのリプレイ防止用の一意な参照文字列（自動生成）
# - etag: 公開鍵のバージョン識別用ETag（更新検知に使用）
#
# 参照例:
#   aws_cloudfront_field_level_encryption_profile.example {
#     encryption_entities {
#       items {
#         public_key_id = aws_cloudfront_public_key.example.id
#       }
#     }
#   }
#---------------------------------------------------------------
