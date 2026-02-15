#---------------------------------------
# AWS Customer Profiles Domain
#---------------------------------------
# Amazon Customer Profilesのドメインを作成します。
# Customer Profilesは複数のデータソースから顧客情報を統合し、
# 統一された顧客プロファイルを作成するサービスです。
#
# 主な用途:
# - 顧客データの統合と一元管理
# - 複数システムからの顧客情報の集約
# - 顧客プロファイルのマッチングとマージ
# - 顧客セグメンテーションの基盤構築
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマから生成されています
#
# Terraform説明: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customerprofiles_domain
# AWS APIドキュメント: https://docs.aws.amazon.com/customerprofiles/latest/APIReference/API_CreateDomain.html

#---------------------------------------
# Terraformリソース定義
#---------------------------------------
resource "aws_customerprofiles_domain" "example" {

  #---------------------------------------
  # ドメイン基本設定
  #---------------------------------------
  # 設定内容: Customer Profilesドメインの一意な名前
  # 設定可能な値: 1〜64文字の英数字、ハイフン、アンダースコア
  # 注意事項: 作成後の変更不可（新規リソース作成が必要）
  domain_name = "customer-profiles-domain"

  # 設定内容: プロファイルデータのデフォルト有効期限（日数）
  # 設定可能な値: 1〜1098（1日〜3年）
  # 注意事項: 期限切れデータは自動削除されます
  default_expiration_days = 365

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------
  # 設定内容: プロファイルデータの暗号化に使用するKMSキーのARN
  # 省略時: AWS管理のKMSキーが使用されます
  # 注意事項: カスタマー管理キーを使用する場合に指定
  default_encryption_key = null

  #---------------------------------------
  # デッドレターキュー設定
  #---------------------------------------
  # 設定内容: 処理に失敗したイベントを送信するSQSキューのURL
  # 省略時: デッドレターキューは使用されません
  # 注意事項: データ取り込みエラーの監視とリトライに使用
  dead_letter_queue_url = null

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを作成するAWSリージョン
  # 省略時: プロバイダーで設定されたリージョンが使用されます
  # 注意事項: マルチリージョン管理時に指定
  region = null

  #---------------------------------------
  # マッチング設定
  #---------------------------------------
  # 設定内容: プロファイルのマッチングとマージの設定
  # 省略時: マッチング機能は無効化されます
  # 注意事項: 重複プロファイルの統合に使用
  matching {
    # 設定内容: マッチング機能の有効化フラグ
    # 設定可能な値: true（有効） / false（無効）
    enabled = true

    #---------------------------------------
    # 自動マージ設定
    #---------------------------------------
    # 設定内容: プロファイルの自動マージ設定
    # 省略時: 自動マージは無効化されます
    # auto_merging {
    #   # 設定内容: 自動マージ機能の有効化フラグ
    #   # 設定可能な値: true（有効） / false（無効）
    #   enabled = true
    #
    #   # 設定内容: マージ実行の最小信頼スコア（0.0〜1.0）
    #   # 省略時: デフォルトのスコア閾値が使用されます
    #   # 注意事項: 高い値ほど正確だが統合数は減少します
    #   # min_allowed_confidence_score_for_merging = 0.7
    #
    #   #---------------------------------------
    #   # 競合解決設定
    #   #---------------------------------------
    #   # 設定内容: プロファイル属性の競合解決方法
    #   # conflict_resolution {
    #   #   # 設定内容: 競合解決モデル
    #   #   # 設定可能な値: RECENCY（最新） / SOURCE（ソース優先）
    #   #   conflict_resolving_model = "RECENCY"
    #   #
    #   #   # 設定内容: SOURCE選択時の優先ソース名
    #   #   # 省略時: RECENCYモデル使用時は不要
    #   #   # source_name = "Salesforce"
    #   # }
    #
    #   #---------------------------------------
    #   # 統合設定
    #   #---------------------------------------
    #   # 設定内容: マージ時に使用する属性の組み合わせ
    #   # consolidation {
    #   #   # 設定内容: マッチング属性の配列リスト
    #   #   # 注意事項: 各配列は統合に使用する属性の組み合わせ
    #   #   matching_attributes_list = [
    #   #     ["EmailAddress", "PhoneNumber"],
    #   #     ["FirstName", "LastName", "Address"]
    #   #   ]
    #   # }
    # }

    #---------------------------------------
    # エクスポート設定
    #---------------------------------------
    # 設定内容: マッチング結果のS3エクスポート設定
    # 省略時: エクスポートは実行されません
    # exporting_config {
    #   s3_exporting {
    #     # 設定内容: エクスポート先S3バケット名
    #     s3_bucket_name = "customer-profiles-export"
    #
    #     # 設定内容: S3キープレフィックス
    #     # 省略時: バケットのルートに出力されます
    #     # s3_key_name = "exports/matching-results"
    #   }
    # }

    #---------------------------------------
    # ジョブスケジュール設定
    #---------------------------------------
    # 設定内容: マッチングジョブの実行スケジュール
    # 省略時: 手動実行のみ可能です
    # job_schedule {
    #   # 設定内容: 実行する曜日
    #   # 設定可能な値: SUNDAY / MONDAY / TUESDAY / WEDNESDAY / THURSDAY / FRIDAY / SATURDAY
    #   day_of_the_week = "SUNDAY"
    #
    #   # 設定内容: 実行時刻（HH:MM形式、UTC）
    #   # 設定可能な値: 00:00〜23:59
    #   time = "02:00"
    # }
  }

  #---------------------------------------
  # ルールベースマッチング設定
  #---------------------------------------
  # 設定内容: カスタムルールによるマッチング設定
  # 省略時: ルールベースマッチングは無効化されます
  # 注意事項: matchingブロックと併用可能
  # rule_based_matching {
  #   # 設定内容: ルールベースマッチングの有効化フラグ
  #   # 設定可能な値: true（有効） / false（無効）
  #   enabled = true
  #
  #   # 設定内容: マッチング時の最大ルールレベル
  #   # 省略時: 制限なし
  #   # 注意事項: 1〜15の範囲で指定可能
  #   # max_allowed_rule_level_for_matching = 5
  #
  #   # 設定内容: マージ時の最大ルールレベル
  #   # 省略時: 制限なし
  #   # 注意事項: 1〜15の範囲で指定可能
  #   # max_allowed_rule_level_for_merging = 3
  #
  #   #---------------------------------------
  #   # 属性タイプセレクター
  #   #---------------------------------------
  #   # 設定内容: マッチングに使用する属性タイプの定義
  #   # attribute_types_selector {
  #   #   # 設定内容: 属性マッチングモデル
  #   #   # 設定可能な値: ONE_TO_ONE（1対1） / MANY_TO_MANY（多対多）
  #   #   attribute_matching_model = "ONE_TO_ONE"
  #   #
  #   #   # 設定内容: マッチングに使用する住所属性リスト
  #   #   # 省略時: 住所によるマッチングは実行されません
  #   #   # address = ["BusinessAddress", "ShippingAddress"]
  #   #
  #   #   # 設定内容: マッチングに使用するメールアドレス属性リスト
  #   #   # 省略時: メールによるマッチングは実行されません
  #   #   # email_address = ["EmailAddress", "PersonalEmailAddress"]
  #   #
  #   #   # 設定内容: マッチングに使用する電話番号属性リスト
  #   #   # 省略時: 電話番号によるマッチングは実行されません
  #   #   # phone_number = ["PhoneNumber", "MobilePhoneNumber"]
  #   # }
  #
  #   #---------------------------------------
  #   # 競合解決設定
  #   #---------------------------------------
  #   # 設定内容: プロファイル属性の競合解決方法
  #   # conflict_resolution {
  #   #   # 設定内容: 競合解決モデル
  #   #   # 設定可能な値: RECENCY（最新） / SOURCE（ソース優先）
  #   #   conflict_resolving_model = "RECENCY"
  #   #
  #   #   # 設定内容: SOURCE選択時の優先ソース名
  #   #   # 省略時: RECENCYモデル使用時は不要
  #   #   # source_name = "Salesforce"
  #   # }
  #
  #   #---------------------------------------
  #   # エクスポート設定
  #   #---------------------------------------
  #   # 設定内容: マッチング結果のS3エクスポート設定
  #   # exporting_config {
  #   #   s3_exporting {
  #   #     # 設定内容: エクスポート先S3バケット名
  #   #     s3_bucket_name = "customer-profiles-export"
  #   #
  #   #     # 設定内容: S3キープレフィックス
  #   #     # 省略時: バケットのルートに出力されます
  #   #     # s3_key_name = "exports/rule-based-results"
  #   #   }
  #   # }
  #
  #   #---------------------------------------
  #   # マッチングルール定義
  #   #---------------------------------------
  #   # 設定内容: カスタムマッチングルールのセット
  #   # 注意事項: 複数のルールを定義可能
  #   # matching_rules {
  #   #   # 設定内容: マッチング条件の配列
  #   #   # 注意事項: AND条件で評価されます
  #   #   rule = [
  #   #     "EmailAddress",
  #   #     "PhoneNumber"
  #   #   ]
  #   # }
  #   #
  #   # matching_rules {
  #   #   rule = [
  #   #     "FirstName",
  #   #     "LastName",
  #   #     "Address"
  #   #   ]
  #   # }
  # }

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: リソースに付与するタグ
  # 省略時: タグは付与されません
  # 注意事項: コスト配分、リソース管理に使用
  tags = {
    Name        = "customer-profiles-domain"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------
# arn
#   設定内容: ドメインのARN
#   形式: arn:aws:profile:region:account-id:domains/domain-name
#
# id
#   設定内容: ドメイン名（domain_nameと同値）
#
# region
#   設定内容: リソースが作成されたAWSリージョン
#
# tags_all
#   設定内容: デフォルトタグを含む全タグのマップ
#
# rule_based_matching.0.status
#   設定内容: ルールベースマッチングのステータス
#   設定可能な値: PENDING / IN_PROGRESS / ACTIVE

#---------------------------------------
# 出力例
#---------------------------------------
# output "domain_arn" {
#   description = "Customer Profiles ドメインのARN"
#   value       = aws_customerprofiles_domain.example.arn
# }
#
# output "domain_id" {
#   description = "Customer Profiles ドメインID"
#   value       = aws_customerprofiles_domain.example.id
# }
