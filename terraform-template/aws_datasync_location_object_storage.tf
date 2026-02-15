#---------------------------------------
# AWS DataSync オブジェクトストレージロケーション
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datasync_location_object_storage
#
# NOTE: このテンプレートは日本語による詳細な設定説明を含みます
#
# オブジェクトストレージ（S3互換ストレージ）へのDataSync転送ロケーションを作成します。
# オンプレミスやサードパーティのオブジェクトストレージとAWS間のデータ転送に使用します。
#
# ユースケース:
# - MinIOやCeph等のS3互換ストレージからAWSへのデータ移行
# - オンプレミスオブジェクトストレージとの双方向同期
# - マルチクラウド環境でのデータレプリケーション
#
# 制約事項:
# - S3互換APIをサポートするオブジェクトストレージが必要
# - DataSyncエージェントのデプロイが必要（オンプレミス接続時）
# - サーバー証明書検証にはPEM形式の証明書が必要
#
# 関連リソース:
# - aws_datasync_agent: DataSyncエージェント（オンプレミス接続に必要）
# - aws_datasync_task: データ転送タスク
# - aws_datasync_location_s3: AWS S3ロケーション
#
# 参考ドキュメント:
# https://docs.aws.amazon.com/datasync/latest/userguide/create-object-location.html

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_datasync_location_object_storage" "example" {
  # 設定内容: オブジェクトストレージのバケット名
  # 接続先ストレージのバケット名を指定します
  bucket_name = "my-object-storage-bucket"

  # 設定内容: オブジェクトストレージサーバーのホスト名またはIPアドレス
  # DNS名またはIPアドレス形式で指定します
  server_hostname = "object-storage.example.com"

  #---------------------------------------
  # サーバー接続設定
  #---------------------------------------

  # 設定内容: サーバーのポート番号
  # 設定可能な値: 1-65535の整数
  # 省略時: プロトコルのデフォルトポート（HTTP: 80、HTTPS: 443）
  server_port = 443

  # 設定内容: 通信プロトコル
  # 設定可能な値: HTTPS / HTTP
  # 省略時: HTTPS
  # セキュリティのため本番環境ではHTTPSを推奨
  server_protocol = "HTTPS"

  # 設定内容: バケット内のサブディレクトリパス
  # 省略時: バケットのルート（"/"）
  # パスは"/"で始まる必要があります
  subdirectory = "/data"

  #---------------------------------------
  # 認証設定
  #---------------------------------------

  # 設定内容: オブジェクトストレージのアクセスキーID
  # 省略時: 認証なし（匿名アクセス）
  # secret_keyと併せて指定が必要
  access_key = "AKIAIOSFODNN7EXAMPLE"

  # 設定内容: オブジェクトストレージのシークレットアクセスキー
  # 省略時: 認証なし（匿名アクセス）
  # access_keyと併せて指定が必要
  # Terraformステートに機密情報として保存されます
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

  #---------------------------------------
  # SSL/TLS証明書設定
  #---------------------------------------

  # 設定内容: サーバーのSSL/TLS証明書（PEM形式）
  # 省略時: システムの信頼された証明書ストアで検証
  # 自己署名証明書や社内CAの証明書を使用する場合に指定
  # 証明書チェーン全体（中間CA含む）の指定を推奨
  server_certificate = file("server-cert.pem")

  #---------------------------------------
  # エージェント設定
  #---------------------------------------

  # 設定内容: DataSyncエージェントのARNリスト
  # 省略時: VPC内のエージェントを自動選択
  # オンプレミスまたはVPC内のストレージに接続する際に必要
  # 高可用性のため複数エージェントの指定を推奨
  agent_arns = [
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-12345678901234567",
    "arn:aws:datasync:us-east-1:123456789012:agent/agent-23456789012345678",
  ]

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # DataSyncタスクと同じリージョンを指定することを推奨
  region = "us-east-1"

  #---------------------------------------
  # リソース管理
  #---------------------------------------

  # 設定内容: リソースタグのキーと値のマップ
  # コスト配分、運用管理、アクセス制御に使用
  tags = {
    Name        = "OnPremObjectStorageLocation"
    Environment = "Production"
    DataSource  = "OnPremises"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DataSyncロケーションのARN（arnと同値）
# - arn: ロケーションのAmazon Resource Name
#   形式: arn:aws:datasync:<region>:<account-id>:location/loc-xxxxxxxxxxxxxxxxx
# - uri: オブジェクトストレージのURI
#   形式: <protocol>://<server_hostname>:<server_port>/<bucket_name>/<subdirectory>
# - tags_all: デフォルトタグとリソースタグを統合したタグマップ
# - region: リソースが管理されるAWSリージョン（省略時はプロバイダーのリージョン）
# - subdirectory: 実際に使用されるサブディレクトリパス（省略時は"/"）
