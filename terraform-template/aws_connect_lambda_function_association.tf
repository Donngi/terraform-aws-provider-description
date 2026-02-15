################################################################################
# AWS Connect Lambda Function Association
################################################################################
# Amazon ConnectインスタンスとLambda関数の関連付けを管理するリソース
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/connect_lambda_function_association
# Generated: 2026-02-13
#
# 主な用途:
# - Contact Flowで使用するLambda関数の登録
# - Amazon Connectインスタンスに対するLambda関数の実行権限付与
# - カスタムビジネスロジックの統合
#
# 制限事項:
# - Lambda関数はConnectインスタンスと同じリージョンに存在する必要がある
# - Lambda関数には適切なリソースベースポリシーが必要
# - 1つのインスタンスあたり最大50個のLambda関数を関連付け可能
#
# 関連リソース:
# - aws_connect_instance: Amazon Connectインスタンス
# - aws_lambda_function: 関連付けるLambda関数
# - aws_lambda_permission: Lambda関数の実行許可ポリシー
#
# NOTE: このテンプレートは基本的な設定例です。実際の使用時は環境に応じて調整してください。

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_connect_lambda_function_association" "example" {
  # 設定内容: Amazon ConnectインスタンスのID
  # 形式: 36文字の英数字とハイフン（例: 12345678-1234-1234-1234-123456789012）
  # 備考: aws_connect_instanceリソースのidを参照
  instance_id = "12345678-1234-1234-1234-123456789012"

  # 設定内容: 関連付けるLambda関数のARN
  # 形式: arn:aws:lambda:region:account-id:function:function-name[:version|alias]
  # 備考:
  # - バージョンやエイリアスの指定も可能
  # - 関数には適切なリソースベースポリシーが必要
  # - $LATESTバージョンの場合はバージョン番号の指定不要
  function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-contact-flow-function"

  #-----------------------------------------------------------------------
  # リージョン設定
  #-----------------------------------------------------------------------

  # 設定内容: リソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 備考:
  # - 通常はプロバイダー設定に従うため省略
  # - マルチリージョン構成の場合に明示的に指定
  region = "us-east-1"
}

################################################################################
# Attributes Reference（参照専用属性）
################################################################################
# このリソースでは以下の属性が参照可能:
#
# - id
#   リソースの一意識別子
#   形式: instance_id,function_arn
#   用途: リソースのインポートや参照
#
# - region
#   リソースが管理されているリージョン
#   形式: リージョンコード（例: us-east-1）
#   用途: リージョン情報の確認

################################################################################
# Import（既存リソースのインポート）
################################################################################
# 既存のLambda関数関連付けは以下の形式でインポート可能:
#
# terraform import aws_connect_lambda_function_association.example instance_id,function_arn
#
# 例:
# terraform import aws_connect_lambda_function_association.example \
#   12345678-1234-1234-1234-123456789012,arn:aws:lambda:us-east-1:123456789012:function:my-function
