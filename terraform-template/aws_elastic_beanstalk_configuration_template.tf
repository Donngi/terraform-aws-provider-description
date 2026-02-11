# =============================================================================
# AWS Elastic Beanstalk Configuration Template
# =============================================================================
# Generated: 2026-01-18
# Provider Version: 6.28.0
# Resource: aws_elastic_beanstalk_configuration_template
#
# このファイルは自動生成されたテンプレートです。
# 実際の使用時は、環境に応じて不要な項目を削除し、必要な値を設定してください。
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/elastic_beanstalk_configuration_template
# =============================================================================

resource "aws_elastic_beanstalk_configuration_template" "example" {
  # =========================================================================
  # 必須パラメータ (Required)
  # =========================================================================

  # application - (必須) 設定テンプレートが関連付けられるElastic Beanstalkアプリケーションの名前
  # Type: string
  application = "my-application"

  # name - (必須) 設定テンプレートの名前
  # Type: string
  name = "my-configuration-template"

  # =========================================================================
  # オプションパラメータ (Optional)
  # =========================================================================

  # description - (任意) 設定テンプレートの説明
  # Type: string
  description = "Configuration template for production environment"

  # environment_id - (任意) テンプレートのベースとなる既存環境のID
  # 既存環境の設定をコピーして新しい設定テンプレートを作成する場合に使用
  # solution_stack_nameと排他的（どちらか一方のみ指定可能）
  # Type: string
  # environment_id = "e-xxxxxxxxxx"

  # solution_stack_name - (任意) 使用するソリューションスタックの名前
  # 例: "64bit Amazon Linux 2023 v4.0.0 running Python 3.11"
  # environment_idと排他的（どちらか一方のみ指定可能）
  # Type: string
  solution_stack_name = "64bit Amazon Linux 2023 v4.0.0 running Python 3.11"

  # =========================================================================
  # ネストブロック (Nested Blocks)
  # =========================================================================

  # setting - (任意) 環境設定オプション
  # Elastic Beanstalk環境の各種設定を定義します
  # 複数のsettingブロックを定義可能（set形式）
  #
  # 設定可能なオプションの詳細は以下を参照:
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html
  #
  # 主な設定カテゴリ（namespace）:
  # - aws:autoscaling:asg: Auto Scalingグループの設定
  # - aws:autoscaling:launchconfiguration: 起動設定
  # - aws:ec2:instances: インスタンスタイプ設定
  # - aws:ec2:vpc: VPC設定
  # - aws:elasticbeanstalk:environment: 環境設定
  # - aws:elasticbeanstalk:application:environment: 環境変数
  # - aws:elasticbeanstalk:healthreporting:system: ヘルスレポート設定
  # - aws:elbv2:loadbalancer: Application Load Balancer設定
  # など

  # Auto Scalingグループの最小インスタンス数
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  # Auto Scalingグループの最大インスタンス数
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  # インスタンスタイプの設定
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.small,t3.medium"
  }

  # VPC IDの設定
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "vpc-xxxxx"
  }

  # サブネットの設定
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "subnet-xxxxx,subnet-yyyyy"
  }

  # ELBサブネットの設定
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "subnet-xxxxx,subnet-yyyyy"
  }

  # 環境タイプの設定（LoadBalanced or SingleInstance）
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  # ロードバランサータイプの設定
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  # 環境変数の設定例
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ENV_NAME"
    value     = "production"
  }

  # ヘルスレポートシステムの設定
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  # IAMインスタンスプロファイルの設定
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  # セキュリティグループの設定
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "sg-xxxxx"
  }

  # キーペアの設定
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "my-keypair"
  }
}

# =============================================================================
# 出力値 (Outputs)
# =============================================================================

# 設定テンプレート名を出力
output "configuration_template_name" {
  description = "The name of the configuration template"
  value       = aws_elastic_beanstalk_configuration_template.example.name
}
