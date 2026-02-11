#---------------------------------------------------------------
# MemoryDB Multi-Region Cluster
#---------------------------------------------------------------
#
# Amazon MemoryDB Multi-Regionクラスターをプロビジョニングする。
# MemoryDB Multi-Regionは、複数のAWSリージョン間でアクティブ-アクティブな
# レプリケーションを提供するフルマネージドのインメモリデータベースサービス。
# 最大99.999%の可用性、マイクロ秒単位の読み取りレイテンシ、
# ミリ秒単位の書き込みレイテンシを実現する。
#
# AWS公式ドキュメント:
#   - MemoryDB Multi-Region: https://docs.aws.amazon.com/memorydb/latest/devguide/multi-region.html
#   - How it works: https://docs.aws.amazon.com/memorydb/latest/devguide/multi-region.how.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_multi_region_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_multi_region_cluster" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # multi_region_cluster_name_suffix (Required, Forces new resource)
  # ----------------------------------------------------------------
  # マルチリージョンクラスター名に付加されるサフィックス。
  # AWSが自動生成するプレフィックスと組み合わせて最終的なクラスター名が決定される。
  # この値を変更すると、クラスターが再作成される。
  #
  # 例: "example" を指定すると、"virxk-example" のようなクラスター名が生成される
  multi_region_cluster_name_suffix = "example"

  # node_type (Required)
  # --------------------
  # マルチリージョンクラスターで使用するノードタイプ。
  # ノードタイプによってメモリ容量、CPU、ネットワーク性能が決まる。
  #
  # 使用可能なノードタイプの例:
  #   - db.r7g.large    : 汎用、メモリ最適化
  #   - db.r7g.xlarge   : より大きなワークロード向け
  #   - db.r7g.2xlarge  : 高負荷ワークロード向け
  #   - db.t4g.small    : 開発・テスト向け（低コスト）
  #   - db.t4g.medium   : 小規模本番ワークロード向け
  node_type = "db.r7g.xlarge"

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description (Optional)
  # ----------------------
  # マルチリージョンクラスターの説明文。
  # クラスターの用途や特性を記述するために使用する。
  #
  # 型: string
  # description = "Production multi-region cluster for user session data"

  # engine (Optional)
  # -----------------
  # マルチリージョンクラスターで使用するエンジン名。
  #
  # 有効な値:
  #   - "redis"  : Redis互換モード
  #   - "valkey" : Valkey（Linux Foundation管理のRedis OSS後継）
  #
  # 型: string
  # デフォルト: 指定しない場合はAWSのデフォルト値が適用される
  # engine = "valkey"

  # engine_version (Optional)
  # -------------------------
  # マルチリージョンクラスターで使用するエンジンのバージョン。
  # ダウングレードはサポートされていない点に注意。
  #
  # 型: string
  # engine_version = "7.1"

  # multi_region_parameter_group_name (Optional)
  # --------------------------------------------
  # クラスターに関連付けるマルチリージョンパラメータグループの名前。
  # パラメータグループでエンジンの動作設定をカスタマイズできる。
  #
  # 型: string
  # multi_region_parameter_group_name = "my-multi-region-parameter-group"

  # num_shards (Optional)
  # ---------------------
  # マルチリージョンクラスターのシャード数。
  # シャード数を増やすことで、データを分散してスループットを向上できる。
  #
  # 型: number
  # num_shards = 2

  # region (Optional)
  # -----------------
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用される。
  #
  # 型: string
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags (Optional)
  # ---------------
  # リソースに割り当てるタグのマップ。
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーのタグはこちらの値で上書きされる。
  #
  # 型: map(string)
  # tags = {
  #   Environment = "production"
  #   Project     = "my-project"
  # }

  # tls_enabled (Optional, Forces new resource)
  # -------------------------------------------
  # クラスターで転送中の暗号化（TLS）を有効にするかどうか。
  # セキュリティ要件に応じて有効化を検討する。
  # この値を変更すると、クラスターが再作成される。
  #
  # 型: bool
  # デフォルト: true（推奨）
  # tls_enabled = true

  # update_strategy (Optional)
  # --------------------------
  # クラスター更新時の戦略を指定する。
  #
  # 型: string
  # update_strategy = "coordinated"

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  #---------------------------------------------------------------
  # リソースの作成、更新、削除操作のタイムアウト値を設定する。
  # 大規模なクラスターや複雑な構成では、デフォルトのタイムアウトでは
  # 不十分な場合があるため、必要に応じて延長する。
  #
  # timeouts {
  #   # create (Optional)
  #   # -----------------
  #   # リソース作成のタイムアウト。
  #   # 形式: "30s", "5m", "2h45m" など（s=秒, m=分, h=時間）
  #   #
  #   # 型: string
  #   create = "120m"
  #
  #   # update (Optional)
  #   # -----------------
  #   # リソース更新のタイムアウト。
  #   # 形式: "30s", "5m", "2h45m" など（s=秒, m=分, h=時間）
  #   #
  #   # 型: string
  #   update = "120m"
  #
  #   # delete (Optional)
  #   # -----------------
  #   # リソース削除のタイムアウト。
  #   # 削除操作で状態がstateに保存された後にのみ適用される。
  #   # 形式: "30s", "5m", "2h45m" など（s=秒, m=分, h=時間）
  #   #
  #   # 型: string
  #   delete = "120m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、参照可能。
# これらはリソースブロック内で設定することはできない。
#
# arn
# ---
# マルチリージョンクラスターのARN（Amazon Resource Name）。
# 他のAWSサービスやIAMポリシーでこのリソースを参照する際に使用。
#
# 使用例: aws_memorydb_multi_region_cluster.this.arn
#
# multi_region_cluster_name
# -------------------------
# マルチリージョンクラスターの完全な名前。
# AWSが生成したプレフィックスと指定したサフィックスを組み合わせた名前。
# 各リージョンのクラスターをこのマルチリージョンクラスターに関連付ける際に使用。
#
# 使用例: aws_memorydb_multi_region_cluster.this.multi_region_cluster_name
#
# status
# ------
# マルチリージョンクラスターの現在のステータス。
#
# 使用例: aws_memorydb_multi_region_cluster.this.status
#
# tags_all
# --------
# リソースに割り当てられた全タグのマップ。
# プロバイダーレベルの default_tags で設定されたタグを含む。
#
# 使用例: aws_memorydb_multi_region_cluster.this.tags_all
#---------------------------------------------------------------
