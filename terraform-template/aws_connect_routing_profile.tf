#---------------------------------------------------------------
# AWS Connect Routing Profile
#---------------------------------------------------------------
#
# Amazon Connectのルーティングプロファイルをプロビジョニングするリソースです。
# ルーティングプロファイルは、エージェントがContact Control Panel (CCP)で処理できる
# チャネルと、関連付けられたキューを定義します。各エージェントは1つのルーティング
# プロファイルに割り当てられ、ルーティングプロファイルは複数のエージェントを持つことができます。
#
# AWS公式ドキュメント:
#   - Routing Profiles概要: https://docs.aws.amazon.com/connect/latest/adminguide/routing-profiles.html
#   - Routing Profileの仕組み: https://docs.aws.amazon.com/connect/latest/adminguide/concepts-routing.html
#   - API Reference: https://docs.aws.amazon.com/connect/latest/APIReference/API_RoutingProfile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_routing_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_connect_routing_profile" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # instance_id (Required)
  # 設定内容: このルーティングプロファイルを作成するAmazon ConnectインスタンスのIDを指定します。
  # 設定可能な値: 有効なAmazon ConnectインスタンスID (UUID形式)
  # 参考: Amazon Connectインスタンスは、コンタクトセンターの基盤となるリソースです
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # name (Required)
  # 設定内容: ルーティングプロファイルの名前を指定します。
  # 設定可能な値: 1-127文字の文字列
  # 注意: 同一インスタンス内で一意である必要があります
  name = "example-routing-profile"

  # description (Required)
  # 設定内容: ルーティングプロファイルの説明を指定します。
  # 設定可能な値: 1-250文字の文字列
  # 用途: プロファイルの用途や対象チームなどを記載
  description = "Routing profile for customer support team"

  # default_outbound_queue_id (Required)
  # 設定内容: このルーティングプロファイルのデフォルトアウトバウンドキューのIDを指定します。
  # 設定可能な値: 有効なAmazon ConnectキューID (UUID形式)
  # 用途: エージェントが発信通話を行う際のデフォルトキューを定義
  default_outbound_queue_id = "12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # メディア同時処理設定 (Required)
  #-------------------------------------------------------------

  # media_concurrencies (Required, min_items: 1)
  # 設定内容: エージェントがContact Control Panel (CCP)で処理できるチャネルと
  #          同時処理数を定義します。
  # 用途: エージェントが音声、チャット、タスクを同時にいくつ処理できるかを設定
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/routing-profiles.html
  media_concurrencies {
    # channel (Required)
    # 設定内容: エージェントが処理できるチャネルの種類を指定します。
    # 設定可能な値:
    #   - "VOICE": 音声通話チャネル
    #   - "CHAT": チャットチャネル
    #   - "TASK": タスクチャネル
    channel = "VOICE"

    # concurrency (Required)
    # 設定内容: このチャネルでエージェントが同時に処理できるコンタクト数を指定します。
    # 設定可能な値:
    #   - VOICE: 1 (最小値: 1, 最大値: 1)
    #   - CHAT: 1-10 (最小値: 1, 最大値: 10)
    #   - TASK: 1-10 (最小値: 1, 最大値: 10)
    # 注意: VOICEは常に1のみ設定可能
    concurrency = 1

    # cross_channel_behavior (Optional)
    # 設定内容: チャネル間のルーティング動作を定義します。
    # 用途: 異なるチャネル間でのコンタクトルーティングの制御
    # 注意: この引数を明示的に設定しない場合、外部変更は検出されません
    cross_channel_behavior {
      # behavior_type (Required)
      # 設定内容: クロスチャネルルーティングの動作タイプを指定します。
      # 設定可能な値:
      #   - "ROUTE_CURRENT_CHANNEL_ONLY": エージェントは現在処理中のチャネルからのみコンタクトを受け取ります
      #   - "ROUTE_ANY_CHANNEL": エージェントは現在処理中のチャネルに関係なく、任意のチャネルからコンタクトを受け取ります
      # 用途: マルチチャネル対応時のエージェントの柔軟性を制御
      # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/about-routing.html
      behavior_type = "ROUTE_ANY_CHANNEL"
    }
  }

  # 複数のチャネルを設定する例
  media_concurrencies {
    channel     = "CHAT"
    concurrency = 3

    cross_channel_behavior {
      behavior_type = "ROUTE_CURRENT_CHANNEL_ONLY"
    }
  }

  media_concurrencies {
    channel     = "TASK"
    concurrency = 5

    cross_channel_behavior {
      behavior_type = "ROUTE_ANY_CHANNEL"
    }
  }

  #-------------------------------------------------------------
  # キュー設定 (Optional)
  #-------------------------------------------------------------

  # queue_configs (Optional)
  # 設定内容: このルーティングプロファイルに関連付けるインバウンドキューを定義します。
  # 用途: キューが追加されていない場合、エージェントはアウトバウンド通話のみ可能
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/connect-queues.html
  queue_configs {
    # channel (Required)
    # 設定内容: このキュー設定が適用されるチャネルを指定します。
    # 設定可能な値:
    #   - "VOICE": 音声通話チャネル
    #   - "CHAT": チャットチャネル
    #   - "TASK": タスクチャネル
    # 注意: media_concurrenciesで指定したチャネルと一致する必要があります
    channel = "VOICE"

    # delay (Required)
    # 設定内容: コンタクトが利用可能なエージェントにルーティングされるまでの
    #          キュー内での待機時間を秒単位で指定します。
    # 設定可能な値: 0以上の整数（秒）
    # 用途: キューの優先順位制御に使用。delayが長いほど後回しになります
    delay = 0

    # priority (Required)
    # 設定内容: このキューのコンタクトを処理する順序を指定します。
    # 設定可能な値: 1以上の整数（数値が小さいほど優先度が高い）
    # 用途: 複数キュー間での処理優先順位の制御
    # 例: priority=1のキューはpriority=2のキューより先に処理されます
    priority = 1

    # queue_id (Required)
    # 設定内容: 関連付けるキューのIDを指定します。
    # 設定可能な値: 有効なAmazon ConnectキューID (UUID形式)
    queue_id = "12345678-1234-1234-1234-123456789012"

    # 注意: 以下の属性は読み取り専用（computed）のため設定不要
    # - queue_arn: キューのARN
    # - queue_name: キューの名前
  }

  # 複数のキューを設定する例
  queue_configs {
    channel  = "CHAT"
    delay    = 5
    priority = 2
    queue_id = "87654321-4321-4321-4321-210987654321"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 省略時: Terraformが自動的に生成します（推奨）
  # 形式: instance_id:routing_profile_id のコロン区切り
  # 注意: 通常は明示的に設定する必要はありません
  # id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: ルーティングプロファイルに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの整理、追跡、アクセス制御に使用
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、このリソースレベルで定義されたものが優先されます。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "customer-support-routing"
    Environment = "production"
    Team        = "support"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられた全てのタグを指定します。
  # 省略時: tagsとプロバイダーのdefault_tagsが自動的にマージされます（推奨）
  # 注意: 通常は明示的に設定する必要はありません
  #       プロバイダーのdefault_tags機能を使用することで自動的に管理されます
  # tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ルーティングプロファイルのAmazon Resource Name (ARN)
#
# - id: Amazon ConnectインスタンスIDとルーティングプロファイルIDを
#       コロン(:)で区切った識別子
#       形式: instance_id:routing_profile_id
#
# - routing_profile_id: ルーティングプロファイルのID (UUID形式)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# queue_configs ブロック内の追加の読み取り専用属性:
# - queue_arn: キューのARN
# - queue_name: キューの名前
#---------------------------------------------------------------
