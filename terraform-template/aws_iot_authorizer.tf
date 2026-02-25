#---------------------------------------------------------------
# AWS IoT カスタムオーソライザー
#---------------------------------------------------------------
#
# AWS IoT Core のカスタムオーソライザーをプロビジョニングするリソースです。
# カスタムオーソライザーは、AWS IoT Core がネイティブサポートする認証方式以外の
# 独自の認証・認可スキームを実装するための Lambda 関数を定義します。
# ベアラートークンや MQTT ユーザー名・パスワードを使用したデバイスの
# 認証に使用でき、HTTP、MQTT、WebSocket の各プロトコルに対応しています。
#
# AWS公式ドキュメント:
#   - カスタム認証と認可: https://docs.aws.amazon.com/iot/latest/developerguide/custom-authentication.html
#   - カスタムオーソライザーの作成と管理: https://docs.aws.amazon.com/iot/latest/developerguide/config-custom-auth.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_authorizer
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iot_authorizer" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: オーソライザーの名前を指定します。
  # 設定可能な値: 1〜128文字の文字列。使用可能な文字: [a-zA-Z0-9_=,@-]+
  name = "example-authorizer"

  # authorizer_function_arn (Required)
  # 設定内容: 認証・認可ロジックを実装する Lambda 関数の ARN を指定します。
  # 設定可能な値: 有効な Lambda 関数の ARN
  # 注意: Lambda 関数のタイムアウト上限は 5 秒です。
  #       関数の実行回数と実行時間に応じて AWS IoT Core の料金が発生します。
  authorizer_function_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:my-iot-authorizer"

  #-------------------------------------------------------------
  # 署名設定
  #-------------------------------------------------------------

  # signing_disabled (Optional)
  # 設定内容: 認証リクエスト内のトークン署名を AWS IoT が検証するかを指定します。
  # 設定可能な値:
  #   - false (デフォルト): 署名の検証を有効化。token_key_name と token_signing_public_keys の指定が必要
  #   - true: 署名の検証を無効化。MQTT ユーザー名・パスワードなど署名なし認証に使用
  # 注意: 既存オーソライザーの署名要件は変更できません。
  #       署名を必要とするオーソライザーで無効化、またはその逆は更新で変更不可です。
  signing_disabled = false

  # token_key_name (Optional)
  # 設定内容: HTTP ヘッダーからトークンを抽出するために使用するトークンキーの名前を指定します。
  # 設定可能な値: 1〜128文字の文字列。使用可能な文字: [a-zA-Z0-9_-]+
  # 注意: signing_disabled が false（署名有効）の場合は必須です。
  token_key_name = "Token-Header"

  # token_signing_public_keys (Optional)
  # 設定内容: カスタム認証サービスが返すトークン署名の検証に使用する公開鍵のマップを指定します。
  # 設定可能な値: キーと値のマップ。キーは [a-zA-Z0-9:_-]+ パターン、値は最大 5120 文字の公開鍵文字列（PEM 形式）
  # 注意: signing_disabled が false（署名有効）の場合は必須です。
  #       このフィールドはセンシティブ属性として扱われます（Terraform state に保存されますが表示は秘匿化）。
  token_signing_public_keys = {
    Key1 = file("path/to/public-key.pem")
  }

  #-------------------------------------------------------------
  # 動作設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: オーソライザーの状態を指定します。
  # 設定可能な値:
  #   - "ACTIVE" (デフォルト): オーソライザーを有効化し、認証リクエストを処理します
  #   - "INACTIVE": オーソライザーを無効化し、認証リクエストを処理しません
  status = "ACTIVE"

  # enable_caching_for_http (Optional)
  # 設定内容: HTTP 接続に対してオーソライザーの Lambda 関数の実行結果をキャッシュするかを指定します。
  # 設定可能な値:
  #   - false (デフォルト): キャッシュを無効化。リクエストのたびに Lambda 関数を呼び出します
  #   - true: キャッシュを有効化。Lambda 関数のレスポンスに含まれる refreshAfterInSeconds で指定した時間キャッシュします
  enable_caching_for_http = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値の文字列ペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルのタグを上書きします。
  tags = {
    Name        = "example-authorizer"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: オーソライザーの Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
