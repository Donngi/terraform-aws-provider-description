#---------------------------------------------------------------
# Amazon Kendra Thesaurus
#---------------------------------------------------------------
#
# Amazon Kendra Thesaurusは、検索インデックスに対してシノニム（同義語）の
# 辞書を提供するリソースです。Thesaurusを使用すると、検索クエリに対して
# 同義語を自動的に展開し、より包括的な検索結果を返すことができます。
# Thesaurusファイルは Solr 形式で記述し、S3バケットに配置する必要があります。
#
# AWS公式ドキュメント:
#   - CreateThesaurus API: https://docs.aws.amazon.com/kendra/latest/APIReference/API_CreateThesaurus.html
#   - Adding a thesaurus to an index: https://docs.aws.amazon.com/kendra/latest/dg/index-synonyms-adding-thesaurus-file.html
#   - IAM access roles for Amazon Kendra: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kendra_thesaurus
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kendra_thesaurus" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # index_id - Thesaurusを追加するKendraインデックスのID
  # Type: string (required)
  #
  # Kendraインデックスの一意の識別子を指定します。
  # 形式: 36文字の固定長（例: "12345678-1234-1234-1234-123456789012"）
  # パターン: [a-zA-Z0-9][a-zA-Z0-9-]*
  index_id = "12345678-1234-1234-1234-123456789012"

  # name - Thesaurusの名前
  # Type: string (required)
  #
  # Thesaurusの識別に使用される名前を指定します。
  # 制約:
  #   - 長さ: 1〜100文字
  #   - パターン: [a-zA-Z0-9][a-zA-Z0-9_-]*
  #   - 英数字、アンダースコア、ハイフンが使用可能
  name = "example-thesaurus"

  # role_arn - S3バケットへのアクセス権限を持つIAMロールのARN
  # Type: string (required)
  #
  # ThesaurusファイルをS3から読み取るために必要な権限を持つIAMロールを指定します。
  # このロールには以下の権限が必要です:
  #   - s3:GetObject (ThesaurusファイルのS3オブジェクトへのアクセス)
  #   - s3:ListBucket (オプション: バケット内のオブジェクト一覧取得)
  #   - kms:Decrypt (S3オブジェクトがKMS暗号化されている場合)
  #
  # 制約:
  #   - 長さ: 0〜1284文字
  #   - パターン: arn:[a-z0-9-\.]{1,63}:[a-z0-9-\.]{0,63}:[a-z0-9-\.]{0,63}:[a-z0-9-\.]{0,63}:[^/].{0,1023}
  #
  # 参考: https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html
  role_arn = "arn:aws:iam::123456789012:role/KendraThesaurusRole"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # description - Thesaurusの説明
  # Type: string (optional)
  #
  # Thesaurusの用途や内容を説明するテキストを指定します。
  # 制約:
  #   - 長さ: 0〜1000文字
  #   - パターン: ^\P{C}*$ (制御文字を除く全てのUnicode文字が使用可能)
  description = "Example thesaurus for synonym expansion in search queries"

  # region - リソースを管理するAWSリージョン
  # Type: string (optional, computed)
  #
  # このリソースを管理するAWSリージョンを明示的に指定します。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - リソースタグ
  # Type: map(string) (optional)
  #
  # Thesaurusに付与するタグのキーと値のマップを指定します。
  # タグはリソースの整理、コスト配分、アクセス制御などに使用できます。
  #
  # 制約:
  #   - タグキーと値には Unicode 文字、数字、空白、および以下の記号が使用可能:
  #     _ . : / = + - @
  #   - 最大200個のタグを設定可能
  #
  # プロバイダーのdefault_tagsと統合されます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "Example Kendra Thesaurus"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # ネストブロック (Required)
  #---------------------------------------------------------------

  # source_s3_path - ThesaurusファイルのS3パス
  # Type: list(object) (required)
  # Min items: 1, Max items: 1
  #
  # Thesaurusファイル（Solr形式）が配置されているS3の場所を指定します。
  # Thesaurusファイルは以下の要件を満たす必要があります:
  #   - ファイルサイズ: 5MB未満
  #   - フォーマット: Solr Thesaurus形式
  #   - 反映時間: 更新後、効果が現れるまで最大30分かかる場合があります
  source_s3_path {
    # bucket - S3バケット名
    # Type: string (required)
    #
    # Thesaurusファイルが保存されているS3バケットの名前を指定します。
    bucket = "example-kendra-bucket"

    # key - S3オブジェクトキー（ファイルパス）
    # Type: string (required)
    #
    # S3バケット内のThesaurusファイルのパス（キー）を指定します。
    # 例: "thesaurus/synonyms.txt", "kendra-resources/thesaurus/en-synonyms.txt"
    key = "thesaurus/synonyms.txt"
  }

  #---------------------------------------------------------------
  # タイムアウト設定（オプション）
  #---------------------------------------------------------------

  # timeouts - リソース操作のタイムアウト設定
  # Type: object (optional)
  #
  # Terraform操作のタイムアウト時間を指定します。
  # Thesaurusの作成や更新には時間がかかる場合があるため、
  # 必要に応じてタイムアウトを調整できます。
  timeouts {
    # create - 作成操作のタイムアウト
    # Type: string (optional)
    # Default: 通常のタイムアウト値
    # 形式: "30m", "1h" など
    create = "30m"

    # update - 更新操作のタイムアウト
    # Type: string (optional)
    # Default: 通常のタイムアウト値
    update = "30m"

    # delete - 削除操作のタイムアウト
    # Type: string (optional)
    # Default: 通常のタイムアウト値
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（読み取り専用）:
#
# - arn (string)
#   ThesaurusのAmazon Resource Name (ARN)
#   形式: arn:aws:kendra:<region>:<account-id>:index/<index-id>/thesaurus/<thesaurus-id>
#
# - id (string)
#   Thesaurusの一意の識別子
#   形式: <thesaurus_id>/<index_id>（スラッシュ区切り）
#   例: "example-thesaurus-id/12345678-1234-1234-1234-123456789012"
#
# - status (string)
#   Thesaurusの現在のステータス
#   可能な値:
#     - CREATING: 作成中
#     - ACTIVE: アクティブ（使用可能）
#     - DELETING: 削除中
#     - UPDATING: 更新中
#     - ACTIVE_BUT_UPDATE_FAILED: アクティブだが更新に失敗
#     - FAILED: 失敗
#
# - tags_all (map(string))
#   リソースに割り当てられた全てのタグ（プロバイダーのdefault_tagsを含む）
#
# - thesaurus_id (string)
#   Kendraが生成したThesaurusの一意のID
#   長さ: 1〜100文字
#   パターン: [a-zA-Z0-9][a-zA-Z0-9_-]*
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 出力値の参照
#---------------------------------------------------------------
# output "thesaurus_arn" {
#   description = "The ARN of the Kendra thesaurus"
#   value       = aws_kendra_thesaurus.example.arn
# }
#
# output "thesaurus_id" {
#   description = "The ID of the Kendra thesaurus"
#   value       = aws_kendra_thesaurus.example.thesaurus_id
# }
#
# output "thesaurus_status" {
#   description = "The current status of the Kendra thesaurus"
#   value       = aws_kendra_thesaurus.example.status
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 補足情報
#---------------------------------------------------------------
#
# 1. Thesaurusファイル形式 (Solr形式)
#    Thesaurusファイルは以下のいずれかの形式で記述します:
#
#    a) 同義語形式（Equivalent Synonyms）:
#       ipod, i-pod, i pod
#       universe, cosmos
#
#    b) 明示的マッピング形式（Explicit Mappings）:
#       automobile => car
#       laptop => notebook, portable computer
#
# 2. IAMロールのポリシー例
#    Thesaurusアクセス用のIAMロールには以下のようなポリシーが必要です:
#
#    {
#      "Version": "2012-10-17",
#      "Statement": [
#        {
#          "Effect": "Allow",
#          "Action": [
#            "s3:GetObject"
#          ],
#          "Resource": "arn:aws:s3:::example-kendra-bucket/thesaurus/*"
#        }
#      ]
#    }
#
#    また、信頼関係ポリシーには以下を設定:
#
#    {
#      "Version": "2012-10-17",
#      "Statement": [
#        {
#          "Effect": "Allow",
#          "Principal": {
#            "Service": "kendra.amazonaws.com"
#          },
#          "Action": "sts:AssumeRole"
#        }
#      ]
#    }
#
# 3. 制限事項とベストプラクティス
#    - Thesaurusファイルは5MB未満である必要があります
#    - 更新後、効果が現れるまで最大30分かかる場合があります
#    - 1つのインデックスに複数のThesaurusを追加できます
#    - サービスクォータの制限に注意してください
#      参考: https://docs.aws.amazon.com/kendra/latest/dg/quotas.html
#
# 4. インポート
#    既存のThesaurusは以下のコマンドでインポートできます:
#
#    terraform import aws_kendra_thesaurus.example thesaurus_id/index_id
#
#---------------------------------------------------------------
