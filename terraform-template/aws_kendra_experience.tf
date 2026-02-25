#---------------------------------------------------------------
# Amazon Kendra Experience
#---------------------------------------------------------------
#
# Amazon Kendra の検索エクスペリエンス（Experience）をプロビジョニングするリソースです。
# Kendra エクスペリエンスは、インデックスに関連付けられた検索 UI を提供し、
# ユーザーが Kendra 検索機能にアクセスするためのエンドポイントを生成します。
# コンテンツソース（データソース・FAQ）やユーザー ID 属性を設定することで
# きめ細かなアクセス制御と検索体験を実現します。
#
# AWS公式ドキュメント:
#   - Amazon Kendra とは: https://docs.aws.amazon.com/kendra/latest/dg/what-is-kendra.html
#   - エクスペリエンスの作成: https://docs.aws.amazon.com/kendra/latest/dg/deploying-search-experience-no-code.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_experience
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_experience" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: エクスペリエンスの名前を指定します。
  # 設定可能な値: 1〜1000文字の文字列
  name = "example-kendra-experience"

  # index_id (Required)
  # 設定内容: エクスペリエンスを関連付ける Kendra インデックスの ID を指定します。
  # 設定可能な値: 有効な Kendra インデックス ID（aws_kendra_index リソースの id 属性など）
  index_id = aws_kendra_index.example.id

  # role_arn (Required)
  # 設定内容: Amazon Kendra がエクスペリエンスを作成する際に引き受ける IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロールの ARN（例: arn:aws:iam::123456789012:role/KendraExperienceRole）
  # 注意: IAM ロールには Kendra エクスペリエンスの作成・管理に必要な権限が必要です。
  role_arn = aws_iam_role.example.arn

  # description (Optional)
  # 設定内容: エクスペリエンスの説明を指定します。
  # 設定可能な値: 1〜1000文字の文字列
  # 省略時: 説明なし
  description = "Example Kendra search experience"

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
  # コンテンツ・ユーザー設定
  #-------------------------------------------------------------

  # configuration (Optional)
  # 設定内容: エクスペリエンスのコンテンツソースおよびユーザー ID 属性を設定するブロックです。
  # 省略時: コンテンツソースおよびユーザー ID 設定なし
  configuration {

    #-------------------------------------------------------------
    # コンテンツソース設定
    #-------------------------------------------------------------

    # content_source_configuration (Optional)
    # 設定内容: エクスペリエンスで使用するコンテンツソースを設定するブロックです。
    # データソース・FAQ・ダイレクトプットコンテンツのいずれかまたは組み合わせを指定します。
    content_source_configuration {

      # data_source_ids (Optional)
      # 設定内容: エクスペリエンスで使用するデータソースの ID セットを指定します。
      # 設定可能な値: Kendra データソース ID の集合
      # 省略時: データソースを使用しない
      data_source_ids = []

      # faq_ids (Optional)
      # 設定内容: エクスペリエンスで使用する FAQ の ID セットを指定します。
      # 設定可能な値: Kendra FAQ ID の集合
      # 省略時: FAQ を使用しない
      faq_ids = []

      # direct_put_content (Optional)
      # 設定内容: ダイレクトプットコンテンツをコンテンツソースとして有効にするかを指定します。
      # 設定可能な値:
      #   - true: PutPrincipalMapping および BatchPutDocument で追加したドキュメントを含める
      #   - false: ダイレクトプットコンテンツを含めない
      # 省略時: false
      direct_put_content = false
    }

    #-------------------------------------------------------------
    # ユーザー ID 設定
    #-------------------------------------------------------------

    # user_identity_configuration (Optional)
    # 設定内容: Amazon IAM Identity Center（旧 SSO）を使用したユーザー ID 属性を設定するブロックです。
    # ユーザー属性フィルタリングを使用してエクスペリエンスへのアクセスを制御する際に使用します。
    user_identity_configuration {

      # identity_attribute_name (Required)
      # 設定内容: ユーザーのメールアドレスに相当するアプリケーションのユーザー属性名を指定します。
      # 設定可能な値: IAM Identity Center に登録されたユーザー属性名（例: "email"）
      # 注意: この属性名は IAM Identity Center のユーザープロファイルに設定されている属性名と一致させる必要があります。
      identity_attribute_name = "email"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 省略時: 各操作でデフォルトのタイムアウトを使用
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goの time.Duration 形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Kendra エクスペリエンスの Amazon Resource Name (ARN)
# - experience_id: Kendra エクスペリエンスの ID
# - id: "{index_id}/{experience_id}" 形式の識別子
# - status: エクスペリエンスのステータス（CREATING, ACTIVE, DELETING, FAILED など）
# - endpoints: エクスペリエンスのエンドポイント情報のセット
#   - endpoint: エンドポイントの URL
#   - endpoint_type: エンドポイントのタイプ（HOME など）
#---------------------------------------------------------------
