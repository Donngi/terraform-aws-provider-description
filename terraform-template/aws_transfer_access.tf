#---------------------------------------------------------------
# AWS Transfer Family Access
#---------------------------------------------------------------
#
# AWS Transfer Familyサーバーに対するアクセス権限を管理するリソースです。
# SFTPサーバーをサービスプロバイダーとしてIDプロバイダーに統合している場合に、
# ディレクトリグループやユーザーがTransfer Familyサーバーにアクセスできるよう
# 制御します。
#
# AWS公式ドキュメント:
#   - Transfer Family Accessの管理: https://docs.aws.amazon.com/transfer/latest/userguide/access-control-aws-managed.html
#   - Transfer Familyの概要: https://docs.aws.amazon.com/transfer/latest/userguide/what-is-aws-transfer-family.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_access
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_access" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # server_id (Required)
  # 設定内容: アクセスを関連付けるTransfer FamilyサーバーのIDを指定します。
  # 設定可能な値: Transfer ServerのID（例: s-12345678abcdefgh）
  # 関連機能: AWS Transfer Family サーバー
  #   このリソースはAWS Directory Serviceを使用するサーバーに対して使用します。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/create-server.html
  server_id = "s-12345678abcdefgh"

  # external_id (Required)
  # 設定内容: SFTPサーバーにアクセスできるSIDを指定します。
  # 設定可能な値: Active DirectoryグループのセキュリティID（SID）
  #   例: "S-1-5-21-1234567890-123456789-1234567890-1234"
  # 関連機能: AWS Directory Service 統合
  #   サーバーがAWS Directory Serviceを使用している場合に、
  #   アクセスを許可するディレクトリグループのSIDを指定します。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/access-control-aws-managed.html
  external_id = "S-1-5-21-1234567890-123456789-1234567890-1234"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # アクセス権限設定
  #-------------------------------------------------------------

  # role (Optional)
  # 設定内容: このアクセス設定のAmazon S3バケットまたはEFSファイルシステムへの
  #           アクセスを制御するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 省略時: アクセス設定にIAMロールが付与されません
  # 関連機能: Transfer Family IAMロール
  #   このロールは、ユーザーがアクセスできるS3バケットやEFSファイルシステムを定義します。
  #   Transfer Familyサービスからの AssumeRole を許可する信頼ポリシーが必要です。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/requirements-roles.html
  role = "arn:aws:iam::123456789012:role/transfer-access-role"

  # policy (Optional)
  # 設定内容: このアクセス設定のAmazon S3バケットの一部へのアクセスを制限する
  #           IAM JSONポリシードキュメントを指定します。
  # 設定可能な値: 有効なIAM JSONポリシー文字列
  # 省略時: roleで指定されたIAMロールのポリシーのみが適用されます
  # 関連機能: Transfer Family セッションポリシー
  #   このポリシーは、ユーザーがバケットをナビゲートするときにオンザフライで評価されます。
  #   IAM変数 ${Transfer:UserName}、${Transfer:HomeDirectory}、${Transfer:HomeBucket} を使用可能。
  #   Terraformの補間構文と一致するため、エスケープが必要（例: $${Transfer:UserName}）。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/users-policies.html
  # 注意: jsonencode() または aws_iam_policy_document データソースの使用を推奨します。
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowListingOfUserFolder"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::example-bucket-1234"
        ]
        Condition = {
          StringLike = {
            "s3:prefix" = [
              "$${Transfer:UserName}/*",
              "$${Transfer:UserName}"
            ]
          }
        }
      },
      {
        Sid    = "HomeDirObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::example-bucket-1234/$${Transfer:UserName}/*"
        ]
      }
    ]
  })

  #-------------------------------------------------------------
  # ホームディレクトリ設定
  #-------------------------------------------------------------

  # home_directory (Optional)
  # 設定内容: このアクセス設定のユーザーがSFTPクライアントを使用してログインするときの
  #           ランディングディレクトリ（フォルダ）を指定します。
  # 設定可能な値: `/` で始まるパス
  #   - PATH モードの場合: `/バケット名/プレフィックス` のような物理パス
  #   - LOGICAL モードの場合: ホームディレクトリマッピングのEntryに対応する仮想パス
  # 省略時: home_directory_type が PATH の場合は "/" がデフォルト
  # 関連機能: Transfer Family ホームディレクトリ
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/users-policies.html
  home_directory = "/example-bucket-1234"

  # home_directory_type (Optional)
  # 設定内容: ユーザーのホームディレクトリにマッピングするランディングディレクトリの
  #           タイプを指定します。
  # 設定可能な値:
  #   - "PATH": 物理的なS3バケットパスまたはEFSファイルシステムパスを使用
  #   - "LOGICAL": 論理ディレクトリマッピングを使用して仮想ディレクトリ構造を定義
  # 省略時: "PATH" がデフォルト
  # 関連機能: Transfer Family 論理ディレクトリマッピング
  #   LOGICALモードでは、実際のS3パスを仮想ディレクトリ構造として表示できます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
  home_directory_type = "LOGICAL"

  #-------------------------------------------------------------
  # ホームディレクトリマッピング設定
  #-------------------------------------------------------------

  # home_directory_mappings (Optional)
  # 設定内容: ユーザーに表示するS3パスとキー、およびそれらを表示する方法を指定する
  #           論理ディレクトリマッピングを定義します（最大50件）。
  # 設定可能な値: entry と target のペアを含むブロックのリスト
  # 省略時: home_directory_type が "PATH" の場合は不要
  # 関連機能: Transfer Family 論理ディレクトリマッピング
  #   仮想ディレクトリ構造を作成し、複数のS3バケットやプレフィックスを
  #   単一の論理ディレクトリツリーとしてユーザーに提示できます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
  # 注意: home_directory_type が "LOGICAL" の場合に使用します。
  home_directory_mappings {
    # entry (Required)
    # 設定内容: ユーザーに表示する仮想ディレクトリパスを指定します。
    # 設定可能な値: `/` で始まる仮想パス（例: "/", "/documents"）
    # 関連機能: 論理ディレクトリエントリ
    #   これはユーザーがSFTPクライアントで見るパスです。
    #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
    entry = "/"

    # target (Required)
    # 設定内容: エントリに対応する実際のS3バケットパスまたはEFSファイルシステムパスを指定します。
    # 設定可能な値: `/バケット名/プレフィックス` の形式のパス
    #   IAM変数 ${Transfer:UserName} 等を使用可能
    #   （Terraformではエスケープが必要: $${Transfer:UserName}）
    # 関連機能: 論理ディレクトリターゲット
    #   これは実際のS3またはEFSの物理パスです。
    #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
    target = "/example-bucket-1234/$${Transfer:UserName}"
  }

  #-------------------------------------------------------------
  # POSIX プロファイル設定
  #-------------------------------------------------------------

  # posix_profile (Optional)
  # 設定内容: Amazon EFSファイルシステムへのアクセスを制御する
  #           完全なPOSIXアイデンティティ（ユーザーID、グループID、セカンダリグループID）を指定します。
  # 設定可能な値: gid、uid、および任意の secondary_gids を含むブロック
  # 省略時: EFSを使用しない場合は不要
  # 関連機能: Transfer Family POSIX プロファイル
  #   EFSファイルシステムを使用する場合、ユーザーのファイルアクセス権限を制御するために
  #   POSIXアイデンティティを指定する必要があります。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/users-efs.html
  # 注意: Amazon EFSストレージを使用する場合にのみ必要です。
  posix_profile {
    # gid (Required)
    # 設定内容: このアクセス設定のすべてのEFS操作で使用されるPOSIXグループIDを指定します。
    # 設定可能な値: 0-4294967295 の整数値
    # 関連機能: POSIX グループID
    #   UNIXファイルシステムのグループ所有権を決定します。
    gid = 1000

    # uid (Required)
    # 設定内容: このアクセス設定のすべてのEFS操作で使用されるPOSIXユーザーIDを指定します。
    # 設定可能な値: 0-4294967295 の整数値
    # 関連機能: POSIX ユーザーID
    #   UNIXファイルシステムのユーザー所有権を決定します。
    uid = 1000

    # secondary_gids (Optional)
    # 設定内容: このアクセス設定のすべてのEFS操作で使用されるセカンダリPOSIXグループIDを指定します。
    # 設定可能な値: 0-4294967295 の整数値のセット（最大16個）
    # 省略時: セカンダリグループなし
    # 関連機能: POSIX セカンダリグループ
    #   複数のグループに対するアクセス権限を付与できます。
    secondary_gids = [1001, 1002]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サーバーIDと外部IDで構成される識別子
#       （形式: server_id/external_id）
#---------------------------------------------------------------
