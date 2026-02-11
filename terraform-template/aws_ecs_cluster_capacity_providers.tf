#---------------------------------------------------------------
# ECS Cluster Capacity Providers
#---------------------------------------------------------------
#
# ECSクラスターのキャパシティプロバイダーを管理するリソース。
# キャパシティプロバイダーは、ECSクラスターにコンピューティング容量を提供し、
# タスクを実行するためのインフラストラクチャを制御します。
# Fargate、Fargate Spot、またはEC2 Auto Scalingグループベースの
# キャパシティプロバイダーを設定できます。
#
# AWS公式ドキュメント:
#   - Amazon ECS cluster capacity: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/capacity-cluster-best-practice.html
#   - Cluster capacity: https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/capacity-cluster.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ecs_cluster_capacity_providers
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_cluster_capacity_providers" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) ECSクラスターの名前
  # キャパシティプロバイダーを管理する対象のクラスター名を指定します。
  # この値を変更すると新しいリソースが作成されます（Forces new resource）。
  cluster_name = "my-cluster"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) クラスターに関連付けるキャパシティプロバイダーの名前のセット
  # 以下の値を指定できます:
  # - "FARGATE": AWS Fargateによるサーバーレスコンピューティング
  # - "FARGATE_SPOT": Fargateのスポットインスタンス（コスト削減、中断可能）
  # - カスタムEC2キャパシティプロバイダー名: EC2 Auto Scalingグループベース
  #
  # 複数のキャパシティプロバイダーを組み合わせることで、
  # コストとパフォーマンスのバランスを最適化できます。
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  # (Optional) リソースを管理するAWSリージョン
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # (Optional) デフォルトのキャパシティプロバイダー戦略
  # タスクやサービスの起動時にキャパシティプロバイダー戦略が
  # 明示的に指定されていない場合に使用される戦略を定義します。
  # 複数のキャパシティプロバイダー間でタスクを分散する方法を制御します。
  default_capacity_provider_strategy {
    # (Required) キャパシティプロバイダーの名前
    # capacity_providersで指定した名前のいずれかを指定します。
    capacity_provider = "FARGATE"

    # (Optional) 最小限実行するタスクの数
    # 指定したキャパシティプロバイダー上で最低限実行されるタスクの数を定義します。
    # baseを定義できるのは、戦略内の1つのキャパシティプロバイダーのみです。
    # デフォルト: 0
    #
    # 例: base = 2 の場合、最低2つのタスクがこのプロバイダーで実行されます。
    base = 1

    # (Optional) タスク配分の重み
    # baseで指定した数のタスクを満たした後、残りのタスクを
    # 各キャパシティプロバイダーに配分する際の相対的な割合を指定します。
    # デフォルト: 0
    #
    # 例: プロバイダーAのweight=100、プロバイダーBのweight=50の場合、
    # base以降のタスクは2:1の比率でAとBに分散されます。
    weight = 100
  }

  # 複数のキャパシティプロバイダー戦略の例:
  # 以下のようにFargateとFargate Spotを組み合わせることで、
  # コスト最適化と可用性のバランスを取ることができます。
  #
  # default_capacity_provider_strategy {
  #   capacity_provider = "FARGATE"
  #   base              = 1
  #   weight            = 1
  # }
  #
  # default_capacity_provider_strategy {
  #   capacity_provider = "FARGATE_SPOT"
  #   base              = 0
  #   weight            = 4
  # }
  #
  # 上記の設定では:
  # - 最低1つのタスクはFargateで実行（base = 1）
  # - それ以降のタスクは1:4の比率でFargate:Fargate Spotに配分
  # - 結果として約80%のタスクがFargate Spotで実行されコスト削減
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed only）:
#
# - id: cluster_nameと同じ値
#---------------------------------------------------------------

