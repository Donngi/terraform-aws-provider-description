#---------------------------------------------------------------
# AWS Transfer Family Connector
#---------------------------------------------------------------
#
# AWS Transfer Familyのコネクターをプロビジョニングするリソースです。
# AS2プロトコルまたはSFTPプロトコルを使用して外部サーバーとの
# ファイル転送接続を確立します。
#
# AWS公式ドキュメント:
#   - AWS Transfer Family Connectors: https://docs.aws.amazon.com/transfer/latest/userguide/connectors.html
#   - AS2 Connectors: https://docs.aws.amazon.com/transfer/latest/userguide/create-b2b-server.html
#   - SFTP Connectors: https://docs.aws.amazon.com/transfer/latest/userguide/API_SftpConnectorConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_connector
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_connector" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # access_role (Required)
  # 設定内容: StartFileTransferリクエストで指定されたファイルの親ディレクトリへの
  #          読み取り/書き込みアクセスを提供するIAMロールを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: コネクターがファイル転送を実行するために必要な権限を持つロールを指定してください
  # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/connectors-iam.html
  access_role = "arn:aws:iam::123456789012:role/transfer-connector-role"

  # url (Optional)
  # 設定内容: パートナーのAS2エンドポイントまたはSFTPエンドポイントのURLを指定します。
  # 設定可能な値:
  #   - AS2コネクター: http://またはhttps://で始まるURL
  #   - SFTPコネクター: sftp://で始まるURL
  # 注意:
  #   - AS2コネクターおよびサービスマネージド型SFTPコネクターでは必須
  #   - VPC Lattice egress設定を使用する場合はnullを指定（エンドポイントはVPC Latticeで指定）
  url = "https://partner.example.com/as2"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # security_policy_name (Optional)
  # 設定内容: コネクターに使用するセキュリティポリシーの名前を指定します。
  # 設定可能な値: 有効なTransfer Familyセキュリティポリシー名
  # 省略時: デフォルトのセキュリティポリシーが使用されます
  # 関連機能: Transfer Family セキュリティポリシー
  #   暗号化アルゴリズムやプロトコルオプションを定義するポリシー。
  #   コネクションのセキュリティ要件に応じて選択します。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/security-policies.html
  security_policy_name = null

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_role (Optional)
  # 設定内容: Amazon S3イベントのCloudWatchロギングを有効にするために必要なIAMロールを指定します。
  # 設定可能な値: CloudWatch Logsへの書き込み権限を持つIAMロールARN
  # 省略時: ロギングは無効
  # 関連機能: Transfer Family ロギング
  #   ファイル転送操作の詳細なログをCloudWatch Logsに記録。
  #   監査やトラブルシューティングに有用。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/monitoring.html
  logging_role = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-connector"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # プロトコル設定 - AS2
  #-------------------------------------------------------------
  # 注意: as2_configとsftp_configは排他的です。どちらか一方のみを指定してください。

  # as2_config (Optional)
  # 設定内容: AS2プロトコルを使用するコネクターのパラメーターを設定します。
  # 注意: SFTPコネクター（sftp_config）とは排他的
  as2_config {
    # compression (Required)
    # 設定内容: AS2ファイルを圧縮するかどうかを指定します。
    # 設定可能な値:
    #   - "ZLIB": ファイルを圧縮
    #   - "DISABLED": 圧縮を無効化
    compression = "DISABLED"

    # encryption_algorithm (Required)
    # 設定内容: ファイルの暗号化に使用するアルゴリズムを指定します。
    # 設定可能な値:
    #   - "AES128_CBC": AES 128ビットCBC暗号化
    #   - "AES192_CBC": AES 192ビットCBC暗号化
    #   - "AES256_CBC": AES 256ビットCBC暗号化
    #   - "NONE": 暗号化なし
    # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/as2-encryption.html
    encryption_algorithm = "AES256_CBC"

    # local_profile_id (Required)
    # 設定内容: AS2ローカルプロファイルの一意の識別子を指定します。
    # 設定可能な値: aws_transfer_profileリソースのprofile_id
    # 注意: 事前にAS2プロファイルを作成しておく必要があります
    local_profile_id = "p-1234567890abcdef0"

    # mdn_response (Required)
    # 設定内容: 転送に対するパートナー応答が同期または非同期かを指定します。
    # 設定可能な値:
    #   - "SYNC": 同期応答（MDNをHTTP応答として即座に受信）
    #   - "NONE": MDN応答なし
    # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/as2-mdn.html
    mdn_response = "SYNC"

    # mdn_signing_algorithm (Optional)
    # 設定内容: MDN応答の署名アルゴリズムを指定します。
    # 設定可能な値:
    #   - "SHA256": SHA-256ハッシュアルゴリズム
    #   - "SHA384": SHA-384ハッシュアルゴリズム
    #   - "SHA512": SHA-512ハッシュアルゴリズム
    #   - "SHA1": SHA-1ハッシュアルゴリズム（非推奨）
    #   - "NONE": 署名なし
    #   - "DEFAULT": デフォルト設定を使用
    # 省略時: 署名なし
    mdn_signing_algorithm = "SHA256"

    # message_subject (Optional)
    # 設定内容: コネクターで送信されるAS2メッセージのHTTPヘッダー属性（Subject）として使用される値を指定します。
    # 設定可能な値: 任意の文字列
    # 省略時: 件名は設定されません
    message_subject = "File Transfer from Company A"

    # partner_profile_id (Required)
    # 設定内容: AS2パートナープロファイルの一意の識別子を指定します。
    # 設定可能な値: aws_transfer_profileリソースのprofile_id
    # 注意: 事前にパートナーのAS2プロファイルを作成しておく必要があります
    partner_profile_id = "p-0987654321fedcba0"

    # signing_algorithm (Required)
    # 設定内容: コネクターで送信されるAS2メッセージの署名に使用するアルゴリズムを指定します。
    # 設定可能な値:
    #   - "SHA256": SHA-256ハッシュアルゴリズム
    #   - "SHA384": SHA-384ハッシュアルゴリズム
    #   - "SHA512": SHA-512ハッシュアルゴリズム
    #   - "SHA1": SHA-1ハッシュアルゴリズム（非推奨）
    #   - "NONE": 署名なし
    # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/as2-digital-signing.html
    signing_algorithm = "SHA256"
  }

  #-------------------------------------------------------------
  # プロトコル設定 - SFTP
  #-------------------------------------------------------------
  # 注意: as2_configとsftp_configは排他的です。どちらか一方のみを指定してください。

  # sftp_config (Optional)
  # 設定内容: SFTPプロトコルを使用するコネクターのパラメーターを設定します。
  # 注意: AS2コネクター（as2_config）とは排他的
  # sftp_config {
  #   # trusted_host_keys (Optional)
  #   # 設定内容: 接続先の外部サーバーの認証に使用するホストキーの公開部分のリストを指定します。
  #   # 設定可能な値: SSH公開鍵の文字列のセット（ssh-rsa、ssh-ed25519等）
  #   # 注意: サーバーのホストキーと一致する必要があります
  #   # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/API_SftpConnectorConfig.html
  #   trusted_host_keys = [
  #     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB..."
  #   ]
  #
  #   # user_secret_id (Optional)
  #   # 設定内容: SFTPユーザーの秘密鍵、パスワード、またはその両方を含むシークレットの識別子を指定します。
  #   # 設定可能な値:
  #   #   - AWS Secrets ManagerのシークレットARN
  #   #   - シークレット名
  #   # 注意: 指定したシークレットには適切なアクセス権限が必要
  #   # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/requirements-sftp-connector.html
  #   user_secret_id = "arn:aws:secretsmanager:us-east-1:123456789012:secret:sftp-credentials"
  # }

  #-------------------------------------------------------------
  # Egress設定（VPC Lattice経由のプライベート接続）
  #-------------------------------------------------------------

  # egress_config (Optional)
  # 設定内容: VPC Latticeを使用してカスタマーVPC経由でトラフィックをルーティングするための
  #          egress設定を指定します。プライベート接続を有効化します。
  # 注意: この設定を使用する場合、urlパラメーターはnullに設定する必要があります
  # egress_config {
  #   # vpc_lattice (Optional)
  #   # 設定内容: カスタマーVPC経由でコネクタートラフィックをルーティングするためのVPC Lattice設定を指定します。
  #   vpc_lattice {
  #     # resource_configuration_arn (Required)
  #     # 設定内容: ターゲットSFTPサーバーの場所を定義するVPC Latticeリソース設定のARNを指定します。
  #     # 設定可能な値: 有効なVPC LatticeリソースコンフィギュレーションARN
  #     # 注意:
  #     #   - SFTPサーバーへの適切なネットワーク接続を持つVPC内の有効なリソース設定を指す必要があります
  #     #   - リソース設定は事前に作成しておく必要があります
  #     # 参考: https://docs.aws.amazon.com/vpc-lattice/latest/ug/resource-configurations.html
  #     resource_configuration_arn = "arn:aws:vpc-lattice:us-east-1:123456789012:resourceconfiguration/rcfg-12345678901234567"
  #
  #     # port_number (Optional)
  #     # 設定内容: VPC Lattice経由でSFTPサーバーに接続するためのポート番号を指定します。
  #     # 設定可能な値: 1〜65535の整数
  #     # 省略時: 22（標準のSFTPポート）
  #     # 注意: ターゲットSFTPサーバーがリッスンしているポートと一致する必要があります
  #     port_number = 22
  #   }
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   create = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除操作のタイムアウト時間を指定します。
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値が使用されます
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コネクターのAmazon Resource Name (ARN)
#
# - connector_id: AS2プロファイルまたはSFTPプロファイルの一意の識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
