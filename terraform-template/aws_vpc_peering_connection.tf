#---------------------------------------------------------------
# AWS VPC Peering Connection
#---------------------------------------------------------------
#
# 2つのVPC間のVPCピアリング接続をプロビジョニングするリソースです。
# VPCピアリング接続は、プライベートIPv4/IPv6アドレスを使用して
# 2つのVPC間で通信を可能にするネットワーク接続です。
# 同一アカウント内、異なるアカウント間、異なるリージョン間での
# ピアリングが可能です。
#
# AWS公式ドキュメント:
#   - VPCピアリングの概要: https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
#   - VPCピアリング接続の作成: https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html
#   - VPCピアリング接続の操作: https://docs.aws.amazon.com/vpc/latest/peering/working-with-vpc-peering.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_peering_connection" "example" {
  #-------------------------------------------------------------
  # 必須設定 - VPC指定
  #-------------------------------------------------------------

  # vpc_id (Required)
  # 設定内容: リクエスター側VPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（vpc-xxxxxxxxxxxxxxxxx形式）
  # 関連機能: VPCピアリング接続
  #   ピアリング接続を確立するリクエスター側のVPCを指定します。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
  vpc_id = "vpc-0123456789abcdef0"

  # peer_vpc_id (Required)
  # 設定内容: ピアリング先（アクセプター側）VPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（vpc-xxxxxxxxxxxxxxxxx形式）
  # 関連機能: VPCピアリング接続
  #   ピアリング接続を確立するターゲットVPCを指定します。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
  peer_vpc_id = "vpc-0fedcba9876543210"

  #-------------------------------------------------------------
  # クロスアカウント・クロスリージョン設定
  #-------------------------------------------------------------

  # peer_owner_id (Optional)
  # 設定内容: ターゲットVPCを所有するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在接続しているAWSプロバイダーのアカウントIDが使用されます。
  # 関連機能: クロスアカウントVPCピアリング
  #   異なるAWSアカウント間でVPCピアリングを確立する場合に使用します。
  #   クロスアカウントピアリングでは、アクセプター側での承認が必要です。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html
  # 注意: クロスアカウント接続の場合は必ず指定してください。
  peer_owner_id = null

  # peer_region (Optional)
  # 設定内容: アクセプター側VPCのリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: リクエスター側VPCと同じリージョンが使用されます。
  # 関連機能: クロスリージョンVPCピアリング
  #   異なるリージョン間でVPCピアリングを確立する場合に使用します。
  #   クロスリージョンピアリングでは、auto_acceptをfalseに設定し、
  #   aws_vpc_peering_connection_accepterリソースで承認を管理する必要があります。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
  # 注意: クロスリージョン接続の場合、auto_acceptは使用できません。
  peer_region = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 自動承認設定
  #-------------------------------------------------------------

  # auto_accept (Optional)
  # 設定内容: ピアリング接続を自動的に承認するかを指定します。
  # 設定可能な値:
  #   - true: ピアリングリクエストを自動承認
  #   - false: 手動または別リソースで承認が必要
  # 省略時: false（自動承認しない）
  # 関連機能: VPCピアリング接続の承認
  #   両方のVPCが同一AWSアカウント・同一リージョンにある場合のみ使用可能です。
  #   クロスアカウントまたはクロスリージョンの場合は使用できません。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/create-vpc-peering-connection.html
  # 注意: peer_regionを指定した場合、auto_acceptはfalseである必要があります。
  #       クロスアカウント・クロスリージョンの場合は
  #       aws_vpc_peering_connection_accepterリソースを使用してください。
  auto_accept = true

  #-------------------------------------------------------------
  # アクセプター側オプション設定
  #-------------------------------------------------------------

  # accepter (Optional)
  # 設定内容: アクセプター側VPCのピアリングオプションを設定します。
  # 関連機能: VPCピアリングDNS解決オプション
  #   ピアリング接続でDNS解決を有効にすることで、パブリックDNSホスト名を
  #   プライベートIPアドレスに解決できます。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/working-with-vpc-peering.html
  # 注意: オプションを変更するにはピアリングがアクティブ状態である必要があります。
  #       クロスアカウント・クロスリージョンの場合は
  #       aws_vpc_peering_connection_optionsリソースの使用を推奨します。
  accepter {
    # allow_remote_vpc_dns_resolution (Optional)
    # 設定内容: ピアVPCのインスタンスからクエリされた場合、ローカルVPCの
    #          パブリックDNSホスト名をプライベートIPアドレスに解決することを許可します。
    # 設定可能な値:
    #   - true: DNS解決を許可
    #   - false: DNS解決を許可しない
    # 省略時: false
    # 関連機能: プライベートIPアドレスへのDNS解決
    #   この設定により、ピアVPC内のインスタンスはローカルVPCのインスタンスの
    #   パブリックDNSホスト名をプライベートIPアドレスに解決できます。
    #   - https://docs.aws.amazon.com/vpc/latest/peering/working-with-vpc-peering.html
    allow_remote_vpc_dns_resolution = true
  }

  #-------------------------------------------------------------
  # リクエスター側オプション設定
  #-------------------------------------------------------------

  # requester (Optional)
  # 設定内容: リクエスター側VPCのピアリングオプションを設定します。
  # 関連機能: VPCピアリングDNS解決オプション
  #   ピアリング接続でDNS解決を有効にすることで、パブリックDNSホスト名を
  #   プライベートIPアドレスに解決できます。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/working-with-vpc-peering.html
  # 注意: オプションを変更するにはピアリングがアクティブ状態である必要があります。
  #       クロスアカウント・クロスリージョンの場合は
  #       aws_vpc_peering_connection_optionsリソースの使用を推奨します。
  requester {
    # allow_remote_vpc_dns_resolution (Optional)
    # 設定内容: ピアVPCのインスタンスからクエリされた場合、ローカルVPCの
    #          パブリックDNSホスト名をプライベートIPアドレスに解決することを許可します。
    # 設定可能な値:
    #   - true: DNS解決を許可
    #   - false: DNS解決を許可しない
    # 省略時: false
    # 関連機能: プライベートIPアドレスへのDNS解決
    #   この設定により、ピアVPC内のインスタンスはローカルVPCのインスタンスの
    #   パブリックDNSホスト名をプライベートIPアドレスに解決できます。
    #   - https://docs.aws.amazon.com/vpc/latest/peering/working-with-vpc-peering.html
    allow_remote_vpc_dns_resolution = true
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を設定します。
  # 関連機能: Terraformタイムアウト設定
  #   各操作が完了するまでの最大待機時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = "15m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    update = "15m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    delete = "15m"
  }

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
    Name        = "example-vpc-peering"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCピアリング接続のID
#
# - accept_status: VPCピアリング接続リクエストのステータス
#                  (pending-acceptance, active, deleted, expired, rejected等)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
