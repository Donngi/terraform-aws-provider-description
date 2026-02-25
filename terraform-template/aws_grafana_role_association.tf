#---------------------------------------------------------------
# Amazon Managed Grafana ロール関連付け
#---------------------------------------------------------------
#
# Amazon Managed Grafana ワークスペースにユーザーまたはグループをロールに
# 関連付けるリソースです。IAM Identity Center（旧SSO）と連携して、
# Grafana ワークスペースへのアクセス権限をユーザーやグループに付与します。
#
# AWS公式ドキュメント:
#   - Amazon Managed Grafana ユーザー権限:
#       https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-permissions.html
#   - Amazon Managed Grafana ワークスペース:
#       https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-workspace.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_grafana_role_association" "example" {
  #-------------------------------------------------------------
  # ワークスペース設定
  #-------------------------------------------------------------

  # workspace_id (Required)
  # 設定内容: ロール関連付けを行うGrafanaワークスペースのIDを指定します。
  # 設定可能な値: aws_grafana_workspace リソースの id 属性
  workspace_id = "g-xxxxxxxxxxxx"

  #-------------------------------------------------------------
  # ロール設定
  #-------------------------------------------------------------

  # role (Required)
  # 設定内容: ユーザーまたはグループに付与するGrafanaのロールを指定します。
  # 設定可能な値:
  #   - "ADMIN": ワークスペースへの完全な管理アクセス権限
  #   - "EDITOR": ダッシュボードの作成・編集権限
  #   - "VIEWER": ダッシュボードの閲覧のみの権限
  role = "VIEWER"

  #-------------------------------------------------------------
  # ユーザー・グループ設定
  #-------------------------------------------------------------

  # user_ids (Optional)
  # 設定内容: 指定したロールを付与するIAM Identity CenterユーザーIDの
  #          セットを指定します。
  # 設定可能な値: IAM Identity Center（旧AWS SSO）のユーザーIDの集合
  # 省略時: ユーザーへの関連付けなし
  # 注意: user_ids と group_ids の少なくとも一方を指定する必要があります
  user_ids = [
    "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  ]

  # group_ids (Optional)
  # 設定内容: 指定したロールを付与するIAM Identity CenterグループIDの
  #          セットを指定します。
  # 設定可能な値: IAM Identity Center（旧AWS SSO）のグループIDの集合
  # 省略時: グループへの関連付けなし
  # 注意: user_ids と group_ids の少なくとも一方を指定する必要があります
  group_ids = [
    "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" などのGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "1h" などのGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ロール関連付けを識別するID（workspace_id と role の組み合わせ）
#---------------------------------------------------------------
