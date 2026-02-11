#---------------------------------------------------------------
# AWS Global Accelerator Custom Routing Endpoint Group
#---------------------------------------------------------------
#
# AWS Global Acceleratorのカスタムルーティングエンドポイントグループを
# プロビジョニングします。カスタムルーティングアクセラレータでは、
# 特定のEC2インスタンスや特定のポートへトラフィックを転送できます。
# エンドポイントグループにはポート範囲とプロトコル、VPCサブネットを
# 指定します。
#
# AWS公式ドキュメント:
#   - AWS Global Accelerator: https://docs.aws.amazon.com/global-accelerator/
#   - Custom Routing Accelerator: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/globalaccelerator_custom_routing_endpoint_group
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_custom_routing_endpoint_group" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # カスタムルーティングリスナーのARN
  # このエンドポイントグループが属するカスタムルーティングリスナーを
  # Amazon Resource Name (ARN)で指定します。
  # 例: "arn:aws:globalaccelerator::123456789012:accelerator/12345678-1234-1234-1234-123456789012/listener/abcdef12"
  listener_arn = "arn:aws:globalaccelerator::123456789012:accelerator/xxx/listener/xxx"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # エンドポイントグループのリージョン
  # このエンドポイントグループを作成するAWSリージョンを指定します。
  # 指定しない場合は、リスナーに関連付けられたアクセラレータのリージョンが使用されます。
  # 例: "us-west-2", "ap-northeast-1"
  endpoint_group_region = "us-west-2"

  # リソースID
  # Terraformが管理するリソースの一意な識別子です。
  # 通常は指定する必要はなく、Terraformが自動的に割り当てます。
  # id = null

  #---------------------------------------------------------------
  # Destination Configuration (Required Block)
  #---------------------------------------------------------------
  # カスタムルーティングエンドポイントグループの宛先設定
  # すべてのエンドポイントがクライアントトラフィックを受け入れる
  # ポート範囲とプロトコルを定義します。
  # 最低1つのdestination_configurationブロックが必要です。

  destination_configuration {
    # 開始ポート番号（必須）
    # エンドポイントグループのポート範囲の最初のポート（境界含む）を指定します。
    # 1～65535の範囲で指定します。
    from_port = 80

    # 終了ポート番号（必須）
    # エンドポイントグループのポート範囲の最後のポート（境界含む）を指定します。
    # from_port以上の値で、1～65535の範囲で指定します。
    to_port = 8080

    # プロトコル（必須）
    # エンドポイントグループに関連付けられたプロトコルを指定します。
    # 指定可能な値: "TCP", "UDP"
    # 複数のプロトコルを指定することができます。
    protocols = ["TCP", "UDP"]
  }

  # 追加の宛先設定を指定する場合は、複数のdestination_configurationブロックを定義できます
  # destination_configuration {
  #   from_port = 443
  #   to_port   = 443
  #   protocols = ["TCP"]
  # }

  #---------------------------------------------------------------
  # Endpoint Configuration (Optional Block)
  #---------------------------------------------------------------
  # エンドポイント設定
  # カスタムルーティングアクセラレータのエンドポイントオブジェクトのリストです。
  # カスタムルーティングでは、エンドポイントIDはVPCサブネットIDです。

  endpoint_configuration {
    # エンドポイントID（任意）
    # カスタムルーティングアクセラレータの場合、これは
    # VPC（Virtual Private Cloud）サブネットIDです。
    # 例: "subnet-12345678"
    endpoint_id = "subnet-12345678"
  }

  # 複数のエンドポイントを追加する場合
  # endpoint_configuration {
  #   endpoint_id = "subnet-87654321"
  # }

  #---------------------------------------------------------------
  # Timeouts (Optional Block)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定
  # 各操作の最大待機時間を指定します。

  timeouts {
    # 作成時のタイムアウト
    # リソースの作成完了を待つ最大時間を指定します。
    # デフォルト: 30m
    # 例: "30m", "1h"
    create = "30m"

    # 削除時のタイムアウト
    # リソースの削除完了を待つ最大時間を指定します。
    # デフォルト: 30m
    # 例: "30m", "1h"
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# リソース作成後に参照可能な属性
#
# - arn: カスタムルーティングエンドポイントグループのAmazon Resource Name (ARN)
#   例: aws_globalaccelerator_custom_routing_endpoint_group.example.arn
#
# - id: カスタムルーティングエンドポイントグループのAmazon Resource Name (ARN)
#   arnと同じ値が設定されます。
#   例: aws_globalaccelerator_custom_routing_endpoint_group.example.id
#
#---------------------------------------------------------------
