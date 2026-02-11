#---------------------------------------------------------------
# AWS Lightsail Disk
#---------------------------------------------------------------
#
# Lightsailインスタンスに追加のブロックストレージを提供するディスクリソースです。
# Lightsailディスクは、Lightsailインスタンスにアタッチできる追加のストレージ容量を提供し、
# データベース、ファイルストレージ、バックアップなどの用途で使用できます。
# ディスクは作成後、同じアベイラビリティーゾーン内のLightsailインスタンスにアタッチ可能です。
#
# AWS公式ドキュメント:
#   - Amazon Lightsail: https://docs.aws.amazon.com/lightsail/
#   - Lightsail Block Storage: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-block-storage-disks-in-amazon-lightsail.html
#   - Attaching Disks: https://docs.aws.amazon.com/lightsail/latest/userguide/attach-disk-to-instance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_disk
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_disk" "example" {
  #-------------------------------------------------------------
  # ディスク基本設定 (必須)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ディスクの名前を指定します。
  # 設定可能な値: アルファベット文字で始まり、英数字、アンダースコア、
  #              ハイフン、ドットのみを含む文字列
  # 注意: ディスク名は作成後に変更できません（リソースの再作成が必要）。
  #       同じリージョン内で一意である必要があります。
  # 命名規則の推奨:
  #   - わかりやすく、用途が明確な名前を使用する
  #   - 環境名やインスタンス名を含めると管理しやすい（例: prod-web-disk-01）
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-block-storage-disks-in-amazon-lightsail.html
  name = "example-disk"

  # size_in_gb (Required)
  # 設定内容: ディスクのサイズをGB単位で指定します。
  # 設定可能な値: 8GB以上の整数値
  # 注意: ディスクサイズは作成後に増加させることはできますが、減少させることはできません。
  #       増加は特定のサイズ増分でのみ可能です（例: 8GB, 16GB, 32GB, 64GB, 128GB, 256GB, 512GB, 1024GB, 2048GB）。
  # 推奨: 初期は必要最小限のサイズで開始し、必要に応じて拡張することを検討してください。
  # 課金: ディスクサイズに応じて月額料金が発生します。
  # 参考: https://aws.amazon.com/lightsail/pricing/
  size_in_gb = 8

  # availability_zone (Required)
  # 設定内容: ディスクを作成するアベイラビリティーゾーンを指定します。
  # 設定可能な値: 有効なLightsailアベイラビリティーゾーン（例: us-east-1a, ap-northeast-1a）
  # 注意: ディスクは、同じアベイラビリティーゾーン内のLightsailインスタンスにのみアタッチできます。
  #       アベイラビリティーゾーンは作成後に変更できません（リソースの再作成が必要）。
  # 推奨: アタッチ予定のLightsailインスタンスと同じアベイラビリティーゾーンを指定してください。
  # データソースの利用例:
  #   data "aws_availability_zones" "available" {
  #     state = "available"
  #     filter {
  #       name   = "opt-in-status"
  #       values = ["opt-in-not-required"]
  #     }
  #   }
  #   availability_zone = data.aws_availability_zones.available.names[0]
  # 参考: https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-regions-and-availability-zones-in-amazon-lightsail.html
  availability_zone = "us-east-1a"

  #-------------------------------------------------------------
  # リージョン設定 (オプション)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます（推奨）
  # 注意: 通常はプロバイダーレベルでリージョンを設定し、このパラメータは省略することを推奨します。
  #       リージョンを変更する場合は、リソースの再作成が必要です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = null

  #-------------------------------------------------------------
  # タグ設定 (オプション)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（キーのみのタグを作成する場合は空文字列を値として使用）
  # 注意: プロバイダーの default_tags 設定ブロックが存在する場合、
  #       同じキーを持つタグはプロバイダーレベルで定義されたタグを上書きします。
  # 推奨タグの例:
  #   - Environment: 環境名（例: production, staging, development）
  #   - Project: プロジェクト名
  #   - ManagedBy: 管理方法（例: terraform）
  #   - Owner: 所有者またはチーム名
  #   - Purpose: ディスクの用途（例: database, backup, logs）
  # タグの利用例:
  #   - コスト配分とトラッキング
  #   - リソースの整理と検索
  #   - アクセス制御（IAMポリシーでタグベースの条件を使用）
  # 参考: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-disk"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディスクのID（nameと同じ値）
#   使用例: aws_lightsail_disk.example.id
#
# - arn: ディスクのAmazon Resource Name (ARN)
#   形式: arn:aws:lightsail:region:account-id:Disk/disk-id
#   使用例: aws_lightsail_disk.example.arn
#   用途: IAMポリシー、リソースベースのポリシー、クロスアカウントアクセスの制御に使用
#
# - created_at: ディスクが作成された日時（ISO 8601形式）
#   形式: YYYY-MM-DDTHH:MM:SSZ
#   使用例: aws_lightsail_disk.example.created_at
#
# - support_code: ディスクのサポートコード
#   説明: Lightsailに関する問い合わせ時にこのコードを含めることで、
#         AWSサポートがリソースを迅速に特定できます。
#   使用例: aws_lightsail_disk.example.support_code
#
# - tags_all: リソースに割り当てられたすべてのタグのマップ
#   説明: プロバイダーの default_tags 設定ブロックから継承されたタグを含みます。
#   使用例: aws_lightsail_disk.example.tags_all
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_disk#attributes-reference
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のLightsailディスクをTerraform管理下にインポートできます:
#
# terraform import aws_lightsail_disk.example example-disk
#
# インポート形式: ディスク名を使用します
#
# 注意事項:
#   - インポート後は、terraform plan を実行して差分がないことを確認してください
#   - tagsなどのオプション属性は、インポート後に手動で設定する必要があります
#
# 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_disk#import
#---------------------------------------------------------------
