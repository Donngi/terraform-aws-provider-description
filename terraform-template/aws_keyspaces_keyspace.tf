################################################################################
# Amazon Keyspaces (Apache Cassandra) - Keyspace
################################################################################
# Amazon Keyspacesは、Apache Cassandra互換のマネージド型NoSQLデータベースサービスです。
# keyspaceは、関連するテーブルをグループ化する論理コンテナであり、
# すべてのテーブルのレプリケーション戦略を定義します。
#
# 主な特徴:
# - フルマネージド型: サーバーのプロビジョニング、パッチ適用、管理が不要
# - Apache Cassandra互換: 既存のCassandraアプリケーションコードで動作
# - スケーラビリティ: リクエストに応じて自動的にスケールアップ/ダウン
# - マルチリージョン対応: 複数のAWSリージョンにまたがるデータレプリケーション
# - セキュリティ: 保管時と転送時の暗号化、IAM認証をサポート
#
# ユースケース:
# - IoTデバイスデータの保存
# - 時系列データの管理
# - ゲームのリーダーボード
# - ショッピングカートデータ
# - メッセージング/チャットアプリケーション
#
# 公式ドキュメント:
# - https://docs.aws.amazon.com/keyspaces/latest/devguide/what-is-keyspaces.html
# - https://docs.aws.amazon.com/keyspaces/latest/devguide/getting-started.keyspaces.html
################################################################################

# 単一リージョンのキースペース（シンプルな構成）
resource "aws_keyspaces_keyspace" "single_region" {
  # キースペース名
  # - 必須パラメータ
  # - 変更すると新しいリソースが作成されます（Forces new resource）
  # - 小文字、数字、アンダースコア（_）のみ使用可能
  # - 先頭は文字である必要があります
  # - 最大長: 48文字
  # - Amazon Keyspacesは、引用符で囲まれていない場合、すべての入力を小文字に変換します
  name = "my_keyspace"

  # タグ
  # - オプション
  # - リソースの管理、請求の追跡、アクセス制御に使用
  # - provider default_tags設定ブロックで定義されたタグは自動的にマージされます
  tags = {
    Environment = "production"
    Application = "ecommerce"
    ManagedBy   = "terraform"
  }
}

# マルチリージョンのキースペース（高可用性構成）
resource "aws_keyspaces_keyspace" "multi_region" {
  name = "global_keyspace"

  # レプリケーション仕様
  # - オプション: 指定しない場合、デフォルトでSINGLE_REGION戦略が使用されます
  # - キースペース内のすべてのテーブルは、この設定を継承します
  replication_specification {
    # レプリケーション戦略
    # - 必須
    # - SINGLE_REGION: 単一リージョン内でのレプリケーション（デフォルト）
    # - MULTI_REGION: 複数のAWSリージョン間でのレプリケーション
    # - MULTI_REGIONを選択すると、Amazon Keyspacesは自動的に
    #   AWSServiceRoleForAmazonKeyspacesReplicationという名前の
    #   サービスリンクロールを作成します
    replication_strategy = "MULTI_REGION"

    # レプリケーションリージョンのリスト
    # - MULTI_REGIONの場合は必須
    # - 現在のリージョンと少なくとも1つの追加リージョンを含む必要があります
    # - 各リージョンでデータが複製され、低レイテンシの読み取りが可能になります
    # - リージョン間のレプリケーションは非同期で行われます
    # - リージョンの追加/削除はALTER KEYSPACE操作で実行できます
    region_list = [
      "ap-northeast-1", # 東京（現在のリージョン）
      "us-east-1",      # バージニア北部
      "eu-west-1"       # アイルランド
    ]
  }

  tags = {
    Environment    = "production"
    Application    = "global-app"
    ReplicationType = "multi-region"
    ManagedBy      = "terraform"
  }
}

# 特定リージョンを指定したキースペース
resource "aws_keyspaces_keyspace" "specific_region" {
  # リージョンの指定
  # - オプション
  # - 指定しない場合、プロバイダー設定のリージョンが使用されます
  # - 特定のリージョンにリソースを作成する場合に使用
  # - 注意: この属性はTerraformドキュメントに記載されていますが、
  #   通常はプロバイダーのエイリアスを使用してリージョンを制御します
  # region = "us-west-2"

  name = "regional_keyspace"

  tags = {
    Environment = "development"
    Region      = "us-west-2"
  }
}

################################################################################
# Outputs
################################################################################
# 作成されたリソースの情報を出力し、他のモジュールやリソースで参照可能にします

output "single_region_keyspace_id" {
  description = "単一リージョンキースペースのID（名前と同じ）"
  value       = aws_keyspaces_keyspace.single_region.id
}

output "single_region_keyspace_arn" {
  description = "単一リージョンキースペースのARN"
  value       = aws_keyspaces_keyspace.single_region.arn
}

output "multi_region_keyspace_id" {
  description = "マルチリージョンキースペースのID"
  value       = aws_keyspaces_keyspace.multi_region.id
}

output "multi_region_keyspace_arn" {
  description = "マルチリージョンキースペースのARN"
  value       = aws_keyspaces_keyspace.multi_region.arn
}

output "multi_region_keyspace_regions" {
  description = "マルチリージョンキースペースがレプリケートされているリージョンのリスト"
  value       = aws_keyspaces_keyspace.multi_region.replication_specification[0].region_list
}

################################################################################
# 補足情報
################################################################################
# 1. キースペースの命名規則:
#    - 小文字で始まる必要があります
#    - 使用可能な文字: a-z、0-9、アンダースコア(_)
#    - 最大長: 48文字
#    - システムキースペース名（system、system_schemaなど）は使用不可
#
# 2. レプリケーション戦略の選択:
#    - SINGLE_REGION: 1つのAWSリージョン内でのみデータを保持
#      - コスト効率が高い
#      - 単一リージョンのアプリケーションに最適
#    - MULTI_REGION: 複数のAWSリージョン間でデータをレプリケート
#      - グローバルアプリケーションの低レイテンシ読み取り
#      - 災害復旧とビジネス継続性の向上
#      - コストが高い（複数リージョンでのストレージとレプリケーション）
#
# 3. マルチリージョンレプリケーションの考慮事項:
#    - 各リージョンでの読み取りは低レイテンシ
#    - 書き込みはすべてのリージョンに非同期で複製されます
#    - 結果整合性モデル（eventual consistency）
#    - 各リージョンで個別に課金されます
#    - リージョン間のデータ転送コストが発生します
#
# 4. 料金:
#    - 読み取り/書き込みリクエスト単位で課金（オンデマンドモード）
#    - またはプロビジョニングされたスループットで課金（プロビジョニングモード）
#    - ストレージ料金（GB/月）
#    - マルチリージョンの場合は各リージョンで個別に課金
#    - 詳細: https://aws.amazon.com/keyspaces/pricing/
#
# 5. 削除保護:
#    - キースペースを削除する前に、すべてのテーブルを削除する必要があります
#    - DROP KEYSPACE操作はキースペースとその中のすべてのテーブルを削除します
#    - Terraformでは、依存リソース（テーブル）が存在する場合、
#      キースペースの削除は失敗します
#
# 6. CQLとの互換性:
#    - CQLを使用してキースペースを作成することもできます:
#      CREATE KEYSPACE my_keyspace
#      WITH REPLICATION = {'class': 'SingleRegionStrategy'};
#    - TerraformとCQLの両方で管理する場合、状態の不整合に注意してください
#
# 7. セキュリティのベストプラクティス:
#    - IAMポリシーを使用してキースペースへのアクセスを制御
#    - VPCエンドポイントを使用してプライベートネットワークからアクセス
#    - すべてのデータは保管時に自動的に暗号化されます（AWS所有のキー）
#    - カスタマーマネージドキー（CMK）を使用することも可能
#    - TLS/SSL経由でのみ接続を許可
#
# 8. モニタリング:
#    - CloudWatchメトリクスで使用状況とパフォーマンスを監視
#    - 主要なメトリクス:
#      - UserErrors: クライアントエラーの数
#      - SystemErrors: サーバーエラーの数
#      - ConsumedReadCapacityUnits: 消費された読み取り容量
#      - ConsumedWriteCapacityUnits: 消費された書き込み容量
#
# 9. タグ付け戦略:
#    - Environment: 環境の識別（dev/staging/prod）
#    - Application: アプリケーション名
#    - CostCenter: コスト管理のためのコストセンター
#    - Owner: 所有者またはチーム名
#    - ManagedBy: リソース管理ツール（terraform）
#
# 10. アップグレードとメンテナンス:
#     - Amazon Keyspacesは完全マネージドサービスのため、
#       パッチ適用やメンテナンスは自動的に実行されます
#     - アプリケーションのダウンタイムは発生しません
#
# 11. バックアップとリストア:
#     - キースペースレベルではなく、テーブルレベルでバックアップを設定
#     - Point-in-Time Recovery (PITR)をテーブルで有効化可能
#     - 継続的バックアップ（最大35日間）
#
# 12. 制限とクォータ:
#     - キースペース名の最大長: 48文字
#     - 1アカウントあたりのキースペース数: デフォルトで256（増加申請可能）
#     - マルチリージョンキースペースの最大リージョン数: 6
#     - 詳細: https://docs.aws.amazon.com/keyspaces/latest/devguide/quotas.html
################################################################################
