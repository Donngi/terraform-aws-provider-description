#---------------------------------------------------------------
# AWS IAM Policy
#---------------------------------------------------------------
#
# IAMポリシーをプロビジョニングするリソースです。
# IAMポリシーはAWSリソースへのアクセス許可を定義するJSONドキュメントであり、
# IAMユーザー・グループ・ロールにアタッチすることで権限を付与します。
# このリソースはカスタマー管理ポリシー（Customer Managed Policy）を作成します。
#
# AWS公式ドキュメント:
#   - IAM ポリシーの概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
#   - IAM ポリシーの作成: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_create.html
#   - IAM ポリシードキュメントのリファレンス: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
#   - IAM の識別子: https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_policy" "example" {
  #---------------------------------------------------------------
  # ポリシードキュメント設定
  #---------------------------------------------------------------

  # policy (Required)
  # 設定内容: IAMポリシーのドキュメントをJSON形式の文字列で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメントのJSON文字列
  # 注意: jsonencode() 関数または aws_iam_policy_document データソースの使用を推奨します。
  #   直接JSON文字列を記述すると、フォーマットの不整合や空白の差異によって
  #   Terraformが不必要な差分を検出する場合があります。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "*"
      },
    ]
  })

  #---------------------------------------------------------------
  # 名前設定
  #---------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: IAMポリシーの名前を指定します。
  # 設定可能な値: 英数字・プラス(+)・等号(=)・カンマ(,)・ピリオド(.)・アットマーク(@)・アンダースコア(_)・ハイフン(-)
  #   最大128文字
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefix と排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html
  name = "example-policy"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: IAMポリシー名のプレフィックスを指定します。
  #   Terraformが後ろにランダムなサフィックスを追加して一意の名前を生成します。
  # 設定可能な値: 最大96文字の文字列（name の最大128文字からサフィックス分を引いた長さ）
  # 省略時: null（名前はname引数またはTerraformによる自動生成に依存）
  # 注意: name と排他的（どちらか一方のみ指定可能）
  name_prefix = null

  #---------------------------------------------------------------
  # パス設定
  #---------------------------------------------------------------

  # path (Optional)
  # 設定内容: ポリシーを作成するIAMの階層パスを指定します。
  #   パスはポリシーの論理的なグループ分けに使用します。
  # 設定可能な値: スラッシュ(/)で始まりスラッシュ(/)で終わるパス文字列
  #   例: "/" (ルート), "/application/", "/division_abc/subdivision_xyz/"
  # 省略時: "/" (ルートパス)
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html
  path = "/"

  #---------------------------------------------------------------
  # 説明設定
  #---------------------------------------------------------------

  # description (Optional, Forces new resource)
  # 設定内容: IAMポリシーの説明文を指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明なし（空文字列）
  # 注意: 一度設定した説明は変更するとリソースが再作成されます（Forces new resource）
  description = "My example IAM policy"

  #---------------------------------------------------------------
  # 動作調整設定
  #---------------------------------------------------------------

  # delay_after_policy_creation_in_ms (Optional)
  # 設定内容: ポリシー作成後にデフォルトバージョンとして設定するまでの待機時間（ミリ秒）を指定します。
  # 設定可能な値: 正の整数（ミリ秒単位）
  # 省略時: 待機なし
  # 注意: S3のIOが非常に高い環境でポリシー作成直後の操作が失敗する場合に使用します。
  delay_after_policy_creation_in_ms = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ。キー・値ともに文字列
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-policy"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSによって付与されるポリシーのARN（arn と同じ値）
#
# - arn: AWSによって付与されるポリシーのARN
#
# - policy_id: ポリシーのID（例: ANPAIOSFODNN7EXAMPLE）
#
# - attachment_count: このポリシーがアタッチされているエンティティ
#                     （ユーザー・グループ・ロール）の数
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
