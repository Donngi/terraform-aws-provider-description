#---------------------------------------
# AWS CloudHSM v2 HSM
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudhsm_v2_hsm
#
# AWS CloudHSM クラスタに追加するハードウェアセキュリティモジュール (HSM) を管理します。
# HSM は暗号鍵の生成・管理を行う専用ハードウェアで、FIPS 140-3 Level 3 認証を取得しています。
# 高可用性を確保するため、複数の Availability Zone に HSM を配置することを推奨します。
#
# 主な用途:
# - 暗号鍵の安全な生成・保管
# - PCI DSS、PCI-PIN などのコンプライアンス要件対応
# - データベースやアプリケーションの暗号化処理
#
# NOTE: HSM の作成には通常 10〜15 分かかります。クラスタは事前に初期化されている必要があります。

#---------------------------------------
# HSM の基本設定
#---------------------------------------

resource "aws_cloudhsm_v2_hsm" "example" {
  # 設定内容: HSM を追加する CloudHSM クラスタの ID
  # 設定可能な値: 既存の CloudHSM クラスタ ID (例: cluster-xxxxxxxx)
  cluster_id = "cluster-abc123def456"

  #---------------------------------------
  # 配置設定
  #---------------------------------------

  # 設定内容: HSM を配置する Availability Zone
  # 設定可能な値: クラスタの VPC 内で利用可能な AZ (例: us-east-1a)
  # 省略時: AWS が自動選択
  # 補足: 高可用性のため、異なる AZ に複数の HSM を配置することを推奨
  availability_zone = "us-east-1a"

  # 設定内容: HSM の Elastic Network Interface (ENI) を配置するサブネット ID
  # 設定可能な値: クラスタ VPC 内のサブネット ID
  # 省略時: 指定した AZ 内でクラスタに関連付けられたサブネットを自動選択
  # 補足: クラスタ作成時に指定したサブネット内で選択されます
  subnet_id = null

  # 設定内容: HSM に割り当てるプライベート IP アドレス
  # 設定可能な値: サブネットの CIDR 範囲内の有効な IP アドレス
  # 省略時: サブネット内で自動割り当て
  # 補足: 静的 IP が必要な場合のみ指定します
  ip_address = null

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースを管理する AWS リージョン
  # 設定可能な値: AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  # timeouts {
  #   # 設定内容: HSM 作成のタイムアウト時間
  #   # 設定可能な値: 時間文字列 (例: 60m, 2h)
  #   # 省略時: 60m
  #   # 補足: HSM の作成には通常 10〜15 分かかります
  #   create = "120m"
  #
  #   # 設定内容: HSM 削除のタイムアウト時間
  #   # 設定可能な値: 時間文字列 (例: 30m, 1h)
  #   # 省略時: 60m
  #   delete = "120m"
  # }
}

#---------------------------------------
# Attributes Reference (参照可能な属性)
#---------------------------------------
# このリソースの作成後、以下の属性を参照できます:
#
# - id               : HSM のリソース識別子 (通常は hsm_id と同じ値)
# - hsm_id           : HSM の一意な識別子
# - hsm_state        : HSM の現在の状態
#                      値: ACTIVE, DEGRADED, DELETE_IN_PROGRESS, DELETED など
# - hsm_eni_id       : HSM に関連付けられた ENI の ID
#                      クライアントソフトウェアがこの ENI 経由で HSM と通信します
# - availability_zone: HSM が配置されている Availability Zone
# - subnet_id        : HSM の ENI が配置されているサブネット ID
# - ip_address       : HSM の ENI に割り当てられたプライベート IP アドレス
# - region           : HSM が管理されているリージョン
