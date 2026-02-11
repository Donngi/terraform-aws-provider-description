################################################################################
# AWS Global Accelerator Custom Routing Listener
# Terraform Resource: aws_globalaccelerator_custom_routing_listener
# Provider Version: 6.28.0
#
# 概要:
# AWS Global Acceleratorのカスタムルーティングリスナーを定義するリソース。
# カスタムルーティングアクセラレーターに接続されたリスナーは、クライアントから
# の受信接続を処理し、指定されたポート範囲で静的IPアドレスに到着するトラフィック
# を処理します。カスタムルーティングアクセラレーターは、アプリケーションロジック
# を使用して、VPCサブネット内の特定のAmazon EC2インスタンスに直接トラフィックを
# ルーティングできます。
#
# ユースケース:
# - ゲームアプリケーションで複数のユーザーを同じEC2インスタンスとポートの
#   セッションに配置する必要がある場合
# - VoIP (Voice over IP) セッションで特定のEC2インスタンスにユーザーを
#   マッピングする必要がある場合
# - マッチメイキングサービスで、ユーザーを特定のEC2インスタンスの宛先に
#   ルーティングする必要がある場合
# - Global Acceleratorのパフォーマンス向上の恩恵を受けながら、カスタムの
#   トラフィックルーティングロジックを実装する場合
#
# 制限事項と注意点:
# - カスタムルーティングアクセラレーターは、VPCサブネット内のAmazon EC2
#   インスタンスのプライベートIPエンドポイントにのみトラフィックをルーティング可能
# - カスタムルーティングアクセラレーターはIPv4 IPアドレスタイプのみサポート
# - 各リスナーポート範囲は最低16ポートを含む必要がある
# - リスナーはポート1-65535をサポート
# - リスナー作成後、ポート範囲を減少させることはできない
# - カスタムルーティングアクセラレーターはヘルスチェックや正常なエンドポイント
#   へのフェイルオーバーを実行しない
# - デフォルトでは、サブネット内のすべての宛先へのトラフィックは拒否され、
#   トラフィックを許可するために明示的な設定が必要
# - CloudFormationはカスタムルーティングアクセラレーターに対応していない
#
# 参考ドキュメント:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_custom_routing_listener
# - AWS API: https://docs.aws.amazon.com/global-accelerator/latest/api/API_CreateCustomRoutingListener.html
# - AWS User Guide: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-listeners.html
################################################################################

resource "aws_globalaccelerator_custom_routing_listener" "example" {
  ##############################################################################
  # 必須パラメータ (Required Parameters)
  ##############################################################################

  # accelerator_arn
  # 型: string
  # 必須: Yes
  # 説明: カスタムルーティングアクセラレーターのAmazon Resource Name (ARN)
  #
  # このリスナーが関連付けられるカスタムルーティングアクセラレーターを指定します。
  # カスタムルーティングアクセラレーターは事前に作成されている必要があります。
  #
  # フォーマット: arn:aws:globalaccelerator::account-id:accelerator/accelerator-id
  #
  # 例:
  # - accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.example.arn
  # - accelerator_arn = "arn:aws:globalaccelerator::123456789012:accelerator/abcd1234-5678-90ab-cdef-EXAMPLE11111"
  #
  # 注意点:
  # - 標準のアクセラレーターARNではなく、カスタムルーティング専用の
  #   アクセラレーターARNを指定する必要があります
  # - アクセラレーターは有効化されている必要があります
  # - 削除予定のアクセラレーターには新しいリスナーを追加できません
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.example.arn

  ##############################################################################
  # オプションパラメータ (Optional Parameters)
  ##############################################################################

  # port_range
  # 型: list(object)
  # 必須: No (ただし、トラフィックを処理するには少なくとも1つのport_rangeが推奨)
  # 説明: クライアントからアクセラレーターへの接続のためのポート範囲のリスト
  #
  # リスナーが受信するトラフィックのポート範囲を定義します。各port_rangeブロックは
  # from_portとto_portを含みます。複数のport_rangeブロックを指定できます。
  #
  # ポート範囲の計画時の考慮事項:
  # - リスナーポート範囲は、リスナーポートと宛先IPアドレスの組み合わせの
  #   数を定義します
  # - 最大限の柔軟性を得るために、大きなポート範囲を指定することが推奨されます
  # - サブネット内の宛先数に対応するために十分なリスナーポートを指定する必要があります
  # - Global Acceleratorはサブネット追加時にポート範囲をブロック単位で割り当てます
  # - 各リスナーポート範囲は最低16ポートを含む必要があります
  # - リスナー作成後、ポート範囲を減少させることはできません（増加のみ可能）
  #
  # 静的ポートマッピング:
  # - Global Acceleratorは、リスナーのポート範囲をサブネットでサポートされる
  #   ポート範囲への静的ポートマッピングを作成します
  # - このマッピングは決して変更されません
  # - アプリケーションはGlobal Accelerator APIを呼び出して、グローバル
  #   アクセラレーターポートとそれに関連する宛先IPアドレスとポートの
  #   静的マッピングを受け取ることができます
  #
  # 例:
  # - 単一ポート: from_port = 80, to_port = 80
  # - ポート範囲: from_port = 8000, to_port = 8100
  # - 大きな範囲: from_port = 10000, to_port = 20000
  port_range {
    # from_port
    # 型: number
    # 必須: No (ただし、port_rangeブロックを使用する場合は推奨)
    # 説明: ポート範囲の最初のポート（包含的）
    #
    # リスナーが受け入れるポート範囲の開始ポート番号を指定します。
    #
    # 有効な値:
    # - 1から65535の範囲の整数
    # - to_port以下である必要があります
    #
    # 例:
    # - from_port = 80     # 単一ポート80の場合（to_portも80に設定）
    # - from_port = 8000   # ポート範囲8000-9000の開始
    # - from_port = 10000  # 大きなポート範囲の開始
    #
    # 注意点:
    # - リスナーはポート1-65535をサポートします
    # - ポート範囲の合計は、サブネット内の宛先数に対応する必要があります
    # - from_portとto_portの差が最低15（16ポート）必要です
    from_port = 80

    # to_port
    # 型: number
    # 必須: No (ただし、port_rangeブロックを使用する場合は推奨)
    # 説明: ポート範囲の最後のポート（包含的）
    #
    # リスナーが受け入れるポート範囲の終了ポート番号を指定します。
    #
    # 有効な値:
    # - 1から65535の範囲の整数
    # - from_port以上である必要があります
    #
    # 例:
    # - to_port = 80     # 単一ポート80の場合（from_portも80に設定）
    # - to_port = 9000   # ポート範囲8000-9000の終了
    # - to_port = 20000  # 大きなポート範囲の終了
    #
    # 注意点:
    # - to_portはfrom_port以上である必要があります
    # - 単一ポートを指定する場合は、from_portとto_portを同じ値に設定します
    # - ポート範囲が大きいほど、より多くの宛先に対応できます
    to_port = 80
  }

  # 追加のポート範囲を指定する例
  # 複数のport_rangeブロックを定義することで、複数のポート範囲を
  # 同じリスナーに関連付けることができます
  #
  # 例: HTTPとHTTPSの両方をサポートする場合
  # port_range {
  #   from_port = 80
  #   to_port   = 80
  # }
  #
  # port_range {
  #   from_port = 443
  #   to_port   = 443
  # }
  #
  # 例: ゲームサーバー用の大きなポート範囲
  # port_range {
  #   from_port = 10000
  #   to_port   = 20000
  # }
  #
  # 例: VoIPアプリケーション用のUDP/TCPポート範囲
  # port_range {
  #   from_port = 5060
  #   to_port   = 5080
  # }

  ##############################################################################
  # 出力属性 (Computed Attributes)
  ##############################################################################

  # id
  # 型: string
  # 説明: カスタムルーティングリスナーのAmazon Resource Name (ARN)
  #
  # リスナーの一意の識別子として使用されるARN。他のリソースでこのリスナーを
  # 参照する際に使用できます。
  #
  # フォーマット: arn:aws:globalaccelerator::account-id:accelerator/accelerator-id/listener/listener-id
  #
  # アクセス例:
  # - aws_globalaccelerator_custom_routing_listener.example.id
  #
  # 用途:
  # - エンドポイントグループの作成時にリスナーを参照
  # - IAMポリシーでリスナーを指定
  # - CloudWatch監視でリスナーを特定
  # - API呼び出しでリスナーを識別

  ##############################################################################
  # タグ付け
  ##############################################################################

  # 注意: aws_globalaccelerator_custom_routing_listenerリソースは
  # 直接のタグ付けをサポートしていません。タグはアクセラレーターレベルで
  # 管理されます。リスナーに関連するタグ付けを行う場合は、親アクセラレーター
  # にタグを設定してください。
}

################################################################################
# 使用例とベストプラクティス
################################################################################

# 例1: 基本的なカスタムルーティングリスナー
# 単一のポート（80）でHTTPトラフィックを処理する基本的な構成
resource "aws_globalaccelerator_custom_routing_listener" "basic" {
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.example.arn

  port_range {
    from_port = 80
    to_port   = 80
  }
}

# 例2: 複数のポート範囲を持つリスナー
# HTTPとHTTPSの両方のトラフィックを処理
resource "aws_globalaccelerator_custom_routing_listener" "multi_port" {
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.example.arn

  port_range {
    from_port = 80
    to_port   = 80
  }

  port_range {
    from_port = 443
    to_port   = 443
  }
}

# 例3: ゲームサーバー向けの大規模ポート範囲
# 多数のゲームセッションをサポートするための広いポート範囲
resource "aws_globalaccelerator_custom_routing_listener" "gaming" {
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.gaming.arn

  port_range {
    from_port = 10000
    to_port   = 30000
  }
}

# 例4: VoIPアプリケーション向けリスナー
# SIPシグナリングとRTPメディアストリームのポート範囲
resource "aws_globalaccelerator_custom_routing_listener" "voip" {
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.voip.arn

  # SIPシグナリング用ポート
  port_range {
    from_port = 5060
    to_port   = 5080
  }

  # RTPメディアストリーム用ポート範囲
  port_range {
    from_port = 16384
    to_port   = 32767
  }
}

# 例5: 動的なポート範囲計算
# サブネット内のEC2インスタンス数に基づいてポート範囲を計算
locals {
  # サブネット内の予想されるEC2インスタンス数
  expected_instances = 100

  # 各インスタンスが必要とするポート数
  ports_per_instance = 10

  # 必要な合計ポート数（余裕を持たせるために1.5倍）
  total_ports_needed = ceil(local.expected_instances * local.ports_per_instance * 1.5)

  # ポート範囲の開始と終了
  port_range_start = 20000
  port_range_end   = local.port_range_start + local.total_ports_needed - 1
}

resource "aws_globalaccelerator_custom_routing_listener" "dynamic" {
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.example.arn

  port_range {
    from_port = local.port_range_start
    to_port   = local.port_range_end
  }
}

# 例6: カスタムルーティングアクセラレーターとリスナーの完全な構成
resource "aws_globalaccelerator_custom_routing_accelerator" "complete" {
  name            = "example-custom-routing-accelerator"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled   = true
    flow_logs_s3_bucket = "example-flow-logs-bucket"
    flow_logs_s3_prefix = "global-accelerator/"
  }
}

resource "aws_globalaccelerator_custom_routing_listener" "complete" {
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.complete.arn

  port_range {
    from_port = 1024
    to_port   = 65535
  }
}

# リスナーARNを出力として公開
output "listener_arn" {
  description = "The ARN of the custom routing listener"
  value       = aws_globalaccelerator_custom_routing_listener.complete.id
}

################################################################################
# ベストプラクティス
################################################################################

# 1. ポート範囲の計画
#    - サブネット内の宛先数に対応するために十分なリスナーポートを確保
#    - 将来の成長を見越して、余裕を持ったポート範囲を設定
#    - 各リスナーポート範囲は最低16ポートを含めること
#
# 2. 静的ポートマッピングの理解
#    - Global Acceleratorが作成する静的ポートマッピングは変更されないことを理解
#    - アプリケーションロジックでこの静的マッピングを活用
#
# 3. トラフィック制御
#    - デフォルトではすべての宛先へのトラフィックが拒否されることを理解
#    - Global Accelerator APIを使用してトラフィックを明示的に許可
#
# 4. モニタリングとロギング
#    - アクセラレーターレベルでフローログを有効化してトラフィックを追跡
#    - CloudWatch メトリクスを使用してリスナーのパフォーマンスを監視
#
# 5. セキュリティ考慮事項
#    - 必要なポート範囲のみを開放
#    - VPCセキュリティグループでEC2インスタンスへのアクセスを制限
#    - AWS Shield Standardが自動的に有効化されることを活用
#
# 6. 高可用性設計
#    - カスタムルーティングアクセラレーターは自動的にヘルスチェックを
#      実行しないため、アプリケーションレベルでの健全性管理が必要
#    - 複数のAWSリージョンにエンドポイントグループを配置して冗長性を確保
#
# 7. コスト最適化
#    - 必要な最小限のポート範囲を使用してコストを最適化
#    - 使用していないリスナーは削除してコストを削減
#
# 8. 変更管理
#    - リスナー作成後のポート範囲の削減はできないため、初期設計を慎重に行う
#    - ポート範囲の拡張は可能だが、トラフィックへの影響を考慮してメンテナンス
#      ウィンドウ中に実施
#
# 9. アプリケーション統合
#    - Global Accelerator APIを使用して静的ポートマッピング情報を取得
#    - マッチメイキングサービスやロードバランサーとの統合を計画
#
# 10. ドキュメント化
#     - ポート範囲の用途と割り当てロジックをドキュメント化
#     - 静的ポートマッピングの使用方法をチームで共有

################################################################################
# トラブルシューティング
################################################################################

# 問題: リスナー作成時にポート範囲が不十分エラーが発生
# 解決策: 各リスナーポート範囲が最低16ポートを含むことを確認
#         from_portとto_portの差が最低15であることを確認

# 問題: トラフィックが宛先に到達しない
# 解決策: デフォルトではトラフィックが拒否されるため、Global Accelerator
#         APIを使用してトラフィックを明示的に許可する必要があります
#         aws_globalaccelerator_custom_routing_endpoint_groupリソースと
#         組み合わせて使用してください

# 問題: ポート範囲を削減したい
# 解決策: リスナー作成後、ポート範囲の削減はできません。新しいリスナーを
#         作成し、古いリスナーを削除する必要があります（ダウンタイムが発生）

# 問題: IPv6トラフィックをサポートしたい
# 解決策: カスタムルーティングアクセラレーターはIPv4のみをサポートします。
#         IPv6が必要な場合は、標準のGlobal Acceleratorの使用を検討

# 問題: CloudFormationでカスタムルーティングアクセラレーターを管理したい
# 解決策: CloudFormationはカスタムルーティングアクセラレーターに対応して
#         いません。TerraformまたはAWS APIを使用してください

################################################################################
# 関連リソース
################################################################################

# このリソースは以下のリソースと組み合わせて使用されます:
#
# - aws_globalaccelerator_custom_routing_accelerator
#   カスタムルーティングアクセラレーター本体
#
# - aws_globalaccelerator_custom_routing_endpoint_group
#   リスナーに関連付けられたエンドポイントグループ
#
# - aws_vpc / aws_subnet
#   EC2インスタンスが配置されるVPCとサブネット
#
# - aws_security_group
#   EC2インスタンスへのトラフィックを制御するセキュリティグループ

# 例: 関連リソースとの統合
resource "aws_globalaccelerator_custom_routing_accelerator" "main" {
  name            = "main-custom-routing-accelerator"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled   = true
    flow_logs_s3_bucket = aws_s3_bucket.flow_logs.id
    flow_logs_s3_prefix = "accelerator-logs/"
  }
}

resource "aws_globalaccelerator_custom_routing_listener" "main" {
  accelerator_arn = aws_globalaccelerator_custom_routing_accelerator.main.arn

  port_range {
    from_port = 10000
    to_port   = 20000
  }
}

# エンドポイントグループは別途定義が必要
# resource "aws_globalaccelerator_custom_routing_endpoint_group" "main" {
#   listener_arn = aws_globalaccelerator_custom_routing_listener.main.id
#   # ... その他の設定
# }

################################################################################
# 参考: カスタムルーティングアクセラレーターの仕組み
################################################################################

# カスタムルーティングアクセラレーターは以下のように動作します:
#
# 1. 静的IPアドレスの割り当て
#    - Global Acceleratorは2つの静的IPv4アドレスを割り当て
#    - これらのアドレスはアプリケーションへの固定エントリーポイントとなる
#
# 2. リスナーの設定
#    - リスナーはポート範囲とプロトコルを定義
#    - クライアントからの接続を受け入れる
#
# 3. エンドポイントグループの設定
#    - VPCサブネットエンドポイントを追加
#    - 宛先ポート範囲とプロトコルを定義
#
# 4. 静的ポートマッピングの作成
#    - Global Acceleratorはリスナーポート範囲をサブネット内の
#      EC2インスタンスの宛先IPアドレスとポートにマッピング
#    - このマッピングは静的で変更されない
#
# 5. アプリケーション統合
#    - アプリケーションはGlobal Accelerator APIを呼び出してポートマッピングを取得
#    - マッチメイキングサービスがこのマッピングを使用してユーザーを特定の
#      EC2インスタンスにルーティング
#
# 6. トラフィック制御
#    - デフォルトではすべてのトラフィックが拒否される
#    - アプリケーションは明示的にトラフィックを許可する必要がある
#    - サブネット全体または特定のIPアドレス/ポートの組み合わせに対して許可可能
#
# 7. トラフィックルーティング
#    - ユーザートラフィックが最も近いAWSエッジロケーションに到着
#    - Global AcceleratorがAWSグローバルネットワークを使用して
#      最適なパスでトラフィックをルーティング
#    - 静的ポートマッピングに基づいて特定のEC2インスタンスに配信

################################################################################
# メトリクスとモニタリング
################################################################################

# Global Acceleratorは以下のCloudWatchメトリクスを提供します:
#
# - NewFlowCount
#   新しいフローの数（接続数）
#
# - ProcessedBytesIn
#   アクセラレーターによって処理された受信バイト数
#
# - ProcessedBytesOut
#   アクセラレーターによって処理された送信バイト数
#
# モニタリングのベストプラクティス:
# - CloudWatch アラームを設定してトラフィック異常を検出
# - フローログを有効化してトラフィックパターンを分析
# - アクセラレーターレベルのメトリクスを定期的に確認
# - アプリケーション固有のメトリクスと相関分析を実施
