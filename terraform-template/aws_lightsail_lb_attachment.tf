# ================================================================================
# AWS Lightsail Load Balancer Attachment
# ================================================================================
# Lightsail ロードバランサーに Lightsail インスタンスをアタッチするリソース
#
# 用途:
# - Lightsail インスタンスをロードバランサーに接続してトラフィックを分散
# - 複数のインスタンスに負荷を分散することで可用性を向上
# - ヘルスチェックを通じて健全なインスタンスのみにトラフィックをルーティング
#
# ベストプラクティス:
# - インスタンスとロードバランサーを同じリージョンに配置する
# - ヘルスチェックパスを適切に設定してインスタンスの健全性を監視
# - 複数のアベイラビリティゾーンにインスタンスを分散して冗長性を確保
# - タグを使用してリソースを整理・管理
#
# 注意事項:
# - アタッチメント作成前にインスタンスとロードバランサーが存在している必要がある
# - インスタンスのポートがロードバランサーのヘルスチェックに応答できる必要がある
# - 削除時はインスタンスとロードバランサー自体は削除されない（アタッチメントのみ削除）
#
# 関連リソース:
# - aws_lightsail_lb: Lightsail ロードバランサー本体
# - aws_lightsail_instance: アタッチ対象の Lightsail インスタンス
#
# ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_lb_attachment
# ================================================================================

resource "aws_lightsail_lb_attachment" "example" {
  # ================================================================================
  # 必須パラメータ
  # ================================================================================

  # ロードバランサー名
  # - アタッチ先の Lightsail ロードバランサーの名前を指定
  # - aws_lightsail_lb リソースの name 属性を参照
  # - 既存のロードバランサーが必要
  lb_name = aws_lightsail_lb.example.name

  # インスタンス名
  # - アタッチする Lightsail インスタンスの名前を指定
  # - aws_lightsail_instance リソースの name 属性を参照
  # - インスタンスは running 状態である必要がある
  instance_name = aws_lightsail_instance.example.name

  # ================================================================================
  # オプションパラメータ
  # ================================================================================

  # リージョン
  # - このリソースを管理するリージョンを指定
  # - デフォルトはプロバイダー設定のリージョン
  # - インスタンスとロードバランサーと同じリージョンである必要がある
  # region = "us-east-1"
}

# ================================================================================
# 出力値の例
# ================================================================================

# アタッチメントID
# - 形式: "lb_name,instance_name" の組み合わせ
output "lightsail_lb_attachment_id" {
  description = "Lightsail ロードバランサーアタッチメントの ID"
  value       = aws_lightsail_lb_attachment.example.id
}

# ================================================================================
# 使用例
# ================================================================================

# 前提リソース: アベイラビリティゾーン情報
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# 前提リソース: Lightsail ロードバランサー
resource "aws_lightsail_lb" "example" {
  name              = "example-load-balancer"
  health_check_path = "/"
  instance_port     = "80"

  tags = {
    Name        = "example-load-balancer"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# 前提リソース: Lightsail インスタンス
resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = data.aws_availability_zones.available.names[0]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_3_0"

  tags = {
    Name        = "example-instance"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# ================================================================================
# 複数インスタンスをアタッチする例
# ================================================================================

# インスタンス1
resource "aws_lightsail_instance" "web_1" {
  name              = "web-instance-1"
  availability_zone = data.aws_availability_zones.available.names[0]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "small_3_0"

  tags = {
    Name = "web-instance-1"
    Role = "web-server"
  }
}

# インスタンス2
resource "aws_lightsail_instance" "web_2" {
  name              = "web-instance-2"
  availability_zone = data.aws_availability_zones.available.names[1]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "small_3_0"

  tags = {
    Name = "web-instance-2"
    Role = "web-server"
  }
}

# ロードバランサー
resource "aws_lightsail_lb" "web" {
  name              = "web-load-balancer"
  health_check_path = "/health"
  instance_port     = "80"

  tags = {
    Name = "web-load-balancer"
    Role = "web-tier"
  }
}

# アタッチメント1
resource "aws_lightsail_lb_attachment" "web_1" {
  lb_name       = aws_lightsail_lb.web.name
  instance_name = aws_lightsail_instance.web_1.name
}

# アタッチメント2
resource "aws_lightsail_lb_attachment" "web_2" {
  lb_name       = aws_lightsail_lb.web.name
  instance_name = aws_lightsail_instance.web_2.name
}

# ================================================================================
# 動的アタッチメントの例（for_each 使用）
# ================================================================================

# 複数インスタンスの定義
resource "aws_lightsail_instance" "app" {
  for_each = toset(["app-1", "app-2", "app-3"])

  name              = each.key
  availability_zone = data.aws_availability_zones.available.names[index(tolist(toset(["app-1", "app-2", "app-3"])), each.key) % length(data.aws_availability_zones.available.names)]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "medium_3_0"

  tags = {
    Name = each.key
    Tier = "application"
  }
}

# アプリケーション用ロードバランサー
resource "aws_lightsail_lb" "app" {
  name              = "app-load-balancer"
  health_check_path = "/api/health"
  instance_port     = "8080"

  tags = {
    Name = "app-load-balancer"
    Tier = "application"
  }
}

# 動的アタッチメント
resource "aws_lightsail_lb_attachment" "app" {
  for_each = aws_lightsail_instance.app

  lb_name       = aws_lightsail_lb.app.name
  instance_name = each.value.name
}

# ================================================================================
# WordPress マルチインスタンス構成の例
# ================================================================================

# 共有データベース
resource "aws_lightsail_database" "wordpress" {
  relational_database_name = "wordpress-db"
  master_database_name     = "wordpress"
  master_username          = "admin"
  master_password          = var.db_password # AWS Secrets Manager から取得推奨
  blueprint_id             = "mysql_8_0"
  bundle_id                = "micro_2_0"

  tags = {
    Name = "wordpress-database"
    App  = "wordpress"
  }
}

# WordPress インスタンス（複数）
resource "aws_lightsail_instance" "wordpress" {
  count = 2

  name              = "wordpress-${count.index + 1}"
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  blueprint_id      = "wordpress"
  bundle_id         = "medium_3_0"

  # データベース接続設定を含むユーザーデータ
  user_data = templatefile("${path.module}/wordpress-init.sh", {
    db_host     = aws_lightsail_database.wordpress.master_endpoint_address
    db_name     = aws_lightsail_database.wordpress.master_database_name
    db_user     = aws_lightsail_database.wordpress.master_username
    db_password = var.db_password
  })

  tags = {
    Name  = "wordpress-instance-${count.index + 1}"
    App   = "wordpress"
    Index = count.index
  }
}

# WordPress 用ロードバランサー
resource "aws_lightsail_lb" "wordpress" {
  name              = "wordpress-lb"
  health_check_path = "/wp-admin/install.php"
  instance_port     = "80"

  tags = {
    Name = "wordpress-load-balancer"
    App  = "wordpress"
  }
}

# WordPress インスタンスのアタッチメント
resource "aws_lightsail_lb_attachment" "wordpress" {
  count = 2

  lb_name       = aws_lightsail_lb.wordpress.name
  instance_name = aws_lightsail_instance.wordpress[count.index].name
}

# ================================================================================
# Blue/Green デプロイメントの例
# ================================================================================

# Blue 環境のインスタンス
resource "aws_lightsail_instance" "blue" {
  name              = "app-blue"
  availability_zone = data.aws_availability_zones.available.names[0]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "medium_3_0"

  tags = {
    Environment = "blue"
    Version     = "v1.0"
  }
}

# Green 環境のインスタンス（新バージョン）
resource "aws_lightsail_instance" "green" {
  name              = "app-green"
  availability_zone = data.aws_availability_zones.available.names[1]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "medium_3_0"

  tags = {
    Environment = "green"
    Version     = "v2.0"
  }
}

# ロードバランサー
resource "aws_lightsail_lb" "main" {
  name              = "app-lb"
  health_check_path = "/"
  instance_port     = "80"

  tags = {
    Name = "main-load-balancer"
  }
}

# Blue 環境のアタッチメント（変数で制御）
resource "aws_lightsail_lb_attachment" "blue" {
  count = var.use_blue ? 1 : 0

  lb_name       = aws_lightsail_lb.main.name
  instance_name = aws_lightsail_instance.blue.name
}

# Green 環境のアタッチメント（変数で制御）
resource "aws_lightsail_lb_attachment" "green" {
  count = var.use_green ? 1 : 0

  lb_name       = aws_lightsail_lb.main.name
  instance_name = aws_lightsail_instance.green.name
}

# ================================================================================
# Node.js アプリケーション（Redis セッション管理）の例
# ================================================================================

# Redis インスタンス（セッション管理用）
resource "aws_lightsail_instance" "redis" {
  name              = "redis-server"
  availability_zone = data.aws_availability_zones.available.names[0]
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_3_0"

  user_data = file("${path.module}/redis-init.sh")

  tags = {
    Name = "redis-server"
    Role = "session-store"
  }
}

# Node.js アプリケーションインスタンス
resource "aws_lightsail_instance" "nodejs" {
  count = 3

  name              = "nodejs-app-${count.index + 1}"
  availability_zone = data.aws_availability_zones.available.names[count.index % 2]
  blueprint_id      = "nodejs"
  bundle_id         = "small_3_0"

  user_data = templatefile("${path.module}/nodejs-init.sh", {
    redis_host = aws_lightsail_instance.redis.private_ip_address
  })

  tags = {
    Name  = "nodejs-app-${count.index + 1}"
    Tier  = "application"
    Index = count.index
  }
}

# Node.js 用ロードバランサー
resource "aws_lightsail_lb" "nodejs" {
  name              = "nodejs-lb"
  health_check_path = "/health"
  instance_port     = "3000"

  tags = {
    Name = "nodejs-load-balancer"
    Tier = "application"
  }
}

# Node.js インスタンスのアタッチメント
resource "aws_lightsail_lb_attachment" "nodejs" {
  count = 3

  lb_name       = aws_lightsail_lb.nodejs.name
  instance_name = aws_lightsail_instance.nodejs[count.index].name
}

# ================================================================================
# トラブルシューティング
# ================================================================================

# 問題1: アタッチメントが失敗する
# 原因: インスタンスがヘルスチェックに応答していない
# 解決策:
# - インスタンス上でヘルスチェックパスにアクセス可能か確認
# - セキュリティグループでポートが開いているか確認
# - インスタンスのファイアウォール設定を確認
# - ヘルスチェックパスが正しく設定されているか確認

# 問題2: インスタンス削除時にエラーが発生
# 原因: アタッチメントが残っている状態でインスタンスを削除しようとした
# 解決策:
# - depends_on を使用して削除順序を制御
# - または明示的にアタッチメントを先に削除してからインスタンスを削除

# 問題3: 複数リージョンでのデプロイ
# 原因: Lightsail ロードバランサーはリージョン固有のリソース
# 解決策:
# - 各リージョンごとに別々のロードバランサーとアタッチメントを作成
# - region パラメータまたはプロバイダーエイリアスを使用

# 問題4: インスタンスが "Instance is not in running state" エラー
# 原因: インスタンスが起動していない
# 解決策:
# - depends_on を使用してインスタンスの起動を待機
# - インスタンスの状態を確認: aws lightsail get-instance --instance-name {name}

# ================================================================================
# セキュリティ考慮事項
# ================================================================================

# 1. ネットワーク分離
#    - インスタンスとロードバランサーを適切なネットワークに配置
#    - 必要なポートのみを開放
#    - ファイアウォールルールを適切に設定

# 2. ヘルスチェック設定
#    - ヘルスチェックパスは認証不要なエンドポイントを使用
#    - 機密情報を含まないレスポンスを返すように設定
#    - ヘルスチェック間隔を適切に設定

# 3. モニタリング
#    - CloudWatch メトリクスでヘルスステータスを監視
#    - アラームを設定して異常を早期検知
#    - ログを収集して問題を追跡

# 4. アクセス制御
#    - IAM ポリシーで適切なアクセス権限を設定
#    - 最小権限の原則に従う
#    - タグを使用してリソースを整理・管理

# ================================================================================
# インポート
# ================================================================================

# 既存の Lightsail ロードバランサーアタッチメントをインポート可能
#
# 構文:
# terraform import aws_lightsail_lb_attachment.example {lb_name},{instance_name}
#
# 例:
# terraform import aws_lightsail_lb_attachment.example my-load-balancer,my-instance
# terraform import aws_lightsail_lb_attachment.web production-lb,web-server-1
#
# 複数のアタッチメントをインポート:
# terraform import aws_lightsail_lb_attachment.web[0] production-lb,web-server-1
# terraform import aws_lightsail_lb_attachment.web[1] production-lb,web-server-2

# ================================================================================
# デバッグコマンド
# ================================================================================

# ロードバランサーの状態確認:
# aws lightsail get-load-balancer --load-balancer-name my-lb

# アタッチされたインスタンスの確認:
# aws lightsail get-load-balancer \
#   --load-balancer-name my-lb \
#   --query 'loadBalancer.instanceHealthSummary'

# インスタンスのヘルスチェック状態:
# aws lightsail get-instance-health \
#   --load-balancer-name my-lb \
#   --query 'instanceHealthSummary[*].[instanceName,instanceHealth,healthCheckPath]'

# インスタンスの状態確認:
# aws lightsail get-instance \
#   --instance-name web-server-1 \
#   --query 'instance.state.name'

# ================================================================================
# 制約事項
# ================================================================================

# 1. リージョンの制限
#    - インスタンスとロードバランサーは同じリージョンに存在する必要がある
#    - 異なる AWS リージョンのインスタンスは使用不可

# 2. アタッチメント数
#    - 1 つのロードバランサーに複数のインスタンスをアタッチ可能
#    - 1 つのインスタンスは 1 つのロードバランサーにのみアタッチ可能

# 3. インスタンスの状態
#    - アタッチできるのは実行中（running）のインスタンスのみ
#    - 停止中や削除されたインスタンスはアタッチ不可

# 4. アプリケーション設定
#    - ステートフルなアプリケーションは外部セッションストアが必要
#    - ローカルファイルシステムへの書き込みは推奨されない
#    - 各インスタンスから接続可能な共有データベースを使用

# ================================================================================
# 関連リソース
# ================================================================================

# - aws_lightsail_lb: ロードバランサー本体の作成
# - aws_lightsail_instance: アタッチ対象のインスタンス
# - aws_lightsail_lb_certificate: HTTPS 用の SSL/TLS 証明書
# - aws_lightsail_lb_certificate_attachment: 証明書のアタッチメント
# - aws_lightsail_database: 共有データベース
# - aws_lightsail_bucket: 静的ファイル用のオブジェクトストレージ

# ================================================================================
# 参考リンク
# ================================================================================

# Terraform AWS Provider - aws_lightsail_lb_attachment:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_lb_attachment

# AWS Lightsail - ロードバランサーの理解:
# https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-lightsail-load-balancers.html

# AWS Lightsail - インスタンスをロードバランサー用に設定:
# https://docs.aws.amazon.com/lightsail/latest/userguide/configure-lightsail-instances-for-load-balancing.html

# AWS API - AttachInstancesToLoadBalancer:
# https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_AttachInstancesToLoadBalancer.html
