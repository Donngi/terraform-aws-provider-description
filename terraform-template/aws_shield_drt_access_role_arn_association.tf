################################################################################
# AWS Shield DRT Access Role ARN Association
################################################################################
# リソース概要:
# Shield Response Team (SRT) がDDoS攻撃の緩和を支援するために、
# 指定されたロールを使用してAWSアカウントにアクセスすることを承認します。
#
# ユースケース:
# - AWS ShieldのDDoS攻撃対応時にSRTチームのアクセスを許可
# - Advanced Shield保護プランでのインシデント対応体制の構築
#
# 参考ドキュメント:
# https://docs.aws.amazon.com/waf/latest/developerguide/authorize-srt.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_drt_access_role_arn_association
################################################################################

resource "aws_shield_drt_access_role_arn_association" "example" {
  #============================================================================
  # 必須パラメータ
  #============================================================================

  # role_arn - (必須) SRTがAWSアカウントにアクセスするために使用するロールのARN
  # 型: string
  # 制約:
  # - このロールには事前に AWSShieldDRTAccessPolicy マネージドポリシーを
  #   アタッチする必要があります
  # - ロールの信頼ポリシーで drt.shield.amazonaws.com サービスプリンシパルを
  #   許可する必要があります
  # 例: "arn:aws:iam::123456789012:role/SRTAccessRole"
  role_arn = aws_iam_role.example.arn

  #============================================================================
  # タイムアウト設定 (オプション)
  #============================================================================

  # timeouts {
  #   # create - リソース作成時のタイムアウト
  #   # 型: string (例: "30s", "5m", "1h")
  #   # デフォルト: 適用なし
  #   create = "5m"
  #
  #   # update - リソース更新時のタイムアウト
  #   # 型: string (例: "30s", "5m", "1h")
  #   # デフォルト: 適用なし
  #   update = "5m"
  #
  #   # delete - リソース削除時のタイムアウト
  #   # 型: string (例: "30s", "5m", "1h")
  #   # デフォルト: 適用なし
  #   delete = "5m"
  # }
}

################################################################################
# 関連リソース例 - IAM Role
################################################################################
# SRTアクセス用のIAMロール設定例

resource "aws_iam_role" "example" {
  name = "shield-srt-access-role"

  # SRTサービスがこのロールを引き受けることを許可
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowShieldSRTAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "drt.shield.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSShieldDRTAccessPolicy"
}

################################################################################
# 出力値例
################################################################################

output "shield_drt_association_id" {
  description = "Shield DRT Access Role ARN AssociationのID"
  value       = aws_shield_drt_access_role_arn_association.example.id
}

output "shield_drt_role_arn" {
  description = "SRTアクセスに使用されるIAMロールのARN"
  value       = aws_shield_drt_access_role_arn_association.example.role_arn
}

################################################################################
# 属性リファレンス
################################################################################
# このリソースでは以下の属性が利用可能です:
#
# - id (string, computed)
#   リソースの一意識別子
#
# - role_arn (string)
#   設定されたIAMロールのARN
################################################################################

################################################################################
# 重要な注意事項
################################################################################
# 1. AWS Shield Advanced サブスクリプション
#    - このリソースを使用するには、AWS Shield Advancedのサブスクリプションが
#      必要です
#
# 2. IAMロールの必須設定
#    - role_arnで指定するロールには必ず AWSShieldDRTAccessPolicy を
#      アタッチしてください
#    - 信頼ポリシーで drt.shield.amazonaws.com を許可してください
#
# 3. SRTアクセスの範囲
#    - このロールによりSRTは以下の操作が可能になります:
#      - WAF設定の確認と変更
#      - Shield保護の確認
#      - CloudWatchメトリクスの参照
#
# 4. セキュリティ考慮事項
#    - SRTアクセスは必要な期間のみ有効化することを推奨
#    - CloudTrailでSRTの操作ログを監視することを推奨
#
# 5. 他のShieldリソースとの連携
#    - aws_shield_drt_access_log_bucket_association と併用して
#      ログバケットへのアクセスも許可できます
#    - aws_shield_protection_group でリソースグループの保護を構成できます
################################################################################
