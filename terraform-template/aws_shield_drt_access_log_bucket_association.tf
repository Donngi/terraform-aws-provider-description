#---------------------------------------------------------------
# AWS Shield DRT Access Log Bucket Association
#---------------------------------------------------------------
#
# AWS Shield Advanced の Shield Response Team (SRT) に対して、
# Amazon S3バケットへのアクセス権限を関連付けるリソースです。
# SRTがDDoS攻撃の調査・対応時にログデータ（Application Load Balancer
# アクセスログ、CloudFrontログ、サードパーティログ等）を確認できるよう、
# 最大10個のS3バケットを共有できます。
#
# AWS公式ドキュメント:
#   - SRTへのアクセス許可: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-srt-access.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_drt_access_log_bucket_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_drt_access_log_bucket_association" "example" {
  #-------------------------------------------------------------
  # バケット設定
  #-------------------------------------------------------------

  # log_bucket (Required)
  # 設定内容: SRTと共有するログが格納されているAmazon S3バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名（文字列）
  # 注意: バケットはSRTアクセスロールと同じAWSアカウントに存在する必要があります。
  #       バケットはプレーンテキストまたはSSE-S3暗号化が可能ですが、
  #       AWS KMSで暗号化されたバケットのログはSRTが閲覧・処理できません。
  #       最大10個のバケットをDRTアクセス共有に関連付けできます。
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-srt-access.html
  log_bucket = "my-shield-drt-access-logs-bucket"

  #-------------------------------------------------------------
  # ロールARN関連付け設定
  #-------------------------------------------------------------

  # role_arn_association_id (Required)
  # 設定内容: Shield DRTアクセスを許可するために使用するロールARN関連付けのIDを指定します。
  # 設定可能な値: aws_shield_drt_access_role_arn_associationリソースのID（文字列）
  # 注意: aws_shield_drt_access_role_arn_associationリソースを先に作成し、
  #       そのIDを参照する必要があります。ロールにはAWSShieldDRTAccessPolicy
  #       マネージドポリシーがアタッチされ、サービスプリンシパル
  #       drt.shield.amazonaws.com を信頼する設定が必要です。
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/ddos-srt-access.html
  role_arn_association_id = aws_shield_drt_access_role_arn_association.example.id

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    #   有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    #   有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    # 注意: 削除操作のタイムアウト設定は、destroy操作の前に変更がstateに
    #       保存される場合にのみ適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#---------------------------------------------------------------
