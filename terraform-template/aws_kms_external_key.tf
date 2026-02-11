#---------------------------------------------------------------
# AWS KMS External Key
#---------------------------------------------------------------
#
# 外部キーマテリアルを使用するKMSキーをプロビジョニングするリソースです。
# 通常のKMSキー（aws_kms_key）ではAWSがキーマテリアルを自動生成しますが、
# このリソースではユーザーが独自のキーマテリアルを外部で生成し、
# AWS KMSにインポートして使用します。
# シングルリージョンキーおよびマルチリージョンプライマリキーに対応しています。
#
# AWS公式ドキュメント:
#   - KMSキーマテリアルのインポート: https://docs.aws.amazon.com/kms/latest/developerguide/importing-keys-conceptual.html
#   - ImportKeyMaterial API: https://docs.aws.amazon.com/kms/latest/APIReference/API_ImportKeyMaterial.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_external_key
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
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
  # 設定可能な値: 任意の文字列（最大8192文字）
  # 省略時: 説明なし
  # 用途: キーの目的や用途を記録し、管理を容易にするために使用します。
  description = "KMS external key for importing custom key material"

  # enabled (Optional)
  # 設定内容: KMSキーの有効/無効状態を指定します。
  # 設定可能な値:
  #   - true: キーを有効化（暗号化操作に使用可能）
  #   - false: キーを無効化（暗号化操作に使用不可）
  # 省略時: キーマテリアルインポート済みの場合はtrue（有効期限切れでない場合）
  # 注意: キーマテリアルのインポート待ち（PendingImport状態）のキーはfalseのみ設定可能
  enabled = true

  #-------------------------------------------------------------
  # キー仕様設定
  #-------------------------------------------------------------

  # key_spec (Optional)
  # 設定内容: キーの種類（対称キーか非対称キーペアか）と、
  #           サポートする暗号化アルゴリズムまたは署名アルゴリズムを指定します。
  # 設定可能な値:
  #   - "SYMMETRIC_DEFAULT" (デフォルト): 対称暗号化キー（256ビット）
  #   - "RSA_2048": RSA 2048ビット非対称キー
  #   - "RSA_3072": RSA 3072ビット非対称キー
  #   - "RSA_4096": RSA 4096ビット非対称キー
  #   - "HMAC_224": HMAC 224ビットキー
  #   - "HMAC_256": HMAC 256ビットキー
  #   - "HMAC_384": HMAC 384ビットキー
  #   - "HMAC_512": HMAC 512ビットキー
  #   - "ECC_NIST_P256": NIST P-256楕円曲線キー
  #   - "ECC_NIST_P384": NIST P-384楕円曲線キー
  #   - "ECC_NIST_P521": NIST P-521楕円曲線キー
  #   - "ECC_SECG_P256K1": secp256k1楕円曲線キー
  #   - "ML_DSA_44": ML-DSA-44ポスト量子署名キー
  #   - "ML_DSA_65": ML-DSA-65ポスト量子署名キー
  #   - "ML_DSA_87": ML-DSA-87ポスト量子署名キー
  #   - "SM2": SM2非対称キー（中国リージョンのみ）
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/symm-asymm-choose.html
  # 注意: インポートするキーマテリアルはこのkey_specと互換性がある必要があります。
  key_spec = "SYMMETRIC_DEFAULT"

  # key_usage (Optional)
  # 設定内容: キーの用途を指定します。
  # 設定可能な値:
  #   - "ENCRYPT_DECRYPT" (デフォルト): 暗号化および復号に使用
  #   - "SIGN_VERIFY": デジタル署名の生成および検証に使用
  #   - "GENERATE_VERIFY_MAC": MACの生成および検証に使用
  # 省略時: "ENCRYPT_DECRYPT"
  # 注意: key_specとの組み合わせに制約があります。
  #       SYMMETRIC_DEFAULTはENCRYPT_DECRYPTのみ使用可能。
  #       RSA/ECCキーはSIGN_VERIFYまたはENCRYPT_DECRYPTを使用可能。
  #       HMACキーはGENERATE_VERIFY_MACのみ使用可能。
  key_usage = "ENCRYPT_DECRYPT"

  #-------------------------------------------------------------
  # キーマテリアル設定
  #-------------------------------------------------------------

  # key_material_base64 (Optional, Sensitive)
  # 設定内容: インポートするキーマテリアルをBase64エンコードした値を指定します。
  # 設定可能な値: Base64エンコードされたキーマテリアル
  # 省略時: キーマテリアルはインポートされず、キーはPendingImport状態になります。
  # 関連機能: KMSキーマテリアルインポート
  #   ユーザーが外部で生成したキーマテリアルをAWS KMSにインポートする機能です。
  #   対称暗号化キーの場合、256ビット（32バイト）のバイナリデータが必要です。
  #   同じキーマテリアルの再インポートは可能ですが、異なるキーマテリアルのインポートはできません。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/importing-keys-conceptual.html
  # 注意: この値はTerraform stateにプレーンテキストで保存されます。
  #       機密データの管理に注意してください。
  #       - https://www.terraform.io/docs/state/sensitive-data.html
  key_material_base64 = null

  # valid_to (Optional)
  # 設定内容: インポートしたキーマテリアルの有効期限を指定します。
  # 設定可能な値: RFC3339形式の日時文字列（例: "2025-12-31T23:59:59Z"）
  # 省略時: キーマテリアルは期限切れになりません（無期限）
  # 関連機能: キーマテリアルの有効期限
  #   有効期限が設定されている場合、期限到達時にAWS KMSがキーマテリアルを自動削除し、
  #   KMSキーは使用不可になります。引き続きキーを使用するには、
  #   同じキーマテリアルを再インポートする必要があります。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/importing-keys-conceptual.html
  valid_to = null

  #-------------------------------------------------------------
  # マルチリージョン設定
  #-------------------------------------------------------------

  # multi_region (Optional)
  # 設定内容: KMSキーがマルチリージョンキーかリージョンキーかを指定します。
  # 設定可能な値:
  #   - true: マルチリージョンプライマリキーとして作成
  #   - false (デフォルト): シングルリージョンキーとして作成
  # 関連機能: AWS KMSマルチリージョンキー
  #   複数のAWSリージョンで使用できるKMSキーを作成します。
  #   プライマリキーを1つのリージョンに作成し、レプリカキーを他のリージョンに作成できます。
  #   各リージョンのキーは同じキーマテリアルとキーIDを共有します。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/multi-region-keys-overview.html
  multi_region = false

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
  # キーポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: KMSキーのキーポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 省略時: AWSがデフォルトのキーポリシーを適用します。
  # 関連機能: KMSキーポリシー
  #   キーポリシーはKMSキーへのアクセスを制御する主要な方法です。
  #   デフォルトのキーポリシーは、AWSアカウントのルートユーザーにキーへの
  #   完全なアクセス権を付与し、IAMポリシーによるアクセス制御を可能にします。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  # 注意: bypass_policy_lockout_safety_checkがfalse（デフォルト）の場合、
  #       キーポリシーにはAPI呼び出し元のプリンシパルへのアクセス許可が含まれている
  #       必要があります。
  policy = null

  # bypass_policy_lockout_safety_check (Optional)
  # 設定内容: キーポリシーのロックアウト安全チェックを無効化するかを指定します。
  # 設定可能な値:
  #   - true: 安全チェックを無効化（キーが管理不能になるリスクが増加）
  #   - false (デフォルト): 安全チェックを有効化
  # 省略時: false
  # 関連機能: KMSキーポリシーのロックアウト防止
  #   デフォルトでは、キーポリシーの作成・更新時にAWS KMSが安全チェックを実行し、
  #   API呼び出し元がキーポリシーで自身へのアクセスを誤って削除することを防止します。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam
  # 注意: trueに設定すると、キーが管理不能になるリスクがあります。
  #       通常はfalseのまま使用することを推奨します。
  bypass_policy_lockout_safety_check = false

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # deletion_window_in_days (Optional)
  # 設定内容: リソース削除後、キーが完全に削除されるまでの待機日数を指定します。
  # 設定可能な値: 7〜30（日）の整数
  # 省略時: 30日
  # 関連機能: KMSキーの削除スケジュール
  #   KMSキーの削除は即座には行われず、指定した待機期間後に実行されます。
  #   待機期間中はキーの削除をキャンセルできます。
  #   これにより、誤ってキーを削除した場合のリカバリが可能です。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/deleting-keys.html
  deletion_window_in_days = 30

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/tagging-keys.html
  tags = {
    Name        = "my-external-kms-key"
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
#                     キーマテリアルインポート待ちの場合は空文字列。
#                     インポート済みの場合は "KEY_MATERIAL_EXPIRES" または
#                     "KEY_MATERIAL_DOES_NOT_EXPIRE" のいずれか。
#
# - id: KMSキーの一意識別子（キーID）
#
# - key_state: KMSキーの状態。
#              例: "Enabled", "Disabled", "PendingImport", "PendingDeletion" 等
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
