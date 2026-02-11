#---------------------------------------------------------------
# IAM Role
#---------------------------------------------------------------
#
# IAMロールを作成します。IAMロールは、AWSサービスやユーザーが
# 一時的な権限を取得するための信頼関係とアクセス許可を定義します。
#
# AWS公式ドキュメント:
#   - IAM Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
#   - IAM Identifiers: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
#   - Permissions Boundaries: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
#   - IAM API Reference - Role: https://docs.aws.amazon.com/IAM/latest/APIReference/API_Role.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/iam_role
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_role" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) 信頼ポリシー - どのプリンシパル（サービスやユーザー）が
  # このロールを引き受ける（AssumeRole）ことができるかを定義します。
  # JSON形式で指定します。jsonencode()関数やaws_iam_policy_document
  # データソースの使用を推奨します。
  #
  # 値: JSON形式の文字列
  # 例: EC2サービスがロールを引き受ける場合
  #   assume_role_policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [{
  #       Action = "sts:AssumeRole"
  #       Effect = "Allow"
  #       Principal = {
  #         Service = "ec2.amazonaws.com"
  #       }
  #     }]
  #   })
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  #---------------------------------------------------------------
  # オプションパラメータ - 識別情報
  #---------------------------------------------------------------

  # (Optional, Computed) リソースID
  # 通常は設定不要です。Terraformによって自動的にロール名が設定されます。
  # 明示的に設定することもできますが、通常はcomputed属性として使用します。
  #
  # 値: 文字列
  # 注意: 通常はcomputed属性として使用（設定不要）
  # id = null

  # (Optional, Forces new resource) ロールのフレンドリー名
  # 省略した場合、Terraformがランダムな一意の名前を割り当てます。
  # name_prefixとは併用できません。
  #
  # 値: 1-64文字の英数字、+、=、,、.、@、-、_
  # 注意: 変更すると新しいリソースが作成されます
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
  name = "example-role"

  # (Optional, Forces new resource) 指定されたプレフィックスで始まる
  # 一意のフレンドリー名を作成します。nameとは併用できません。
  #
  # 値: 文字列
  # 注意: 変更すると新しいリソースが作成されます
  # name_prefix = "example-role-"

  # (Optional) ロールの説明文
  # ロールの目的や用途を明確にするための人間が読める説明です。
  #
  # 値: 最大1000文字の文字列
  description = "Example IAM role description"

  #---------------------------------------------------------------
  # オプションパラメータ - 権限設定
  #---------------------------------------------------------------

  # (Optional) Permissions Boundary（権限境界）として使用するポリシーのARN
  # 権限境界は、アイデンティティベースのポリシーがエンティティに付与できる
  # 最大権限を設定します（権限自体は付与しません）。
  #
  # 値: 管理ポリシーのARN（AWS管理またはカスタマー管理）
  # 形式: arn:aws:iam::123456789012:policy/PolicyName
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html
  # permissions_boundary = "arn:aws:iam::123456789012:policy/ExampleBoundary"

  # (Optional) 最大セッション期間（秒単位）
  # ロールを引き受けた際に有効なセッションの最大時間を設定します。
  # 値を指定しない場合、デフォルトで1時間（3600秒）が適用されます。
  #
  # 値: 3600秒（1時間）から43200秒（12時間）まで
  # デフォルト: 3600
  max_session_duration = 3600

  #---------------------------------------------------------------
  # オプションパラメータ - パスとタグ
  #---------------------------------------------------------------

  # (Optional) ロールへのパス
  # 組織構造やプロジェクト構造を反映したパスを設定できます。
  # パスはIAMコンソールでは作成・操作できず、API/CLI/SDKでのみ使用可能です。
  #
  # 値: スラッシュで始まり、スラッシュで終わる文字列
  # 形式: /division_abc/subdivision_xyz/
  # デフォルト: /
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
  path = "/"

  # (Optional) ロールに付与するタグ
  # キーと値のマップ形式でタグを指定します。
  # provider設定にdefault_tagsが設定されている場合、
  # ここで指定したタグは上書きされます。
  #
  # 値: キーと値の文字列マップ
  tags = {
    Environment = "production"
    Application = "example-app"
  }

  # (Optional, Computed) すべてのタグのマップ
  # 通常は設定不要です。このリソースに割り当てられたすべてのタグ
  # （providerのdefault_tagsから継承したタグを含む）が自動的に管理されます。
  # 明示的に設定することもできますが、通常は参照専用として使用します。
  #
  # 値: キーと値の文字列マップ
  # 注意: 通常はcomputed属性として使用（設定不要）
  # tags_all = {}

  #---------------------------------------------------------------
  # オプションパラメータ - ポリシー管理
  #---------------------------------------------------------------

  # (Optional) 削除前にポリシーを強制デタッチするかどうか
  # trueに設定すると、ロール削除時にアタッチされているポリシーを
  # 強制的にデタッチしてから削除します。
  # aws_iam_policy_attachmentを使用している場合は必要ですが、
  # aws_iam_role_policy_attachment（推奨）を使用している場合は不要です。
  #
  # 値: true / false
  # デフォルト: false
  force_detach_policies = false

  #---------------------------------------------------------------
  # 非推奨パラメータ
  #---------------------------------------------------------------

  # (Optional, Deprecated) インラインポリシーの排他的セット
  # このリソースでIAMロールに関連付けるインラインポリシーの排他的セットを定義します。
  # ブロックを設定しない場合、このリソースはインラインポリシーを管理しません。
  # 空のブロック（inline_policy {}）を設定すると、applyで追加された
  # すべてのインラインポリシーを削除します。
  #
  # 注意: 非推奨です。代わりにaws_iam_role_policyリソースの使用を検討してください。
  # 注意: このパラメータとaws_iam_role_policy等の他のポリシー管理方法を
  #       併用するとリソースサイクリングやエラーが発生します。
  #
  # inline_policy {
  #   # (Optional) インラインポリシーの名前
  #   name = "my_inline_policy"
  #
  #   # (Optional) JSON形式のポリシードキュメント
  #   # jsonencode()やaws_iam_policy_documentデータソースの使用を推奨
  #   policy = jsonencode({
  #     Version = "2012-10-17"
  #     Statement = [
  #       {
  #         Action   = ["ec2:Describe*"]
  #         Effect   = "Allow"
  #         Resource = "*"
  #       },
  #     ]
  #   })
  # }

  # (Optional, Deprecated) アタッチするIAM管理ポリシーARNの排他的セット
  # この属性が設定されていない場合、Terraformはポリシーアタッチメントを無視します。
  # 設定された場合、Terraformはロールの管理ポリシーアタッチメントをこのセットに
  # 合わせて調整します。空のセット（managed_policy_arns = []）を設定すると、
  # すべての管理ポリシーアタッチメントが削除されます。
  #
  # 注意: 非推奨です。代わりにaws_iam_role_policy_attachmentリソースの
  #       使用を検討してください。
  # 注意: このパラメータとaws_iam_policy_attachment等の他のポリシー管理方法を
  #       併用するとリソースサイクリングやエラーが発生します。
  #
  # managed_policy_arns = [
  #   "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  # ]
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（設定不可）:
#
# - arn          : ロールを特定するAmazon Resource Name (ARN)
#                  形式: arn:aws:iam::123456789012:role/role-name
#
# - create_date  : IAMロールの作成日時（RFC3339形式）
#
# - id           : ロールの名前
#
# - name         : ロールの名前（name属性を設定した場合と同じ値）
#
# - tags_all     : リソースに割り当てられたタグのマップ。
#                  providerのdefault_tagsから継承したタグを含む
#
# - unique_id    : ロールを識別する安定した一意の文字列
#                  形式: AIDAI****** (Iで始まる一意のID)
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 他のリソースからこのロールを参照する場合:
#
# resource "aws_iam_role_policy_attachment" "example" {
#   role       = aws_iam_role.example.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }
#
# output "role_arn" {
#   value = aws_iam_role.example.arn
# }
#---------------------------------------------------------------
