################################################################################
# AWS Global Accelerator Listener
# Terraform Resource: aws_globalaccelerator_listener
# Provider Version: 6.28.0
#
# 用途: Global Acceleratorリスナーを作成・管理
#
# Global Acceleratorリスナーは、クライアントからのトラフィックを受信し、
# エンドポイントグループに転送するための設定を定義します。
# TCPまたはUDPプロトコルをサポートし、ポート範囲とクライアントアフィニティを指定できます。
################################################################################

resource "aws_globalaccelerator_listener" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # accelerator_arn - (Required) 対象アクセラレータのARN
  # Type: string
  #
  # このリスナーを関連付けるGlobal AcceleratorのARNを指定します。
  # 例: "arn:aws:globalaccelerator::123456789012:accelerator/12345678-1234-1234-1234-123456789012"
  accelerator_arn = aws_globalaccelerator_accelerator.example.arn

  # protocol - (Required) クライアントからアクセラレータへの接続プロトコル
  # Type: string
  # Valid values: "TCP", "UDP"
  #
  # リスナーが受け付けるプロトコルを指定します。
  # - TCP: 信頼性の高い接続指向プロトコル（Webアプリケーション、データベースなど）
  # - UDP: 低遅延のコネクションレス型プロトコル（ゲーム、VoIPなど）
  protocol = "TCP"

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # client_affinity - (Optional) クライアントアフィニティ設定
  # Type: string
  # Valid values: "NONE", "SOURCE_IP"
  # Default: "NONE"
  #
  # クライアントからのすべてのリクエストを同じエンドポイントに転送するかどうかを指定します。
  # - NONE: 5タプル（送信元IP、送信元ポート、宛先IP、宛先ポート、プロトコル）でハッシュ化
  # - SOURCE_IP: 2タプル（送信元IP、宛先IP）でハッシュ化し、同じクライアントを同じエンドポイントに転送
  #
  # ステートフルなアプリケーションやセッション維持が必要な場合はSOURCE_IPを使用します。
  client_affinity = "SOURCE_IP"

  ################################################################################
  # ブロックタイプ
  ################################################################################

  # port_range - (Optional) クライアントからアクセラレータへの接続ポート範囲リスト
  # Min items: 1
  # Max items: 10
  # Nesting mode: set
  #
  # リスナーがリッスンするポート範囲を定義します。
  # 最低1つ、最大10個のポート範囲を指定できます。
  port_range {
    # from_port - (Optional) ポート範囲の開始ポート（この値を含む）
    # Type: number
    #
    # リッスンする最初のポート番号を指定します。
    # 単一ポートの場合、from_portとto_portに同じ値を設定します。
    from_port = 80

    # to_port - (Optional) ポート範囲の終了ポート（この値を含む）
    # Type: number
    #
    # リッスンする最後のポート番号を指定します。
    # ポート範囲を指定する場合、from_portより大きい値を設定します。
    to_port = 80
  }

  # 複数のポート範囲を指定する例
  # port_range {
  #   from_port = 443
  #   to_port   = 443
  # }
  #
  # port_range {
  #   from_port = 8000
  #   to_port   = 8100
  # }

  # timeouts - (Optional) リソース操作のタイムアウト設定
  # Nesting mode: single
  #
  # リソースの作成、更新、削除操作のタイムアウト時間を設定します。
  # timeouts {
  #   # create - (Optional) 作成操作のタイムアウト
  #   # Type: string
  #   # Format: "30m", "1h" など
  #   # Default: Terraform provider default
  #   create = "30m"
  #
  #   # update - (Optional) 更新操作のタイムアウト
  #   # Type: string
  #   # Format: "30m", "1h" など
  #   # Default: Terraform provider default
  #   update = "30m"
  #
  #   # delete - (Optional) 削除操作のタイムアウト
  #   # Type: string
  #   # Format: "30m", "1h" など
  #   # Default: Terraform provider default
  #   delete = "30m"
  # }

  ################################################################################
  # Computed Attributes（参照のみ可能な属性）
  ################################################################################

  # arn - リスナーのARN
  # Type: string (computed)
  #
  # Global AcceleratorリスナーのAmazon Resource Name（ARN）。
  # 他のリソースでこのリスナーを参照する際に使用します。
  # 例: "arn:aws:globalaccelerator::123456789012:accelerator/12345678-1234-1234-1234-123456789012/listener/abcdef12"
  #
  # 参照方法: aws_globalaccelerator_listener.example.arn

  # id - リスナーの識別子
  # Type: string (computed)
  #
  # Global Acceleratorリスナーの一意の識別子。リスナーのARNと同じ値になります。
  #
  # 参照方法: aws_globalaccelerator_listener.example.id
}

################################################################################
# 使用例
################################################################################

# 例1: 単一ポートのTCPリスナー
# resource "aws_globalaccelerator_listener" "http" {
#   accelerator_arn = aws_globalaccelerator_accelerator.main.arn
#   protocol        = "TCP"
#   client_affinity = "NONE"
#
#   port_range {
#     from_port = 80
#     to_port   = 80
#   }
# }

# 例2: 複数ポート範囲とクライアントアフィニティ設定
# resource "aws_globalaccelerator_listener" "multi_port" {
#   accelerator_arn = aws_globalaccelerator_accelerator.main.arn
#   protocol        = "TCP"
#   client_affinity = "SOURCE_IP"  # セッション維持
#
#   # HTTPポート
#   port_range {
#     from_port = 80
#     to_port   = 80
#   }
#
#   # HTTPSポート
#   port_range {
#     from_port = 443
#     to_port   = 443
#   }
# }

# 例3: UDPリスナー（ゲーム、VoIPなど）
# resource "aws_globalaccelerator_listener" "gaming" {
#   accelerator_arn = aws_globalaccelerator_accelerator.game_server.arn
#   protocol        = "UDP"
#   client_affinity = "SOURCE_IP"
#
#   # ゲームサーバーポート範囲
#   port_range {
#     from_port = 7000
#     to_port   = 7100
#   }
# }

# 例4: カスタムタイムアウト設定
# resource "aws_globalaccelerator_listener" "custom_timeout" {
#   accelerator_arn = aws_globalaccelerator_accelerator.main.arn
#   protocol        = "TCP"
#
#   port_range {
#     from_port = 443
#     to_port   = 443
#   }
#
#   timeouts {
#     create = "10m"
#     update = "10m"
#     delete = "10m"
#   }
# }

################################################################################
# 出力例
################################################################################

# output "listener_arn" {
#   description = "Global AcceleratorリスナーのARN"
#   value       = aws_globalaccelerator_listener.example.arn
# }
#
# output "listener_id" {
#   description = "Global AcceleratorリスナーのID"
#   value       = aws_globalaccelerator_listener.example.id
# }

################################################################################
# 重要な注意事項
################################################################################

# 1. プロトコルの選択:
#    - TCP: Webアプリケーション、データベース、API など信頼性が必要な場合
#    - UDP: ゲーム、VoIP、ストリーミング など低遅延が必要な場合

# 2. クライアントアフィニティ:
#    - NONE: ステートレスアプリケーション向け、最適な負荷分散
#    - SOURCE_IP: ステートフルアプリケーション向け、セッション維持が可能

# 3. ポート範囲の制限:
#    - 最大10個のポート範囲を指定可能
#    - 単一ポートの場合もport_rangeブロックが必須（最低1つ）

# 4. エンドポイントグループとの関連:
#    - リスナー作成後、aws_globalaccelerator_endpoint_groupリソースで
#      エンドポイントグループを追加する必要があります

# 5. プロトコル変更時の注意:
#    - プロトコルを変更すると、リスナーが再作成される可能性があります
#    - 本番環境での変更時は計画的に実施してください

# 6. ポート使用の推奨事項:
#    - 標準的なポート（80, 443など）を使用する場合が多い
#    - カスタムポートを使用する場合、クライアント側の設定も確認

# 7. コスト考慮:
#    - Global Acceleratorは固定料金 + データ転送料金が発生
#    - リスナー数に応じた追加料金はありませんが、アクセラレータ自体に課金

# 8. 複数リスナーの設定:
#    - 1つのアクセラレータに複数のリスナーを作成可能
#    - 異なるプロトコルやポートごとにリスナーを分けることができます
