# ============================================================================
# AWS CodeConnections Connection
# ============================================================================
# Generated: 2026-01-19
# Provider version: hashicorp/aws 6.28.0
#
# 注意:
# このテンプレートは生成時点 (2026-01-19) のAWS Provider 6.28.0 の仕様に
# 基づいて作成されています。最新の仕様や詳細については、必ず公式ドキュメント
# をご確認ください。
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeconnections_connection
#
# AWS CodeConnections Documentation:
# https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Connection.html
# https://docs.aws.amazon.com/dtconsole/latest/userguide/supported-versions-connections.html
# ============================================================================

# ============================================================================
# 重要な注意事項
# ============================================================================
# aws_codeconnections_connection リソースは、作成直後は PENDING 状態になります。
# 接続プロバイダーとの認証は、AWS Consoleで手動で完了する必要があります。
# 詳細はこちら: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html
# ============================================================================

resource "aws_codeconnections_connection" "example" {

  # --------------------------------------------------------------------------
  # Required Arguments
  # --------------------------------------------------------------------------

  # name - (必須) string
  # 作成する接続の名前。AWS アカウント内で一意である必要があります。
  # この値を変更すると、新しいリソースが作成されます。
  # https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Connection.html
  name = "example-connection"


  # --------------------------------------------------------------------------
  # Optional Arguments
  # --------------------------------------------------------------------------

  # host_arn - (オプション) string
  # 接続に関連付けられたホストのAmazon Resource Name (ARN)。
  # provider_type と競合します。どちらか一方のみ指定してください。
  # ホストベースの接続を作成する場合に使用します（GitHub Enterprise Server、
  # GitLab self-managed など）。
  # https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Connection.html
  # host_arn = "arn:aws:codeconnections:us-east-1:123456789012:host/example-host-id"

  # provider_type - (オプション) string
  # サードパーティのコードリポジトリが設定されている外部プロバイダーの名前。
  # この値を変更すると、新しいリソースが作成されます。
  # host_arn と競合します。どちらか一方のみ指定してください。
  #
  # 有効な値:
  # - "Bitbucket" - Atlassian Bitbucket Cloud
  # - "GitHub" - GitHub および GitHub Enterprise Cloud
  # - "GitHubEnterpriseServer" - GitHub Enterprise Server
  # - "GitLab" - GitLab.com
  # - "GitLabSelfManaged" - GitLab self-managed (Enterprise/Community Edition)
  # - "AzureDevOps" - Azure DevOps
  #
  # 注: Bitbucket Server、Azure Cloud Hosting などのインストール型プロバイダーは
  # サポートされていません。
  # https://docs.aws.amazon.com/dtconsole/latest/userguide/supported-versions-connections.html
  provider_type = "Bitbucket"

  # region - (オプション) string
  # このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトで使用されます。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags - (オプション) map(string)
  # リソースに関連付けるキーと値のペアのマップ。
  # プロバイダーの default_tags 設定ブロックでタグが定義されている場合、
  # 同じキーを持つタグはここで定義されたものが優先されます。
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Project     = "example-project"
    ManagedBy   = "terraform"
  }


  # --------------------------------------------------------------------------
  # Timeouts (Optional)
  # --------------------------------------------------------------------------
  # リソース操作のタイムアウト設定
  # 時間は "30s" や "2h45m" のような形式で指定します。
  # 有効な単位: "s" (秒), "m" (分), "h" (時間)
  # https://pkg.go.dev/time#ParseDuration

  timeouts {
    # create - リソース作成のタイムアウト
    # create = "5m"

    # update - リソース更新のタイムアウト
    # update = "5m"

    # delete - リソース削除のタイムアウト
    # 注: Delete操作のタイムアウトは、destroy操作の前に状態が保存される場合にのみ適用されます。
    # delete = "5m"
  }
}


# ============================================================================
# Computed Attributes (読み取り専用)
# ============================================================================
# 以下の属性は Terraform によって自動的に計算され、参照可能です。
# これらの属性はリソース定義では指定できません。
#
# - arn (string)
#   接続のAmazon Resource Name (ARN)
#   例: aws_codeconnections_connection.example.arn
#
# - connection_status (string)
#   接続のステータス
#   可能な値: "PENDING", "AVAILABLE", "ERROR"
#   例: aws_codeconnections_connection.example.connection_status
#
# - id (string) - 非推奨
#   接続のARN（arn属性と同じ値）
#   この属性は非推奨です。代わりにarn属性を使用してください。
#
# - owner_account_id (string)
#   サードパーティコードリポジトリが設定されている外部プロバイダーの識別子
#   例: aws_codeconnections_connection.example.owner_account_id
#
# - tags_all (map(string))
#   リソースに割り当てられたすべてのタグ（プロバイダーの default_tags から
#   継承されたものを含む）
#   例: aws_codeconnections_connection.example.tags_all
# ============================================================================


# ============================================================================
# 使用例とユースケース
# ============================================================================

# 例1: Bitbucket Cloud との接続
resource "aws_codeconnections_connection" "bitbucket" {
  name          = "my-bitbucket-connection"
  provider_type = "Bitbucket"

  tags = {
    Name = "Bitbucket Connection"
  }
}

# 例2: GitHub との接続
resource "aws_codeconnections_connection" "github" {
  name          = "my-github-connection"
  provider_type = "GitHub"

  tags = {
    Name = "GitHub Connection"
  }
}

# 例3: GitHub Enterprise Server との接続（ホストARN使用）
# 注: 事前に aws_codeconnections_host リソースでホストを作成する必要があります
resource "aws_codeconnections_connection" "github_enterprise" {
  name     = "my-github-enterprise-connection"
  host_arn = aws_codeconnections_host.example.arn

  tags = {
    Name = "GitHub Enterprise Server Connection"
  }
}

# 例4: 特定のリージョンに接続を作成
resource "aws_codeconnections_connection" "regional" {
  name          = "my-regional-connection"
  provider_type = "GitLab"
  region        = "us-west-2"

  tags = {
    Name   = "GitLab Connection"
    Region = "us-west-2"
  }
}

# ============================================================================
# 接続の参照例
# ============================================================================
# CodePipeline などの他のサービスで接続を使用する例

# CodePipeline でソースステージに接続を使用
resource "aws_codepipeline" "example" {
  name     = "example-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        # 接続ARNを参照
        ConnectionArn    = aws_codeconnections_connection.example.arn
        FullRepositoryId = "my-org/my-repo"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "example-project"
      }
    }
  }
}

# ============================================================================
# トラブルシューティング
# ============================================================================
#
# 1. 接続が PENDING 状態のまま
#    - AWS Console で接続の認証を完了する必要があります
#    - https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html
#
# 2. provider_type と host_arn の競合エラー
#    - どちらか一方のみを指定してください
#    - マネージドプロバイダー（GitHub、Bitbucket など）: provider_type を使用
#    - カスタムホスト（GitHub Enterprise Server など）: host_arn を使用
#
# 3. サポートされていないプロバイダー
#    - サポートされているプロバイダーとバージョンを確認してください
#    - https://docs.aws.amazon.com/dtconsole/latest/userguide/supported-versions-connections.html
#
# ============================================================================
