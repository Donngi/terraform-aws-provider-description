#---------------------------------------------------------------
# Storage Gateway File System Association
#---------------------------------------------------------------
#
# Amazon FSx for Windows File Serverファイルシステムを
# FSx File Gatewayに関連付けるリソース。
# 関連付けプロセスが完了すると、Amazon FSxファイルシステム上の
# ファイル共有がゲートウェイ経由でアクセス可能になります。
#
# 注意: Amazon FSx File Gatewayは新規顧客への提供を終了しています。
# 既存の顧客は通常通りサービスを利用できます。
#
# 制約事項:
# - FSxファイルシステムとゲートウェイは同じAWSアカウント・同じリージョンである必要があります
# - 各ゲートウェイは最大5つのファイルシステムをサポートします
# - ソフトクォータはサポートされますが、ハードクォータはサポートされません
# - Microsoft DFSを使用した構成は非推奨です
#
# AWS公式ドキュメント:
#   - Attach an Amazon FSx for Windows File Server file system: https://docs.aws.amazon.com/filegateway/latest/filefsxw/attach-fsxw-filesystem.html
#   - FSx File Gateway Requirements: https://docs.aws.amazon.com/filegateway/latest/filefsxw/Requirements.html
#   - API Reference - FileSystemAssociationInfo: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_FileSystemAssociationInfo.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_file_system_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_file_system_association" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ゲートウェイのARN
  # FSx File GatewayのAmazon Resource Name
  # 関連付けを行うゲートウェイを指定します
  gateway_arn = "arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678"

  # FSxファイルシステムのARN
  # Amazon FSx for Windows File ServerのARN
  # FSx File Gatewayに関連付けるファイルシステムを指定します
  location_arn = "arn:aws:fsx:us-east-1:123456789012:file-system/fs-0123456789abcdef0"

  # ユーザー名
  # Amazon FSxファイルシステムのルート共有へのアクセス権限を持つユーザー資格情報
  # ユーザーアカウントはAmazon FSx委任管理者グループに属している必要があります
  #
  # 推奨事項:
  # - AWS Directory Serviceを使用する場合: AWS Delegated FSx Administratorsグループのメンバー
  # - セルフマネージドADを使用する場合: カスタム委任ファイルシステム管理者グループのメンバー
  # - ファイル、フォルダ、ファイルメタデータへの十分な権限を確保するため、
  #   サービスアカウントをファイルシステム管理者グループのメンバーにすることを推奨
  username = "Admin"

  # パスワード
  # ユーザー資格情報のパスワード
  # 機密情報のため、プレーンテキストでの保存は避けてください
  # AWS Secrets ManagerやSSM Parameter Storeの使用を推奨します
  password = "avoid-plaintext-passwords" # センシティブ情報

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 監査ログの保存先ARN
  # 監査ログの保存に使用されるストレージのARN（S3バケットなど）
  # ファイルシステムへのアクセスを監視する場合に指定します
  # 例: "arn:aws:s3:::my-audit-logs-bucket"
  audit_destination_arn = null

  # リージョン
  # このリソースが管理されるリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # FSxファイルシステムとゲートウェイは同じリージョンである必要があります
  region = null

  # タグ
  # リソースに割り当てるキーバリューペアのタグ
  # プロバイダーのdefault_tags設定ブロックと組み合わせて使用できます
  tags = {
    Name        = "example-fsx-file-system-association"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # すべてのタグ（プロバイダー継承含む）
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  # リソースに割り当てられたすべてのタグのマップ
  # 通常は明示的に設定する必要はありません
  tags_all = null

  # リソースID
  # Terraformリソースの識別子
  # 通常は自動生成されるため、明示的に設定する必要はありません
  id = null

  #---------------------------------------------------------------
  # ネストブロック
  #---------------------------------------------------------------

  # キャッシュ属性
  # ファイル共有またはFSxファイルシステムのキャッシュ更新情報
  cache_attributes {
    # キャッシュステイルタイムアウト（秒）
    # Time To Live（TTL）を使用してファイル共有のキャッシュを更新します
    # TTLは、最後の更新から経過した時間で、この時間が経過すると
    # ディレクトリへのアクセス時にファイルゲートウェイがS3バケットから
    # そのディレクトリの内容を最初に更新します
    #
    # 有効値: 0または300～2592000秒（5分～30日）
    # デフォルト: 0（自動更新なし）
    #
    # 推奨設定:
    # - 頻繁に変更されるデータ: 300～3600秒（5分～1時間）
    # - 比較的静的なデータ: 3600～86400秒（1時間～1日）
    # - 自動更新を無効にする場合: 0
    cache_stale_timeout_in_seconds = 0
  }

  # タイムアウト設定
  # リソースの作成、更新、削除操作のタイムアウト値
  timeouts {
    # 作成タイムアウト
    # ファイルシステム関連付けの作成操作のタイムアウト
    # デフォルト: 10分
    create = "10m"

    # 更新タイムアウト
    # ファイルシステム関連付けの更新操作のタイムアウト
    # デフォルト: 10分
    update = "10m"

    # 削除タイムアウト
    # ファイルシステム関連付けの削除操作のタイムアウト
    # デフォルト: 10分
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed）:
#
# - id
#   FSxファイルシステム関連付けのAmazon Resource Name（ARN）
#
# - arn
#   新しく作成されたファイルシステム関連付けのAmazon Resource Name（ARN）
#
# - tags_all
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
