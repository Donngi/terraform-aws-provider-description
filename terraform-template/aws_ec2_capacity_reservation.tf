#---------------------------------------------------------------
# EC2 Capacity Reservation
#---------------------------------------------------------------
#
# EC2 Capacity Reservationは、特定のアベイラビリティゾーンにおいて
# EC2インスタンスのキャパシティを予約するリソースです。
# オンデマンドキャパシティ予約により、必要なときにインスタンスを
# 確実に起動できるようにします。
#
# AWS公式ドキュメント:
#   - On-Demand Capacity Reservations: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-capacity-reservations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_capacity_reservation
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_capacity_reservation" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # availability_zone - (必須) キャパシティを予約するアベイラビリティゾーン
  # 例: "us-east-1a", "ap-northeast-1a"
  availability_zone = "us-east-1a"

  # instance_count - (必須) 予約するインスタンスの数
  # 最小値: 1
  instance_count = 1

  # instance_platform - (必須) インスタンスのプラットフォーム
  # 有効な値: "Linux/UNIX", "Red Hat Enterprise Linux", "SUSE Linux", 
  #          "Windows", "Windows with SQL Server", 
  #          "Windows with SQL Server Enterprise", "Windows with SQL Server Standard", 
  #          "Windows with SQL Server Web", "Linux with SQL Server Standard",
  #          "Linux with SQL Server Web", "Linux with SQL Server Enterprise"
  instance_platform = "Linux/UNIX"

  # instance_type - (必須) 予約するインスタンスタイプ
  # 例: "t3.micro", "m5.large", "c5.xlarge"
  instance_type = "t3.micro"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # ebs_optimized - (オプション) EBS最適化インスタンスとして予約するかどうか
  # デフォルト: false
  # EBS最適化インスタンスは、EBSボリュームへの専用帯域幅を提供します
  ebs_optimized = null

  # end_date - (オプション) キャパシティ予約の終了日時
  # RFC3339形式で指定: "2026-12-31T23:59:59Z"
  # end_date_typeが"limited"の場合に使用します
  end_date = null

  # end_date_type - (オプション) キャパシティ予約の終了タイプ
  # 有効な値: "unlimited" (デフォルト), "limited"
  # - unlimited: 手動でキャンセルするまで予約を継続
  # - limited: end_dateで指定した日時に自動的に終了
  end_date_type = null

  # ephemeral_storage - (オプション) エフェメラルストレージを予約するかどうか
  # デフォルト: false
  # インスタンスストア（一時ストレージ）を含むインスタンスタイプで使用
  ephemeral_storage = null

  # id - (オプション) リソースID
  # 通常は指定不要。Terraformが自動的に管理します
  id = null

  # instance_match_criteria - (オプション) インスタンスマッチング条件
  # 有効な値: "open" (デフォルト), "targeted"
  # - open: 同じインスタンスタイプの任意のインスタンスにマッチ
  # - targeted: 特定のインスタンスIDにのみマッチ
  instance_match_criteria = null

  # outpost_arn - (オプション) AWS Outpostのリソース名（ARN）
  # OutpostにキャパシティReservationを作成する場合に指定
  # 例: "arn:aws:outposts:us-east-1:123456789012:outpost/op-1234567890abcdef0"
  outpost_arn = null

  # placement_group_arn - (オプション) プレースメントグループのARN
  # キャパシティ予約を特定のプレースメントグループに関連付ける場合に指定
  # 例: "arn:aws:ec2:us-east-1:123456789012:placement-group/my-cluster"
  placement_group_arn = null

  # region - (オプション) リソースを管理するリージョン
  # 指定しない場合はプロバイダー設定のリージョンが使用されます
  # 例: "us-east-1", "ap-northeast-1"
  region = null

  # tags - (オプション) リソースに付けるタグのマップ
  # キャパシティ予約の識別や管理に使用
  tags = {
    Name        = "example-capacity-reservation"
    Environment = "production"
  }

  # tags_all - (オプション) すべてのタグを含むマップ
  # デフォルトタグとリソース固有のタグを統合したもの
  # 通常は明示的に指定する必要はありません
  tags_all = null

  # tenancy - (オプション) インスタンスのテナンシー
  # 有効な値: "default" (デフォルト), "dedicated"
  # - default: 共有ハードウェア上で実行
  # - dedicated: 専有ハードウェア上で実行
  tenancy = null

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # create - (オプション) リソース作成のタイムアウト
    # デフォルト: 10分
    # 例: "15m", "1h"
    create = null

    # update - (オプション) リソース更新のタイムアウト
    # デフォルト: 10分
    update = null

    # delete - (オプション) リソース削除のタイムアウト
    # デフォルト: 10分
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照できますが、設定はできません。
#
# - arn - Capacity ReservationのAmazon Resource Name (ARN)
#   例: "arn:aws:ec2:us-east-1:123456789012:capacity-reservation/cr-1234567890abcdef0"
#
# - owner_id - Capacity Reservationを所有するAWSアカウントID
#   例: "123456789012"
#
#---------------------------------------------------------------