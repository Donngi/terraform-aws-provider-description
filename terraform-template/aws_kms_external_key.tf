#---------------------------------------------------------------
# AWS KMS External Key (外部キーマテリアル使用KMSキー)
#---------------------------------------------------------------
#
# 外部キーマテリアルを使用するAWS KMSキー（BYOK: Bring Your Own Key）を
# プロビジョニングするリソースです。AWSが自動生成するキーマテリアルではなく、
# 外部で生成したキーマテリアルをインポートして使用します。
# 単一リージョンおよびマルチリージョンのプライマリKMSキーをサポートします。
#
# AWS公式ドキュメント:
#   - 外部キーマテリアルのインポート: https://docs.aws.amazon.com/kms/latest/developerguide/importing-keys-conceptual.html
#   - KMSキーのインポート手順: https://docs.aws.amazon.com/kms/latest/developerguide/importing-keys.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_external_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_kms_external_key" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: KMSキーの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "KMS external key for encryption"

  #-------------------------------------------------------------
  # キーマテリアル設定
  #-------------------------------------------------------------

  # key_material_base64 (Optional)
  # 設定内容: インポートする256ビット対称暗号化キーマテリアルをBase64エンコードした値を指定します。
  #           CMKはこのキーマテリアルと永続的に関連付けられます。
  #           同じキーマテリアルを再インポートすることは可能ですが、異なるキーマテリアルはインポートできません。
  # 設定可能な値: Base64エンコードされた256ビット対称暗号化キーマテリアル文字列
  # 省略時: キーマテリアルなし（PendingImport状態）
  # 注意: このフィールドはsensitiveとしてマークされており、stateファイルに平文で保存されます。
  #       ステートファイルの管理には十分注意してください。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/importing-keys-conceptual.html
  key_material_base64 = null

  # valid_to (Optional)
  # 設定内容: インポートしたキーマテリアルの有効期限を指定します。
  #           有効期限が切れると、AWSはキーマテリアルを削除し、CMKが使用不可になります。
  # 設定可能な値: RFC3339形式の時刻文字列（例: "2026-12-31T00:00:00Z"）
  # 省略時: キーマテリアルは期限なし（無期限）
  # 注意: key_material_base64と合わせて使用する場合に有効。
  #       期限切れ後はキーマテリアルを再インポートすることで復旧可能。
  # 参考: https://docs.aws.amazon.com/kms/latest/APIReference/API_ImportKeyMaterial.html
  valid_to = null

  #-------------------------------------------------------------
  # キー仕様・用途設定
  #-------------------------------------------------------------

  # key_spec (Optional)
  # 設定内容: キーに含まれるキーの種類（対称または非対称）と、サポートする暗号化アルゴリズムまたは
  #           署名アルゴリズムを指定します。
  # 設定可能な値:
  #   - "SYMMETRIC_DEFAULT": 対称暗号化キー（デフォルト）
  #   - "RSA_2048": RSA 2048ビット
  #   - "RSA_3072": RSA 3072ビット
  #   - "RSA_4096": RSA 4096ビット
  #   - "HMAC_224": HMAC SHA-224
  #   - "HMAC_256": HMAC SHA-256
  #   - "HMAC_384": HMAC SHA-384
  #   - "HMAC_512": HMAC SHA-512
  #   - "ECC_NIST_P256": 楕円曲線 P-256
  #   - "ECC_NIST_P384": 楕円曲線 P-384
  #   - "ECC_NIST_P521": 楕円曲線 P-521
  #   - "ECC_SECG_P256K1": 楕円曲線 secp256k1
  #   - "ML_DSA_44": ML-DSA-44（ポスト量子署名）
  #   - "ML_DSA_65": ML-DSA-65（ポスト量子署名）
  #   - "ML_DSA_87": ML-DSA-87（ポスト量子署名）
  #   - "SM2": SM2（中国リージョンのみ）
  # 省略時: "SYMMETRIC_DEFAULT"
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/symm-asymm-choose.html
  key_spec = "SYMMETRIC_DEFAULT"

  # key_usage (Optional)
  # 設定内容: キーの用途（意図する使用目的）を指定します。
  # 設定可能な値:
  #   - "ENCRYPT_DECRYPT": データの暗号化・復号（デフォルト）
  #   - "SIGN_VERIFY": デジタル署名の生成・検証（非対称キーのみ）
  #   - "GENERATE_VERIFY_MAC": MACの生成・検証（HMACキーのみ）
  # 省略時: "ENCRYPT_DECRYPT"
  key_usage = "ENCRYPT_DECRYPT"

  #-------------------------------------------------------------
  # キー状態設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: キーが有効かどうかを指定します。
  # 設定可能な値:
  #   - true: キーを有効化（インポート済みキーのデフォルト）
  #   - false: キーを無効化（キーマテリアルのインポート待ち状態では false のみ指定可）
  # 省略時: インポート済みキーの場合 true、期限切れでない限り
  # 注意: キーマテリアルのインポート前（PendingImport状態）は false のみ有効
  enabled = true

  #-------------------------------------------------------------
  # マルチリージョン設定
  #-------------------------------------------------------------

  # multi_region (Optional)
  # 設定内容: KMSキーをマルチリージョンキーとして設定するかを指定します。
  #           マルチリージョンキーは、複数リージョンにわたって同じキーマテリアルを
  #           複製でき、リージョン間の暗号化・復号が可能です。
  # 設定可能な値:
  #   - true: マルチリージョンプライマリキーとして作成
  #   - false: 単一リージョンキーとして作成（デフォルト）
  # 省略時: false
  # 注意: このパラメータはリソース作成後に変更できません（Forces new resource）。
  multi_region = false

  #-------------------------------------------------------------
  # キーポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: キーポリシーをJSON形式で指定します。
  #           指定しない場合、AWSはデフォルトのキーポリシーをCMKにアタッチします。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 省略時: AWSがデフォルトキーポリシーを適用
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  policy = null

  # bypass_policy_lockout_safety_check (Optional)
  # 設定内容: キーポリシーの作成・更新時に実行されるポリシーロックアウトチェックを
  #           無効化するかを指定します。
  # 設定可能な値:
  #   - true: ポリシーロックアウトチェックを無効化（推奨しない）
  #   - false: ポリシーロックアウトチェックを有効化（デフォルト）
  # 省略時: false
  # 注意: trueに設定するとキーが管理不能になるリスクが高まります。
  #       デフォルトキーポリシーの詳細については公式ドキュメントを参照してください。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam
  bypass_policy_lockout_safety_check = false

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # deletion_window_in_days (Optional)
  # 設定内容: リソース破棄後にキーが削除されるまでの待機日数を指定します。
  #           この期間中はキーの削除をキャンセルできます。
  # 設定可能な値: 7〜30の整数
  # 省略時: 30日
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/deleting-keys.html
  deletion_window_in_days = 30

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定で定義されたタグと
  #       キーが一致する場合、プロバイダーレベルのタグを上書きします。
  tags = {
    Name        = "example-external-key"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: KMSキーのAmazon Resource Name (ARN)
#
# - expiration_model: キーマテリアルの有効期限モデル。
#                    キーマテリアルインポート待ち中は空文字列。
#                    インポート後は "KEY_MATERIAL_EXPIRES" または "KEY_MATERIAL_DOES_NOT_EXPIRE"。
#
# - key_state: CMKの現在の状態。
#              例: "Enabled", "Disabled", "PendingImport", "PendingDeletion" 等。
#
# - id: KMSキーの一意の識別子（キーID）。
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
