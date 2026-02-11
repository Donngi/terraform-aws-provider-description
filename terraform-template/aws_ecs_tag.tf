#---------------------------------------------------------------
# AWS ECS Tag
#---------------------------------------------------------------
#
# Amazon ECS（Elastic Container Service）のリソースに対してタグを管理する
# リソースです。ECSクラスター、サービス、タスク定義などのリソースに対して
# キーと値のペアでタグを追加できます。
#
# AWS公式ドキュメント:
#   - ECS概要: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html
#   - リソースのタグ付け: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_tag
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ecs_tag" "example" {
  #-------------------------------------------------------------
  # リソース指定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: タグを追加するECSリソースのARNを指定します。
  # 設定可能な値: 有効なECSリソースのARN（クラスター、サービス、タスク定義など）
  # 関連機能: Amazon Resource Names (ARN)
  #   AWSリソースを一意に識別するための識別子です。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
  resource_arn = "arn:aws:ecs:ap-northeast-1:123456789012:cluster/my-cluster"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # key (Required)
  # 設定内容: タグのキーを指定します。
  # 設定可能な値: 1-128文字のUnicode文字列
  # 注意: タグキーには大文字小文字の区別があります
  # 関連機能: AWSリソースタグ付け
  #   リソースの分類、検索、管理を容易にするためのメタデータです。
  #   - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html
  key = "Environment"

  # value (Required)
  # 設定内容: タグの値を指定します。
  # 設定可能な値: 0-256文字のUnicode文字列
  # 注意: タグ値には大文字小文字の区別があります
  value = "production"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの識別子を指定します。
  # 省略時: Terraformが自動的に生成します
  # 注意: 通常はこの属性を明示的に設定する必要はありません
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: タグリソースの識別子
#---------------------------------------------------------------
