################################################################################
# AWS CloudHSM v2 Cluster - Annotated Terraform Template
################################################################################
# Generated: 2026-01-18
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点(2026-01-18)の情報に基づいています。
#       最新の仕様や詳細については、必ず公式ドキュメントをご確認ください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudhsm_v2_cluster
################################################################################

resource "aws_cloudhsm_v2_cluster" "example" {
  #-----------------------------------------------------------------------------
  # Required Parameters
  #-----------------------------------------------------------------------------

  # (Required) The type of HSM module in the cluster.
  # 現在サポートされているHSMタイプ:
  #   - "hsm1.medium": 従来型HSM (2024年6月10日以前のデフォルト)
  #                    注: 新規クラスター作成には使用できなくなっています
  #   - "hsm2m.medium": 最新世代のHSM (推奨)
  #
  # 参考: https://docs.aws.amazon.com/cloudhsm/latest/userguide/cluster-hsm-types.html
  hsm_type = "hsm2m.medium"

  # (Required) The IDs of subnets in which cluster will operate.
  # クラスターが動作するサブネットのID。
  # 高可用性のため、複数のアベイラビリティゾーンにサブネットを配置することを推奨します。
  # クラスター内のHSMは最大28個まで配置可能です(デフォルト制限は6個/リージョン)。
  #
  # 参考: https://docs.aws.amazon.com/cloudhsm/latest/userguide/clusters.html
  subnet_ids = [
    "subnet-12345678",
    "subnet-87654321",
  ]

  #-----------------------------------------------------------------------------
  # Optional Parameters
  #-----------------------------------------------------------------------------

  # (Optional) The mode to use in the cluster.
  # クラスターの動作モード:
  #   - "FIPS": FIPS検証済みの鍵とアルゴリズムのみを使用 (hsm1.mediumおよびhsm2m.mediumで利用可能)
  #   - "NON_FIPS": FIPS検証済みおよび非FIPS検証済みの鍵とアルゴリズムを使用可能 (hsm2m.mediumのみ)
  #
  # 注意:
  #   - hsm_typeが"hsm2m.medium"の場合、このフィールドは必須です
  #   - クラスター作成後はモードを変更できません
  #   - FIPSモードのクラスターはFIPSモードのバックアップのみ復元可能
  #   - NON_FIPSモードのクラスターはNON_FIPSモードのバックアップのみ復元可能
  #
  # 参考: https://docs.aws.amazon.com/cloudhsm/latest/userguide/cluster-hsm-types.html
  mode = "FIPS"

  # (Optional) ID of Cloud HSM v2 cluster backup to be restored.
  # 復元するCloudHSM v2クラスターバックアップのID。
  # バックアップからクラスターを復元する場合に指定します。
  #
  # 参考: https://docs.aws.amazon.com/cloudhsm/latest/APIReference/API_CreateCluster.html
  source_backup_identifier = null

  # (Optional) Region where this resource will be managed.
  # このリソースが管理されるリージョン。
  # デフォルトではプロバイダー設定のリージョンが使用されます。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # (Optional) A map of tags to assign to the resource.
  # リソースに割り当てるタグのマップ。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # キーが一致するタグはプロバイダーレベルで定義されたものを上書きします。
  #
  # 注意: クラスターの属性の中で、実質的に更新可能なのはこのtagsのみです。
  #
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-cloudhsm-cluster"
    Environment = "production"
  }

  #-----------------------------------------------------------------------------
  # Computed-Only Attributes (Read-Only)
  #-----------------------------------------------------------------------------
  # 以下の属性は自動的に計算され、設定することはできません:
  #
  # - id: Terraform リソースID (cluster_idと同じ値)
  # - cluster_id: CloudHSMクラスターのID
  # - cluster_state: CloudHSMクラスターの状態
  #   (例: UNINITIALIZED, INITIALIZE_IN_PROGRESS, INITIALIZED, ACTIVE, など)
  # - vpc_id: CloudHSMクラスターが配置されているVPCのID
  # - security_group_id: CloudHSMクラスターに関連付けられたセキュリティグループのID
  # - cluster_certificates: クラスター証明書のリスト
  #   - cluster_certificates.0.cluster_certificate: クラスター証明書
  #   - cluster_certificates.0.cluster_csr: 証明書署名要求 (CSR、UNINITIALIZED状態でのみ利用可能)
  #   - cluster_certificates.0.aws_hardware_certificate: AWS CloudHSMが発行したHSMハードウェア証明書
  #   - cluster_certificates.0.hsm_certificate: HSMハードウェアが発行したHSM証明書
  #   - cluster_certificates.0.manufacturer_hardware_certificate: ハードウェア製造元が発行したHSMハードウェア証明書
  # - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #   リソースに割り当てられたすべてのタグのマップ
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Timeouts
  #-----------------------------------------------------------------------------
  timeouts {
    # (Optional) クラスター作成のタイムアウト (デフォルト: 120分)
    # CloudHSMクラスターのセットアップには数分かかる場合があります。
    create = "120m"

    # (Optional) クラスター更新のタイムアウト
    update = null

    # (Optional) クラスター削除のタイムアウト
    # 注意: クラスターを削除する前に、すべてのHSMモジュールを削除する必要があります。
    delete = null
  }
}

################################################################################
# Output Examples
################################################################################
# クラスターのIDを出力する例
# output "cluster_id" {
#   description = "The ID of the CloudHSM cluster"
#   value       = aws_cloudhsm_v2_cluster.example.cluster_id
# }
#
# クラスターの状態を出力する例
# output "cluster_state" {
#   description = "The state of the CloudHSM cluster"
#   value       = aws_cloudhsm_v2_cluster.example.cluster_state
# }
#
# クラスターのVPC IDを出力する例
# output "vpc_id" {
#   description = "The VPC ID where the CloudHSM cluster resides"
#   value       = aws_cloudhsm_v2_cluster.example.vpc_id
# }
#
# クラスターのセキュリティグループIDを出力する例
# output "security_group_id" {
#   description = "The security group ID associated with the CloudHSM cluster"
#   value       = aws_cloudhsm_v2_cluster.example.security_group_id
# }
#
# クラスター証明書を出力する例
# output "cluster_certificates" {
#   description = "The cluster certificates"
#   value       = aws_cloudhsm_v2_cluster.example.cluster_certificates
#   sensitive   = true
# }
################################################################################

################################################################################
# Important Notes
################################################################################
# 1. CloudHSMクラスターのセットアップには数分かかる場合があります。
#
# 2. tagsを除き、ほとんどの属性は作成後に更新できません。
#    変更が必要な場合は、クラスターを再作成する必要があります。
#
# 3. クラスターを削除する前に、すべてのHSMモジュールを削除する必要があります。
#
# 4. クラスターを初期化するには:
#    a. HSMインスタンスをクラスターに追加
#    b. CSRに署名してアップロード
#
# 5. hsm2m.mediumを使用する場合、modeパラメータは必須です。
#
# 6. クラスターのモードは作成後に変更できません。
#    クラスター作成前に適切なモードを選択することが重要です。
#
# 7. 2024年6月10日以前に作成されたすべてのクラスターは、
#    hsm1.mediumのHSMタイプでFIPSモードになっています。
#
# 8. hsm1.mediumはサポート終了に向かっており、新規クラスター作成には使用できません。
#
# 参考リンク:
#   - ユーザーガイド: https://docs.aws.amazon.com/cloudhsm/latest/userguide/
#   - API リファレンス: https://docs.aws.amazon.com/cloudhsm/latest/APIReference/
#   - クラスターの作成: https://docs.aws.amazon.com/cloudhsm/latest/userguide/create-cluster.html
#   - クラスターモード: https://docs.aws.amazon.com/cloudhsm/latest/userguide/cluster-hsm-types.html
################################################################################
