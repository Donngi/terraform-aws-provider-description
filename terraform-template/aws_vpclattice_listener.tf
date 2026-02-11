#---------------------------------------------------------------
# Amazon VPC Lattice Listener
#
# VPC Lattice サービスのリスナーを管理するリソースです。
# リスナーは、指定されたプロトコルとポートを使用して
# 接続リクエストをチェックし、ルールに基づいて
# ターゲットグループにトラフィックをルーティングします。
#
# AWS Documentation:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/listeners.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_listener
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートは参考例です。実際の環境に応じて
# 設定値を調整してください。
#---------------------------------------------------------------

resource "aws_vpclattice_listener" "example" {
  #-------------------------------------------------------------
  # Required Settings
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: リスナーの名前
  # 設定可能な値: 英小文字（a-z）、数字（0-9）、ハイフン（-）を使用可能。先頭と末尾、連続したハイフンは使用不可。サービス内で一意である必要がある。
  # 省略時: 必須のため省略不可
  name = "example-listener"

  # protocol (Required, Forces new resource)
  # 設定内容: リスナーが使用するプロトコル
  # 設定可能な値: HTTP、HTTPS、TLS_PASSTHROUGH
  # 省略時: 必須のため省略不可
  # 関連機能: HTTP Listeners - https://docs.aws.amazon.com/vpc-lattice/latest/ug/http-listeners.html
  # 関連機能: HTTPS Listeners - https://docs.aws.amazon.com/vpc-lattice/latest/ug/https-listeners.html
  # 関連機能: TLS Listeners - https://docs.aws.amazon.com/vpc-lattice/latest/ug/tls-listeners.html
  protocol = "HTTPS"

  #-------------------------------------------------------------
  # Service Identification (Required - One of service_arn or service_identifier)
  #-------------------------------------------------------------

  # service_identifier (Optional)
  # 設定内容: VPC Lattice サービスの ID
  # 設定可能な値: VPC Lattice サービスの ID
  # 省略時: service_arn を使用する場合は省略可能（どちらか一方は必須）
  service_identifier = "svc-0123456789abcdef0"

  # service_arn (Optional)
  # 設定内容: VPC Lattice サービスの ARN
  # 設定可能な値: VPC Lattice サービスの完全な ARN
  # 省略時: service_identifier を使用する場合は省略可能（どちらか一方は必須）
  # service_arn = "arn:aws:vpc-lattice:ap-northeast-1:123456789012:service/svc-0123456789abcdef0"

  #-------------------------------------------------------------
  # Default Action (Required)
  #-------------------------------------------------------------

  # default_action (Required)
  # 設定内容: デフォルトリスナールールのアクション
  # 設定可能な値: fixed_response または forward のいずれか一方を指定
  default_action {
    # forward - ターゲットグループへのトラフィック転送
    forward {
      # target_groups (Required)
      # 設定内容: トラフィックを転送するターゲットグループ
      # 複数指定して重み付けによる負荷分散が可能
      target_groups {
        # target_group_identifier (Required)
        # 設定内容: ターゲットグループの ID または ARN
        # 設定可能な値: ターゲットグループの ID または ARN
        target_group_identifier = "tg-0123456789abcdef0"

        # weight (Optional)
        # 設定内容: ターゲットグループへのトラフィック分散の重み
        # 設定可能な値: 0～999 の整数
        # 省略時: 100
        # 関連機能: Listener Rules - https://docs.aws.amazon.com/vpc-lattice/latest/ug/listeners.html#listener-rules
        weight = 100
      }

      # 複数のターゲットグループを指定する例（重み付け分散）
      # target_groups {
      #   target_group_identifier = "tg-1111111111111111"
      #   weight                  = 80
      # }
      # target_groups {
      #   target_group_identifier = "tg-2222222222222222"
      #   weight                  = 20
      # }
    }

    # fixed_response - 固定レスポンスを返す（forward と排他的）
    # fixed_response {
    #   # status_code (Required)
    #   # 設定内容: 返却するカスタム HTTP ステータスコード
    #   # 設定可能な値: HTTP ステータスコード（例: 404、503）
    #   # 関連機能: Listeners - https://docs.aws.amazon.com/vpc-lattice/latest/ug/listeners.html
    #   status_code = 404
    # }
  }

  #-------------------------------------------------------------
  # Optional Settings
  #-------------------------------------------------------------

  # port (Optional, Forces new resource)
  # 設定内容: リスナーが接続を受け付けるポート番号
  # 設定可能な値: 1～65535
  # 省略時: HTTP の場合は 80、HTTPS の場合は 443
  port = 443

  # region (Optional)
  # 設定内容: リソースを管理するリージョン
  # 設定可能な値: AWS リージョンコード（us-east-1、ap-northeast-1 など）
  # 省略時: プロバイダー設定のリージョン
  # 関連機能: AWS Regions - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "ap-northeast-1"

  #-------------------------------------------------------------
  # Tagging
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし（プロバイダーの default_tags は適用される）
  # 関連機能: AWS Resource Tagging - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-listener"
    Environment = "production"
    Protocol    = "HTTPS"
  }

  # tags_all は computed なので設定不要
  # provider の default_tags と tags がマージされた結果

  #-------------------------------------------------------------
  # Timeouts (Optional)
  #-------------------------------------------------------------

  # timeouts {
  #   # create (Optional)
  #   # 設定内容: リソース作成のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値
  #   create = "30m"
  #
  #   # update (Optional)
  #   # 設定内容: リソース更新のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値
  #   update = "30m"
  #
  #   # delete (Optional)
  #   # 設定内容: リソース削除のタイムアウト時間
  #   # 設定可能な値: 時間文字列（例: "30m", "1h"）
  #   # 省略時: デフォルトのタイムアウト値
  #   delete = "30m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#
# 以下の属性は Terraform によって自動的に設定されます（computed-only）
#
# - id: リスナーの ID（通常は listener_id と同じ）
# - arn: リスナーの ARN
#   例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:service/svc-0123456789abcdef0/listener/listener-0123456789abcdef0
# - listener_id: リスナーのスタンドアロン ID
#   例: listener-0123456789abcdef0
# - created_at: リスナーが作成された日時（ISO-8601 形式）
#   例: 2026-02-09T12:34:56Z
# - last_updated_at: リスナーが最後に更新された日時（ISO-8601 形式）
#   例: 2026-02-09T15:00:00Z
#
# 参照例:
# output "listener_arn" {
#   value = aws_vpclattice_listener.example.arn
# }
#
# output "listener_id" {
#   value = aws_vpclattice_listener.example.listener_id
# }
#---------------------------------------------------------------

#---------------------------------------------------------------
# Additional Examples
#---------------------------------------------------------------

# Example: HTTP Listener with Fixed Response
# resource "aws_vpclattice_listener" "http_example" {
#   name               = "http-listener"
#   protocol           = "HTTP"
#   port               = 80
#   service_identifier = aws_vpclattice_service.example.id
#
#   default_action {
#     fixed_response {
#       status_code = 404
#     }
#   }
# }

# Example: TLS_PASSTHROUGH Listener
# resource "aws_vpclattice_listener" "tls_passthrough_example" {
#   name               = "tls-passthrough-listener"
#   protocol           = "TLS_PASSTHROUGH"
#   port               = 443
#   service_identifier = aws_vpclattice_service.example.id
#
#   default_action {
#     forward {
#       target_groups {
#         target_group_identifier = aws_vpclattice_target_group.tcp_example.id
#       }
#     }
#   }
# }
