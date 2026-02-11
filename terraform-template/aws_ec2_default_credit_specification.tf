#---------------------------------------------------------------
# EC2 Default Credit Specification
#---------------------------------------------------------------
#
# EC2インスタンスファミリーのデフォルトCPUクレジット設定を管理する
# リソース。バーストパフォーマンスインスタンス（T2/T3/T3a/T4g）の
# デフォルトCPUクレジットモードを「standard」または「unlimited」に設定。
#
# AWS公式ドキュメント:
#   - Burstable performance instances: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances.html
#   - CPU credits and baseline performance: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-credits-baseline-concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_default_credit_specification
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_default_credit_specification" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # cpu_credits (Required)
  # 設定内容: CPUクレジットモードを指定します。
  # 設定可能な値:
  #   - "standard": ベースラインパフォーマンスを超えた場合、蓄積したCPUクレジットを消費
  #   - "unlimited": 追加料金で無制限にCPUバーストが可能
  # 関連機能: CPU クレジットオプション
  #   T2/T3/T3a/T4gインスタンスは、ベースラインレベルのCPUパフォーマンスを提供し、
  #   必要に応じてバースト可能。standardモードでは蓄積したクレジットを消費し、
  #   unlimitedモードでは追加料金でバースト可能。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances-standard-mode.html
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances-unlimited-mode.html
  cpu_credits = "standard"

  # instance_family (Required)
  # 設定内容: EC2インスタンスファミリーを指定します。
  # 設定可能な値:
  #   - "t2": T2インスタンスファミリー
  #   - "t3": T3インスタンスファミリー
  #   - "t3a": T3aインスタンスファミリー（AMD EPYC プロセッサ）
  #   - "t4g": T4gインスタンスファミリー（AWS Graviton2 プロセッサ）
  # 注意: バーストパフォーマンスインスタンスファミリーのみ対象
  instance_family = "t3"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: この設定を適用するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "2h45m"）
    # 省略時: デフォルトのタイムアウト値を使用
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースには明示的な読み取り専用属性（computed onlyの属性）は
# 定義されていません。
#---------------------------------------------------------------
