#---------------------------------------------------------------
# AWS Device Farm Test Grid Project
#---------------------------------------------------------------
#
# AWS Device Farmのデスクトップブラウザテスト用プロジェクトを管理するリソースです。
# Seleniumを使用したWebアプリケーションのブラウザテストを実行するための
# Test Gridプロジェクトを作成します。
#
# 注意: AWS Device Farmは現在、限られたリージョンでのみサポートされています
#       （例: us-west-2）。サポートされているリージョンについては
#       AWS Device Farmエンドポイントとクォータを参照してください。
#
# AWS公式ドキュメント:
#   - Device Farm デスクトップブラウザテスト概要: https://docs.aws.amazon.com/devicefarm/latest/testgrid/getting-started.html
#   - Device Farm エンドポイントとクォータ: https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_test_grid_project
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_devicefarm_test_grid_project" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Seleniumテストプロジェクトの名前を指定します。
  # 設定可能な値: 文字列
  name = "my-test-grid-project"

  # description (Optional)
  # 設定内容: プロジェクトの説明を人間が読める形式で指定します。
  # 設定可能な値: 文字列
  description = "My Selenium test grid project for desktop browser testing"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Device Farmは限られたリージョンでのみサポートされています
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_config (Required)
  # 設定内容: プロジェクトにアタッチするVPCセキュリティグループとサブネットを指定します。
  # 関連機能: Test Gridプロジェクトが内部リソースにアクセスするためのVPC設定
  vpc_config {
    # vpc_id (Required)
    # 設定内容: Amazon VPCのIDを指定します。
    # 設定可能な値: VPC ID（例: vpc-12345678）
    vpc_id = "vpc-12345678"

    # subnet_ids (Required)
    # 設定内容: Amazon VPCのサブネットIDリストを指定します。
    # 設定可能な値: サブネットIDのセット
    # 注意: テストの実行に使用されるサブネットを指定します
    subnet_ids = [
      "subnet-12345678",
      "subnet-87654321",
    ]

    # security_group_ids (Required)
    # 設定内容: Amazon VPCのセキュリティグループIDリストを指定します。
    # 設定可能な値: セキュリティグループIDのセット
    # 注意: テスト実行時のネットワークアクセスを制御します
    security_group_ids = [
      "sg-12345678",
    ]
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーのdefault_tags設定ブロックが存在する場合、
  #       一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-test-grid-project"
    Environment = "development"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #           リソースに割り当てられたすべてのタグのマップです。
  # 注意: この属性は通常明示的に設定せず、tagsとdefault_tagsから自動計算されます。
  # tags_all = {}
}
