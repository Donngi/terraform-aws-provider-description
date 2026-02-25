#---------------------------------------------------------------
# Amazon VPC Lattice Target Group
#
# VPC Lattice のターゲットグループを管理するリソースです。
# ターゲットグループはトラフィックの転送先となるエンドポイントの
# コレクションであり、EC2 インスタンス、Lambda 関数、IP アドレス、
# または ALB をターゲットとして登録できます。
#
# AWS Documentation:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/target-groups.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_target_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
#
# NOTE: このテンプレートは参考例です。実際の環境に応じて
# 設定値を調整してください。
#---------------------------------------------------------------

resource "aws_vpclattice_target_group" "example" {
  #-------------------------------------------------------------
  # ターゲットグループ基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ターゲットグループの名前
  # 設定可能な値: 3〜128文字の英数字またはハイフン（先頭・末尾はハイフン不可）
  # 省略時: 必須のため省略不可
  name = "example-target-group"

  # type (Required)
  # 設定内容: ターゲットグループのターゲットタイプ
  # 設定可能な値: INSTANCE（EC2 インスタンス）、IP（IP アドレス）、
  #              LAMBDA（Lambda 関数）、ALB（Application Load Balancer）
  # 省略時: 必須のため省略不可
  type = "INSTANCE"

  #-------------------------------------------------------------
  # ターゲットグループ詳細設定
  #-------------------------------------------------------------

  # config (Optional)
  # 設定内容: ターゲットグループの詳細設定
  # 設定可能な値: ポート、プロトコル、VPC、ヘルスチェックなどのサブブロックで構成
  # 省略時: デフォルト値が適用される（LAMBDA タイプの場合はこのブロックは省略可能）
  config {
    # port (Optional)
    # 設定内容: ターゲットへのトラフィックをルーティングするポート番号
    # 設定可能な値: 1〜65535 の整数
    # 省略時: Terraform がデフォルト値を設定
    port = 80

    # protocol (Optional)
    # 設定内容: ターゲットへのトラフィックに使用するプロトコル
    # 設定可能な値: HTTP、HTTPS、TCP
    # 省略時: Terraform がデフォルト値を設定
    protocol = "HTTP"

    # protocol_version (Optional)
    # 設定内容: ターゲットへのトラフィックに使用するプロトコルバージョン
    # 設定可能な値: HTTP1（HTTP/1.1）、HTTP2（HTTP/2）、GRPC（gRPC）
    # 省略時: Terraform がデフォルト値を設定
    protocol_version = "HTTP1"

    # ip_address_type (Optional)
    # 設定内容: IP タイプのターゲットグループで使用する IP アドレスタイプ
    # 設定可能な値: IPV4（IPv4 アドレス）、IPV6（IPv6 アドレス）
    # 省略時: Terraform がデフォルト値を設定（type が IP の場合に有効）
    ip_address_type = "IPV4"

    # lambda_event_structure_version (Optional)
    # 設定内容: Lambda ターゲットに送信されるイベント構造のバージョン
    # 設定可能な値: V1（バージョン 1）、V2（バージョン 2）
    # 省略時: Terraform がデフォルト値を設定（type が LAMBDA の場合に有効）
    # lambda_event_structure_version = "V2"

    # vpc_identifier (Optional)
    # 設定内容: ターゲットグループが属する VPC の ID
    # 設定可能な値: VPC ID（vpc-xxxxxxxx 形式）
    # 省略時: 省略可能（LAMBDA タイプの場合は指定不要）
    vpc_identifier = "vpc-0123456789abcdef0"

    #-----------------------------------------------------------
    # ヘルスチェック設定
    #-----------------------------------------------------------

    # health_check (Optional)
    # 設定内容: ターゲットのヘルスチェック設定
    # 設定可能な値: 有効化フラグ、チェック間隔、タイムアウト、しきい値などのサブ属性で構成
    # 省略時: デフォルトのヘルスチェック設定が適用される（LAMBDA タイプは非対応）
    health_check {
      # enabled (Optional)
      # 設定内容: ヘルスチェックの有効・無効フラグ
      # 設定可能な値: true（有効）、false（無効）
      # 省略時: true
      enabled = true

      # health_check_interval_seconds (Optional)
      # 設定内容: ヘルスチェックを実行する間隔（秒）
      # 設定可能な値: 5〜300 の整数
      # 省略時: 30
      health_check_interval_seconds = 30

      # health_check_timeout_seconds (Optional)
      # 設定内容: ヘルスチェックのタイムアウト時間（秒）
      # 設定可能な値: 1〜120 の整数
      # 省略時: 5
      health_check_timeout_seconds = 5

      # healthy_threshold_count (Optional)
      # 設定内容: ターゲットを正常と判断するために必要な連続成功回数
      # 設定可能な値: 2〜10 の整数
      # 省略時: 5
      healthy_threshold_count = 3

      # unhealthy_threshold_count (Optional)
      # 設定内容: ターゲットを異常と判断するために必要な連続失敗回数
      # 設定可能な値: 2〜10 の整数
      # 省略時: 2
      unhealthy_threshold_count = 3

      # path (Optional)
      # 設定内容: ヘルスチェックリクエストの送信先パス
      # 設定可能な値: "/" で始まる URL パス（最大 1024 文字）
      # 省略時: "/"
      path = "/health"

      # protocol (Optional)
      # 設定内容: ヘルスチェックに使用するプロトコル
      # 設定可能な値: HTTP、HTTPS
      # 省略時: Terraform がデフォルト値を設定
      protocol = "HTTP"

      # protocol_version (Optional)
      # 設定内容: ヘルスチェックに使用するプロトコルバージョン
      # 設定可能な値: HTTP1（HTTP/1.1）、HTTP2（HTTP/2）
      # 省略時: HTTP1
      protocol_version = "HTTP1"

      # port (Optional)
      # 設定内容: ヘルスチェックリクエストを送信するポート番号
      # 設定可能な値: 1〜65535 の整数
      # 省略時: Terraform がデフォルト値を設定（traffic-port を使用）
      port = 80

      # matcher (Optional)
      # 設定内容: ヘルスチェック成功とみなす HTTP レスポンスコードの範囲
      # 設定可能な値: value にカンマ区切りまたは範囲指定の HTTP ステータスコードを指定
      # 省略時: "200" のみ成功とみなす
      matcher {
        # value (Optional)
        # 設定内容: 成功とみなす HTTP ステータスコードのパターン
        # 設定可能な値: "200"、"200,202"、"200-299" などのコードまたは範囲
        # 省略時: 省略可能
        value = "200"
      }
    }
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: AWS リージョンコード（us-east-1、ap-northeast-1 など）
  # 省略時: プロバイダー設定のリージョン
  # 関連機能: AWS Regions - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし（プロバイダーの default_tags は適用される）
  # 関連機能: AWS Resource Tagging - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-vpclattice-target-group"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all は computed なので設定不要
  # provider の default_tags と tags がマージされた結果

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間
    # 設定可能な値: "Xm"（分）、"Xh"（時間）などの期間文字列
    # 省略時: プロバイダーのデフォルト値
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間
    # 設定可能な値: "Xm"（分）、"Xh"（時間）などの期間文字列
    # 省略時: プロバイダーのデフォルト値
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間
    # 設定可能な値: "Xm"（分）、"Xh"（時間）などの期間文字列
    # 省略時: プロバイダーのデフォルト値
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#
# 以下の属性は Terraform によって自動的に設定されます（computed-only）
#
# - id: ターゲットグループの ID
# - arn: ターゲットグループの ARN
#   例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:targetgroup/tg-0123456789abcdef0
# - status: ターゲットグループのステータス（ACTIVE、CREATE_IN_PROGRESS など）
# - tags_all: provider の default_tags と tags がマージされた全タグのマップ
#---------------------------------------------------------------
