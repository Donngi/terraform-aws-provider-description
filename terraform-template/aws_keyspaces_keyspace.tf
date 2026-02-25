#---------------------------------------------------------------
# Amazon Keyspaces Keyspace
#---------------------------------------------------------------
#
# Amazon Keyspaces（Apache Cassandra向けマネージドサービス）のキースペースを
# プロビジョニングするリソースです。キースペースはテーブルの論理的なコンテナであり、
# 全テーブルが継承するレプリケーション戦略を定義します。
#
# AWS公式ドキュメント:
#   - Amazon Keyspacesキースペース概要: https://docs.aws.amazon.com/keyspaces/latest/devguide/what-is-keyspaces.html
#   - キースペースの作成: https://docs.aws.amazon.com/keyspaces/latest/devguide/getting-started.keyspaces.html
#   - マルチリージョンキースペース: https://docs.aws.amazon.com/keyspaces/latest/devguide/keyspaces-mrr-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/keyspaces_keyspace
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_keyspaces_keyspace" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: 作成するキースペースの名前を指定します。
  # 設定可能な値: 英数字とアンダースコアで構成された文字列
  # 注意: Amazon Keyspacesでは入力値が引用符で囲まれていない限り小文字に変換されます。
  # 参考: https://docs.aws.amazon.com/keyspaces/latest/devguide/getting-started.keyspaces.html
  name = "my_keyspace"

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
  # レプリケーション設定
  #-------------------------------------------------------------

  replication_specification {
    # replication_strategy (Optional)
    # 設定内容: キースペースのレプリケーション戦略を指定します。
    #           キースペース内の全テーブルがこの戦略を継承します。
    # 設定可能な値:
    #   - "SINGLE_REGION": 単一リージョンでのレプリケーション（デフォルト）
    #   - "MULTI_REGION": 複数リージョンへのレプリケーション。region_listの指定が必要
    # 省略時: プロバイダーが自動的に判断します。
    # 参考: https://docs.aws.amazon.com/keyspaces/latest/devguide/keyspaces-mrr-create.html
    replication_strategy = "SINGLE_REGION"

    # region_list (Optional)
    # 設定内容: レプリケーション先のリージョン一覧を指定します。
    # 設定可能な値: AWSリージョンコードのセット
    # 注意: replication_strategyが"MULTI_REGION"の場合、
    #       現在のリージョンと少なくとも1つの追加リージョンが必要です。
    # 参考: https://docs.aws.amazon.com/keyspaces/latest/devguide/keyspaces-mrr-create.html
    region_list = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウトを使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: Terraformのデフォルトタイムアウトを使用
    delete = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: プロバイダーレベルのdefault_tags設定
  #   プロバイダーのdefault_tagsブロックで定義されたタグと一致するキーを持つタグは
  #   プロバイダーレベルの設定を上書きします。
  tags = {
    Name        = "my-keyspace"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: キースペースのAmazon Resource Name (ARN)
#
# - id: キースペースの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
