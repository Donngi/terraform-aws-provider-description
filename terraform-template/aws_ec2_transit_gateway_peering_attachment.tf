#---------------------------------------
# AWS Provider Version: 6.28.0
# Resource: aws_ec2_transit_gateway_peering_attachment
# Generated: 2026-02-15
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_transit_gateway_peering_attachment
# NOTE: このテンプレートは参考実装です。実際の環境に合わせて適宜カスタマイズしてください。
#---------------------------------------

# Transit Gatewayピアリング接続を作成するリソース
# リージョン間またはアカウント間でTransit Gatewayを接続し、VPC間の通信を実現します
# 接続先のTransit Gatewayの所有者が接続リクエストを承認する必要があります

resource "aws_ec2_transit_gateway_peering_attachment" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # 設定内容: ローカル側（リクエスト元）のTransit Gateway ID
  # 説明: このリソースを作成するAWSアカウントが所有するTransit GatewayのIDを指定します
  transit_gateway_id = "tgw-0123456789abcdef0"

  # 設定内容: 接続先（ピア）のTransit Gateway ID
  # 説明: ピアリング接続を確立したい相手側のTransit GatewayのIDを指定します
  peer_transit_gateway_id = "tgw-0987654321fedcba0"

  # 設定内容: 接続先Transit Gatewayが存在するリージョン
  # 説明: ピアTransit Gatewayが配置されているAWSリージョンを指定します
  # 例: "us-west-2", "ap-northeast-1"など
  peer_region = "us-west-2"

  #---------------------------------------
  # オプションパラメータ - アカウント設定
  #---------------------------------------

  # 設定内容: 接続先Transit Gatewayを所有するAWSアカウントID
  # 省略時: 現在のAWSアカウントIDが使用されます（同一アカウント内のピアリング）
  # 説明: クロスアカウントピアリングを行う場合に、相手側のAWSアカウントIDを12桁の数字で指定します
  peer_account_id = "123456789012"

  # 設定内容: このリソースを管理するリージョン
  # 省略時: プロバイダー設定のリージョンが使用されます
  # 説明: マルチリージョン構成でリソース管理リージョンを明示的に指定する場合に使用します
  region = "us-east-1"

  #---------------------------------------
  # オプションパラメータ - ルーティング設定
  #---------------------------------------

  # 設定内容: ダイナミックルーティングの有効化オプション
  # 説明: BGPを使用した動的ルート交換を有効にする場合に設定します
  # 設定可能な値: "enable", "disable"
  # 省略時: ダイナミックルーティングは無効化され、スタティックルートのみ使用可能です
  # 注意: 従来はスタティックルーティングのみサポートされていましたが、
  #       ダイナミックルーティングを有効にすることでBGPによる自動ルート交換が可能です
  # options {
  #   dynamic_routing = "enable"
  # }

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグ
  # 説明: Transit Gatewayピアリング接続を識別・管理するためのキーバリューペアを指定します
  tags = {
    Name        = "example-tgw-peering"
    Environment = "production"
    Purpose     = "cross-region-connectivity"
  }

  # 設定内容: デフォルトタグを含む全てのタグ
  # 省略時: tagsで指定したタグとプロバイダーのdefault_tagsがマージされます
  # 説明: 通常は明示的な指定は不要で、Terraformが自動的に管理します
  # tags_all = {}
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースでは、以下の属性が参照可能です:
#
# id                       - Transit Gatewayピアリング接続のID（tgw-attach-xxxxx形式）
# arn                      - リソースのARN（Amazon Resource Name）
# state                    - 接続の現在の状態
#                           値: initiatingRequest（リクエスト初期化中）
#                               pendingAcceptance（承認待ち）
#                               available（利用可能）
#                               rejected（拒否済み）
#                               expired（期限切れ）
#                               failing（失敗中）
#                               failed（失敗）
#                               deleting（削除中）
#                               deleted（削除済み）
# peer_account_id          - 接続先Transit Gatewayを所有するAWSアカウントID
# region                   - このリソースが管理されているリージョン
# tags_all                 - デフォルトタグを含む全てのタグのマップ

#---------------------------------------
# 補足事項
#---------------------------------------
# ・ピアリング接続は作成後、接続先のAWSアカウント所有者が承認する必要があります
# ・承認はaws_ec2_transit_gateway_peering_attachment_accepterリソースで行います
# ・同一リージョン内のピアリング、または異なるリージョン間のピアリングの両方がサポートされます
# ・リージョン間通信はAWS内部ネットワークを使用し、AES-256で暗号化されます
# ・トラフィックをルーティングするには、Transit Gatewayルートテーブルに
#   ピアリング接続を指すスタティックルートを追加する必要があります
# ・ダイナミックルーティングを有効にする場合は、各Transit Gatewayに
#   異なるASN（自律システム番号）を割り当てることが推奨されます
# ・接続削除時は、関連するルートテーブルエントリも削除する必要があります
