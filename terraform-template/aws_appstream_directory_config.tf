#---------------------------------------------------------------
# AWS AppStream Directory Config
#---------------------------------------------------------------
#
# Amazon AppStream 2.0のディレクトリ設定をプロビジョニングするリソースです。
# このリソースは、AppStream 2.0フリートおよびイメージビルダーを
# Microsoft Active Directoryドメインに参加させるための設定情報を定義します。
#
# AWS公式ドキュメント:
#   - AppStream 2.0とActive Directoryの統合: https://docs.aws.amazon.com/appstream2/latest/developerguide/active-directory.html
#   - 証明書ベース認証: https://docs.aws.amazon.com/appstream2/latest/developerguide/certificate-based-authentication.html
#   - DirectoryConfig API: https://docs.aws.amazon.com/appstream2/latest/APIReference/API_DirectoryConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appstream_directory_config
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appstream_directory_config" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # directory_name (Required)
  # 設定内容: ディレクトリの完全修飾名（FQDN）を指定します。
  # 設定可能な値: 有効なActive Directoryドメイン名（例: corp.example.com）
  # 注意: AWS Directory ServiceまたはオンプレミスのActive Directoryドメイン名を指定
  directory_name = "corp.example.com"

  # organizational_unit_distinguished_names (Required)
  # 設定内容: コンピューターアカウント用の組織単位（OU）の識別名を指定します。
  # 設定可能な値: 有効なOU識別名のセット
  #   例: ["OU=AppStream,OU=Computers,DC=corp,DC=example,DC=com"]
  # 関連機能: Active Directory組織単位
  #   AppStream 2.0インスタンスのコンピューターオブジェクトが作成されるOUを指定。
  #   各AppStream 2.0スタックごとに専用のOUを使用することが推奨されます。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/active-directory-admin.html
  organizational_unit_distinguished_names = [
    "OU=AppStream,OU=Computers,DC=corp,DC=example,DC=com"
  ]

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
  # サービスアカウント認証情報
  #-------------------------------------------------------------

  # service_account_credentials (Required)
  # 設定内容: Active Directoryドメインへの参加に使用するサービスアカウントの認証情報を指定します。
  # 関連機能: サービスアカウント
  #   このアカウントには以下の権限が必要です:
  #   - コンピューターオブジェクトの作成
  #   - コンピューターのドメイン参加
  #   - 指定されたOU内のコンピューターオブジェクトのパスワード変更/リセット
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/active-directory-admin.html
  service_account_credentials {
    # account_name (Required)
    # 設定内容: サービスアカウントのユーザー名を指定します。
    # 設定可能な値: Active Directoryのユーザー名
    #   例: "svc-appstream" または "DOMAIN\\svc-appstream"
    # 注意: このアカウントには上記の権限が必要
    account_name = "svc-appstream"

    # account_password (Required, Sensitive)
    # 設定内容: サービスアカウントのパスワードを指定します。
    # 設定可能な値: サービスアカウントの有効なパスワード
    # 注意: 機密情報のため、変数やSecrets Managerの使用を推奨
    account_password = var.service_account_password
  }

  #-------------------------------------------------------------
  # 証明書ベース認証設定
  #-------------------------------------------------------------

  # certificate_based_auth_properties (Optional)
  # 設定内容: SAML 2.0 IdPユーザーIDをActive Directoryドメイン参加済み
  #          ストリーミングインスタンスに認証するための証明書ベース認証プロパティを指定します。
  # 関連機能: 証明書ベース認証（CBA）
  #   ユーザーはSAML 2.0 IDプロバイダーのセキュリティ機能（パスワードレス認証など）を使用して
  #   AppStream 2.0リソースにアクセス可能。Active Directoryへの個別のパスワード入力が不要となり、
  #   シングルサインオン体験を提供します。
  #   - https://docs.aws.amazon.com/appstream2/latest/developerguide/certificate-based-authentication.html
  #   - https://docs.aws.amazon.com/appstream2/latest/APIReference/API_CertificateBasedAuthProperties.html
  certificate_based_auth_properties {
    # certificate_authority_arn (Optional)
    # 設定内容: AWS Certificate Manager Private CAリソースのARNを指定します。
    # 設定可能な値: 有効なACM Private CA ARN
    #   例: arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012
    # 注意: Private CAは同じAWSアカウントおよびリージョンに存在し、
    #       `euc-private-ca`というキー名のタグが必要
    certificate_authority_arn = "arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"

    # status (Optional)
    # 設定内容: 証明書ベース認証のステータスを指定します。
    # 設定可能な値:
    #   - "DISABLED": 証明書ベース認証を無効化
    #   - "ENABLED": 証明書ベース認証を有効化（フォールバック認証あり）
    #       認証失敗時やデスクトップロック画面解除時にADドメインパスワードでログイン可能
    #   - "ENABLED_NO_DIRECTORY_LOGIN_FALLBACK": 証明書ベース認証を有効化（フォールバックなし）
    #       認証失敗時にADドメインパスワードでのログイン不可
    # 注意: フォールバック無効時、ロック画面やWindowsログオフ発生時にセッションが切断される可能性あり
    status = "ENABLED"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AppStreamディレクトリ設定の一意の識別子（ID）
#
# - created_time: ディレクトリ設定が作成された日時
#                 （UTCおよび拡張RFC 3339形式）
#---------------------------------------------------------------
