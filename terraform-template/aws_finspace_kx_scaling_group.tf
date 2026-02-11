#---------------------------------------------------------------
# Amazon FinSpace Kx Scaling Group
#---------------------------------------------------------------
#
# Amazon FinSpace Kx環境内でkdbクラスターを実行するためのスケーリンググループをプロビジョニングします。
# スケーリンググループは、単一のホスト上で複数のkdbクラスターを実行することで、
# コンピューティングリソースを最大限に活用し、kdbワークロードのリソース使用を最適化します。
#
# 注意: Amazon FinSpaceは2026年10月7日にサポートが終了します。
#       2025年10月7日以降、新規顧客の受け入れは停止されます。
#
# AWS公式ドキュメント:
#   - CreateKxScalingGroup API: https://docs.aws.amazon.com/finspace/latest/management-api/API_CreateKxScalingGroup.html
#   - KxScalingGroup Structure: https://docs.aws.amazon.com/finspace/latest/management-api/API_KxScalingGroup.html
#   - Managed kdb Scaling Groups: https://docs.aws.amazon.com/finspace/latest/userguide/finspace-managed-kdb-scaling-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/finspace_kx_scaling_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_finspace_kx_scaling_group" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # スケーリンググループを作成するkdb環境の一意な識別子
  # 形式: 1～32文字の小文字英数字 (例: "myenv123")
  environment_id = "your-environment-id"

  # アベイラビリティーゾーンの識別子
  # kdbクラスターを配置するAZを指定します
  # 形式: 8～12文字 (例: "use1-az2", "usw2-az1")
  availability_zone_id = "use1-az2"

  # スケーリンググループのホストタイプ
  # FinSpace Managed kdbクラスターが配置されるホストのメモリとCPU能力を定義します
  #
  # 指定可能な値:
  #   - kx.sg.large      : 16 GiB メモリ、2 vCPU
  #   - kx.sg.xlarge     : 32 GiB メモリ、4 vCPU
  #   - kx.sg.2xlarge    : 64 GiB メモリ、8 vCPU
  #   - kx.sg.4xlarge    : 108 GiB メモリ、16 vCPU
  #   - kx.sg.8xlarge    : 216 GiB メモリ、32 vCPU
  #   - kx.sg.16xlarge   : 432 GiB メモリ、64 vCPU
  #   - kx.sg.32xlarge   : 864 GiB メモリ、128 vCPU
  #   - kx.sg1.16xlarge  : 1949 GiB メモリ、64 vCPU
  #   - kx.sg1.24xlarge  : 2948 GiB メモリ、96 vCPU
  host_type = "kx.sg.4xlarge"

  # kdbスケーリンググループの一意な名前
  # 形式: 3～63文字、英数字とハイフン・アンダースコアが使用可能
  #       先頭と末尾は英数字である必要があります
  # パターン: ^[a-zA-Z0-9][a-zA-Z0-9-_]*[a-zA-Z0-9]$
  name = "my-tf-kx-scalinggroup"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # リージョンの変更はリソースの再作成を伴う場合があります
  # region = "us-east-1"

  # スケーリンググループに適用するタグ
  # 最大50個のタグを追加できます
  # プロバイダーのdefault_tagsブロックで設定されたタグとマージされます
  #
  # 例:
  # tags = {
  #   Name        = "my-kx-scaling-group"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }
  tags = {
    Name = "example-scaling-group"
  }

  # プロバイダーのdefault_tagsとマージされた全てのタグ
  # このパラメータはcomputed属性として自動的に管理されるため、
  # 通常は明示的に設定する必要はありません
  # tags_all = {}

  #---------------------------------------------------------------
  # Timeouts (Optional)
  #---------------------------------------------------------------
  # 各操作のタイムアウト時間を設定できます
  # デフォルト値が設定されていない場合、Terraformのデフォルト動作が適用されます

  # timeouts {
  #   # スケーリンググループ作成のタイムアウト（デフォルト: 適切な値が自動設定）
  #   create = "30m"
  #
  #   # スケーリンググループ更新のタイムアウト（デフォルト: 適切な値が自動設定）
  #   update = "30m"
  #
  #   # スケーリンググループ削除のタイムアウト（デフォルト: 適切な値が自動設定）
  #   # 注意: スケーリンググループ上の全てのクラスターを削除するまで、
  #   #       スケーリンググループ自体は削除できません
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースが作成された後、以下の属性を参照できます（computed only）:
#
# - arn                    : KxスケーリンググループのAmazon Resource Name (ARN)
# - clusters               : 現在このスケーリンググループでアクティブなManaged kdbクラスターのリスト
# - created_timestamp      : スケーリンググループがFinSpaceで作成されたタイムスタンプ（エポック時間、ミリ秒単位）
#                            例: 2021年11月1日 12:00:00 PM UTC = 1635768000000
# - last_modified_timestamp: FinSpaceでスケーリンググループが最後に更新されたタイムスタンプ（エポック時間、秒単位）
#                            例: 2021年11月1日 12:00:00 PM UTC = 1635768000
# - status                 : スケーリンググループのステータス
#                            - CREATING       : 作成中
#                            - CREATE_FAILED  : 作成失敗
#                            - ACTIVE         : アクティブ
#                            - UPDATING       : 更新中
#                            - UPDATE_FAILED  : 更新失敗
#                            - DELETING       : 削除中
#                            - DELETE_FAILED  : 削除失敗
#                            - DELETED        : 削除完了
# - status_reason          : 失敗状態が発生した場合のエラーメッセージ
# - tags_all               : プロバイダーのdefault_tagsとマージされたタグのマップ
#
# 使用例:
# output "scaling_group_arn" {
#   value = aws_finspace_kx_scaling_group.example.arn
# }
#
# output "scaling_group_status" {
#   value = aws_finspace_kx_scaling_group.example.status
# }
#
# output "active_clusters" {
#   value = aws_finspace_kx_scaling_group.example.clusters
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
# 1. スケーリンググループの削除
#    - スケーリンググループを削除する前に、その上で実行中の全てのkdbクラスターを
#      削除する必要があります
#
# 2. リソース管理の考慮事項
#    - スケーリンググループ上でクラスターを起動する際は、最小および予想メモリ要件を
#      指定する必要があります
#    - 各スケーリンググループは単一のホストで構成され、複数のクラスターを持つことができます
#    - 各クラスターは1つ以上のノードを持つことができます
#
# 3. 制限事項
#    - スケーリンググループ上で実行されるGPおよびHDBクラスターでは、
#      savedownストレージと高性能HDBディスクキャッシュがサポートされていません
#
# 4. FinSpaceサービスの終了
#    - Amazon FinSpaceは2026年10月7日にサポート終了予定です
#    - 2025年10月7日以降、新規顧客の受け入れは停止されます
#    - 既存の環境は2026年10月7日まで通常通り使用できます
#---------------------------------------------------------------
