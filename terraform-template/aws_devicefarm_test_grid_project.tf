# AWS Device Farm Test Grid Project
# AWS Device FarmでSeleniumテストを実行するためのテストグリッドプロジェクトを作成・管理するリソース
#
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_test_grid_project
#
# 主な機能:
# - Webアプリケーションのクロスブラウザテストをクラウドで実行
# - 複数のブラウザバージョンとOSの組み合わせで並列テスト
# - VPC内でのテスト実行によるプライベートリソースへのアクセス
#
# 制限事項:
# - Test Grid Projectは米国西部（オレゴン）リージョン（us-west-2）でのみ利用可能
# - VPC設定を使用する場合、サブネットとセキュリティグループは同じVPC内に存在する必要がある
# - プロジェクト作成後、Selenium WebDriverのエンドポイントURLを取得して使用する
#
# NOTE:
# - VPC設定はオプションですが、プライベートネットワーク内のアプリケーションをテストする場合に必要
# - リージョンは明示的にus-west-2を指定することを推奨（他のリージョンでは利用不可）
# - Test Grid Projectの削除には実行中のセッションがないことを確認する必要あり
#
# 参考: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateTestGridProject.html

#-----------------------------------------------------------------------
# 基本設定
#-----------------------------------------------------------------------

resource "aws_devicefarm_test_grid_project" "example" {
  # プロジェクト名
  # 設定内容: Test Grid Projectの識別名
  # 制約: 1〜256文字の範囲で設定
  name = "my-test-grid-project"

  # プロジェクトの説明
  # 設定内容: プロジェクトの目的や用途を記述
  # 制約: 0〜2048文字の範囲で設定
  # 省略時: 説明なし
  description = "Cross-browser testing project for web application"

  # リージョン
  # 設定内容: リソースが作成されるAWSリージョン
  # 設定可能な値: us-west-2（Test Grid Projectは米国西部（オレゴン）リージョンのみサポート）
  # 省略時: プロバイダーのデフォルトリージョン（ただし、us-west-2以外ではエラーになる可能性がある）
  region = "us-west-2"

  #-----------------------------------------------------------------------
  # VPC設定
  #-----------------------------------------------------------------------

  # VPCネットワーク設定
  # 設定内容: プライベートVPC内でテストを実行するための設定
  # 用途: プライベートサブネット内のリソースへのアクセスが必要な場合に使用
  # 省略時: VPC外で通常のインターネットアクセスでテストを実行
  vpc_config {
    # VPC ID
    # 設定内容: テストを実行するVPCのID
    # 制約: 既存のVPC IDを指定
    vpc_id = "vpc-12345678"

    # サブネットID
    # 設定内容: テストで使用するサブネットのIDリスト
    # 制約: 指定したVPC内のサブネットIDを設定、複数指定可能
    # 推奨: 可用性確保のため複数AZのサブネットを指定
    subnet_ids = [
      "subnet-11111111",
      "subnet-22222222",
    ]

    # セキュリティグループID
    # 設定内容: テスト実行時に適用するセキュリティグループのIDリスト
    # 制約: 指定したVPC内のセキュリティグループIDを設定、複数指定可能
    # 推奨: テスト対象へのアクセスとインターネットへの送信を許可する設定
    security_group_ids = [
      "sg-11111111",
      "sg-22222222",
    ]
  }

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # タグ
  # 設定内容: リソースに付与するメタデータのキーバリューペア
  # 用途: リソースの分類、コスト配分、アクセス制御などに使用
  tags = {
    Name        = "my-test-grid-project"
    Environment = "production"
    Application = "web-app"
    ManagedBy   = "terraform"
  }
}

#-----------------------------------------------------------------------
# Attributes Reference
#-----------------------------------------------------------------------

# 以下の属性がエクスポートされ、他のリソースから参照可能:
#
# - id
#   Test Grid ProjectのARN（Amazon Resource Name）
#
# - arn
#   Test Grid Projectの完全なARN
#   形式: arn:aws:devicefarm:us-west-2:123456789012:testgrid-project:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#
# - tags_all
#   プロバイダーレベルのデフォルトタグとリソースのタグを統合したマップ
