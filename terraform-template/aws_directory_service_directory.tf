#---------------------------------------------------------------
# AWS Directory Service Directory
#---------------------------------------------------------------
#
# AWS Directory Service の Simple AD、AWS Managed Microsoft AD、
# または AD Connector ディレクトリをプロビジョニングするリソースです。
#
# ディレクトリタイプ:
#   1. SimpleAD: Samba 4 をベースとした軽量なディレクトリサービス
#   2. MicrosoftAD: AWS が運用管理する Microsoft Active Directory
#   3. ADConnector: 既存のオンプレミス Active Directory への接続コネクタ
#
# 重要: パスワードを含む全ての引数は Terraform state ファイルに
#       プレーンテキストで保存されます。
#       https://developer.hashicorp.com/terraform/language/state/sensitive-data
#
# AWS公式ドキュメント:
#   - Directory Service とは: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html
#   - Simple AD: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_simple_ad.html
#   - AWS Managed Microsoft AD: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_microsoft_ad.html
#   - AD Connector: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_ad_connector.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_directory_service_directory" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ディレクトリの完全修飾ドメイン名 (FQDN) を指定します。
  # 設定可能な値: 有効なドメイン名 (例: corp.example.com)
  # 注意: 作成後の変更は不可（変更時はリソース再作成）
  # 関連機能: ディレクトリの DNS 名として使用され、ドメイン参加時に指定する値
  name = "corp.example.com"

  # password (Required, Sensitive)
  # 設定内容: ディレクトリ管理者またはオンプレミス AD 接続用ユーザーのパスワードを指定します。
  # 設定可能な値:
  #   - SimpleAD: Administrator アカウントのパスワード
  #   - MicrosoftAD: Admin アカウントのパスワード
  #   - ADConnector: オンプレミス AD のサービスアカウントのパスワード
  # 注意: state ファイルにプレーンテキストで保存されるため、機密情報の取り扱いに注意してください
  # 推奨: AWS Secrets Manager や環境変数経由での値注入を推奨
  password = "SuperSecretPassw0rd!"

  # short_name (Optional, Forces new resource)
  # 設定内容: ディレクトリの NetBIOS 名（ショートネーム）を指定します。
  # 設定可能な値: 最大15文字の英数字（例: CORP）
  # 省略時: ドメイン名の最初のラベルから自動生成（例: corp.example.com → CORP）
  # 関連機能: Windows ネットワーク上でドメインを識別する短縮名として利用されます
  short_name = "CORP"

  # description (Optional, Forces new resource)
  # 設定内容: ディレクトリの説明テキストを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Corporate directory for example.com"

  #-------------------------------------------------------------
  # ディレクトリタイプ設定
  #-------------------------------------------------------------

  # type (Optional, Forces new resource)
  # 設定内容: 作成するディレクトリのタイプを指定します。
  # 設定可能な値:
  #   - "SimpleAD": Samba 4 ベースの軽量ディレクトリ
  #   - "MicrosoftAD": AWS Managed Microsoft AD
  #   - "ADConnector": オンプレミス AD への接続コネクタ
  # 省略時: "SimpleAD"
  # 関連機能: ディレクトリタイプにより必要な設定ブロックが異なります
  #   - SimpleAD / MicrosoftAD: vpc_settings ブロックが必須
  #   - ADConnector: connect_settings ブロックが必須
  type = "SimpleAD"

  # size (Optional, Forces new resource)
  # 設定内容: ディレクトリのサイズを指定します（SimpleAD と ADConnector で使用）。
  # 設定可能な値:
  #   - "Small": 小規模環境向け（最大500ユーザー）
  #   - "Large": 大規模環境向け（最大5,000ユーザー）
  # 省略時: API側で決定された値（typeによる）
  # 注意: MicrosoftAD タイプでは size を指定せず edition を使用します
  size = "Small"

  # edition (Optional, Forces new resource)
  # 設定内容: AWS Managed Microsoft AD のエディションを指定します（MicrosoftAD タイプ専用）。
  # 設定可能な値:
  #   - "Standard": 標準エディション（最大30,000オブジェクト、小～中規模向け）
  #   - "Enterprise": エンタープライズエディション（最大500,000オブジェクト、大規模向け）
  # 省略時: API側で決定された値
  # 注意: SimpleAD / ADConnector では指定しないでください
  edition = null

  #-------------------------------------------------------------
  # ディレクトリ拡張設定
  #-------------------------------------------------------------

  # alias (Optional, Forces new resource)
  # 設定内容: ディレクトリの一意なエイリアスを指定します。
  # 設定可能な値: AWS 全体で一意のエイリアス文字列
  # 省略時: ディレクトリ ID がエイリアスとして使用されます
  # 関連機能:
  #   - アクセス URL（https://<alias>.awsapps.com）の生成
  #   - enable_sso を有効化する際に必要
  # 注意: 一度設定したエイリアスは変更不可
  alias = null

  # enable_sso (Optional)
  # 設定内容: ディレクトリのシングルサインオン (SSO) を有効化するかを指定します。
  # 設定可能な値:
  #   - true: SSO を有効化
  #   - false: SSO を無効化
  # 省略時: false
  # 前提条件: alias の設定または自動生成済みであること
  # 関連機能: AWS アプリケーション (WorkDocs / WorkMail 等) への SSO ログインを実現
  #   - https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_single_sign_on.html
  enable_sso = false

  # enable_directory_data_access (Optional)
  # 設定内容: Directory Service Data API によるディレクトリデータへのアクセスを有効化するかを指定します。
  # 設定可能な値:
  #   - true: Directory Service Data API を有効化（ユーザー / グループのプログラム的管理が可能）
  #   - false: Directory Service Data API を無効化
  # 省略時: false
  # 関連機能: AWS Directory Service Data API
  #   AWS Managed Microsoft AD のユーザー、グループ、メンバーシップを API 経由で管理可能にします。
  #   - https://docs.aws.amazon.com/directoryservice/latest/devguide/what_is_dsd.html
  # 注意: MicrosoftAD タイプでのみ有効
  enable_directory_data_access = false

  # desired_number_of_domain_controllers (Optional)
  # 設定内容: ディレクトリに配置するドメインコントローラーの数を指定します。
  # 設定可能な値: 2 以上の整数
  # 省略時: 2（最小値）
  # 注意: MicrosoftAD タイプでのみ有効。SimpleAD / ADConnector では設定不可
  # 関連機能: ドメインコントローラーを追加することでパフォーマンス・可用性を向上
  #   - https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_deploy_additional_dcs.html
  desired_number_of_domain_controllers = 2

  #-------------------------------------------------------------
  # VPC設定 (SimpleAD / MicrosoftAD で必須)
  #-------------------------------------------------------------

  # vpc_settings (Required for SimpleAD and MicrosoftAD)
  # 設定内容: ディレクトリを配置する VPC とサブネットを指定する設定ブロックです。
  # 注意: ADConnector タイプの場合は vpc_settings ではなく connect_settings を使用してください
  vpc_settings {

    # vpc_id (Required)
    # 設定内容: ディレクトリを配置する VPC の ID を指定します。
    # 設定可能な値: 有効な VPC ID
    vpc_id = "vpc-12345678"

    # subnet_ids (Required)
    # 設定内容: ドメインコントローラーを配置するサブネット ID のセットを指定します。
    # 設定可能な値: 異なる 2 つのアベイラビリティゾーンに属する 2 つのサブネット ID
    # 注意: 同一 VPC 内で異なる AZ のサブネットを 2 つ指定する必要があります
    # 関連機能: 高可用性のため複数 AZ にドメインコントローラーが分散配置されます
    subnet_ids = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]
  }

  #-------------------------------------------------------------
  # 接続設定 (ADConnector で必須)
  #-------------------------------------------------------------

  # connect_settings (Required for ADConnector)
  # 設定内容: AD Connector がオンプレミス AD に接続するための設定ブロックです。
  # 注意: type = "ADConnector" の場合に必須。SimpleAD / MicrosoftAD の場合は使用しません
  connect_settings {

    # vpc_id (Required)
    # 設定内容: AD Connector を配置する VPC の ID を指定します。
    # 設定可能な値: オンプレミス AD と通信可能な VPC の ID
    vpc_id = "vpc-12345678"

    # subnet_ids (Required)
    # 設定内容: AD Connector を配置するサブネット ID のセットを指定します。
    # 設定可能な値: 異なる 2 つのアベイラビリティゾーンのサブネット ID
    subnet_ids = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]

    # customer_dns_ips (Required)
    # 設定内容: 接続先オンプレミス AD の DNS サーバー IP アドレスを指定します。
    # 設定可能な値: IPv4 アドレスのセット
    # 関連機能: AD Connector はこの DNS サーバーを介してオンプレミス AD に解決を行います
    customer_dns_ips = ["10.0.0.1", "10.0.0.2"]

    # customer_username (Required)
    # 設定内容: オンプレミス AD への接続に使用するユーザーアカウント名を指定します。
    # 設定可能な値: オンプレミス AD の有効なユーザー名
    # 注意: 該当ユーザーには所定の権限（ユーザー / コンピュータ オブジェクト読み取り等）が必要
    #   - https://docs.aws.amazon.com/directoryservice/latest/admin-guide/prereq_connector.html
    customer_username = "Admin"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-directory"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定する設定ブロックです。
  # 関連機能: ディレクトリの作成 / 削除には数十分要するため、長めのタイムアウト指定を推奨
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Go duration 形式の文字列（例: "60m", "1h"）
    # 省略時: プロバイダー既定値
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Go duration 形式の文字列（例: "60m", "1h"）
    # 省略時: プロバイダー既定値
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Go duration 形式の文字列（例: "60m", "1h"）
    # 省略時: プロバイダー既定値
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディレクトリの識別子（例: d-1234567890）
# - access_url: ディレクトリのアクセス URL（<alias>.awsapps.com 形式）
# - dns_ip_addresses: ディレクトリの DNS サーバー IP アドレスのセット
# - security_group_id: ディレクトリ用に作成されたセキュリティグループ ID
# - vpc_settings.availability_zones: ドメインコントローラー配置 AZ のセット
# - connect_settings.connect_ips: AD Connector サーバーの IP アドレスのセット
# - connect_settings.availability_zones: AD Connector 配置 AZ のセット
# - tags_all: 継承タグを含む全タグマップ
#---------------------------------------------------------------
