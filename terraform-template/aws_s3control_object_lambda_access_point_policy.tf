#---------------------------------------------------------------
# AWS S3 Object Lambda Access Point Policy
#---------------------------------------------------------------
#
# S3 Object Lambda Access Point にリソースベースのポリシーを
# アタッチするためのリソースです。
# Object Lambda Access Point は、S3 から返されるデータを Lambda 関数で
# 動的に変換する機能を提供します。このリソースポリシーにより、
# Object Lambda Access Point へのアクセスをリソース、ユーザー、
# 条件に基づいて制御できます。
#
# 注意: 2025年11月7日以降、S3 Object Lambda は既存ユーザーおよび
#       特定の AWS Partner Network (APN) パートナーのみ利用可能です。
#
# AWS公式ドキュメント:
#   - Object Lambda Access Point ポリシー: https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-policies.html
#   - Object Lambda Access Point の作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-create.html
#   - Object Lambda セキュリティ: https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-security.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_object_lambda_access_point_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_object_lambda_access_point_policy" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ポリシーを関連付ける Object Lambda Access Point の名前を指定します。
  # 設定可能な値: 既存の Object Lambda Access Point の名前
  # 関連機能: S3 Object Lambda Access Point
  #   Object Lambda Access Point は、S3 標準アクセスポイント（supporting access point）と
  #   Lambda 関数を組み合わせて、GetObject 等の S3 API 呼び出し時に
  #   データを動的に変換します。例えば、PII データのマスキング、
  #   画像のリサイズ、データフォーマットの変換などが可能です。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-create.html
  name = aws_s3control_object_lambda_access_point.example.name

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: Object Lambda Access Point のリソースベースポリシー（JSON形式）を指定します。
  # 設定可能な値: 有効な JSON 形式の IAM ポリシードキュメント
  # 関連機能: Object Lambda Access Point のアクセス制御
  #   リソースベースポリシーにより、以下のアクセス制御が可能です:
  #   - 特定の IAM ユーザーやロールに対する s3-object-lambda アクションの許可
  #   - クロスアカウントでの Object Lambda Access Point へのアクセス制御
  #   - 条件キーを使った詳細なアクセス制御
  #   Object Lambda Access Point を使用するには、以下の4つのリソースに
  #   適切な権限が必要です:
  #     1. IAM アイデンティティ（ユーザーまたはロール）
  #     2. 標準アクセスポイント（supporting access point）
  #     3. Object Lambda Access Point
  #     4. Lambda 関数
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-policies.html
  # 注意: Lambda 関数の実行ロールには s3-object-lambda:WriteGetObjectResponse
  #       権限が必要です。自アカウントの Lambda 関数を使用する場合、
  #       ポリシーステートメントには特定のバージョン番号を含める必要があります
  #       （$LATEST バージョンは IAM ポリシーに追加できません）。
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "s3-object-lambda:GetObject"
      Principal = {
        AWS = data.aws_caller_identity.current.account_id
      }
      Resource = aws_s3control_object_lambda_access_point.example.arn
    }]
  })

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: Object Lambda Access Point を所有する AWS アカウント ID を指定します。
  # 設定可能な値: 有効な AWS アカウント ID（12桁の数字）
  # 省略時: Terraform AWS プロバイダーのアカウント ID を自動使用
  # 関連機能: クロスアカウントでの Object Lambda Access Point 管理
  #   異なるアカウントの Object Lambda Access Point にポリシーを設定する場合に使用します。
  # account_id = "123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWS アカウント ID と Object Lambda Access Point 名をコロン（:）で
#        区切った値（例: "123456789012:example"）
#
# - has_public_access_policy: このアクセスポイントに現在パブリックアクセスを
#                              許可するポリシーが設定されているかどうかを示す
#                              ブール値
#
#---------------------------------------------------------------
