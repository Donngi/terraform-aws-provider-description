#======================================================================================================
# Amazon CloudFront Connection Group
#======================================================================================================
# Generated: 2026-01-18
# Provider version: 6.28.0
#
# 注意: このテンプレートは生成時点(2026-01-18)の情報に基づいています。
# 最新の仕様については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_connection_group
#======================================================================================================

resource "aws_cloudfront_connection_group" "example" {
  #--------------------------------------------------
  # Required Attributes
  #--------------------------------------------------

  # name - (Required) 接続グループの名前
  # CloudFront接続グループを識別するための名前。
  # マルチテナントディストリビューションで使用される接続グループの管理に使用されます。
  # 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/custom-connection-group.html
  name = "example-connection-group"

  #--------------------------------------------------
  # Optional Attributes
  #--------------------------------------------------

  # anycast_ip_list_id - (Optional) Anycast静的IPリストのID
  # 接続グループに関連付けるAnycast静的IPリストのID。
  # Anycast静的IPは、ゼロレーティングやIPアドレスの許可リスト管理に使用されます。
  # 参考: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/request-static-ips.html
  anycast_ip_list_id = "example-anycast-ip-list-id"

  # enabled - (Optional) 接続グループを有効化するかどうか
  # 接続グループを有効にするかどうかを指定します。
  # デフォルトではcomputedされた値が使用されます。
  enabled = true

  # ipv6_enabled - (Optional) IPv6を有効化するかどうか
  # 接続グループでIPv6を有効にするかどうかを指定します。
  # IPv6を有効にすると、クライアントはIPv6アドレスを使用してコンテンツにアクセスできます。
  # デフォルトではcomputedされた値が使用されます。
  ipv6_enabled = true

  # tags - (Optional) リソースに割り当てるタグのマップ
  # 接続グループに適用するタグ。
  # プロバイダーレベルでdefault_tagsが設定されている場合、同じキーのタグは上書きされます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # wait_for_deployment - (Optional) デプロイメントの完了を待機するかどうか
  # 接続グループのデプロイメントが完了するまでTerraformが待機するかどうかを指定します。
  # デフォルトではcomputedされた値が使用されます。
  wait_for_deployment = true

  #--------------------------------------------------
  # Timeouts Block (Optional)
  #--------------------------------------------------
  # 接続グループの作成、更新、削除操作のタイムアウトを設定します。
  # デフォルトは各操作で90分です。
  timeouts {
    # create - (Optional) 接続グループの作成タイムアウト
    # 時間単位の文字列 (例: "30s", "2h45m")
    # 有効な単位: "s" (秒), "m" (分), "h" (時間)
    # デフォルト: 90分
    create = "90m"

    # update - (Optional) 接続グループの更新タイムアウト
    # 時間単位の文字列 (例: "30s", "2h45m")
    # 有効な単位: "s" (秒), "m" (分), "h" (時間)
    # デフォルト: 90分
    update = "90m"

    # delete - (Optional) 接続グループの削除タイムアウト
    # 時間単位の文字列 (例: "30s", "2h45m")
    # 有効な単位: "s" (秒), "m" (分), "h" (時間)
    # デフォルト: 90分
    delete = "90m"
  }
}

#======================================================================================================
# Computed Attributes (Read-Only)
#======================================================================================================
# 以下の属性はTerraformによって自動的に計算され、リソース作成後に参照可能です。
#
# - id                  : 接続グループのID
# - arn                 : 接続グループのARN (Amazon Resource Name)
# - status              : 接続グループの現在のステータス
# - is_default          : ディストリビューションテナントのデフォルト接続グループかどうか
# - routing_endpoint    : 接続グループに割り当てられたルーティングエンドポイント(DNS名)
#                         例: d111111abcdef8.cloudfront.net
# - last_modified_time  : 接続グループが最後に変更された日時
# - etag                : 接続グループの現在のバージョン
# - tags_all            : リソースに割り当てられたすべてのタグ(プロバイダーのdefault_tagsを含む)
#
# これらの属性は、他のリソースの参照や出力値として使用できます。
# 例: aws_cloudfront_connection_group.example.arn
#======================================================================================================
