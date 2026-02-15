#-------------------------------------------------------------------------------------------------------
# リソース名: aws_datasync_location_hdfs
# Provider Version: 6.28.0
# Generated: 2025-01-XX
#
# NOTE: このテンプレートは参考情報です。実際の使用時は環境に合わせて調整してください。
#-------------------------------------------------------------------------------------------------------
# 機能概要:
#   AWS DataSyncのHDFS (Hadoop Distributed File System) ロケーションを管理します。
#   オンプレミスやクラウド上のHDFSクラスタとAWS間でデータ転送を行うための
#   DataSyncロケーションエンドポイントを定義します。
#
# 主な用途:
#   - オンプレミスHadoopクラスタからS3への移行
#   - HDFSとAWSストレージサービス間のデータ同期
#   - ビッグデータワークロードのクラウド移行
#   - 分散ファイルシステムとのハイブリッド構成
#
# リソースドキュメント: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datasync_location_hdfs
# AWS公式ドキュメント: https://docs.aws.amazon.com/datasync/latest/userguide/create-hdfs-location.html
#-------------------------------------------------------------------------------------------------------

resource "aws_datasync_location_hdfs" "example" {
  #-------------------------------------------------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------------------------------------------------

  # agent_arns - DataSyncエージェントのARNリスト
  # 設定内容: HDFSクラスタにアクセスするために使用するDataSyncエージェントのARN
  # 補足: 高可用性のために複数エージェントを指定可能。各エージェントはHDFSネットワークにアクセスできる必要がある
  agent_arns = [
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-0123456789abcdef0",
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-0123456789abcdef1"
  ]

  # name_node - HDFSクラスタのNameNode設定
  # 設定内容: HDFSクラスタのNameNodeエンドポイント情報
  # 補足: 高可用性構成の場合は複数のNameNodeを指定可能
  name_node {
    # hostname - NameNodeのホスト名またはIPアドレス
    # 設定内容: HDFSクラスタのNameNodeにアクセスするためのホスト名
    hostname = "namenode.example.com"

    # port - NameNodeのポート番号
    # 設定内容: NameNodeがリッスンするポート番号
    # 省略時: 8020 (HDFS標準ポート)
    port = 8020
  }

  # 高可用性構成の例（複数NameNode）
  # name_node {
  #   hostname = "namenode2.example.com"
  #   port     = 8020
  # }

  #-------------------------------------------------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------------------------------------------------

  # authentication_type - 認証方式
  # 設定内容: HDFSクラスタへの認証方式を指定
  # 設定可能な値:
  #   - SIMPLE: シンプル認証（ユーザー名のみ）
  #   - KERBEROS: Kerberos認証
  # 省略時: SIMPLE
  authentication_type = "KERBEROS"

  # simple_user - シンプル認証ユーザー名
  # 設定内容: authentication_type=SIMPLEの場合に使用するユーザー名
  # 補足: SIMPLE認証時は必須。HDFSクラスタ上で適切な権限を持つユーザーを指定
  simple_user = "hdfs"

  # kerberos_principal - Kerberosプリンシパル
  # 設定内容: Kerberos認証時に使用するプリンシパル名
  # 補足: authentication_type=KERBEROSの場合に必須。形式: primary/instance@REALM
  kerberos_principal = "datasync/agent@EXAMPLE.COM"

  # kerberos_keytab - Kerberos Keytabファイルパス
  # 設定内容: Keytabファイルへのローカルパス
  # 補足: kerberos_keytab_base64との排他設定。ファイルは自動的にBase64エンコードされる
  kerberos_keytab = "/path/to/keytab"

  # kerberos_keytab_base64 - Base64エンコード済みKeytab
  # 設定内容: Base64エンコードされたKeytabファイルの内容
  # 補足: kerberos_keytabとの排他設定。Terraform内で管理する場合はこちらを推奨
  kerberos_keytab_base64 = "BQIAAABHAAIACEVYQU1QTEUuQ09NAAdkYXRhc3luYw=="

  # kerberos_krb5_conf - Kerberos設定ファイルパス
  # 設定内容: krb5.confファイルへのローカルパス
  # 補足: kerberos_krb5_conf_base64との排他設定
  kerberos_krb5_conf = "/etc/krb5.conf"

  # kerberos_krb5_conf_base64 - Base64エンコード済みKerberos設定
  # 設定内容: Base64エンコードされたkrb5.confファイルの内容
  # 補足: kerberos_krb5_confとの排他設定。Terraform内で管理する場合はこちらを推奨
  kerberos_krb5_conf_base64 = "W2xpYmRlZmF1bHRzXQogICAgZGVmYXVsdF9yZWFsbSA9IEVYQU1QTEUuQ09N"

  #-------------------------------------------------------------------------------------------------------
  # HDFS設定
  #-------------------------------------------------------------------------------------------------------

  # subdirectory - サブディレクトリパス
  # 設定内容: HDFS上でDataSyncがアクセスするサブディレクトリパス
  # 省略時: "/" (ルートディレクトリ)
  # 補足: 転送対象のディレクトリパスを指定。存在しない場合は作成される
  subdirectory = "/data/migration"

  # block_size - ブロックサイズ
  # 設定内容: HDFSブロックサイズ（バイト単位）
  # 省略時: HDFSクラスタのデフォルト値（通常134217728 = 128MB）
  # 補足: パフォーマンス最適化のために調整可能。大容量ファイルの場合は増やすことを推奨
  block_size = 134217728

  # replication_factor - レプリケーション係数
  # 設定内容: HDFSに書き込む際のレプリケーション数
  # 省略時: HDFSクラスタのデフォルト値（通常3）
  # 補足: データ可用性と冗長性のバランスを考慮して設定
  replication_factor = 3

  #-------------------------------------------------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------------------------------------------------

  # qop_configuration - QoP（Quality of Protection）設定
  # 設定内容: データ転送時の保護レベル設定
  # 補足: Kerberos認証時に使用可能。データ転送とRPC通信の暗号化レベルを制御
  qop_configuration {
    # data_transfer_protection - データ転送の保護レベル
    # 設定内容: HDFS Data Transferプロトコルの保護レベル
    # 設定可能な値:
    #   - DISABLED: 保護なし
    #   - AUTHENTICATION: 認証のみ
    #   - INTEGRITY: 完全性チェック
    #   - PRIVACY: 暗号化
    # 省略時: PRIVACY
    data_transfer_protection = "PRIVACY"

    # rpc_protection - RPC保護レベル
    # 設定内容: HDFS RPCの保護レベル
    # 設定可能な値:
    #   - DISABLED: 保護なし
    #   - AUTHENTICATION: 認証のみ
    #   - INTEGRITY: 完全性チェック
    #   - PRIVACY: 暗号化
    # 省略時: PRIVACY
    rpc_protection = "PRIVACY"
  }

  # kms_key_provider_uri - KMSキープロバイダURI
  # 設定内容: Hadoop KMSキープロバイダのURI
  # 補足: HDFS Transparent Encryption使用時に指定。形式: kms://http@kmshost:port/kms
  kms_key_provider_uri = "kms://http@kms.example.com:9292/kms"

  #-------------------------------------------------------------------------------------------------------
  # リージョン・タグ設定
  #-------------------------------------------------------------------------------------------------------

  # region - AWSリージョン
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダ設定のリージョン
  # 補足: DataSyncエージェントと同じリージョンを推奨
  region = "us-east-1"

  # tags - リソースタグ
  # 設定内容: ロケーションに付与するタグ
  tags = {
    Name        = "hdfs-migration-location"
    Environment = "production"
    Cluster     = "hadoop-prod"
    ManagedBy   = "terraform"
  }
}

#-------------------------------------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-------------------------------------------------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# - id          : リソースID（ARNと同じ値）
# - arn         : ロケーションのARN
# - uri         : HDFSロケーションのURI（形式: hdfs://namenode:port/path）
# - tags_all    : デフォルトタグとリソースタグを統合した全タグ
#-------------------------------------------------------------------------------------------------------
