#---------------------------------------------------------------
# Amazon SageMaker Augmented AI Flow Definition
#---------------------------------------------------------------
#
# Amazon Augmented AI (Amazon A2I) のフロー定義（ヒューマンレビューワークフロー）を
# プロビジョニングするリソースです。フロー定義は、ヒューマンループを呼び出す条件、
# タスクを送信するワークフォース、ワーカータスクテンプレートの設定、
# および出力データの保存場所を指定します。
# Amazon Rekognition または Amazon Textract との統合、またはカスタムタスクタイプの
# いずれかを選択してヒューマンレビューを組み込むことができます。
#
# AWS公式ドキュメント:
#   - フロー定義の作成: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-create-flow-definition.html
#   - Amazon Augmented AI の概要: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-use-augmented-ai-a2i-human-review-loops.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_flow_definition
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_flow_definition" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # flow_definition_name (Required)
  # 設定内容: フロー定義の名前を指定します。
  # 設定可能な値: 1-63文字の英数字、ハイフン（-）
  flow_definition_name = "example-flow-definition"

  # role_arn (Required)
  # 設定内容: 他のサービスを呼び出すために必要なIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: S3への書き込み権限、およびAmazon A2Iが必要とするサービス権限が付与されている必要があります。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-permissions-security.html
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-a2i-execution-role"

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
  # ヒューマンループ設定
  #-------------------------------------------------------------

  # human_loop_config (Required)
  # 設定内容: ヒューマンレビュアーが実行するタスクに関する情報を含む設定ブロックです。
  # 関連機能: Amazon A2I ヒューマンループ設定
  #   ワーカータスクUIテンプレート、ワークチーム、タスク条件等を定義します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-create-flow-definition.html
  human_loop_config {

    # human_task_ui_arn (Required)
    # 設定内容: ヒューマンタスクUIのARNを指定します。
    # 設定可能な値: aws_sagemaker_human_task_ui リソースのARN
    human_task_ui_arn = "arn:aws:sagemaker:ap-northeast-1:123456789012:human-task-ui/example-ui"

    # task_title (Required)
    # 設定内容: ヒューマンワーカータスクのタイトルを指定します。
    # 設定可能な値: 文字列
    task_title = "レビュータスクのタイトル"

    # task_description (Required)
    # 設定内容: ヒューマンワーカータスクの説明を指定します。
    # 設定可能な値: 文字列
    task_description = "このタスクで実施するレビュー内容の説明"

    # task_count (Required)
    # 設定内容: 各オブジェクトに対して同一タスクを実行する異なるワーカーの数を指定します。
    # 設定可能な値: 1 〜 3 の整数
    task_count = 1

    # workteam_arn (Required)
    # 設定内容: タスクを送信するワークチームのARNを指定します。
    # 設定可能な値:
    #   - プライベートワークチームのARN: aws_sagemaker_workteam リソースのARN
    #   - パブリックワークフォース（Amazon Mechanical Turk）のARN:
    #     arn:aws:sagemaker:<region>:394669845002:workteam/public-crowd/default
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-management-public.html
    workteam_arn = "arn:aws:sagemaker:ap-northeast-1:123456789012:workteam/private-crowd/example-team"

    # task_availability_lifetime_in_seconds (Optional)
    # 設定内容: タスクがヒューマンワーカーによるレビューのために利用可能な時間（秒）を指定します。
    # 設定可能な値: 1 〜 864000（10日間）の整数
    # 省略時: デフォルト値が適用されます
    task_availability_lifetime_in_seconds = 86400

    # task_time_limit_in_seconds (Optional)
    # 設定内容: ワーカーがタスクを完了するために与えられる時間（秒）を指定します。
    # 設定可能な値: 整数
    # 省略時: 3600秒（1時間）
    task_time_limit_in_seconds = 3600

    # task_keywords (Optional)
    # 設定内容: ワーカーがタスクを発見しやすくするためのキーワードの配列を指定します。
    # 設定可能な値: 文字列のセット
    # 省略時: キーワードなし
    task_keywords = ["レビュー", "画像確認", "テキスト検証"]

    #-------------------------------------------------------------
    # パブリックワークフォース報酬設定
    #-------------------------------------------------------------

    # public_workforce_task_price (Optional)
    # 設定内容: Amazon Mechanical Turk ワーカーに支払う報酬金額の設定ブロックです。
    # 関連機能: Amazon Mechanical Turk ワークフォース
    #   パブリックワークフォース（Amazon Mechanical Turk）を使用する場合にのみ設定します。
    #   - https://docs.aws.amazon.com/sagemaker/latest/dg/sms-workforce-management-public.html
    public_workforce_task_price {

      # amount_in_usd (Optional)
      # 設定内容: 米国ドル建てで支払う報酬金額の設定ブロックです。
      amount_in_usd {

        # dollars (Optional)
        # 設定内容: 報酬金額のドル単位の整数部分を指定します。
        # 設定可能な値: 0 〜 2 の整数
        # 省略時: 0
        dollars = 0

        # cents (Optional)
        # 設定内容: 報酬金額のセント単位の端数部分を指定します。
        # 設定可能な値: 0 〜 99 の整数
        # 省略時: 0
        cents = 1

        # tenth_fractions_of_a_cent (Optional)
        # 設定内容: 報酬金額の1/10セント単位の端数部分を指定します。
        # 設定可能な値: 0 〜 9 の整数
        # 省略時: 0
        tenth_fractions_of_a_cent = 2
      }
    }
  }

  #-------------------------------------------------------------
  # 出力設定
  #-------------------------------------------------------------

  # output_config (Required)
  # 設定内容: ヒューマンレビュー結果をアップロードする場所に関する情報の設定ブロックです。
  output_config {

    # s3_output_path (Required)
    # 設定内容: ヒューマンレビューの出力を含むオブジェクトを格納するAmazon S3パスを指定します。
    # 設定可能な値: 有効なS3 URIパス（s3://バケット名/プレフィックス/形式）
    s3_output_path = "s3://my-a2i-output-bucket/flow-definition-output/"

    # kms_key_id (Optional)
    # 設定内容: サーバー側の暗号化に使用するAWS KMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 省略時: S3のデフォルト暗号化が適用されます
    kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # ヒューマンループリクエストソース設定
  #-------------------------------------------------------------

  # human_loop_request_source (Optional)
  # 設定内容: ヒューマンタスクリクエストのソースを設定するコンテナブロックです。
  # 関連機能: Amazon A2I 組み込みタスクタイプ
  #   Amazon Rekognition または Amazon Textract をインテグレーションソースとして使用する場合に設定します。
  #   カスタムタスクタイプの場合はこのブロックを設定しません。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-task-types-general.html
  human_loop_request_source {

    # aws_managed_human_loop_request_source (Required)
    # 設定内容: Amazon Rekognition または Amazon Textract のどちらをインテグレーションソースとして使用するかを指定します。
    # 設定可能な値:
    #   - "AWS/Rekognition/DetectModerationLabels/Image/V3": Amazon Rekognition のコンテンツモデレーション
    #   - "AWS/Textract/AnalyzeDocument/Forms/V1": Amazon Textract のドキュメント分析
    aws_managed_human_loop_request_source = "AWS/Textract/AnalyzeDocument/Forms/V1"
  }

  #-------------------------------------------------------------
  # ヒューマンループアクティベーション設定
  #-------------------------------------------------------------

  # human_loop_activation_config (Optional)
  # 設定内容: ヒューマンワークフローをトリガーするイベントに関する情報の設定ブロックです。
  # 関連機能: Amazon A2I ヒューマンループアクティベーション条件
  #   human_loop_request_source を設定した場合（組み込みタスクタイプ）にのみ使用できます。
  #   カスタムタスクタイプでは使用できません。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-human-fallback-conditions-json-schema.html
  human_loop_activation_config {

    # human_loop_activation_conditions_config (Required)
    # 設定内容: SageMaker AI がヒューマンループを作成する条件の設定ブロックです。
    human_loop_activation_conditions_config {

      # human_loop_activation_conditions (Required)
      # 設定内容: ユースケース固有の条件を宣言的に表現するJSON文字列を指定します。
      #           いずれかの条件が一致した場合、設定されたワークチームに対してアトミックタスクが作成されます。
      # 設定可能な値: Amazon A2I ヒューマンループアクティベーション条件のJSONスキーマに準拠したJSON文字列
      # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/a2i-human-fallback-conditions-json-schema.html
      human_loop_activation_conditions = jsonencode({
        Conditions = [
          {
            ConditionType = "Sampling"
            ConditionParameters = {
              RandomSamplingPercentage = 5
            }
          }
        ]
      })
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-flow-definition"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フロー定義のAmazon Resource Name (ARN)
# - id: フロー定義の名前
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
