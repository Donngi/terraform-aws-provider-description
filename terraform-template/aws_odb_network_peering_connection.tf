#---------------------------------------------------------------
# AWS ODB Network Peering Connection
#---------------------------------------------------------------
#
# Oracle Database@AWS (ODB) ネットワークと、別のODBネットワークまたは顧客所有のVPCとの間に
# ピアリング接続をプロビジョニングするリソースです。
# ピアリング接続により、アプリケーション層の通信のためのプライベートネットワーク接続が確立され、
# VPC内のアプリケーションからOracle Exadataデータベースへの低レイテンシアクセスが実現します。
# ODBネットワークがAWS RAMで共有されている場合は odb_network_id の代わりに odb_network_arn を
# 使用してください。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS ユーザーガイド: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#   - ODB ピアリング設定: https://docs.aws.amazon.com/odb/latest/UserGuide/configuring.html
#   - ODB の仕組み: https://docs.aws.amazon.com/odb/latest/UserGuide/how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_network_peering_connection
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_network_peering_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Required, Forces new resource)
  # 設定内容: ODBネットワークピアリング接続の表示名を指定します。
  # 設定可能な値: 文字列
  # 注意: この値を変更すると、Terraformは新しいリソースを作成します。
  display_name = "example-odb-peering"

  # peer_network_id (Required, Forces new resource)
  # 設定内容: ピアリング接続先となる、ODBピアリング接続の一意の識別子を指定します。
  #           接続先がVPCの場合はVPC ID、別のODBネットワークの場合はODBネットワークIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-12345678）または有効なODBネットワークID
  # 注意: この値を変更すると、Terraformは新しいリソースを作成します。
  peer_network_id = "vpc-12345678abcdef012"

  #-------------------------------------------------------------
  # ODBネットワーク識別設定
  #-------------------------------------------------------------

  # odb_network_id (Optional, Forces new resource)
  # 設定内容: ピアリング接続を開始するODBネットワークの一意の識別子を指定します。
  # 設定可能な値: 有効なODBネットワークID（例: odbpcx-abcdefgh12345678）
  # 省略時: AWSが値を計算（odb_network_arn を指定する場合は不要）
  # 注意: odb_network_id または odb_network_arn のいずれか一方を指定してください。
  #       AWS RAMで共有されているODBネットワークに接続する場合は odb_network_arn の使用を推奨します。
  #       この値を変更すると、Terraformは新しいリソースを作成します。
  odb_network_id = "odbpcx-abcdefgh12345678"

  # odb_network_arn (Optional)
  # 設定内容: ピアリング接続を開始するODBネットワークのARNを指定します。
  # 設定可能な値: 有効なODBネットワークARN
  # 省略時: AWSが値を計算（odb_network_id を指定する場合は不要）
  # 関連機能: AWS Resource Access Manager (AWS RAM) によるODBネットワーク共有
  #   AWS RAMで共有されているODBネットワークに接続する場合、odb_network_id ではなく
  #   odb_network_arn を指定する必要があります。
  #   - https://docs.aws.amazon.com/odb/latest/UserGuide/configuring.html
  odb_network_arn = null

  #-------------------------------------------------------------
  # ピアネットワーク設定
  #-------------------------------------------------------------

  # peer_network_cidrs (Optional)
  # 設定内容: ピア接続先ネットワークのCIDRブロック一覧を指定します。
  # 設定可能な値: CIDR表記の文字列の集合 (例: ["10.0.0.0/16", "10.1.0.0/16"])
  # 省略時: AWSが自動的にCIDR一覧を計算
  # 用途: ピアリング接続でルーティング対象となるピア側ネットワークの範囲を明示的に指定する場合に使用
  peer_network_cidrs = ["10.0.0.0/16"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-odb-peering"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: このリソースのCRUD操作のタイムアウト時間を指定する設定ブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m" などの時間文字列（s: 秒、m: 分、h: 時間）
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m" などの時間文字列（s: 秒、m: 分、h: 時間）
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m" などの時間文字列（s: 秒、m: 分、h: 時間）
    # 注意: destroy操作前にstateに変更が保存されている場合にのみ適用されます。
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ODBネットワークピアリング接続の一意の識別子
# - arn: ODBネットワークピアリング接続のARN
# - created_at: ODBネットワークピアリング接続が作成された日時
# - odb_peering_connection_type: ピアリング接続の種別 (ODB-VPC または ODB-ODB)
# - peer_network_arn: ピアネットワークのARN
# - percent_progress: ODBネットワークピアリング接続作成・削除の進捗率
# - status: ピアリング接続のステータス (AVAILABLE / FAILED / PROVISIONING 等)
# - status_reason: 現在のステータスの理由
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
