#---------------------------------------------------------------
# S3 Directory Bucket Access Point Scope
#---------------------------------------------------------------
#
# ディレクトリバケットのアクセスポイントスコープを管理するリソース。
# アクセスポイントスコープを使用することで、特定のプレフィックス・APIアクション、
# またはその組み合わせへのアクセスを制限できます。
# 指定できるプレフィックス数に制限はありませんが、全プレフィックスの合計文字数は
# 256バイト未満である必要があります。
#
# 注意: スタンドアロンリソース（aws_s3control_directory_bucket_access_point_scope）と
#       aws_s3_directory_access_point リソースのインラインスコープは同時に使用できません。
#       どちらか一方のみを使用してください。
#
# AWS公式ドキュメント:
#   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-directory-buckets-manage-scope.html
#   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/opt-in-directory-bucket-lz.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_directory_bucket_access_point_scope
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_directory_bucket_access_point_scope" "example" {

  #---------------------------------------
  # アクセスポイント識別設定
  #---------------------------------------

  # 設定内容: スコープを適用するアクセスポイントの名前
  # 省略時: 必須項目のため省略不可
  name = "example--zoneId--xa-s3"

  # 設定内容: 指定したアクセスポイントを所有するAWSアカウントID
  # 省略時: 必須項目のため省略不可
  account_id = "123456789012"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定で指定されたリージョンが使用される
  region = "ap-northeast-1"

  #---------------------------------------
  # スコープ設定
  #---------------------------------------

  # 設定内容: アクセスを制限する対象のプレフィックスおよびAPIアクションのスコープ設定
  # 省略時: スコープなし（デフォルトは permissions=[] prefixes=[]）
  # 注意: スコープを削除する場合は scope { permissions = [] prefixes = [] } を設定すること
  scope {
    # 設定内容: アクセスを許可するS3 APIアクションの一覧
    # 設定可能な値: "GetObject", "PutObject", "DeleteObject", "ListBucket", etc.
    # 省略時: 設定なし（APIアクションによる制限なし）
    permissions = ["GetObject", "ListBucket"]

    # 設定内容: アクセスを制限するS3オブジェクトプレフィックスの一覧
    # 設定可能な値: 任意のプレフィックス文字列（ワイルドカード * 使用可能）
    #             全プレフィックスの合計文字数は256バイト未満であること
    # 省略時: 設定なし（プレフィックスによる制限なし）
    prefixes = ["myobject1.csv", "myobject2*"]
  }
}

#---------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アクセスポイントスコープの識別子
#---------------------------------------
