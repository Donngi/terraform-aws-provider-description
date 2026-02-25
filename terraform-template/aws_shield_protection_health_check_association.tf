#---------------------------------------------------------------
# AWS Shield Advanced Protection ヘルスチェック関連付け
#---------------------------------------------------------------
#
# Route53ヘルスチェックとShield Advanced保護リソースの関連付けを作成するリソースです。
# ヘルスベースの検知を有効化することで、攻撃検知・緩和の精度と応答性を向上させます。
# アプリケーションの正常性情報をShield Advancedに提供し、
# 誤検知を減らしながらより迅速なDDoS攻撃の緩和を実現します。
#
# AWS公式ドキュメント:
#   - AWS Shield Advancedのヘルスベース検知: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-advanced-health-checks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection_health_check_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_protection_health_check_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # health_check_arn (Required)
  # 設定内容: 保護リソースに関連付けるRoute53ヘルスチェックのARNを指定します。
  # 設定可能な値: 有効なRoute53ヘルスチェックリソースのARN文字列
  # 省略時: 必須項目のため省略不可
  health_check_arn = aws_route53_health_check.example.arn

  # shield_protection_id (Required)
  # 設定内容: ヘルスチェックを関連付けるShield Advanced保護オブジェクトのIDを指定します。
  # 設定可能な値: 既存のaws_shield_protectionリソースのID
  # 省略時: 必須項目のため省略不可
  shield_protection_id = aws_shield_protection.example.id
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 作成されたProtectionオブジェクトの一意識別子（ID）
#---------------------------------------------------------------
