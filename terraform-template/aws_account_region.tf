#---------------------------------------------------------------
# AWS Account Region
#---------------------------------------------------------------
#
# AWS アカウントで特定のリージョンを有効化（オプトイン）または無効化（オプトアウト）するリソースです。
# デフォルトで有効なリージョンと異なり、オプトインリージョンは手動で有効化する必要があります。
# リージョンを有効化すると、そのリージョンでAWSサービスを利用できるようになり、
# 無効化するとIAMクレデンシャルがそのリージョンで使用できなくなります。
#
# AWS公式ドキュメント:
#   - Enable or disable AWS Regions: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-regions.html
#   - AWS Regions: https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html
#   - GetRegionOptStatus API: https://docs.aws.amazon.com/accounts/latest/reference/API_GetRegionOptStatus.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_region
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_account_region" "example" {
  #-------------------------------------------------------------
  # リージョン設定 (必須)
  #-------------------------------------------------------------

  # region_name (Required)
  # 設定内容: 管理対象のリージョン名を指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-southeast-3, ap-east-1, me-south-1）
  # 注意: デフォルトで有効化されているリージョンは管理できません。
  #       2019年3月20日以降に追加されたオプトインリージョンが対象です。
  # 参考: https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html
  region_name = "ap-southeast-3"

  # enabled (Required)
  # 設定内容: リージョンを有効化するか無効化するかを指定します。
  # 設定可能な値:
  #   - true: リージョンを有効化（オプトイン）。IAMデータと認証情報がそのリージョンに伝播されます。
  #   - false: リージョンを無効化（オプトアウト）。IAM認証情報が無効化されますが、
  #            リソースは削除されず、課金も継続します。
  # 関連機能: AWS Region Opt-In/Opt-Out
  #   リージョンの有効化には数分から数時間かかる場合があります。
  #   リージョンを無効化してもリソースは削除されないため、
  #   事前にリソースを削除することが推奨されます。
  #   - https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-regions.html
  enabled = true

  #-------------------------------------------------------------
  # アカウント設定 (オプション)
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: メンバーアカウントを管理する際のターゲットアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のユーザーのアカウントを管理します（デフォルト）
  # 注意: このパラメータを使用するには、呼び出し元が組織の管理アカウントまたは
  #       委任管理者アカウントのアイデンティティである必要があります。
  #       指定されたアカウントIDも同じ組織のメンバーアカウントである必要があります。
  #       組織ではすべての機能が有効化されており、Account Managementサービスへの
  #       信頼されたアクセスが有効化されている必要があります。
  # 参考: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-regions.html
  account_id = null

  #-------------------------------------------------------------
  # タイムアウト設定 (オプション)
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h", "2h30m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    # 注意: リージョンの有効化には時間がかかる場合があるため、
    #       必要に応じて長めのタイムアウトを設定してください。
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h", "2h30m"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    # 注意: リージョンの有効化/無効化の切り替えには時間がかかる場合があります。
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースID（account_id:region_name の形式）
#
# - opt_status: リージョンのオプトイン状態
#   取り得る値:
#     - ENABLED: 有効化済み
#     - ENABLING: 有効化処理中
#     - DISABLING: 無効化処理中
#     - DISABLED: 無効化済み
#     - ENABLED_BY_DEFAULT: デフォルトで有効化されているリージョン
#   参考: https://docs.aws.amazon.com/accounts/latest/reference/API_GetRegionOptStatus.html
#---------------------------------------------------------------
