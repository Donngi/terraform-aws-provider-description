#---------------------------------------------------------------
# AWS Lambda Capacity Provider
#---------------------------------------------------------------
#
# Lambda Managed Instances用のキャパシティプロバイダーをプロビジョニングするリソースです。
# キャパシティプロバイダーはLambda Managed Instancesを実行するための基盤であり、
# セキュリティ境界として機能します。VPC設定・権限・インスタンス要件・スケーリング設定を
# 定義し、Lambda関数が顧客所有のEC2インスタンス上で実行されるインフラを提供します。
#
# AWS公式ドキュメント:
#   - キャパシティプロバイダー: https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-capacity-providers.html
#   - Lambda Managed Instances: https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances.html
#   - スケーリング設定API: https://docs.aws.amazon.com/lambda/latest/api/API_CapacityProviderScalingConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_capacity_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lambda_capacity_provider" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: キャパシティプロバイダーの一意な名前を指定します。
  # 設定可能な値: AWSアカウントおよびリージョン内で一意の文字列
  name = "example-capacity-provider"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_arn (Optional)
  # 設定内容: キャパシティプロバイダーのデータ（保存時・転送時）を暗号化するKMSキーのARNを指定します。
  # 設定可能な値: 有効なAWS KMSキーARN
  # 省略時: KMS暗号化を使用しない
  # 参考: https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-capacity-providers.html
  kms_key_arn = null

  #-------------------------------------------------------------
  # インスタンス要件設定
  #-------------------------------------------------------------

  # instance_requirements (Optional)
  # 設定内容: キャパシティプロバイダーが使用するコンピュートインスタンスの要件を指定します。
  # 省略時: Lambdaがコスト・パフォーマンスに基づいて自動的にインスタンスタイプを選択します。
  # 関連機能: Lambda Managed Instances インスタンスタイプ選択
  #   特定のハードウェア要件やコスト最適化のためにインスタンスタイプをカスタマイズ可能です。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-scaling.html
  # 注意: allowed_instance_types と excluded_instance_types は排他的（どちらか一方のみ指定可能）
  instance_requirements = [
    {
      # architectures (Required in block)
      # 設定内容: CPUアーキテクチャのリストを指定します。
      # 設定可能な値:
      #   - ["x86_64"]: x86_64アーキテクチャ
      #   - ["arm64"]: ARM64アーキテクチャ（Graviton）
      architectures = ["x86_64"]

      # allowed_instance_types (Optional)
      # 設定内容: 使用を許可するインスタンスタイプのリストを指定します。
      # 設定可能な値: 有効なEC2インスタンスタイプのリスト（例: ["m5.xlarge", "c6i.2xlarge"]）
      # 省略時: アーキテクチャに基づいてLambdaが自動選択
      # 注意: excluded_instance_types と排他的
      allowed_instance_types = ["c6i.2xlarge", "c7i.2xlarge"]

      # excluded_instance_types (Optional)
      # 設定内容: 使用を除外するインスタンスタイプのリストを指定します。
      # 設定可能な値: 有効なEC2インスタンスタイプのリスト
      # 省略時: 除外なし
      # 注意: allowed_instance_types と排他的
      excluded_instance_types = []
    }
  ]

  #-------------------------------------------------------------
  # スケーリング設定
  #-------------------------------------------------------------

  # capacity_provider_scaling_config (Optional)
  # 設定内容: キャパシティプロバイダーのスケーリングポリシー設定を指定します。
  # 省略時: デフォルトのスケーリング動作（Autoモード）を使用
  # 関連機能: Lambda Managed Instances スケーリング
  #   需要に応じてコンピュートインスタンスをスケールするスケーリングモードとポリシーを定義。
  #   Autoモードは需要に基づいて自動調整。Manualモードはポリシーに基づく手動制御。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-scaling.html
  #   - https://docs.aws.amazon.com/lambda/latest/api/API_CapacityProviderScalingConfig.html
  capacity_provider_scaling_config = [
    {
      # max_vcpu_count (Optional)
      # 設定内容: キャパシティプロバイダーが全コンピュートインスタンスを通じてプロビジョニングできる最大vCPU数を指定します。
      # 設定可能な値: 2〜15000の整数
      # 省略時: 制限なし
      max_vcpu_count = 100

      # scaling_mode (Required in block)
      # 設定内容: キャパシティプロバイダーが需要変化に対応するスケーリングモードを指定します。
      # 設定可能な値:
      #   - "Auto": 需要に基づいて自動的にインスタンス数を調整
      #   - "Manual": スケーリングポリシーに基づく手動制御
      # 省略時: "Auto"
      scaling_mode = "Auto"

      # scaling_policies (Optional)
      # 設定内容: メトリクスとしきい値に基づくスケーリングポリシーのリストを指定します。
      # 省略時: スケーリングポリシーなし
      # 注意: scaling_mode が "Manual" の場合のみ必須
      scaling_policies = [
        {
          # predefined_metric_type (Required in block)
          # 設定内容: スケーリングポリシーの定義済みメトリクスタイプを指定します。
          # 設定可能な値:
          #   - "LambdaCapacityProviderAverageCPUUtilization": 平均CPU使用率に基づくスケーリング
          predefined_metric_type = "LambdaCapacityProviderAverageCPUUtilization"

          # target_value (Required in block)
          # 設定内容: スケーリングポリシーのターゲット値を指定します。
          # 設定可能な値: 数値（例: CPU使用率50%の場合は50）
          target_value = 50
        }
      ]
    }
  ]

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Required)
  # 設定内容: コンピュートインスタンスのネットワーク設定ブロックです。
  # 関連機能: Lambda VPC接続
  #   キャパシティプロバイダーが起動するEC2インスタンスを配置するVPCサブネットと
  #   セキュリティグループを指定します。高可用性のため複数AZのサブネットを推奨。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-capacity-providers.html
  #   - https://docs.aws.amazon.com/lambda/latest/api/API_CapacityProviderVpcConfig.html
  vpc_config {

    # subnet_ids (Required)
    # 設定内容: キャパシティプロバイダーがコンピュートインスタンスを起動するサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット（最小1個、最大16個）
    # 注意: 高可用性のため複数AZにわたるサブネットの指定を推奨
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # security_group_ids (Required)
    # 設定内容: キャパシティプロバイダーが管理するコンピュートインスタンスのネットワークアクセスを
    #           制御するセキュリティグループIDのセットを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット（最大5個）
    security_group_ids = ["sg-12345678"]
  }

  #-------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------

  # permissions_config (Required)
  # 設定内容: キャパシティプロバイダーの権限設定ブロックです。
  # 関連機能: Lambda Managed Instances オペレーターロール
  #   LambdaがEC2インスタンスおよび関連リソースを作成・管理するために必要な
  #   IAMロールを指定します。このロールはキャパシティプロバイダーオペレーターロールと呼ばれます。
  #   - https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-capacity-providers.html
  permissions_config {

    # capacity_provider_operator_role_arn (Required)
    # 設定内容: LambdaがキャパシティプロバイダーのEC2リソースを管理することを許可するIAMロールのARNを指定します。
    # 設定可能な値: 有効なIAMロールARN
    capacity_provider_operator_role_arn = "arn:aws:iam::123456789012:role/lambda-capacity-provider-operator-role"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-capacity-provider"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（有効な単位: s, m, h）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（有効な単位: s, m, h）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（有効な単位: s, m, h）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: キャパシティプロバイダーのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
