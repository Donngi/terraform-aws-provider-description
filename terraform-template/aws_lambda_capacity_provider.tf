#---------------------------------------------------------------
# AWS Lambda Capacity Provider
#---------------------------------------------------------------
#
# AWS Lambda Capacity Provider は、Lambda Managed Instances を顧客所有の
# Amazon EC2 インスタンスで実行するための基盤となるリソースです。
# 大規模な Lambda ワークロード向けにコストを最適化しつつ、
# サーバーレスプログラミングモデルを維持できます。
#
# 主な特徴:
#   - 顧客所有の EC2 インスタンス上で Lambda 関数を実行
#   - VPC 内でのセキュリティ境界の設定
#   - 自動スケーリングによるコンピュートリソースの最適化
#   - インスタンスタイプやアーキテクチャの柔軟な指定
#
# ユースケース:
#   - 大規模な Lambda ワークロードのコスト最適化
#   - カスタムコンピュート要件を持つワークロード
#   - 特定のインスタンスタイプやアーキテクチャが必要な場合
#
# AWS公式ドキュメント:
#   - Capacity Providers 概要: https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-capacity-providers.html
#   - Getting Started: https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-getting-started.html
#   - SAM CapacityProvider: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-capacityprovider.html
#   - API Reference: https://docs.aws.amazon.com/lambda/latest/api/API_CapacityProviderScalingConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_capacity_provider
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
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
  # 設定内容: Capacity Provider の名前を指定します。
  # 設定可能な値: アカウントとリージョン内で一意となる文字列
  # 用途: Capacity Provider を識別するための名前
  # 注意: 作成後は変更できません (変更すると再作成されます)
  # VPC 設定 (必須)
  #-------------------------------------------------------------

  # vpc_config (Required)
  # 設定内容: VPC 設定を定義するブロックです。
  # 用途: EC2 インスタンスを起動する VPC のサブネットとセキュリティグループを指定
  # 重要: Capacity Provider は VPC 内でセキュリティ境界を提供します
  # アクセス許可設定 (必須)
  #-------------------------------------------------------------

  # permissions_config (Required)
  # 設定内容: Lambda が Capacity Provider を管理するために必要な
  #           IAM ロールの設定を定義するブロックです。
  # 用途: Lambda サービスが EC2 インスタンスの作成・管理権限を取得
  permissions_config {
    # capacity_provider_operator_role_arn (Required)
    # 設定内容: Lambda が Capacity Provider を操作するために使用する IAM ロールの ARN を指定します。
    # 設定可能な値: 有効な IAM ロール ARN
    # 必要な権限:
    #   - EC2 インスタンスの作成・削除・管理
    #   - VPC リソースへのアクセス
    #   - 関連するネットワーク設定の管理
    # 用途: Lambda サービスが顧客アカウント内の EC2 リソースを管理
    # 関連機能: Capacity Provider のアクセス許可
    #   - https://docs.aws.amazon.com/lambda/latest/dg/lambda-managed-instances-getting-started.html
    capacity_provider_operator_role_arn = "arn:aws:iam::123456789012:role/lambda-capacity-provider-operator"
  }

  #-------------------------------------------------------------
  # スケーリング設定 (オプション)
  #-------------------------------------------------------------

  # capacity_provider_scaling_config (Optional, Computed)
  # 設定内容: Capacity Provider が EC2 インスタンスを需要に応じて
  #           スケーリングする方法を定義するブロックです。
  # 省略時: デフォルトのスケーリング設定が適用されます
  # 用途: コスト効率とパフォーマンスのバランスを最適化
  capacity_provider_scaling_config {
    # max_vcpu_count (Optional)
    # 設定内容: Capacity Provider がプロビジョニングできる vCPU の最大数を指定します。
    # 設定可能な値: 2 〜 15,000 の整数
    # 省略時: デフォルト値が適用されます
    # 用途: コスト管理とリソース上限の設定
  # インスタンス要件 (オプション)
  #-------------------------------------------------------------

  # instance_requirements (Optional, Computed)
  # 設定内容: Capacity Provider が使用できるコンピュートインスタンスの
  #           タイプを指定するブロックです。
  # 省略時: Lambda が最適なインスタンスタイプを自動選択
  # KMS 暗号化設定 (オプション)
  #-------------------------------------------------------------

  # kms_key_arn (Optional)
  # 設定内容: Capacity Provider のデータ (転送中および保存時) を
  #           暗号化するために使用する AWS KMS キーの ARN を指定します。
  # 設定可能な値: 有効な KMS キー ARN
  # 省略時: AWS 管理キーが使用されます
  # 用途: データ暗号化のセキュリティ要件を満たす
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: マルチリージョン構成で特定のリージョンにリソースを作成
  # 関連機能: AWS リージョナルエンドポイント
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定 (オプション)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト配分、管理の簡素化
  # タイムアウト設定 (オプション)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  # 用途: 大規模な Capacity Provider の作成・更新・削除時のタイムアウトを調整
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Go の time.ParseDuration 形式 (例: "30s", "5m", "1h")
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 例: "30m" (30分)
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Go の time.ParseDuration 形式 (例: "30s", "5m", "1h")
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 例: "20m" (20分)
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Go の time.ParseDuration 形式 (例: "30s", "5m", "1h")
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 注意: 変更が state に保存された後、destroy 操作が発生する場合にのみ適用
    # 例: "30m" (30分)
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Capacity Provider の Amazon Resource Name (ARN)
#   形式: arn:aws:lambda:region:account-id:capacity-provider:name
#   用途: 他のリソースから Capacity Provider を参照する際に使用
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承された
#   タグを含む、リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
# resource "aws_lambda_function" "example" {
#   function_name = "example-function"
#   role          = aws_iam_role.lambda.arn
#   handler       = "index.handler"
#   runtime       = "python3.12"
#
#   capacity_provider_config {
#     capacity_provider_arn                     = aws_lambda_capacity_provider.example.arn
#     execution_environment_memory_gib_per_vcpu = 4
#     per_execution_environment_max_concurrency = 100
#   }
#
#---------------------------------------------------------------
