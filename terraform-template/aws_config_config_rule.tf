#---------------------------------------
# AWS Config ルール
#---------------------------------------
# AWS Config ルールを作成し、AWSリソースの設定がコンプライアンス基準に
# 準拠しているかを自動的に評価します。
# マネージドルール、カスタムLambdaルール、カスタムポリシールールの
# いずれかを使用できます。
#
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/config_config_rule
# Generated: 2026-02-13
# NOTE: すべてのパラメータにデフォルト値または例を記載していますが、
#       実際の使用時には要件に応じて適切な値に変更してください。

resource "aws_config_config_rule" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: Config ルールの名前
  # 設定可能な値: 1〜128文字の英数字、ハイフン、アンダースコア
  name = "example-config-rule"

  # 設定内容: Config ルールの説明
  # 設定可能な値: 任意の文字列（最大256文字）
  # 省略時: 説明なし
  description = "S3バケットの暗号化を確認するルール"

  #---------------------------------------
  # ルールソース設定
  #---------------------------------------
  source {
    # 設定内容: ルールのオーナータイプ
    # 設定可能な値:
    #   - AWS: AWSマネージドルール
    #   - CUSTOM_LAMBDA: カスタムLambda関数ルール
    #   - CUSTOM_POLICY: カスタムポリシールール
    owner = "AWS"

    # 設定内容: ルールの識別子
    # 設定可能な値:
    #   - owner=AWSの場合: AWSマネージドルールの識別子（例: S3_BUCKET_VERSIONING_ENABLED）
    #   - owner=CUSTOM_LAMBDAの場合: Lambda関数のARN
    #   - owner=CUSTOM_POLICYの場合: 省略可能
    # 省略時: カスタムポリシールールの場合は不要
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"

    #---------------------------------------
    # カスタムポリシー詳細設定（owner=CUSTOM_POLICYの場合）
    #---------------------------------------
    # custom_policy_details {
    #   # 設定内容: ポリシーランタイムバージョン
    #   # 設定可能な値: guard-2.x.x（例: guard-2.0.0）
    #   policy_runtime = "guard-2.x.x"
    #
    #   # 設定内容: Config ポリシーのテキスト本文
    #   # 設定可能な値: Guard DSL形式のポリシー定義
    #   policy_text = <<-EOT
    #     rule check_s3_encryption {
    #       AWS::S3::Bucket {
    #         ServerSideEncryptionConfiguration exists
    #       }
    #     }
    #   EOT
    #
    #   # 設定内容: デバッグログ配信の有効化
    #   # 設定可能な値: true（有効）、false（無効）
    #   # 省略時: false
    #   # enable_debug_log_delivery = false
    # }

    #---------------------------------------
    # ソース詳細設定（イベントトリガー）
    #---------------------------------------
    # source_detail {
    #   # 設定内容: イベントソース
    #   # 設定可能な値: aws.config
    #   # 省略時: デフォルトイベントソース
    #   # event_source = "aws.config"
    #
    #   # 設定内容: メッセージタイプ
    #   # 設定可能な値:
    #   #   - ConfigurationItemChangeNotification: 設定変更時
    #   #   - OversizedConfigurationItemChangeNotification: 大容量設定変更時
    #   #   - ScheduledNotification: スケジュール実行時
    #   #   - ConfigurationSnapshotDeliveryCompleted: スナップショット配信完了時
    #   # message_type = "ConfigurationItemChangeNotification"
    #
    #   # 設定内容: スケジュール実行の最大実行頻度
    #   # 設定可能な値:
    #   #   - One_Hour: 1時間ごと
    #   #   - Three_Hours: 3時間ごと
    #   #   - Six_Hours: 6時間ごと
    #   #   - Twelve_Hours: 12時間ごと
    #   #   - TwentyFour_Hours: 24時間ごと
    #   # 省略時: message_type=ScheduledNotificationの場合は必須
    #   # maximum_execution_frequency = "TwentyFour_Hours"
    # }
    #
    # source_detail {
    #   message_type = "ConfigurationSnapshotDeliveryCompleted"
    # }
  }

  #---------------------------------------
  # 評価スコープ設定
  #---------------------------------------
  # scope {
  #   # 設定内容: 評価対象のリソースタイプ
  #   # 設定可能な値: AWSリソースタイプのリスト（例: ["AWS::S3::Bucket", "AWS::EC2::Instance"]）
  #   # 省略時: すべてのリソースタイプ
  #   # compliance_resource_types = ["AWS::S3::Bucket"]
  #
  #   # 設定内容: 特定のリソースID
  #   # 設定可能な値: 単一のリソースID（例: バケット名、インスタンスID）
  #   # 省略時: compliance_resource_typesで指定したすべてのリソース
  #   # compliance_resource_id = "my-bucket"
  #
  #   # 設定内容: タグキー
  #   # 設定可能な値: 評価対象とするタグのキー名
  #   # 省略時: タグによるフィルタリングなし
  #   # tag_key = "Environment"
  #
  #   # 設定内容: タグ値
  #   # 設定可能な値: 評価対象とするタグの値
  #   # 省略時: tag_keyで指定したキーを持つすべてのリソース
  #   # tag_value = "Production"
  # }

  #---------------------------------------
  # 実行設定
  #---------------------------------------
  # 設定内容: ルールの最大実行頻度（非推奨、source_detailを使用）
  # 設定可能な値: One_Hour、Three_Hours、Six_Hours、Twelve_Hours、TwentyFour_Hours
  # 省略時: 設定変更時のみ実行
  maximum_execution_frequency = "TwentyFour_Hours"

  # 設定内容: ルールに渡す入力パラメータ
  # 設定可能な値: JSON形式の文字列（ルール固有のパラメータ）
  # 省略時: パラメータなし
  input_parameters = jsonencode({
    desiredInstanceType = "t3.micro"
  })

  #---------------------------------------
  # 評価モード設定
  #---------------------------------------
  # evaluation_mode {
  #   # 設定内容: 評価モード
  #   # 設定可能な値:
  #   #   - DETECTIVE: 検出モード（既存リソースの評価）
  #   #   - PROACTIVE: 事前検証モード（デプロイ前の検証）
  #   # 省略時: DETECTIVE
  #   # mode = "DETECTIVE"
  # }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定のリージョン
  region = "us-east-1"

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-config-rule"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースの作成後、以下の属性を参照できます。
#
# - arn
#   Config ルールのARN
#
# - rule_id
#   Config ルールのID
#
# - id
#   Config ルールの名前
#
# - tags_all
#   プロバイダーのdefault_tagsとリソースのtagsを統合したタグマップ
