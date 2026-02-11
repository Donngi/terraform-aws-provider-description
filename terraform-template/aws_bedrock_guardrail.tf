#---------------------------------------------------------------
# AWS Bedrock Guardrail
#---------------------------------------------------------------
#
# Amazon Bedrockのガードレールをプロビジョニングするリソースです。
# ガードレールは、生成AIアプリケーションの安全性を確保するための設定可能な
# セーフガードを提供し、有害なコンテンツのフィルタリング、機密情報の保護、
# トピック制限、ハルシネーション検出などの機能を持ちます。
#
# AWS公式ドキュメント:
#   - Bedrock Guardrails概要: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html
#   - Guardrails仕組み: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-how.html
#   - コンテンツフィルター: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-content-filters.html
#   - 機密情報フィルター: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-sensitive-filters.html
#   - コンテキストグラウンディング: https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-contextual-grounding-check.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_bedrock_guardrail" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ガードレールの名前を指定します。
  # 設定可能な値: 1-50文字の文字列（英数字、ハイフン、アンダースコアを含む）
  name = "my-guardrail"

  # blocked_input_messaging (Required)
  # 設定内容: ガードレールがプロンプト（入力）をブロックした際に返すメッセージを指定します。
  # 設定可能な値: 任意の文字列
  # 用途: ユーザーの入力が有害なコンテンツとして検出された場合に表示される応答メッセージ
  blocked_input_messaging = "申し訳ございませんが、その内容についてはお答えできません。"

  # blocked_outputs_messaging (Required)
  # 設定内容: ガードレールがモデルの応答（出力）をブロックした際に返すメッセージを指定します。
  # 設定可能な値: 任意の文字列
  # 用途: モデルの出力が有害なコンテンツとして検出された場合に表示される応答メッセージ
  blocked_outputs_messaging = "申し訳ございませんが、適切な応答を生成できませんでした。"

  #-------------------------------------------------------------
  # 基本設定（オプション）
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ガードレールの説明を指定します。
  # 設定可能な値: 任意の文字列（最大200文字）
  description = "生成AIアプリケーション用のコンテンツセーフガード"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # kms_key_arn (Optional)
  # 設定内容: ガードレールの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 関連機能: カスタムKMSキーによるデータ暗号化
  #   AWS管理キーの代わりにカスタマー管理キー（CMK）を使用してガードレールを暗号化できます。
  kms_key_arn = null

  #-------------------------------------------------------------
  # コンテンツポリシー設定
  #-------------------------------------------------------------
  # 有害なテキストや画像コンテンツを検出・フィルタリングするためのポリシーです。
  # Hate（差別）、Insults（侮辱）、Sexual（性的）、Violence（暴力）、
  # Misconduct（不正行為）、Prompt Attack（プロンプト攻撃）のカテゴリで
  # フィルタリングできます。

  content_policy_config {
    # tier_config (Optional)
    # 設定内容: コンテンツポリシーのティア設定を指定します。
    # 設定可能な値:
    #   - "STANDARD": 標準ティア。コード要素内の有害コンテンツも検出可能
    #   - "CLASSIC": クラシックティア。基本的なコンテンツフィルタリング
    tier_config {
      tier_name = "STANDARD"
    }

    # filters_config (Optional)
    # 設定内容: コンテンツフィルターの設定を指定します。
    # 複数のフィルターを設定できます。

    filters_config {
      # type (Required)
      # 設定内容: コンテンツフィルターのタイプを指定します。
      # 設定可能な値:
      #   - "HATE": 差別・偏見に関するコンテンツ
      #   - "INSULTS": 侮辱的なコンテンツ
      #   - "SEXUAL": 性的なコンテンツ
      #   - "VIOLENCE": 暴力的なコンテンツ
      #   - "MISCONDUCT": 不正行為に関するコンテンツ
      #   - "PROMPT_ATTACK": プロンプト攻撃（ジェイルブレイク、プロンプトインジェクション）
      type = "HATE"

      # input_strength (Required)
      # 設定内容: 入力プロンプトに対するフィルタリング強度を指定します。
      # 設定可能な値:
      #   - "NONE": フィルタリングなし
      #   - "LOW": 低強度（明らかに有害なコンテンツのみ検出）
      #   - "MEDIUM": 中強度（一般的な有害コンテンツを検出）
      #   - "HIGH": 高強度（潜在的に有害なコンテンツも検出）
      input_strength = "MEDIUM"

      # output_strength (Required)
      # 設定内容: モデル応答に対するフィルタリング強度を指定します。
      # 設定可能な値: "NONE", "LOW", "MEDIUM", "HIGH"（input_strengthと同様）
      output_strength = "MEDIUM"

      # input_action (Optional)
      # 設定内容: 有害コンテンツが入力で検出された場合のアクションを指定します。
      # 設定可能な値:
      #   - "BLOCK": コンテンツをブロックし、blocked_input_messagingを返す
      #   - "NONE": 検出のみ行い、ブロックしない（検出モード）
      input_action = "BLOCK"

      # input_enabled (Optional)
      # 設定内容: 入力に対するガードレール評価を有効にするかを指定します。
      # 設定可能な値: true, false
      # 注意: falseの場合、評価は実行されず課金も発生しません
      input_enabled = true

      # input_modalities (Optional)
      # 設定内容: 入力でフィルタリングするモダリティを指定します。
      # 設定可能な値: ["TEXT"], ["IMAGE"], ["TEXT", "IMAGE"]
      input_modalities = ["TEXT"]

      # output_action (Optional)
      # 設定内容: 有害コンテンツが出力で検出された場合のアクションを指定します。
      # 設定可能な値: "BLOCK", "NONE"（input_actionと同様）
      output_action = "BLOCK"

      # output_enabled (Optional)
      # 設定内容: 出力に対するガードレール評価を有効にするかを指定します。
      # 設定可能な値: true, false
      output_enabled = true

      # output_modalities (Optional)
      # 設定内容: 出力でフィルタリングするモダリティを指定します。
      # 設定可能な値: ["TEXT"], ["IMAGE"], ["TEXT", "IMAGE"]
      output_modalities = ["TEXT"]
    }

    filters_config {
      type            = "INSULTS"
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
    }

    filters_config {
      type            = "SEXUAL"
      input_strength  = "HIGH"
      output_strength = "HIGH"
    }

    filters_config {
      type            = "VIOLENCE"
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
    }

    filters_config {
      type            = "MISCONDUCT"
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
    }

    filters_config {
      type            = "PROMPT_ATTACK"
      input_strength  = "HIGH"
      output_strength = "NONE"
    }
  }

  #-------------------------------------------------------------
  # トピックポリシー設定
  #-------------------------------------------------------------
  # 特定のトピックを拒否するためのポリシーです。
  # アプリケーションのコンテキストで望ましくないトピックを定義し、
  # ユーザークエリやモデル応答で検出された場合にブロックします。

  topic_policy_config {
    # tier_config (Optional)
    # 設定内容: トピックポリシーのティア設定を指定します。
    # 設定可能な値:
    #   - "STANDARD": 標準ティア。より高度なトピック検出
    #   - "CLASSIC": クラシックティア。基本的なトピック検出
    tier_config {
      tier_name = "CLASSIC"
    }

    # topics_config (Optional)
    # 設定内容: 拒否するトピックの設定を指定します。

    topics_config {
      # name (Required)
      # 設定内容: トピックの名前を指定します。
      # 設定可能な値: 一意の識別名（最大100文字）
      name = "investment_advice"

      # type (Required)
      # 設定内容: トピックのタイプを指定します。
      # 設定可能な値:
      #   - "DENY": このトピックを拒否（ブロック）する
      type = "DENY"

      # definition (Required)
      # 設定内容: トピックの定義（説明）を自然言語で指定します。
      # 設定可能な値: トピックを説明する文章（最大200文字）
      # 用途: ガードレールがこのトピックを識別するための説明
      definition = "投資アドバイスとは、リターンを生み出すことを目的とした資金や資産の管理または配分に関する問い合わせ、ガイダンス、または推奨事項を指します。"

  # 機密情報ポリシー設定
  #-------------------------------------------------------------
  # 個人情報（PII）やカスタムパターンの機密情報を検出し、
  # ブロックまたはマスキング（匿名化）するためのポリシーです。

  sensitive_information_policy_config {
    # pii_entities_config (Optional)
    # 設定内容: PIIエンティティのフィルター設定を指定します。
    # 検出可能なPIIタイプ:
    #   - ADDRESS: 住所
    #   - AGE: 年齢
    #   - NAME: 名前
    #   - EMAIL: メールアドレス
    #   - PHONE: 電話番号
    #   - USERNAME: ユーザー名
    #   - PASSWORD: パスワード
    #   - DRIVER_ID: 運転免許証番号
    #   - LICENSE_PLATE: ナンバープレート
    #   - VEHICLE_IDENTIFICATION_NUMBER: 車両識別番号
    #   - CREDIT_DEBIT_CARD_CVV: クレジット/デビットカードCVV
    #   - CREDIT_DEBIT_CARD_EXPIRY: クレジット/デビットカード有効期限
    #   - CREDIT_DEBIT_CARD_NUMBER: クレジット/デビットカード番号
    #   - PIN: 暗証番号
    #   - INTERNATIONAL_BANK_ACCOUNT_NUMBER: IBAN
    #   - SWIFT_CODE: SWIFTコード
    #   - IP_ADDRESS: IPアドレス
    #   - MAC_ADDRESS: MACアドレス
    #   - URL: URL
    #   - AWS_ACCESS_KEY: AWSアクセスキー
    #   - AWS_SECRET_KEY: AWSシークレットキー
    #   - US_BANK_ACCOUNT_NUMBER: 米国銀行口座番号
    #   - US_BANK_ROUTING_NUMBER: 米国銀行ルーティング番号
    #   - US_INDIVIDUAL_TAX_IDENTIFICATION_NUMBER: 米国個人納税者識別番号
    #   - US_PASSPORT_NUMBER: 米国パスポート番号
    #   - CA_HEALTH_NUMBER: カナダ健康保険番号
    #   - CA_SOCIAL_INSURANCE_NUMBER: カナダ社会保険番号
    #   - UK_NATIONAL_HEALTH_SERVICE_NUMBER: 英国NHS番号
    #   - UK_NATIONAL_INSURANCE_NUMBER: 英国国民保険番号
    #   - UK_UNIQUE_TAXPAYER_REFERENCE_NUMBER: 英国納税者参照番号

    pii_entities_config {
      # type (Required)
      # 設定内容: 検出するPIIエンティティのタイプを指定します。
      type = "NAME"

      # action (Required)
      # 設定内容: PIIが検出された場合のデフォルトアクションを指定します。
      # 設定可能な値:
      #   - "BLOCK": コンテンツをブロック
      #   - "ANONYMIZE": PIIをマスキング（例: [NAME]に置換）
      action = "ANONYMIZE"

      # input_action (Optional)
      # 設定内容: 入力でPIIが検出された場合のアクションを指定します。
      # 設定可能な値: "BLOCK", "ANONYMIZE", "NONE"
      input_action = "ANONYMIZE"

      # input_enabled (Optional)
      # 設定内容: 入力に対するPII検出を有効にするかを指定します。
      input_enabled = true

      # output_action (Optional)
      # 設定内容: 出力でPIIが検出された場合のアクションを指定します。
      # 設定可能な値: "BLOCK", "ANONYMIZE", "NONE"
      output_action = "ANONYMIZE"

      # output_enabled (Optional)
      # 設定内容: 出力に対するPII検出を有効にするかを指定します。
      output_enabled = true
    }

    pii_entities_config {
      type           = "EMAIL"
      action         = "ANONYMIZE"
      input_action   = "ANONYMIZE"
      input_enabled  = true
      output_action  = "ANONYMIZE"
      output_enabled = true
    }

    pii_entities_config {
      type           = "PHONE"
      action         = "ANONYMIZE"
      input_action   = "ANONYMIZE"
      input_enabled  = true
      output_action  = "ANONYMIZE"
      output_enabled = true
    }

    pii_entities_config {
      type           = "CREDIT_DEBIT_CARD_NUMBER"
      action         = "BLOCK"
      input_action   = "BLOCK"
      input_enabled  = true
      output_action  = "BLOCK"
      output_enabled = true
    }

    # regexes_config (Optional)
    # 設定内容: カスタム正規表現パターンで機密情報を検出する設定を指定します。

    regexes_config {
      # name (Required)
      # 設定内容: 正規表現パターンの名前を指定します。
      name = "social_security_number"

      # pattern (Required)
      # 設定内容: 検出する正規表現パターンを指定します。
      pattern = "^\\d{3}-\\d{2}-\\d{4}$"

      # action (Required)
      # 設定内容: パターンが検出された場合のデフォルトアクションを指定します。
      # 設定可能な値: "BLOCK", "ANONYMIZE"
      action = "BLOCK"

      # description (Optional)
      # 設定内容: 正規表現パターンの説明を指定します。
      description = "米国社会保障番号（SSN）形式のパターン"

      # input_action (Optional)
      # 設定内容: 入力でパターンが検出された場合のアクションを指定します。
      input_action = "BLOCK"

      # input_enabled (Optional)
      # 設定内容: 入力に対するパターン検出を有効にするかを指定します。
      input_enabled = true

      # output_action (Optional)
      # 設定内容: 出力でパターンが検出された場合のアクションを指定します。
      output_action = "BLOCK"

      # output_enabled (Optional)
      # 設定内容: 出力に対するパターン検出を有効にするかを指定します。
      output_enabled = true
    }
  }

  #-------------------------------------------------------------
  # ワードポリシー設定
  #-------------------------------------------------------------
  # 特定の単語やフレーズをブロックするためのポリシーです。
  # カスタムワードリストやAWSが提供するマネージドワードリスト
  # （不適切な言葉など）を使用できます。

  word_policy_config {
    # managed_word_lists_config (Optional)
    # 設定内容: AWSが提供するマネージドワードリストの設定を指定します。

    managed_word_lists_config {
      # type (Required)
      # 設定内容: マネージドワードリストのタイプを指定します。
      # 設定可能な値:
      #   - "PROFANITY": 不適切な言葉・冒涜的な表現をブロック
      type = "PROFANITY"

      # input_action (Optional)
      # 設定内容: 入力でマネージドワードが検出された場合のアクションを指定します。
      # 設定可能な値: "BLOCK", "NONE"
      input_action = "BLOCK"

      # input_enabled (Optional)
      # 設定内容: 入力に対するマネージドワード検出を有効にするかを指定します。
      input_enabled = true

      # output_action (Optional)
      # 設定内容: 出力でマネージドワードが検出された場合のアクションを指定します。
      output_action = "BLOCK"

      # output_enabled (Optional)
      # 設定内容: 出力に対するマネージドワード検出を有効にするかを指定します。
      output_enabled = true
    }

    # words_config (Optional)
    # 設定内容: カスタムワードリストの設定を指定します。

    words_config {
      # text (Required)
      # 設定内容: ブロックする単語またはフレーズを指定します。
      text = "競合他社名"

      # input_action (Optional)
      # 設定内容: 入力でカスタムワードが検出された場合のアクションを指定します。
      input_action = "BLOCK"

      # input_enabled (Optional)
      # 設定内容: 入力に対するカスタムワード検出を有効にするかを指定します。
      input_enabled = true

      # output_action (Optional)
      # 設定内容: 出力でカスタムワードが検出された場合のアクションを指定します。
      output_action = "BLOCK"

      # output_enabled (Optional)
      # 設定内容: 出力に対するカスタムワード検出を有効にするかを指定します。
      output_enabled = true
    }

    words_config {
      text = "禁止フレーズ"
    }
  }

  #-------------------------------------------------------------
  # コンテキストグラウンディングポリシー設定
  #-------------------------------------------------------------
  # モデル応答のハルシネーション（事実に基づかない情報）を検出するための
  # ポリシーです。グラウンディング（根拠性）とリレバンス（関連性）の
  # 2つの観点でチェックします。

  contextual_grounding_policy_config {
    # filters_config (Required)
    # 設定内容: コンテキストグラウンディングフィルターの設定を指定します。

    filters_config {
      # type (Required)
      # 設定内容: フィルターのタイプを指定します。
      # 設定可能な値:
      #   - "GROUNDING": グラウンディングチェック
      #     ソース情報に基づいて事実的に正確かどうかを検証
      #   - "RELEVANCE": リレバンスチェック
      #     ユーザーのクエリに対して応答が関連しているかを検証
      type = "GROUNDING"

      # threshold (Required)
      # 設定内容: フィルターのしきい値を指定します。
      # 設定可能な値: 0.0から1.0の間の数値
      # 注意: 値が高いほど厳格な検出（より多くの応答がブロックされる可能性）
      threshold = 0.75
    }

    filters_config {
      type      = "RELEVANCE"
      threshold = 0.75
    }
  }

  #-------------------------------------------------------------
  # クロスリージョン設定
  #-------------------------------------------------------------
  # 複数のリージョンにまたがる推論を有効にするための設定です。
  # ガードレールプロファイルを使用してクロスリージョン推論を構成します。

  # cross_region_config (Optional)
  # 設定内容: クロスリージョン推論の設定を指定します。
  # cross_region_config {
  #   # guardrail_profile_identifier (Required)
  #   # 設定内容: ガードレールプロファイルの識別子を指定します。
  #   guardrail_profile_identifier = "arn:aws:bedrock:us-east-1:123456789012:guardrail-profile/abc123"
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30s", "5m", "1h"）
    delete = "5m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-guardrail"
    Environment = "production"
    Purpose     = "content-safety"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - guardrail_arn: ガードレールのAmazon Resource Name (ARN)
#
# - guardrail_id: ガードレールのID
#
# - version: ガードレールのバージョン番号
#
# - status: ガードレールのステータス
#   - "READY": ガードレールが使用可能
#   - "FAILED": ガードレールの作成/更新に失敗
#
# - created_at: ガードレールが作成されたUnixエポックタイムスタンプ（秒）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
