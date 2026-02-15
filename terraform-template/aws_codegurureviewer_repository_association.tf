#---------------------------------------
# AWS CodeGuru Reviewer Repository Association
#---------------------------------------
# 用途: CodeGuru ReviewerとCodeCommit/Bitbucket/GitHub Enterprise Server/S3リポジトリの
#       関連付けを管理し、コードレビューの自動化を実現するリソース
#
# 主な機能:
# - 各種リポジトリタイプのサポート（CodeCommit/Bitbucket/GitHub Enterprise/S3）
# - KMS暗号化キーの設定
# - リポジトリとの関連付けライフサイクル管理
#
# 関連リソース:
# - aws_codecommit_repository: CodeCommitリポジトリ
# - aws_kms_key: カスタマー管理KMSキー
# - aws_codestarconnections_connection: Bitbucket/GitHub Enterprise接続
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/codeguru/latest/reviewer-ug/welcome.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codegurureviewer_repository_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: CodeStar接続を使用するリポジトリ（Bitbucket/GitHub Enterprise Server）の場合、
#       接続が「Available」ステータスである必要があります。
#---------------------------------------

#---------------------------------------
# リポジトリ設定
#---------------------------------------

resource "aws_codegurureviewer_repository_association" "example" {
  #---------------------------------------
  # 必須設定
  #---------------------------------------

  # リポジトリ設定ブロック（必須）
  # 設定内容: CodeGuru Reviewerと関連付けるリポジトリの設定
  # 注意事項: codecommit、bitbucket、github_enterprise_server、s3_bucketのいずれか1つを指定
  repository {
    # CodeCommitリポジトリの設定（オプション）
    # 設定内容: AWSマネージドのGitリポジトリとの関連付け
    # 注意事項: Bitbucket/GitHub Enterprise Serverと排他的
    codecommit {
      # リポジトリ名（必須）
      # 設定内容: CodeCommitリポジトリの名前
      # 設定例: "my-application-repo"
      name = "example-repo"
    }

    # Bitbucketリポジトリの設定（オプション）
    # 設定内容: Bitbucket Cloudリポジトリとの関連付け
    # 注意事項: CodeStar接続が「Available」ステータスである必要がある
    # bitbucket {
    #   # CodeStar接続ARN（必須）
    #   # 設定内容: Bitbucket接続用のCodeStar Connections ARN
    #   # 設定例: aws_codestarconnections_connection.bitbucket.arn
    #   connection_arn = "arn:aws:codestar-connections:us-east-1:123456789012:connection/example-id"
    #
    #   # リポジトリ名（必須）
    #   # 設定内容: Bitbucketリポジトリの名前
    #   # 設定例: "my-application"
    #   name = "example-repo"
    #
    #   # リポジトリオーナー（必須）
    #   # 設定内容: Bitbucketワークスペース名またはユーザー名
    #   # 設定例: "my-organization"
    #   owner = "example-owner"
    # }

    # GitHub Enterprise Serverリポジトリの設定（オプション）
    # 設定内容: GitHub Enterprise Serverリポジトリとの関連付け
    # 注意事項: CodeStar接続が「Available」ステータスである必要がある
    # github_enterprise_server {
    #   # CodeStar接続ARN（必須）
    #   # 設定内容: GitHub Enterprise Server接続用のCodeStar Connections ARN
    #   # 設定例: aws_codestarconnections_connection.github.arn
    #   connection_arn = "arn:aws:codestar-connections:us-east-1:123456789012:connection/example-id"
    #
    #   # リポジトリ名（必須）
    #   # 設定内容: GitHub Enterprise Serverリポジトリの名前
    #   # 設定例: "my-application"
    #   name = "example-repo"
    #
    #   # リポジトリオーナー（必須）
    #   # 設定内容: GitHubオーガニゼーション名またはユーザー名
    #   # 設定例: "my-organization"
    #   owner = "example-owner"
    # }

    # S3バケットリポジトリの設定（オプション）
    # 設定内容: S3バケットに格納されたコードとの関連付け
    # 注意事項: ソースコードアーティファクトがS3に格納されている場合に使用
    # s3_bucket {
    #   # バケット名（必須）
    #   # 設定内容: コードが格納されているS3バケットの名前
    #   # 設定例: "my-code-bucket"
    #   bucket_name = "example-bucket"
    #
    #   # リポジトリ名（必須）
    #   # 設定内容: このS3ベースリポジトリの論理名
    #   # 設定例: "s3-based-repo"
    #   name = "example-repo"
    # }
  }

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------

  # KMSキー設定ブロック（オプション）
  # 設定内容: CodeGuru Reviewerが使用する暗号化キーの設定
  # 省略時: AWS管理キーによる暗号化
  kms_key_details {
    # 暗号化オプション（オプション）
    # 設定内容: 暗号化方式の選択
    # 設定可能な値:
    #   - AWS_OWNED_CMK: AWS所有のキー（デフォルト）
    #   - CUSTOMER_MANAGED_CMK: カスタマー管理キー
    # 省略時: AWS_OWNED_CMK
    encryption_option = "CUSTOMER_MANAGED_CMK"

    # KMSキーID（オプション）
    # 設定内容: カスタマー管理キーを使用する場合のKMSキーID
    # 設定例: aws_kms_key.example.key_id
    # 注意事項: encryption_option = "CUSTOMER_MANAGED_CMK"の場合に指定
    kms_key_id = "alias/example-key"
  }

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # リージョン（オプション）
  # 設定内容: このリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # 設定例: "us-east-1"
  # 注意事項: リポジトリとCodeGuru Reviewerは同じリージョンに存在する必要がある
  region = null

  # タグ（オプション）
  # 設定内容: リソースに付与するタグのマップ
  # 設定例: { Environment = "production", Project = "code-review" }
  # 注意事項: CodeGuruサービスが自動的に"codeguru-reviewer"タグを追加する
  tags = {
    Name        = "example-codegurureviewer-repository-association"
    Environment = "production"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # 操作タイムアウト（オプション）
  # 設定内容: リソース操作の最大待機時間
  # timeouts {
  #   # 作成タイムアウト（オプション）
  #   # 設定内容: リソース作成の最大待機時間
  #   # 省略時: 30分
  #   # 設定例: "45m"
  #   create = "30m"
  #
  #   # 更新タイムアウト（オプション）
  #   # 設定内容: リソース更新の最大待機時間
  #   # 省略時: 30分
  #   # 設定例: "45m"
  #   update = "30m"
  #
  #   # 削除タイムアウト（オプション）
  #   # 設定内容: リソース削除の最大待機時間
  #   # 省略時: 30分
  #   # 設定例: "45m"
  #   delete = "30m"
  # }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースでは以下の属性を参照可能:
#
# - id: リポジトリ関連付けを識別するARN
# - arn: リポジトリ関連付けのAmazon Resource Name
# - association_id: リポジトリ関連付けのID
# - connection_arn: CodeStar Connections接続のARN（Bitbucket/GitHub Enterpriseの場合）
# - name: リポジトリの名前
# - owner: リポジトリのオーナー（Bitbucket/GitHub Enterpriseの場合）
# - provider_type: リポジトリプロバイダーのタイプ
# - state: リポジトリ関連付けの状態
# - state_reason: 現在の状態の理由説明
# - s3_repository_details: S3リポジトリの詳細情報（S3バケット使用時）
# - tags_all: デフォルトタグを含む全てのタグ
#---------------------------------------
