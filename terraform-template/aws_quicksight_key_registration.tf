#---------------------------------------------------------------
# Amazon QuickSight KMSキー登録
#---------------------------------------------------------------
#
# Amazon QuickSightアカウントにカスタマーマネージドキー（CMK）を登録する
# リソースです。QuickSightのデータ暗号化にAWS KMSのCMKを使用することで、
# 暗号化キーの完全な制御が可能になります。
#
# 注意: このリソースを削除すると、QuickSightアカウントのすべてのCMK登録が
#       クリアされます。QuickSightはその後、AWSマネージドキーを使用して
#       リソースを暗号化します。
#
# AWS公式ドキュメント:
#   - QuickSightでのCMK操作: https://docs.aws.amazon.com/quicksight/latest/developerguide/cmk-operations.html
#   - RegisteredCustomerManagedKey APIリファレンス: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RegisteredCustomerManagedKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_key_registration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_key_registration" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: CMKを登録するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: TerraformのAWSプロバイダーが自動的に決定するアカウントIDを使用します。
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # KMSキー登録設定
  #-------------------------------------------------------------

  # key_registration (Required)
  # 設定内容: QuickSightアカウントに登録するAWS KMSキーを指定します。
  #           複数のキーを登録可能ですが、デフォルトキーは1つのみ設定できます。
  #           このブロックは1つ以上指定する必要があります。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/developerguide/cmk-operations.html
  key_registration {
    # key_arn (Required)
    # 設定内容: 暗号化・復号化に使用するAWS KMSキーのARNを指定します。
    # 設定可能な値: 有効なAWS KMSキーのARN
    # 注意: 非対称KMSキーはサポートされていません。対称CMKを使用してください。
    key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # default_key (Optional)
    # 設定内容: このキーをデフォルトの暗号化・復号化キーとして設定するかを指定します。
    # 設定可能な値:
    #   - true: デフォルトキーとして設定。新しいQuickSightデータの暗号化に使用されます。
    #   - false: デフォルトキーとして設定しません。
    # 省略時: AWSがデフォルト値を決定します。
    # 注意: デフォルトキーは1つのAWSアカウント・リージョンにつき1つのみ設定可能です。
    default_key = true
  }

  # 追加キーの登録例（複数キーを登録する場合）:
  # key_registration {
  #   key_arn     = "arn:aws:kms:ap-northeast-1:123456789012:key/87654321-4321-4321-4321-210987654321"
  #   default_key = false
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのID（AWSアカウントIDと同一）
#---------------------------------------------------------------
