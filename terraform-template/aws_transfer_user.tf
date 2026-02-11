#---------------------------------------------------------------
# AWS Transfer Family User
#---------------------------------------------------------------
#
# AWS Transfer Familyサーバーにアクセスするユーザーをプロビジョニングするリソースです。
# SFTP、FTPS、FTPプロトコルを使用してAmazon S3またはAmazon EFSにアクセスする
# ユーザーの認証情報、ホームディレクトリ、アクセス権限を定義します。
#
# AWS公式ドキュメント:
#   - Transfer Familyユーザー管理: https://docs.aws.amazon.com/transfer/latest/userguide/create-user.html
#   - Transfer Familyの概要: https://docs.aws.amazon.com/transfer/latest/userguide/what-is-aws-transfer-family.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_user
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_user" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # server_id (Required)
  # 設定内容: ユーザーを関連付けるTransfer FamilyサーバーのIDを指定します。
  # 設定可能な値: Transfer ServerのID（例: s-12345678）
  # 関連機能: AWS Transfer Family サーバー
  #   ユーザーは特定のTransfer Familyサーバーに紐付けられます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/create-server.html
  server_id = "s-12345678abcdefgh"

  # user_name (Required)
  # 設定内容: SFTPクライアントを使用してサーバーにログインするときに使用する名前を指定します。
  # 設定可能な値: 3-100文字の文字列（英数字、ハイフン、アンダースコア）
  # 注意: 1または2文字のユーザー名、および "root" ユーザー名は、
  #       悪意のあるログイン試行を防ぐためブロックされます。
  # 関連機能: AWS Transfer Family ユーザー認証
  #   ユーザー名はSSH公開鍵またはパスワードベースの認証で使用されます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/create-user.html
  user_name = "tftestuser"

  # role (Required)
  # 設定内容: ユーザーのAmazon S3バケットまたはEFSファイルシステムへのアクセスを制御する
  #           IAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN
  # 関連機能: Transfer Family IAMロール
  #   このロールは、ユーザーがアクセスできるS3バケットやEFSファイルシステムを定義します。
  #   Transfer Family サービスからAssumeRoleできるよう信頼ポリシーを設定する必要があります。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/requirements-roles.html
  role = "arn:aws:iam::123456789012:role/transfer-user-role"

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
  # ホームディレクトリ設定
  #-------------------------------------------------------------

  # home_directory (Optional)
  # 設定内容: ユーザーがSFTPクライアントを使用してログインするときの
  #           ランディングディレクトリ（フォルダ）を指定します。
  # 設定可能な値: `/` で始まるパス
  #   - PATH モードの場合: `/example-bucket-1234/username` のような物理パス
  #   - LOGICAL モードの場合: ホームディレクトリマッピングのEntryに対応する仮想パス
  # 省略時: home_directory_typeがPATHの場合は "/" がデフォルト、
  #         LOGICALの場合は "/" がデフォルトでマッピングが必要
  # 関連機能: Transfer Family ホームディレクトリ
  #   パスの最初の項目はホームバケット（ポリシー内で ${Transfer:HomeBucket} としてアクセス可能）、
  #   残りはホームディレクトリ（${Transfer:HomeDirectory} としてアクセス可能）。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/users-policies.html
  # 注意: LOGICAL モードの場合、home_directory_mappings 内の Entry 値のいずれかと
  #       一致する必要があります。
  home_directory = "/example-bucket-1234/tftestuser"

  # home_directory_type (Optional)
  # 設定内容: ユーザーのホームディレクトリにマッピングするランディングディレクトリの
  #           タイプを指定します。
  # 設定可能な値:
  #   - "PATH": 物理的なS3バケットパスまたはEFSファイルシステムパスを使用
  #   - "LOGICAL": 論理ディレクトリマッピングを使用して仮想ディレクトリ構造を定義
  # 省略時: "PATH" がデフォルト
  # 関連機能: Transfer Family 論理ディレクトリマッピング
  #   LOGICALモードでは、実際のS3パスを仮想ディレクトリ構造として表示できます。
  #   これにより、ユーザーに対して一貫したディレクトリ構造を提供できます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
  home_directory_type = "LOGICAL"

  #-------------------------------------------------------------
  # アクセスポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: ユーザーのアクセスをAmazon S3バケットの一部に制限するIAM JSONポリシードキュメントを指定します。
  # 設定可能な値: 有効なIAM JSONポリシー文字列
  # 省略時: roleで指定されたIAMロールのポリシーのみが適用されます
  # 関連機能: Transfer Family セッションポリシー
  #   このポリシーは、ユーザーがバケットをナビゲートするときにオンザフライで評価されます。
  #   IAM変数 ${Transfer:UserName}、${Transfer:HomeDirectory}、${Transfer:HomeBucket} を使用可能。
  #   Terraformの補間構文と一致するため、エスケープが必要（例: $${Transfer:UserName}）。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/users-policies.html
  # 注意: jsonencode() または aws_iam_policy_document データソースの使用を推奨します。
  #       これにより、JSON形式の不整合や空白の問題を回避できます。
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
              "tftestuser/*",
              "tftestuser"
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
          "arn:aws:s3:::example-bucket-1234/tftestuser/*"
        ]
      }
    ]
  })

  #-------------------------------------------------------------
  # ホームディレクトリマッピング設定
  #-------------------------------------------------------------

  # home_directory_mappings (Optional)
  # 設定内容: ユーザーに表示するS3パスとキー、およびそれらを表示する方法を指定する
  #           論理ディレクトリマッピングを定義します。
  # 設定可能な値: entry と target のペアを含むブロックのリスト
  # 省略時: home_directory_type が "PATH" の場合は不要
  # 関連機能: Transfer Family 論理ディレクトリマッピング
  #   仮想ディレクトリ構造を作成し、複数のS3バケットやプレフィックスを
  #   単一の論理ディレクトリツリーとしてユーザーに提示できます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
  # 注意: home_directory_type が "LOGICAL" の場合に使用します。
  #       "Restricted" オプションは以下のマッピングで実現できます:
  #       entry = "/", target = "/${bucket_name}/$${Transfer:UserName}"
  home_directory_mappings {
    # entry (Required)
    # 設定内容: ユーザーに表示する仮想ディレクトリパスを指定します。
    # 設定可能な値: `/` で始まる仮想パス（例: "/", "/documents", "/shared"）
    # 関連機能: 論理ディレクトリエントリ
    #   これはユーザーがSFTPクライアントで見るパスです。
    #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
    entry = "/test.pdf"

    # target (Required)
    # 設定内容: エントリに対応する実際のS3バケットパスまたはEFSファイルシステムパスを指定します。
    # 設定可能な値: `/バケット名/プレフィックス` の形式のパス
    #   IAM変数 ${Transfer:UserName}、${Transfer:HomeDirectory}、${Transfer:HomeBucket} を使用可能
    #   （Terraformではエスケープが必要: $${Transfer:UserName}）
    # 関連機能: 論理ディレクトリターゲット
    #   これは実際のS3またはEFSの物理パスです。
    #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
    target = "/bucket3/test-path/tftestuser.pdf"
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
  #       S3ストレージの場合は使用しません。
  posix_profile {
    # gid (Required)
    # 設定内容: このユーザーによるすべてのEFS操作で使用されるPOSIXグループIDを指定します。
    # 設定可能な値: 0-4294967295 の整数値
    # 関連機能: POSIX グループID
    #   UNIXファイルシステムのグループ所有権を決定します。
    #   EFSファイルおよびディレクトリの権限チェックに使用されます。
    gid = 1000

    # uid (Required)
    # 設定内容: このユーザーによるすべてのEFS操作で使用されるPOSIXユーザーIDを指定します。
    # 設定可能な値: 0-4294967295 の整数値
    # 関連機能: POSIX ユーザーID
    #   UNIXファイルシステムのユーザー所有権を決定します。
    #   EFSファイルおよびディレクトリの権限チェックに使用されます。
    uid = 1000

    # secondary_gids (Optional)
    # 設定内容: このユーザーによるすべてのEFS操作で使用されるセカンダリPOSIXグループIDを指定します。
    # 設定可能な値: 0-4294967295 の整数値のセット（最大16個）
    # 省略時: セカンダリグループなし
    # 関連機能: POSIX セカンダリグループ
    #   複数のグループに対するアクセス権限をユーザーに付与できます。
    #   EFSファイルおよびディレクトリの権限チェックに使用されます。
    secondary_gids = [1001, 1002]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/tagging.html
  tags = {
    Name        = "tftestuser"
    Environment = "production"
    Application = "file-transfer"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を指定します。
  # 設定可能な値: delete タイムアウト期間を含むブロック
  # 省略時: デフォルトのタイムアウト値を使用
  timeouts {
    # delete (Optional)
    # 設定内容: リソースの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Transfer UserのAmazon Resource Name (ARN)
#
# - id: サーバーID、ユーザー名で構成される識別子（形式: s-12345678/username）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
