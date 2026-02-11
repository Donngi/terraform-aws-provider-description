# ================================================================
# Terraform AWS Resource Template: aws_codeartifact_repository
# ================================================================
# 生成日: 2026-01-19
# Provider Version: 6.28.0
#
# 【注意】
# このテンプレートは生成時点(2026-01-19)の AWS Provider v6.28.0 の
# スキーマに基づいています。最新の仕様や詳細については、必ず公式
# ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository
# ================================================================

# ================================================================
# CodeArtifact Repository
# AWS CodeArtifactのリポジトリリソース
# ================================================================
# AWS CodeArtifactは、ソフトウェアパッケージの保管と管理を行う
# フルマネージドなアーティファクトリポジトリサービスです。
# Maven、npm、NuGet、Python、Rubyなどのパッケージフォーマットに
# 対応しており、外部の公開リポジトリとの接続やアップストリーム
# リポジトリの設定が可能です。
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/codeartifact/latest/ug/welcome.html
# Terraform AWS Provider:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository
# ================================================================

resource "aws_codeartifact_repository" "example" {
  # ================================================================
  # 必須パラメータ
  # ================================================================

  # repository - (必須)
  # 作成するリポジトリの名前
  #
  # 制約:
  # - 2〜100文字
  # - 小文字、数字、ハイフン(-)、アンダースコア(_)、ピリオド(.)のみ使用可能
  # - 先頭と末尾はアルファベットまたは数字である必要がある
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/codeartifact/latest/ug/repo-create.html
  repository = "example-repository"

  # domain - (必須)
  # このリポジトリを作成するCodeArtifactドメインの名前
  #
  # CodeArtifactドメインは、リポジトリのグループ化と管理を行う
  # 単位です。同一ドメイン内のリポジトリは相互に接続でき、
  # パッケージの共有が容易になります。
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/codeartifact/latest/ug/domain.html
  domain = "example-domain"

  # ================================================================
  # オプションパラメータ
  # ================================================================

  # description - (オプション)
  # リポジトリの説明
  #
  # リポジトリの目的や用途を記述します。この説明は
  # AWS Management Consoleやリポジトリ一覧に表示されます。
  description = "Example CodeArtifact repository for storing application packages"

  # domain_owner - (オプション)
  # ドメインを所有するAWSアカウントのアカウント番号
  #
  # 他のAWSアカウントが所有するドメインにリポジトリを作成する場合に指定します。
  # 省略した場合は、現在のAWSアカウントが所有するドメインが使用されます。
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/codeartifact/latest/ug/domain-cross-account.html
  domain_owner = "123456789012"

  # region - (オプション)
  # このリソースが管理されるAWSリージョン
  #
  # 省略した場合は、プロバイダー設定で指定されたリージョンが使用されます。
  # 特定のリージョンでリソースを管理したい場合に明示的に指定します。
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # tags - (オプション)
  # リソースに付与するタグのキー・バリューマップ
  #
  # タグを使用してリソースの分類、管理、コスト追跡を行うことができます。
  # プロバイダーレベルで default_tags が設定されている場合、
  # ここで指定したタグが優先されます。
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/codeartifact/latest/ug/tag-resources.html
  tags = {
    Environment = "production"
    Project     = "example-project"
    ManagedBy   = "terraform"
  }

  # ================================================================
  # ネストブロック: upstream
  # ================================================================
  # アップストリームリポジトリの設定
  #
  # アップストリームリポジトリを指定することで、複数のリポジトリの
  # パッケージに単一のエンドポイントでアクセスできます。
  # リクエストされたパッケージバージョンがローカルリポジトリに
  # 存在しない場合、CodeArtifactはアップストリームリポジトリを
  # 優先順位に従って検索します。
  #
  # 制約:
  # - 最大10個のアップストリームリポジトリを設定可能
  # - リストの順序が検索の優先順位を決定します
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/codeartifact/latest/ug/repos-upstream.html
  # https://docs.aws.amazon.com/codeartifact/latest/ug/repo-upstream-behavior.html
  upstream {
    # repository_name - (必須)
    # アップストリームリポジトリの名前
    #
    # 同一ドメイン内の既存のリポジトリ名を指定します。
    # アップストリームリポジトリに対して
    # AssociateWithDownstreamRepository アクションの
    # 権限が必要です。
    repository_name = "upstream-repository-1"
  }

  upstream {
    repository_name = "upstream-repository-2"
  }

  # ================================================================
  # ネストブロック: external_connections
  # ================================================================
  # 外部接続の設定
  #
  # 外部の公開リポジトリ(npmjs.com、Maven Central、PyPIなど)との
  # 接続を設定します。外部接続により、公開リポジトリのパッケージを
  # CodeArtifact経由で取得できるようになります。
  #
  # 制約:
  # - 1つのリポジトリにつき1つの外部接続のみ設定可能
  # - 推奨: ドメインごとに1つのリポジトリに外部接続を設定し、
  #   他のリポジトリはそのリポジトリをアップストリームとして追加
  #
  # 公式ドキュメント:
  # https://docs.aws.amazon.com/codeartifact/latest/ug/external-connection.html
  # https://docs.aws.amazon.com/codeartifact/latest/ug/external-connection-requesting-packages.html
  external_connections {
    # external_connection_name - (必須)
    # リポジトリに関連付ける外部接続の名前
    #
    # サポートされている外部接続:
    # - public:npmjs (npm パッケージ)
    # - public:pypi (Python パッケージ)
    # - public:maven-central (Maven パッケージ)
    # - public:maven-googleandroid (Google Android ライブラリ)
    # - public:maven-gradleplugins (Gradle プラグイン)
    # - public:maven-commonsware (CommonsWare Android ライブラリ)
    # - public:nuget-org (NuGet パッケージ)
    # - public:rubygems-org (Ruby gems)
    #
    # 公式ドキュメント:
    # https://docs.aws.amazon.com/codeartifact/latest/ug/external-connection.html
    external_connection_name = "public:npmjs"
  }
}

# ================================================================
# 補足情報
# ================================================================
#
# 【Computed Attributes(読み取り専用)】
# 以下の属性はTerraformによって自動的に設定され、
# 他のリソースから参照可能です:
#
# - id: リポジトリのARN
# - arn: リポジトリのARN
# - administrator_account: リポジトリを管理するAWSアカウント番号
# - tags_all: リソースに割り当てられた全てのタグ
#   (プロバイダーのdefault_tagsから継承されたタグを含む)
#
# 【外部接続時のパッケージ取得の流れ】
# 1. パッケージマネージャーで `aws codeartifact login` を実行して認証
# 2. パッケージをインストール(例: npm install <package>)
# 3. パッケージは公開リポジトリから取得され、CodeArtifactにコピーされる
# 4. 取得されたパッケージは永続的にCodeArtifactに保存される
#
# 【アップストリームリポジトリの優先順位】
# - upstream ブロックの記述順序が検索の優先順位を決定します
# - パッケージバージョンが見つかった場合、ローカルリポジトリに
#   参照がコピーされ、以降は常に利用可能になります
#
# 【セキュリティのベストプラクティス】
# - IAMポリシーでリポジトリへのアクセスを制限
# - ドメインレベルとリポジトリレベルの権限を適切に設定
# - 外部接続を持つリポジトリは専用のリポジトリとして分離
# - タグを活用したリソース管理とコスト追跡
#
# ================================================================
