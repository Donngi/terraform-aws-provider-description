#---------------------------------------------------------------
# AWS Transfer Family - Access
#---------------------------------------------------------------
#
# AWS Transfer Familyサーバーへのアクセスをプロビジョニングするリソースです。
# Active Directoryグループに対してSFTP/FTPS/FTPサーバーへのアクセス権限を設定し、
# ホームディレクトリやIAMロールによるアクセス制御を行います。
#
# AWS公式ドキュメント:
#   - AWS Transfer Family概要: https://docs.aws.amazon.com/transfer/latest/userguide/what-is-aws-transfer-family.html
#   - ディレクトリサービス連携: https://docs.aws.amazon.com/transfer/latest/userguide/directory-services-users.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_access
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_access" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # external_id (Required)
  # 設定内容: Transfer Serverに接続されたディレクトリ内のグループのSIDを指定します。
  # 設定可能な値: Active DirectoryのSID文字列（例: "S-1-1-12-1234567890-123456789-1234567890-1234"）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  external_id = "S-1-1-12-1234567890-123456789-1234567890-1234"

  # server_id (Required)
  # 設定内容: Transfer ServerのIDを指定します。
  # 設定可能な値: Transfer ServerのID文字列（例: "s-12345678"）
  # 注意: リソース作成後の変更はできません（Forces new resource）
  server_id = "s-12345678"

  #-------------------------------------------------------------
  # アクセス制御設定
  #-------------------------------------------------------------

  # role (Optional)
  # 設定内容: ユーザーのS3バケットまたはEFSファイルシステムへのアクセスを制御する
  #          IAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 関連機能: Transfer Familyのアクセス制御
  #   このロールにより、ユーザーがアクセスできるS3バケットやEFSファイルシステムが決まります。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/requirements-roles.html
  role = "arn:aws:iam::123456789012:role/transfer-access-role"

  # policy (Optional)
  # 設定内容: ユーザーのS3バケットへのアクセスをスコープダウンするIAM JSONポリシードキュメントを指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 注意: ポリシー内で使用可能なIAM変数:
  #   - ${Transfer:UserName}: ユーザー名
  #   - ${Transfer:HomeDirectory}: ホームディレクトリ
  #   - ${Transfer:HomeBucket}: ホームバケット
  #   Terraformの補間構文と競合するため、$${Transfer:UserName} のようにエスケープが必要です。
  # 推奨: jsonencode() または aws_iam_policy_document データソースの使用を推奨します。
  #   - https://developer.hashicorp.com/terraform/language/functions/jsonencode
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Sid    = "AllowListingOfUserFolder"
  #       Effect = "Allow"
  #       Action = ["s3:ListBucket"]
  #       Resource = ["arn:aws:s3:::$${Transfer:HomeBucket}"]
  #       Condition = {
  #         StringLike = {
  #           "s3:prefix" = ["$${Transfer:HomeFolder}/*", "$${Transfer:HomeFolder}"]
  #         }
  #       }
  #     },
  #     {
  #       Sid    = "AllowReadWriteToUserFolder"
  #       Effect = "Allow"
  #       Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
  #       Resource = "arn:aws:s3:::$${Transfer:HomeBucket}/$${Transfer:HomeFolder}/*"
  #     }
  #   ]
  # })

  #-------------------------------------------------------------
  # ホームディレクトリ設定
  #-------------------------------------------------------------

  # home_directory (Optional)
  # 設定内容: ユーザーがSFTPクライアントでログインした際のランディングディレクトリを指定します。
  # 設定可能な値: "/" で始まるパス文字列。最初のパスコンポーネントがバケット名またはEFSファイルシステムIDです。
  # 例: "/example-bucket-1234/username" の場合
  #   - ホームバケット: example-bucket-1234
  #   - ホームディレクトリ: username
  home_directory = "/example-bucket/home"

  # home_directory_type (Optional)
  # 設定内容: ホームディレクトリのタイプを指定します。
  # 設定可能な値:
  #   - "PATH": 実際のS3パスまたはEFSパスをそのまま使用
  #   - "LOGICAL": 論理的なディレクトリマッピングを使用（home_directory_mappingsと併用）
  # 省略時: "PATH"
  # home_directory_type = "LOGICAL"

  #-------------------------------------------------------------
  # 論理ディレクトリマッピング設定
  #-------------------------------------------------------------

  # home_directory_mappings (Optional)
  # 設定内容: ユーザーに表示するS3パスとキーの論理的なディレクトリマッピングを指定します。
  # 注意: home_directory_type が "LOGICAL" の場合に使用します。最大50個まで指定可能です。
  # home_directory_mappings {
  #   # entry (Required)
  #   # 設定内容: ユーザーに表示する仮想パス（エントリ）を指定します。
  #   # 設定可能な値: "/" で始まるパス文字列
  #   entry = "/"
  #
  #   # target (Required)
  #   # 設定内容: エントリにマップされる実際のS3パスまたはEFSパスを指定します。
  #   # 設定可能な値: "/bucket-name/path" 形式のパス文字列
  #   target = "/example-bucket/home/username"
  # }

  #-------------------------------------------------------------
  # POSIXプロファイル設定
  #-------------------------------------------------------------

  # posix_profile (Optional)
  # 設定内容: EFSファイルシステムへのアクセスを制御するための完全なPOSIX IDを指定します。
  # 注意: EFSをバックエンドストレージとして使用する場合に必要です。最大1ブロックです。
  # 関連機能: EFSファイルシステムのPOSIXアクセス制御
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/create-user-efs.html
  # posix_profile {
  #   # gid (Required)
  #   # 設定内容: すべてのEFS操作に使用するPOSIXグループIDを指定します。
  #   # 設定可能な値: 正の整数
  #   gid = 1000
  #
  #   # uid (Required)
  #   # 設定内容: すべてのEFS操作に使用するPOSIXユーザーIDを指定します。
  #   # 設定可能な値: 正の整数
  #   uid = 1000
  #
  #   # secondary_gids (Optional)
  #   # 設定内容: すべてのEFS操作に使用するセカンダリPOSIXグループIDを指定します。
  #   # 設定可能な値: 正の整数のセット
  #   secondary_gids = [1001, 1002]
  # }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのID
#---------------------------------------------------------------
