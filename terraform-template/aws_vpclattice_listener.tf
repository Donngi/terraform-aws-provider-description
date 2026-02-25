#---------------------------------------------------------------
# Amazon VPC Lattice Listener
#
# VPC Lattice サービスのリスナーを管理するリソースです。
# リスナーは受信トラフィックを受け付けるポートとプロトコルを定義し、
# デフォルトアクションとしてターゲットグループへの転送や
# 固定レスポンスを設定できます。
#
# AWS Documentation:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/listeners.html
#
# Terraform Registry:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_listener
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
#
# NOTE: このテンプレートは参考例です。実際の環境に応じて
# 設定値を調整してください。
#---------------------------------------------------------------

resource "aws_vpclattice_listener" "example" {
  #-------------------------------------------------------------
  # サービス識別子
  #-------------------------------------------------------------

  # service_identifier (Optional)
  # 設定内容: リスナーを作成するサービスの ID または ARN
  # 設定可能な値: VPC Lattice サービスの ID（svc-xxxxxxxx）または ARN
  # 省略時: service_arn との組み合わせで指定可能
  # 関連機能: VPC Lattice Service - https://docs.aws.amazon.com/vpc-lattice/latest/ug/services.html
  service_identifier = "svc-0123456789abcdef0"

  # service_arn (Optional)
  # 設定内容: リスナーを作成するサービスの ARN
  # 設定可能な値: VPC Lattice サービスの ARN
  # 省略時: service_identifier との組み合わせで指定可能
  # 関連機能: VPC Lattice Service - https://docs.aws.amazon.com/vpc-lattice/latest/ug/services.html
  service_arn = null # "arn:aws:vpc-lattice:ap-northeast-1:123456789012:service/svc-0123456789abcdef0"

  #-------------------------------------------------------------
  # リスナー設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リスナーの名前
  # 設定可能な値: 3〜63文字の英数字またはハイフン（先頭・末尾はハイフン不可）
  # 省略時: 必須のため省略不可
  name = "example-listener"

  # protocol (Required)
  # 設定内容: リスナーが使用するプロトコル
  # 設定可能な値: HTTP、HTTPS、TLS_PASSTHROUGH
  # 省略時: 必須のため省略不可
  protocol = "HTTP"

  # port (Optional)
  # 設定内容: リスナーが受信するポート番号
  # 設定可能な値: 1〜65535 の整数
  # 省略時: HTTP の場合は 80、HTTPS の場合は 443
  port = 80

  #-------------------------------------------------------------
  # デフォルトアクション
  #-------------------------------------------------------------

  # default_action (Required)
  # 設定内容: リスナーへのリクエストに対するデフォルトのアクション
  # 設定可能な値: forward（ターゲットグループへの転送）または fixed_response（固定レスポンス）
  # 省略時: 必須のため省略不可
  default_action {
    # forward (Optional)
    # 設定内容: ターゲットグループへのトラフィック転送設定
    # 設定可能な値: target_groups ブロックで転送先のターゲットグループを指定
    forward {
      # target_groups (Optional)
      # 設定内容: トラフィックを転送するターゲットグループのリスト
      target_groups {
        # target_group_identifier (Optional)
        # 設定内容: 転送先ターゲットグループの ID または ARN
        # 設定可能な値: VPC Lattice ターゲットグループの ID または ARN
        target_group_identifier = "tg-0123456789abcdef0"

        # weight (Optional)
        # 設定内容: 複数ターゲットグループ間でのトラフィック重み付け
        # 設定可能な値: 0〜999 の整数（合計が 0 の場合は全グループに均等分配）
        # 省略時: 1
        weight = 100
      }
    }

    # fixed_response (Optional)
    # 設定内容: 固定の HTTP ステータスコードを返す設定（forward との排他使用）
    # 設定可能な値: status_code ブロックで HTTP ステータスコードを指定
    # fixed_response {
    #   # status_code (Required)
    #   # 設定内容: 返却する HTTP ステータスコード
    #   # 設定可能な値: 100〜599 の整数
    #   status_code = 404
    # }
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
    Name        = "example-vpclattice-listener"
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
# - id: リスナーの ID
# - arn: リスナーの ARN
#   例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:service/svc-xxx/listener/lis-xxx
# - listener_id: リスナーの ID（arn とは異なる短い ID）
# - created_at: リスナーの作成日時（ISO 8601 形式）
# - last_updated_at: リスナーの最終更新日時（ISO 8601 形式）
#---------------------------------------------------------------
