#---------------------------------------------------------------
# AWS Network Manager Global Network
#---------------------------------------------------------------
#
# AWS Network Manager のグローバルネットワークを作成・管理する。
# グローバルネットワークは、Transit Gateway やコアネットワークなどの
# ネットワークオブジェクトのコンテナとして機能する単一のプライベート
# ネットワークである。
#
# AWS公式ドキュメント:
#   - グローバルネットワークの作成: https://docs.aws.amazon.com/network-manager/latest/cloudwan/create-global-network.html
#   - Transit Gateway用グローバルネットワーク: https://docs.aws.amazon.com/network-manager/latest/tgwnm/global-networks-creating.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_global_network
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_global_network" "this" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # description (任意, string)
  # グローバルネットワークの説明文。
  # このネットワークの用途や目的を記述することで、複数のグローバル
  # ネットワークを管理する際の識別に役立つ。
  description = null

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags (任意, map(string))
  # グローバルネットワークに付与するキーバリュー形式のタグ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグはこちらの値で上書きされる。
  tags = {
    Name = "example-global-network"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts (任意, block)
  # リソースの作成・更新・削除操作のタイムアウト時間を設定する。
  # 大規模なグローバルネットワークや複雑な構成の場合、
  # デフォルトのタイムアウトでは不十分な場合がある。
  timeouts {
    # create (任意, string)
    # リソース作成時のタイムアウト時間。
    # 例: "30m" (30分), "1h" (1時間)
    create = null

    # update (任意, string)
    # リソース更新時のタイムアウト時間。
    # 例: "30m" (30分), "1h" (1時間)
    update = null

    # delete (任意, string)
    # リソース削除時のタイムアウト時間。
    # 関連リソースが多い場合は削除に時間がかかることがある。
    # 例: "30m" (30分), "1h" (1時間)
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (参照専用属性)
#---------------------------------------------------------------
#
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能。
#
# arn (string)
#   グローバルネットワークのARN（Amazon Resource Name）。
#   形式: arn:aws:networkmanager::<account-id>:global-network/<global-network-id>
#
# id (string)
#   グローバルネットワークのID。
#
# tags_all (map(string))
#   プロバイダーレベルの default_tags と リソースレベルの tags を
#   マージした全てのタグ。
#
#---------------------------------------------------------------
