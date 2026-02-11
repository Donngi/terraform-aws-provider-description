#---------------------------------------------------------------
# AWS Payment Cryptography Key
#---------------------------------------------------------------
#
# AWS Payment Cryptography Control Planeの暗号鍵をプロビジョニングするリソースです。
# Payment Cryptographyは、PCI準拠の決済処理用暗号機能とキー管理を提供する
# マネージドサービスです。専用のHSMインスタンスを必要とせず、
# PCI PIN / PCI P2PE / PCI DSS規則に準拠した暗号操作が可能です。
#
# AWS公式ドキュメント:
#   - Payment Cryptography概要: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/what-is.html
#   - キーの管理: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-manage.html
#   - キー属性の理解: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-validattributes.html
#   - CreateKey API: https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_CreateKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/paymentcryptography_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
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
  #   - true: キーをエクスポート可能にする。TR-31/TR-34等の鍵交換方式で外部共有が可能
  #   - false: キーをエクスポート不可にする。サービス内でのみ使用可能
  # 関連機能: AWS Payment Cryptography キーのエクスポート
  #   エクスポート可能なキーは、ANSI X9 TR-31やTR-34などの標準鍵交換方式を
  #   使用してサービスパートナーと安全に共有できます。
  #   - https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-importexport.html
  exportable = true

  # enabled (Optional)
  # 設定内容: キーを有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): キーを有効化し、暗号操作に使用可能にする
  #   - false: キーを作成するが、暗号操作には使用不可。後から有効化可能
  # 関連機能: AWS Payment Cryptography キーの有効化/無効化
  #   キーを一時的に使用停止する場合は、削除ではなく無効化を推奨。
  #   無効化されたキーは暗号操作に使用できませんが、後から再有効化できます。
  #   - https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-enable-disable.html
  enabled = true

  #-------------------------------------------------------------
  # キー属性設定
  #-------------------------------------------------------------

  # key_attributes (Required)
  # 設定内容: キーの役割、サポートするアルゴリズム、許可される暗号操作を定義します。
  # 注意: これらの属性はキー作成後に変更できません（イミュータブル）。
  # 関連機能: AWS Payment Cryptography キー属性
  #   キー属性はTR-31規格に基づいてキーブロックにバインドされ、
  #   適切なキースコーピングと操作制限を実現します。
  #   - https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-validattributes.html
  key_attributes {

    # key_algorithm (Required)
    # 設定内容: キー作成時に使用するアルゴリズムを指定します。
    # 設定可能な値:
    #   対称鍵アルゴリズム:
    #   - "TDES_2KEY": Triple DES 2キー
    #   - "TDES_3KEY": Triple DES 3キー
    #   - "AES_128": AES 128ビット
    #   - "AES_192": AES 192ビット
    #   - "AES_256": AES 256ビット
    #   非対称鍵アルゴリズム:
    #   - "RSA_2048": RSA 2048ビット
    #   - "RSA_3072": RSA 3072ビット
    #   - "RSA_4096": RSA 4096ビット
    #   楕円曲線アルゴリズム (ECDH用):
    #   - "ECC_NIST_P256": NIST P-256曲線
    #   - "ECC_NIST_P384": NIST P-384曲線
    #   - "ECC_NIST_P521": NIST P-521曲線
    # 注意: key_usageとの有効な組み合わせが決まっています。
    #   詳細は https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-validattributes.html を参照
    key_algorithm = "TDES_3KEY"

    # key_class (Required)
    # 設定内容: キーのタイプ（クラス）を指定します。
    # 設定可能な値:
    #   - "SYMMETRIC_KEY": 対称鍵。暗号化/復号に同一の鍵を使用
    #   - "ASYMMETRIC_KEY_PAIR": 非対称鍵ペア。公開鍵と秘密鍵のペア
    #   - "PUBLIC_KEY": 公開鍵。インポート時に使用
    # 注意: key_algorithmおよびkey_usageと整合性のある値を指定する必要があります。
    key_class = "SYMMETRIC_KEY"

    # key_usage (Required)
    # 設定内容: TR-31規格のセクションA.5.2に基づくキーの暗号用途を指定します。
    # 設定可能な値:
    #   対称鍵用途:
    #   - "TR31_B0_BASE_DERIVATION_KEY": 基本導出鍵
    #   - "TR31_C0_CARD_VERIFICATION_KEY": カード検証鍵 (CVV/CVV2)
    #   - "TR31_D0_SYMMETRIC_DATA_ENCRYPTION_KEY": 対称データ暗号化鍵
    #   - "TR31_E0_EMV_MKEY_APP_CRYPTOGRAMS": EMVマスター鍵（アプリケーション暗号文）
    #   - "TR31_E1_EMV_MKEY_CONFIDENTIALITY": EMVマスター鍵（機密性）
    #   - "TR31_E2_EMV_MKEY_INTEGRITY": EMVマスター鍵（完全性）
    #   - "TR31_E4_EMV_MKEY_DYNAMIC_NUMBERS": EMVマスター鍵（動的番号）
    #   - "TR31_E5_EMV_MKEY_CARD_PERSONALIZATION": EMVマスター鍵（カードパーソナライゼーション）
    #   - "TR31_E6_EMV_MKEY_OTHER": EMVマスター鍵（その他）
    #   - "TR31_K0_KEY_ENCRYPTION_KEY": キー暗号化鍵（TR31_K1推奨）
    #   - "TR31_K1_KEY_BLOCK_PROTECTION_KEY": キーブロック保護鍵
    #   - "TR31_M1_ISO_9797_1_MAC_KEY": ISO 9797-1 MAC鍵
    #   - "TR31_M3_ISO_9797_3_MAC_KEY": ISO 9797-3 MAC鍵
    #   - "TR31_M6_ISO_9797_5_CMAC_KEY": ISO 9797-5 CMAC鍵
    #   - "TR31_M7_HMAC_KEY": HMAC鍵
    #   - "TR31_P0_PIN_ENCRYPTION_KEY": PIN暗号化鍵
    #   - "TR31_P1_PIN_GENERATION_KEY": PIN生成鍵
    #   - "TR31_V1_IBM3624_PIN_VERIFICATION_KEY": IBM 3624 PIN検証鍵
    #   - "TR31_V2_VISA_PIN_VERIFICATION_KEY": VISA PIN検証鍵
    #   非対称鍵用途:
    #   - "TR31_D1_ASYMMETRIC_KEY_FOR_DATA_ENCRYPTION": 非対称データ暗号化鍵
    #   - "TR31_K2_TR34_ASYMMETRIC_KEY": TR-34非対称鍵
    #   - "TR31_K3_ASYMMETRIC_KEY_FOR_KEY_AGREEMENT": ECDH鍵合意用非対称鍵
    #   - "TR31_S0_ASYMMETRIC_KEY_FOR_DIGITAL_SIGNATURE": デジタル署名用非対称鍵
    # 参考: https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-validattributes.html
    key_usage = "TR31_P0_PIN_ENCRYPTION_KEY"

    #-----------------------------------------------------------
    # キー使用モード設定
    #-----------------------------------------------------------

    # key_modes_of_use (Optional)
    # 設定内容: キーに許可される暗号操作モードを定義します。
    # 注意: key_usageによって指定可能な組み合わせが制限されます。
    #   有効な組み合わせは以下を参照:
    #   https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-validattributes.html
    key_modes_of_use {

      # decrypt (Optional)
      # 設定内容: キーをデータの復号に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      decrypt = true

      # derive_key (Optional)
      # 設定内容: キーを新しいキーの導出に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      # 用途: 基本導出鍵 (BDK) やEMVマスター鍵で使用
      derive_key = false

      # encrypt (Optional)
      # 設定内容: キーをデータの暗号化に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      encrypt = true

      # generate (Optional)
      # 設定内容: キーをカード検証値やPIN検証値の生成に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      # 用途: CVV/CVV2生成鍵やPIN検証鍵で使用
      generate = false

      # no_restrictions (Optional)
      # 設定内容: key_usageで暗示される制限以外の特別な制限を設けないかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      # 注意: trueに設定すると、key_usageで許可される全ての操作モードが有効になります。
      #   他の個別モード指定と併用しないでください。
      no_restrictions = false

      # sign (Optional)
      # 設定内容: キーを署名に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      # 用途: デジタル署名用非対称鍵で使用
      sign = false

      # unwrap (Optional)
      # 設定内容: キーを他のキーのアンラップ（復号）に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      # 用途: キー暗号化鍵 (KEK) やPIN暗号化鍵で使用
      unwrap = true

      # verify (Optional)
      # 設定内容: キーを署名の検証に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      # 用途: カード検証値やPIN検証値の検証に使用
      verify = false

      # wrap (Optional)
      # 設定内容: キーを他のキーのラップ（暗号化）に使用可能にするかを指定します。
      # 設定可能な値: true / false
      # 省略時: false
      # 用途: キー暗号化鍵 (KEK) やPIN暗号化鍵で使用
      wrap = true
    }
  }

  #-------------------------------------------------------------
  # キーチェック値設定
  #-------------------------------------------------------------

  # key_check_value_algorithm (Optional)
  # 設定内容: キーチェック値 (KCV) の計算に使用するアルゴリズムを指定します。
  # 設定可能な値:
  #   - "CMAC": CMAC方式。AESキーのKCV計算に使用（16バイトのゼロを入力し、上位3バイトを保持）
  #   - "ANSI_X9_24": ANSI X9.24方式。TDESキーのKCV計算に使用（8バイトのゼロを暗号化し、上位3バイトを保持）
  #   - "HMAC": HMAC方式
  #   - "SHA_1": SHA-1方式
  # 省略時: キーアルゴリズムに応じて適切なアルゴリズムが自動選択されます
  # 関連機能: キーチェック値 (KCV)
  #   KCVは、キーの整合性を検証するために使用されます。
  #   全当事者が同じキーを保持しているか、またはキーが変更されていないかを検出します。
  #   - https://docs.aws.amazon.com/payment-cryptography/latest/APIReference/API_CreateKey.html
  key_check_value_algorithm = "ANSI_X9_24"

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # deletion_window_in_days (Optional)
  # 設定内容: キー削除までの待機期間（日数）を指定します。
  # 設定可能な値: 3 - 180 (日)
  # 省略時: 7 (日)
  # 関連機能: AWS Payment Cryptography キーの削除
  #   キーの削除は不可逆です。待機期間中はキーの状態がDELETE_PENDINGとなり、
  #   暗号操作には使用できません。待機期間中であればrestore-keyで削除をキャンセルできます。
  #   - https://docs.aws.amazon.com/payment-cryptography/latest/userguide/keys-deleting.html
  deletion_window_in_days = 7

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大200個）
  # 関連機能: AWS Payment Cryptography キーのタグ付け
  #   タグを使用してキーの分類や管理が可能です。
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/payment-cryptography/latest/userguide/tagging-keys.html
  # 注意: 個人情報や機密情報をタグに含めないでください。
  #   タグはCloudTrailログ等で平文表示される可能性があります。
  tags = {
    Name        = "my-payment-key"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 設定可能な値: 数値と単位サフィックスの文字列（例: "30s", "5m", "1h"）
  #   有効な単位: "s"（秒）, "m"（分）, "h"（時間）
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: キーのAmazon Resource Name (ARN)
#
# - id: キーの識別子
#
# - key_check_value: キーチェック値 (KCV)。全当事者が同じキーを保持しているか、
#                     またはキーが変更されていないかを検出するために使用されます。
#
# - key_origin: キーマテリアルの生成元。
#               AWS_PAYMENT_CRYPTOGRAPHY（サービス内で生成）または
#               EXTERNAL（外部からインポート）等の値をとります。
#
# - key_state: キーの状態。CREATE_COMPLETE（使用可能）、
#              DELETE_PENDING（削除待ち）等の値をとります。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
