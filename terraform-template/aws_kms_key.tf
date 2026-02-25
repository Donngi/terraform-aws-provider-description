#---------------------------------------------------------------
# AWS KMS Key
#---------------------------------------------------------------
#
# AWS Key Management Service (KMS) のカスタマー管理キー (CMK) を
# プロビジョニングするリソースです。
# 単一リージョンまたはマルチリージョンのプライマリKMSキーを管理します。
# 対称暗号化キー、非対称キーペア、HMACキーをサポートします。
#
# AWS公式ドキュメント:
#   - AWS KMS キーの概念: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html
#   - KMS キーの作成: https://docs.aws.amazon.com/kms/latest/developerguide/create-keys.html
#   - キーのローテーション: https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: AWSコンソールで表示されるキーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしで作成されます。
  description = "An example symmetric encryption KMS key"

  # key_usage (Optional)
  # 設定内容: キーの用途（暗号化アルゴリズムまたは署名アルゴリズム）を指定します。
  # 設定可能な値:
  #   - "ENCRYPT_DECRYPT" (デフォルト): 対称暗号化および復号に使用
  #   - "SIGN_VERIFY": デジタル署名の作成と検証に使用（非対称キー）
  #   - "GENERATE_VERIFY_MAC": HMAC の生成と検証に使用（HMACキー）
  # 注意: 作成後は変更できません（Forces new resource）
  key_usage = "ENCRYPT_DECRYPT"

  # customer_master_key_spec (Optional)
  # 設定内容: キーが対称キーか非対称キーペアか、サポートする暗号化・署名アルゴリズムを指定します。
  # 設定可能な値:
  #   - "SYMMETRIC_DEFAULT" (デフォルト): AES-256-GCM 対称暗号化キー
  #   - "RSA_2048", "RSA_3072", "RSA_4096": RSA 非対称キーペア
  #   - "ECC_NIST_P256", "ECC_NIST_P384", "ECC_NIST_P521": NIST 推奨楕円曲線キー
  #   - "ECC_SECG_P256K1": secp256k1 楕円曲線キー（暗号通貨用途）
  #   - "ECC_NIST_EDWARDS25519": Edwards 曲線キー
  #   - "HMAC_224", "HMAC_256", "HMAC_384", "HMAC_512": HMAC キー
  #   - "ML_DSA_44", "ML_DSA_65", "ML_DSA_87": 耐量子暗号 ML-DSA キー
  #   - "SM2": 中国リージョンのみ利用可能
  # 注意: 作成後は変更できません（Forces new resource）
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/symm-asymm-choose.html
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  #-------------------------------------------------------------
  # キーポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: キーポリシーを JSON 形式で指定します。
  # 設定可能な値: 有効なキーポリシー JSON ドキュメント
  # 省略時: AWS がデフォルトキーポリシーを適用します。デフォルトポリシーでは、
  #         所有アカウントの全プリンシパルにキーへの無制限アクセスが付与されます。
  # 注意: aws_kms_key_policy リソースと併用すると設定が競合するため、
  #       どちらか一方のみを使用してください。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  policy = null

  # bypass_policy_lockout_safety_check (Optional)
  # 設定内容: キーポリシーのロックアウト安全チェックをバイパスするかを指定します。
  # 設定可能な値:
  #   - true: 安全チェックをバイパス。KMSキーが管理不能になるリスクが高まります
  #   - false (デフォルト): 安全チェックを実施
  # 注意: true に設定すると KMS キーが管理不能になるリスクが高まります。
  #       安易に true を設定しないでください。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam
  bypass_policy_lockout_safety_check = false

  #-------------------------------------------------------------
  # キーローテーション設定
  #-------------------------------------------------------------

  # enable_key_rotation (Optional)
  # 設定内容: キーの自動ローテーションを有効にするかを指定します。
  # 設定可能な値:
  #   - true: キーローテーションを有効化
  #   - false (デフォルト): キーローテーションを無効化
  # 注意: rotation_period_in_days を指定する場合は true にする必要があります。
  #       非対称キーおよび HMAC キーはローテーションをサポートしません。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html
  enable_key_rotation = true

  # rotation_period_in_days (Optional)
  # 設定内容: キーローテーションの間隔を日数で指定します。
  # 設定可能な値: 90〜2560 の整数（日数）
  # 省略時: AWS KMS のデフォルト値（365日）が使用されます。
  # 注意: enable_key_rotation = true の場合のみ有効です。
  rotation_period_in_days = 365

  #-------------------------------------------------------------
  # キー有効化設定
  #-------------------------------------------------------------

  # is_enabled (Optional)
  # 設定内容: キーを有効または無効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): キーを有効化。暗号化・復号操作が可能な状態
  #   - false: キーを無効化。暗号化・復号操作が拒否されます
  # 注意: キーを無効化しても、既に暗号化されたデータは削除されません。
  #       キーの再有効化で復号が可能になります。
  is_enabled = true

  #-------------------------------------------------------------
  # キー削除設定
  #-------------------------------------------------------------

  # deletion_window_in_days (Optional)
  # 設定内容: キーを削除するまでの待機日数を指定します。
  # 設定可能な値: 7〜30 の整数（日数）
  # 省略時: 30日が適用されます。
  # 注意: 待機期間中はキーの削除をキャンセルできます。
  #       マルチリージョンプライマリキーの場合、全レプリカキー削除後に
  #       待機期間がカウントされます。
  deletion_window_in_days = 30

  #-------------------------------------------------------------
  # マルチリージョン設定
  #-------------------------------------------------------------

  # multi_region (Optional)
  # 設定内容: マルチリージョンプライマリキーとして作成するかを指定します。
  # 設定可能な値:
  #   - true: マルチリージョンプライマリキーとして作成
  #   - false (デフォルト): 単一リージョンキーとして作成
  # 注意: 作成後は変更できません（Forces new resource）
  #       マルチリージョンキーは aws_kms_replica_key リソースで他リージョンに複製できます。
  multi_region = false

  #-------------------------------------------------------------
  # カスタムキーストア設定
  #-------------------------------------------------------------

  # custom_key_store_id (Optional)
  # 設定内容: キーを保存するカスタムキーストアの ID を指定します。
  # 設定可能な値: 有効なカスタムキーストア ID（CloudHSM クラスターや外部キーストア）
  # 省略時: 標準の AWS KMS キーストアに保存されます。
  # 注意: 作成後は変更できません（Forces new resource）
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/create-cmk-keystore.html
  custom_key_store_id = null

  # xks_key_id (Optional)
  # 設定内容: 外部キーストア内の KMS キーのキーマテリアルとなる外部キーの ID を指定します。
  # 設定可能な値: 外部キーストアプロキシが認識できる外部キーの識別子
  # 省略時: KMS が自動的にキーマテリアルを生成します。
  # 注意: custom_key_store_id で外部キーストアを指定した場合のみ使用可能です。
  xks_key_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしで作成されます。
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-kms-key"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30m", "1h" 等の期間文字列
    # 省略時: プロバイダーのデフォルトタイムアウトが適用されます。
    create = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: KMS キーの Amazon Resource Name (ARN)
# - key_id: キーのグローバル一意識別子
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む、
#             リソースに割り当てられた全タグのマップ
#---------------------------------------------------------------
