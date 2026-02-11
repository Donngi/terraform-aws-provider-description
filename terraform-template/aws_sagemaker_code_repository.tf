#---------------------------------------------------------------
# Amazon SageMaker Code Repository
#---------------------------------------------------------------
#
# Amazon SageMakerアカウントにGitリポジトリリソースをプロビジョニングするリソースです。
# AWS CodeCommitまたはその他のGitリポジトリをSageMakerノートブックインスタンスや
# Studio環境で利用できるようにします。
#
# AWS公式ドキュメント:
#   - GitConfig API リファレンス: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_GitConfig.html
#   - CreateCodeRepository API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateCodeRepository.html
#   - SageMaker Code Repository CLI設定: https://docs.aws.amazon.com/sagemaker/latest/dg/nbi-git-resource-cli.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_code_repository
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_code_repository" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # code_repository_name (Required, Forces new resource)
  # 設定内容: コードリポジトリの名前を指定します。
  # 設定可能な値: 1-63文字の英数字とハイフン。一意である必要があります。
  # パターン: ^[a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}$
  # 注意: リソース作成後の変更は新しいリソースの作成を強制します。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateCodeRepository.html
  code_repository_name = "my-code-repository"

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: Terraformリソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: コードリポジトリの名前が自動的に割り当てられます
  # 注意: 通常は明示的に設定する必要はありません
  id = null

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
  # Git設定
  #-------------------------------------------------------------

  # git_config (Required)
  # 設定内容: Gitリポジトリの詳細情報を指定します。
  # 注意: このブロックは必須です。最小1個、最大1個まで設定可能です。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_GitConfig.html
  git_config {
    # repository_url (Required)
    # 設定内容: Gitリポジトリが配置されているURLを指定します。
    # 設定可能な値: 11-1024文字のHTTPS URL
    # パターン: ^https://([^/]+)/?.{3,1016}$
    # 例:
    #   - AWS CodeCommit: https://git-codecommit.{region}.amazonaws.com/v1/repos/{repo-name}
    #   - GitHub: https://github.com/{owner}/{repository}.git
    #   - GitLab: https://gitlab.com/{owner}/{repository}.git
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_GitConfig.html
    repository_url = "https://github.com/example/my-repository.git"

    # branch (Optional)
    # 設定内容: Gitリポジトリのデフォルトブランチを指定します。
    # 設定可能な値: 1-1024文字のブランチ名
    # パターン: ^[^ ~^:?*\[]+$（スペース、~、^、:、?、*、[を含まない）
    # 省略時: リポジトリのデフォルトブランチが使用されます
    # 例: "main", "master", "develop"
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_GitConfig.html
    branch = "main"

    # secret_arn (Optional)
    # 設定内容: Gitリポジトリへのアクセスに使用する認証情報を含む
    #           AWS Secrets ManagerシークレットのARNを指定します。
    # 設定可能な値: 1-2048文字の有効なSecrets Manager ARN
    # パターン: ^arn:aws[a-z\-]*:secretsmanager:[a-z0-9\-]*:[0-9]{12}:secret:.*$
    # シークレット形式: {"username": "UserName", "password": "Password"} のJSON形式
    # ステージングラベル: AWSCURRENT が必要
    # 省略時: 認証なしでアクセス可能なパブリックリポジトリとして扱われます
    # 用途: プライベートリポジトリへのアクセスに必要
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_GitConfig.html
    secret_arn = "arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:my-git-credentials-AbCdEf"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-code-repository"
    Environment = "production"
    Team        = "data-science"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられた全てのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsが自動的にマージされます
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #   リソースに割り当てられたすべてのタグのマップです。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # 注意: 通常は明示的に設定する必要はありません
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コードリポジトリの名前
#
# - arn: AWSによって割り当てられたコードリポジトリの
#        Amazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
