#---------------------------------------------------------------
# ODB Network Peering Connection
#---------------------------------------------------------------
#
# ODB（Oracle Database@AWS）ネットワークと、別のODBネットワークまたは
# 顧客所有のVPCとの間のピアリング接続を管理するリソース。
#
# ODBネットワークが共有されている場合は、odb_network_idではなく
# odb_network_arnを使用してピアリング接続を作成する必要がある。
#
# AWS公式ドキュメント:
#   - Oracle Database@AWS User Guide: https://docs.aws.amazon.com/odb/latest/UserGuide/what-is-odb.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/odb_network_peering_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_odb_network_peering_connection" "this" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # display_name (Required, Forces new resource)
  # ODBネットワークピアリング接続の表示名。
  # この値を変更すると、リソースが再作成される。
  display_name = "example-odb-peering"

  # peer_network_id (Required, Forces new resource)
  # ピアリング先のネットワークの一意識別子。
  # ODB間ピアリングの場合は別のODBネットワークID、VPCピアリングの場合はVPC IDを指定する。
  # この値を変更すると、リソースが再作成される。
  peer_network_id = "vpc-xxxxxxxxxxxxxxxxx"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # odb_network_id (Optional, Forces new resource)
  # ピアリング接続を開始するODBネットワークの一意識別子。
  # 例: "odbpcx-abcdefgh12345678"
  # odb_network_idまたはodb_network_arnのいずれか一方を指定する必要がある。
  # ODBネットワークが共有されている場合は、odb_network_arnを使用する。
  # この値を変更すると、リソースが再作成される。
  odb_network_id = null

  # odb_network_arn (Optional, Forces new resource)
  # ピアリング接続を開始するODBネットワークのARN。
  # ODBネットワークが共有されている場合は、odb_network_idではなくこちらを使用する。
  # odb_network_idまたはodb_network_arnのいずれか一方を指定する必要がある。
  # この値を変更すると、リソースが再作成される。
  odb_network_arn = null

  # region (Optional)
  # このリソースが管理されるAWSリージョン。
  # 指定しない場合は、プロバイダー設定のリージョンがデフォルトで使用される。
  # 参照: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # tags (Optional)
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーのタグはプロバイダーレベルの設定を上書きする。
  tags = {
    Name        = "example-odb-peering"
    Environment = "dev"
  }

  #---------------------------------------------------------------
  # Timeouts Block (Optional)
  #---------------------------------------------------------------
  # リソースの作成・更新・削除操作のタイムアウト時間を指定する。
  # 値は "30s", "5m", "2h45m" のような形式で指定する。
  # 有効な時間単位: "s"（秒）, "m"（分）, "h"（時）

  timeouts {
    # create (Optional)
    # リソース作成時のタイムアウト時間。
    create = "60m"

    # update (Optional)
    # リソース更新時のタイムアウト時間。
    update = "60m"

    # delete (Optional)
    # リソース削除時のタイムアウト時間。
    # 削除タイムアウトは、破棄操作の前に状態が保存される場合にのみ適用される。
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 上記の引数に加えて、以下の属性がエクスポートされる:
#
# id
#   ODBネットワークピアリング接続の一意識別子。
#
# arn
#   ODBネットワークピアリング接続のARN。
#
# status
#   ODBネットワークピアリング接続のステータス。
#
# status_reason
#   ODBピアリング接続の現在のステータスの理由。
#
# peer_network_arn
#   ピアネットワークピアリング接続のARN。
#
# odb_peering_connection_type
#   ODBピアリング接続のタイプ。
#
# created_at
#   ODBネットワークピアリング接続の作成日時。
#
# percent_progress
#   ODBネットワークピアリング接続の進捗率。
#
# tags_all
#   プロバイダーレベルの default_tags から継承されたタグを含む、
#   リソースに割り当てられた全タグのマップ。
#---------------------------------------------------------------
