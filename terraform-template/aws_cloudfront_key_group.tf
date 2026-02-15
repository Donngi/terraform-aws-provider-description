#---------------------------------------------------------------
# CloudFront Key Group
#---------------------------------------------------------------
#
# CloudFront Key Groupは、CloudFront署名付きURLや署名付きCookieで使用する
# 公開鍵のグループを管理するリソースです。
# 複数の公開鍵をグループ化することで、鍵のローテーションやマルチキー構成を
# 実現できます。
#
# AWS公式ドキュメント:
#   - CloudFront署名付きURLと署名付きCookie: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html
#   - キーグループの使用: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-trusted-signers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_key_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_key_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: キーグループの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコア（最大128文字）
  # 注意: アカウント内で一意である必要があります
  name = "example-key-group"

  # items (Required)
  # 設定内容: キーグループに含める公開鍵のIDリストを指定します。
  # 設定可能な値: aws_cloudfront_public_keyリソースのIDのセット
  # 注意:
  #   - 最低1つ以上の公開鍵IDを指定する必要があります
  #   - 最大5つまでの公開鍵を含めることができます
  #   - 鍵のローテーション時は複数の鍵を含めることを推奨します
  # 関連機能: CloudFront公開鍵管理
  #   署名付きURLやCookieの検証に使用される公開鍵を管理します。
  #   複数の鍵をグループに含めることで、鍵のローテーションを
  #   ダウンタイムなしで実行できます。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-trusted-signers.html
  items = [
    "K1234567890ABC",
    "K0987654321XYZ",
  ]

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # comment (Optional)
  # 設定内容: キーグループの説明コメントを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: コメントなし
  # 用途: キーグループの目的や用途を記録します
  comment = "本番環境用のキーグループ"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: キーグループの一意識別子
#
# - etag: キーグループの現在のバージョンを示すETag値
#       更新時の競合検出やバージョン管理に使用されます
#---------------------------------------------------------------
