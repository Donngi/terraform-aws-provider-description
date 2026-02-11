# ================================================================================
# AWS DataSync SMB Location Resource Template
# ================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
# Resource: aws_datasync_location_smb
#
# このテンプレートは生成時点(2026-01-19)の情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_smb
#
# 注意: DataSync Agentがこのリソースを作成する前に利用可能である必要があります。
# ================================================================================

resource "aws_datasync_location_smb" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # agent_arns - (Required) DataSync Agentの ARNリスト
  # この場所に関連付けられる DataSync Agent の ARN を指定します。
  # SMB ファイルサーバーへの接続に使用される Agent を指定する必要があります。
  # Type: set(string)
  # AWS API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationSmb.html
  agent_arns = [
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-0123456789abcdef0"
  ]

  # server_hostname - (Required) SMB サーバーのホスト名または IP アドレス
  # DataSync Agent がマウントする SMB サーバーの IP アドレスまたは DNS 名を指定します。
  # DataSync Agent はこの値を使用して SMB 共有をマウントします。
  # Type: string
  # AWS API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationSmb.html
  server_hostname = "smb.example.com"

  # subdirectory - (Required) SMB サーバー上のサブディレクトリパス
  # ソースまたは宛先として操作を実行するサブディレクトリを指定します。
  # SMB サーバーによってエクスポートされている必要があります。
  # パスは "/" で始まる必要があります (例: "/exported/path")
  # Type: string
  # AWS API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationSmb.html
  subdirectory = "/exported/path"

  # user - (Required) SMB 共有にアクセスするユーザー名
  # SMB 共有をマウントでき、ファイルとフォルダーのアクセス許可を持つユーザーを指定します。
  # NTLM 認証を使用する場合に必要です (AuthenticationType が NTLM の場合)。
  # Domain 形式の場合: "DOMAIN\user" または "user@domain.com" 形式で指定可能
  # Type: string
  # 最大長: 104文字
  # AWS API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationSmb.html
  user = "Guest"

  # password - (Required) SMB 共有にアクセスするためのパスワード
  # SMB 共有をマウントでき、転送に関わるファイルとフォルダーへのアクセス許可を
  # 持つユーザーのパスワードを指定します。
  # NTLM 認証を使用する場合に必要です (AuthenticationType が NTLM の場合)。
  # Type: string (sensitive)
  # 最大長: 104文字
  # AWS API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationSmb.html
  password = "ANotGreatPassword" # 本番環境では変数や Secrets Manager を使用してください

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # domain - (Optional) Windows ドメイン名
  # SMB サーバーが属する Windows ドメインの名前を指定します。
  # NTLM 認証を使用する場合に、ドメインユーザーで認証する際に使用します。
  # Active Directory 環境で SMB サーバーを使用している場合に指定します。
  # Type: string
  # 最大長: 253文字
  # AWS API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationSmb.html
  domain = "example.com"

  # region - (Optional) リソースが管理されるリージョン
  # このリソースが管理される AWS リージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # Type: string
  # AWS Docs: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (Optional) リソースタグ
  # DataSync Location に割り当てるキー/値ペアのリソースタグです。
  # プロバイダーに default_tags 設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  # Type: map(string)
  # AWS Docs: https://docs.aws.amazon.com/datasync/latest/userguide/API_TagListEntry.html
  tags = {
    Name        = "example-smb-location"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # ================================================================================
  # Nested Blocks
  # ================================================================================

  # mount_options - (Optional) マウントオプション設定
  # DataSync が SMB サーバーにアクセスする際に使用するマウントオプションを設定します。
  # SMB プロトコルのバージョンを指定できます。
  # Max Items: 1
  mount_options {
    # version - (Optional) SMB プロトコルバージョン
    # DataSync が SMB 共有のマウントに使用する特定の SMB バージョンを指定します。
    #
    # 有効な値:
    # - "AUTOMATIC" (デフォルト): DataSync と SMB ファイルサーバーが
    #   2.1 から 3.1.1 の間で相互にサポートされる最高バージョンを自動的にネゴシエートします。
    #   推奨オプションです。
    # - "SMB3": プロトコルネゴシエーションを SMB バージョン 3.0.2 のみに制限します。
    # - "SMB2": プロトコルネゴシエーションを SMB バージョン 2.1 のみに制限します。
    # - "SMB2_0": プロトコルネゴシエーションを SMB バージョン 2.0 のみに制限します。
    # - "SMB1": プロトコルネゴシエーションを SMB バージョン 1.0 のみに制限します。
    #   (注: Amazon FSx for NetApp ONTAP ロケーション作成時は使用不可)
    #
    # Type: string
    # Default: "AUTOMATIC"
    # AWS API: https://docs.aws.amazon.com/datasync/latest/userguide/API_SmbMountOptions.html
    version = "AUTOMATIC"
  }
}

# ================================================================================
# Outputs (参考)
# ================================================================================
# このリソースは以下の属性を出力します (computed):
#
# - arn: DataSync Location の Amazon Resource Name (ARN)
#   Type: string
#
# - id: DataSync Location の ID (ARN と同じ値)
#   Type: string
#
# - uri: Location の URI (smb://server_hostname/subdirectory 形式)
#   Type: string
#
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#   (プロバイダーの default_tags から継承されたタグを含む)
#   Type: map(string)
#
# 使用例:
# output "smb_location_arn" {
#   value = aws_datasync_location_smb.example.arn
# }
# ================================================================================

# ================================================================================
# 関連リソース
# ================================================================================
# - aws_datasync_agent: DataSync Agent の登録
# - aws_datasync_task: DataSync タスクの作成
# - aws_datasync_location_s3: S3 ロケーション
# - aws_datasync_location_efs: EFS ロケーション
# - aws_datasync_location_fsx_windows_file_system: FSx Windows ファイルサーバーロケーション
# ================================================================================

# ================================================================================
# 参考資料
# ================================================================================
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_smb
#
# AWS DataSync User Guide:
# https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html
#
# AWS API Reference - CreateLocationSmb:
# https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationSmb.html
#
# AWS API Reference - SmbMountOptions:
# https://docs.aws.amazon.com/datasync/latest/userguide/API_SmbMountOptions.html
#
# DataSync SMB File Server Access:
# https://docs.aws.amazon.com/datasync/latest/userguide/create-smb-location.html
# ================================================================================
