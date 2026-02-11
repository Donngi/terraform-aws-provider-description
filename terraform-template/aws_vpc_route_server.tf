#---------------------------------------------------------------
# AWS VPC Route Server
#---------------------------------------------------------------
#
# Amazon VPC Route Serverをプロビジョニングするリソースです。
# VPC Route Serverは、VPC内の仮想アプライアンス間の動的ルーティングを
# 簡素化するサービスです。Border Gateway Protocol (BGP) を使用して
# 仮想アプライアンスからルーティング情報を広告し、サブネットや
# インターネットゲートウェイに関連付けられたVPCルートテーブルを
# 動的に更新できます。
#
# AWS公式ドキュメント:
#   - VPC Route Server概要: https://docs.aws.amazon.com/vpc/latest/userguide/dynamic-routing-route-server.html
#   - VPC Route Serverの仕組み: https://docs.aws.amazon.com/vpc/latest/userguide/route-server-how-it-works.html
#   - VPC Route Server用語集: https://docs.aws.amazon.com/vpc/latest/userguide/route-server-terms.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_route_server
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_route_server" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # amazon_side_asn (Required)
  # 設定内容: BGPセッションのAmazon側のAutonomous System Number (ASN) を指定します。
  # 設定可能な値: 1 から 4294967295 の範囲の数値
  # 関連機能: Border Gateway Protocol (BGP)
  #   ASNはBGPルーティングにおいてネットワークを一意に識別する番号です。
  #   プライベートASN範囲（64512-65534、4200000000-4294967294）を使用することが推奨されます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-server-how-it-works.html
  amazon_side_asn = 65534

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ルート永続化設定
  #-------------------------------------------------------------

  # persist_routes (Optional)
  # 設定内容: すべてのBGPセッションが終了した後もルートを永続化するかを指定します。
  # 設定可能な値:
  #   - "enable": BGPセッション終了後もルートを永続化
  #   - "disable": BGPセッション終了時にルートを削除
  #   - "reset": 永続化されたルートをリセット
  # 省略時: disable（ルートは永続化されない）
  # 関連機能: VPC Route Server ルート永続化
  #   ネットワークデバイスの障害や再起動時にルートを維持し、
  #   BGPセッションが再確立されるまでの間もトラフィックを継続できます。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-server-how-it-works.html
  # 注意: "enable"を指定する場合、persist_routes_durationも設定が必要です。
  persist_routes = "enable"

  # persist_routes_duration (Optional)
  # 設定内容: BGPが再確立された後、FIBおよびRIBのルートを永続化解除するまでの待機時間（分）を指定します。
  # 設定可能な値: 1 から 5 の範囲の数値
  # 省略時: 設定なし
  # 関連機能: VPC Route Server ルート永続化
  #   BGPセッションが再確立された後、この期間が経過するとルートの永続化が解除されます。
  # 注意: persist_routesが"enable"の場合に必須です。
  persist_routes_duration = 2

  #-------------------------------------------------------------
  # SNS通知設定
  #-------------------------------------------------------------

  # sns_notifications_enabled (Optional)
  # 設定内容: Route Serverイベントに対するSNS通知を有効にするかを指定します。
  # 設定可能な値:
  #   - true: SNS通知を有効化。AWSがプロビジョニングするSNSトピックにBGPステータス変更が通知されます。
  #   - false: SNS通知を無効化
  # 省略時: false（SNS通知は無効）
  # 関連機能: VPC Route Server SNS通知
  #   BGPセッションのステータス変更やBFDセッションの状態変化を
  #   SNSトピックに通知することで、ネットワークの監視と運用を支援します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/route-server-tutorial-create.html
  sns_notifications_enabled = true

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-route-server"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの時間文字列。有効な単位は "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルト値
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの時間文字列。有効な単位は "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルト値
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの時間文字列。有効な単位は "s"（秒）, "m"（分）, "h"（時間）
    # 省略時: プロバイダーのデフォルト値
    # 注意: 削除操作のタイムアウトは、destroy操作の前に状態が保存される場合にのみ適用されます。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Route ServerのAmazon Resource Name (ARN)
#
# - route_server_id: Route Serverの一意な識別子
#
# - sns_topic_arn: 通知が発行されるSNSトピックのARN
#                  （sns_notifications_enabledがtrueの場合にAWSが自動プロビジョニング）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
