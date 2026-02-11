# ================================================================================
# Resource: aws_lightsail_instance
# Provider Version: 6.28.0
# Generated: 2026-01-28
# ================================================================================
# Amazon Lightsail仮想プライベートサーバー（VPS）インスタンスを管理するリソース。
# 事前にソフトウェアがセットアップされた使いやすい仮想サーバーを作成します。
#
# 注意: Lightsailは現在、限られたAWSリージョンでのみサポートされています。
# 詳細は以下を参照してください:
# https://lightsail.aws.amazon.com/ls/docs/overview/article/understanding-regions-and-availability-zones-in-amazon-lightsail
#
# 公式ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_instance
# https://docs.aws.amazon.com/lightsail/latest/userguide/what-is-lightsail.html
# ================================================================================

resource "aws_lightsail_instance" "example" {
  # ============================================================
  # 必須パラメータ (Required Parameters)
  # ============================================================

  # ------------------------------------------------------------
  # name - インスタンス名
  # ------------------------------------------------------------
  # Type: string
  # Required: Yes
  #
  # Lightsailインスタンスの名前。
  # 名前は、LightsailアカウントのAWSリージョンごとに一意である必要があります。
  #
  # 参考:
  # - インスタンス名は英数字、ダッシュ、アンダースコアを使用可能
  # - 同じリージョン内で重複する名前は使用不可
  name = "example-lightsail-instance"

  # ------------------------------------------------------------
  # availability_zone - アベイラビリティーゾーン
  # ------------------------------------------------------------
  # Type: string
  # Required: Yes
  #
  # インスタンスを作成するアベイラビリティーゾーン。
  # 利用可能なゾーンのリストは以下のAWS CLIコマンドで取得できます:
  # aws lightsail get-regions --include-availability-zones
  #
  # 参考:
  # - 各リージョンには複数のアベイラビリティーゾーンがあります
  # - フォールトトレランスのため、複数のゾーンにインスタンスを分散することを推奨
  # - 例: us-east-1a, us-east-1b, ap-northeast-1a など
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-regions-and-availability-zones-in-amazon-lightsail.html
  availability_zone = "us-east-1a"

  # ------------------------------------------------------------
  # blueprint_id - ブループリントID
  # ------------------------------------------------------------
  # Type: string
  # Required: Yes
  #
  # 仮想プライベートサーバーイメージのID。
  # 利用可能なブループリントIDのリストは以下のAWS CLIコマンドで取得できます:
  # aws lightsail get-blueprints
  #
  # ブループリントの種類:
  # - OSのみ: amazon_linux_2, ubuntu_20_04, debian_10, centos_7 など
  # - アプリケーション付き: wordpress, lamp_8, nodejs, mean, drupal など
  #
  # 参考:
  # - ブループリントにはOSとプリインストールされたソフトウェアが含まれます
  # - アプリケーションブループリントを使用すると、設定済みのスタックを迅速にデプロイ可能
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_CreateInstances.html
  blueprint_id = "amazon_linux_2"

  # ------------------------------------------------------------
  # bundle_id - バンドルID
  # ------------------------------------------------------------
  # Type: string
  # Required: Yes
  #
  # 仕様情報のバンドル（インスタンスタイプ）。
  # 利用可能なバンドルIDのリストは以下のAWS CLIコマンドで取得できます:
  # aws lightsail get-bundles
  #
  # バンドルの例:
  # - nano_3_0: 0.5 GB RAM, 1 vCPU, 20 GB SSD
  # - micro_3_0: 1 GB RAM, 1 vCPU, 40 GB SSD
  # - small_3_0: 2 GB RAM, 1 vCPU, 60 GB SSD
  # - medium_3_0: 4 GB RAM, 2 vCPU, 80 GB SSD
  # - large_3_0: 8 GB RAM, 2 vCPU, 160 GB SSD
  #
  # 参考:
  # - バンドルはCPU、メモリ、ストレージ、データ転送量を定義します
  # - 必要なリソースに応じて適切なバンドルを選択してください
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_CreateInstances.html
  bundle_id = "nano_3_0"

  # ============================================================
  # オプションパラメータ (Optional Parameters)
  # ============================================================

  # ------------------------------------------------------------
  # key_pair_name - キーペア名
  # ------------------------------------------------------------
  # Type: string
  # Required: No
  #
  # SSHアクセス用のキーペア名。
  # Lightsailコンソールで作成されたキーペアを使用します。
  #
  # 注意:
  # - 現時点では、aws_key_pair リソースは使用できません
  # - Lightsail専用のキーペアを使用する必要があります
  # - キーペアは事前にLightsailコンソールまたはCLIで作成しておく必要があります
  #
  # 参考:
  # - キーペアを指定しない場合、Lightsailがデフォルトのキーペアを使用します
  # - セキュリティ強化のため、独自のキーペアを使用することを推奨
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/lightsail/latest/userguide/lightsail-how-to-set-up-ssh.html
  key_pair_name = "my-lightsail-key"

  # ------------------------------------------------------------
  # ip_address_type - IPアドレスタイプ
  # ------------------------------------------------------------
  # Type: string
  # Required: No
  # Default: "dualstack"
  # Valid Values: "dualstack", "ipv4", "ipv6"
  #
  # LightsailインスタンスのIPアドレスタイプ。
  #
  # 設定値:
  # - dualstack: IPv4とIPv6の両方を有効化（デフォルト）
  # - ipv4: IPv4のみを有効化
  # - ipv6: IPv6のみを有効化
  #
  # 参考:
  # - デュアルスタックを使用すると、IPv4とIPv6の両方でインスタンスにアクセス可能
  # - IPv6のみのサポートが必要な場合は "ipv6" を指定
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_CreateInstances.html
  ip_address_type = "dualstack"

  # ------------------------------------------------------------
  # user_data - ユーザーデータ
  # ------------------------------------------------------------
  # Type: string
  # Required: No
  #
  # 追加のユーザーデータでサーバーを設定するための単一行の起動スクリプト。
  #
  # ユーザーデータの用途:
  # - インスタンス起動時の自動設定
  # - ソフトウェアのインストール
  # - 設定ファイルの配置
  # - スクリプトの実行
  #
  # パッケージマネージャーの例:
  # - Amazon Linux, CentOS: yum
  # - Debian, Ubuntu: apt-get
  # - FreeBSD: pkg
  #
  # 参考:
  # - ユーザーデータはインスタンス起動時に一度だけ実行されます
  # - スクリプトは単一行の文字列として指定します
  # - 複雑なスクリプトの場合は、heredoc構文を使用することも可能
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_InstanceEntry.html
  user_data = "sudo yum install -y httpd && sudo systemctl start httpd && sudo systemctl enable httpd && echo '<h1>Deployed via Terraform</h1>' | sudo tee /var/www/html/index.html"

  # ------------------------------------------------------------
  # region - リージョン
  # ------------------------------------------------------------
  # Type: string
  # Required: No
  # Computed: Yes
  #
  # このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 参考:
  # - 通常はプロバイダーレベルでリージョンを設定します
  # - 複数リージョンにリソースを作成する場合は、明示的に指定可能
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ------------------------------------------------------------
  # tags - タグ
  # ------------------------------------------------------------
  # Type: map(string)
  # Required: No
  #
  # リソースに割り当てるタグのマップ。
  # キーのみのタグを作成するには、値として空文字列を使用します。
  #
  # 注意:
  # - プロバイダーの default_tags 設定ブロックが存在する場合、
  #   一致するキーを持つタグはプロバイダーレベルで定義されたものを上書きします
  #
  # タグのベストプラクティス:
  # - Environment: 環境を識別（dev, staging, prod など）
  # - Project: プロジェクト名
  # - Owner: 所有者またはチーム名
  # - CostCenter: コストセンターまたは部門
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Environment = "production"
    Project     = "web-server"
    ManagedBy   = "terraform"
  }

  # ============================================================
  # ブロック設定 (Block Configuration)
  # ============================================================

  # ------------------------------------------------------------
  # add_on - アドオン設定
  # ------------------------------------------------------------
  # Type: list(object)
  # Required: No
  # Max Items: 1
  #
  # インスタンスのアドオン設定。
  # 現在サポートされているアドオンタイプは AutoSnapshot のみです。
  #
  # 自動スナップショットの利点:
  # - 定期的なバックアップの自動化
  # - データの保護と災害復旧
  # - インスタンスの状態を特定の時点に復元可能
  #
  # AWS Docs:
  # https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-configuring-automatic-snapshots.html
  add_on {
    # ----------------------------------------------------------
    # type - アドオンタイプ
    # ----------------------------------------------------------
    # Type: string
    # Required: Yes
    # Valid Values: "AutoSnapshot"
    #
    # アドオンタイプ。現在、AutoSnapshot のみが有効な値です。
    type = "AutoSnapshot"

    # ----------------------------------------------------------
    # snapshot_time - スナップショット時刻
    # ----------------------------------------------------------
    # Type: string
    # Required: Yes
    # Format: HH:00
    #
    # 自動スナップショットが作成される毎日の時刻。
    # - HH:00 形式で指定（1時間単位）
    # - 協定世界時（UTC）で指定
    # - スナップショットは指定時刻から最大45分後までの間に自動作成されます
    #
    # 例: "06:00"（UTC午前6時）、"18:00"（UTC午後6時）
    #
    # 参考:
    # - 業務時間外の時刻を選択することを推奨
    # - UTCとローカルタイムゾーンの時差に注意してください
    snapshot_time = "06:00"

    # ----------------------------------------------------------
    # status - ステータス
    # ----------------------------------------------------------
    # Type: string
    # Required: Yes
    # Valid Values: "Enabled", "Disabled"
    #
    # アドオンのステータス。
    # - Enabled: 自動スナップショットを有効化
    # - Disabled: 自動スナップショットを無効化
    #
    # 参考:
    # - 本番環境では Enabled を推奨
    # - 開発環境ではコスト削減のため Disabled も検討可能
    status = "Enabled"
  }

  # ============================================================
  # 計算属性 (Computed Attributes)
  # ============================================================
  # 以下の属性はTerraformによって自動的に計算され、参照可能です:
  #
  # arn                - LightsailインスタンスのARN（idと同じ）
  # cpu_count          - インスタンスが持つvCPUの数
  # created_at         - インスタンスが作成されたタイムスタンプ
  # id                 - LightsailインスタンスのARN（arnと同じ）
  # ipv6_addresses     - LightsailインスタンスのIPv6アドレスのリスト
  # is_static_ip       - このインスタンスに静的IPが割り当てられているかどうか
  # private_ip_address - インスタンスのプライベートIPアドレス
  # public_ip_address  - インスタンスのパブリックIPアドレス
  # ram_size           - インスタンスのRAM容量（GB単位、例: 1.0）
  # tags_all           - プロバイダーの default_tags から継承されたものを含む、
  #                      リソースに割り当てられたタグのマップ
  # username           - インスタンスへの接続用ユーザー名（例: ec2-user）
  #
  # 使用例:
  # output "instance_public_ip" {
  #   value = aws_lightsail_instance.example.public_ip_address
  # }
  #
  # output "instance_username" {
  #   value = aws_lightsail_instance.example.username
  # }
}

# ================================================================================
# 使用例とベストプラクティス
# ================================================================================

# ------------------------------------------------------------
# 例1: 基本的なLightsailインスタンス
# ------------------------------------------------------------
# シンプルなWebサーバーとして使用する最小構成の例
#
# resource "aws_lightsail_instance" "basic" {
#   name              = "basic-web-server"
#   availability_zone = "us-east-1a"
#   blueprint_id      = "amazon_linux_2"
#   bundle_id         = "nano_3_0"
# }

# ------------------------------------------------------------
# 例2: WordPressブループリントを使用
# ------------------------------------------------------------
# 事前設定されたWordPressスタックをデプロイする例
#
# resource "aws_lightsail_instance" "wordpress" {
#   name              = "wordpress-blog"
#   availability_zone = "ap-northeast-1a"
#   blueprint_id      = "wordpress"
#   bundle_id         = "small_3_0"
#   key_pair_name     = "my-wordpress-key"
#
#   tags = {
#     Application = "WordPress"
#     Environment = "production"
#   }
# }

# ------------------------------------------------------------
# 例3: カスタムユーザーデータでNginxをインストール
# ------------------------------------------------------------
# 起動時にNginxをインストールして設定する例
#
# resource "aws_lightsail_instance" "nginx" {
#   name              = "nginx-server"
#   availability_zone = "us-west-2a"
#   blueprint_id      = "ubuntu_20_04"
#   bundle_id         = "micro_3_0"
#
#   user_data = <<-EOF
#     #!/bin/bash
#     apt-get update
#     apt-get install -y nginx
#     systemctl start nginx
#     systemctl enable nginx
#     echo '<h1>Hello from Lightsail!</h1>' > /var/www/html/index.html
#   EOF
#
#   tags = {
#     Server = "Nginx"
#   }
# }

# ------------------------------------------------------------
# 例4: 複数のアベイラビリティーゾーンに分散
# ------------------------------------------------------------
# 高可用性のため複数のゾーンにインスタンスを配置する例
#
# resource "aws_lightsail_instance" "web_az1" {
#   name              = "web-server-az1"
#   availability_zone = "us-east-1a"
#   blueprint_id      = "amazon_linux_2"
#   bundle_id         = "small_3_0"
#
#   add_on {
#     type          = "AutoSnapshot"
#     snapshot_time = "06:00"
#     status        = "Enabled"
#   }
# }
#
# resource "aws_lightsail_instance" "web_az2" {
#   name              = "web-server-az2"
#   availability_zone = "us-east-1b"
#   blueprint_id      = "amazon_linux_2"
#   bundle_id         = "small_3_0"
#
#   add_on {
#     type          = "AutoSnapshot"
#     snapshot_time = "06:00"
#     status        = "Enabled"
#   }
# }

# ------------------------------------------------------------
# 例5: IPv4のみのインスタンス
# ------------------------------------------------------------
# IPv6が不要な場合、IPv4のみを使用する例
#
# resource "aws_lightsail_instance" "ipv4_only" {
#   name              = "ipv4-server"
#   availability_zone = "eu-west-1a"
#   blueprint_id      = "debian_10"
#   bundle_id         = "nano_3_0"
#   ip_address_type   = "ipv4"
# }

# ================================================================================
# 関連リソース
# ================================================================================
# Lightsailインスタンスと組み合わせて使用できる関連リソース:
#
# - aws_lightsail_static_ip: 静的IPアドレスの割り当て
# - aws_lightsail_static_ip_attachment: 静的IPのアタッチ
# - aws_lightsail_instance_public_ports: ファイアウォールルールの設定
# - aws_lightsail_domain: ドメインの管理
# - aws_lightsail_lb: ロードバランサーの作成
# - aws_lightsail_lb_attachment: ロードバランサーへのインスタンスのアタッチ
# - aws_lightsail_disk: 追加ストレージディスクの作成
# - aws_lightsail_disk_attachment: ディスクのアタッチ
#
# ================================================================================
# 重要な注意事項
# ================================================================================
# 1. リージョンの制限:
#    - Lightsailは限られたAWSリージョンでのみ利用可能です
#    - 使用前にサポートされているリージョンを確認してください
#
# 2. キーペア管理:
#    - aws_key_pair リソースは使用できません
#    - Lightsailコンソールまたはaws lightsail create-key-pair CLIコマンドで
#      キーペアを事前に作成する必要があります
#
# 3. 自動スナップショット:
#    - 本番環境では自動スナップショットの有効化を強く推奨します
#    - スナップショットには追加の料金が発生します
#    - スナップショット時刻はUTCで指定されます
#
# 4. ユーザーデータ:
#    - ユーザーデータスクリプトはインスタンス起動時に一度だけ実行されます
#    - 複数行のスクリプトはheredoc構文（<<-EOF ... EOF）を使用できます
#    - スクリプトのログは /var/log/cloud-init.log で確認できます
#
# 5. ネットワーキング:
#    - デフォルトではHTTP/HTTPS/SSHポートが開いています
#    - カスタムポート設定には aws_lightsail_instance_public_ports を使用
#
# 6. 料金:
#    - Lightsailは月額固定料金制（バンドルに基づく）
#    - データ転送量の超過には追加料金が発生します
#    - スナップショットとディスクには別途料金がかかります
#
# ================================================================================
