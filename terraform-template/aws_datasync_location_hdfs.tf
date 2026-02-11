# =====================================================================================================
# Terraform Template: aws_datasync_location_hdfs
# =====================================================================================================
# 生成日: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の AWS Provider 6.28.0 の仕様に基づいています
# - 最新の仕様や詳細な情報は公式ドキュメントを参照してください
# - 実際の使用時には、環境に応じて必要なプロパティのみを設定してください
#
# 公式ドキュメント:
# - Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datasync_location_hdfs
# - AWS DataSync HDFS Location: https://docs.aws.amazon.com/datasync/latest/userguide/create-hdfs-location.html
# - AWS API Reference: https://docs.aws.amazon.com/datasync/latest/userguide/API_CreateLocationHdfs.html
# =====================================================================================================

# HDFS (Hadoop Distributed File System) ロケーションの定義
# AWS DataSync は HDFS クラスタとの間でデータ転送を行うためのロケーションを作成します
# このリソースは source または destination として使用可能です
#
# 注意: このリソースを作成する前に DataSync Agent が利用可能である必要があります
resource "aws_datasync_location_hdfs" "example" {
  # =====================================================================================================
  # 必須パラメータ (Required)
  # =====================================================================================================

  # agent_arns - (必須) この HDFS ロケーションに関連付ける DataSync Agent の ARN リスト
  # DataSync Agent は HDFS クラスタへの接続とデータ転送を担当します
  # Agent は HDFS クライアントとして動作し、NameNode および DataNode と通信します
  # 少なくとも 1 つの Agent ARN が必要です
  # 型: set(string)
  agent_arns = [
    # "arn:aws:datasync:us-east-1:123456789012:agent/agent-12345678901234567"
  ]

  # =====================================================================================================
  # name_node ブロック - (必須) HDFS ネームスペースを管理する NameNode の設定
  # =====================================================================================================
  # NameNode は HDFS クラスタのメタデータを管理し、ファイルやディレクトリの操作を実行します
  # DataNode へのデータブロックのマッピング情報も保持します
  # 最小 1 つの name_node ブロックが必要です
  # 注意: 複数の NameNode 構成はサポートされていません
  name_node {
    # hostname - (必須) HDFS クラスタの NameNode のホスト名
    # IP アドレスまたは DNS 名を指定します
    # オンプレミスにインストールされた Agent はこのホスト名を使用して NameNode と通信します
    # 型: string
    hostname = "namenode.example.com"

    # port - (必須) NameNode がクライアントリクエストをリッスンするポート番号
    # 通常、HDFS のデフォルトポートは 8020 または 9000 です
    # 型: number
    port = 8020
  }

  # =====================================================================================================
  # オプションパラメータ - 認証設定
  # =====================================================================================================

  # authentication_type - (オプション) ユーザー認証に使用する認証タイプ
  # SIMPLE または KERBEROS を指定します
  # - SIMPLE: 基本的なユーザー名ベースの認証
  # - KERBEROS: Kerberos プロトコルを使用した認証
  # 型: string
  # 有効な値: "SIMPLE", "KERBEROS"
  authentication_type = "KERBEROS"

  # simple_user - (オプション) ホストオペレーティングシステム上でクライアントを識別するユーザー名
  # authentication_type が "SIMPLE" の場合に必須です
  # 型: string
  # simple_user = "hdfs-user"

  # kerberos_principal - (オプション) HDFS クラスタのファイルとフォルダへのアクセス権を持つ Kerberos プリンシパル
  # authentication_type が "KERBEROS" の場合に必須です
  # 例: "user@EXAMPLE.COM"
  # 型: string
  # kerberos_principal = "datasync@EXAMPLE.COM"

  # kerberos_keytab - (オプション) Kerberos プリンシパルと暗号化キーのマッピングを含む keytab ファイルの内容
  # authentication_type が "KERBEROS" の場合、このパラメータまたは kerberos_keytab_base64 が必須です
  # 値が有効な UTF-8 文字列でない場合は kerberos_keytab_base64 を使用してください
  # 型: string
  # kerberos_keytab = file("path/to/user.keytab")

  # kerberos_keytab_base64 - (オプション) kerberos_keytab の代わりに base64 エンコードされたバイナリデータを直接渡す
  # authentication_type が "KERBEROS" の場合、このパラメータまたは kerberos_keytab が必須です
  # 型: string
  # kerberos_keytab_base64 = filebase64("path/to/user.keytab")

  # kerberos_krb5_conf - (オプション) Kerberos 設定情報を含む krb5.conf ファイルの内容
  # authentication_type が "KERBEROS" の場合、このパラメータまたは kerberos_krb5_conf_base64 が必須です
  # 値が有効な UTF-8 文字列でない場合は kerberos_krb5_conf_base64 を使用してください
  # 型: string
  # kerberos_krb5_conf = file("path/to/krb5.conf")

  # kerberos_krb5_conf_base64 - (オプション) kerberos_krb5_conf の代わりに base64 エンコードされたバイナリデータを直接渡す
  # authentication_type が "KERBEROS" の場合、このパラメータまたは kerberos_krb5_conf が必須です
  # 型: string
  # kerberos_krb5_conf_base64 = filebase64("path/to/krb5.conf")

  # =====================================================================================================
  # オプションパラメータ - データ転送設定
  # =====================================================================================================

  # block_size - (オプション) HDFS クラスタに書き込むデータブロックのサイズ
  # 512 バイトの倍数である必要があります
  # デフォルトは 128 MiB (134217728 バイト) です
  # 型: number (バイト単位)
  # block_size = 134217728

  # replication_factor - (オプション) HDFS クラスタへの書き込み時にデータをレプリケートする DataNode の数
  # デフォルトでは、データは 3 つの DataNode にレプリケートされます
  # 型: number
  # replication_factor = 3

  # subdirectory - (オプション) HDFS クラスタ内のサブディレクトリ
  # HDFS クラスタからのデータ読み取り、または書き込みに使用されます
  # 指定しない場合、デフォルトで "/" になります
  # 型: string
  # subdirectory = "/data/transfer"

  # =====================================================================================================
  # オプションパラメータ - セキュリティ設定
  # =====================================================================================================

  # kms_key_provider_uri - (オプション) HDFS クラスタの Key Management Server (KMS) の URI
  # Transparent Data Encryption (TDE) で暗号化された HDFS クラスタを使用する場合に指定します
  # 注意: TDE と Kerberos 認証の組み合わせはサポートされていません
  # 型: string
  # kms_key_provider_uri = "kms://http@kms.example.com:16000/kms"

  # =====================================================================================================
  # qop_configuration ブロック - (オプション) Quality of Protection (QOP) 設定
  # =====================================================================================================
  # HDFS クラスタに設定された RPC およびデータ転送の保護設定を指定します
  # qop_configuration を指定しない場合、rpc_protection と data_transfer_protection はデフォルトで "PRIVACY" になります
  # RpcProtection または DataTransferProtection のいずれかを設定すると、もう一方のパラメータも同じ値を想定します
  qop_configuration {
    # data_transfer_protection - (オプション) HDFS クラスタに設定されたデータ転送保護設定
    # hdfs-site.xml ファイルの dfs.data.transfer.protection 設定に対応します
    # 型: string
    # 有効な値: "DISABLED", "AUTHENTICATION", "INTEGRITY", "PRIVACY"
    # - DISABLED: 保護なし
    # - AUTHENTICATION: 認証のみ
    # - INTEGRITY: 認証 + データの整合性チェック
    # - PRIVACY: 認証 + データの整合性チェック + 暗号化
    # デフォルト: "PRIVACY"
    data_transfer_protection = "PRIVACY"

    # rpc_protection - (オプション) HDFS クラスタに設定された RPC 保護設定
    # core-site.xml ファイルの hadoop.rpc.protection 設定に対応します
    # 型: string
    # 有効な値: "DISABLED", "AUTHENTICATION", "INTEGRITY", "PRIVACY"
    # - DISABLED: 保護なし
    # - AUTHENTICATION: 認証のみ
    # - INTEGRITY: 認証 + データの整合性チェック
    # - PRIVACY: 認証 + データの整合性チェック + 暗号化
    # デフォルト: "PRIVACY"
    rpc_protection = "PRIVACY"
  }

  # =====================================================================================================
  # オプションパラメータ - タグとメタデータ
  # =====================================================================================================

  # tags - (オプション) DataSync Location に割り当てるリソースタグのキーと値のペア
  # provider の default_tags 設定ブロックが存在する場合、一致するキーを持つタグは
  # プロバイダーレベルで定義されたものを上書きします
  # 型: map(string)
  tags = {
    Name        = "hdfs-location"
    Environment = "production"
    Purpose     = "data-migration"
  }

  # tags_all - (オプション) リソースに割り当てられたすべてのタグのマップ
  # provider の default_tags 設定ブロックから継承されたタグを含みます
  # このパラメータは通常、Terraform によって自動的に管理されるため、明示的に設定する必要はありません
  # 型: map(string)
  # tags_all = {}

  # =====================================================================================================
  # オプションパラメータ - その他
  # =====================================================================================================

  # id - (オプション) リソースの ID
  # このパラメータは computed であり、通常は明示的に設定する必要はありません
  # Terraform が自動的に管理します
  # 型: string
  # id = ""

  # region - (オプション) このリソースが管理されるリージョン
  # 指定しない場合、provider 設定で設定されたリージョンがデフォルトになります
  # 型: string
  # region = "us-east-1"
}

# =====================================================================================================
# 出力値の例 (Computed Attributes)
# =====================================================================================================

# arn - DataSync Location の Amazon Resource Name (ARN)
# 他のリソースで参照する際に使用します
output "hdfs_location_arn" {
  description = "ARN of the DataSync HDFS Location"
  value       = aws_datasync_location_hdfs.example.arn
}

# uri - HDFS ロケーションの URI
# DataSync が HDFS クラスタへの接続に使用する URI です
output "hdfs_location_uri" {
  description = "URI of the DataSync HDFS Location"
  value       = aws_datasync_location_hdfs.example.uri
}

# tags_all - リソースに割り当てられたすべてのタグ
# provider の default_tags から継承されたタグを含みます
output "hdfs_location_tags_all" {
  description = "All tags assigned to the DataSync HDFS Location"
  value       = aws_datasync_location_hdfs.example.tags_all
}

# =====================================================================================================
# 使用例とベストプラクティス
# =====================================================================================================

# 例1: Simple 認証を使用した HDFS ロケーション
# resource "aws_datasync_location_hdfs" "simple_auth" {
#   agent_arns          = [aws_datasync_agent.example.arn]
#   authentication_type = "SIMPLE"
#   simple_user         = "hadoop-user"
#
#   name_node {
#     hostname = "namenode.example.com"
#     port     = 8020
#   }
#
#   subdirectory = "/data/source"
#
#   tags = {
#     Name = "hdfs-simple-auth-location"
#   }
# }

# 例2: Kerberos 認証を使用した HDFS ロケーション
# resource "aws_datasync_location_hdfs" "kerberos_auth" {
#   agent_arns             = [aws_datasync_agent.example.arn]
#   authentication_type    = "KERBEROS"
#   kerberos_principal     = "datasync@EXAMPLE.COM"
#   kerberos_keytab_base64 = filebase64("${path.module}/credentials/user.keytab")
#   kerberos_krb5_conf     = file("${path.module}/config/krb5.conf")
#
#   name_node {
#     hostname = aws_instance.namenode.private_dns
#     port     = 8020
#   }
#
#   qop_configuration {
#     data_transfer_protection = "PRIVACY"
#     rpc_protection           = "PRIVACY"
#   }
#
#   block_size         = 134217728  # 128 MiB
#   replication_factor = 3
#   subdirectory       = "/data/migration"
#
#   tags = {
#     Name        = "hdfs-kerberos-location"
#     Environment = "production"
#   }
# }

# =====================================================================================================
# 注意事項とサポートされていない機能
# =====================================================================================================
#
# サポートされていない HDFS 機能:
# 1. TDE と Kerberos 認証の組み合わせ
# 2. 複数の NameNode の構成
# 3. Hadoop HDFS over HTTP
# 4. POSIX アクセス制御リスト (ACL)
# 5. HDFS 拡張属性
# 6. Apache HBase を使用する HDFS クラスタ
#
# ベストプラクティス:
# 1. DataSync Agent は HDFS クラスタにネットワークアクセスできる必要があります
# 2. Kerberos 認証を使用する場合は、keytab と krb5.conf ファイルを安全に管理してください
# 3. QOP 設定は HDFS クラスタの設定と一致させる必要があります
# 4. 本番環境では PRIVACY レベルの保護を使用することを推奨します
# 5. block_size と replication_factor は HDFS クラスタの設定に合わせて調整してください
# =====================================================================================================
