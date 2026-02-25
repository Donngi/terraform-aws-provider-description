#---------------------------------------------------------------
# AWS Payment Cryptography Key
#---------------------------------------------------------------
#
# AWS Payment Cryptographyの暗号化キーをプロビジョニングするリソースです。
# Payment Cryptographyは、決済処理向けのPCI準拠の暗号化機能とキー管理を提供する
# マネージドサービスです。FIPS 140-2 Level 3認定のHSMを使用してキーマテリアルを
# 安全に管理します。キーにはkey_attributes（キーアルゴリズム、クラス、用途、
# 使用モード）を設定し、TR-31/TR-34規格に従った安全なキー交換が可能です。
#
# AWS公式ドキュメント:
#   - AWS Payment Cryptography概要: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/what-is.html
#   - キーの管理: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-manage.html
#   - CreateKey APIリファレンス: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_CreateKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/paymentcryptography_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_paymentcryptography_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # exportable (Required)
  # 設定内容: キーをサービスからエクスポート可能にするかを指定します。
  # 設定可能な値:
  #   - true: キーのエクスポートを許可。TR-31/TR-34規格を使用したキー交換が可能
  #   - false: キーのエクスポートを禁止。サービス内でのみ使用可能
  # 注意: 一度作成したキーのexportable設定は変更できません（Forces new resource相当）
  # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/security-best-practices.html
  exportable = true

  #-------------------------------------------------------------
  # 削除ウィンドウ設定
  #-------------------------------------------------------------

  # deletion_window_in_days (Optional)
  # 設定内容: キーを削除するまでの待機期間（日数）を指定します。
  # 設定可能な値: 整数値（日数）
  # 省略時: サービスのデフォルト値が適用されます
  # 注意: 削除をスケジュールすると、指定した日数後にキーが削除されます。
  #       削除待機期間中はキーを復元することができます
  # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-manage.html
  deletion_window_in_days = 7

  #-------------------------------------------------------------
  # キー有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: キーを有効にするかを指定します。
  # 設定可能な値:
  #   - true: キーを有効化。暗号化操作に使用可能
  #   - false: キーを無効化。暗号化操作には使用不可
  # 省略時: true（有効）
  enabled = true

  #-------------------------------------------------------------
  # キーチェック値アルゴリズム設定
  #-------------------------------------------------------------

  # key_check_value_algorithm (Optional)
  # 設定内容: キーチェック値（KCV）の計算に使用するアルゴリズムを指定します。
  # 設定可能な値:
  #   - "CMAC": CMAC（Cipher-based Message Authentication Code）を使用してKCVを計算
  #   - "ANSI_X9_24": ANSI X9.24規格に基づいてKCVを計算
  # 省略時: キーアルゴリズムに基づくデフォルト値が使用されます
  # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_CreateKey.html
  key_check_value_algorithm = "ANSI_X9_24"

  #-------------------------------------------------------------
  # キー属性設定
  #-------------------------------------------------------------

  # key_attributes (Required)
  # 設定内容: キーの役割、サポートするアルゴリズム、および許可される暗号化操作を定義するブロックです。
  # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_KeyAttributes.html
  key_attributes {

    # key_algorithm (Required)
    # 設定内容: キー作成時に使用するキーアルゴリズムを指定します。
    # 設定可能な値:
    #   対称キー:
    #   - "TDES_2KEY": Triple DES 2キー（112ビット）
    #   - "TDES_3KEY": Triple DES 3キー（168ビット）
    #   - "AES_128": AES 128ビット
    #   - "AES_192": AES 192ビット
    #   - "AES_256": AES 256ビット
    #   非対称キー:
    #   - "RSA_2048": RSA 2048ビット
    #   - "RSA_3072": RSA 3072ビット
    #   - "RSA_4096": RSA 4096ビット
    #   - "ECC_NIST_P256": ECC NIST P-256
    #   - "ECC_NIST_P384": ECC NIST P-384
    #   - "ECC_NIST_P521": ECC NIST P-521
    # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_KeyAttributes.html
    key_algorithm = "TDES_3KEY"

    # key_class (Required)
    # 設定内容: 作成するAWS Payment Cryptographyキーの種類を指定します。
    # 設定可能な値:
    #   - "SYMMETRIC_KEY": 対称キー。暗号化・復号化・MACに使用
    #   - "ASYMMETRIC_KEY_PAIR": 非対称キーペア。署名・検証・キー交換に使用
    #   - "PRIVATE_KEY": 非対称キーペアの秘密鍵
    #   - "PUBLIC_KEY": 非対称キーペアの公開鍵
    # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_KeyAttributes.html
    key_class = "SYMMETRIC_KEY"

    # key_usage (Required)
    # 設定内容: TR-31規格のA.5.2セクションで定義されたキーの暗号化用途を指定します。
    # 設定可能な値（主要なもの）:
    #   - "TR31_P0_PIN_ENCRYPTION_KEY": PINの暗号化キー
    #   - "TR31_B0_BASE_DERIVATION_KEY": ベース派生キー
    #   - "TR31_C0_CARD_VERIFICATION_KEY": カード検証キー
    #   - "TR31_D0_SYMMETRIC_DATA_ENCRYPTION_KEY": 対称データ暗号化キー
    #   - "TR31_E0_EMV_MKEY_APP_CRYPTOGRAMS": EMVマスターキー（アプリケーション暗号）
    #   - "TR31_K0_KEY_ENCRYPTION_KEY": キー暗号化キー（KEK）
    #   - "TR31_M1_ISO_9797_1_MAC_KEY": ISO 9797-1 MACキー
    #   - "TR31_M3_ISO_9797_3_MAC_KEY": ISO 9797-3 MACキー
    #   - "TR31_V1_IBM3624_PIN_VERIFICATION_KEY": IBM 3624 PIN検証キー
    #   - "TR31_V2_VISA_PIN_VERIFICATION_KEY": VISA PIN検証キー
    # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_KeyAttributes.html
    key_usage = "TR31_P0_PIN_ENCRYPTION_KEY"

    #-----------------------------------------------------------
    # キー使用モード設定
    #-----------------------------------------------------------

    # key_modes_of_use (Optional)
    # 設定内容: キーが許可される暗号化操作の種類を定義するブロックです。
    # 注意: key_usageとkey_classの組み合わせによって有効な使用モードが決まります
    # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_KeyModesOfUse.html
    key_modes_of_use {

      # decrypt (Optional)
      # 設定内容: このキーを使用してデータを復号化できるかを指定します。
      # 設定可能な値:
      #   - true: 復号化操作を許可
      #   - false: 復号化操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      decrypt = true

      # derive_key (Optional)
      # 設定内容: このキーを使用して新しいキーを派生させられるかを指定します。
      # 設定可能な値:
      #   - true: キー派生操作を許可
      #   - false: キー派生操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      derive_key = false

      # encrypt (Optional)
      # 設定内容: このキーを使用してデータを暗号化できるかを指定します。
      # 設定可能な値:
      #   - true: 暗号化操作を許可
      #   - false: 暗号化操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      encrypt = true

      # generate (Optional)
      # 設定内容: このキーを使用してカードおよびPIN検証キーを生成・検証できるかを指定します。
      # 設定可能な値:
      #   - true: 生成・検証操作を許可
      #   - false: 生成・検証操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      generate = false

      # no_restrictions (Optional)
      # 設定内容: key_usageによって暗黙的に定義される制限以外に特別な制限がないかを指定します。
      # 設定可能な値:
      #   - true: 追加制限なし。key_usageで定義された範囲内で全操作が許可
      #   - false: 個別の使用モードフラグによって操作を制限
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      no_restrictions = false

      # sign (Optional)
      # 設定内容: このキーを使用して署名を作成できるかを指定します。
      # 設定可能な値:
      #   - true: 署名操作を許可
      #   - false: 署名操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      sign = false

      # unwrap (Optional)
      # 設定内容: このキーを使用して他のキーのラップを解除できるかを指定します。
      # 設定可能な値:
      #   - true: キーアンラップ操作を許可。KEKとしてキーの受け取りに使用
      #   - false: キーアンラップ操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      unwrap = true

      # verify (Optional)
      # 設定内容: このキーを使用して署名を検証できるかを指定します。
      # 設定可能な値:
      #   - true: 署名検証操作を許可
      #   - false: 署名検証操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      verify = false

      # wrap (Optional)
      # 設定内容: このキーを使用して他のキーをラップできるかを指定します。
      # 設定可能な値:
      #   - true: キーラップ操作を許可。KEKとしてキーの送信に使用
      #   - false: キーラップ操作を禁止
      # 省略時: キーの種類とkey_usageに基づくデフォルト値が適用されます
      wrap = true
    }
  }

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" など、数値と単位サフィックス（s/m/h）で構成される文字列
    # 省略時: プロバイダーのデフォルト値を使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" など、数値と単位サフィックス（s/m/h）で構成される文字列
    # 省略時: プロバイダーのデフォルト値を使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" など、数値と単位サフィックス（s/m/h）で構成される文字列
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-manage.html
  tags = {
    Name        = "example-payment-crypto-key"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: キーのAmazon Resource Name (ARN)
# - key_check_value: キーチェック値（KCV）。全パーティが同一のキーを保持しているか
#                    確認するため、またはキーの変更を検出するために使用されます
# - key_origin: キーマテリアルのソース（AWS_PAYMENTCRYPTOGRAPHYまたはEXTERNAL）
# - key_state: キーの現在の状態（CREATE_COMPLETE, DELETE_SCHEDULED等）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
