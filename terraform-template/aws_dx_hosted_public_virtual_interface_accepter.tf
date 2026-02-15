#---------------------------------------
# AWS Direct Connect ホストパブリック仮想インターフェース受諾
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/dx_hosted_public_virtual_interface_accepter
#
# 他のAWSアカウントが作成したDirect Connectホストパブリック仮想インターフェースを
# 受諾する側のリソースを管理します。
#
# 主な用途:
# - クロスアカウントでのDirect Connect接続の受諾
# - パブリックAWSサービスへのプライベート接続の確立
# - 複数アカウント間でのネットワーク接続の管理
#
# 制限事項:
# - 仮想インターフェースの所有者が作成した後、受諾側が明示的に受諾する必要があります
# - 一度受諾すると、仮想インターフェースの基本設定は変更できません
# - 受諾側はタグとリージョン設定のみを管理できます
#
# 前提条件:
# - 所有者側でaws_dx_hosted_public_virtual_interfaceリソースが作成済みであること
# - 受諾側のAWSアカウントに適切な権限が付与されていること
# - 所有者から仮想インターフェースIDが共有されていること
#
# NOTE:
# - タグを使用して受諾側の識別と管理を容易にする
# - 複数リージョンで管理する場合はregionパラメータを明示的に設定する
# - 受諾前に仮想インターフェースの設定内容を所有者と確認する
#---------------------------------------

resource "aws_dx_hosted_public_virtual_interface_accepter" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # 仮想インターフェースID
  # 設定内容: 受諾するDirect Connectホストパブリック仮想インターフェースのID
  # 形式: vif-xxxxxxxxxxxxxxxxx (17文字の英数字)
  # 注意: 所有者側のaws_dx_hosted_public_virtual_interfaceリソースから取得
  virtual_interface_id = "vif-12345678901234567"

  #---------------------------------------
  # オプションパラメータ - リージョン設定
  #---------------------------------------

  # リージョン
  # 設定内容: このリソースが管理されるAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: 仮想インターフェースが作成されたリージョンと一致させる必要があります
  region = "us-east-1"

  #---------------------------------------
  # オプションパラメータ - タグ
  #---------------------------------------

  # タグ
  # 設定内容: リソースに割り当てるキー/値ペアのマップ
  # 用途: リソースの識別、コスト配分、アクセス制御などに使用
  # 注意: プロバイダーのdefault_tagsと統合されます
  tags = {
    Name        = "example-dx-public-vif-accepter"
    Environment = "production"
    Side        = "Accepter"
    ManagedBy   = "Terraform"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # 作成・削除のタイムアウト
  # 設定内容: リソース操作の最大待機時間
  # デフォルト: create=10m, delete=10m
  # timeouts {
  #   create = "10m"
  #   delete = "10m"
  # }
}

#---------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------
# このリソースからは以下の属性を参照できます:
#
# - id: 仮想インターフェースのID (virtual_interface_idと同じ値)
#
# - arn: 仮想インターフェースのARN
#   形式: arn:aws:directconnect:region:account-id:dxvif/vif-id
#
# - tags_all: リソースに割り当てられたすべてのタグ (プロバイダーのdefault_tagsを含む)
#---------------------------------------
