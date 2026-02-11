# ============================================================
# AWS DataSync EFS Location - 解説付きテンプレート
# ============================================================
# 生成日: 2026-01-19
# Provider version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
# 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_efs
# ============================================================

resource "aws_datasync_location_efs" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # EFSファイルシステムのARN
  # - DataSyncが接続するEFSファイルシステムを指定
  # - 事前にEFS Mount Targetが作成されている必要がある
  # - AWS公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/create-efs-location.html
  efs_file_system_arn = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-12345678"

  # EC2設定（必須のネストブロック）
  # - DataSyncがEFSファイルシステムに接続するためのネットワーク設定
  # - EFS Mount Targetと同じVPCおよびAvailability Zoneのサブネットを指定する必要がある
  ec2_config {
    # セキュリティグループのARNリスト（必須）
    # - EFS Mount Targetに関連付けられているセキュリティグループ、
    #   またはMount Targetのセキュリティグループと通信可能なセキュリティグループを指定
    # - インバウンドルールでNFSトラフィック（ポート2049）を許可する必要がある
    security_group_arns = [
      "arn:aws:ec2:us-east-1:123456789012:security-group/sg-12345678"
    ]

    # サブネットのARN（必須）
    # - EFS Mount Targetに関連付けられているサブネットを指定
    # - DataSyncはこのサブネット内にネットワークインターフェースを作成
    # - VPCはデフォルトテナンシーである必要がある
    subnet_arn = "arn:aws:ec2:us-east-1:123456789012:subnet/subnet-12345678"
  }

  # ============================================================
  # オプションパラメータ
  # ============================================================

  # アクセスポイントのARN（オプション）
  # - DataSyncがEFSファイルシステムにアクセスする際に使用するアクセスポイントを指定
  # - EFSアクセスポイントを使用することで、特定のパスへのアクセスを制限したり、
  #   ユーザーIDやグループIDを指定したアクセス制御が可能
  # - AWS公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationEfs.html
  # access_point_arn = "arn:aws:elasticfilesystem:us-east-1:123456789012:access-point/fsap-12345678"

  # ファイルシステムアクセスロールのARN（オプション）
  # - DataSyncがEFSファイルシステムをマウントする際に使用するIAMロールを指定
  # - アクセス制限されたEFSファイルシステムにアクセスする場合に必要
  # - IAMロールには、EFSファイルシステムへのアクセスを許可するポリシーが必要
  # - AWS公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/create-efs-location.html
  # file_system_access_role_arn = "arn:aws:iam::123456789012:role/DataSyncEFSAccessRole"

  # 転送時の暗号化設定（オプション）
  # - DataSyncがEFSファイルシステムとの間でデータを転送する際にTLS暗号化を使用するかを指定
  # - 有効な値: "NONE", "TLS1_2"
  # - デフォルト: "NONE"（暗号化なし）
  # - TLS1_2を指定すると、転送中のデータがTLS 1.2で暗号化される
  # - AWS公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationEfs.html
  # in_transit_encryption = "TLS1_2"

  # サブディレクトリ（オプション）
  # - EFSファイルシステム内のマウントパスを指定
  # - ソースまたはデスティネーションとして動作する際のベースディレクトリを設定
  # - デフォルト: "/" (ルートディレクトリ)
  # - パスは "/" で始まる必要がある
  # - 例: "/data/backups", "/shared/files"
  # subdirectory = "/data"

  # リージョン（オプション）
  # - このリソースが管理されるAWSリージョンを指定
  # - デフォルト: プロバイダー設定で指定されたリージョン
  # - クロスリージョン転送を行う場合などに明示的に指定
  # - AWS公式ドキュメント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ（オプション）
  # - DataSync Locationに割り当てるキーと値のペア
  # - リソースの管理、コスト配分、アクセス制御などに使用
  # - プロバイダーの default_tags 設定ブロックが存在する場合、
  #   一致するキーを持つタグはここで定義されたものが優先される
  tags = {
    Name        = "example-datasync-efs-location"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all（オプション）
  # - プロバイダーのdefault_tagsを含む、リソースに割り当てられるすべてのタグ
  # - 通常は明示的に設定する必要はなく、プロバイダー設定とtagsの組み合わせで自動管理される
  # tags_all = {}

  # id（オプション）
  # - Terraformリソースの識別子
  # - 通常は自動的に設定されるため、明示的な指定は不要
  # - 指定した場合、DataSync LocationのARNが使用される
  # id = "arn:aws:datasync:us-east-1:123456789012:location/loc-12345678"
}

# ============================================================
# Computed Attributes（読み取り専用、テンプレートでは設定不可）
# ============================================================
# 以下の属性は、リソース作成後にAWSによって自動的に設定されます。
# terraform apply 実行後、これらの値を参照できます。
#
# - arn: DataSync LocationのAmazon Resource Name (ARN)
# - uri: DataSync LocationのURI
#
# 使用例:
# output "datasync_location_arn" {
#   value = aws_datasync_location_efs.example.arn
# }
# output "datasync_location_uri" {
#   value = aws_datasync_location_efs.example.uri
# }
# ============================================================
