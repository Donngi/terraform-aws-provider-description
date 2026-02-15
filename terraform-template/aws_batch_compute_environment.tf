#---------------------------------------
# AWS Batch Compute Environment
#---------------------------------------
# AWS Batchのコンピューティング環境を作成します。
# コンピューティング環境は、コンテナ化されたバッチジョブの実行に使用される
# Amazon ECSコンテナインスタンスを含みます。
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
#
# NOTE:
# - 環境削除時の競合状態を防ぐため、関連するaws_iam_role_policy_attachmentに
#   depends_onを設定してください。設定しないとポリシーが早期に削除され、
#   コンピューティング環境がDELETING状態でスタックする可能性があります。
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/batch_compute_environment

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_batch_compute_environment" "example" {
  # 設定内容: コンピューティング環境の名前
  # 設定可能な値: 最大128文字（大文字・小文字・数字・アンダースコア）
  # 省略時: Terraformがランダムで一意な名前を自動生成
  name = "example-compute-env"

  # 設定内容: コンピューティング環境の名前プレフィックス
  # 設定可能な値: 任意の文字列（この値で始まる一意な名前が自動生成される）
  # 省略時: プレフィックスなしで名前が設定される
  # 【注意】nameと同時に指定できません
  name_prefix = null

  # 設定内容: コンピューティング環境のタイプ
  # 設定可能な値: MANAGED（AWS Batchが管理）、UNMANAGED（ユーザーが管理）
  # 省略時: 設定必須（required）
  type = "MANAGED"

  #---------------------------------------
  # IAMロール設定
  #---------------------------------------

  # 設定内容: AWS BatchがAWSサービスを呼び出すためのIAMロールのARN
  # 設定可能な値: 有効なIAMロールのARN
  # 省略時: 一部の環境では自動的に設定されるが、明示的な指定を推奨
  service_role = "arn:aws:iam::123456789012:role/aws-batch-service-role"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（us-east-1、ap-northeast-1など）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #---------------------------------------
  # 状態管理
  #---------------------------------------

  # 設定内容: コンピューティング環境の状態
  # 設定可能な値: ENABLED（ジョブを受け付けて自動スケール）、DISABLED（無効化）
  # 省略時: ENABLED
  state = "ENABLED"

  #---------------------------------------
  # コンピューティングリソース設定（マネージド環境）
  #---------------------------------------

  compute_resources {
    #-------
    # インスタンスタイプ設定
    #-------

    # 設定内容: コンピューティングリソースのタイプ
    # 設定可能な値: EC2、SPOT、FARGATE、FARGATE_SPOT
    # 省略時: 設定必須（required）
    type = "EC2"

    # 設定内容: 起動可能なEC2インスタンスタイプのリスト
    # 設定可能な値: 有効なEC2インスタンスタイプ（c4.large、optimalなど）
    # 省略時: Fargateでは不要、EC2/SPOTでは設定を推奨
    instance_type = [
      "c4.large",
      "c5.large",
    ]

    #-------
    # ネットワーク設定
    #-------

    # 設定内容: コンピューティングリソースが起動されるVPCサブネットのリスト
    # 設定可能な値: 有効なサブネットIDのリスト
    # 省略時: 設定必須（required）
    subnets = [
      "subnet-12345678",
      "subnet-87654321",
    ]

    # 設定内容: インスタンスに関連付けるセキュリティグループのリスト
    # 設定可能な値: 有効なセキュリティグループIDのリスト
    # 省略時: Fargate環境では必須、EC2環境ではデフォルトSGが使用される
    security_group_ids = [
      "sg-12345678",
    ]

    #-------
    # vCPU容量設定
    #-------

    # 設定内容: 環境が到達可能な最大EC2 vCPU数
    # 設定可能な値: 正の整数
    # 省略時: 設定必須（required）
    max_vcpus = 16

    # 設定内容: 環境が維持する最小EC2 vCPU数
    # 設定可能な値: 0以上の整数
    # 省略時: EC2/SPOT環境では0、Fargateでは設定不要
    min_vcpus = 0

    # 設定内容: 環境内の希望EC2 vCPU数
    # 設定可能な値: min_vcpus以上max_vcpus以下の整数
    # 省略時: 自動的に調整される（Fargateでは設定不要）
    # desired_vcpus = 4

    #-------
    # IAMロール設定（EC2/SPOT専用）
    #-------

    # 設定内容: EC2インスタンスに適用されるECSインスタンスロール
    # 設定可能な値: 有効なIAMインスタンスプロファイルのARN
    # 省略時: EC2/SPOT環境では設定を推奨、Fargateでは設定不要
    instance_role = "arn:aws:iam::123456789012:instance-profile/ecs-instance-role"

    #-------
    # アロケーション戦略（EC2/SPOT専用）
    #-------

    # 設定内容: 最適なインスタンスタイプが不足している場合のリソース割り当て戦略
    # 設定可能な値: BEST_FIT（最適フィット）、BEST_FIT_PROGRESSIVE（段階的最適フィット）、SPOT_CAPACITY_OPTIMIZED（スポット容量最適化）
    # 省略時: BEST_FIT（Fargateでは設定不要）
    # allocation_strategy = "BEST_FIT_PROGRESSIVE"

    #-------
    # スポットインスタンス設定（SPOT専用）
    #-------

    # 設定内容: スポットインスタンス価格の最大入札パーセンテージ（オンデマンド価格比）
    # 設定可能な値: 1〜100の整数（例: 20 = オンデマンド価格の20%）
    # 省略時: 100（オンデマンド価格の100%まで）
    # bid_percentage = 50

    # 設定内容: SPOTコンピューティング環境用のEC2 Spot Fleet IAMロールのARN
    # 設定可能な値: 有効なIAMロールのARN
    # 省略時: SPOT環境では必須、他の環境では設定不要
    # spot_iam_fleet_role = "arn:aws:iam::123456789012:role/aws-ec2-spot-fleet-role"

    #-------
    # EC2設定（EC2/SPOT専用）
    #-------

    # 設定内容: インスタンス起動時に使用されるEC2キーペア名
    # 設定可能な値: 既存のEC2キーペア名
    # 省略時: キーペアなしで起動（Fargateでは設定不要）
    # ec2_key_pair = "my-key-pair"

    # 設定内容: インスタンスに使用されるAMI ID（非推奨）
    # 設定可能な値: 有効なAMI ID
    # 省略時: デフォルトのECS最適化AMIが使用される
    # 【注意】このパラメータは非推奨です。代わりにec2_configuration内のimage_id_overrideを使用してください
    # image_id = "ami-12345678"

    # 設定内容: コンピューティングリソースに関連付けるEC2プレースメントグループ
    # 設定可能な値: 既存のプレースメントグループ名
    # 省略時: プレースメントグループなし（Fargateでは設定不要）
    # placement_group = "my-placement-group"

    #-------
    # リソースタグ（EC2/SPOT専用）
    #-------

    # 設定内容: コンピューティング環境で起動されるリソースに適用されるタグ
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: タグなし（Fargateでは設定不要）
    # tags = {
    #   Name        = "batch-compute-instance"
    #   Environment = "production"
    # }

    #-------
    # EC2設定詳細
    #-------

    # ec2_configuration {
    #   # 設定内容: インスタンスタイプに一致させるイメージタイプ
    #   # 設定可能な値: ECS_AL2（Amazon Linux 2）、ECS_AL2_NVIDIA（GPU対応）など
    #   # 省略時: image_id_overrideが未指定の場合、最新のECS_AL2 AMIが使用される
    #   image_type = "ECS_AL2"
    #
    #   # 設定内容: イメージタイプに一致するインスタンスに使用されるAMI ID
    #   # 設定可能な値: 有効なAMI ID
    #   # 省略時: image_typeに基づいてデフォルトAMIが使用される
    #   image_id_override = "ami-12345678"
    #
    #   # 設定内容: コンピューティング環境のKubernetesバージョン
    #   # 設定可能な値: AWS BatchがサポートするKubernetesバージョン
    #   # 省略時: AWS Batchがサポートする最新バージョンが使用される
    #   image_kubernetes_version = "1.27"
    # }

    #-------
    # 起動テンプレート設定
    #-------

    # launch_template {
    #   # 設定内容: 起動テンプレートのID
    #   # 設定可能な値: 有効な起動テンプレートID
    #   # 省略時: launch_template_nameまたはこのパラメータのいずれかが必須
    #   launch_template_id = "lt-12345678"
    #
    #   # 設定内容: 起動テンプレートの名前
    #   # 設定可能な値: 既存の起動テンプレート名
    #   # 省略時: launch_template_idまたはこのパラメータのいずれかが必須
    #   launch_template_name = "my-launch-template"
    #
    #   # 設定内容: 起動テンプレートのバージョン番号
    #   # 設定可能な値: 起動テンプレートの有効なバージョン番号、$Latest、$Default
    #   # 省略時: 起動テンプレートのデフォルトバージョン
    #   version = "$Latest"
    # }
  }

  #---------------------------------------
  # EKS統合設定
  #---------------------------------------

  # eks_configuration {
  #   # 設定内容: Amazon EKSクラスターのARN
  #   # 設定可能な値: 有効なEKSクラスターのARN
  #   # 省略時: EKS統合を使用する場合は設定必須
  #   eks_cluster_arn = "arn:aws:eks:ap-northeast-1:123456789012:cluster/my-cluster"
  #
  #   # 設定内容: AWS Batchがポッドを管理するKubernetesネームスペース
  #   # 設定可能な値: 有効なKubernetesネームスペース名
  #   # 省略時: EKS統合を使用する場合は設定必須
  #   kubernetes_namespace = "batch-jobs"
  # }

  #---------------------------------------
  # 更新ポリシー設定
  #---------------------------------------

  # update_policy {
  #   # 設定内容: インフラ更新時のジョブタイムアウト時間（分）
  #   # 設定可能な値: 正の整数（分単位）
  #   # 省略時: デフォルトのタイムアウト値が使用される
  #   job_execution_timeout_minutes = 30
  #
  #   # 設定内容: インフラ更新時にジョブを自動的に終了するかどうか
  #   # 設定可能な値: true（終了する）、false（終了しない）
  #   # 省略時: デフォルトで自動的に計算される
  #   terminate_jobs_on_update = false
  # }

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに適用されるタグのキーと値のペア
  # 設定可能な値: キーと値の文字列マップ
  # 省略時: タグなし
  tags = {
    Name        = "example-compute-env"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #---------------------------------------
  # 依存関係設定
  #---------------------------------------

  # 重要: IAMロールポリシーアタッチメントへの依存関係を設定して
  # 環境削除時の競合状態を防ぎます
  # depends_on = [
  #   aws_iam_role_policy_attachment.aws_batch_service_role
  # ]
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn
#   コンピューティング環境のARN
#
# - ecs_cluster_arn
#   コンピューティング環境で使用される基盤となるECSクラスターのARN
#
# - status
#   コンピューティング環境の現在のステータス（CREATING、VALIDなど）
#
# - status_reason
#   コンピューティング環境の現在のステータスに関する追加詳細を提供する短い文字列
#
# - tags_all
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたタグのマップ
