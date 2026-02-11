#---------------------------------------------------------------
# AWS Audit Manager Control
#---------------------------------------------------------------
#
# AWS Audit Managerのカスタムコントロールをプロビジョニングするリソースです。
# コントロールは、コンプライアンス要件を満たすための安全対策や手順を定義し、
# AWSサービスからエビデンスを自動収集するか、手動でエビデンスを追加するかを
# 設定できます。
#
# AWS公式ドキュメント:
#   - Audit Manager概要: https://docs.aws.amazon.com/audit-manager/latest/userguide/what-is.html
#   - コントロールの概念: https://docs.aws.amazon.com/audit-manager/latest/userguide/concepts.html
#   - カスタムコントロールの作成: https://docs.aws.amazon.com/audit-manager/latest/userguide/create-controls.html
#   - サポートされるデータソース: https://docs.aws.amazon.com/audit-manager/latest/userguide/control-data-sources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/auditmanager_control
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_auditmanager_control" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コントロールの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-control"

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
  # コントロールの説明・情報
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: コントロールの説明を指定します。
  # 設定可能な値: 文字列（最大1000文字）
  description = "このコントロールはセキュリティ要件を満たすためのものです。"

  # testing_information (Optional)
  # 設定内容: コントロールが満たされているかを判断するための手順を指定します。
  # 設定可能な値: 文字列
  # 用途: 監査担当者がコントロールの準拠状況を評価する際のガイダンス
  testing_information = "1. 設定を確認する\n2. ログを確認する\n3. 結果を文書化する"

  #-------------------------------------------------------------
  # アクションプラン設定
  #-------------------------------------------------------------

  # action_plan_title (Optional)
  # 設定内容: コントロールの是正アクションプランのタイトルを指定します。
  # 設定可能な値: 文字列
  # 用途: コントロールが満たされていない場合の改善計画の見出し
  action_plan_title = "是正アクションプラン"

  # action_plan_instructions (Optional)
  # 設定内容: コントロールが満たされていない場合に実施すべき推奨アクションを指定します。
  # 設定可能な値: 文字列
  # 用途: コントロールが不適合の場合に監査担当者が参照するガイダンス
  action_plan_instructions = "1. 問題を特定する\n2. 是正措置を実施する\n3. 変更を文書化する"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-control"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # コントロールマッピングソース (Required)
  #-------------------------------------------------------------
  # エビデンスを収集するためのデータソースを定義します。
  # 複数のcontrol_mapping_sourcesブロックを指定することで、
  # 異なるソースからエビデンスを収集できます。

  # 例1: 手動エビデンス収集（Procedural Controls Mapping）
  control_mapping_sources {
    # source_name (Required)
    # 設定内容: ソースの名前を指定します。
    # 設定可能な値: 文字列（1-300文字）
    source_name = "manual-evidence-source"

    # source_set_up_option (Required)
    # 設定内容: データソースのセットアップオプションを指定します。
    # 設定可能な値:
    #   - "System_Controls_Mapping": 自動化されたエビデンス収集
    #   - "Procedural_Controls_Mapping": 手動エビデンス収集
    source_set_up_option = "Procedural_Controls_Mapping"

    # source_type (Required)
    # 設定内容: エビデンス収集に使用するデータソースの種類を指定します。
    # 設定可能な値:
    #   source_set_up_optionが"Procedural_Controls_Mapping"の場合:
    #     - "MANUAL": 手動でエビデンスを追加
    #   source_set_up_optionが"System_Controls_Mapping"の場合:
    #     - "AWS_Cloudtrail": CloudTrailログからエビデンスを収集
    #     - "AWS_Config": AWS Configルールからエビデンスを収集
    #     - "AWS_Security_Hub": Security Hubからエビデンスを収集
    #     - "AWS_API_Call": AWS APIコールからエビデンスを収集
    source_type = "MANUAL"

    # source_description (Optional)
    # 設定内容: ソースの説明を指定します。
    # 設定可能な値: 文字列（最大1000文字）
    source_description = "手動で追加するセキュリティレビューのエビデンス"

    # source_frequency (Optional)
    # 設定内容: エビデンス収集の頻度を指定します。
    # 設定可能な値:
    #   - "DAILY": 毎日収集
    #   - "WEEKLY": 毎週収集
    #   - "MONTHLY": 毎月収集
    # 注意: MANUALソースタイプでは通常使用しません
    source_frequency = null

    # troubleshooting_text (Optional)
    # 設定内容: コントロールのトラブルシューティング手順を指定します。
    # 設定可能な値: 文字列（最大1000文字）
    troubleshooting_text = "エビデンスが見つからない場合は、担当チームに連絡してください。"

    # source_keyword (Optional)
    # 設定内容: CloudTrailログ、Configルール、Security Hubコントロール、
    #          またはAWS API名を検索するためのキーワードを指定します。
    # 注意: MANUALソースタイプでは通常使用しません
    # source_keyword = [
    #   {
    #     keyword_input_type = "SELECT_FROM_LIST"
    #     keyword_value      = "CreateBucket"
    #   }
    # ]
  }

  # 例2: 自動エビデンス収集（AWS CloudTrail）
  control_mapping_sources {
    source_name          = "cloudtrail-evidence-source"
    source_set_up_option = "System_Controls_Mapping"
    source_type          = "AWS_Cloudtrail"

    source_description = "CloudTrailからS3バケット作成イベントを収集"
    source_frequency   = "DAILY"

    # source_keyword (Optional)
    # 設定内容: CloudTrailログ、Configルール、Security Hubコントロール、
    #          またはAWS API名を検索するためのキーワードを指定します。
    # 設定可能な値: オブジェクトのリスト
    #   - keyword_input_type (Required):
    #       - "INPUT_TEXT": テキスト入力
    #       - "SELECT_FROM_LIST": リストから選択
    #       - "UPLOAD_FILE": ファイルアップロード
    #   - keyword_value (Required): キーワード値
    #       CloudTrailイベント名、Configルール名、Security Hubコントロール、
    #       またはAWS APIコール名
    # 参考: https://docs.aws.amazon.com/audit-manager/latest/userguide/control-data-sources.html
    source_keyword = [
      {
        keyword_input_type = "SELECT_FROM_LIST"
        keyword_value      = "CreateBucket"
      }
    ]

    troubleshooting_text = "CloudTrailが有効化されていることを確認してください。"
  }

  # 例3: 自動エビデンス収集（AWS Config）
  control_mapping_sources {
    source_name          = "config-evidence-source"
    source_set_up_option = "System_Controls_Mapping"
    source_type          = "AWS_Config"

    source_description = "AWS ConfigルールからS3バケットのコンプライアンス状態を収集"

    source_keyword = [
      {
        keyword_input_type = "SELECT_FROM_LIST"
        keyword_value      = "s3-bucket-versioning-enabled"
      }
    ]

    troubleshooting_text = "AWS Configが有効化され、該当ルールが設定されていることを確認してください。"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コントロールのAmazon Resource Name (ARN)
#
# - id: コントロールの一意識別子
#
# - type: コントロールの種類（カスタムコントロールか標準コントロールか）
#
# - control_mapping_sources[*].source_id: 各ソースの一意識別子
#---------------------------------------------------------------
