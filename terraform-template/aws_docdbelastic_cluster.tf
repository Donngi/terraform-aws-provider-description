#---------------------------------------------------------------
# Amazon DocumentDB Elastic Cluster
#---------------------------------------------------------------
#
# Amazon DocumentDB Elastic Clusterをプロビジョニングするリソースです。
# Elastic Clustersは、ハッシュベースのシャーディングによりデータを複数の
# シャードに分散し、ペタバイト規模のデータを処理できるスケーラブルな
# ドキュメントデータベースソリューションです。
#
# AWS公式ドキュメント:
#   - Elastic Clusters概要: https://docs.aws.amazon.com/documentdb/latest/developerguide/docdb-using-elastic-clusters.html
#   - Elastic Clustersの仕組み: https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-how-it-works.html
#   - ベストプラクティス: https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-best-practices.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdbelastic_cluster
#
# Provider Version: 6.37.0
# Generated: 2026-03-20
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdbelastic_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Elastic DocumentDBクラスターの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  name = "my-docdb-elastic-cluster"

  # admin_user_name (Required)
  # 設定内容: Elastic DocumentDBクラスター管理者のユーザー名を指定します。
  # 設定可能な値: 有効なユーザー名文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  admin_user_name = "docdbadmin"

  # admin_user_password (Required, Sensitive)
  # 設定内容: Elastic DocumentDBクラスター管理者のパスワードを指定します。
  # 設定可能な値: 印刷可能なASCII文字を含む文字列（8文字以上）
  # 注意: この値はTerraformのステートファイルに保存されるため、
  #       本番環境ではAWS Secrets Managerなどの利用を検討してください。
  admin_user_password = "mustbeeightchars"

  # auth_type (Required)
  # 設定内容: Elastic DocumentDBクラスターの認証タイプを指定します。
  # 設定可能な値:
  #   - "PLAIN_TEXT": プレーンテキスト認証（ユーザー名とパスワード）
  #   - "SECRET_ARN": AWS Secrets Managerに保存されたシークレットを使用
  # 注意: SECRET_ARNを使用する場合は、admin_user_passwordにシークレットのARNを指定
  auth_type = "PLAIN_TEXT"

  # shard_capacity (Required)
  # 設定内容: 各Elasticクラスターシャードに割り当てるvCPU数を指定します。
  # 設定可能な値: 2, 4, 8, 16, 32, 64（最大64）
  # 関連機能: Elastic Clustersのスケーリング
  #   垂直スケーリングにより、シャードあたりのvCPU数を調整できます。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-managing.html
  shard_capacity = 2

  # shard_count (Required)
  # 設定内容: Elasticクラスターに割り当てるシャード数を指定します。
  # 設定可能な値: 1〜32（最大32）
  # 関連機能: Elastic Clustersのスケーリング
  #   水平スケーリングにより、シャード数を追加または削除できます。
  #   各シャードは2つのノードを異なるアベイラビリティゾーンにデプロイします。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-how-it-works.html
  shard_count = 1

  #-------------------------------------------------------------
  # シャードレプリカ設定 (Optional)
  #-------------------------------------------------------------

  # shard_instance_count (Optional)
  # 設定内容: Elastic Clusterの全シャードに適用されるレプリカインスタンス数を指定します。
  # 設定可能な値: 1以上の整数
  # 省略時: デフォルト値2が設定されます
  # 関連機能: Elastic Clustersの高可用性
  #   各シャードのレプリカ数を増やすことで、読み取りスループットの向上と
  #   高可用性を実現できます。レプリカは異なるアベイラビリティゾーンに配置されます。
  shard_instance_count = 2

  #-------------------------------------------------------------
  # バックアップ設定 (Optional)
  #-------------------------------------------------------------

  # backup_retention_period (Optional)
  # 設定内容: 自動スナップショットを保持する日数を指定します。
  # 設定可能な値: 1〜35の整数
  # 省略時: デフォルト値1が設定されます
  # 関連機能: Elastic Clustersバックアップ
  #   自動バックアップにより、ポイントインタイムリカバリが可能です。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-managing.html
  backup_retention_period = 7

  # preferred_backup_window (Optional)
  # 設定内容: 自動バックアップが作成される毎日の時間範囲を指定します（UTC）。
  # 設定可能な値: "hh24:mi-hh24:mi" 形式（例: "07:30-08:00"）
  # 省略時: AWSが自動的に30分のウィンドウを選択します
  # 注意: backup_retention_periodにより自動バックアップが有効な場合のみ適用
  preferred_backup_window = "03:00-04:00"

  #-------------------------------------------------------------
  # メンテナンス設定 (Optional)
  #-------------------------------------------------------------

  # preferred_maintenance_window (Optional)
  # 設定内容: システムメンテナンスが実行される週次の時間範囲を指定します（UTC）。
  # 設定可能な値: "ddd:hh24:mi-ddd:hh24:mi" 形式（例: "sun:05:00-sun:06:00"）
  #   - ddd: Mon, Tue, Wed, Thu, Fri, Sat, Sun
  # 省略時: AWSがランダムに30分のウィンドウを選択します
  # 関連機能: Elastic Clustersメンテナンス
  #   エンジン更新やOSアップデートがこのウィンドウ内で実行されます。
  #   - https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-cluster-maintenance.html
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  #-------------------------------------------------------------
  # 暗号化設定 (Optional)
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: Elastic DocumentDBクラスターの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSがアカウント用に作成するデフォルトの暗号化キーを使用
  # 注意: リソース作成後の変更はできません（Forces new resource）
  # 関連機能: AWS KMSによる暗号化
  #   Elastic Clustersはデフォルトで暗号化されます。カスタムKMSキーを
  #   使用することで、暗号化キーの管理を制御できます。
  kms_key_id = null

  #-------------------------------------------------------------
  # ネットワーク設定 (Optional)
  #-------------------------------------------------------------

  # subnet_ids (Optional)
  # 設定内容: Elastic DocumentDBクラスターが動作するサブネットのIDを指定します。
  # 設定可能な値: サブネットIDのセット（複数のアベイラビリティゾーンを推奨）
  # 省略時: VPCのデフォルトサブネットが使用されます
  # 注意: 高可用性のため、複数のアベイラビリティゾーンにまたがる
  #       サブネットを指定することを推奨します。
  subnet_ids = [
    "subnet-xxxxxxxxxxxxxxxxx",
    "subnet-yyyyyyyyyyyyyyyyy",
  ]

  # vpc_security_group_ids (Optional)
  # 設定内容: Elastic DocumentDBクラスターに関連付けるVPCセキュリティグループのIDを指定します。
  # 設定可能な値: セキュリティグループIDのセット
  # 省略時: VPCのデフォルトセキュリティグループが使用されます
  # 関連機能: VPCセキュリティグループ
  #   適切なインバウンドルール（デフォルトポート27017）を設定して
  #   クラスターへのアクセスを制御してください。
  vpc_security_group_ids = [
    "sg-xxxxxxxxxxxxxxxxx",
  ]

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定 (Optional)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "my-docdb-elastic-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成、更新、削除操作のタイムアウト時間を指定します。
  # 設定可能な値: "30s", "2h45m" などの時間形式（秒: s, 分: m, 時間: h）
  # 省略時: Terraformのデフォルトタイムアウトが適用されます
  timeouts {
    # create (Optional)
    # 設定内容: クラスター作成操作のタイムアウト時間を指定します。
    create = "45m"

    # update (Optional)
    # 設定内容: クラスター更新操作のタイムアウト時間を指定します。
    update = "45m"

    # delete (Optional)
    # 設定内容: クラスター削除操作のタイムアウト時間を指定します。
    delete = "45m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: DocumentDB Elastic ClusterのAmazon Resource Name (ARN)
#
# - endpoint: DocDBインスタンスのDNSアドレス
#
# - id: クラスターの識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
