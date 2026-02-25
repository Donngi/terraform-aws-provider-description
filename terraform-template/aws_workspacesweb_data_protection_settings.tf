#---------------------------------------------------------------
# AWS WorkSpaces Secure Browser データ保護設定
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browser のデータ保護設定をプロビジョニングするリソースです。
# インラインリダクション機能を使用して、ブラウジングセッション中に表示される
# センシティブなデータ（クレジットカード番号、個人識別番号、機密パターンなど）を
# 自動的にマスキング（リダクション）します。
# ウェブポータルに関連付けることで、DLPポリシーを一元管理できます。
#
# AWS公式ドキュメント:
#   - WorkSpaces Secure Browser概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/what-is-workspaces-web.html
#   - データ保護設定: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/data-protection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_data_protection_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_data_protection_settings" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required)
  # 設定内容: データ保護設定の表示名を指定します。
  # 設定可能な値: 任意の文字列
  display_name = "example-data-protection-settings"

  # description (Optional)
  # 設定内容: データ保護設定の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example data protection settings for sensitive data redaction"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_managed_key (Optional)
  # 設定内容: データ保護設定の暗号化に使用するカスタマーマネージドKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドキーが使用されます
  # 注意: additional_encryption_context と組み合わせて使用可能です。
  customer_managed_key = null

  # additional_encryption_context (Optional)
  # 設定内容: 暗号化コンテキストに追加するキーと値のペアを指定します。
  # 設定可能な値: 文字列のキーと値のペアのマップ
  # 省略時: 追加の暗号化コンテキストなし
  # 注意: customer_managed_key が指定されている場合に使用されます。
  #       同じ暗号化コンテキストを復号化時にも提供する必要があります。
  additional_encryption_context = null

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
  # インラインリダクション設定
  #-------------------------------------------------------------

  # inline_redaction_configuration (Optional)
  # 設定内容: ブラウジングセッション中にセンシティブなデータを自動マスキングする
  #           インラインリダクション機能の設定を行います。
  # 関連機能: インラインリダクション
  #   ウェブページ上のセンシティブなデータをリアルタイムで検出し、
  #   プレースホルダーテキストまたは画像に置き換えることで情報漏洩を防止します。
  #   組み込みパターン（クレジットカード番号、SSNなど）またはカスタム正規表現パターンを使用できます。
  inline_redaction_configuration {
    # global_confidence_level (Optional)
    # 設定内容: すべてのリダクションパターンに適用されるグローバルな信頼レベルを指定します。
    # 設定可能な値: 整数（パターンごとのconfidence_levelで上書き可能）
    # 省略時: 各パターンの個別設定に従います
    global_confidence_level = 2

    # global_enforced_urls (Optional)
    # 設定内容: リダクションを強制適用するURLのリストをグローバルに指定します。
    # 設定可能な値: URLパターンの文字列リスト
    # 省略時: 強制適用するURLなし
    global_enforced_urls = ["https://example.com/*"]

    # global_exempt_urls (Optional)
    # 設定内容: リダクションを適用しないURLのリストをグローバルに指定します。
    # 設定可能な値: URLパターンの文字列リスト
    # 省略時: 除外するURLなし
    global_exempt_urls = ["https://internal.example.com/*"]

    # inline_redaction_pattern (Optional)
    # 設定内容: センシティブデータを検出・リダクションするパターンを定義します。
    # 注意: 複数の inline_redaction_pattern ブロックを指定できます。
    #       各パターンは組み込みパターンIDまたはカスタムパターンのいずれかを使用します。
    inline_redaction_pattern {
      # built_in_pattern_id (Optional)
      # 設定内容: AWSが提供する組み込みリダクションパターンのIDを指定します。
      # 設定可能な値: AWSが提供する組み込みパターンID（例: クレジットカード番号、SSNなど）
      # 省略時: カスタムパターンを使用
      # 注意: built_in_pattern_id と custom_pattern は排他的に使用します。
      built_in_pattern_id = "CreditCardNumber"

      # confidence_level (Optional)
      # 設定内容: このパターンに固有の信頼レベルを指定します。
      # 設定可能な値: 整数（global_confidence_level を上書きします）
      # 省略時: global_confidence_level の値が使用されます
      confidence_level = 3

      # enforced_urls (Optional)
      # 設定内容: このパターンのリダクションを強制適用するURLのリストを指定します。
      # 設定可能な値: URLパターンの文字列リスト
      # 省略時: global_enforced_urls の設定に従います
      enforced_urls = ["https://payment.example.com/*"]

      # exempt_urls (Optional)
      # 設定内容: このパターンのリダクションを適用しないURLのリストを指定します。
      # 設定可能な値: URLパターンの文字列リスト
      # 省略時: global_exempt_urls の設定に従います
      exempt_urls = ["https://admin.example.com/*"]

      # redaction_place_holder (Optional)
      # 設定内容: センシティブデータをリダクションした後に表示するプレースホルダーを設定します。
      redaction_place_holder {
        # redaction_place_holder_type (Required within block)
        # 設定内容: リダクション後に表示するプレースホルダーのタイプを指定します。
        # 設定可能な値:
        #   - "CustomText": カスタムテキストでマスキング（redaction_place_holder_text が必要）
        #   - "Image": 画像でマスキング
        redaction_place_holder_type = "CustomText"

        # redaction_place_holder_text (Optional)
        # 設定内容: CustomText タイプの場合に表示するテキストを指定します。
        # 設定可能な値: 任意の文字列
        # 省略時: デフォルトのプレースホルダーテキストが使用されます
        # 注意: redaction_place_holder_type が "CustomText" の場合のみ有効です。
        redaction_place_holder_text = "[REDACTED]"
      }
    }

    # カスタムパターンを使用したリダクション例
    inline_redaction_pattern {
      # confidence_level (Optional)
      confidence_level = 2

      # custom_pattern (Optional)
      # 設定内容: 独自の正規表現パターンを使用してセンシティブデータを検出します。
      # 注意: 1つの inline_redaction_pattern ブロックに最大1つの custom_pattern ブロックを指定できます。
      custom_pattern {
        # pattern_name (Required within block)
        # 設定内容: カスタムパターンの名前を指定します。
        # 設定可能な値: 任意の文字列
        pattern_name = "EmployeeID"

        # pattern_regex (Required within block)
        # 設定内容: センシティブデータを検出するための正規表現を指定します。
        # 設定可能な値: 有効な正規表現パターン
        pattern_regex = "EMP-\\d{6}"

        # keyword_regex (Optional)
        # 設定内容: パターンの近くに存在するキーワードを検出するための正規表現を指定します。
        # 設定可能な値: 有効な正規表現パターン
        # 省略時: キーワード検出なし
        # 注意: キーワードが近くに存在する場合のみパターンが適用されるため、誤検出を減らすことができます。
        keyword_regex = "Employee|EmpID"

        # pattern_description (Optional)
        # 設定内容: カスタムパターンの説明を指定します。
        # 設定可能な値: 任意の文字列
        # 省略時: 説明なし
        pattern_description = "Matches internal employee ID format"
      }

      redaction_place_holder {
        redaction_place_holder_type = "CustomText"
        redaction_place_holder_text = "[EMP-ID]"
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-data-protection-settings"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - data_protection_settings_arn: データ保護設定リソースのAmazon Resource Name (ARN)
#
# - associated_portal_arns: このデータ保護設定に関連付けられたウェブポータルのARNリスト
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
