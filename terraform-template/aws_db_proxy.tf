#---------------------------------------------------------------
# AWS RDS DB Proxy
#---------------------------------------------------------------
#
# Amazon RDS Proxy を作成するリソースです。
# RDS Proxy はアプリケーションとRDSデータベース間の接続を管理し、
# 接続プールの効率化、フェイルオーバー時間の短縮、データベースの
# セキュリティ強化を実現します。
#
# AWS公式ドキュメント:
#   - RDS Proxy 概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html
#   - RDS Proxy の設定: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-setup.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_proxy" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロキシの識別子を指定します。
  # 設定可能な値: 英字で始まり、ASCII文字、数字、ハイフンのみ使用可能。
  #               ハイフンで終わることや2つ連続するハイフンは不可。
  # 注意: 指定したAWSリージョン内で、AWSアカウントが所有するすべてのプロキシに対して一意である必要があります。
  name = "my-db-proxy"

  # engine_family (Required, Forces new resource)
  # 設定内容: プロキシが接続できるデータベースの種類を指定します。
  # 設定可能な値:
  #   - "MYSQL": Aurora MySQL、RDS for MariaDB、RDS for MySQL
  #   - "POSTGRESQL": Aurora PostgreSQL、RDS for PostgreSQL
  #   - "SQLSERVER": RDS for Microsoft SQL Server
  # 注意: 変更すると新しいリソースが強制的に作成されます。
  engine_family = "MYSQL"

  # role_arn (Required)
  # 設定内容: AWS Secrets Manager のシークレットにアクセスするためのIAMロールのARNを指定します。
  # 注意: このロールには Secrets Manager から認証情報を取得する権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/rds-proxy-role"

  # vpc_subnet_ids (Required)
  # 設定内容: プロキシに関連付けるVPCサブネットIDを指定します。
  # 設定可能な値: 1つ以上のサブネットID
  # 注意: すべてのアベイラビリティーゾーン（AZ）がDBプロキシをサポートしているわけではありません。
  #       サポートされていないAZのサブネットを指定してもエラーにはなりませんが、
  #       Terraformが設定と実際のインフラの差分を継続的に検出する原因となります。
  vpc_subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # default_auth_scheme (Optional)
  # 設定内容: プロキシがクライアントとの接続および基盤データベースとの接続に使用するデフォルトの認証スキームを指定します。
  # 設定可能な値:
  #   - "NONE" (デフォルト): 認証スキームを使用しない
  #   - "IAM_AUTH": IAM認証を使用
  # 注意: 値が "NONE" または未指定の場合、auth ブロックが必須です。
  default_auth_scheme = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # vpc_security_group_ids (Optional)
  # 設定内容: プロキシに関連付けるVPCセキュリティグループIDを指定します。
  # 設定可能な値: 1つ以上のセキュリティグループID
  # 省略時: VPCのデフォルトセキュリティグループが使用されます。
  vpc_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

  # endpoint_network_type (Optional)
  # 設定内容: DBプロキシエンドポイントのネットワークタイプを指定します。
  # 設定可能な値:
  #   - "IPV4" (デフォルト): IPv4のみ
  #   - "IPV6": IPv6のみ
  #   - "DUAL": IPv4とIPv6の両方
  # 注意: "IPV6" を指定する場合、関連付けられたサブネットはIPv6専用である必要があり、
  #       target_connection_network_type も "IPV6" である必要があります。
  endpoint_network_type = null

  # target_connection_network_type (Optional)
  # 設定内容: プロキシがターゲットデータベースへの接続に使用するネットワークタイプを指定します。
  # 設定可能な値:
  #   - "IPV4" (デフォルト): IPv4を使用
  #   - "IPV6": IPv6を使用
  target_connection_network_type = null

  #-------------------------------------------------------------
  # 接続設定
  #-------------------------------------------------------------

  # idle_client_timeout (Optional)
  # 設定内容: プロキシへの接続がアイドル状態でいられる秒数を指定します。
  # 設定可能な値: 1〜28800秒（8時間）
  # 省略時: 1800秒（30分）
  # 注意: 関連付けられたデータベースの接続タイムアウト制限より高くまたは低く設定できます。
  idle_client_timeout = 1800

  # require_tls (Optional)
  # 設定内容: プロキシへの接続にTLS暗号化を必須にするかを指定します。
  # 設定可能な値:
  #   - true: TLS暗号化を必須にする（暗号化されたTLS接続を強制）
  #   - false (デフォルト): TLS暗号化を必須にしない
  require_tls = true

  #-------------------------------------------------------------
  # デバッグ設定
  #-------------------------------------------------------------

  # debug_logging (Optional)
  # 設定内容: プロキシがSQL文の詳細情報をログに含めるかを指定します。
  # 設定可能な値:
  #   - true: 詳細なSQL情報をログに記録
  #   - false (デフォルト): 詳細なSQL情報をログに記録しない
  # 注意: この情報はSQLの動作やプロキシ接続のパフォーマンス・スケーラビリティの
  #       問題をデバッグするのに役立ちます。ただし、SQL文のテキストがログに
  #       含まれるため、デバッグが必要な場合のみ有効にし、機密情報を保護する
  #       セキュリティ対策を講じてください。
  debug_logging = false

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-db-proxy"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されたタグを含む全タグのマップです。
  # 注意: 通常は明示的に設定せず、Terraform が自動計算します。
  # tags_all = {}

  #-------------------------------------------------------------
  # 認証ブロック設定
  #-------------------------------------------------------------

  # auth (Optional)
  # 設定内容: 関連付けられたインスタンスまたはクラスターへの接続に使用する認証メカニズムの設定ブロックです。
  # 注意: default_auth_scheme が "NONE" または未指定の場合は必須です。
  auth {
    # auth_scheme (Optional)
    # 設定内容: プロキシから基盤データベースへの接続に使用する認証タイプを指定します。
    # 設定可能な値:
    #   - "SECRETS": Secrets Manager のシークレットを使用した認証
    auth_scheme = "SECRETS"

    # client_password_auth_type (Optional)
    # 設定内容: クライアントからの接続に使用する認証タイプを指定します。
    # 設定可能な値:
    #   - "MYSQL_CACHING_SHA2_PASSWORD": MySQL caching_sha2_password認証
    #   - "MYSQL_NATIVE_PASSWORD": MySQL ネイティブパスワード認証
    #   - "POSTGRES_SCRAM_SHA_256": PostgreSQL SCRAM-SHA-256認証
    #   - "POSTGRES_MD5": PostgreSQL MD5認証
    #   - "SQL_SERVER_AUTHENTICATION": SQL Server認証
    client_password_auth_type = null

    # description (Optional)
    # 設定内容: 特定のデータベースユーザーとしてログインするための認証に関する説明を指定します。
    description = "Example authentication configuration"

    # iam_auth (Optional)
    # 設定内容: プロキシへの接続にIAM認証を必須にするか無効にするかを指定します。
    # 設定可能な値:
    #   - "DISABLED": IAM認証を無効化
    #   - "REQUIRED": IAM認証を必須にする
    iam_auth = "DISABLED"

    # secret_arn (Optional)
    # 設定内容: RDS DBインスタンスまたはAurora DBクラスターへの認証に使用するシークレットのARNを指定します。
    # 注意: これらのシークレットはAmazon Secrets Manager内に保存されています。
    secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:my-db-secret-AbCdEf"

    # username (Optional)
    # 設定内容: プロキシが接続するデータベースユーザー名を指定します。
    username = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウトを指定します。
    # 設定可能な値: "30m" などの duration 文字列
    # 省略時: 30m
    create = "30m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウトを指定します。
    # 設定可能な値: "30m" などの duration 文字列
    # 省略時: 30m
    update = "30m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウトを指定します。
    # 設定可能な値: "60m" などの duration 文字列
    # 省略時: 60m
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: プロキシのAmazon Resource Name (ARN)
#
# - arn: プロキシのAmazon Resource Name (ARN)
#
# - endpoint: プロキシに接続するために使用できるエンドポイント
#             データベースクライアントアプリケーションの接続文字列に含めます。
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
