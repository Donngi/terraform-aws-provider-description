#---------------------------------------------------------------
# Amazon Neptune Analytics Graph
#---------------------------------------------------------------
#
# Amazon Neptune Analytics（Neptune Graph）のグラフをプロビジョニングするリソースです。
# Neptune Analytics はメモリ最適化グラフデータベースエンジンであり、大規模グラフの
# 分析クエリやベクトル検索を低レイテンシで実行できます。
#
# AWS公式ドキュメント:
#   - Neptune Analytics ユーザーガイド: https://docs.aws.amazon.com/neptune-analytics/latest/userguide/what-is-neptune-analytics.html
#   - グラフの作成: https://docs.aws.amazon.com/neptune-analytics/latest/apiref/API_CreateGraph.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptunegraph_graph
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_neptunegraph_graph" "example" {
  #-------------------------------------------------------------
  # 容量設定
  #-------------------------------------------------------------

  # provisioned_memory (Required)
  # 設定内容: グラフに割り当てるメモリ最適化Neptune Capacity Units（m-NCUs）の数を指定します。
  # 設定可能な値: 正の整数。有効な値は16, 32, 64, 128, 256, 384, 512, 768, 1024 など
  #   グラフデータが増加した場合は更新によって拡張が可能ですが、
  #   縮小する場合はすべてのデータを収容できるサイズ以上である必要があります。
  # 参考: https://docs.aws.amazon.com/neptune-analytics/latest/userguide/managing-modifying.html
  provisioned_memory = 16

  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # graph_name (Optional, Forces new resource)
  # 設定内容: グラフの名前を指定します。
  # 設定可能な値: 1〜63文字の英字・数字・ハイフンの文字列。
  #   先頭は英字である必要があり、末尾をハイフンにすることや連続ハイフンは不可。
  # 省略時: プレフィックス "graph-for-" に続くスタック名とUUIDの組み合わせで自動生成されます。
  # 注意: graph_name_prefix と同時に指定できません。
  graph_name = "my-neptune-graph"

  # graph_name_prefix (Optional, Forces new resource)
  # 設定内容: グラフ名のプレフィックスを指定します。Terraformが後ろに一意のサフィックスを付加します。
  # 設定可能な値: 文字列（graph_name の命名規則に準じたプレフィックス部分）
  # 省略時: graph_name が使用されます。
  # 注意: graph_name と同時に指定できません。
  graph_name_prefix = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # public_connectivity (Optional)
  # 設定内容: グラフをインターネット経由で到達可能にするかを指定します。
  #   グラフへのすべてのアクセスはIAM認証が必要です。
  #   公開時はDNSエンドポイントがパブリックIPに解決されます。
  #   非公開時はVPC内のPrivateGraphEndpointを作成して接続します。
  # 設定可能な値:
  #   - true: インターネットからアクセス可能
  #   - false: プライベートアクセスのみ（VPC経由）
  # 省略時: false（プライベートアクセスのみ）
  # 参考: https://docs.aws.amazon.com/neptune-analytics/latest/userguide/what-is-neptune-analytics.html
  public_connectivity = false

  #-------------------------------------------------------------
  # レプリカ設定
  #-------------------------------------------------------------

  # replica_count (Optional)
  # 設定内容: 他のアベイラビリティーゾーンに配置するレプリカ数を指定します。
  # 設定可能な値: 0〜2 の整数
  #   - 0: レプリカなし（シングルAZ構成）
  #   - 1: 別AZに1つのレプリカ
  #   - 2: 別AZに2つのレプリカ（高可用性構成）
  # 省略時: 0（レプリカなし）
  replica_count = 0

  #-------------------------------------------------------------
  # 削除保護設定
  #-------------------------------------------------------------

  # deletion_protection (Optional)
  # 設定内容: グラフの削除保護を有効にするかを指定します。
  #   削除保護が有効な場合、グラフは削除できません。
  # 設定可能な値:
  #   - true: 削除保護を有効化
  #   - false: 削除保護を無効化
  # 省略時: false（削除保護なし）
  deletion_protection = false

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_identifier (Optional, Forces new resource)
  # 設定内容: グラフ内のデータ暗号化に使用するKMSキーを指定します。
  # 設定可能な値: KMSキーのARN（例: arn:aws:kms:us-east-1:123456789012:key/...）
  # 省略時: AWSマネージドキーで暗号化されます。
  # 注意: 作成後に変更することはできません（Forces new resource）。
  # 参考: https://docs.aws.amazon.com/neptune-analytics/latest/apiref/API_CreateGraph.html
  kms_key_identifier = null

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
  tags = {
    Name        = "my-neptune-graph"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ベクトル検索設定
  #-------------------------------------------------------------

  # vector_search_configuration (Optional, Forces new resource)
  # 設定内容: グラフのベクトル検索機能を設定するブロックです。
  #   ベクトル検索を有効化すると、グラフトラバーサル内でベクトル類似検索が可能になります。
  #   RAGワークフローや機械学習の埋め込みベクトルの格納・検索に活用できます。
  # 注意: 作成後に変更することはできません（Forces new resource）。
  # 参考: https://docs.aws.amazon.com/neptune-analytics/latest/userguide/what-is-neptune-analytics.html
  vector_search_configuration {
    # vector_search_dimension (Optional)
    # 設定内容: ベクトル埋め込みの次元数を指定します。
    # 設定可能な値: 1〜65,535 の整数
    #   使用する埋め込みモデルの出力次元数に合わせて設定します。
    #   例: Amazon Titan Embeddings V2（1024次元）、OpenAI text-embedding-3-small（1536次元）
    vector_search_dimension = 1536
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: グラフ作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s: 秒, m: 分, h: 時間）
    create = "60m"

    # update (Optional)
    # 設定内容: グラフ更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s: 秒, m: 分, h: 時間）
    update = "60m"

    # delete (Optional)
    # 設定内容: グラフ削除操作のタイムアウト時間を指定します。
    #   destroyオペレーション実行前にstateに保存された変更がある場合のみ適用されます。
    # 設定可能な値: "30s", "5m", "2h" などの時間文字列（s: 秒, m: 分, h: 時間）
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: サービスによって自動生成されたグラフの識別子
# - arn: グラフリソースのARN（Amazon Resource Name）
# - endpoint: グラフの接続エンドポイント
#             例: g-12a3bcdef4.us-east-1.neptune-graph.amazonaws.com
# - tags_all: プロバイダーのdefault_tags設定から継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
