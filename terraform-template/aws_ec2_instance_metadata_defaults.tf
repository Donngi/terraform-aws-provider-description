#---------------------------------------
# aws_ec2_instance_metadata_defaults
#---------------------------------------
# 説明: EC2インスタンスメタデータサービス（IMDS）のリージョン全体でのデフォルト設定を管理
# - リージョン内の新規EC2インスタンスに適用されるIMDS設定のデフォルト値を定義
# - 既存インスタンスには影響せず、設定後に起動される新規インスタンスにのみ適用
# - セキュリティ強化のため、IMDSv2の強制やメタデータサービスの無効化が可能
# 依存関係:
# - 対象AWSリージョンへのアクセス権限が必要
# 公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_instance_metadata_defaults
# Provider Version: 6.28.0
# Generated: 2026-02-14
# NOTE: リージョン単位の設定のため、1リージョンにつき1つのリソースのみ作成可能

#---------------------------------------
# 基本設定
#---------------------------------------

resource "aws_ec2_instance_metadata_defaults" "example" {
  # http_endpoint: メタデータサービスHTTPエンドポイントの有効/無効
  # 設定内容: 新規インスタンスでのIMDSエンドポイントのデフォルト状態
  # 設定可能な値:
  #   - enabled  : メタデータサービスを有効化（デフォルト）
  #   - disabled : メタデータサービスを無効化（全メタデータへのアクセスを遮断）
  # 省略時: enabled（AWSデフォルト）
  http_endpoint = "enabled"

  # http_tokens: IMDSv2トークンの要求レベル
  # 設定内容: メタデータ取得時のセッショントークン認証要否
  # 設定可能な値:
  #   - optional : IMDSv1とIMDSv2の両方を許可（デフォルト）
  #   - required : IMDSv2のみを許可（セキュリティ強化推奨設定）
  # 省略時: optional（AWSデフォルト）
  # ベストプラクティス: セキュリティ強化のため"required"を推奨
  http_tokens = "required"

  # http_put_response_hop_limit: メタデータトークンのネットワークホップ数上限
  # 設定内容: IMDSv2トークンがネットワーク経由で転送可能なホップ数
  # 設定可能な値: 1～64の整数
  # 省略時: 1（AWSデフォルト）
  # 用途:
  #   - 1  : インスタンス内からの直接アクセスのみ許可（最もセキュア）
  #   - 2+ : コンテナやNAT経由でのアクセスを許可（ECS/EKS等で必要）
  http_put_response_hop_limit = 1

  # instance_metadata_tags: インスタンスタグへのメタデータ経由アクセス
  # 設定内容: IMDSを通じたEC2インスタンスタグへのアクセス可否
  # 設定可能な値:
  #   - enabled  : タグへのメタデータアクセスを許可
  #   - disabled : タグへのメタデータアクセスを拒否（デフォルト）
  # 省略時: disabled（AWSデフォルト）
  instance_metadata_tags = "disabled"

  # region: リソースが管理されるAWSリージョン
  # 設定内容: このデフォルト設定を適用するリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: 明示的に指定することで、マルチリージョン環境での設定ミスを防止可能
  region = "us-east-1"
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースから参照可能な属性:
#
# - id
#   リソースの一意識別子（リージョン名と同値）
#
# - http_endpoint
#   設定されたHTTPエンドポイントの状態
#
# - http_tokens
#   設定されたトークン要求レベル
#
# - http_put_response_hop_limit
#   設定されたホップ数上限
#
# - instance_metadata_tags
#   設定されたタグアクセス可否
#
# - region
#   設定が適用されるリージョン名
