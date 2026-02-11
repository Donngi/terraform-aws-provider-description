#---------------------------------------------------------------
# AWS VPC Peering Connection Accepter
#---------------------------------------------------------------
#
# VPCピアリング接続のアクセプター（受け入れ側）を管理するリソースです。
# クロスアカウント（リクエスター側のAWSアカウントとアクセプター側のAWSアカウントが異なる）
# または、リージョン間VPCピアリング接続が作成された場合、アクセプター側のアカウントに
# VPCピアリング接続リソースが自動的に作成されます。
# リクエスター側はaws_vpc_peering_connectionリソースで接続を管理し、
# アクセプター側はこのaws_vpc_peering_connection_accepterリソースで
# 接続の「受け入れ」をTerraform管理下に置くことができます。
#
# AWS公式ドキュメント:
#   - VPCピアリングとは: https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
#   - VPCピアリング接続の受け入れ: https://docs.aws.amazon.com/vpc/latest/peering/accept-vpc-peering-connection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_peering_connection_accepter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_peering_connection_id (Required)
  # 設定内容: 管理対象のVPCピアリング接続IDを指定します。
  # 設定可能な値: 有効なVPCピアリング接続ID（例: pcx-xxxxxxxxxxxxxxxxx）
  # 注意: このIDはリクエスター側のaws_vpc_peering_connectionリソースから取得します。
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  # auto_accept (Optional)
  # 設定内容: ピアリングリクエストを自動的に受け入れるかどうかを指定します。
  # 設定可能な値:
  #   - true: ピアリングリクエストを自動的に受け入れます
  #   - false: 手動での受け入れが必要です
  # 省略時: false
  # 注意: クロスアカウントピアリングの場合、アクセプター側でtrueに設定することで
  #       リクエストを自動的に受け入れることができます。
  auto_accept = true

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1, us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: リージョン間ピアリングの場合、アクセプター側のVPCが存在するリージョンを指定します。
  #       Provider v6以降では、provider aliasの代わりにこの属性でリージョンを指定できます。
  region = null

  #-------------------------------------------------------------
  # ピアリングオプション設定（アクセプター側）
  #-------------------------------------------------------------

  # accepter (Optional)
  # 設定内容: アクセプター側VPCのピアリング接続オプションを設定します。
  # 関連機能: VPCピアリング接続オプション
  #   ピアリング接続を介したDNS解決などの機能を制御できます。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
  accepter {
    # allow_remote_vpc_dns_resolution (Optional)
    # 設定内容: ピアVPCのインスタンスからクエリされた場合、ローカルVPCがパブリックDNS
    #           ホスト名をプライベートIPアドレスに解決できるようにするかを指定します。
    # 設定可能な値:
    #   - true: リモートVPCからのDNS解決を許可します
    #   - false: リモートVPCからのDNS解決を許可しません
    # 省略時: false
    # 関連機能: VPCピアリング DNS解決
    #   この機能を有効にすると、ピアリング接続を介してプライベートIPアドレスで
    #   相手側VPCのリソースにアクセスできるようになります。両側のVPCで
    #   enableDnsHostnamesとenableDnsSupportがtrueである必要があります。
    allow_remote_vpc_dns_resolution = true
  }

  #-------------------------------------------------------------
  # ピアリングオプション設定（リクエスター側）
  #-------------------------------------------------------------

  # requester (Optional)
  # 設定内容: リクエスター側VPCのピアリング接続オプションを設定します。
  # 関連機能: VPCピアリング接続オプション
  #   ピアリング接続を介したDNS解決などの機能を制御できます。
  #   - https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
  # 注意: 通常、リクエスター側のオプションはaws_vpc_peering_connectionリソースで
  #       設定しますが、このリソースでも設定可能です。
  requester {
    # allow_remote_vpc_dns_resolution (Optional)
    # 設定内容: ピアVPCのインスタンスからクエリされた場合、ローカルVPCがパブリックDNS
    #           ホスト名をプライベートIPアドレスに解決できるようにするかを指定します。
    # 設定可能な値:
    #   - true: リモートVPCからのDNS解決を許可します
    #   - false: リモートVPCからのDNS解決を許可しません
    # 省略時: false
    allow_remote_vpc_dns_resolution = true
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "accepter-vpc-peering"
    Side        = "Accepter"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "5m"
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
#        （例: pending-acceptance, active, deleted, rejected, expired）
#
# - vpc_id: アクセプター側VPCのID
#
# - peer_vpc_id: リクエスター側VPCのID
#
# - peer_owner_id: リクエスター側VPCを所有するAWSアカウントID
#
# - peer_region: アクセプター側VPCのリージョン
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
