#---------------------------------------------------------------
# AWS KMS Custom Key Store
#---------------------------------------------------------------
#
# AWS KMS（Key Management Service）のカスタムキーストアをプロビジョニングするリソースです。
# カスタムキーストアは、AWS管理のHSMではなく、ユーザーが所有・管理するキーストアを
# AWS KMSと連携させることができます。
# AWS CloudHSMクラスターを使用するタイプ（AWS_CLOUDHSM）と、
# AWSの外部にある外部キー管理システムを使用するタイプ（EXTERNAL_KEY_STORE）の
# 2種類をサポートしています。
#
# AWS公式ドキュメント:
#   - カスタムキーストア概要: https://docs.aws.amazon.com/kms/latest/developerguide/key-store-overview.html
#   - AWS CloudHSMキーストア: https://docs.aws.amazon.com/kms/latest/developerguide/keystore-cloudhsm.html
#   - 外部キーストア: https://docs.aws.amazon.com/kms/latest/developerguide/keystore-external.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_custom_key_store
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_custom_key_store" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # custom_key_store_name (Required)
  # 設定内容: カスタムキーストアの一意な名前を指定します。
  # 設定可能な値: 1-256文字の文字列。同一AWSアカウント・リージョン内で一意である必要があります。
  custom_key_store_name = "example-custom-key-store"

  # custom_key_store_type (Optional, Forces new resource)
  # 設定内容: 作成するキーストアのタイプを指定します。
  # 設定可能な値:
  #   - "AWS_CLOUDHSM": AWS CloudHSMクラスターをバッキングストアとして使用するキーストア
  #   - "EXTERNAL_KEY_STORE": AWSの外部にある外部キー管理システムを使用するキーストア
  # 省略時: "AWS_CLOUDHSM" が使用されます。
  # 注意: このパラメーターはリソース作成後に変更できません（再作成が必要）。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-store-overview.html
  custom_key_store_type = "AWS_CLOUDHSM"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # AWS CloudHSMキーストア設定
  # (custom_key_store_type = "AWS_CLOUDHSM" の場合に使用)
  #-------------------------------------------------------------

  # cloud_hsm_cluster_id (Optional)
  # 設定内容: CloudHSMクラスターのIDを指定します。
  # 設定可能な値: 有効なAWS CloudHSMクラスターID（例: "cluster-1234567890abcdef0"）
  # 省略時: null（custom_key_store_type が "AWS_CLOUDHSM" の場合は必須）
  # 注意: 指定するCloudHSMクラスターは、アクティブ状態であり、
  #       少なくとも2つのAZに1つ以上のアクティブHSMが必要です。
  #       また、他のカスタムキーストアに関連付けられていてはなりません。
  # 関連機能: AWS CloudHSMキーストア
  #   AWS KMSがCloudHSMクラスター内のkmsuser暗号ユーザーとしてログインし、
  #   キーマテリアルを作成・管理します。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/keystore-cloudhsm.html
  cloud_hsm_cluster_id = null

  # key_store_password (Optional)
  # 設定内容: AWS CloudHSMキーストアのkmsuser暗号ユーザーのパスワードを指定します。
  # 設定可能な値: CloudHSMクラスターのkmsuser CUアカウントのパスワード文字列
  # 省略時: null（custom_key_store_type が "AWS_CLOUDHSM" の場合は必須）
  # 注意: このパスワードは機密情報です。Terraformのstateファイルに平文で保存されるため、
  #       stateファイルのアクセス制御に注意してください。
  #       カスタムキーストアが接続されると、AWS KMSがkmsuser CUとしてログインし、
  #       パスワードを自動的にローテーションします。
  key_store_password = null

  # trust_anchor_certificate (Optional)
  # 設定内容: AWS CloudHSMキーストアに使用するトラストアンカー証明書を指定します。
  # 設定可能な値: CloudHSMクラスターのトラストアンカー証明書（PEM形式のX.509証明書）
  # 省略時: null（custom_key_store_type が "AWS_CLOUDHSM" の場合は必須）
  # 注意: 証明書は file() 関数などを使用してファイルから読み込むことができます。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/keystore-cloudhsm.html
  trust_anchor_certificate = null

  #-------------------------------------------------------------
  # 外部キーストア（XKS）設定
  # (custom_key_store_type = "EXTERNAL_KEY_STORE" の場合に使用)
  #-------------------------------------------------------------

  # xks_proxy_connectivity (Optional)
  # 設定内容: AWS KMSと外部キーストアプロキシ（XKSプロキシ）の通信方法を指定します。
  # 設定可能な値:
  #   - "PUBLIC_ENDPOINT": パブリックエンドポイント経由でXKSプロキシと通信します。
  #                        XKSプロキシのエンドポイントはインターネットからアクセス可能である必要があります。
  #   - "VPC_ENDPOINT_SERVICE": Amazon VPCエンドポイントサービス経由でXKSプロキシと通信します。
  #                              プライベートネットワーク内での通信が可能です。
  # 省略時: null（custom_key_store_type が "EXTERNAL_KEY_STORE" の場合は必須）
  # 関連機能: 外部キーストア
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/keystore-external.html
  xks_proxy_connectivity = null

  # xks_proxy_uri_endpoint (Optional)
  # 設定内容: AWS KMSがXKSプロキシへのリクエスト送信に使用するエンドポイントURIを指定します。
  # 設定可能な値: "https://" で始まるURIエンドポイント（例: "https://myproxy.xks.example.com"）
  # 省略時: null（custom_key_store_type が "EXTERNAL_KEY_STORE" の場合は必須）
  # 注意: URIにはパスやクエリ文字列を含めないでください。xks_proxy_uri_path で指定します。
  #       xks_proxy_connectivity が "PUBLIC_ENDPOINT" の場合、このエンドポイントは
  #       インターネットからアクセス可能である必要があります。
  xks_proxy_uri_endpoint = null

  # xks_proxy_uri_path (Optional)
  # 設定内容: 外部キーストアのプロキシAPIへのベースパスを指定します。
  # 設定可能な値: "/kms/xks/v1" 形式のパス文字列
  # 省略時: null（custom_key_store_type が "EXTERNAL_KEY_STORE" の場合は必須）
  # 注意: このパスはXKSプロキシのドキュメントを参照して設定してください。
  xks_proxy_uri_path = null

  # xks_proxy_vpc_endpoint_service_name (Optional)
  # 設定内容: XKSプロキシとの通信に使用するAmazon VPCエンドポイントサービスの名前を指定します。
  # 設定可能な値: VPCエンドポイントサービス名（例: "com.amazonaws.vpce.us-east-1.vpce-svc-example"）
  # 省略時: null（xks_proxy_connectivity が "VPC_ENDPOINT_SERVICE" の場合は必須）
  # 注意: xks_proxy_connectivity が "VPC_ENDPOINT_SERVICE" の場合のみ使用します。
  xks_proxy_vpc_endpoint_service_name = null

  #-------------------------------------------------------------
  # XKSプロキシ認証情報設定
  # (custom_key_store_type = "EXTERNAL_KEY_STORE" の場合に使用)
  #-------------------------------------------------------------

  # xks_proxy_authentication_credential (Optional)
  # 設定内容: 外部キーストアプロキシ（XKSプロキシ）の認証情報の設定ブロックです。
  # 省略時: null（custom_key_store_type が "EXTERNAL_KEY_STORE" の場合は必須）
  # 関連機能: 外部キーストアプロキシ認証
  #   AWS KMSはSigV4署名でXKSプロキシへのリクエストに署名します。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/keystore-external.html
  xks_proxy_authentication_credential {

    # access_key_id (Required)
    # 設定内容: RAWシークレットアクセスキーの一意の識別子を指定します。
    # 設定可能な値: 大文字の英字またはデジタル文字で構成される20-30文字の文字列
    access_key_id = "ABCDE12345670EXAMPLE"

    # raw_secret_access_key (Required)
    # 設定内容: XKSプロキシの認証に使用するシークレット文字列を指定します。
    # 設定可能な値: 43-64文字の文字列
    # 注意: この値は機密情報です。Terraformのstateファイルに平文で保存されるため、
    #       stateファイルのアクセス制御に注意してください。
    raw_secret_access_key = "Example-RAW-Secret-Access-Key-43-to-64-chars"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列形式（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = "15m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列形式（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    update = "15m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration文字列形式（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = "15m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: カスタムキーストアのID（custom_key_store_id と同じ値）
#---------------------------------------------------------------
