#---------------------------------------------------------------
# EC2 Capacity Block Reservation
#---------------------------------------------------------------
#
# EC2 Capacity Block Reservationは、機械学習トレーニングなどの短期間の
# 大規模コンピューティングワークロード向けに、指定した将来の期間に
# EC2インスタンス容量を予約するためのリソースです。
#
# AWS公式ドキュメント:
#   - EC2 Capacity Blocks: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-capacity-blocks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_capacity_block_reservation
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_capacity_block_reservation" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # capacity_block_offering_id - (Required, string)
  # Capacity Block Offeringの識別子。
  # aws_ec2_capacity_block_offeringデータソースから取得可能。
  capacity_block_offering_id = "cbr-xxxxxxxxxxxxxxxx"

  # instance_platform - (Required, string)
  # インスタンスプラットフォームのタイプ。
  # 有効な値: "Linux/UNIX", "Red Hat Enterprise Linux", "SUSE Linux", "Windows",
  #          "Windows with SQL Server", "Windows with SQL Server Enterprise",
  #          "Windows with SQL Server Standard", "Windows with SQL Server Web"
  instance_platform = "Linux/UNIX"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # region - (Optional, string)
  # このリソースを管理するリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  # region = "us-east-1"

  # tags - (Optional, map of strings)
  # リソースに割り当てるタグのマップ。
  # tags = {
  #   Name        = "capacity-block-reservation"
  #   Environment = "production"
  # }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # timeouts {
  #   # create - (Optional, string)
  #   # リソース作成のタイムアウト時間。
  #   # デフォルト値が使用されます。
  #   # 形式: "30s", "2h45m" など
  #   # create = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 以下の属性は、リソース作成後に参照可能です（computed-only）:
#
# - arn (string)
#   Capacity Block ReservationのARN
#
# - availability_zone (string)
#   予約が作成されたアベイラビリティゾーン
#
# - created_date (string)
#   予約が作成された日時
#
# - ebs_optimized (bool)
#   EBS最適化が有効かどうか
#
# - end_date (string)
#   予約の終了日時
#
# - end_date_type (string)
#   終了日のタイプ
#
# - id (string)
#   Capacity Block Reservationの識別子
#
# - instance_count (number)
#   予約されたインスタンスの数
#
# - instance_type (string)
#   予約されたインスタンスタイプ
#
# - outpost_arn (string)
#   Outpostに関連付けられている場合のARN
#
# - placement_group_arn (string)
#   プレースメントグループのARN
#
# - reservation_type (string)
#   予約のタイプ
#
# - start_date (string)
#   予約の開始日時
#
# - tags_all (map of strings)
#   デフォルトタグを含む全てのタグのマップ
#
# - tenancy (string)
#   インスタンステナンシー（dedicated, default等）
#
#---------------------------------------------------------------
