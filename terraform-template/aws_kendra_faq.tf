#---------------------------------------------------------------
# AWS Kendra FAQ
#---------------------------------------------------------------
#
# Amazon Kendra の FAQ（よくある質問と回答）をプロビジョニングするリソースです。
# FAQは S3 に保存された CSV または JSON ファイルから読み込まれ、Kendra インデックスに
# 追加されることで、ユーザーの自然言語クエリに対して直接的な回答を提供します。
#
# 主なユースケース:
#   - 社内ナレッジベースの Q&A データを Kendra インデックスに登録
#   - カスタマーサポート FAQ を検索システムに統合
#   - 既存の FAQ ドキュメントを Kendra で検索可能にする
#
# 重要な注意事項:
#   - FAQ ファイルは CSV（質問・回答の2列）または JSON 形式で S3 に配置する必要があります
#   - FAQ の作成・削除には時間がかかるため、timeouts ブロックで調整することを推奨します
#   - role_arn に指定するロールには、S3 バケットへの読み取り権限が必要です
#
# AWS公式ドキュメント:
#   - FAQ 概要: https://docs.aws.amazon.com/kendra/latest/dg/in-creating-faq.html
#   - FAQ ファイル形式: https://docs.aws.amazon.com/kendra/latest/dg/faq-questions-answer-file.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/kendra_faq
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_faq" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Required)
  # 設定内容: FAQ の名前を指定します。
  # 設定可能な値: 1〜100文字の英数字、スペース、ハイフン、アンダースコアを含む文字列
  # 省略時: 省略不可
  name = "example-faq"

  # index_id (Required)
  # 設定内容: この FAQ を追加する Kendra インデックスの ID を指定します。
  # 設定可能な値: Kendra インデックスの ID 文字列（aws_kendra_index リソースの id 属性など）
  # 省略時: 省略不可
  index_id = aws_kendra_index.example.id

  # role_arn (Required)
  # 設定内容: Kendra が S3 バケットから FAQ ファイルを読み取るために使用する IAM ロールの ARN を指定します。
  # 設定可能な値: IAM ロールの ARN 文字列
  # 省略時: 省略不可
  #
  # 必要な権限:
  #   - s3:GetObject（FAQ ファイルが格納された S3 バケットへのアクセス）
  #   - kendra:BatchPutDocument（インデックスへのドキュメント追加）
  role_arn = aws_iam_role.kendra_faq.arn

  # description (Optional)
  # 設定内容: FAQ の説明文を指定します。
  # 設定可能な値: 最大 1000 文字の文字列
  # 省略時: 説明なし
  description = "Example FAQ for Kendra index"

  # file_format (Optional)
  # 設定内容: S3 に格納された FAQ ファイルの形式を指定します。
  # 設定可能な値:
  #   - "CSV"              : 質問と回答の2列を持つ CSV ファイル（ヘッダー行なし）
  #   - "CSV_WITH_HEADER"  : ヘッダー行付きの CSV ファイル（Question, Answer の列名）
  #   - "JSON"             : JSON 形式のファイル
  # 省略時: "CSV"
  file_format = "CSV"

  # language_code (Optional)
  # 設定内容: FAQ のコンテンツに使用される言語コードを指定します。
  # 設定可能な値: BCP-47 形式の言語コード
  #   例: "en"（英語）、"ja"（日本語）、"zh"（中国語）、"fr"（フランス語）、"de"（ドイツ語）
  # 省略時: インデックスのデフォルト言語コード
  language_code = "ja"

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: AWS リージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョン
  region = null

  #---------------------------------------------------------------
  # S3 ファイルパス設定
  #---------------------------------------------------------------

  # s3_path ブロック (Required)
  # 設定内容: FAQ ファイルが格納された S3 バケットとキーを指定します。
  # 省略時: 省略不可（min_items = 1）
  s3_path {
    # bucket (Required)
    # 設定内容: FAQ ファイルが格納された S3 バケット名を指定します。
    # 設定可能な値: S3 バケット名の文字列
    # 省略時: 省略不可
    bucket = aws_s3_bucket.faq.bucket

    # key (Required)
    # 設定内容: S3 バケット内の FAQ ファイルのキー（パス）を指定します。
    # 設定可能な値: S3 オブジェクトキーの文字列
    # 省略時: 省略不可
    key = "faq/questions-and-answers.csv"
  }

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグをキーと値のペアで指定します。
  # 設定可能な値: キーと値のペアのマップ。最大 50 個のタグを指定可能
  # 省略時: タグなし
  tags = {
    Name        = "example-faq"
    Environment = "development"
    ManagedBy   = "Terraform"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts ブロック (Optional)
  # 設定内容: FAQ の作成・削除操作のタイムアウト時間を指定します。
  # 省略時: Terraform のデフォルトタイムアウト
  timeouts {
    # create (Optional)
    # 設定内容: FAQ 作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値
    create = "30m"

    # delete (Optional)
    # 設定内容: FAQ 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 形式の文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルト値
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn
#     FAQ の ARN
#     例: arn:aws:kendra:ap-northeast-1:123456789012:index/xxxxxxxx/faq/yyyyyyyy
#
# - created_at
#     FAQ が作成された日時（ISO 8601 形式）
#
# - error_message
#     FAQ の作成に失敗した場合のエラーメッセージ
#
# - faq_id
#     FAQ の一意の識別子
#
# - id
#     "<index_id>/<faq_id>" 形式の複合 ID
#
# - status
#     FAQ の現在のステータス（CREATING, ACTIVE, DELETING, FAILED）
#
# - updated_at
#     FAQ が最後に更新された日時（ISO 8601 形式）
#
# - tags_all
#     プロバイダーのデフォルトタグを含む全タグのマップ
#
