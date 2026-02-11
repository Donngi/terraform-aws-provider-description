# ================================================================================
# Terraform AWS Resource Template: aws_datasync_location_nfs
# ================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様については公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs
# ================================================================================
#
# AWS DataSync NFS Location
#
# AWS DataSyncでNFSファイルサーバーとの間でデータ転送を行うためのロケーションを管理します。
# このリソースを使用することで、オンプレミスまたはクラウド上のNFSサーバーとAWSストレージサービス
# （Amazon S3、Amazon EFS、Amazon FSx等）との間でデータを転送できます。
#
# 重要な注意事項:
# - DataSync Agentが事前に利用可能である必要があります
# - NFSサーバーのエクスポートパスは、Kerberos認証なしでアクセス可能である必要があります
# - エージェントと同じネットワーク構成の任意のコンピューターでマウント可能である必要があります
#
# AWS公式ドキュメント:
# - CreateLocationNfs API: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationNfs.html
# - NFS location configuration: https://docs.aws.amazon.com/datasync/latest/userguide/create-nfs-location.html
# - NfsMountOptions: https://docs.aws.amazon.com/datasync/latest/userguide/API_NfsMountOptions.html
# ================================================================================

resource "aws_datasync_location_nfs" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # server_hostname - NFSサーバーのホスト名またはIPアドレス
  #
  # NFSサーバーのIPアドレスまたはDNS名を指定します。
  # DataSync Agentはこの情報を使用してNFSサーバーをマウントします。
  #
  # 例: "nfs.example.com", "192.168.1.100"
  #
  # Type: string (required)
  # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#server_hostname
  server_hostname = "nfs.example.com"

  # subdirectory - マウントするサブディレクトリパス
  #
  # ソースまたは宛先として操作を実行するサブディレクトリを指定します。
  # NFSサーバーによってエクスポートされている必要があります。
  #
  # パーミッション要件:
  # - ソースロケーション: DataSyncは読み取りアクセスのみを必要とします
  #   設定例: export-path datasync-agent-ip-address (ro,no_root_squash)
  # - 宛先ロケーション: DataSyncはメタデータの書き込みと設定のためにrootアクセスを必要とします
  #   設定例: export-path datasync-agent-ip-address (rw,no_root_squash)
  #
  # 例: "/exported/path", "/data/transfer"
  #
  # Type: string (required)
  # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#subdirectory
  # AWS Docs: https://docs.aws.amazon.com/datasync/latest/userguide/create-nfs-location.html
  subdirectory = "/exported/path"

  # ================================================================================
  # オプションパラメータ
  # ================================================================================

  # id - リソースID（通常は自動生成されるため指定不要）
  #
  # DataSync LocationのAmazon Resource Name (ARN)。
  # 通常は自動的に生成されるため、明示的に指定する必要はありません。
  #
  # Type: string (optional, computed)
  # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#id
  # id = "arn:aws:datasync:us-east-1:123456789012:location/loc-1234567890abcdef0"

  # region - リソースを管理するAWSリージョン
  #
  # このリソースが管理されるリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 例: "us-east-1", "ap-northeast-1"
  #
  # Type: string (optional, computed)
  # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#region
  # AWS Docs: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - リソースタグ
  #
  # DataSync Locationに割り当てるリソースタグのキーバリューペア。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、一致するキーを持つタグは
  # プロバイダーレベルで定義されたものを上書きします。
  #
  # 例:
  # tags = {
  #   Environment = "production"
  #   Project     = "data-migration"
  #   ManagedBy   = "terraform"
  # }
  #
  # Type: map(string) (optional)
  # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#tags
  tags = {
    Name        = "example-nfs-location"
    Environment = "development"
  }

  # tags_all - すべてのタグ（プロバイダーのdefault_tagsを含む）
  #
  # リソースに割り当てられたすべてのタグのマップ。
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます。
  # 通常は自動的に管理されるため、明示的に指定する必要はありません。
  #
  # Type: map(string) (optional, computed)
  # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#tags_all
  # tags_all = {
  #   Environment = "production"
  # }

  # ================================================================================
  # ネストブロック
  # ================================================================================

  # mount_options - NFSマウントオプション
  #
  # DataSyncがNFSサーバーにアクセスする際に使用するマウントオプションを含む設定ブロック。
  # NFSプロトコルを使用してロケーションにアクセスする方法を決定します。
  #
  # AWS Docs: https://docs.aws.amazon.com/datasync/latest/userguide/API_NfsMountOptions.html
  mount_options {
    # version - NFSプロトコルバージョン
    #
    # DataSyncがNFS共有をマウントする際に使用する特定のNFSバージョンを指定します。
    #
    # 有効な値:
    # - AUTOMATIC (デフォルト): DataSyncが自動的にNFSバージョンを選択（通常はNFS 4.1）
    # - NFS3: ステートレスなプロトコルバージョン
    # - NFS4_0: ステートフルでファイアウォールフレンドリーなプロトコルバージョン
    # - NFS4_1: 追加機能を備えたステートフルなプロトコルバージョン
    #
    # 注意:
    # - DataSyncは現在、Amazon FSx for NetApp ONTAPロケーションではNFSバージョン3のみをサポート
    # - デフォルトではNFSバージョン4.1、4.0、3.xをサポート
    #
    # 例: "AUTOMATIC", "NFS3", "NFS4_0", "NFS4_1"
    #
    # Type: string (optional)
    # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#version
    # AWS Docs: https://docs.aws.amazon.com/datasync/latest/userguide/API_NfsMountOptions.html
    version = "AUTOMATIC"
  }

  # on_prem_config - オンプレミス設定（必須ブロック）
  #
  # NFSファイルシステムに接続するための情報を含む設定ブロック。
  # DataSync AgentのARNを指定して、NFSサーバーへの接続を確立します。
  #
  # 最小項目数: 1
  # 最大項目数: 1
  #
  # AWS Docs: https://docs.aws.amazon.com/datasync/latest/userguide/create-nfs-location.html
  on_prem_config {
    # agent_arns - DataSync AgentのARNリスト
    #
    # NFSサーバーへの接続に使用されるDataSync AgentのAmazon Resource Name (ARN)のリスト。
    # 事前にDataSync Agentをデプロイして利用可能にしておく必要があります。
    #
    # ネットワーク要件:
    # - AgentがNFSサーバーに接続できるようにトラフィックを許可する必要があります
    # - サービスエンドポイント接続のための適切なポート構成が必要
    #
    # 例: ["arn:aws:datasync:us-east-1:123456789012:agent/agent-1234567890abcdef0"]
    #
    # Type: set(string) (required)
    # Terraform Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_nfs#agent_arns
    agent_arns = [aws_datasync_agent.example.arn]
  }
}

# ================================================================================
# Computed Attributes (読み取り専用)
# ================================================================================
#
# 以下の属性はTerraformによって自動的に計算され、出力として利用できます。
# これらはリソース作成後に参照可能ですが、入力パラメータとしては指定できません。
#
# - arn: DataSync LocationのAmazon Resource Name (ARN)
#   例: aws_datasync_location_nfs.example.arn
#   Type: string
#
# - uri: NFS LocationのURI
#   例: aws_datasync_location_nfs.example.uri
#   Type: string
#
# ================================================================================
# 使用例
# ================================================================================
#
# 基本的な使用例:
#
# resource "aws_datasync_agent" "example" {
#   ip_address = "10.0.1.100"
#   name       = "example-agent"
# }
#
# resource "aws_datasync_location_nfs" "source" {
#   server_hostname = "nfs-source.example.com"
#   subdirectory    = "/data/source"
#
#   on_prem_config {
#     agent_arns = [aws_datasync_agent.example.arn]
#   }
#
#   mount_options {
#     version = "NFS4_1"
#   }
#
#   tags = {
#     Name        = "source-nfs-location"
#     Environment = "production"
#   }
# }
#
# resource "aws_datasync_location_nfs" "destination" {
#   server_hostname = "nfs-dest.example.com"
#   subdirectory    = "/data/destination"
#
#   on_prem_config {
#     agent_arns = [aws_datasync_agent.example.arn]
#   }
#
#   mount_options {
#     version = "NFS3"
#   }
#
#   tags = {
#     Name        = "destination-nfs-location"
#     Environment = "production"
#   }
# }
#
# resource "aws_datasync_task" "example" {
#   source_location_arn      = aws_datasync_location_nfs.source.arn
#   destination_location_arn = aws_datasync_location_nfs.destination.arn
#   name                     = "nfs-to-nfs-transfer"
# }
#
# ================================================================================
