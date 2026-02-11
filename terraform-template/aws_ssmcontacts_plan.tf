#---------------------------------------------------------------
# AWS Systems Manager Incident Manager Contact Plan
#---------------------------------------------------------------
#
# AWS Systems Manager Incident Manager の連絡先計画（エスカレーションプラン）を
# プロビジョニングするリソースです。
# 連絡先計画は、インシデント発生時に複数のステージからなるエスカレーション手順を
# 定義し、指定された順序で連絡先または連絡チャネルに通知を送信します。
# 各ステージには期間と複数のターゲット（連絡先またはチャネル）を含めることができ、
# 前のステージで応答がない場合に次のステージへ進むエスカレーションロジックを実現します。
#
# AWS公式ドキュメント:
#   - エスカレーションプランの作成: https://docs.aws.amazon.com/incident-manager/latest/userguide/escalation.html
#   - Incident Manager概要: https://aws.amazon.com/systems-manager/features/incident-manager/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmcontacts_plan
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssmcontacts_plan" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # contact_id (Required)
  # 設定内容: この計画を適用する連絡先のARNを指定します。
  # 設定可能な値: 有効な連絡先のAmazon Resource Name (ARN)
  # 関連機能: AWS Systems Manager Incident Manager 連絡先
  #   連絡先は個人（PERSONAL）またはエスカレーションプラン（ESCALATION）のタイプを持ちます。
  #   エスカレーションプランタイプの連絡先に対してこのリソースで計画を定義します。
  #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/escalation.html
  # 参考: aws_ssmcontacts_contactリソースのarnを使用します
  contact_id = "arn:aws:ssm-contacts:ap-northeast-1:123456789012:contact/example-escalation-plan"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的に生成します
  # 注意: 通常は指定不要です。計算属性としても使用されます。
  id = null

  #-------------------------------------------------------------
  # エスカレーションステージ設定
  #-------------------------------------------------------------

  # stage (Required)
  # 設定内容: エスカレーション計画のステージを定義します。
  # 注意: 少なくとも1つのステージが必要です。
  # 関連機能: エスカレーションステージ
  #   各ステージは期間と、通知を送信する1つ以上のターゲット（連絡先またはチャネル）を
  #   持ちます。前のステージで応答がない場合、指定された期間後に次のステージに進みます。
  #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/escalation.html
  stage {
    # duration_in_minutes (Required)
    # 設定内容: このステージの継続時間を分単位で指定します。
    # 設定可能な値: 数値（分単位）。0を指定すると即座に開始されます。
    # 注意: 最初のステージでは通常0を指定し、後続のステージでは前のステージの
    #       応答を待つ時間を指定します。
    # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/escalation.html
    duration_in_minutes = 0

    # target (Optional)
    # 設定内容: このステージで通知を送信するターゲットを定義します。
    # 注意: 複数のtargetブロックを指定できます。各targetは連絡先またはチャネルの
    #       いずれか一方を含む必要があります。
    target {
      # contact_target_info (Optional, 最大1つまで)
      # 設定内容: 連絡先をターゲットとして指定します。
      # 注意: channel_target_infoと排他的（どちらか一方のみ指定可能）
      contact_target_info {
        # contact_id (Optional)
        # 設定内容: 通知を送信する連絡先のARNを指定します。
        # 設定可能な値: 有効な連絡先のAmazon Resource Name (ARN)
        # 参考: 個人（PERSONAL）タイプの連絡先を指定します
        contact_id = "arn:aws:ssm-contacts:ap-northeast-1:123456789012:contact/example-contact"

        # is_essential (Required)
        # 設定内容: この連絡先が重要（エッセンシャル）であるかを指定します。
        # 設定可能な値:
        #   - true: 重要な連絡先。この連絡先が応答するとエスカレーションが停止します
        #   - false: 重要でない連絡先。応答してもエスカレーションは継続します
        # 関連機能: エスカレーション制御
        #   重要な連絡先が応答すると、エスカレーション計画の実行を停止できます。
        #   複数の連絡先がいる場合、重要な連絡先の応答のみがエスカレーションを停止します。
        #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/escalation.html
        is_essential = true
      }

      # channel_target_info (Optional, 最大1つまで)
      # 設定内容: 連絡チャネルをターゲットとして指定します。
      # 注意: contact_target_infoと排他的（どちらか一方のみ指定可能）
      # channel_target_info {
      #   # contact_channel_id (Required)
      #   # 設定内容: 通知を送信する連絡チャネルのARNを指定します。
      #   # 設定可能な値: 有効な連絡チャネルのAmazon Resource Name (ARN)
      #   # 関連機能: 連絡チャネル
      #   #   連絡チャネルは、SMS、音声通話、メールなどの通知方法を定義します。
      #   #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/contacts.html
      #   # 参考: aws_ssmcontacts_contact_channelリソースのarnを使用します
      #   contact_channel_id = "arn:aws:ssm-contacts:ap-northeast-1:123456789012:contact-channel/example-channel"
      #
      #   # retry_interval_in_minutes (Optional)
      #   # 設定内容: 再試行の間隔を分単位で指定します。
      #   # 設定可能な値: 数値（分単位）
      #   # 省略時: 再試行は行われません
      #   # 注意: 指定した場合、応答がない場合にこの間隔で再度通知が送信されます。
      #   retry_interval_in_minutes = 2
      # }
    }

    # 複数のターゲットを指定する例
    # target {
    #   contact_target_info {
    #     contact_id   = "arn:aws:ssm-contacts:ap-northeast-1:123456789012:contact/another-contact"
    #     is_essential = false
    #   }
    # }
  }

  # 複数のステージを指定する例（第2ステージ）
  # stage {
  #   # duration_in_minutes (Required)
  #   # 設定内容: 前のステージから次のステージまでの待機時間を分単位で指定します。
  #   # 設定可能な値: 数値（分単位）
  #   # 注意: 前のステージで応答がない場合、この期間後に次のステージに進みます。
  #   duration_in_minutes = 5
  #
  #   target {
  #     contact_target_info {
  #       contact_id   = "arn:aws:ssm-contacts:ap-northeast-1:123456789012:contact/escalation-contact"
  #       is_essential = true
  #     }
  #   }
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは明示的なcomputed only属性をエクスポートしません。
# idとregionは入力可能かつcomputedな属性です。
#---------------------------------------------------------------
