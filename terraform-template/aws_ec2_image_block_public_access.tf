#---------------------------------------
# EC2 Image Block Public Access
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_image_block_public_access
#
# 説明: Amazon Machine Image (AMI) の公開共有をアカウントレベルで制御するリソース
# 　　　AMIの新規公開共有をブロックすることでセキュリティを強化します
# 　　　設定は指定されたリージョン単位で適用され、設定完了まで最大10分かかります
#
# ユースケース:
# - AMIの意図しない公開共有を防止
# - セキュリティポリシーに基づくAMI共有制御
# - 組織全体でのAMI公開共有ガバナンス強化
# - Control Towerによる一元的なAMI共有管理
#
# 注意事項:
# - 既に公開共有されているAMIには影響しません（新規共有のみブロック）
# - 設定変更には最大10分かかり、その間は以前の状態が表示されます
# - リージョンごとに個別に設定する必要があります
# - EnableImageBlockPublicAccess/DisableImageBlockPublicAccess権限が必要です
# - Control Towerの制御と併用する場合は継承設定に注意が必要です
#
# NOTE: このリソースはタグをサポートしていません
# 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/manage-block-public-access-for-amis.html
#---------------------------------------

resource "aws_ec2_image_block_public_access" "example" {

  #---------------------------------------
  # アクセス制御設定
  #---------------------------------------

  # ブロック状態
  # 設定内容: AMIの公開共有に対するブロック状態
  # 設定可能な値:
  #   - block-new-sharing: 新規の公開共有をブロック
  #   - unblocked: 公開共有を許可
  # 注意: 既存の公開AMIには影響しません
  state = "block-new-sharing"

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 対象リージョン
  # 設定内容: この設定を適用するAWSリージョン
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 注意: リージョンごとに個別に設定する必要があります
  region = "us-east-1"

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # 更新タイムアウト
  # 設定内容: 設定変更の最大待機時間
  # 省略時: 10分
  # 注意: 設定変更には最大10分かかります
  # timeouts {
  #   update = "10m"
  # }

}

#---------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------
# このリソースでは以下の属性が参照可能です:
#
# id               - リソースID（リージョン名）
# state            - 現在のブロック状態
# region           - 設定が適用されているリージョン
