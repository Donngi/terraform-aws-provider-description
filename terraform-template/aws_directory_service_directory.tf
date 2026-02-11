#---------------------------------------------------------------
# AWS Directory Service Directory
#---------------------------------------------------------------
#
# AWS Directory Service で Simple AD または Managed Microsoft AD ディレクトリ、
# または Active Directory Connector を管理するリソースです。
#
# ディレクトリタイプ:
#   1. SimpleAD: Samba 4 ベースの軽量なディレクトリサービス
#   2. MicrosoftAD: AWS マネージド Microsoft Active Directory
#   3. ADConnector: オンプレミス Active Directory への接続コネクタ
#
# 重要: パスワードとカスタマーユーザー名を含むすべての引数は、
#       Terraform の state ファイルにプレーンテキストで保存されます。
#       https://www.terraform.io/docs/state/sensitive-data.html
#
# AWS公式ドキュメント:
#   - Directory Service 概要: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html
#   - Simple AD: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_simple_ad.html
#   - Managed Microsoft AD: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_microsoft_ad.html
#   - AD Connector: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_ad_connector.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_directory_service_directory" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ディレクトリの完全修飾ドメイン名 (FQDN) を指定します。
  # 設定可能な値: 有効なドメイン名 (例: corp.example.com)
  # 関連機能: ディレクトリのDNS名として使用され、ドメイン参加時に指定
  # 注意: 作成後は変更不可。変更する場合はディレクトリの再作成が必要
  name = "corp.example.com"

  # password (Required, Sensitive)
  # 設定内容: ディレクトリ管理者またはコネクタユーザーのパスワードを指定します。
  # 設定可能な値: ディレクトリタイプに応じたパスワード要件を満たす文字列
  # 注意:
  #   - SimpleAD: Administratorアカウントのパスワード
  #   - MicrosoftAD: Admin アカウントのパスワード
  #   - ADConnector: オンプレミスADのユーザーパスワード
  #   - state ファイルにプレーンテキストで保存されます
  # 推奨: AWS Secrets Manager または環境変数から取得することを推奨
  password = "SuperSecretPassw0rd"

  #-------------------------------------------------------------
  # ディレクトリタイプ設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: 作成するディレクトリのタイプを指定します。
  # 設定可能な値:
  #   - "SimpleAD": Samba 4 ベースの軽量ディレクトリ (デフォルト)
  #   - "MicrosoftAD": AWS マネージド Microsoft Active Directory
  #   - "ADConnector": オンプレミス AD への接続コネクタ
  # 省略時: "SimpleAD"
  # 関連機能: ディレクトリタイプに応じて必要な設定が異なる
  #   - SimpleAD/MicrosoftAD: vpc_settings が必須
  #   - ADConnector: connect_settings が必須
  type = "SimpleAD"

  # size (Optional, Computed)
  # 設定内容: ディレクトリのサイズを指定します (SimpleAD および ADConnector 用)。
  # 設定可能な値:
  #   - "Small": 小規模環境向け (最大500ユーザー)
  #   - "Large": 大規模環境向け (最大5000ユーザー)
  # 省略時: "Large"
  # 注意: MicrosoftAD では edition を使用し、size は使用しません
  # 関連機能: ディレクトリの容量とパフォーマンスに影響
  size = "Small"

  # edition (Optional, Computed)
  # 設定内容: Managed Microsoft AD のエディションを指定します (MicrosoftAD タイプのみ)。
  # 設定可能な値:
  #   - "Standard": 標準エディション (最大30,000オブジェクト)
  #   - "Enterprise": エンタープライズエディション (最大500,000オブジェクト)
  # 省略時: "Enterprise"
  # 注意: SimpleAD および ADConnector では使用しない (size を使用)
  # 関連機能: 大規模な組織やマルチリージョンレプリケーションが必要な場合は Enterprise を推奨
  edition = null

  #-------------------------------------------------------------
  # ディレクトリ詳細設定
  #-------------------------------------------------------------

  # short_name (Optional, Computed)
  # 設定内容: ディレクトリの NetBIOS 名を指定します。
  # 設定可能な値: 最大15文字の英数字 (例: CORP)
  # 省略時: ドメイン名の最初の部分から自動生成
  # 関連機能: Windows ネットワーク上でのディレクトリ識別名として使用
  short_name = "CORP"

  # description (Optional)
  # 設定内容: ディレクトリの説明テキストを指定します。
  # 設定可能な値: 任意の文字列
  # 用途: 管理目的でのディレクトリの識別や説明
  description = "Corporate directory for example.com"

  # alias (Optional, Computed)
  # 設定内容: ディレクトリのエイリアスを指定します。
  # 設定可能な値: AWS全体で一意のエイリアス名
  # 関連機能:
  #   - アクセスURL (https://<alias>.awsapps.com) の生成に使用
  #   - enable_sso を有効にする場合は必須
  # 注意: 作成後は変更不可
  alias = null

  # enable_sso (Optional)
  # 設定内容: ディレクトリのシングルサインオン (SSO) を有効にするかを指定します。
  # 設定可能な値:
  #   - true: SSO を有効化
  #   - false: SSO を無効化 (デフォルト)
  # 前提条件: alias の設定が必須
  # 関連機能: AWS マネジメントコンソールへの SSO ログインを可能にする
  enable_sso = false

  # desired_number_of_domain_controllers (Optional, Computed)
  # 設定内容: ディレクトリに必要なドメインコントローラーの数を指定します。
  # 設定可能な値: 2以上の整数
  # 省略時: デフォルト値 (通常は2)
  # 注意: MicrosoftAD ディレクトリでのみドメインコントローラーのスケーリングをサポート
  # 関連機能: 高可用性とパフォーマンスのためにドメインコントローラーを追加
  desired_number_of_domain_controllers = null

  #-------------------------------------------------------------
  # VPC設定 (SimpleAD および MicrosoftAD で必須)
  #-------------------------------------------------------------

  # vpc_settings (Required for SimpleAD and MicrosoftAD)
  # 設定内容: ディレクトリを配置する VPC の設定を指定します。
  # 注意: ADConnector では connect_settings を使用
  vpc_settings {
    # vpc_id (Required)
    # 設定内容: ディレクトリを配置する VPC の ID を指定します。
    # 設定可能な値: 有効な VPC ID
    # 関連機能: ディレクトリサーバーがこの VPC 内に作成されます
    vpc_id = "vpc-12345678"

    # subnet_ids (Required)
    # 設定内容: ディレクトリサーバーを配置するサブネット ID を指定します。
    # 設定可能な値: 2つの異なるアベイラビリティゾーンのサブネット ID のセット
    # 関連機能: 高可用性のため、2つの異なる AZ にドメインコントローラーを配置
    # 注意: サブネットは同じ VPC 内に存在し、異なる AZ にある必要があります
    subnet_ids = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]

    # availability_zones (Computed)
    # 読み取り専用: サブネットが配置されているアベイラビリティゾーン
  }

  #-------------------------------------------------------------
  # 接続設定 (ADConnector で必須)
  #-------------------------------------------------------------

  # connect_settings (Required for ADConnector)
  # 設定内容: AD Connector の接続設定を指定します。
  # 注意: SimpleAD および MicrosoftAD では vpc_settings を使用
  # ADConnector タイプの場合のみコメントを解除して使用:
  #
  # connect_settings {
  #   # vpc_id (Required)
  #   # 設定内容: AD Connector を配置する VPC の ID を指定します。
  #   vpc_id = "vpc-12345678"
  #
  #   # subnet_ids (Required)
  #   # 設定内容: AD Connector を配置するサブネット ID を指定します。
  #   # 注意: 2つの異なるアベイラビリティゾーンのサブネットが必要
  #   subnet_ids = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]
  #
  #   # customer_dns_ips (Required)
  #   # 設定内容: 接続先オンプレミス AD の DNS サーバー IP アドレスを指定します。
  #   # 設定可能な値: IP アドレスのセット
  #   customer_dns_ips = ["10.0.0.1", "10.0.0.2"]
  #
  #   # customer_username (Required)
  #   # 設定内容: オンプレミス AD に接続するためのユーザー名を指定します。
  #   # 設定可能な値: オンプレミス AD の有効なユーザー名
  #   # 注意: このユーザーには AD への接続権限が必要
  #   customer_username = "Admin"
  #
  #   # availability_zones (Computed)
  #   # 読み取り専用: サブネットが配置されているアベイラビリティゾーン
  #
  #   # connect_ips (Computed)
  #   # 読み取り専用: AD Connector サーバーの IP アドレス
  # }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "60m", "1h")
    # 省略時: デフォルトのタイムアウト値
    # 用途: ディレクトリの作成には時間がかかるため、長めに設定することを推奨
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "60m", "1h")
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "60m", "1h")
    delete = "60m"
  }

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
    Name        = "example-directory"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID (ディレクトリ識別子)
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディレクトリの識別子 (例: d-1234567890)
#
# - access_url: ディレクトリのアクセス URL
#   (例: http://alias.awsapps.com または http://d-1234567890.awsapps.com)
#
# - dns_ip_addresses: ディレクトリまたはコネクタの DNS サーバーの
#   IP アドレスのリスト
#
# - security_group_id: ディレクトリによって作成されたセキュリティグループの ID
#   このセキュリティグループは VPC 内のインスタンスがディレクトリに
#   アクセスできるように設定されています
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
# - connect_settings.connect_ips: AD Connector サーバーの IP アドレス
#   (ADConnector タイプの場合のみ)
#
# - connect_settings.availability_zones: 接続設定で使用されている
#   アベイラビリティゾーン (ADConnector タイプの場合のみ)
#---------------------------------------------------------------
