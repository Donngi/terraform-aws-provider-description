#---------------------------------------------------------------
# AWS MemoryDB User
#---------------------------------------------------------------
#
# Amazon MemoryDB のユーザーをプロビジョニングするリソースです。
# ユーザーはアクセス文字列と認証方式（パスワードまたはIAM）を持ち、
# Access Control List（ACL）に割り当てることでクラスターへのアクセスを制御します。
#
# AWS公式ドキュメント:
#   - MemoryDB ACLによるユーザー認証: https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html
#   - IAM認証: https://docs.aws.amazon.com/memorydb/latest/devguide/auth-iam.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_user
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_user" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # user_name (Required, Forces new resource)
  # 設定内容: MemoryDB ユーザーの名前を指定します。
  # 設定可能な値: 最大40文字の文字列
  # 注意: ユーザー名は作成後に変更できません。変更する場合はリソースの再作成が必要です。
  user_name = "my-user"

  # access_string (Required)
  # 設定内容: ユーザーのアクセス権限を定義するアクセス文字列を指定します。
  # 設定可能な値: Redis OSS ACL 形式のアクセス文字列
  #   - "on ~* &* +@all": 全コマンド・全キー・全チャンネルへのアクセスを許可
  #   - "on ~app:* +@read": app: プレフィックスのキーへの読み取りのみ許可
  #   - "off": ユーザーを無効化
  # 参考: https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html
  access_string = "on ~* &* +@all"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication_mode (Required)
  # 設定内容: ユーザーの認証方式を定義するブロックです。
  # 参考: https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html
  # 注意: すべての引数（ユーザー名・パスワードを含む）はTerraform stateに平文で保存されます。
  authentication_mode {

    # type (Required)
    # 設定内容: 認証の種類を指定します。
    # 設定可能な値:
    #   - "password": パスワードによる認証。passwords 引数でパスワードを指定します。
    #   - "iam": IAM認証。Valkey または Redis OSS エンジンバージョン 7.0 以降が必要です。
    # 参考: https://docs.aws.amazon.com/memorydb/latest/devguide/auth-iam.html
    type = "password"

    # passwords (Optional)
    # 設定内容: 認証に使用するパスワードのセットを指定します。
    # 設定可能な値: 1〜2個のパスワード文字列のセット
    # 省略時: type が "iam" の場合は不要です。
    # 注意: type が "password" の場合に指定します。パスワードは最大2つまで設定できます。
    #       この値はTerraform stateにsensitiveとして保存されますが、stateファイル自体は平文です。
    passwords = ["my-password-1"]
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-memorydb-user"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ユーザーのAmazon Resource Name (ARN)
#
# - minimum_engine_version: ユーザーがサポートする最小エンジンバージョン
#
# - authentication_mode.password_count: type が "password" の場合のパスワード数
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
