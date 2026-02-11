#---------------------------------------------------------------
# AWS CodeStar Connections
#---------------------------------------------------------------
#
# AWS CodeStar Connectionsのコネクションリソースをプロビジョニングします。
# コネクションは、AWS リソース（CodePipelineなど）を外部コードリポジトリ
# （Bitbucket、GitHub、GitHub Enterprise Server、GitLab、GitLab self-managed）
# に接続するために使用される設定リソースです。
#
# 重要: このリソースは作成後、PENDING状態になります。
#       AWSコンソールで接続プロバイダーとの認証を完了する必要があります。
#
# AWS公式ドキュメント:
#   - CodeStar Connections概要: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections.html
#   - 接続の更新方法: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html
#   - CodeConnections APIリファレンス: https://docs.aws.amazon.com/codeconnections/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codestarconnections_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: 作成する接続の名前を指定します。
  # 設定可能な値: AWS アカウント内で一意な名前（文字列）
  # 注意: 名前を変更すると新しいリソースが作成されます
  name = "example-connection"

  #-------------------------------------------------------------
  # プロバイダー設定
  #-------------------------------------------------------------

  # provider_type (Optional, Forces new resource, Computed)
  # 設定内容: サードパーティコードリポジトリが設定されている外部プロバイダーの名前を指定します。
  # 設定可能な値:
  #   - "Bitbucket": Bitbucketリポジトリ
  #   - "GitHub": GitHubリポジトリ
  #   - "GitHubEnterpriseServer": GitHub Enterprise Serverリポジトリ
  #   - "GitLab": GitLab.comリポジトリ
  #   - "GitLabSelfManaged": GitLab self-managedリポジトリ
  # 省略時: host_arnから自動的に推測されます
  # 注意:
  #   - provider_typeを変更すると新しいリソースが作成されます
  #   - host_arnと競合します（どちらか一方のみ指定可能）
  provider_type = "Bitbucket"

  # host_arn (Optional, Forces new resource)
  # 設定内容: 接続に関連付けられたホストのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なCodeStar Connections ホストのARN
  # 用途: GitHub Enterprise ServerやGitLab self-managedなど、インストール型プロバイダーを使用する場合に指定
  # 関連機能: CodeStar Connections ホスト
  #   インストール型プロバイダー（GitHub Enterprise Server等）が
  #   インストールされているサーバーを表すリソース。
  #   ホストの作成方法: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-hosts.html
  # 注意:
  #   - provider_typeと競合します（どちらか一方のみ指定可能）
  #   - host_arnを変更すると新しいリソースが作成されます
  host_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
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
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-tag.html
  tags = {
    Name        = "example-connection"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられるすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #        すべてのタグが自動的に設定されます
  # 注意: 通常は省略し、tagsとプロバイダーのdefault_tagsで管理することを推奨
  tags_all = null

  #-------------------------------------------------------------
  # その他の設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: CodeStar ConnectionのARN
  # 省略時: 自動的にConnectionのARNが設定されます
  # 注意: 通常は省略し、自動生成されたIDを使用することを推奨
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: CodeStar ConnectionのARN
#
# - arn: CodeStar ConnectionのARN
#
# - connection_status: CodeStar Connectionのステータス
#                      設定可能な値: "PENDING", "AVAILABLE", "ERROR"
#                      - PENDING: 接続が作成されたが、プロバイダーとの認証が完了していない
#                      - AVAILABLE: 接続が使用可能（認証完了）
#                      - ERROR: 接続にエラーが発生
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
