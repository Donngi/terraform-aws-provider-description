#########################################################################
# CodeConnections Connection
#########################################################################
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeconnections_connection
#
# NOTE: 接続は初期状態でPENDINGステータスで作成される。AWSコンソールで
#       プロバイダーとの認証を完了する必要がある。認証完了後、ステータスが
#       AVAILABLEに変更される。
#
# AWS CodeConnectionsの接続を管理するリソース
#
# 【主な用途】
# - サードパーティのソースプロバイダー（GitHub、Bitbucket、GitLabなど）とAWSサービスの連携
# - CodePipelineなどのサービスからサードパーティリポジトリへのアクセス
# - GitHub Enterprise ServerやGitLab Self-Managedなどのホスト型プロバイダーとの統合
#
# 【重要な注意事項】
# - nameまたはprovider_typeの変更は新しいリソースを作成する
# - provider_typeとhost_arnは同時に指定できない（どちらか一方を選択）
#
# 【関連ドキュメント】
# - 接続の更新と認証: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html
# - 接続の概念: https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts-connections.html

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_codeconnections_connection" "example" {
  # 接続名（必須）
  # 設定内容: AWS アカウント内で一意となる接続の名前
  # 補足: 名前の変更は新しいリソースを作成する
  name = "example-connection"

  #-----------------------------------------------------------------------
  # プロバイダー設定（provider_typeまたはhost_arnのどちらか一方を指定）
  #-----------------------------------------------------------------------

  # プロバイダータイプ（任意）
  # 設定内容: サードパーティコードリポジトリが設定されている外部プロバイダーの名前
  # 設定可能な値:
  #   - Bitbucket          : Bitbucket Cloud
  #   - GitHub             : GitHub.com
  #   - GitHubEnterpriseServer : GitHub Enterprise Server（ホスト設定が必要）
  #   - GitLab             : GitLab.com
  #   - GitLabSelfManaged  : GitLab Self-Managed（ホスト設定が必要）
  #   - AzureDevOps        : Azure DevOps
  # 補足: host_arnとは同時に指定できない。変更時は新しいリソースを作成する
  provider_type = "Bitbucket"

  # ホストARN（任意）
  # 設定内容: 接続に関連付けるホストのAmazon Resource Name（ARN）
  # 補足: GitHub Enterprise ServerやGitLab Self-Managedなどのホスト型プロバイダーを使用する場合に指定
  # 補足: provider_typeとは同時に指定できない
  host_arn = null
  # host_arn = aws_codeconnections_host.example.arn

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # リージョン（任意）
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 補足: 特定のリージョンでリソースを管理する必要がある場合に明示的に指定
  region = null
  # region = "us-west-2"

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # リソースタグ（任意）
  # 設定内容: リソースに関連付けるキー・バリューペアのタグ
  # 補足: プロバイダーのdefault_tagsと統合される
  tags = {
    Environment = "production"
    Team        = "platform"
    ManagedBy   = "terraform"
  }

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # 操作タイムアウト（任意）
  # 設定内容: 各操作の最大待機時間
  # timeouts {
  #   # 作成タイムアウト
  #   # 設定内容: 接続作成時の最大待機時間
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # create = "10m"
  #
  #   # 更新タイムアウト
  #   # 設定内容: 接続更新時の最大待機時間
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # update = "10m"
  #
  #   # 削除タイムアウト
  #   # 設定内容: 接続削除時の最大待機時間
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # delete = "10m"
  # }
}

#########################################################################
# Attributes Reference（参照可能な属性）
#########################################################################
# このリソースから参照可能な属性:
#
# - arn              : 接続のARN（Amazon Resource Name）
# - connection_status: 接続のステータス（PENDING、AVAILABLE、ERROR）
# - owner_account_id : サードパーティコードリポジトリが設定されている外部プロバイダーの識別子
# - tags_all         : リソースに割り当てられた全タグ（プロバイダーのdefault_tagsを含む）
