#---------------------------------------------------------------
# AWS WorkSpaces Connection Alias
#---------------------------------------------------------------
#
# Amazon WorkSpacesのコネクションエイリアスをプロビジョニングするリソースです。
# コネクションエイリアスは、クロスリージョンリダイレクションに使用され、
# ユーザーがプライマリリージョンのWorkSpacesが利用不可の場合に、
# 指定されたフェイルオーバーリージョンのWorkSpacesに接続できるようにします。
# コネクションエイリアスはFQDN（完全修飾ドメイン名）形式の接続文字列を持ち、
# DNSルーティングポリシーと組み合わせてリージョンの復元力を実現します。
#
# AWS公式ドキュメント:
#   - Cross-Region redirection for WorkSpaces Personal: https://docs.aws.amazon.com/workspaces/latest/adminguide/cross-region-redirection.html
#   - ConnectionAlias API Reference: https://docs.aws.amazon.com/workspaces/latest/api/API_ConnectionAlias.html
#   - CreateConnectionAlias API Reference: https://docs.aws.amazon.com/workspaces/latest/api/API_CreateConnectionAlias.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_connection_alias
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspaces_connection_alias" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # connection_string (Required)
  # 設定内容: コネクションエイリアスに指定する接続文字列を指定します。
  # 設定可能な値: FQDN（完全修飾ドメイン名）形式の文字列（例: www.example.com）
  #   - 1〜255文字
  #   - 使用可能文字: 英数字、ハイフン、ドット（パターン: ^[.0-9a-zA-Z\-]{1,255}$）
  # 注意: 接続文字列は作成後にアカウントでグローバルに予約されます。
  #       クロスリージョンリダイレクション機能で使用するため、
  #       DNSルーティングポリシーと合わせて設定する必要があります。
  # 参考: https://docs.aws.amazon.com/workspaces/latest/adminguide/cross-region-redirection.html
  connection_string = "workspaces.example.com"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
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
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-workspaces-connection-alias"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 数値と単位サフィックスの文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 数値と単位サフィックスの文字列（例: "30s", "5m", "1h"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コネクションエイリアスの識別子。
#
# - owner_account_id: コネクションエイリアスを所有するAWSアカウントの識別子。
#
# - state: コネクションエイリアスの現在の状態。
#          有効な値: CREATING, CREATED, DELETING
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
