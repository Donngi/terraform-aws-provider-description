#---------------------------------------------------------------
# AWS Transfer Family Server
#---------------------------------------------------------------
#
# AWS Transfer Familyサーバーをプロビジョニングします。
# SFTP、FTPS、FTP、AS2プロトコルをサポートし、Amazon S3またはAmazon EFSへの
# セキュアなファイル転送を実現します。
#
# AWS公式ドキュメント:
#   - AWS Transfer Family User Guide: https://docs.aws.amazon.com/transfer/latest/userguide/
#   - Creating an SFTP server: https://docs.aws.amazon.com/transfer/latest/userguide/create-server-sftp.html
#   - Creating an FTPS server: https://docs.aws.amazon.com/transfer/latest/userguide/create-server-ftp.html
#   - Security policies: https://docs.aws.amazon.com/transfer/latest/userguide/security-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/transfer_server
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_server" "example" {

  #-------------------------------------------------------------
  # プロトコル設定
  #-------------------------------------------------------------

  # protocols (Optional)
  # 設定内容: ファイル転送プロトコルを指定します
  # 設定可能な値:
  #   - AS2: Applicability Statement 2によるファイル転送
  #   - SFTP: SSH上でのファイル転送（デフォルト）
  #   - FTPS: TLS暗号化を使用したファイル転送
  #   - FTP: 暗号化なしのファイル転送
  # 省略時: ["SFTP"]がデフォルトで設定されます
  # 注意: 複数のプロトコルを指定できますが、AS2は単独でのみ使用可能です
  protocols = ["SFTP"]

  # certificate (Optional)
  # 設定内容: FTPS接続に使用するACM証明書のARNを指定します
  # 省略時: 証明書は設定されません
  # 注意: protocolsにFTPSを含む場合は必須です
  certificate = null

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # endpoint_type (Optional)
  # 設定内容: サーバーエンドポイントのタイプを指定します
  # 設定可能な値:
  #   - PUBLIC: パブリックインターネット経由でアクセス可能（デフォルト）
  #   - VPC: VPC内のプライベートエンドポイント
  #   - VPC_ENDPOINT: 既存のVPCエンドポイントを使用
  # 省略時: PUBLICがデフォルトで設定されます
  # 注意: VPCまたはVPC_ENDPOINTを選択すると、パブリックインターネットからはアクセスできません
  endpoint_type = "PUBLIC"

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # identity_provider_type (Optional)
  # 設定内容: ユーザー認証方式を指定します
  # 設定可能な値:
  #   - SERVICE_MANAGED: AWS Transfer Family内でユーザー認証情報を管理（デフォルト）
  #   - API_GATEWAY: Amazon API Gatewayエンドポイントを使用したカスタム認証
  #   - AWS_DIRECTORY_SERVICE: AWS Managed Active DirectoryまたはオンプレミスADとの連携
  #   - AWS_LAMBDA: Lambda関数を使用したカスタム認証
  # 省略時: SERVICE_MANAGEDがデフォルトで設定されます
  identity_provider_type = "SERVICE_MANAGED"

  # url (Optional)
  # 設定内容: API_GATEWAY認証方式で使用するエンドポイントURLを指定します
  # 省略時: URL は設定されません
  # 注意: identity_provider_typeがAPI_GATEWAYの場合に必要です
  url = null

  # invocation_role (Optional)
  # 設定内容: API_GATEWAY認証でユーザーを認証するIAMロールのARNを指定します
  # 省略時: ロールは設定されません
  # 注意: identity_provider_typeがAPI_GATEWAYの場合に必要です
  invocation_role = null

  # directory_id (Optional)
  # 設定内容: AWS Directory ServiceのディレクトリIDを指定します
  # 省略時: ディレクトリIDは設定されません
  # 注意: identity_provider_typeがAWS_DIRECTORY_SERVICEの場合に必要です
  directory_id = null

  # function (Optional)
  # 設定内容: Lambda関数のARNを指定します
  # 省略時: Lambda関数は設定されません
  # 注意: identity_provider_typeがAWS_LAMBDAの場合に必要です
  function = null

  # sftp_authentication_methods (Optional)
  # 設定内容: SFTP接続での認証方式を指定します
  # 設定可能な値:
  #   - PASSWORD: パスワード認証のみ
  #   - PUBLIC_KEY: 公開鍵認証のみ
  #   - PUBLIC_KEY_OR_PASSWORD: 公開鍵またはパスワード認証（デフォルト）
  #   - PUBLIC_KEY_AND_PASSWORD: 公開鍵とパスワードの両方が必要
  # 省略時: PUBLIC_KEY_OR_PASSWORDがデフォルトで設定されます
  # 注意: identity_provider_typeがAPI_GATEWAYまたはAWS_LAMBDAの場合のみ有効です
  sftp_authentication_methods = null

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # domain (Optional)
  # 設定内容: ファイル転送に使用するストレージシステムのドメインを指定します
  # 設定可能な値:
  #   - S3: Amazon S3バケット（デフォルト）
  #   - EFS: Amazon Elastic File System
  # 省略時: S3がデフォルトで設定されます
  domain = "S3"

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # security_policy_name (Optional)
  # 設定内容: サーバーに適用するセキュリティポリシーを指定します
  # 設定可能な値:
  #   - TransferSecurityPolicy-2018-11（デフォルト）
  #   - TransferSecurityPolicy-2020-06
  #   - TransferSecurityPolicy-2022-03
  #   - TransferSecurityPolicy-2023-05
  #   - TransferSecurityPolicy-2024-01
  #   - TransferSecurityPolicy-2025-03
  #   - TransferSecurityPolicy-FIPS-2020-06
  #   - TransferSecurityPolicy-FIPS-2023-05
  #   - TransferSecurityPolicy-FIPS-2024-01
  #   - TransferSecurityPolicy-FIPS-2024-05
  #   - TransferSecurityPolicy-FIPS-2025-03
  #   - TransferSecurityPolicy-PQ-SSH-Experimental-2023-04
  #   - TransferSecurityPolicy-PQ-SSH-FIPS-Experimental-2023-04
  #   - TransferSecurityPolicy-Restricted-2018-11
  #   - TransferSecurityPolicy-Restricted-2020-06
  #   - TransferSecurityPolicy-Restricted-2024-06
  #   - TransferSecurityPolicy-SshAuditCompliant-2025-02
  #   - TransferSecurityPolicy-AS2Restricted-2025-07
  # 省略時: TransferSecurityPolicy-2018-11がデフォルトで設定されます
  # 関連機能: Security Policies
  #   暗号化アルゴリズム、鍵交換アルゴリズム、MACアルゴリズムを定義します
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/security-policies.html
  security_policy_name = "TransferSecurityPolicy-2024-01"

  # host_key (Optional, Forces new resource)
  # 設定内容: サーバーのホスト鍵（RSA、ECDSA、またはED25519秘密鍵）を指定します
  # 省略時: AWS Transfer Familyが自動的にホスト鍵を生成します
  # 注意: ssh-keygenコマンドで生成したPEM形式の秘密鍵を指定します
  #       例: ssh-keygen -t rsa -b 2048 -N "" -m PEM -f my-new-server-key
  host_key = null

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_role (Optional)
  # 設定内容: CloudWatch Logsへのロギングを有効にするIAMロールのARNを指定します
  # 省略時: ロギングは無効になります
  # 関連機能: CloudWatch Logs Integration
  #   ユーザーのアクティビティをCloudWatch Logsに記録します
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/monitoring.html
  logging_role = null

  # structured_log_destinations (Optional)
  # 設定内容: 構造化ログの送信先ARNのセットを指定します
  # 設定可能な値: CloudWatch Log GroupのARN（例: "arn:aws:logs:region:account-id:log-group:log-group-name:*"）
  # 省略時: 構造化ログは無効になります
  # 関連機能: Structured Logging
  #   JSON形式の構造化ログをCloudWatch Logsに出力します
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/structured-logging.html
  structured_log_destinations = null

  #-------------------------------------------------------------
  # ワークフロー設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: サーバー削除時に関連するすべてのユーザーを自動削除するかを指定します
  # 設定可能な値:
  #   - true: ユーザーを自動削除
  #   - false: ユーザーが存在する場合は削除を拒否（デフォルト）
  # 省略時: falseがデフォルトで設定されます
  # 注意: identity_provider_typeがSERVICE_MANAGEDの場合のみ有効です
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグを指定します
  # 省略時: タグは設定されません
  tags = {
    Name        = "example-transfer-server"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # エンドポイント詳細設定（VPCエンドポイントの場合）
  #-------------------------------------------------------------

  # endpoint_details (Optional)
  # 設定内容: VPCエンドポイントの詳細設定を行います
  # 注意: endpoint_typeがVPCまたはVPC_ENDPOINTの場合に必要です
  # endpoint_details {
  #
  #   # vpc_id (Optional)
  #   # 設定内容: サーバーエンドポイントをホストするVPCのIDを指定します
  #   # 注意: endpoint_typeがVPCの場合に必要です
  #   vpc_id = "vpc-12345678"
  #
  #   # subnet_ids (Optional)
  #   # 設定内容: サーバーエンドポイントをホストするサブネットIDのリストを指定します
  #   # 注意: endpoint_typeがVPCの場合に必要です
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #
  #   # security_group_ids (Optional)
  #   # 設定内容: サーバーエンドポイントにアタッチするセキュリティグループIDのリストを指定します
  #   # 省略時: VPCのデフォルトセキュリティグループが自動的に割り当てられます
  #   # 注意: endpoint_typeがVPCの場合のみ有効です
  #   security_group_ids = ["sg-12345678"]
  #
  #   # address_allocation_ids (Optional)
  #   # 設定内容: Elastic IP アドレスをアタッチするためのアロケーションIDのリストを指定します
  #   # 省略時: Elastic IPは割り当てられません
  #   # 注意: endpoint_typeがVPCの場合のみ有効です
  #   address_allocation_ids = ["eipalloc-12345678"]
  #
  #   # vpc_endpoint_id (Optional)
  #   # 設定内容: 既存のVPCエンドポイントIDを指定します
  #   # 注意: endpoint_typeがVPC_ENDPOINTの場合に必要です
  #   vpc_endpoint_id = "vpce-12345678"
  # }

  #-------------------------------------------------------------
  # プロトコル詳細設定
  #-------------------------------------------------------------

  # protocol_details (Optional)
  # 設定内容: プロトコル固有の詳細設定を行います
  # protocol_details {
  #
  #   # passive_ip (Optional)
  #   # 設定内容: FTPおよびFTPSプロトコルのパッシブモードで使用するIPv4アドレスを指定します
  #   # 設定可能な値: 単一のIPv4アドレス（例: ファイアウォール、ルーター、ロードバランサーのパブリックIP）
  #   # 省略時: パッシブIPは設定されません
  #   passive_ip = "203.0.113.1"
  #
  #   # tls_session_resumption_mode (Optional)
  #   # 設定内容: FTPSプロトコルでのTLSセッション再開モードを指定します
  #   # 設定可能な値:
  #   #   - DISABLED: TLSセッション再開を無効化
  #   #   - ENABLED: TLSセッション再開を有効化
  #   #   - ENFORCED: TLSセッション再開を強制
  #   # 省略時: セッション再開モードは設定されません
  #   tls_session_resumption_mode = "ENABLED"
  #
  #   # set_stat_option (Optional)
  #   # 設定内容: S3バケットへのファイルアップロード時のSETSTATエラーを無視するかを指定します
  #   # 設定可能な値:
  #   #   - DEFAULT: デフォルト動作（エラーを返す）
  #   #   - ENABLE_NO_OP: エラーを無視する
  #   # 省略時: DEFAULTが設定されます
  #   set_stat_option = "ENABLE_NO_OP"
  #
  #   # as2_transports (Optional)
  #   # 設定内容: AS2メッセージの転送方式を指定します
  #   # 設定可能な値:
  #   #   - HTTP: HTTP転送（現在HTTPのみサポート）
  #   # 省略時: AS2転送は設定されません
  #   # 注意: protocolsにAS2を含む場合に必要です
  #   as2_transports = ["HTTP"]
  #
  #   # s3_storage_options (Optional)
  #   # 設定内容: S3ストレージのオプション設定を行います
  #   # s3_storage_options {
  #     # directory_listing_optimization (Optional)
  #     # 設定内容: S3ディレクトリのパフォーマンス最適化を有効にするかを指定します
  #     # 設定可能な値:
  #     #   - DISABLED: 最適化を無効化（デフォルト）
  #     #   - ENABLED: 最適化を有効化
  #     # 省略時: DISABLEDがデフォルトで設定されます
  #     # 関連機能: S3 Directory Listing Optimization
  #     #   ホームディレクトリマッピングでTYPEをFILEに設定する必要があります
  #     #   - https://docs.aws.amazon.com/transfer/latest/userguide/logical-dir-mappings.html
  #     # directory_listing_optimization = "ENABLED"
  #   # }
  # }

  #-------------------------------------------------------------
  # ワークフロー詳細設定
  #-------------------------------------------------------------

  # workflow_details (Optional)
  # 設定内容: マネージドワークフローの詳細設定を行います
  # 関連機能: AWS Transfer Family Workflows
  #   ファイルアップロード時に自動実行されるワークフローを定義します
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/transfer-workflows.html
  # workflow_details {
  #
  #   # on_upload (Optional)
  #   # 設定内容: ファイルアップロード完了時に実行されるワークフローを指定します
  #   # on_upload {
  #     # execution_role (Required)
  #     # 設定内容: ワークフロー実行に必要なIAMロールのARNを指定します
  #     # 注意: S3、EFS、Lambda操作に必要な権限を含める必要があります
  #     # execution_role = "arn:aws:iam::123456789012:role/transfer-workflow-execution-role"
  #
  #     # workflow_id (Required)
  #     # 設定内容: 実行するワークフローの一意な識別子を指定します
  #     # workflow_id = "w-1234567890abcdef0"
  #   # }
  #
  #   # on_partial_upload (Optional)
  #   # 設定内容: ファイルが部分的にアップロードされた場合に実行されるワークフローを指定します
  #   # on_partial_upload {
  #     # execution_role (Required)
  #     # 設定内容: ワークフロー実行に必要なIAMロールのARNを指定します
  #     # 注意: S3、EFS、Lambda操作に必要な権限を含める必要があります
  #     # execution_role = "arn:aws:iam::123456789012:role/transfer-workflow-execution-role"
  #
  #     # workflow_id (Required)
  #     # 設定内容: 実行するワークフローの一意な識別子を指定します
  #     # workflow_id = "w-1234567890abcdef1"
  #   # }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Transfer ServerのAmazon Resource Name（ARN）
#   例: arn:aws:transfer:us-east-1:123456789012:server/s-1234567890abcdef0
#
# - id: Transfer ServerのサーバーID
#   例: s-1234567890abcdef0
#
# - endpoint: Transfer Serverのエンドポイント
#   例: s-1234567890abcdef0.server.transfer.us-east-1.amazonaws.com
#
# - host_key_fingerprint: サーバーのホスト鍵のMD5ハッシュ
#   ssh-keygen -l -E md5 -f my-new-server-keyコマンドの出力と同等の値
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# 1. 基本的なSFTPサーバー（SERVICE_MANAGED認証）
#    - endpoint_type = "PUBLIC"
#    - identity_provider_type = "SERVICE_MANAGED"
#    - protocols = ["SFTP"]
#
# 2. VPCエンドポイントを使用したSFTPサーバー
#    - endpoint_type = "VPC"
#    - endpoint_details { vpc_id, subnet_ids, security_group_ids }
#    - protocols = ["SFTP"]
#
# 3. FTP/FTPSサーバー（証明書必須）
#    - endpoint_type = "VPC"
#    - protocols = ["FTP", "FTPS"]
#    - certificate = aws_acm_certificate.example.arn
#
# 4. AWS Directory Service認証
#    - identity_provider_type = "AWS_DIRECTORY_SERVICE"
#    - directory_id = aws_directory_service_directory.example.id
#
# 5. Lambda関数による認証
#    - identity_provider_type = "AWS_LAMBDA"
#    - function = aws_lambda_function.example.arn
#
# 6. API Gateway認証
#    - identity_provider_type = "API_GATEWAY"
#    - url = "${aws_api_gateway_deployment.example.invoke_url}..."
#    - invocation_role = aws_iam_role.example.arn
#
# 7. 構造化ロギング
#    - logging_role = aws_iam_role.iam_for_transfer.arn
#    - structured_log_destinations = ["${aws_cloudwatch_log_group.transfer.arn}:*"]
#
# 8. ワークフロー統合
#    - workflow_details {
#        on_upload { execution_role, workflow_id }
#      }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# 1. IAM権限について
#    - endpoint_typeがVPCの場合、ec2:DescribeVpcEndpointsと
#      ec2:ModifyVpcEndpoint権限が必要です
#
# 2. カスタムホスト名について
#    - カスタムホスト名を使用する場合は、aws_transfer_tagリソースで
#      システムタグを管理してください
#    - https://docs.aws.amazon.com/transfer/latest/userguide/requirements-dns.html#tag-custom-hostname-cdk
#
# 3. セキュリティポリシーについて
#    - 新しいポリシーほど強固な暗号化アルゴリズムを使用しますが、
#      古いクライアントとの互換性が失われる可能性があります
#    - FIPS準拠が必要な場合は、FIPS対応ポリシーを選択してください
#
# 4. エンドポイントタイプの変更について
#    - エンドポイントタイプを変更する前に、サーバーを停止する必要があります
#
# 5. プロトコル制約について
#    - AS2プロトコルは他のプロトコルと同時に使用できません
#    - FTPSを使用する場合は、certificateパラメータが必須です
#
# 6. ストレージについて
#    - Amazon S3使用時は、HeadObject動作によるレイテンシーに注意してください
#    - Amazon EFS使用時は、Transfer FamilyサーバーとEFSファイルシステムを
#      同じAWSリージョンに配置する必要があります
#
# 7. リージョン設定について
#    - regionパラメータで明示的にリージョンを指定できますが、
#      省略時はプロバイダー設定のリージョンが使用されます
#
#---------------------------------------------------------------
