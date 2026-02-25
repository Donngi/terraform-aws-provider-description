#---------------------------------------------------------------
# AWS Shield DRT Access Role ARN Association
#---------------------------------------------------------------
#
# AWS Shield Advanced の Shield Response Team (SRT) に対して、
# 指定したIAMロールを使用してAWSアカウントへのアクセス権限を付与するリソースです。
# SRTはDDoS攻撃の軽減を支援するためにこのロールを使用します。
# ロールには AWSShieldDRTAccessPolicy マネージドポリシーのアタッチと、
# drt.shield.amazonaws.com サービスプリンシパルへの信頼設定が必要です。
#
# AWS公式ドキュメント:
#   - SRTへのアクセス許可: https://docs.aws.amazon.com/waf/latest/developerguide/authorize-srt.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_drt_access_role_arn_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_shield_drt_access_role_arn_association" "example" {
  #-------------------------------------------------------------
  # ロール設定
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: SRTがAWSアカウントへのアクセスに使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールのARN（文字列）
  # 注意: このリクエストを実行する前に、ロールに AWSShieldDRTAccessPolicy
  #       マネージドポリシーをアタッチする必要があります。
  #       また、ロールの信頼ポリシーに drt.shield.amazonaws.com
  #       サービスプリンシパルへの sts:AssumeRole 許可を設定する必要があります。
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/authorize-srt.html
  role_arn = aws_iam_role.example.arn

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

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "5m", "2h45m"）
    #   有効な時間単位: "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    update = "30m"

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
# - id: リソースの識別子（role_arnと同じ値）
#---------------------------------------------------------------
