#---------------------------------------------------------------
# AWS WorkSpaces Directory
#---------------------------------------------------------------
#
# Amazon WorkSpaces ディレクトリをプロビジョニングするリソースです。
# WorkSpaces ディレクトリは、WorkSpaces の認証・管理に使用するディレクトリサービスとの
# 連携を定義します。PERSONAL（個人用）とPOOLS（プール）の2種類のワークスペースタイプを
# サポートしています。
#
# AWS公式ドキュメント:
#   - WorkSpaces 管理ガイド: https://docs.aws.amazon.com/workspaces/latest/adminguide/
#   - WorkSpaces アクセス制御: https://docs.aws.amazon.com/workspaces/latest/adminguide/workspaces-access-control.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_directory
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspaces_directory" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # directory_id (Optional)
  # 設定内容: WorkSpaces サービスに登録するディレクトリ識別子を指定します。
  # 設定可能な値: AWS Directory Service のディレクトリID（例: d-1234567890）
  # 省略時: workspace_type が POOLS の場合は自動生成されます。
  # 注意: workspace_type が PERSONAL の場合に使用。POOLS の場合は directory_id を手動で設定できません。
  directory_id = "d-1234567890"

  # workspace_type (Optional)
  # 設定内容: WorkSpaces ディレクトリのタイプを指定します。
  # 設定可能な値:
  #   - "PERSONAL" (デフォルト): 個人用 WorkSpaces。各ユーザーに専用のワークスペースを割り当て
  #   - "POOLS": WorkSpaces プール。複数ユーザーで共有するプール型ワークスペース
  # 関連機能: WorkSpaces プール
  #   プール型では、ユーザーはオンデマンドでワークスペースにアクセスし、
  #   使用後は自動的にリセットされます。
  #   - https://docs.aws.amazon.com/workspaces/latest/adminguide/pools.html
  workspace_type = "PERSONAL"

  #-------------------------------------------------------------
  # プール用設定（workspace_type = "POOLS" の場合に必要）
  #-------------------------------------------------------------

  # workspace_directory_name (Required for POOLS)
  # 設定内容: workspace_type が POOLS の場合に WorkSpaces ディレクトリの名前を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: workspace_type が POOLS の場合は必須
  workspace_directory_name = null

  # workspace_directory_description (Required for POOLS)
  # 設定内容: workspace_type が POOLS の場合に WorkSpaces ディレクトリの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 注意: workspace_type が POOLS の場合は必須
  workspace_directory_description = null

  # user_identity_type (Required for POOLS)
  # 設定内容: WorkSpaces ディレクトリのユーザーIDタイプを指定します。
  # 設定可能な値:
  #   - "CUSTOMER_MANAGED": 顧客管理の Active Directory を使用
  #   - "AWS_DIRECTORY_SERVICE": AWS Directory Service を使用
  #   - "AWS_IAM_IDENTITY_CENTER": AWS IAM Identity Center を使用
  # 注意: workspace_type が POOLS の場合は必須
  user_identity_type = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_ids (Optional)
  # 設定内容: ディレクトリが存在するサブネットの識別子を指定します。
  # 設定可能な値: VPC サブネット ID のセット（2つ以上のサブネットを異なる AZ で指定）
  # 省略時: ディレクトリの既存のサブネット設定が使用されます。
  # 注意: WorkSpaces をプロビジョニングするための可用性ゾーンを決定します。
  subnet_ids = [
    "subnet-0123456789abcdef0",
    "subnet-0123456789abcdef1"
  ]

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
  # テナンシー設定
  #-------------------------------------------------------------

  # tenancy (Optional)
  # 設定内容: WorkSpaces ディレクトリのテナンシーを指定します。
  # 設定可能な値:
  #   - "SHARED" (デフォルト): 共有ハードウェア上でワークスペースを実行
  #   - "DEDICATED": 専用ハードウェア上でワークスペースを実行
  # 関連機能: 専用テナンシー
  #   専用テナンシーでは、ワークスペースは他の AWS アカウントと
  #   ハードウェアを共有しない専用ホスト上で実行されます。
  tenancy = "SHARED"

  #-------------------------------------------------------------
  # IP グループ設定
  #-------------------------------------------------------------

  # ip_group_ids (Optional)
  # 設定内容: ディレクトリに関連付ける IP アクセス制御グループの識別子を指定します。
  # 設定可能な値: WorkSpaces IP グループ ID のセット
  # 省略時: IP 制限なし
  # 関連機能: IP アクセスコントロール
  #   信頼できる IP アドレスからのみ WorkSpaces へのアクセスを許可できます。
  #   - https://docs.aws.amazon.com/workspaces/latest/adminguide/amazon-workspaces-ip-access-control-groups.html
  ip_group_ids = []

  #-------------------------------------------------------------
  # Active Directory 設定（workspace_type = "POOLS" の場合）
  #-------------------------------------------------------------

  # active_directory_config (Optional)
  # 設定内容: workspace_type が POOLS の場合の Active Directory 統合設定を定義します。
  # 注意: workspace_type が POOLS で user_identity_type が CUSTOMER_MANAGED の場合に使用
  # active_directory_config {
  #   # domain_name (Required)
  #   # 設定内容: AWS Directory Service ディレクトリの完全修飾ドメイン名を指定します。
  #   # 設定可能な値: FQDN 形式のドメイン名（例: example.internal）
  #   domain_name = "example.internal"
  #
  #   # service_account_secret_arn (Required)
  #   # 設定内容: サービスアカウントの認証情報を含む Secrets Manager シークレットの ARN を指定します。
  #   # 設定可能な値: 有効な Secrets Manager シークレット ARN
  #   # 参考: https://docs.aws.amazon.com/workspaces/latest/adminguide/pools-service-account-details.html
  #   service_account_secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:workspaces-service-account"
  # }

  #-------------------------------------------------------------
  # 証明書ベース認証設定
  #-------------------------------------------------------------

  # certificate_based_auth_properties (Optional)
  # 設定内容: 証明書ベース認証（CBA）統合の設定を定義します。
  # 注意: SAML 認証が有効な場合に使用可能
  # 関連機能: 証明書ベース認証
  #   スマートカードや証明書を使用したより強力な認証を提供します。
  # certificate_based_auth_properties {
  #   # certificate_authority_arn (Optional)
  #   # 設定内容: 証明書ベース認証に使用する ACM Private CA の ARN を指定します。
  #   # 設定可能な値: 有効な ACM PCA の ARN
  #   certificate_authority_arn = "arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"
  #
  #   # status (Optional)
  #   # 設定内容: 証明書ベース認証のステータスを指定します。
  #   # 設定可能な値:
  #   #   - "ENABLED": 証明書ベース認証を有効化
  #   #   - "DISABLED" (デフォルト): 証明書ベース認証を無効化
  #   status = "DISABLED"
  # }

  #-------------------------------------------------------------
  # SAML 認証設定
  #-------------------------------------------------------------

  # saml_properties (Optional)
  # 設定内容: SAML 2.0 認証統合の設定を定義します。
  # 関連機能: SAML 2.0 認証
  #   外部 ID プロバイダーとの統合により、シングルサインオン（SSO）を実現します。
  # saml_properties {
  #   # relay_state_parameter_name (Optional)
  #   # 設定内容: SAML 2.0 ID プロバイダー（IdP）がサポートするリレー状態パラメータ名を指定します。
  #   # 設定可能な値: 任意の文字列
  #   # 省略時: "RelayState"
  #   relay_state_parameter_name = "RelayState"
  #
  #   # user_access_url (Optional)
  #   # 設定内容: SAML 2.0 ID プロバイダー（IdP）のユーザーアクセス URL を指定します。
  #   # 設定可能な値: 有効な HTTPS URL
  #   user_access_url = "https://sso.example.com/"
  #
  #   # status (Optional)
  #   # 設定内容: SAML 2.0 認証のステータスを指定します。
  #   # 設定可能な値:
  #   #   - "ENABLED": SAML 認証を有効化
  #   #   - "DISABLED" (デフォルト): SAML 認証を無効化
  #   status = "DISABLED"
  # }

  #-------------------------------------------------------------
  # セルフサービス権限設定（workspace_type = "PERSONAL" の場合）
  #-------------------------------------------------------------

  # self_service_permissions (Optional)
  # 設定内容: workspace_type が PERSONAL の場合にユーザーに付与するセルフサービス権限を定義します。
  # 関連機能: セルフサービス機能
  #   ユーザーが管理者の介入なしにワークスペースを管理できる機能です。
  #   - https://docs.aws.amazon.com/workspaces/latest/adminguide/enable-user-self-service-workspace-management.html
  self_service_permissions {
    # change_compute_type (Optional)
    # 設定内容: ユーザーがワークスペースのコンピュートタイプ（バンドル）を変更できるかを指定します。
    # 設定可能な値:
    #   - true: コンピュートタイプの変更を許可
    #   - false (デフォルト): コンピュートタイプの変更を禁止
    change_compute_type = false

    # increase_volume_size (Optional)
    # 設定内容: ユーザーがワークスペースのボリュームサイズを増加できるかを指定します。
    # 設定可能な値:
    #   - true: ボリュームサイズの増加を許可
    #   - false (デフォルト): ボリュームサイズの増加を禁止
    increase_volume_size = false

    # rebuild_workspace (Optional)
    # 設定内容: ユーザーがワークスペースの OS を元の状態に再構築できるかを指定します。
    # 設定可能な値:
    #   - true: ワークスペースの再構築を許可
    #   - false (デフォルト): ワークスペースの再構築を禁止
    rebuild_workspace = false

    # restart_workspace (Optional)
    # 設定内容: ユーザーがワークスペースを再起動できるかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): ワークスペースの再起動を許可
    #   - false: ワークスペースの再起動を禁止
    restart_workspace = true

    # switch_running_mode (Optional)
    # 設定内容: ユーザーがワークスペースの実行モードを切り替えられるかを指定します。
    # 設定可能な値:
    #   - true: 実行モードの切り替えを許可（AlwaysOn と AutoStop の間）
    #   - false (デフォルト): 実行モードの切り替えを禁止
    switch_running_mode = false
  }

  #-------------------------------------------------------------
  # デバイスアクセス設定
  #-------------------------------------------------------------

  # workspace_access_properties (Optional)
  # 設定内容: ユーザーが WorkSpaces にアクセスできるデバイスと OS を指定します。
  # 関連機能: デバイスアクセス制御
  #   特定のデバイスタイプからのアクセスを制御できます。
  workspace_access_properties {
    # device_type_android (Optional)
    # 設定内容: ユーザーが Android デバイスから WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": Android デバイスからのアクセスを許可
    #   - "DENY": Android デバイスからのアクセスを拒否
    device_type_android = "ALLOW"

    # device_type_chromeos (Optional)
    # 設定内容: ユーザーが Chromebook から WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": Chromebook からのアクセスを許可
    #   - "DENY": Chromebook からのアクセスを拒否
    device_type_chromeos = "ALLOW"

    # device_type_ios (Optional)
    # 設定内容: ユーザーが iOS デバイスから WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": iOS デバイスからのアクセスを許可
    #   - "DENY": iOS デバイスからのアクセスを拒否
    device_type_ios = "ALLOW"

    # device_type_linux (Optional)
    # 設定内容: ユーザーが Linux クライアントから WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": Linux クライアントからのアクセスを許可
    #   - "DENY": Linux クライアントからのアクセスを拒否
    device_type_linux = "ALLOW"

    # device_type_osx (Optional)
    # 設定内容: ユーザーが macOS クライアントから WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": macOS クライアントからのアクセスを許可
    #   - "DENY": macOS クライアントからのアクセスを拒否
    device_type_osx = "ALLOW"

    # device_type_web (Optional)
    # 設定内容: ユーザーが Web ブラウザから WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": Web ブラウザからのアクセスを許可
    #   - "DENY": Web ブラウザからのアクセスを拒否
    device_type_web = "ALLOW"

    # device_type_windows (Optional)
    # 設定内容: ユーザーが Windows クライアントから WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": Windows クライアントからのアクセスを許可
    #   - "DENY": Windows クライアントからのアクセスを拒否
    device_type_windows = "ALLOW"

    # device_type_zeroclient (Optional)
    # 設定内容: ユーザーが Zero Client デバイスから WorkSpaces にアクセスできるかを指定します。
    # 設定可能な値:
    #   - "ALLOW": Zero Client からのアクセスを許可
    #   - "DENY": Zero Client からのアクセスを拒否
    device_type_zeroclient = "ALLOW"
  }

  #-------------------------------------------------------------
  # ワークスペース作成プロパティ
  #-------------------------------------------------------------

  # workspace_creation_properties (Optional)
  # 設定内容: WorkSpaces を作成する際のデフォルトプロパティを定義します。
  workspace_creation_properties {
    # custom_security_group_id (Optional)
    # 設定内容: WorkSpaces が存在する VPC に関連するカスタムセキュリティグループの ID を指定します。
    # 設定可能な値: 有効なセキュリティグループ ID
    # 注意: ワークスペースと同じ VPC 内のセキュリティグループを指定する必要があります。
    custom_security_group_id = null

    # default_ou (Optional)
    # 設定内容: WorkSpaces ディレクトリのデフォルト組織単位（OU）を指定します。
    # 設定可能な値: "OU=<value>,DC=<value>,...,DC=<value>" 形式の文字列
    # 例: "OU=AWS,DC=Workgroup,DC=Example,DC=com"
    default_ou = null

    # enable_internet_access (Optional)
    # 設定内容: WorkSpaces のインターネットアクセスを有効にするかを指定します。
    # 設定可能な値:
    #   - true: インターネットアクセスを有効化
    #   - false: インターネットアクセスを無効化（デフォルトの NAT を使用しない）
    # 注意: true の場合、パブリック IP アドレスが割り当てられます。
    enable_internet_access = false

    # enable_maintenance_mode (Optional)
    # 設定内容: WorkSpaces のメンテナンスモードを有効にするかを指定します。
    # 設定可能な値:
    #   - true: メンテナンスモードを有効化
    #   - false: メンテナンスモードを無効化
    # 注意: workspace_type が PERSONAL の場合のみ有効
    # 関連機能: メンテナンスモード
    #   Windows WorkSpaces の自動更新を管理し、毎月のパッチ適用ウィンドウ中に
    #   自動的に起動・更新・再起動されます。
    enable_maintenance_mode = true

    # user_enabled_as_local_administrator (Optional)
    # 設定内容: ユーザーを WorkSpaces のローカル管理者として有効にするかを指定します。
    # 設定可能な値:
    #   - true: ユーザーをローカル管理者として設定
    #   - false: ユーザーをローカル管理者として設定しない
    # 注意: workspace_type が PERSONAL の場合のみ有効
    user_enabled_as_local_administrator = false
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
    Name        = "example-workspaces-directory"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WorkSpaces ディレクトリ識別子
#
# - alias: ディレクトリのエイリアス
#
# - customer_user_name: サービスアカウントのユーザー名
#
# - directory_name: ディレクトリの名前
#
# - directory_type: ディレクトリのタイプ
#
# - dns_ip_addresses: ディレクトリの DNS サーバーの IP アドレス
#
# - iam_role_id: IAM ロールの識別子。Amazon WorkSpaces が Amazon EC2 などの
#                他のサービスを呼び出すために使用するロールです。
#
# - ip_group_ids: ディレクトリに関連付けられた IP アクセス制御グループの識別子
#
# - registration_code: ディレクトリの登録コード。ユーザーが Amazon WorkSpaces
#                      クライアントアプリケーションでディレクトリに接続するために
#                      入力するコードです。
#---------------------------------------------------------------
