#########################################################################
# Resource: aws_datasync_location_smb
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datasync_location_smb
# Overview: AWS DataSync SMB (Server Message Block) ファイルシステムロケーション
#
# DataSync タスクのソースまたは転送先として使用する SMB ファイルシステムのロケーションを定義します。
# オンプレミスや他のクラウド環境の SMB サーバーと AWS 間でデータを同期する際に使用します。
#
# 主な用途:
# - オンプレミス SMB ファイルサーバーから AWS へのデータ移行
# - Windows ファイル共有と S3/EFS 間のデータ同期
# - クロスクラウド環境でのファイル同期
#
# 注意事項:
# - DataSync エージェントが SMB サーバーにアクセス可能である必要があります
# - パスワードは Terraform state に保存されるため、適切なアクセス管理が必要です
# - SMB バージョンは自動ネゴシエーションまたは明示的に指定可能です
#
# 依存関係:
# - DataSync エージェント (aws_datasync_agent) の事前作成が必要
# - SMB サーバーへのネットワーク接続が必要
#
# 補足:
# - 作成後、このロケーションを DataSync タスクで使用できます
# - サブディレクトリパスは SMB 共有内の相対パスとして指定します
#
# NOTE: このテンプレートは AWS Provider v6.28.0 のスキーマから生成されています
#########################################################################

resource "aws_datasync_location_smb" "example" {
  #-----------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------

  # 設定内容: SMB サーバーのホスト名または IP アドレス
  # DNS 名または IPv4 アドレスで指定可能
  # 例: "smb-server.example.com", "10.0.1.100"
  server_hostname = "smb-server.example.com"

  # 設定内容: SMB 共有内のサブディレクトリパス
  # スラッシュで始まるパスで指定、共有名を含む
  # 例: "/share/data", "/backup/files"
  subdirectory = "/share/data"

  # 設定内容: SMB サーバーへのアクセスに使用するユーザー名
  # ドメインユーザーの場合は "DOMAIN\username" 形式で指定可能
  # 例: "admin", "DOMAIN\datauser"
  user = "admin"

  # 設定内容: SMB サーバーへのアクセスに使用するパスワード
  # sensitive 属性により Terraform ログに出力されません
  # AWS Secrets Manager や変数経由での指定を推奨
  password = "your-password-here"

  # 設定内容: DataSync エージェントの ARN リスト
  # SMB サーバーへアクセス可能なエージェントを1つ以上指定
  # 高可用性のため複数エージェント指定を推奨
  agent_arns = [
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-12345678",
  ]

  #-----------------------------------------------------------------------
  # 認証・接続設定
  #-----------------------------------------------------------------------

  # 設定内容: Active Directory ドメイン名
  # ドメイン認証が必要な場合に指定
  # 省略時: ワークグループモードで接続
  # 例: "CORP.EXAMPLE.COM"
  domain = "CORP.EXAMPLE.COM"

  #-----------------------------------------------------------------------
  # マウントオプション
  #-----------------------------------------------------------------------

  # SMB プロトコルのマウントオプション
  mount_options {
    # 設定内容: SMB プロトコルバージョン
    # 設定可能な値: "AUTOMATIC" (デフォルト), "SMB2", "SMB3", "SMB1", "SMB2_0"
    # 省略時: "AUTOMATIC" (サーバーと自動ネゴシエーション)
    # 推奨: セキュリティ上 "SMB3" 以上を推奨、"SMB1" は非推奨
    version = "AUTOMATIC"
  }

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースを管理する AWS リージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 例: "us-east-1", "ap-northeast-1"
  region = "us-east-1"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースに付与するタグ
  # キーと値のマップ形式で指定
  tags = {
    Name        = "datasync-smb-location"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#########################################################################
# Attributes Reference (参照可能な属性)
#########################################################################
# このリソース作成後、以下の属性を参照できます:
#
# - id                ロケーション ID (ARN と同じ)
# - arn               ロケーションの Amazon Resource Name
# - uri               SMB ロケーションの URI (smb://server/share/path 形式)
# - tags_all          適用されたタグの完全なマップ (デフォルトタグ含む)
#
# 参照方法:
#   aws_datasync_location_smb.example.arn
#   aws_datasync_location_smb.example.uri
#
# 他リソースでの利用:
#   aws_datasync_task リソースの source_location_arn または
#   destination_location_arn として指定可能
#########################################################################
