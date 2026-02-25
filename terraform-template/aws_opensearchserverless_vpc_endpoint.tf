#---------------------------------------------------------------
# AWS OpenSearch Serverless VPC Endpoint
#---------------------------------------------------------------
#
# Amazon OpenSearch Serverlessにアクセスするためのインターフェース型VPCエンドポイント
# (AWS PrivateLink) をプロビジョニングするリソースです。
# このエンドポイントを使用することで、インターネットゲートウェイ・NATデバイス・
# VPN接続・Direct Connect接続を必要とせず、VPC内からOpenSearch Serverlessに
# プライベートアクセスが可能になります。
#
# AWS公式ドキュメント:
#   - OpenSearch ServerlessへのVPCエンドポイントアクセス: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-vpc.html
#   - CreateVpcEndpoint APIリファレンス: https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_CreateVpcEndpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_vpc_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearchserverless_vpc_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: インターフェースエンドポイントの名前を指定します。
  # 設定可能な値: 3〜32文字の文字列。小文字で始まり、小文字・数字・ハイフンが使用可能 (パターン: [a-z][a-z0-9-]+)
  name = "myendpoint"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # vpc_id (Required, Forces new resource)
  # 設定内容: OpenSearch Serverlessにアクセスする元となるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID (例: vpc-0123456789abcdef0)
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-vpc.html
  vpc_id = "vpc-0123456789abcdef0"

  # subnet_ids (Required)
  # 設定内容: OpenSearch Serverlessにアクセスする元となるサブネットIDのセットを指定します。
  # 設定可能な値: 有効なサブネットIDのセット。最大6つのサブネットを指定可能。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-vpc.html
  subnet_ids = [
    "subnet-0123456789abcdef0",
  ]

  # security_group_ids (Optional)
  # 設定内容: エンドポイントへのインバウンドトラフィックのポート・プロトコル・送信元を定義する
  #           セキュリティグループIDのセットを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット。最大5つのセキュリティグループを指定可能。
  # 省略時: セキュリティグループが関連付けられません。
  # 注意: セキュリティグループはエンドポイントが属するVPCと同じVPCに属している必要があります。
  #       OpenSearch ServerlessへのアクセスにはインバウンドHTTPS (TCP 443) の許可が必要です。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-vpc.html
  security_group_ids = [
    "sg-0123456789abcdef0",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: ap-northeast-1, us-east-1)
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような時間文字列。単位は "s" (秒), "m" (分), "h" (時間)
    # 省略時: デフォルトのタイムアウト時間を使用します。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" のような時間文字列。単位は "s" (秒), "m" (分), "h" (時間)
    # 省略時: デフォルトのタイムアウト時間を使用します。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    #           destroy操作前に変更がstateに保存されている場合にのみ有効です。
    # 設定可能な値: "30s", "2h45m" のような時間文字列。単位は "s" (秒), "m" (分), "h" (時間)
    # 省略時: デフォルトのタイムアウト時間を使用します。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCエンドポイントの一意識別子
#---------------------------------------------------------------
