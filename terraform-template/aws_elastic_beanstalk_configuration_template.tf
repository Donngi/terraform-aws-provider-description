#-----------------------------------------------
# Terraform AWS Resource Template
#-----------------------------------------------
# Resource: aws_elastic_beanstalk_configuration_template
# Provider Version: 6.28.0
# Generated: 2026-02-17
#
# NOTE:
#   このテンプレートはElastic Beanstalk設定テンプレートのリファレンスです
#   実際の使用時は、環境に応じて適切な値に置き換えてください
#
# 概要:
#   Elastic Beanstalk設定テンプレートを定義するリソース
#   特定のアプリケーションに関連付けられ、同じ設定で異なるバージョンの
#   アプリケーションをデプロイするために使用されます
#   テンプレートは環境に関連付けられず、再利用可能な設定として機能します
#
# 用途:
#   - アプリケーション設定の標準化とテンプレート化
#   - 複数環境での一貫した設定の適用
#   - 環境設定のベースライン定義
#   - プラットフォーム固有のオプション設定の管理
#
# 公式ドキュメント:
#   https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environment-configuration-methods-before.html
#
# Terraform Registry:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_configuration_template
#-----------------------------------------------

resource "aws_elastic_beanstalk_configuration_template" "example" {
  #-----------------------------------------------
  # 基本設定
  #-----------------------------------------------
  # 設定内容: テンプレート名
  # 設定可能な値: 1〜100文字の英数字、ハイフン、アンダースコア
  # 制約: アプリケーション内で一意である必要があります
  name = "my-configuration-template"

  # 設定内容: 関連付けるElastic Beanstalkアプリケーション名
  # 制約: 既存のElastic Beanstalkアプリケーション名を指定
  application = "my-application"

  # 設定内容: テンプレートの説明
  # 設定可能な値: 0〜200文字の任意のテキスト
  # 省略時: 説明なし
  description = "Configuration template for production environments"

  #-----------------------------------------------
  # テンプレートソース設定
  #-----------------------------------------------
  # 設定内容: ソリューションスタック名
  # 設定可能な値: プラットフォーム名とバージョン（例: "64bit Amazon Linux 2 v3.4.0 running Python 3.8"）
  # 用途: テンプレートのベースとなるプラットフォームを指定
  # 制約: solution_stack_nameとenvironment_idは同時に指定できません
  # 省略時: environment_idで指定した環境の設定を使用
  solution_stack_name = "64bit Amazon Linux 2 v5.8.0 running Node.js 18"

  # 設定内容: ソースとなる環境ID
  # 用途: 既存環境の設定をコピーしてテンプレートを作成
  # 制約: solution_stack_nameとenvironment_idは同時に指定できません
  # 省略時: solution_stack_nameで指定したプラットフォームを使用
  environment_id = "e-abcd1234"

  #-----------------------------------------------
  # リージョン設定
  #-----------------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "ap-northeast-1"

  #-----------------------------------------------
  # オプション設定
  #-----------------------------------------------
  # 設定内容: Elastic Beanstalk設定オプション
  # 用途: プラットフォーム固有の設定やカスタム設定を定義
  # 制約: 各settingブロックでnamespace、name、valueは必須

  # インスタンスタイプの設定例
  setting {
    # 設定内容: 設定オプションの名前空間
    # 設定可能な値: aws:elasticbeanstalk:*, aws:ec2:*, aws:autoscaling:* など
    namespace = "aws:autoscaling:launchconfiguration"

    # 設定内容: 設定オプション名
    name = "InstanceType"

    # 設定内容: 設定値
    value = "t3.micro"
  }

  # ヘルスチェック設定例
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/health"
  }

  # 環境変数の設定例
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "postgres://localhost:5432/mydb"
  }

  # ロードバランサー設定例
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  # Auto Scaling最小インスタンス数の設定例
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  # Auto Scaling最大インスタンス数の設定例
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  # VPCサブネット設定例（リソース指定あり）
  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "Subnets"
  #   value     = "subnet-12345678"
  #   # 設定内容: 設定が適用される特定リソース名
  #   # 用途: 複数リソースがある場合に特定のリソースにのみ設定を適用
  #   # 省略時: すべての該当リソースに適用
  #   resource = ""
  # }

  # プラットフォーム固有設定例（Node.jsの場合）
  # setting {
  #   namespace = "aws:elasticbeanstalk:container:nodejs"
  #   name      = "NodeVersion"
  #   value     = "18.x"
  # }

  # カスタムオプション設定例
  # setting {
  #   namespace = "aws:elasticbeanstalk:customoption"
  #   name      = "MyCustomSetting"
  #   value     = "custom-value"
  # }
}

#-----------------------------------------------
# Attributes Reference
#-----------------------------------------------
# このリソースは以下の属性をエクスポートします
#
# id
#   設定テンプレートの一意識別子（テンプレート名）
#
# region
#   テンプレートが管理されるAWSリージョン
#
# application
#   関連付けられたアプリケーション名
#
# name
#   設定テンプレート名
#
# description
#   テンプレートの説明
#
# environment_id
#   ソース環境ID
#
# solution_stack_name
#   ソリューションスタック名
#
# setting
#   設定オプションのセット
