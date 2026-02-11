#---------------------------------------------------------------
# AWS DocumentDB Global Cluster
#---------------------------------------------------------------
#
# Amazon DocumentDBのグローバルクラスターを管理するためのリソースです。
# グローバルクラスターは1つのプライマリリージョンと最大5つの読み取り専用
# セカンダリリージョンで構成されます。プライマリリージョンのプライマリ
# クラスターに書き込み操作を行うと、Amazon DocumentDBは専用インフラを
# 使用してセカンダリリージョンにデータを自動的にレプリケートします。
#
# 注意事項:
#   - グローバルクラスターは複数リージョンにまたがる分散データベースです
#   - プライマリクラスターとセカンダリクラスターが必要です
#   - メジャーバージョンのアップグレードはサポートされていません
#
# AWS公式ドキュメント:
#   - グローバルクラスター概要: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.html
#   - クイックスタートガイド: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.get-started.html
#   - グローバルクラスター管理: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.manage.html
#   - ディザスタリカバリ: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters-disaster-recovery.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_global_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-25
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdb_global_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # global_cluster_identifier (Required, Forces new resources)
  # 設定内容: グローバルクラスター識別子を指定します。
  # 設定可能な値: 英数字とハイフンからなる文字列（小文字のみ）
  # 注意: 作成後は変更できません（Forces new resources）
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.get-started.html
  global_cluster_identifier = "my-docdb-global-cluster"

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
  # データベース設定
  #-------------------------------------------------------------

  # database_name (Optional, Forces new resources)
  # 設定内容: クラスター作成時に自動的に作成されるデータベースの名前を指定します。
  # 設定可能な値: DocumentDBの命名規則に従った文字列
  # 注意: 作成後は変更できません（Forces new resources）
  database_name = null

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Optional, Forces new resources)
  # 設定内容: グローバルデータベースクラスターに使用するデータベースエンジン名を指定します。
  # 設定可能な値: "docdb"（デフォルト）
  # デフォルト値: "docdb"
  # 注意:
  #   - Terraformは設定値が提供された場合のみドリフト検出を実行します
  #   - source_db_cluster_identifierと競合します
  #   - 作成後は変更できません（Forces new resources）
  engine = "docdb"

  # engine_version (Optional)
  # 設定内容: グローバルデータベースのエンジンバージョンを指定します。
  # 設定可能な値: 有効なDocumentDBエンジンバージョン（例: "5.0.0", "4.0.0"）
  # 注意:
  #   - エンジンバージョンをアップグレードすると、すべてのクラスターメンバーが
  #     即座に更新されます
  #   - メジャーバージョンのアップグレードはサポートされていません
  #   - マイナーバージョンのアップグレードのみ可能です
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-versions.html
  engine_version = null

  #-------------------------------------------------------------
  # ソースクラスター設定
  #-------------------------------------------------------------

  # source_db_cluster_identifier (Optional)
  # 設定内容: グローバルクラスターの作成時にプライマリDBクラスターとして使用する
  #           Amazon Resource Name (ARN)を指定します。
  # 設定可能な値: 既存のDocumentDBクラスターのARN
  # 注意:
  #   - Terraformはこの値のドリフト検出を実行できません
  #   - engineパラメータと競合します
  #   - 既存のクラスターからグローバルクラスターを作成する際に使用
  # 例: "arn:aws:rds:us-east-1:123456789012:cluster:my-cluster"
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.get-started.html
  source_db_cluster_identifier = null

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # storage_encrypted (Optional, Forces new resources)
  # 設定内容: DBクラスターを暗号化するかどうかを指定します。
  # 設定可能な値:
  #   - true: DBクラスターを暗号化
  #   - false: DBクラスターを暗号化しない
  # デフォルト値: false（ただし、source_db_cluster_identifierが指定され、
  #               そのクラスターが暗号化されている場合は暗号化されます）
  # 注意:
  #   - Terraformは設定値が提供された場合のみドリフト検出を実行します
  #   - 作成後は変更できません（Forces new resources）
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/encryption-at-rest.html
  storage_encrypted = false

  # deletion_protection (Optional)
  # 設定内容: グローバルクラスターの削除保護を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化（クラスターの削除が不可能になります）
  #   - false: 削除保護を無効化（クラスターの削除が可能です）
  # デフォルト値: false
  # 注意: 本番環境では削除保護を有効にすることを推奨します
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.manage.html
  deletion_protection = false
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です（computed only）:
#
# - arn
#     グローバルクラスターのAmazon Resource Name (ARN)
#
# - global_cluster_members
#     グローバルクラスターメンバーを含むオブジェクトのセット
#     各メンバーには以下の属性が含まれます:
#       - db_cluster_arn: メンバーDBクラスターのAmazon Resource Name (ARN)
#       - is_writer: メンバーがプライマリDBクラスターかどうか
#
# - global_cluster_resource_id
#     グローバルデータベースクラスター用のAWSリージョン固有の不変識別子。
#     この識別子は、DBクラスターのAWS KMSキーがアクセスされるたびに
#     AWS CloudTrailログエントリに記録されます。
#
# - id
#     DocumentDBグローバルクラスターID
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# AWS DocumentDB Global Cluster
#---------------------------------------------------------------
#
# Amazon DocumentDBのグローバルクラスターを管理するためのリソースです。
# グローバルクラスターは1つのプライマリリージョンと最大5つの読み取り専用
# セカンダリリージョンで構成されます。プライマリリージョンのプライマリ
# クラスターに書き込み操作を行うと、Amazon DocumentDBは専用インフラを
# 使用してセカンダリリージョンにデータを自動的にレプリケートします。
#
# 注意事項:
#   - グローバルクラスターは複数リージョンにまたがる分散データベースです
#   - プライマリクラスターとセカンダリクラスターが必要です
#   - メジャーバージョンのアップグレードはサポートされていません
#
# AWS公式ドキュメント:
#   - グローバルクラスター概要: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.html
#   - クイックスタートガイド: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.get-started.html
#   - グローバルクラスター管理: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.manage.html
#   - ディザスタリカバリ: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters-disaster-recovery.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_global_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-25
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_docdb_global_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # global_cluster_identifier (Required, Forces new resources)
  # 設定内容: グローバルクラスター識別子を指定します。
  # 設定可能な値: 英数字とハイフンからなる文字列（小文字のみ）
  # 注意: 作成後は変更できません（Forces new resources）
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.get-started.html
  global_cluster_identifier = "my-docdb-global-cluster"

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
  # データベース設定
  #-------------------------------------------------------------

  # database_name (Optional, Forces new resources)
  # 設定内容: クラスター作成時に自動的に作成されるデータベースの名前を指定します。
  # 設定可能な値: DocumentDBの命名規則に従った文字列
  # 注意: 作成後は変更できません（Forces new resources）
  database_name = null

  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Optional, Forces new resources)
  # 設定内容: グローバルデータベースクラスターに使用するデータベースエンジン名を指定します。
  # 設定可能な値: "docdb"（デフォルト）
  # デフォルト値: "docdb"
  # 注意:
  #   - Terraformは設定値が提供された場合のみドリフト検出を実行します
  #   - source_db_cluster_identifierと競合します
  #   - 作成後は変更できません（Forces new resources）
  engine = "docdb"

  # engine_version (Optional)
  # 設定内容: グローバルデータベースのエンジンバージョンを指定します。
  # 設定可能な値: 有効なDocumentDBエンジンバージョン（例: "5.0.0", "4.0.0"）
  # 注意:
  #   - エンジンバージョンをアップグレードすると、すべてのクラスターメンバーが
  #     即座に更新されます
  #   - メジャーバージョンのアップグレードはサポートされていません
  #   - マイナーバージョンのアップグレードのみ可能です
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-versions.html
  engine_version = null

  #-------------------------------------------------------------
  # ソースクラスター設定
  #-------------------------------------------------------------

  # source_db_cluster_identifier (Optional)
  # 設定内容: グローバルクラスターの作成時にプライマリDBクラスターとして使用する
  #           Amazon Resource Name (ARN)を指定します。
  # 設定可能な値: 既存のDocumentDBクラスターのARN
  # 注意:
  #   - Terraformはこの値のドリフト検出を実行できません
  #   - engineパラメータと競合します
  #   - 既存のクラスターからグローバルクラスターを作成する際に使用
  # 例: "arn:aws:rds:us-east-1:123456789012:cluster:my-cluster"
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.get-started.html
  source_db_cluster_identifier = null

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # storage_encrypted (Optional, Forces new resources)
  # 設定内容: DBクラスターを暗号化するかどうかを指定します。
  # 設定可能な値:
  #   - true: DBクラスターを暗号化
  #   - false: DBクラスターを暗号化しない
  # デフォルト値: false（ただし、source_db_cluster_identifierが指定され、
  #               そのクラスターが暗号化されている場合は暗号化されます）
  # 注意:
  #   - Terraformは設定値が提供された場合のみドリフト検出を実行します
  #   - 作成後は変更できません（Forces new resources）
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/encryption-at-rest.html
  storage_encrypted = false

  # deletion_protection (Optional)
  # 設定内容: グローバルクラスターの削除保護を有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: 削除保護を有効化（クラスターの削除が不可能になります）
  #   - false: 削除保護を無効化（クラスターの削除が可能です）
  # デフォルト値: false
  # 注意: 本番環境では削除保護を有効にすることを推奨します
  # 参考: https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.manage.html
  deletion_protection = false
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能です（computed only）:
#
# - arn
#     グローバルクラスターのAmazon Resource Name (ARN)
#
# - global_cluster_members
#     グローバルクラスターメンバーを含むオブジェクトのセット
#     各メンバーには以下の属性が含まれます:
#       - db_cluster_arn: メンバーDBクラスターのAmazon Resource Name (ARN)
#       - is_writer: メンバーがプライマリDBクラスターかどうか
#
# - global_cluster_resource_id
#     グローバルデータベースクラスター用のAWSリージョン固有の不変識別子。
#     この識別子は、DBクラスターのAWS KMSキーがアクセスされるたびに
#     AWS CloudTrailログエントリに記録されます。
#
# - id
#     DocumentDBグローバルクラスターID
#
#---------------------------------------------------------------

