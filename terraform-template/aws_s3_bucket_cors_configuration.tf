#---------------------------------------------------------------
# Amazon S3 Bucket CORS Configuration
#---------------------------------------------------------------
#
# Amazon S3バケットのCross-Origin Resource Sharing（CORS）設定をプロビジョニングするリソースです。
# CORSを設定することで、異なるオリジン（ドメイン、プロトコル、ポート）からの
# S3バケットへのアクセスを制御できます。
#
# 注意事項:
# - CORS設定はバケット単位で適用されます
# - 最大100個のcors_ruleを設定できます
# - 同一バケットに対して複数のaws_s3_bucket_cors_configurationリソースを宣言すると
#   設定の永続的な差分が発生します
# - このリソースはS3ディレクトリバケットでは使用できません
# - CORS設定はHTTPヘッダーを通じてブラウザに伝えられるため、
#   サーバーサイドのアクセス制御とは独立して動作します
#
# AWS公式ドキュメント:
#   - CORS設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/cors.html
#   - CORSの有効化: https://docs.aws.amazon.com/AmazonS3/latest/userguide/enabling-cors-examples.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3_bucket_cors_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # bucket (Required)
  # 設定内容: CORS設定を適用するバケットの名前を指定します。
  # 設定可能な値: 既存のS3バケット名
  # 注意: 変更すると再作成されます（Forces new resource）
  bucket = "my-bucket-name"

  # expected_bucket_owner (Optional, 非推奨)
  # 設定内容: バケットの予期される所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 所有者の検証は行われません
  # 注意: この属性は非推奨です。変更すると再作成されます（Forces new resource）
  expected_bucket_owner = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # CORSルール設定（1〜100件指定可能）
  #-------------------------------------------------------------

  # cors_rule (Required, 1〜100件)
  # 設定内容: CORSリクエストを制御するルールを定義するブロックです。
  # 注意: 最低1件、最大100件のcors_ruleを指定できます
  cors_rule {
    # allowed_methods (Required)
    # 設定内容: 許可するHTTPメソッドのセットを指定します。
    # 設定可能な値: "GET", "PUT", "POST", "DELETE", "HEAD" の組み合わせ
    allowed_methods = ["GET", "PUT", "POST"]

    # allowed_origins (Required)
    # 設定内容: クロスオリジンアクセスを許可するオリジンのセットを指定します。
    # 設定可能な値: オリジンURL（例: "https://example.com"）またはワイルドカード "*"
    # 注意: ワイルドカード "*" を指定するとすべてのオリジンからのアクセスが許可されます
    allowed_origins = ["https://example.com"]

    # allowed_headers (Optional)
    # 設定内容: プリフライトリクエスト（OPTIONS）で許可するHTTPヘッダーのセットを指定します。
    # 設定可能な値: ヘッダー名（例: "Content-Type", "Authorization"）またはワイルドカード "*"
    # 省略時: ヘッダーの制限はありません
    # 用途: ブラウザがActual Requestで送信できるヘッダーを制御します
    allowed_headers = ["Content-Type", "Authorization"]

    # expose_headers (Optional)
    # 設定内容: ブラウザ（JavaScript）がアクセスできるレスポンスヘッダーのセットを指定します。
    # 設定可能な値: 公開するレスポンスヘッダー名（例: "ETag", "x-amz-meta-*"）
    # 省略時: 標準的な安全なレスポンスヘッダーのみアクセス可能
    # 用途: ETagやカスタムヘッダーをクライアントのJavaScriptから読み取れるようにする場合に使用
    expose_headers = ["ETag"]

    # id (Optional)
    # 設定内容: ルールを一意に識別するIDを指定します。
    # 設定可能な値: 最大255文字の文字列
    # 省略時: IDは割り当てられません
    id = "cors-rule-1"

    # max_age_seconds (Optional)
    # 設定内容: プリフライトリクエストの結果をブラウザがキャッシュする秒数を指定します。
    # 設定可能な値: 0以上の整数（秒単位）
    # 省略時: ブラウザのデフォルトキャッシュ動作に従います
    # 用途: キャッシュ時間を長くすることでプリフライトリクエストの回数を減らしパフォーマンスを向上させます
    max_age_seconds = 3000
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: bucket および expected_bucket_owner（設定されている場合）を
#       カンマ（,）で区切った文字列
#---------------------------------------------------------------
