#---------------------------------------------------------------
# AWS CodeBuild Project
#---------------------------------------------------------------
#
# AWS CodeBuildのビルドプロジェクトをプロビジョニングするリソースです。
# CodeBuildは、ソースコードをコンパイルし、テストを実行し、デプロイ可能な
# ソフトウェアパッケージを生成するフルマネージドビルドサービスです。
# このリソースは、ビルドの実行方法、使用する環境、出力先などを定義します。
#
# AWS公式ドキュメント:
#   - CodeBuild概要: https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html
#   - プロジェクト作成: https://docs.aws.amazon.com/codebuild/latest/userguide/create-project.html
#   - API Reference: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_Project.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codebuild_project" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロジェクトの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  # 注意: プロジェクト名はAWSアカウント内でリージョンごとに一意である必要があります。
  name = "my-codebuild-project"

  # service_role (Required)
  # 設定内容: CodeBuildがAWSサービスと対話するために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このロールには、ログ出力、アーティファクト保存、VPC接続などに必要な権限が必要です。
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/setting-up.html#setting-up-service-role
  service_role = "arn:aws:iam::123456789012:role/codebuild-service-role"

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: プロジェクトの短い説明を指定します。
  # 設定可能な値: 最大255文字の文字列
  description = "My CodeBuild project for building and testing application"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # badge_enabled (Optional)
  # 設定内容: プロジェクトのビルドバッジの公開URLを生成するかを指定します。
  # 設定可能な値:
  #   - true: バッジURLを生成（badge_url属性で利用可能）
  #   - false (デフォルト): バッジURLを生成しない
  # 用途: ビルドステータスをREADMEなどに表示する際に使用
  badge_enabled = false

  # source_version (Optional)
  # 設定内容: ビルドする入力のバージョンを指定します。
  # 設定可能な値: ブランチ名、タグ、コミットID、または "LATEST"
  # 省略時: 最新バージョンが使用されます
  # 例: "main", "v1.0.0", "abc123def456"
  source_version = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # build_timeout (Optional)
  # 設定内容: ビルドがタイムアウトするまでの分数を指定します。
  # 設定可能な値: 5-2160分（36時間）
  # 省略時: 60分
  # 注意: Lambdaコンピュートタイプでは使用できません
  build_timeout = 60

  # queued_timeout (Optional)
  # 設定内容: ビルドがキューに入れられた状態でタイムアウトするまでの分数を指定します。
  # 設定可能な値: 5-480分（8時間）
  # 省略時: 480分（8時間）
  # 注意: Lambdaコンピュートタイプでは使用できません
  queued_timeout = 480

  #-------------------------------------------------------------
  # 並行実行・リトライ設定
  #-------------------------------------------------------------

  # concurrent_build_limit (Optional)
  # 設定内容: このプロジェクトで同時実行可能なビルドの最大数を指定します。
  # 設定可能な値: 0より大きく、アカウントの同時実行制限未満の整数
  # 注意: 指定する値はアカウントの同時実行制限を超えてはいけません
  concurrent_build_limit = null

  # auto_retry_limit (Optional)
  # 設定内容: ビルド失敗後の自動再試行の最大回数を指定します。
  # 設定可能な値: 0以上の整数
  # 省略時: 0（自動再試行なし）
  # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/run-build.html
  auto_retry_limit = 0

  #-------------------------------------------------------------
  # 可視性設定
  #-------------------------------------------------------------

  # project_visibility (Optional)
  # 設定内容: プロジェクトのビルドの可視性を指定します。
  # 設定可能な値:
  #   - "PRIVATE" (デフォルト): プライベートプロジェクト
  #   - "PUBLIC_READ": パブリック読み取り可能プロジェクト
  # 注意: PUBLIC_READを指定する場合は、resource_access_roleも指定する必要があります
  project_visibility = "PRIVATE"

  # resource_access_role (Optional)
  # 設定内容: CodeBuildがプロジェクトのビルドを公開表示するためにCloudWatch LogsとS3にアクセスするIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: project_visibilityが"PUBLIC_READ"の場合のみ適用されます
  resource_access_role = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_key (Optional)
  # 設定内容: ビルドプロジェクトの出力アーティファクトの暗号化に使用するKMSカスタマーマスターキー（CMK）を指定します。
  # 設定可能な値: 有効なKMSキーARNまたはエイリアス
  # 省略時: AWS管理のS3暗号化キーが使用されます
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/overview.html
  encryption_key = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tagsと一致するキーは、ここで定義したものが優先されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsを含むすべてのタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: 通常はプロバイダーのdefault_tags機能を使用し、このパラメータは直接設定しません
  tags_all = null

  #-------------------------------------------------------------
  # Artifacts設定（必須ブロック）
  #-------------------------------------------------------------
  # ビルドの出力アーティファクト設定を定義します。

  artifacts {
    # type (Required)
    # 設定内容: ビルド出力アーティファクトのタイプを指定します。
    # 設定可能な値:
    #   - "CODEPIPELINE": CodePipelineで使用
    #   - "NO_ARTIFACTS": アーティファクトを出力しない
    #   - "S3": S3バケットに出力
    type = "NO_ARTIFACTS"

    # artifact_identifier (Optional)
    # 設定内容: アーティファクトの識別子を指定します。
    # 設定可能な値: 文字列
    # 注意: buildspec内で指定されたものと同じである必要があります
    artifact_identifier = null

    # encryption_disabled (Optional)
    # 設定内容: 出力アーティファクトの暗号化を無効にするかを指定します。
    # 設定可能な値:
    #   - true: 暗号化を無効化
    #   - false (デフォルト): 暗号化を有効化
    # 注意: typeが"NO_ARTIFACTS"の場合、この値は無視されます
    encryption_disabled = false

    # location (Optional)
    # 設定内容: ビルド出力アーティファクトの場所を指定します。
    # 設定可能な値:
    #   - typeが"S3"の場合: 出力バケットの名前
    #   - typeが"CODEPIPELINE"または"NO_ARTIFACTS"の場合: 無視されます
    location = null

    # name (Optional)
    # 設定内容: アーティファクトの名前を指定します。
    # 設定可能な値:
    #   - typeが"S3"の場合: 出力アーティファクトオブジェクトの名前
    #   - typeが"CODEPIPELINE"または"NO_ARTIFACTS"の場合: 無視されます
    name = null

    # namespace_type (Optional)
    # 設定内容: ビルドアーティファクトの保存に使用する名前空間を指定します。
    # 設定可能な値:
    #   - "BUILD_ID": ビルドIDを名前空間として使用
    #   - "NONE": 名前空間を使用しない
    # 注意: typeが"S3"の場合のみ有効です
    namespace_type = null

    # packaging (Optional)
    # 設定内容: ビルド出力アーティファクトのパッケージングタイプを指定します。
    # 設定可能な値:
    #   - "NONE": パッケージングしない
    #   - "ZIP": ZIPファイルとしてパッケージング
    # 注意: typeが"S3"の場合のみ有効です
    packaging = null

    # path (Optional)
    # 設定内容: 出力アーティファクトのパスを指定します。
    # 設定可能な値: 文字列（パス）
    # 注意: typeが"S3"の場合のみ有効です
    path = null

    # override_artifact_name (Optional)
    # 設定内容: アーティファクト名をbuildspecで指定された名前で上書きするかを指定します。
    # 設定可能な値:
    #   - true: buildspec内の名前で上書き
    #   - false (デフォルト): 上書きしない
    override_artifact_name = false

    # bucket_owner_access (Optional)
    # 設定内容: 別のアカウントがS3バケットにアップロードするオブジェクトに対するバケット所有者のアクセス権を指定します。
    # 設定可能な値:
    #   - "NONE": アクセス権なし（デフォルト）
    #   - "READ_ONLY": 読み取り専用アクセス
    #   - "FULL": フルアクセス
    # 注意: CodeBuildサービスロールにs3:PutBucketAcl権限が必要です
    bucket_owner_access = null
  }

  #-------------------------------------------------------------
  # Environment設定（必須ブロック）
  #-------------------------------------------------------------
  # ビルド環境の設定を定義します。

  environment {
    # type (Required)
    # 設定内容: ビルド環境のタイプを指定します。
    # 設定可能な値:
    #   - "LINUX_CONTAINER": Linuxコンテナ
    #   - "LINUX_GPU_CONTAINER": GPU対応Linuxコンテナ
    #   - "ARM_CONTAINER": ARMコンテナ
    #   - "WINDOWS_SERVER_2019_CONTAINER": Windows Server 2019コンテナ
    #   - "WINDOWS_SERVER_2022_CONTAINER": Windows Server 2022コンテナ
    #   - "LINUX_LAMBDA_CONTAINER": Lambda用Linuxコンテナ
    #   - "ARM_LAMBDA_CONTAINER": Lambda用ARMコンテナ
    #   - "LINUX_EC2": Linux EC2
    #   - "ARM_EC2": ARM EC2
    #   - "WINDOWS_EC2": Windows EC2
    #   - "MAC_ARM": Mac ARM
    # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    type = "LINUX_CONTAINER"

    # compute_type (Required)
    # 設定内容: ビルドプロジェクトが使用するコンピュートリソースを指定します。
    # 設定可能な値:
    #   - "BUILD_GENERAL1_SMALL": 3GB メモリ、2 vCPU
    #   - "BUILD_GENERAL1_MEDIUM": 7GB メモリ、4 vCPU
    #   - "BUILD_GENERAL1_LARGE": 15GB メモリ、8 vCPU
    #   - "BUILD_GENERAL1_XLARGE": 70GB メモリ、36 vCPU（Linux GPUのみ）
    #   - "BUILD_GENERAL1_2XLARGE": 145GB メモリ、72 vCPU（Linux GPUのみ）
    #   - "BUILD_LAMBDA_1GB": 1GB メモリ（Lambda環境）
    #   - "BUILD_LAMBDA_2GB": 2GB メモリ（Lambda環境）
    #   - "BUILD_LAMBDA_4GB": 4GB メモリ（Lambda環境）
    #   - "BUILD_LAMBDA_8GB": 8GB メモリ（Lambda環境）
    #   - "BUILD_LAMBDA_10GB": 10GB メモリ（Lambda環境）
    # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    compute_type = "BUILD_GENERAL1_SMALL"

    # image (Required)
    # 設定内容: このビルドプロジェクトで使用するDockerイメージを指定します。
    # 設定可能な値:
    #   - CodeBuild提供イメージ（例: aws/codebuild/amazonlinux2-x86_64-standard:4.0）
    #   - Docker Hubイメージ（例: hashicorp/terraform:latest）
    #   - ECRイメージのフルURI（例: 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-image:latest）
    # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"

    # image_pull_credentials_type (Optional)
    # 設定内容: CodeBuildがビルドでイメージをプルするために使用する認証情報のタイプを指定します。
    # 設定可能な値:
    #   - "CODEBUILD" (デフォルト): CodeBuild認証情報を使用
    #   - "SERVICE_ROLE": サービスロール認証情報を使用
    # 注意: クロスアカウントまたはプライベートレジストリイメージを使用する場合は、SERVICE_ROLEを使用する必要があります
    image_pull_credentials_type = "CODEBUILD"

    # privileged_mode (Optional)
    # 設定内容: Dockerコンテナ内でDockerデーモンを実行するかを指定します。
    # 設定可能な値:
    #   - true: 特権モードを有効化（Dockerビルドに必要）
    #   - false (デフォルト): 特権モードを無効化
    # 注意: Dockerイメージをビルドする場合や、特権コマンドを実行する場合に必要です
    privileged_mode = false

    # certificate (Optional)
    # 設定内容: PEMエンコードされた証明書を含むS3バケット、パスプレフィックス、オブジェクトキーのARNを指定します。
    # 設定可能な値: 有効なS3オブジェクトARN
    certificate = null

    # environment_variable (Optional)
    # 設定内容: 環境変数の設定を定義します。
    # 注意: 複数の環境変数を設定する場合は、このブロックを繰り返します
    environment_variable {
      # name (Required)
      # 設定内容: 環境変数の名前またはキーを指定します。
      # 設定可能な値: 文字列
      name = "ENVIRONMENT"

      # value (Required)
      # 設定内容: 環境変数の値を指定します。
      # 設定可能な値: 文字列
      value = "production"

      # type (Optional)
      # 設定内容: 環境変数のタイプを指定します。
      # 設定可能な値:
      #   - "PLAINTEXT" (デフォルト): プレーンテキスト
      #   - "PARAMETER_STORE": AWS Systems Manager Parameter Storeの値
      #   - "SECRETS_MANAGER": AWS Secrets Managerのシークレット
      type = "PLAINTEXT"
    }

    # registry_credential (Optional)
    # 設定内容: プライベートDockerレジストリにアクセスするための認証情報を指定します。
    # registry_credential {
    #   # credential (Required)
    #   # 設定内容: AWS Secrets Managerで作成された認証情報のARNまたは名前を指定します。
    #   # 設定可能な値: Secrets ManagerのシークレットARNまたは名前
    #   credential = "arn:aws:secretsmanager:region:account-id:secret:secret-name"
    #
    #   # credential_provider (Required)
    #   # 設定内容: プライベートDockerレジストリにアクセスするための認証情報を作成したサービスを指定します。
    #   # 設定可能な値:
    #   #   - "SECRETS_MANAGER": AWS Secrets Manager
    #   credential_provider = "SECRETS_MANAGER"
    # }

    # fleet (Optional)
    # 設定内容: コンピュートフリート設定を定義します。
    # fleet {
    #   # fleet_arn (Optional)
    #   # 設定内容: ビルドプロジェクトのコンピュートフリートARNを指定します。
    #   # 設定可能な値: 有効なコンピュートフリートARN
    #   fleet_arn = null
    # }

    # docker_server (Optional)
    # 設定内容: Dockerサーバー設定を定義します。
    # docker_server {
    #   # compute_type (Required)
    #   # 設定内容: Dockerサーバーのコンピュートタイプを指定します。
    #   # 設定可能な値:
    #   #   - "BUILD_GENERAL1_SMALL"
    #   #   - "BUILD_GENERAL1_MEDIUM"
    #   #   - "BUILD_GENERAL1_LARGE"
    #   #   - "BUILD_GENERAL1_XLARGE"
    #   #   - "BUILD_GENERAL1_2XLARGE"
    #   compute_type = "BUILD_GENERAL1_SMALL"
    #
    #   # security_group_ids (Optional)
    #   # 設定内容: Dockerサーバーに割り当てるセキュリティグループIDのリストを指定します。
    #   # 設定可能な値: セキュリティグループIDのリスト
    #   security_group_ids = []
    # }
  }

  #-------------------------------------------------------------
  # Source設定（必須ブロック）
  #-------------------------------------------------------------
  # ビルドのソースコード設定を定義します。

  source {
    # type (Required)
    # 設定内容: ビルドするソースコードを含むリポジトリのタイプを指定します。
    # 設定可能な値:
    #   - "BITBUCKET": Bitbucket
    #   - "CODECOMMIT": AWS CodeCommit
    #   - "CODEPIPELINE": AWS CodePipeline
    #   - "GITHUB": GitHub
    #   - "GITHUB_ENTERPRISE": GitHub Enterprise
    #   - "GITLAB": GitLab
    #   - "GITLAB_SELF_MANAGED": GitLab Self Managed
    #   - "NO_SOURCE": ソースなし
    #   - "S3": Amazon S3
    type = "GITHUB"

    # location (Optional)
    # 設定内容: gitまたはS3からのソースコードの場所を指定します。
    # 設定可能な値:
    #   - GitHubの場合: https://github.com/owner/repo.git
    #   - CodeCommitの場合: https://git-codecommit.region.amazonaws.com/v1/repos/repo-name
    #   - S3の場合: バケット名/オブジェクトキー
    location = "https://github.com/example/repo.git"

    # buildspec (Optional)
    # 設定内容: このビルドプロジェクトで使用するビルド仕様を指定します。
    # 設定可能な値:
    #   - リポジトリ内のビルド仕様ファイルへのパス
    #   - file()関数を使用したローカルファイルパス
    # 注意: typeが"NO_SOURCE"の場合は必須です
    # 省略時: ルートディレクトリのbuildspec.ymlが使用されます
    buildspec = null

    # git_clone_depth (Optional)
    # 設定内容: git履歴を切り詰めるコミット数を指定します。
    # 設定可能な値:
    #   - 0: フルチェックアウト（git branch --show-currentなどのコマンドを実行する場合に必要）
    #   - 1以上: 指定したコミット数まで履歴を取得
    # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-github-gitclone.html
    git_clone_depth = 1

    # insecure_ssl (Optional)
    # 設定内容: ソース管理への接続時にSSL警告を無視するかを指定します。
    # 設定可能な値:
    #   - true: SSL警告を無視
    #   - false (デフォルト): SSL警告を無視しない
    insecure_ssl = false

    # report_build_status (Optional)
    # 設定内容: ビルドの開始と終了のステータスをソースプロバイダーに報告するかを指定します。
    # 設定可能な値:
    #   - true: ステータスを報告
    #   - false (デフォルト): ステータスを報告しない
    # 注意: GitHub、GitHub Enterprise、GitLab、GitLab Self Managed、Bitbucketの場合のみ有効です
    report_build_status = false

    # git_submodules_config (Optional)
    # 設定内容: Gitサブモジュールの設定を定義します。
    # git_submodules_config {
    #   # fetch_submodules (Required)
    #   # 設定内容: ビルドプロジェクトのためにGitサブモジュールを取得するかを指定します。
    #   # 設定可能な値:
    #   #   - true: サブモジュールを取得
    #   #   - false: サブモジュールを取得しない
    #   fetch_submodules = true
    # }

    # build_status_config (Optional)
    # 設定内容: ビルドプロジェクトがソースプロバイダーにビルドステータスを報告する方法を定義します。
    # 注意: GitHub、GitHub Enterprise、GitLab、GitLab Self Managed、Bitbucketの場合のみ使用されます
    # build_status_config {
    #   # context (Optional)
    #   # 設定内容: CodeBuildがソースプロバイダーに送信するビルドステータスのコンテキストを指定します。
    #   # 設定可能な値: 文字列
    #   # 注意: 使用方法はソースプロバイダーに依存します
    #   context = null
    #
    #   # target_url (Optional)
    #   # 設定内容: CodeBuildがソースプロバイダーに送信するビルドステータスのターゲットURLを指定します。
    #   # 設定可能な値: URL文字列
    #   # 注意: 使用方法はソースプロバイダーに依存します
    #   target_url = null
    # }

    # auth (Optional)
    # 設定内容: CodeBuildがソースコードホストで認証する際に使用する戦略を定義します。
    # auth {
    #   # type (Required)
    #   # 設定内容: CodeBuildが実行すべき認証のタイプを指定します。
    #   # 設定可能な値:
    #   #   - "CODECONNECTIONS": AWS CodeConnections
    #   #   - "SECRETS_MANAGER": AWS Secrets Manager
    #   type = "CODECONNECTIONS"
    #
    #   # resource (Required)
    #   # 設定内容: 認証に使用するリソースのARNを指定します。
    #   # 設定可能な値:
    #   #   - typeが"CODECONNECTIONS"の場合: AWS CodeStar ConnectionのARN
    #   #   - typeが"SECRETS_MANAGER"の場合: AWS Secrets ManagerのシークレットARN
    #   resource = "arn:aws:codestar-connections:region:account-id:connection/connection-id"
    # }
  }

  #-------------------------------------------------------------
  # Cache設定（オプションブロック）
  #-------------------------------------------------------------
  # ビルドキャッシュの設定を定義します。

  cache {
    # type (Optional)
    # 設定内容: ビルドプロジェクトのキャッシュに使用するストレージのタイプを指定します。
    # 設定可能な値:
    #   - "NO_CACHE" (デフォルト): キャッシュを使用しない
    #   - "LOCAL": ローカルキャッシュを使用
    #   - "S3": S3バケットにキャッシュを保存
    type = "NO_CACHE"

    # location (Required when cache type is S3)
    # 設定内容: CodeBuildプロジェクトがキャッシュされたリソースを保存する場所を指定します。
    # 設定可能な値:
    #   - typeが"S3"の場合: 有効なS3バケット名/プレフィックス
    # location = "my-cache-bucket/project-name"

    # modes (Required when cache type is LOCAL)
    # 設定内容: CodeBuildがビルド依存関係を保存および再利用するために使用する設定を指定します。
    # 設定可能な値:
    #   - "LOCAL_SOURCE_CACHE": ソースキャッシュ
    #   - "LOCAL_DOCKER_LAYER_CACHE": Dockerレイヤーキャッシュ
    #   - "LOCAL_CUSTOM_CACHE": カスタムキャッシュ
    # 注意: typeが"LOCAL"の場合のみ有効です
    # modes = ["LOCAL_SOURCE_CACHE", "LOCAL_DOCKER_LAYER_CACHE"]

    # cache_namespace (Optional)
    # 設定内容: キャッシュが複数のプロジェクト間で共有されるスコープを決定する名前空間を指定します。
    # 設定可能な値: 文字列
    # cache_namespace = null
  }

  #-------------------------------------------------------------
  # Logs Config設定（オプションブロック）
  #-------------------------------------------------------------
  # ビルドログの設定を定義します。

  logs_config {
    # cloudwatch_logs (Optional)
    # 設定内容: CloudWatch Logsの設定を定義します。
    cloudwatch_logs {
      # status (Optional)
      # 設定内容: ビルドプロジェクトのCloudWatch Logsでのログの現在のステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED" (デフォルト): ログを有効化
      #   - "DISABLED": ログを無効化
      status = "ENABLED"

      # group_name (Optional)
      # 設定内容: CloudWatch Logsのログのグループ名を指定します。
      # 設定可能な値: 有効なCloudWatch Logsグループ名
      group_name = null

      # stream_name (Optional)
      # 設定内容: CloudWatch Logsのログのストリーム名のプレフィックスを指定します。
      # 設定可能な値: 文字列
      stream_name = null
    }

    # s3_logs (Optional)
    # 設定内容: S3ログの設定を定義します。
    s3_logs {
      # status (Optional)
      # 設定内容: ビルドプロジェクトのS3でのログの現在のステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": ログを有効化
      #   - "DISABLED" (デフォルト): ログを無効化
      status = "DISABLED"

      # location (Optional)
      # 設定内容: S3バケットの名前とS3ログのパスプレフィックスを指定します。
      # 設定可能な値: S3バケット名/パス形式
      # 注意: statusが"ENABLED"の場合は設定必須、それ以外は空である必要があります
      location = null

      # encryption_disabled (Optional)
      # 設定内容: S3ログの暗号化を無効にするかを指定します。
      # 設定可能な値:
      #   - true: 暗号化を無効化
      #   - false (デフォルト): 暗号化を有効化
      encryption_disabled = false

      # bucket_owner_access (Optional)
      # 設定内容: 別のアカウントがS3バケットにアップロードするオブジェクトに対するバケット所有者のアクセス権を指定します。
      # 設定可能な値:
      #   - "NONE": アクセス権なし（デフォルト）
      #   - "READ_ONLY": 読み取り専用アクセス
      #   - "FULL": フルアクセス
      # 注意: CodeBuildサービスロールにs3:PutBucketAcl権限が必要です
      bucket_owner_access = null
    }
  }

  #-------------------------------------------------------------
  # VPC Config設定（オプションブロック）
  #-------------------------------------------------------------
  # VPC内でビルドを実行する場合の設定を定義します。

  # vpc_config {
  #   # vpc_id (Required)
  #   # 設定内容: ビルドを実行するVPCのIDを指定します。
  #   # 設定可能な値: 有効なVPC ID
  #   vpc_id = "vpc-12345678"
  #
  #   # subnets (Required)
  #   # 設定内容: ビルドを実行するサブネットIDのリストを指定します。
  #   # 設定可能な値: サブネットIDのリスト
  #   subnets = ["subnet-12345678", "subnet-87654321"]
  #
  #   # security_group_ids (Required)
  #   # 設定内容: 実行中のビルドに割り当てるセキュリティグループIDのリストを指定します。
  #   # 設定可能な値: セキュリティグループIDのリスト
  #   security_group_ids = ["sg-12345678"]
  # }

  #-------------------------------------------------------------
  # File System Locations設定（オプションブロック）
  #-------------------------------------------------------------
  # ビルド内でマウントするファイルシステムの場所を定義します。

  # file_system_locations {
  #   # type (Optional)
  #   # 設定内容: ファイルシステムのタイプを指定します。
  #   # 設定可能な値:
  #   #   - "EFS": Amazon Elastic File System
  #   type = "EFS"
  #
  #   # location (Optional)
  #   # 設定内容: Amazon EFSで作成されたファイルシステムの場所を指定する文字列です。
  #   # 設定可能な値: "efs-dns-name:/directory-path" 形式の文字列
  #   # 例: "fs-12345678.efs.us-east-1.amazonaws.com:/mount-path"
  #   location = null
  #
  #   # mount_point (Optional)
  #   # 設定内容: コンテナ内でファイルシステムをマウントする場所を指定します。
  #   # 設定可能な値: パス文字列
  #   mount_point = null
  #
  #   # identifier (Optional)
  #   # 設定内容: Amazon EFSで作成されたファイルシステムにアクセスするために使用する名前を指定します。
  #   # 設定可能な値: 文字列
  #   # 注意: CodeBuildは識別子をすべて大文字にしてCODEBUILD_の後に付加した環境変数を作成します
  #   #       例: identifierが"my-efs"の場合、CODEBUILD_MY-EFSという環境変数が作成されます
  #   identifier = null
  #
  #   # mount_options (Optional)
  #   # 設定内容: AWS EFSで作成されたファイルシステムのマウントオプションを指定します。
  #   # 設定可能な値: マウントオプション文字列
  #   mount_options = null
  # }

  #-------------------------------------------------------------
  # Build Batch Config設定（オプションブロック）
  #-------------------------------------------------------------
  # バッチビルドのオプションを定義します。

  # build_batch_config {
  #   # service_role (Required)
  #   # 設定内容: バッチビルドプロジェクトのサービスロールARNを指定します。
  #   # 設定可能な値: 有効なIAMロールARN
  #   service_role = "arn:aws:iam::123456789012:role/codebuild-batch-service-role"
  #
  #   # combine_artifacts (Optional)
  #   # 設定内容: バッチビルドのビルドアーティファクトを単一のアーティファクトの場所に結合するかを指定します。
  #   # 設定可能な値:
  #   #   - true: アーティファクトを結合
  #   #   - false (デフォルト): アーティファクトを結合しない
  #   combine_artifacts = false
  #
  #   # timeout_in_mins (Optional)
  #   # 設定内容: バッチビルドが完了する必要がある最大時間を分単位で指定します。
  #   # 設定可能な値: 正の整数（分）
  #   timeout_in_mins = null
  #
  #   # restrictions (Optional)
  #   # 設定内容: バッチビルドの制限を指定します。
  #   restrictions {
  #     # maximum_builds_allowed (Optional)
  #     # 設定内容: 許可されるビルドの最大数を指定します。
  #     # 設定可能な値: 正の整数
  #     maximum_builds_allowed = null
  #
  #     # compute_types_allowed (Optional)
  #     # 設定内容: バッチビルドに許可されるコンピュートタイプを指定する文字列の配列です。
  #     # 設定可能な値: コンピュートタイプのリスト
  #     # 参考: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
  #     compute_types_allowed = []
  #   }
  # }

  #-------------------------------------------------------------
  # Secondary Artifacts設定（オプションブロック）
  #-------------------------------------------------------------
  # セカンダリアーティファクトの設定を定義します。

  # secondary_artifacts {
  #   # artifact_identifier (Required)
  #   # 設定内容: アーティファクトの識別子を指定します。
  #   # 設定可能な値: 文字列
  #   # 注意: buildspec内で指定されたものと同じである必要があります
  #   artifact_identifier = "secondary-artifact-1"
  #
  #   # type (Required)
  #   # 設定内容: ビルド出力アーティファクトのタイプを指定します。
  #   # 設定可能な値: "CODEPIPELINE", "NO_ARTIFACTS", "S3"
  #   type = "S3"
  #
  #   # encryption_disabled (Optional)
  #   # 設定内容: 出力アーティファクトの暗号化を無効にするかを指定します。
  #   # 設定可能な値:
  #   #   - true: 暗号化を無効化
  #   #   - false (デフォルト): 暗号化を有効化
  #   encryption_disabled = false
  #
  #   # location (Optional)
  #   # 設定内容: ビルド出力アーティファクトの場所を指定します。
  #   # 設定可能な値: S3バケット名
  #   location = null
  #
  #   # name (Optional)
  #   # 設定内容: 出力アーティファクトオブジェクトの名前を指定します。
  #   # 設定可能な値: 文字列
  #   name = null
  #
  #   # namespace_type (Optional)
  #   # 設定内容: ビルドアーティファクトの保存に使用する名前空間を指定します。
  #   # 設定可能な値: "BUILD_ID", "NONE"
  #   namespace_type = null
  #
  #   # packaging (Optional)
  #   # 設定内容: ビルド出力アーティファクトのパッケージングタイプを指定します。
  #   # 設定可能な値: "NONE", "ZIP"
  #   packaging = null
  #
  #   # path (Optional)
  #   # 設定内容: 出力アーティファクトのパスを指定します。
  #   # 設定可能な値: パス文字列
  #   path = null
  #
  #   # override_artifact_name (Optional)
  #   # 設定内容: アーティファクト名をbuildspecで指定された名前で上書きするかを指定します。
  #   # 設定可能な値:
  #   #   - true: buildspec内の名前で上書き
  #   #   - false (デフォルト): 上書きしない
  #   override_artifact_name = false
  #
  #   # bucket_owner_access (Optional)
  #   # 設定内容: 別のアカウントがS3バケットにアップロードするオブジェクトに対するバケット所有者のアクセス権を指定します。
  #   # 設定可能な値: "NONE", "READ_ONLY", "FULL"
  #   bucket_owner_access = null
  # }

  #-------------------------------------------------------------
  # Secondary Sources設定（オプションブロック）
  #-------------------------------------------------------------
  # セカンダリソースの設定を定義します。

  # secondary_sources {
  #   # source_identifier (Required)
  #   # 設定内容: このプロジェクトソースの識別子を指定します。
  #   # 設定可能な値: 128文字未満の英数字とアンダースコアのみ
  #   source_identifier = "secondary-source-1"
  #
  #   # type (Required)
  #   # 設定内容: ビルドするソースコードを含むリポジトリのタイプを指定します。
  #   # 設定可能な値: "BITBUCKET", "CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "GITLAB", "GITLAB_SELF_MANAGED", "NO_SOURCE", "S3"
  #   type = "GITHUB"
  #
  #   # location (Optional)
  #   # 設定内容: gitまたはS3からのソースコードの場所を指定します。
  #   # 設定可能な値: リポジトリURL
  #   location = null
  #
  #   # buildspec (Optional)
  #   # 設定内容: ビルド仕様を指定します。
  #   # 設定可能な値: ビルド仕様ファイルのパスまたは内容
  #   buildspec = null
  #
  #   # git_clone_depth (Optional)
  #   # 設定内容: git履歴を切り詰めるコミット数を指定します。
  #   # 設定可能な値: 0以上の整数
  #   git_clone_depth = 1
  #
  #   # insecure_ssl (Optional)
  #   # 設定内容: ソース管理への接続時にSSL警告を無視するかを指定します。
  #   # 設定可能な値: true, false
  #   insecure_ssl = false
  #
  #   # report_build_status (Optional)
  #   # 設定内容: ビルドの開始と終了のステータスをソースプロバイダーに報告するかを指定します。
  #   # 設定可能な値: true, false
  #   report_build_status = false
  #
  #   # git_submodules_config (Optional)
  #   # git_submodules_config {
  #   #   fetch_submodules = true
  #   # }
  #
  #   # build_status_config (Optional)
  #   # build_status_config {
  #   #   context = null
  #   #   target_url = null
  #   # }
  #
  #   # auth (Optional)
  #   # auth {
  #   #   type = "CODECONNECTIONS"
  #   #   resource = "arn:aws:codestar-connections:region:account-id:connection/connection-id"
  #   # }
  # }

  #-------------------------------------------------------------
  # Secondary Source Version設定（オプションブロック）
  #-------------------------------------------------------------
  # セカンダリソースのバージョンを定義します。

  # secondary_source_version {
  #   # source_identifier (Required)
  #   # 設定内容: ビルドプロジェクト内のソースの識別子を指定します。
  #   # 設定可能な値: 文字列
  #   source_identifier = "secondary-source-1"
  #
  #   # source_version (Required)
  #   # 設定内容: 対応するソース識別子のソースバージョンを指定します。
  #   # 設定可能な値: ブランチ名、タグ、コミットID
  #   # 参考: https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectSourceVersion.html#CodeBuild-Type-ProjectSourceVersion-sourceVersion
  #   source_version = "main"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: CodeBuildプロジェクトのARN
#
# - badge_url: badge_enabledが有効な場合のビルドバッジのURL
#
# - id: プロジェクトの名前（nameでインポートした場合）または
#       ARN（Terraformで作成した場合、またはARNでインポートした場合）
#
# - public_project_alias: パブリックビルドAPIで使用されるプロジェクト識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
