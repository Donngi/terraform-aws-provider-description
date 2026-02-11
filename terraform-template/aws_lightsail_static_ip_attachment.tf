################################################################################
# AWS Lightsail Static IP Attachment
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_static_ip_attachment
################################################################################

# Lightsail静的IPアタッチメント - Lightsail静的IPとLightsailインスタンス間の関係を管理
#
# 用途:
# - インスタンスの再起動時にも維持される一貫したパブリックIPアドレスを提供
# - Lightsailインスタンスに静的IPアドレスをアタッチする
#
# 注意事項:
# - Lightsailは限られたAWSリージョンでのみサポートされています
# - 詳細は「Regions and Availability Zones in Amazon Lightsail」を参照
# - 静的IPは事前にaws_lightsail_static_ipリソースで作成する必要があります
# - インスタンスはaws_lightsail_instanceリソースで作成する必要があります

resource "aws_lightsail_static_ip_attachment" "example" {
  ################################################################################
  # Required Arguments
  ################################################################################

  # アタッチ先のLightsailインスタンス名
  #
  # 設定値:
  # - Lightsailインスタンスのリソース名またはID
  # - 通常はaws_lightsail_instance.*.idを参照
  #
  # 例:
  # - aws_lightsail_instance.web.id
  # - "my-lightsail-instance"
  instance_name = aws_lightsail_instance.example.id

  # アタッチする静的IPの名前
  #
  # 設定値:
  # - 事前に割り当てられた静的IPの名前またはID
  # - 通常はaws_lightsail_static_ip.*.idを参照
  #
  # 例:
  # - aws_lightsail_static_ip.main.id
  # - "my-static-ip"
  static_ip_name = aws_lightsail_static_ip.example.id

  ################################################################################
  # Optional Arguments
  ################################################################################

  # このリソースが管理されるリージョン
  #
  # 設定値:
  # - AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # - 省略した場合はプロバイダー設定のリージョンを使用
  #
  # 注意:
  # - Lightsailが利用可能なリージョンのみ指定可能
  # - インスタンスと静的IPは同じリージョンに存在する必要があります
  #
  # 例:
  # - "us-east-1"
  # - "ap-northeast-1"
  # region = "us-east-1"
}

################################################################################
# Outputs
################################################################################

# アタッチされた静的IPアドレス
output "static_ip_address" {
  description = "割り当てられた静的IPアドレス"
  value       = aws_lightsail_static_ip_attachment.example.ip_address
}

################################################################################
# 使用例: 完全な構成
################################################################################

# 静的IPの作成
resource "aws_lightsail_static_ip" "example" {
  name = "example-static-ip"
}

# Lightsailインスタンスの作成
resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"

  tags = {
    Name        = "example-instance"
    Environment = "production"
  }
}

# 静的IPのアタッチ
resource "aws_lightsail_static_ip_attachment" "example" {
  static_ip_name = aws_lightsail_static_ip.example.id
  instance_name  = aws_lightsail_instance.example.id
}

################################################################################
# ベストプラクティス
################################################################################

# 1. 依存関係の管理
#    - 静的IPとインスタンスを先に作成してからアタッチメントを作成
#    - depends_onを使用して明示的な依存関係を設定することも可能

# 2. リージョンの一貫性
#    - インスタンス、静的IP、アタッチメントは同じリージョンに配置
#    - 異なるリージョン間ではアタッチメント不可

# 3. ネーミング規則
#    - 環境やプロジェクト名を含めたわかりやすい名前を使用
#    - 例: "${var.project}-${var.environment}-static-ip"

# 4. タグ付け
#    - 静的IPとインスタンスには適切なタグを設定
#    - コスト管理と追跡のため

# 5. 可用性ゾーン
#    - インスタンスのavailability_zoneは適切に選択
#    - 静的IPはリージョンレベルのリソースなので特定のAZに依存しない

################################################################################
# トラブルシューティング
################################################################################

# エラー: "Static IP is already attached"
# 原因: 静的IPが既に別のインスタンスにアタッチされている
# 解決: 既存のアタッチメントを削除してから新しいアタッチメントを作成

# エラー: "Instance not found"
# 原因: 指定したインスタンス名が存在しない
# 解決: インスタンスが正しく作成されているか、名前が正確かを確認

# エラー: "Static IP not found"
# 原因: 指定した静的IP名が存在しない
# 解決: 静的IPが正しく作成されているか、名前が正確かを確認

# エラー: "Region mismatch"
# 原因: 静的IPとインスタンスが異なるリージョンに存在
# 解決: 同じリージョンにリソースを配置

################################################################################
# 参考リンク
################################################################################

# Terraform AWS Provider - Lightsail Static IP Attachment:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_static_ip_attachment

# AWS Lightsail - Regions and Availability Zones:
# https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail

# AWS Lightsail - Static IP addresses:
# https://lightsail.aws.amazon.com/ls/docs/en_us/articles/lightsail-create-static-ip
