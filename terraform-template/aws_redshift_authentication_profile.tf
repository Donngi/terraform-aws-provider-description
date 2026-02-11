#---------------------------------------------------------------
# Amazon Redshift 認証プロファイル
#---------------------------------------------------------------
#
# Amazon Redshift への接続に使用する認証プロファイルをプロビジョニングします。
# 認証プロファイルを使用することで、JDBC、ODBC、Python ドライバーでの接続設定を
# 一元管理でき、複数の接続を管理する際の設定の複雑さを軽減できます。
#
# 認証プロファイルには、接続オプション（例：AllowDBUserOverride、Client_ID、
# App_ID、AutoCreate、enableFetchRingBuffer など）を JSON 形式で保存できます。
#
# AWS公式ドキュメント:
#   - 認証プロファイルを使用した接続: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-with-authentication-profiles.html
#   - 認証プロファイルの作成: https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-with-authentication-profiles-creating.html
#   - CreateAuthenticationProfile API: https://docs.aws.amazon.com/redshift/latest/APIReference/redshift-api.pdf#API_CreateAuthenticationProfile
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_authentication_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_authentication_profile" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 認証プロファイル名
  # - 認証プロファイルを一意に識別する名前
  # - この値を変更すると、リソースが再作成されます（Forces new resource）
  # - JDBC/ODBC/Python ドライバーで接続する際に AuthProfile パラメータとして指定します
  # - 例: "my_profile", "analytics_team_profile", "etl_profile"
  authentication_profile_name = "example"

  # 認証プロファイルのコンテンツ（JSON 形式）
  # - 接続オプションを JSON 形式の文字列として指定します
  # - jsonencode() 関数を使用して HCL から JSON に変換することを推奨します
  # - 設定可能な主なオプション:
  #   * AllowDBUserOverride: データベースユーザーの上書きを許可（"1" または "0"）
  #   * Client_ID: OAuth クライアント ID
  #   * App_ID: アプリケーション ID
  #   * AutoCreate: データベースユーザーの自動作成（true または false）
  #   * enableFetchRingBuffer: フェッチリングバッファの有効化（true または false）
  #   * databaseMetadataCurrentDbOnly: メタデータを現在のDBのみに制限（true または false）
  # - 以下の機密情報は保存できません:
  #   * AccessKeyID, access_key_id
  #   * SecretAccessKey, secret_access_key_id
  #   * PWD, Password, password
  #   * AuthProfile, auth_profile
  # - 最大長はアカウントのクォータによって決定されます
  # - 例:
  #   jsonencode({
  #     AllowDBUserOverride         = "1"
  #     Client_ID                   = "ExampleClientID"
  #     App_ID                      = "example"
  #     AutoCreate                  = false
  #     enableFetchRingBuffer       = true
  #     databaseMetadataCurrentDbOnly = true
  #   })
  authentication_profile_content = jsonencode({
    AllowDBUserOverride = "1"
    Client_ID           = "ExampleClientID"
    App_ID              = "example"
  })

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リージョン
  # - このリソースを管理するAWSリージョン
  # - 指定しない場合は、プロバイダー設定のリージョンがデフォルトとして使用されます
  # - 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - 例: "us-east-1", "ap-northeast-1", "eu-west-1"
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
#
# このリソースから参照できる属性:
#
# - id
#   - 認証プロファイルの識別子（認証プロファイル名と同じ値）
#   - 例: aws_redshift_authentication_profile.example.id
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 認証プロファイルを作成後、JDBC 接続文字列で以下のように使用できます:
#
# jdbc:redshift:iam://endpoint:port/database?AuthProfile=<Profile-Name>&AccessKeyID=<Caller-Access-Key>&SecretAccessKey=<Caller-Secret-Key>
#
# 制限事項:
# - 各 AWS アカウントには 10 個までの認証プロファイルのクォータがあります
# - 認証プロファイルは Amazon DynamoDB に保存され、AWS によって管理されます
#
#---------------------------------------------------------------
