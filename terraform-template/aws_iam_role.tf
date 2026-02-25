#---------------------------------------------------------------
# AWS IAM Role
#---------------------------------------------------------------
#
# AWS IAM (Identity and Access Management) ロールをプロビジョニングするリソースです。
# IAMロールは、特定の権限を持つAWSアイデンティティであり、信頼されたエンティティ
#（AWSサービス、ユーザー、アカウント、フェデレーテッドユーザーなど）によって
# 引き受けられます。ロールは、一時的な認証情報を必要とするユースケースに最適です。
#
# 主なユースケース:
#   - EC2インスタンスプロファイルとして使用し、EC2からAWSサービスにアクセス
#   - Lambda関数の実行ロールとして使用
#   - クロスアカウントアクセスを許可
#   - フェデレーテッドIDプロバイダー（SAML、OIDC）からのアクセス許可
#   - AWS ECSタスクロールとして使用
#
# 重要な注意事項:
#   - inline_policy ブロックおよび managed_policy_arns は非推奨（deprecated）です。
#     代わりに aws_iam_role_policy / aws_iam_role_policy_attachment を使用してください。
#   - aws_iam_role_policies_exclusive / aws_iam_role_policy_attachments_exclusive と
#     組み合わせることで、ポリシーの排他的管理が可能です。
#
# AWS公式ドキュメント:
#   - IAM ロール概要: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
#   - IAM ロールの作成: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create.html
#   - 信頼ポリシー: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html
#   - IAM Best Practices: https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role" "example" {
  #---------------------------------------------------------------
  # 信頼ポリシー設定
  #---------------------------------------------------------------

  # assume_role_policy (Required)
  # 設定内容: このロールを引き受けることができるエンティティを定義する信頼ポリシー（JSON形式）を指定します。
  # 設定可能な値: IAMポリシーJSON文字列。jsonencode() 関数または data "aws_iam_policy_document" の使用を推奨
  # 用途: ロールを引き受けられるプリンシパル（AWSサービス、アカウント、フェデレーテッドユーザー等）を制御します
  #
  # 主なプリンシパルの種類:
  #   - AWSサービス: "Service": "ec2.amazonaws.com" （EC2インスタンス）
  #   - AWSサービス: "Service": "lambda.amazonaws.com" （Lambda関数）
  #   - AWSアカウント: "AWS": "arn:aws:iam::123456789012:root"
  #   - 特定のIAMユーザー: "AWS": "arn:aws:iam::123456789012:user/username"
  #   - フェデレーション: "Federated": "cognito-identity.amazonaws.com"
  #
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name (Optional)
  # 設定内容: IAMロールの名前を指定します。name と name_prefix は同時に指定できません。
  # 設定可能な値: 英数字および以下の記号: +=,.@-_
  # 省略時: name_prefix が未指定の場合、Terraformが一意の名前を自動生成します
  #
  # 制約:
  #   - 最大長: 64文字
  #   - AWSアカウント内でユニークである必要があります
  #   - 変更すると既存のロールが削除・再作成されます（forceReplace相当）
  name = "example-role"

  # name_prefix (Optional)
  # 設定内容: IAMロール名のプレフィックスを指定します。Terraformが一意のサフィックスを付与します。
  # 設定可能な値: 英数字および以下の記号: +=,.@-_。最大38文字（残り26文字がサフィックスに使用される）
  # 省略時: name を使用。name も未指定の場合は完全にランダムな名前が生成されます
  # 用途: 複数のロールを作成する場合や、名前の衝突を避けたい場合に便利です
  # 注意: name と同時に指定できません。どちらか一方のみ使用してください。
  name_prefix = null

  # description (Optional)
  # 設定内容: IAMロールの説明文を指定します。
  # 設定可能な値: 最大1000文字の文字列
  # 省略時: 説明なし
  description = "Example IAM role for EC2 instances"

  # path (Optional)
  # 設定内容: IAMロールを作成するパスを指定します。IAMのパス機能により階層構造で整理できます。
  # 設定可能な値: スラッシュ(/)で始まりスラッシュで終わる文字列。例: "/", "/system/", "/division/team/"
  # 省略時: "/" (ルートパス)
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names
  path = "/"

  #---------------------------------------------------------------
  # セッション・権限設定
  #---------------------------------------------------------------

  # max_session_duration (Optional)
  # 設定内容: このロールを使用してリクエストできる最大セッション時間（秒）を指定します。
  # 設定可能な値: 3600（1時間）〜 43200（12時間）の整数
  # 省略時: 3600（1時間）
  #
  # 注意:
  #   - ロールをEC2インスタンスプロファイルやLambda実行ロールとして使用する場合、
  #     この設定はAWSサービスが管理するセッションには適用されません
  #   - AWS CLIや SDK でロールを引き受ける場合（sts:AssumeRole）に適用されます
  max_session_duration = 3600

  # permissions_boundary (Optional)
  # 設定内容: ロールのアクセス許可の境界として使用するIAMポリシーのARNを指定します。
  # 設定可能な値: IAMポリシーのARN文字列
  # 省略時: アクセス許可の境界なし
  #
  # 用途: 権限の委任を制御する際に使用します。ロールが持てる最大権限を制限します。
  #   委任されたロールは、権限の境界を超えたアクセスを行うことができません。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
  permissions_boundary = null # "arn:aws:iam::123456789012:policy/ExampleBoundary"

  # force_detach_policies (Optional)
  # 設定内容: ロール削除時に、アタッチされているポリシーを強制的にデタッチするかどうかを指定します。
  # 設定可能な値: true / false
  # 省略時: false
  #
  # 注意:
  #   - false の場合、ポリシーがアタッチされているロールを削除しようとするとエラーが発生します
  #   - true に設定するとロール削除時の安全性が下がる可能性があります
  #   - CI/CD 環境や一時的なリソース管理では true が便利です
  force_detach_policies = false

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグをキーと値のペアで指定します。
  # 設定可能な値: 最大50個のキーと値のペア。キーは最大128文字、値は最大256文字
  # 省略時: タグなし
  tags = {
    Name        = "example-role"
    Environment = "development"
    ManagedBy   = "Terraform"
  }

  #---------------------------------------------------------------
  # マネージドポリシー設定（非推奨）
  #---------------------------------------------------------------

  # managed_policy_arns (Optional) - 非推奨（deprecated）
  # 設定内容: ロールにアタッチするマネージドポリシーのARNセットを指定します。
  # 設定可能な値: IAMポリシーARNの文字列セット
  # 省略時: マネージドポリシーなし（Terraformによって管理されない）
  #
  # 警告: このフィールドは非推奨です。代わりに以下を使用してください:
  #   - aws_iam_role_policy_attachment: 個別のマネージドポリシーアタッチメント管理
  #   - aws_iam_role_policy_attachments_exclusive: マネージドポリシーの排他的管理
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  managed_policy_arns = null

  #---------------------------------------------------------------
  # インラインポリシー設定（非推奨）
  #---------------------------------------------------------------

  # inline_policy ブロック (Optional) - 非推奨（deprecated）
  # 設定内容: ロールに直接埋め込むインラインポリシーを指定します。
  # 設定可能な値: name（ポリシー名）と policy（JSON形式のポリシードキュメント）を持つブロック
  # 省略時: インラインポリシーなし
  #
  # 警告: このブロックは非推奨です。以下のリソースを代わりに使用してください:
  #   - aws_iam_role_policy: 個別のインラインポリシー管理
  #   - aws_iam_role_policies_exclusive: インラインポリシーの排他的管理
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html
  #
  # inline_policy {
  #   name = "example-inline-policy"
  #   policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [
  #       {
  #         Effect   = "Allow"
  #         Action   = ["s3:GetObject"]
  #         Resource = "*"
  #       }
  #     ]
  #   })
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn
#     AWSが割り当てたロールのARN
#     例: arn:aws:iam::123456789012:role/example-role
#
# - create_date
#     ロールが作成された日時（ISO 8601形式）
#     例: 2026-02-17T00:00:00Z
#
# - id
#     ロール名（name と同一）
#
# - name
#     IAMロールの名前
#
# - unique_id
#     AWSが割り当てたロールの一意のID
#     例: AROAIOSFODNN7EXAMPLE
#
# - tags_all
#     プロバイダーのデフォルトタグを含む全タグのマップ
#
