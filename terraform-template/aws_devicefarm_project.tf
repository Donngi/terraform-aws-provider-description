#---------------------------------------------------------------
# AWS Device Farm Project
#---------------------------------------------------------------
#
# AWS Device FarmのProjectをプロビジョニングするリソースです。
# Device Farm Projectは、単一のアプリケーションを複数のデバイスでテストするための
# 論理的なワークスペースであり、テストランの実行単位となります。
#
# AWS公式ドキュメント:
#   - Device Farm Projects概要: https://docs.aws.amazon.com/devicefarm/latest/developerguide/projects.html
#   - プロジェクトの作成: https://docs.aws.amazon.com/devicefarm/latest/developerguide/how-to-create-project.html
#   - Device Farm概念: https://docs.aws.amazon.com/devicefarm/latest/developerguide/concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_project
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要な制約事項:
#   - AWS Device Farmは限られたリージョンでのみサポートされています。
#   - 現在、us-west-2（米国西部オレゴン）などでの利用が可能です。
#   - 詳細: https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
#
#---------------------------------------------------------------

resource "aws_devicefarm_project" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロジェクトの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: プロジェクト名は、アプリのタイトル、プラットフォーム、テストの種類など、
  #       任意の基準で命名できます。
  # 参考: https://docs.aws.amazon.com/devicefarm/latest/developerguide/how-to-create-project.html
  name = "my-device-farm-project"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # default_job_timeout_minutes (Optional)
  # 設定内容: プロジェクトの実行タイムアウト値を分単位で設定します。
  # 設定可能な値: 正の整数（分単位）
  # 動作: このプロジェクト内の全てのテストランは、ランのスケジュール時に
  #       オーバーライドされない限り、指定された実行タイムアウト値を使用します。
  # 省略時: AWS Device Farmのデフォルト値が適用されます
  # 参考: https://docs.aws.amazon.com/devicefarm/latest/developerguide/how-to-create-project.html
  default_job_timeout_minutes = 60

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 重要: AWS Device Farmは特定のリージョンでのみ利用可能です。
  #       現在、us-west-2（米国西部オレゴン）などでサポートされています。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
  #       https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

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
    Name        = "my-device-farm-project"
    Environment = "production"
    Purpose     = "mobile-app-testing"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: プロジェクトのAmazon Resource Name (ARN)
#
# - id: プロジェクトの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
