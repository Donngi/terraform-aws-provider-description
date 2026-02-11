#---------------------------------------------------------------
# AWS QuickSight Key Registration
#---------------------------------------------------------------
#
# Amazon QuickSightアカウントにカスタマーマネージドキー（CMK）を登録する
# リソースです。CMKを登録することで、QuickSightのリソースをAWS KMSの
# カスタマーマネージドキーで暗号化できるようになります。
#
# AWS公式ドキュメント:
#   - QuickSightキー管理操作: https://docs.aws.amazon.com/quicksight/latest/developerguide/cmk-operations.html
#   - RegisteredCustomerManagedKey API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RegisteredCustomerManagedKey.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_key_registration
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_key_registration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: QuickSightアカウントに関連付けられたAWSアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: Terraform AWSプロバイダーが自動的に決定するアカウントIDを使用
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # キー登録設定
  #-------------------------------------------------------------

  # key_registration (Required)
  # 設定内容: QuickSightアカウントに登録するカスタマーマネージドキー（CMK）を指定します。
  # 複数のkey_registrationブロックを指定して、複数のCMKを登録できます。
  # 関連機能: QuickSightキー管理
  #   QuickSightアカウントにCMKを登録して、データの暗号化・復号化に使用します。
  #   IAMロールには kms:CreateGrant, quicksight:UpdateKeyRegistration,
  #   quicksight:DescribeKeyRegistration の権限が必要です。
  #   - https://docs.aws.amazon.com/quicksight/latest/developerguide/cmk-operations.html
  # 注意: このリソースを削除すると、QuickSightアカウントからすべてのCMK登録が
  #       クリアされ、QuickSightはAWS所有キーを使用してリソースを暗号化します。
  key_registration {
    # key_arn (Required)
    # 設定内容: 暗号化・復号化に使用するAWS KMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # default_key (Optional)
    # 設定内容: このキーをデフォルトの暗号化・復号化キーとして設定するかを指定します。
    # 設定可能な値:
    #   - true: デフォルトキーとして設定。暗号化・復号化操作でこのキーが優先的に使用されます
    #   - false: デフォルトキーとして設定しない
    # 省略時: false
    # 注意: 複数のkey_registrationブロックを指定する場合、
    #       デフォルトキーは1つのみ設定できます。
    default_key = true
  }

  # 追加のキー登録（複数キーを登録する場合）
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
# - aws_account_id: QuickSightアカウントに関連付けられたAWSアカウントID
#
# - region: このリソースが管理されているAWSリージョン
#
# - key_registration[].default_key: 各キーがデフォルトキーとして設定されているか
#---------------------------------------------------------------
