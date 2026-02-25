#---------------------------------------------------------------
# AWS QuickSight Namespace
#---------------------------------------------------------------
#
# Amazon QuickSightのネームスペースをプロビジョニングするリソースです。
# ネームスペースはユーザーとグループを論理的に分離するコンテナであり、
# マルチテナント環境において異なるクライアント・部門・チームを
# 独立したセキュリティ境界でアイソレーションするために使用されます。
# ネームスペース内のユーザーは同一ネームスペースのユーザーとのみ
# アセットを共有できます。
#
# AWS公式ドキュメント:
#   - QuickSight ネームスペース概要: https://docs.aws.amazon.com/quicksight/latest/user/namespaces.html
#   - CreateNamespace API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateNamespace.html
#   - ネームスペース操作: https://docs.aws.amazon.com/quicksight/latest/developerguide/namespace-operations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_namespace
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_namespace" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # namespace (Required, Forces new resource)
  # 設定内容: ネームスペースの名前を指定します。
  # 設定可能な値: 最大64文字。英数字、ハイフン、アンダースコア、ピリオドが使用可能 (パターン: ^[a-zA-Z0-9._-]*$)
  # 注意: AWSアカウント内で一意である必要があります。デフォルトネームスペース名 "default" は既存のため使用不可
  namespace = "example"

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: ネームスペースを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁の数字からなるAWSアカウントID
  # 省略時: TerraformのAWSプロバイダーで自動的に決定されるアカウントIDを使用
  aws_account_id = null

  #-------------------------------------------------------------
  # アイデンティティ設定
  #-------------------------------------------------------------

  # identity_store (Optional)
  # 設定内容: ネームスペースで使用するユーザーアイデンティティディレクトリのタイプを指定します。
  # 設定可能な値:
  #   - "QUICKSIGHT": QuickSightのネイティブユーザーディレクトリを使用（現在唯一の有効値）
  # 省略時: "QUICKSIGHT" が使用されます
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateNamespace.html
  identity_store = "QUICKSIGHT"

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
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-namespace"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m" 等のduration文字列（s: 秒、m: 分、h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "60m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s"、"2h45m" 等のduration文字列（s: 秒、m: 分、h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    # 注意: destroyオペレーション前にstateへ変更が保存されている場合にのみ有効
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ネームスペースのAmazon Resource Name (ARN)
# - capacity_region: ネームスペースのAWSリージョン
# - creation_status: ネームスペースの作成ステータス
#                    (CREATED / CREATING / DELETING / RETRYABLE_FAILURE / NON_RETRYABLE_FAILURE)
# - id: AWSアカウントIDとネームスペースをカンマ区切りで結合した文字列
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
