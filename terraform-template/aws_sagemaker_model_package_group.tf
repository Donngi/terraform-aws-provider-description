# ====================================================================
# AWS SageMaker Model Package Group - Annotated Terraform Template
# ====================================================================
# 生成日: 2026-02-03
# Provider: hashicorp/aws
# Version: 6.28.0
#
# このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_model_package_group
# ====================================================================

# AWS SageMaker Model Package Group リソース
# 機械学習モデルのバージョン管理を行うための Model Group を定義します。
# Model Registry を使用して、モデルのライフサイクル管理、承認ワークフロー、
# デプロイ履歴の追跡などを実現できます。
#
# 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html
# 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-model-group.html
resource "aws_sagemaker_model_package_group" "example" {
  # ========================================
  # 必須パラメータ
  # ========================================

  # Model Package Group 名
  # モデルグループを識別するための名前を指定します。
  # この名前は同一リージョン内で一意である必要があります。
  # 英数字とハイフン（-）のみ使用可能です。
  #
  # 各問題に対して1つのモデルグループを作成し、トレーニング済みモデルを
  # 新しいバージョンとして登録することを推奨します。
  #
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateModelPackageGroup.html
  model_package_group_name = "example-model-group"

  # ========================================
  # オプションパラメータ
  # ========================================

  # Model Package Group の説明
  # モデルグループの目的や用途を記述します。
  # この説明は Model Registry のコンソールやAPIレスポンスで表示されます。
  # モデルが解決する問題や、使用するユースケースを記載すると良いでしょう。
  model_package_group_description = "Example model group for customer churn prediction models"

  # リージョン
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ
  # リソースに割り当てるタグのマップを指定します。
  # プロバイダーの default_tags 設定ブロックと組み合わせて使用できます。
  # タグを使用して、コスト配分、アクセス制御、リソース管理を行うことができます。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    Team        = "ml-platform"
    Project     = "customer-churn"
    ManagedBy   = "terraform"
  }

  # tags_all
  # デフォルトタグとリソースタグを統合したすべてのタグのマップです。
  # 通常は Terraform によって自動的に管理されるため、明示的な指定は不要です。
  # プロバイダーの default_tags と tags を統合した結果がここに反映されます。
  # tags_all = {}
}

# ====================================================================
# 出力例（参考）
# ====================================================================
# 以下の computed 属性は、リソース作成後に参照可能です。

# output "model_package_group_arn" {
#   description = "ARN of the SageMaker Model Package Group"
#   value       = aws_sagemaker_model_package_group.example.arn
# }
#
# output "model_package_group_id" {
#   description = "ID of the SageMaker Model Package Group (same as name)"
#   value       = aws_sagemaker_model_package_group.example.id
# }

# ====================================================================
# 使用例: モデルバージョンの登録
# ====================================================================
# Model Package Group を作成した後は、トレーニング済みモデルを
# モデルパッケージとして登録できます。
#
# Boto3 での登録例:
# ```python
# import boto3
#
# sagemaker = boto3.client('sagemaker')
#
# response = sagemaker.create_model_package(
#     ModelPackageGroupName='example-model-group',
#     ModelPackageDescription='Version 1.0 - Initial model',
#     InferenceSpecification={
#         'Containers': [{
#             'Image': '123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest',
#             'ModelDataUrl': 's3://my-bucket/model.tar.gz'
#         }],
#         'SupportedContentTypes': ['text/csv'],
#         'SupportedResponseMIMETypes': ['text/csv']
#     },
#     ModelApprovalStatus='PendingManualApproval'
# )
# ```
#
# 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry-models.html

# ====================================================================
# ベストプラクティス
# ====================================================================
# 1. 命名規則の統一
#    - プロジェクトや用途が識別できる命名を使用する
#    - 例: "project-usecase-model-group"
#
# 2. モデルバージョン管理
#    - 各トレーニング実行の結果を新しいバージョンとして登録
#    - バージョンごとにメタデータ（精度、データセット情報など）を関連付ける
#
# 3. 承認ワークフロー
#    - 本番環境へのデプロイ前に承認プロセスを実装
#    - ModelApprovalStatus を活用して承認状態を管理
#
# 4. タグ活用
#    - 環境、プロジェクト、チームなどのタグを付与
#    - コスト配分とリソース管理を容易にする
#
# 5. Model Registry Collections
#    - 関連するモデルグループをコレクションにまとめて整理
#    - 大規模な組織でのモデル管理を効率化
#
# 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html
