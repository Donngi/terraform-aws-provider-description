#---------------------------------------------------------------
# AWS WorkSpaces Web Portal
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browser（WorkSpaces Web）のウェブポータルを
# プロビジョニングするリソースです。ウェブポータルは、ユーザーがブラウザを通じて
# 内部Webサイトやクラウドアプリケーションに安全にアクセスするためのエンドポイントです。
# VPCレス構成で動作し、専用クライアントソフトウェアやVPN接続が不要です。
#
# AWS公式ドキュメント:
#   - WorkSpaces Secure Browser ウェブポータル作成: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/getting-started-step1.html
#   - ポータル設定の構成: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/portal-settings.html
#   - ウェブポータルの管理: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/managing-web-portals.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_portal
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_portal" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # display_name (Optional)
  # 設定内容: ウェブポータルの表示名を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 表示名なし
  display_name = "example-portal"

  #-------------------------------------------------------------
  # インスタンス設定
  #-------------------------------------------------------------

  # instance_type (Optional)
  # 設定内容: ポータルのインスタンスタイプを指定します。
  #           同時セッション数に応じた処理能力を決定します。
  # 設定可能な値:
  #   - "standard.regular": 標準インスタンス（小〜中規模の同時セッション向け）
  #   - "standard.large": 大容量インスタンス（大規模な同時セッション向け）
  # 省略時: AWSによるデフォルト値が使用されます。
  instance_type = "standard.regular"

  # max_concurrent_sessions (Optional)
  # 設定内容: ポータルの最大同時セッション数を指定します。
  # 設定可能な値: 正の整数
  # 省略時: AWSによるデフォルト値が使用されます。
  max_concurrent_sessions = 10

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication_type (Optional)
  # 設定内容: ポータルの認証タイプを指定します。
  # 設定可能な値:
  #   - "Standard": 標準認証（SAML 2.0 IDプロバイダーを使用）
  #   - "IAM_Identity_Center": AWS IAM Identity Center（旧 AWS SSO）を使用した認証
  # 省略時: AWSによるデフォルト値（Standard）が使用されます。
  # 参考: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/web-portal-IAM.html
  authentication_type = "IAM_Identity_Center"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_managed_key (Optional, Forces new resource)
  # 設定内容: データの暗号化に使用するカスタマーマネージドKMSキーのARNを指定します。
  #           指定することで、WorkSpaces Webがデータをカスタマーマネージドキーで暗号化します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSマネージドキーによる暗号化が使用されます。
  # 注意: 変更するとリソースが再作成されます（Forces new resource）。
  customer_managed_key = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # additional_encryption_context (Optional, Forces new resource)
  # 設定内容: カスタマーマネージドキーに追加する暗号化コンテキストのマップを指定します。
  #           KMSの暗号化コンテキストはキーの使用範囲を制限し、セキュリティを向上させます。
  # 設定可能な値: 文字列キーと文字列値のペアのマップ
  # 省略時: 追加の暗号化コンテキストなし
  # 注意: 変更するとリソースが再作成されます（Forces new resource）。
  additional_encryption_context = {
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ブラウザ設定
  #-------------------------------------------------------------

  # browser_settings_arn (Optional)
  # 設定内容: ポータルに関連付けるブラウザ設定リソースのARNを指定します。
  #           ブラウザ設定では、URLフィルタリングやブラウザポリシーなどを構成できます。
  # 設定可能な値: 有効なaws_workspacesweb_browser_settingsリソースのARN
  # 省略時: ブラウザ設定なし（デフォルト設定が適用されます）
  browser_settings_arn = null

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
  # 設定可能な値: 文字列キーと文字列値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルのタグを上書きします。
  tags = {
    Name        = "example-portal"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "10m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの時間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - portal_arn: ポータルのARN
# - portal_endpoint: ポータルのエンドポイントURL（ユーザーがアクセスするURL）
# - portal_status: ポータルの現在のステータス（Incomplete / Pending / Active）
# - status_reason: ポータルの現在のステータスの理由
# - browser_type: ポータルのブラウザタイプ
# - renderer_type: ポータルのレンダラータイプ
# - creation_date: ポータルの作成日時
# - data_protection_settings_arn: 関連するデータ保護設定のARN
# - ip_access_settings_arn: 関連するIPアクセス設定のARN
# - network_settings_arn: 関連するネットワーク設定のARN
# - session_logger_arn: 関連するセッションロガーのARN
# - trust_store_arn: 関連するトラストストアのARN
# - user_access_logging_settings_arn: 関連するユーザーアクセスロギング設定のARN
# - user_settings_arn: 関連するユーザー設定のARN
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
