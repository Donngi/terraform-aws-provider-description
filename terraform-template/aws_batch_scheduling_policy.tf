#---------------------------------------------------------------
# AWS Batch Scheduling Policy
#---------------------------------------------------------------
#
# AWS Batchのスケジューリングポリシーをプロビジョニングするリソースです。
# スケジューリングポリシーは、ジョブキューに関連付けてフェアシェアスケジューリングを
# 有効にするために使用します。フェアシェアスケジューリングにより、複数のユーザーや
# ワークロード間でコンピューティングリソースを公平に分配できます。
#
# AWS公式ドキュメント:
#   - Fair-share scheduling policies: https://docs.aws.amazon.com/batch/latest/userguide/job_scheduling.html
#   - Use fair-share scheduling: https://docs.aws.amazon.com/batch/latest/userguide/fair-share-scheduling.html
#   - FairsharePolicy API: https://docs.aws.amazon.com/batch/latest/APIReference/API_FairsharePolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_scheduling_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_batch_scheduling_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スケジューリングポリシーの名前を指定します。
  # 設定可能な値: 一意の文字列
  # 用途: ジョブキューにスケジューリングポリシーを関連付ける際に使用
  name = "example-scheduling-policy"

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
  # フェアシェアポリシー設定
  #-------------------------------------------------------------

  # fair_share_policy (Optional)
  # 設定内容: フェアシェアスケジューリングの詳細設定を指定するブロックです。
  # 関連機能: AWS Batch フェアシェアスケジューリング
  #   フェアシェアスケジューリングにより、各共有識別子に対してコンピューティング
  #   リソースの一定割合を割り当てることができます。これにより、特定のワークロードが
  #   すべてのリソースを独占することを防ぎます。
  #   - https://docs.aws.amazon.com/batch/latest/userguide/fair-share-scheduling.html
  fair_share_policy {
    # compute_reservation (Optional)
    # 設定内容: まだ使用されていないフェアシェア識別子のために、利用可能な最大vCPUの
    #           一部を予約するための値を指定します。
    # 設定可能な値: 0〜99の整数
    #   - 予約比率は (computeReservation/100)^アクティブな共有識別子数 で計算されます
    #   - 0: 予約なし（デフォルト）
    #   - 高い値: より多くのリソースを非アクティブな識別子のために予約
    # 用途: 新しいワークロードがすぐにリソースを取得できるようにする
    # 参考: https://docs.aws.amazon.com/batch/latest/APIReference/API_FairsharePolicy.html
    compute_reservation = 1

    # share_decay_seconds (Optional)
    # 設定内容: 各フェアシェア識別子のフェアシェア比率を計算するために使用する時間
    #           ウィンドウを秒単位で指定します。
    # 設定可能な値: 0〜604800（1週間）の整数
    #   - 0: デフォルトの最小時間ウィンドウ（600秒）を使用
    #   - 長い値: 過去の使用履歴をより長く考慮（最近の使用に対してより重み付け）
    # 用途: 最近リソースを使用していないワークロードに優先度を与える
    # 関連機能: フェアシェア比率の計算
    #   時間の経過とともに過去のリソース使用の影響が減衰し、最近実行された
    #   ジョブにより多くの重みが与えられます。
    #   - https://docs.aws.amazon.com/batch/latest/userguide/fair-share-scheduling.html
    share_decay_seconds = 3600

    # share_distribution (Optional, max 500)
    # 設定内容: フェアシェアポリシーの共有識別子と重みを定義するブロックです。
    # 最大数: 500個まで指定可能
    # 参考: https://docs.aws.amazon.com/batch/latest/APIReference/API_ShareAttributes.html
    share_distribution {
      # share_identifier (Required)
      # 設定内容: フェアシェア識別子またはフェアシェア識別子のプレフィックスを指定します。
      # 設定可能な値: 文字列
      #   - 正確な識別子（例: "A1"）
      #   - プレフィックス（例: "A1*"）: 「*」はプレフィックスとして機能
      # 用途: ジョブ送信時にschedulingPriorityPrefixに指定する値と対応
      # 参考: https://docs.aws.amazon.com/batch/latest/APIReference/API_ShareAttributes.html
      share_identifier = "A1*"

      # weight_factor (Optional)
      # 設定内容: フェアシェア識別子の重み係数を指定します。
      # 設定可能な値: 0.0001〜99.9999の数値
      #   - 低い値: より多くのリソースを取得（優先度が高い）
      #   - 高い値: より少ないリソースを取得（優先度が低い）
      # 省略時: デフォルトの重み1.0が適用
      # 用途: 特定のワークロードに優先度を設定
      # 参考: https://docs.aws.amazon.com/batch/latest/APIReference/API_ShareAttributes.html
      weight_factor = 0.1
    }

    share_distribution {
      share_identifier = "A2"
      weight_factor    = 0.2
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-scheduling-policy"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: スケジューリングポリシーのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
