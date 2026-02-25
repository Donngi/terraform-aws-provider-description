#---------------------------------------------------------------
# AWS Transfer Family Server
#---------------------------------------------------------------
#
# AWS Transfer Familyのマネージドファイル転送サーバーをプロビジョニングするリソースです。
# SFTP、FTPS、FTP、AS2プロトコルに対応し、S3やEFSをストレージバックエンドとして使用できます。
# パブリックエンドポイントまたはVPCエンドポイントでのホスティングをサポートします。
#
# AWS公式ドキュメント:
#   - AWS Transfer Family 概要: https://docs.aws.amazon.com/transfer/latest/userguide/what-is-aws-transfer-family.html
#   - エンドポイントタイプ: https://docs.aws.amazon.com/transfer/latest/userguide/create-server-in-vpc.html
#   - IDプロバイダー: https://docs.aws.amazon.com/transfer/latest/userguide/identity-providers.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
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
  # 設定内容: サーバーがサポートするファイル転送プロトコルのセットを指定します。
  # 設定可能な値:
  #   - "SFTP": SSH File Transfer Protocol（デフォルト）
  #   - "FTPS": File Transfer Protocol over TLS/SSL
  #   - "FTP": File Transfer Protocol（非暗号化）
  #   - "AS2": Applicability Statement 2
  # 省略時: ["SFTP"]
  # 注意: FTPとFTPSを同時に指定する場合は、endpoint_typeをVPCにする必要があります
  protocols = ["SFTP"]

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # endpoint_type (Optional)
  # 設定内容: サーバーのエンドポイントタイプを指定します。
  # 設定可能な値:
  #   - "PUBLIC": インターネット経由でアクセス可能なエンドポイント（デフォルト）
  #   - "VPC": VPC内でホストされるエンドポイント。NLBを介して公開可能
  #   - "VPC_ENDPOINT": 非推奨。既存のVPCエンドポイントを使用（後方互換性のみ）
  # 省略時: "PUBLIC"
  endpoint_type = "PUBLIC"

  #-------------------------------------------------------------
  # IDプロバイダー設定
  #-------------------------------------------------------------

  # identity_provider_type (Optional)
  # 設定内容: ユーザー認証に使用するIDプロバイダーの種類を指定します。
  # 設定可能な値:
  #   - "SERVICE_MANAGED": Transfer Familyがユーザー認証情報を管理（デフォルト）
  #   - "API_GATEWAY": Amazon API Gatewayエンドポイントを使用して認証
  #   - "AWS_DIRECTORY_SERVICE": AWS Managed Microsoft ADを使用して認証
  #   - "AWS_LAMBDA": Lambda関数を使用してカスタム認証
  # 省略時: "SERVICE_MANAGED"
  identity_provider_type = "SERVICE_MANAGED"

  # invocation_role (Optional)
  # 設定内容: identity_provider_typeが"API_GATEWAY"の場合に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: identity_provider_typeが"API_GATEWAY"の場合に必須
  invocation_role = null

  # url (Optional)
  # 設定内容: identity_provider_typeが"API_GATEWAY"の場合に使用するAPIエンドポイントURLを指定します。
  # 設定可能な値: 有効なAPI Gateway URLの文字列
  # 注意: identity_provider_typeが"API_GATEWAY"の場合に必須
  url = null

  # function (Optional)
  # 設定内容: identity_provider_typeが"AWS_LAMBDA"の場合に使用するLambda関数のARNを指定します。
  # 設定可能な値: 有効なLambda関数ARN
  # 注意: identity_provider_typeが"AWS_LAMBDA"の場合に必須
  function = null

  # directory_id (Optional)
  # 設定内容: identity_provider_typeが"AWS_DIRECTORY_SERVICE"の場合に使用するAWS Directory ServiceのディレクトリIDを指定します。
  # 設定可能な値: 有効なAWS Directory ServiceディレクトリID
  # 注意: identity_provider_typeが"AWS_DIRECTORY_SERVICE"の場合に必須
  directory_id = null

  # sftp_authentication_methods (Optional)
  # 設定内容: SFTPプロトコルに対して許可する認証方法を指定します。
  # 設定可能な値:
  #   - "PASSWORD": パスワード認証のみ許可
  #   - "PUBLIC_KEY": 公開鍵認証のみ許可
  #   - "PUBLIC_KEY_OR_PASSWORD": どちらの方法でも認証可能
  #   - "PUBLIC_KEY_AND_PASSWORD": 両方の認証を必須とする
  # 省略時: 認証方法に制限なし（サービスデフォルト）
  sftp_authentication_methods = null

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # security_policy_name (Optional)
  # 設定内容: サーバーに適用するセキュリティポリシー名を指定します。暗号化アルゴリズムやキー交換方式を制御します。
  # 設定可能な値: 有効なTransfer Familyセキュリティポリシー名（例: "TransferSecurityPolicy-2024-01"）
  # 省略時: AWSが管理するデフォルトポリシーを使用
  # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/security-policies.html
  security_policy_name = null

  # certificate (Optional)
  # 設定内容: FTPSプロトコルを使用する際のACM証明書ARNを指定します。
  # 設定可能な値: 有効なACM証明書ARN
  # 注意: protocolsに"FTPS"を含む場合に必須
  certificate = null

  # host_key (Optional)
  # 設定内容: サーバーのホスト秘密鍵をPEM形式で指定します。
  # 設定可能な値: PEM形式の秘密鍵文字列（機密情報）
  # 注意: この値はTerraform stateファイルに機密情報として保存されます
  host_key = null

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_role (Optional)
  # 設定内容: CloudWatch Logsへのログ送信に使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN（transfer.amazonaws.comへの信頼ポリシーが必要）
  # 省略時: ロギングは無効
  logging_role = null

  # structured_log_destinations (Optional)
  # 設定内容: 構造化ログを受信するCloudWatch Logsロググループのログストリームの宛先ARNのセットを指定します。
  # 設定可能な値: 有効なCloudWatch Logs宛先ARNのセット（最大1件）
  # 注意: logging_roleが設定されている必要があります
  structured_log_destinations = []

  #-------------------------------------------------------------
  # ログインバナー設定
  #-------------------------------------------------------------

  # pre_authentication_login_banner (Optional)
  # 設定内容: 認証前に表示するログインバナーテキストを指定します。
  # 設定可能な値: 4096文字以内の文字列（機密情報としてstateに保存）
  # 注意: SFTPプロトコルのみサポート
  pre_authentication_login_banner = null

  # post_authentication_login_banner (Optional)
  # 設定内容: 認証後に表示するログインバナーテキストを指定します。
  # 設定可能な値: 4096文字以内の文字列（機密情報としてstateに保存）
  # 注意: SFTPプロトコルのみサポート
  post_authentication_login_banner = null

  #-------------------------------------------------------------
  # ストレージドメイン設定
  #-------------------------------------------------------------

  # domain (Optional)
  # 設定内容: ファイル転送のバックエンドストレージドメインを指定します。
  # 設定可能な値:
  #   - "S3": Amazon S3をバックエンドストレージとして使用（デフォルト）
  #   - "EFS": Amazon EFSをバックエンドストレージとして使用
  # 省略時: "S3"
  # 注意: この属性はリソース作成後に変更できません（変更には再作成が必要）
  domain = "S3"

  #-------------------------------------------------------------
  # リソース管理設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: サーバー削除時にサーバー内のユーザーとキーを強制的に削除するかを指定します。
  # 設定可能な値:
  #   - true: ユーザーとキーが残っていても強制削除
  #   - false: ユーザーとキーが残っている場合は削除失敗
  # 省略時: false
  force_destroy = false

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
  # VPCエンドポイント詳細設定
  #-------------------------------------------------------------

  # endpoint_details (Optional)
  # 設定内容: VPCエンドポイントの詳細設定を指定するブロックです。
  # 注意: endpoint_typeが"VPC"または"VPC_ENDPOINT"の場合に使用します
  endpoint_details {

    # address_allocation_ids (Optional)
    # 設定内容: NLBのEIPに割り当てるElastic IP（EIP）アドレスのアロケーションIDのセットを指定します。
    # 設定可能な値: 有効なEIPアロケーションIDのセット
    # 注意: endpoint_typeが"VPC"の場合にのみ使用可能
    address_allocation_ids = []

    # security_group_ids (Optional)
    # 設定内容: VPCエンドポイントに関連付けるセキュリティグループIDのセットを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    # 注意: endpoint_typeが"VPC"の場合にのみ使用可能
    security_group_ids = ["sg-12345678"]

    # subnet_ids (Optional)
    # 設定内容: サーバーをホストするサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット（各AZに1つ）
    # 注意: endpoint_typeが"VPC"または"VPC_ENDPOINT"の場合に必須
    subnet_ids = ["subnet-12345678"]

    # vpc_id (Optional)
    # 設定内容: サーバーをホストするVPC IDを指定します。
    # 設定可能な値: 有効なVPC ID
    # 注意: endpoint_typeが"VPC"の場合に必須
    vpc_id = "vpc-12345678"

    # vpc_endpoint_id (Optional)
    # 設定内容: 既存のVPCエンドポイントIDを指定します。
    # 設定可能な値: 有効なVPCエンドポイントID（vpce-xxxxxxxxxx形式）
    # 注意: endpoint_typeが"VPC_ENDPOINT"の場合に使用。AWSにより自動的に設定されることもある
    vpc_endpoint_id = null
  }

  #-------------------------------------------------------------
  # プロトコル詳細設定
  #-------------------------------------------------------------

  # protocol_details (Optional)
  # 設定内容: プロトコルに関する追加設定を指定するブロックです。
  protocol_details {

    # as2_transports (Optional)
    # 設定内容: AS2プロトコルのトランスポートメカニズムのセットを指定します。
    # 設定可能な値:
    #   - "HTTP": HTTPトランスポートを使用
    # 省略時: サービスデフォルト値
    as2_transports = ["HTTP"]

    # passive_ip (Optional)
    # 設定内容: FTP/FTPSクライアントに返すパッシブモードのIPアドレスを指定します。
    # 設定可能な値: 有効なIPv4アドレス文字列（例: "0.0.0.0"）
    # 省略時: サービスデフォルト値
    passive_ip = "0.0.0.0"

    # set_stat_option (Optional)
    # 設定内容: SETSTAT操作（ファイル属性設定）の処理方法を指定します。
    # 設定可能な値:
    #   - "DEFAULT": デフォルト動作（SETSTATコマンドをそのまま実行）
    #   - "ENABLE_NO_OP": SETSTATコマンドを無視してエラーを返さない
    # 省略時: "DEFAULT"
    set_stat_option = "DEFAULT"

    # tls_session_resumption_mode (Optional)
    # 設定内容: FTPSのTLSセッション再開の処理方法を指定します。
    # 設定可能な値:
    #   - "DISABLED": TLSセッション再開を無効化
    #   - "ENABLED": TLSセッション再開を有効化（クライアントが再開を要求した場合のみ）
    #   - "ENFORCED": TLSセッション再開を強制（再開しないクライアントは拒否）
    # 省略時: "ENFORCED"
    tls_session_resumption_mode = "ENFORCED"
  }

  #-------------------------------------------------------------
  # S3ストレージオプション設定
  #-------------------------------------------------------------

  # s3_storage_options (Optional)
  # 設定内容: S3バックエンドのストレージオプションを指定するブロックです。
  # 注意: domainが"S3"の場合に使用します
  s3_storage_options {

    # directory_listing_optimization (Optional)
    # 設定内容: S3バケットのディレクトリリスティングのパフォーマンス最適化モードを指定します。
    # 設定可能な値:
    #   - "ENABLED": ディレクトリリスティングを最適化（S3 Expressや大規模バケット向け）
    #   - "DISABLED": 最適化なし（デフォルト動作）
    # 省略時: "DISABLED"
    directory_listing_optimization = "DISABLED"
  }

  #-------------------------------------------------------------
  # ワークフロー設定
  #-------------------------------------------------------------

  # workflow_details (Optional)
  # 設定内容: ファイルアップロード時に実行するTransfer Familyワークフローを指定するブロックです。
  # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/transfer-workflows.html
  workflow_details {

    # on_upload (Optional)
    # 設定内容: ファイルのアップロード完了時に実行するワークフローを指定するブロックです。
    on_upload {

      # execution_role (Required)
      # 設定内容: ワークフロー実行に使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN（transfer.amazonaws.comへの信頼ポリシーが必要）
      execution_role = "arn:aws:iam::123456789012:role/transfer-workflow-role"

      # workflow_id (Required)
      # 設定内容: 実行するTransfer FamilyワークフローのIDを指定します。
      # 設定可能な値: 有効なTransfer Familyワークフローid
      workflow_id = "w-12345678901234567"
    }

    # on_partial_upload (Optional)
    # 設定内容: ファイルのアップロードが部分的に完了した場合（中断・失敗時）に実行するワークフローを指定するブロックです。
    on_partial_upload {

      # execution_role (Required)
      # 設定内容: ワークフロー実行に使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN（transfer.amazonaws.comへの信頼ポリシーが必要）
      execution_role = "arn:aws:iam::123456789012:role/transfer-workflow-role"

      # workflow_id (Required)
      # 設定内容: 実行するTransfer FamilyワークフローのIDを指定します。
      # 設定可能な値: 有効なTransfer Familyワークフローid
      workflow_id = "w-12345678901234568"
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-transfer-server"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Transfer Familyサーバーの Amazon Resource Name (ARN)
# - id: Transfer FamilyサーバーのサーバーID（s-xxxxxxxxxxxxxxxxx形式）
# - endpoint: サーバーのエンドポイントホスト名
# - host_key_fingerprint: ホスト公開鍵のRSAフィンガープリント
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグマップ
#---------------------------------------------------------------
