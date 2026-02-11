# ================================================================================
# Terraform AWS Resource: aws_codecatalyst_dev_environment
# ================================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-19)の AWS Provider v6.28.0 の
# 仕様に基づいています。最新の仕様や詳細については、必ず公式ドキュメントを
# ご確認ください。
#
# AWS CodeCatalyst Dev Environment
# クラウドベースの開発環境で、プロジェクトのソースリポジトリに保存されたコードを
# 操作するために使用します。統合開発環境(IDE)で作業でき、自動停止機能により
# コンピューティング時間を節約できます。
#
# 公式ドキュメント:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecatalyst_dev_environment
# - AWS API: https://docs.aws.amazon.com/codecatalyst/latest/APIReference/API_CreateDevEnvironment.html
# - AWS User Guide: https://docs.aws.amazon.com/codecatalyst/latest/userguide/devenvironment.html
# ================================================================================

resource "aws_codecatalyst_dev_environment" "example" {
  # ================================================================================
  # Required Arguments
  # ================================================================================

  # space_name - (Required) スペースの名前
  # CodeCatalystスペースは、プロジェクトとリソースを管理する最上位のコンテナです。
  # 3〜63文字の英数字、ハイフン、アンダースコア、ピリオドが使用可能です。
  # Type: string
  space_name = "my-space"

  # project_name - (Required) スペース内のプロジェクトの名前
  # CodeCatalystプロジェクトは、開発チームが共同作業を行う単位です。
  # 3〜63文字の英数字、ハイフン、アンダースコア、ピリオドが使用可能です。
  # Type: string
  project_name = "my-project"

  # instance_type - (Required) Dev Environmentで使用するAmazon EC2インスタンスタイプ
  # 利用可能な値:
  # - dev.standard1.small  : 2コア、4GB RAM
  # - dev.standard1.medium : 4コア、8GB RAM
  # - dev.standard1.large  : 8コア、16GB RAM
  # - dev.standard1.xlarge : 16コア、32GB RAM
  # Type: string
  instance_type = "dev.standard1.small"

  # ================================================================================
  # Optional Arguments
  # ================================================================================

  # alias - (Optional) Dev Environmentのユーザー定義エイリアス
  # 環境を識別しやすくするための名前です。1〜128文字の英数字、ハイフン、
  # アンダースコア、ピリオドが使用可能です。
  # Type: string
  alias = "my-dev-env"

  # inactivity_timeout_minutes - (Optional) アクティビティが検出されない場合に
  # Dev Environmentを停止するまでの時間(分単位)
  # 整数のみ指定可能です。Dev Environmentは実行中にコンピューティング時間を消費します。
  # 有効範囲: 0〜1200分(最大20時間)
  # Type: number
  inactivity_timeout_minutes = 30

  # region - (Optional) このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定で設定されたリージョンがデフォルトとして使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # Type: string (computed)
  # region = "us-west-2"

  # ================================================================================
  # Nested Blocks
  # ================================================================================

  # persistent_storage - (Required) Dev Environmentに割り当てられるストレージ容量の情報
  # CodeCatalystコンソールから作成する場合、デフォルトは16GBですが、
  # プログラム的に作成する場合はデフォルトがないため必ず指定が必要です。
  # Min items: 1, Max items: 1
  persistent_storage {
    # size - (Required) 永続ストレージのサイズ(ギガバイト、具体的にはGiB単位)
    # 有効な値はメモリサイズに基づき16GBの増分です。
    # 有効な値: 16, 32, 64
    # Type: number
    size = 16
  }

  # ides - (Required) Dev Environmentに設定される統合開発環境(IDE)の情報
  # Dev Environmentの作成にはIDEが必要です。
  # Min items: 1, Max items: 1
  ides {
    # name - (Optional) IDEの名前
    # 有効な値: Cloud9, IntelliJ, PyCharm, GoLand, VSCode
    # VSCodeの場合、runtimeパラメータは不要です。
    # Type: string
    name = "VSCode"

    # runtime - (Optional) IDEランタイムイメージへのリンク
    # nameがVSCodeの場合、このパラメータは不要です。
    # 他のIDEの場合の例:
    # - PyCharm: public.ecr.aws/jetbrains/py
    # - GoLand: public.ecr.aws/jetbrains/go
    # - IntelliJ: public.ecr.aws/jetbrains/idea
    # Type: string
    # runtime = "public.ecr.aws/jetbrains/py"
  }

  # repositories - (Optional) Dev Environmentにクローンするブランチを含むソースリポジトリ
  # プロジェクトのソースリポジトリを指定して、Dev Environment起動時に
  # 自動的にコードをクローンできます。
  # Max items: 100
  repositories {
    # repository_name - (Required) ソースリポジトリの名前
    # プロジェクト内のCodeCatalystソースリポジトリ名を指定します。
    # Type: string
    repository_name = "my-repository"

    # branch_name - (Optional) ソースリポジトリ内のブランチ名
    # 指定しない場合、デフォルトブランチが使用されます。
    # Type: string
    branch_name = "main"
  }

  # timeouts - (Optional) リソース操作のタイムアウト設定
  # Terraformがリソース操作を待機する最大時間を設定します。
  timeouts {
    # create - (Optional) リソース作成のタイムアウト
    # デフォルト: 30m
    # Type: string
    # create = "30m"

    # update - (Optional) リソース更新のタイムアウト
    # デフォルト: 30m
    # Type: string
    # update = "30m"

    # delete - (Optional) リソース削除のタイムアウト
    # デフォルト: 30m
    # Type: string
    # delete = "30m"
  }
}

# ================================================================================
# Computed Attributes (Read-Only)
# ================================================================================
# 以下の属性はTerraformによって自動的に計算され、読み取り専用です:
#
# - id: Dev Environmentの一意な識別子(UUID形式)
#
# これらの属性は出力値として参照できます:
# output "dev_environment_id" {
#   value = aws_codecatalyst_dev_environment.example.id
# }
# ================================================================================
