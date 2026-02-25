#---------------------------------------------------------------
# Amazon Kendra Query Suggestions Block List
#---------------------------------------------------------------
#
# Amazon Kendra のインデックスに対するクエリサジェストブロックリストを
# プロビジョニングするリソースです。ブロックリストは S3 バケットに保存した
# テキストファイルで定義し、ブロックワード・フレーズを含むクエリが
# サジェストとして表示されないようフィルタリングします。
#
# AWS公式ドキュメント:
#   - クエリサジェスト概要: https://docs.aws.amazon.com/kendra/latest/dg/query-suggestions.html
#   - CreateQuerySuggestionsBlockList API: https://docs.aws.amazon.com/kendra/latest/APIReference/API_CreateQuerySuggestionsBlockList.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_query_suggestions_block_list
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_query_suggestions_block_list" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # index_id (Required, Forces new resource)
  # 設定内容: ブロックリストを関連付ける Kendra インデックスの ID を指定します。
  # 設定可能な値: 有効な Kendra インデックス ID
  index_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # name (Required)
  # 設定内容: ブロックリストの名前を指定します。
  # 設定可能な値: 最大 100 文字の文字列
  name = "example-block-list"

  # role_arn (Required)
  # 設定内容: S3 バケット内のブロックリストテキストファイルへのアクセスに
  #           使用する IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロールの ARN
  # 注意: 指定する IAM ロールには S3 バケットへの読み取り権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/example-kendra-role"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ブロックリストの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: 説明なし
  description = "Example query suggestions block list"

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
  # S3 ソースパス設定
  #-------------------------------------------------------------

  # source_s3_path (Required)
  # 設定内容: ブロックリストのテキストファイルが格納されている S3 パスの設定ブロックです。
  #           テキストファイルにはブロックするワードやフレーズを 1 行ずつ記載します。
  # 参考: https://docs.aws.amazon.com/kendra/latest/dg/query-suggestions.html
  source_s3_path {

    # bucket (Required)
    # 設定内容: ブロックリストファイルが格納されている S3 バケット名を指定します。
    # 設定可能な値: 有効な S3 バケット名
    bucket = "example-bucket"

    # key (Required)
    # 設定内容: S3 バケット内のブロックリストファイルのオブジェクトキーを指定します。
    # 設定可能な値: 有効な S3 オブジェクトキー（パスを含むファイル名）
    key = "example/suggestions.txt"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" などの時間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-block-list"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ブロックリストの Amazon Resource Name (ARN)
# - query_suggestions_block_list_id: ブロックリストの一意の識別子
# - status: ブロックリストの現在の状態
#           (ACTIVE, CREATING, DELETING, UPDATING, ACTIVE_BUT_UPDATE_FAILED, FAILED)
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
