#---------------------------------------------------------------
# AWS Lambda Function URL
#---------------------------------------------------------------
#
# Lambda 関数に専用の HTTP(S) エンドポイントを作成するリソースです。
# Lambda Function URL を使用すると、API Gateway を経由せずに HTTP リクエスト経由で
# Lambda 関数を直接呼び出すことができます。認証なし（パブリック）または
# AWS IAM 認証をサポートします。
#
# NOTE: authorization_type が "NONE" の場合、lambda:InvokeFunctionUrl 権限が
#       自動的に関数に追加され、パブリックエンドポイントが有効になります。
#       これらのポリシーは、このリソースを削除しても AWS から削除されません。
#
# AWS公式ドキュメント:
#   - Lambda Function URLs: https://docs.aws.amazon.com/lambda/latest/dg/lambda-urls.html
#   - Function URL 認証: https://docs.aws.amazon.com/lambda/latest/dg/urls-auth.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_function_url" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # function_name (Required)
  # 設定内容: Lambda 関数の名前または ARN を指定します。
  # 設定可能な値:
  #   - 関数名: "my-function"
  #   - 関数 ARN: "arn:aws:lambda:region:account-id:function:my-function"
  # 注意: 関数が存在しない場合、このリソースの作成は失敗します。
  function_name = aws_lambda_function.example.function_name

  # authorization_type (Required)
  # 設定内容: Function URL が使用する認証タイプを指定します。
  # 設定可能な値:
  #   - "AWS_IAM": AWS IAM 認証を使用（署名付きリクエストが必要）
  #   - "NONE": 認証なし（パブリックアクセスを許可）
  # 注意: "NONE" を指定すると、誰でもこのエンドポイントを呼び出せます。
  #       lambda:InvokeFunctionUrl 権限が自動的に関数に追加されます。
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/urls-auth.html
  authorization_type = "AWS_IAM"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # qualifier (Optional)
  # 設定内容: エイリアス名または "$LATEST" を指定します。
  # 設定可能な値:
  #   - エイリアス名: "prod", "dev" など
  #   - "$LATEST": 最新バージョンを指定（デフォルト）
  # 省略時: 最新の公開されていないバージョンが対象になります。
  # 注意: 特定のバージョンの Lambda 関数にアクセスする場合に使用します。
  qualifier = null

  # invoke_mode (Optional)
  # 設定内容: Lambda 関数が呼び出しに応答する方法を指定します。
  # 設定可能な値:
  #   - "BUFFERED" (デフォルト): レスポンス全体をバッファリングしてから返す
  #   - "RESPONSE_STREAM": ストリーミングレスポンスをサポート
  # 省略時: "BUFFERED"
  # 関連機能: Lambda Response Streaming
  #   RESPONSE_STREAM を使用すると、大きなペイロードを段階的に返すことができます。
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/configuration-response-streaming.html
  invoke_mode = "BUFFERED"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # CORS 設定
  #-------------------------------------------------------------

  # cors (Optional)
  # 設定内容: Function URL のクロスオリジンリソース共有 (CORS) 設定を指定します。
  # 関連機能: CORS
  #   ブラウザベースのアプリケーションから異なるドメインの Function URL に
  #   アクセスできるようにします。
  # 参考: https://developer.mozilla.org/ja/docs/Web/HTTP/CORS
  cors {
    # allow_credentials (Optional)
    # 設定内容: Function URL へのリクエストでクッキーや他の認証情報を許可するかを指定します。
    # 設定可能な値:
    #   - true: クッキーや認証情報を許可
    #   - false (デフォルト): クッキーや認証情報を許可しない
    # 注意: allow_credentials を true にする場合、allow_origins に "*" を使用できません。
    allow_credentials = false

    # allow_headers (Optional)
    # 設定内容: Function URL へのリクエストに含めることができる HTTP ヘッダーを指定します。
    # 設定可能な値: HTTP ヘッダー名のリスト
    # 省略時: すべてのヘッダーが許可されます。
    # 例: ["Content-Type", "X-Custom-Header", "Authorization"]
    allow_headers = ["content-type", "x-amz-date", "authorization"]

    # allow_methods (Optional)
    # 設定内容: Function URL を呼び出すときに許可される HTTP メソッドを指定します。
    # 設定可能な値: ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "PATCH"]
    # 省略時: すべてのメソッドが許可されます。
    # 注意: OPTIONS メソッドは CORS プリフライトリクエストで自動的に使用されます。
    allow_methods = ["GET", "POST"]

    # allow_origins (Optional)
    # 設定内容: Function URL にアクセスできるオリジンを指定します。
    # 設定可能な値:
    #   - 特定のオリジン: ["https://example.com", "https://app.example.com"]
    #   - すべてのオリジン: ["*"] (allow_credentials が false の場合のみ)
    # 省略時: すべてのオリジンが許可されます。
    # セキュリティ: 本番環境では特定のオリジンのみを許可することを推奨します。
    allow_origins = ["https://example.com"]

    # expose_headers (Optional)
    # 設定内容: Function URL を呼び出すオリジンに公開する関数レスポンスの HTTP ヘッダーを指定します。
    # 設定可能な値: HTTP ヘッダー名のリスト
    # 省略時: デフォルトのセーフリストヘッダーのみが公開されます。
    # 注意: ブラウザの JavaScript からアクセスしたいカスタムヘッダーを指定します。
    expose_headers = ["date", "x-request-id"]

    # max_age (Optional)
    # 設定内容: Web ブラウザがプリフライトリクエストの結果をキャッシュできる最大時間（秒）を指定します。
    # 設定可能な値: 0〜86400 秒（0〜24 時間）
    # 省略時: ブラウザのデフォルト値（通常 5 秒）が使用されます。
    # 推奨: 頻繁に変更されない場合は、パフォーマンス向上のため高い値を設定します。
    max_age = 3600
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "10m" などの duration 文字列
    create = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - function_arn: Lambda 関数の ARN
#   形式: "arn:aws:lambda:region:account-id:function:function-name"
#
# - function_url: 関数の HTTP URL エンドポイント
#   形式: "https://<url_id>.lambda-url.<region>.on.aws/"
#   この URL を使用して Lambda 関数を HTTP リクエストで直接呼び出します。
#
# - url_id: エンドポイントに対して生成された一意の ID
#   この ID は function_url に含まれます。
#
# - id: Terraform のリソース識別子（function_name と同じ値）
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 1. 認証なしのパブリック Function URL:
#
# resource "aws_lambda_function_url" "public" {
#   function_name      = aws_lambda_function.example.function_name
#   authorization_type = "NONE"
#---------------------------------------------------------------
