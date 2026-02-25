#---------------------------------------------------------------
# Amazon QuickSight IP制限設定
#---------------------------------------------------------------
#
# Amazon QuickSightアカウントのIPアドレス制限ルールを管理するリソースです。
# IPルール、VPC IDルール、VPCエンドポイントIDルールを組み合わせて、
# QuickSightへのアクセスを特定のIPアドレス帯域やVPCからのみに制限します。
#
# 注意: このリソースを削除すると、QuickSightアカウントのすべてのIP制限が
#       クリアされます。
#
# AWS公式ドキュメント:
#   - IP/VPC制限の管理: https://docs.aws.amazon.com/quicksight/latest/user/managing-ip-vpc-restrictions.html
#   - UpdateIpRestriction API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_UpdateIpRestriction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_ip_restriction
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_ip_restriction" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: IP制限ルールを管理するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーの設定から自動的に判定されたアカウントIDを使用
  # 注意: 変更時はリソースが再作成されます。
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # IP制限有効化設定
  #-------------------------------------------------------------

  # enabled (Required)
  # 設定内容: IPルールを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: IPルールを有効化。ルールに一致しないトラフィックはブロックされます。
  #   - false: IPルールを無効化。すべてのトラフィックが許可されます。
  # 注意: ルールを有効にする前に、自分自身のトラフィックを許可するルールが
  #       必要です。設定後、ルールが完全に有効になるまで最大10分かかる場合があります。
  enabled = true

  #-------------------------------------------------------------
  # IPアドレス制限設定
  #-------------------------------------------------------------

  # ip_restriction_rule_map (Optional)
  # 設定内容: 許可するIPv4 CIDRレンジと説明のマップを指定します。
  # 設定可能な値: キーがIPv4 CIDR表記（例: "203.0.113.0/24"）、
  #              値がルールの説明文字列となるマップ
  # 省略時: IPアドレスベースの制限ルールなし
  # 注意: IPルール、VPC IDルール、VPCエンドポイントIDルールのいずれかに
  #       一致するトラフィックは許可されます（OR条件）。
  ip_restriction_rule_map = {
    "203.0.113.0/24" = "オフィスネットワーク"
    "198.51.100.1/32" = "特定のIPアドレス"
  }

  #-------------------------------------------------------------
  # VPC制限設定
  #-------------------------------------------------------------

  # vpc_id_restriction_rule_map (Optional)
  # 設定内容: 許可するVPC IDと説明のマップを指定します。
  # 設定可能な値: キーがVPC ID（例: "vpc-12345678"）、
  #              値がルールの説明文字列となるマップ
  # 省略時: VPC IDベースの制限ルールなし
  # 注意: 指定したVPC内のすべてのVPCエンドポイントからのトラフィックが許可されます。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/user/vpc-interface-endpoints.html
  vpc_id_restriction_rule_map = {
    "vpc-12345678" = "メインVPC"
  }

  # vpc_endpoint_id_restriction_rule_map (Optional)
  # 設定内容: 許可するVPCエンドポイントIDと説明のマップを指定します。
  # 設定可能な値: キーがVPCエンドポイントID（例: "vpce-12345678"）、
  #              値がルールの説明文字列となるマップ
  # 省略時: VPCエンドポイントIDベースの制限ルールなし
  # 注意: vpc_id_restriction_rule_mapより細かい粒度でVPCエンドポイント単位での制御が可能です。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/user/vpc-interface-endpoints.html
  vpc_endpoint_id_restriction_rule_map = {
    "vpce-12345678" = "特定のVPCエンドポイント"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは追加のエクスポート属性を持ちません。
# スキーマの全属性は入力設定として上記テンプレートに記載されています。
#---------------------------------------------------------------
