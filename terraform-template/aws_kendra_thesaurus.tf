#---------------------------------------------------------------
# AWS Kendra Thesaurus
#---------------------------------------------------------------
#
# Amazon Kendraインデックスにシソーラス（類義語辞書）をプロビジョニングするリソースです。
# シソーラスはS3バケットに保存したUTF-8エンコードのテキストファイルで定義し、
# クエリ時に同義語を展開することで検索品質を向上させます。
#
# AWS公式ドキュメント:
#   - Amazon Kendraシソーラス概要: https://docs.aws.amazon.com/kendra/latest/dg/index-synonyms.html
#   - シソーラスの追加: https://docs.aws.amazon.com/kendra/latest/dg/index-synonyms-adding-thesaurus-file.html
#   - シソーラスファイルの作成: https://docs.aws.amazon.com/kendra/latest/dg/index-synonyms-creating-thesaurus-file.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_thesaurus
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_thesaurus" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: シソーラスの名前を指定します。
  # 設定可能な値: 1-100文字の文字列
  name = "example-thesaurus"

  # index_id (Required)
  # 設定内容: シソーラスを関連付けるKendraインデックスのIDを指定します。
  # 設定可能な値: 有効なKendraインデックスID
  index_id = aws_kendra_index.example.id

  # role_arn (Required)
  # 設定内容: S3バケット内のシソーラスファイルへのアクセスに使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: IAMロールにはS3バケットへの読み取り権限が必要です。
  role_arn = aws_iam_role.example.arn

  # description (Optional)
  # 設定内容: シソーラスの説明文を指定します。
  # 設定可能な値: 0-1000文字の文字列
  # 省略時: 説明なし
  description = "Example thesaurus for Kendra index"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # シソーラスファイル設定
  #-------------------------------------------------------------

  # source_s3_path (Required)
  # 設定内容: シソーラスファイルが格納されているS3パスの設定ブロックです。
  # 関連機能: Amazon Kendra シソーラスファイル
  #   UTF-8エンコードのテキストファイル（Solr形式）をS3に配置して使用します。
  #   ファイルサイズは5MB未満である必要があります。
  #   - https://docs.aws.amazon.com/kendra/latest/dg/index-synonyms-creating-thesaurus-file.html
  source_s3_path {

    # bucket (Required)
    # 設定内容: シソーラスファイルが格納されているS3バケットの名前を指定します。
    # 設定可能な値: 有効なS3バケット名
    bucket = aws_s3_bucket.example.id

    # key (Required)
    # 設定内容: S3バケット内のシソーラスファイルのオブジェクトキーを指定します。
    # 設定可能な値: 有効なS3オブジェクトキー（例: thesaurus/synonyms.txt）
    key = "thesaurus/synonyms.txt"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-thesaurus"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: シソーラスのARN
# - id: シソーラスIDとインデックスIDをスラッシュ（/）で結合した一意の識別子
# - status: シソーラスの現在のステータス
# - thesaurus_id: シソーラスの一意の識別子
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
