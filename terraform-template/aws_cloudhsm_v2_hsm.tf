# ============================================================
# Terraform Template: aws_cloudhsm_v2_hsm
# ============================================================
# Generated: 2026-01-18
# Provider: hashicorp/aws v6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-18)の情報に基づいています
# - 最新の仕様や詳細は必ず公式ドキュメントをご確認ください
# - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_hsm
# - AWS API Reference: https://docs.aws.amazon.com/cloudhsm/latest/APIReference/API_CreateHsm.html
# ============================================================

# aws_cloudhsm_v2_hsm リソース
#
# AWS CloudHSM v2 クラスター内に新しいハードウェアセキュリティモジュール（HSM）を作成します。
# HSMはクラスターの一部として機能し、暗号化キーの生成・管理・保護を行います。
#
# 参考:
# - Resource Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_hsm
# - AWS User Guide: https://docs.aws.amazon.com/cloudhsm/latest/userguide/add-hsm.html
# - AWS API Reference: https://docs.aws.amazon.com/cloudhsm/latest/APIReference/API_CreateHsm.html

resource "aws_cloudhsm_v2_hsm" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # cluster_id - HSMを追加するCloudHSM v2クラスターのID
  #
  # - 形式: cluster-[2-7a-zA-Z]{11,16}
  # - クラスターIDは aws_cloudhsm_v2_cluster データソースまたはリソースから取得可能
  # - 例: "cluster-abc123def456"
  #
  # 参考: https://docs.aws.amazon.com/cloudhsm/latest/APIReference/API_CreateHsm.html
  cluster_id = "cluster-abc123def456"

  # ============================================================
  # オプションパラメータ
  # ============================================================

  # availability_zone - HSMモジュールを配置するアベイラビリティゾーンのID
  #
  # - subnet_id と競合します（どちらか一方のみ指定可能）
  # - 形式: [a-z]{2}(-(gov))?-(east|west|north|south|central){1,2}-\d[a-z]
  # - クラスターのアベイラビリティゾーンは DescribeClusters で確認可能
  # - 例: "us-east-1a"
  #
  # 注意: subnet_id または availability_zone のいずれか一方は必須です
  #
  # 参考: https://docs.aws.amazon.com/cloudhsm/latest/APIReference/API_CreateHsm.html
  availability_zone = "us-east-1a"

  # id - Terraformリソースの識別子
  #
  # - Terraform内部で使用される一意の識別子
  # - 通常は自動生成されるため、明示的な指定は不要
  # - computed属性としても機能し、作成後に参照可能
  id = null

  # ip_address - HSMモジュールのIPアドレス
  #
  # - 指定する場合は、選択したサブネットのCIDR範囲内の利用可能なIPアドレスを使用
  # - 形式: \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}
  # - 未指定の場合、該当サブネットから自動的に割り当てられます
  # - アベイラビリティゾーンにマップされたサブネットから利用可能なIPアドレスである必要があります
  # - 例: "10.0.1.5"
  #
  # 参考: https://docs.aws.amazon.com/cloudhsm/latest/APIReference/API_CreateHsm.html
  ip_address = "10.0.1.5"

  # region - このリソースが管理されるリージョン
  #
  # - プロバイダー設定で指定されたリージョンがデフォルトで使用されます
  # - 明示的に異なるリージョンを指定する場合に使用
  # - リージョナルエンドポイントについての詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - プロバイダー設定: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_hsm
  region = "us-east-1"

  # subnet_id - HSMモジュールを配置するサブネットのID
  #
  # - availability_zone と競合します（どちらか一方のみ指定可能）
  # - クラスター作成時に指定したサブネットIDの1つを使用
  # - 例: "subnet-12345678"
  #
  # 注意: subnet_id または availability_zone のいずれか一方は必須です
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_hsm
  subnet_id = "subnet-12345678"

  # ============================================================
  # タイムアウト設定
  # ============================================================

  # timeouts - リソース操作のタイムアウト設定
  #
  # HSMの作成・削除には時間がかかる場合があるため、必要に応じてタイムアウトを調整します
  timeouts {
    # create - HSM作成時のタイムアウト時間
    #
    # - デフォルト: 60m（60分）
    # - 形式: "30m", "1h" など
    # - HSMのプロビジョニングと既存HSMからのバックアップ復元に時間がかかる場合があります
    create = "60m"

    # delete - HSM削除時のタイムアウト時間
    #
    # - デフォルト: 60m（60分）
    # - 形式: "30m", "1h" など
    # - HSMの削除処理が完了するまでの時間を設定
    delete = "60m"
  }
}

# ============================================================
# Computed Attributes (参照のみ可能な属性)
# ============================================================
#
# 以下の属性は作成後に参照可能ですが、入力パラメータとしては使用できません:
#
# - hsm_eni_id: HSMモジュールに割り当てられたENIインターフェースのID
#   例: aws_cloudhsm_v2_hsm.example.hsm_eni_id
#
# - hsm_id: HSMモジュールの一意識別子
#   例: aws_cloudhsm_v2_hsm.example.hsm_id
#
# - hsm_state: HSMモジュールの現在の状態
#   例: aws_cloudhsm_v2_hsm.example.hsm_state
#   可能な状態: CREATE_IN_PROGRESS, ACTIVE, DEGRADED, DELETE_IN_PROGRESS, DELETED
#
# ============================================================
# 使用例
# ============================================================
#
# # データソースでクラスター情報を取得
# data "aws_cloudhsm_v2_cluster" "example" {
#   cluster_id = var.cloudhsm_cluster_id
# }
#
# # クラスターの最初のサブネットにHSMを作成
# resource "aws_cloudhsm_v2_hsm" "example" {
#   subnet_id  = data.aws_cloudhsm_v2_cluster.example.subnet_ids[0]
#   cluster_id = data.aws_cloudhsm_v2_cluster.example.cluster_id
# }
#
# # または、アベイラビリティゾーンを指定してHSMを作成
# resource "aws_cloudhsm_v2_hsm" "example_with_az" {
#   availability_zone = "us-east-1a"
#   cluster_id        = data.aws_cloudhsm_v2_cluster.example.cluster_id
#   ip_address        = "10.0.1.10"
# }
#
# ============================================================
# 重要な注意事項
# ============================================================
#
# 1. subnet_id と availability_zone は競合します。どちらか一方のみを指定してください
# 2. HSMの作成には通常10〜15分程度かかります
# 3. AWS CloudHSMは、新しいHSMを作成する際に既存HSMのバックアップを取得し、
#    それを新しいHSMに復元することで、クラスター内のHSM間の同期を保ちます
# 4. 高可用性を確保するため、異なるアベイラビリティゾーンに複数のHSMを配置することを推奨します
# 5. クロスアカウント使用はサポートされていません
#
# ============================================================
