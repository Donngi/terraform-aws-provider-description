#---------------------------------------------------------------
# RDS Custom DB Engine Version
#---------------------------------------------------------------
#
# Amazon RDS Custom用のカスタムエンジンバージョン (CEV) を管理するリソースです。
# RDS Customでは、データベースとオペレーティングシステムへの特権アクセスを提供し、
# カスタマイズされたデータベース環境を構築できます。
#
# CEVは以下の2つのタイプで使用可能:
#   1. RDS Custom for Oracle: Oracle Database の CDB (Container Database) または非CDB構成
#   2. RDS Custom for SQL Server: Microsoft SQL Server のカスタム構成
#
# AWS公式ドキュメント:
#   - RDS Custom for Oracle CEV: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.html
#   - RDS Custom for SQL Server CEV: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev-sqlserver.html
#   - RDS User Guide: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html
#   - CreateCustomDBEngineVersion API: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateCustomDBEngineVersion.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_custom_db_engine_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_custom_db_engine_version" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # engine (Required)
  # 設定内容: データベースエンジンの名前を指定します。
  # 設定可能な値:
  #   RDS Custom for Oracle:
  #     - "custom-oracle-ee": Oracle Enterprise Edition
  #     - "custom-oracle-ee-cdb": Oracle Enterprise Edition (Container Database)
  #     - "custom-oracle-se2": Oracle Standard Edition 2
  #     - "custom-oracle-se2-cdb": Oracle Standard Edition 2 (Container Database)
  #   RDS Custom for SQL Server:
  #     - "custom-sqlserver-ee": SQL Server Enterprise Edition
  #     - "custom-sqlserver-se": SQL Server Standard Edition
  #     - "custom-sqlserver-web": SQL Server Web Edition
  # 用途: RDS Customで使用するデータベースエンジンのタイプを決定
  # 関連機能: RDS Custom エンジン選択
  #   エンジンタイプによってサポートされる機能と要件が異なります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-setup-cev.html
  engine = "custom-oracle-ee-cdb"

  # engine_version (Required)
  # 設定内容: データベースエンジンのバージョンを指定します。
  # 設定可能な値:
  #   Oracle: メジャーバージョン.カスタムバージョン名
  #     例: "19.cdb_cev1", "19.my_cev1"
  #   SQL Server: メジャー.マイナー.ビルド.リビジョン.cev-カスタム文字列
  #     例: "15.00.4249.2.cev-1"
  # 注意:
  #   - Oracle: カスタムバージョン名は英数字、アンダースコア、ドットのみ使用可能
  #   - SQL Server: インストールメディアのバージョンと一致させる必要があります
  # 関連機能: RDS Custom バージョン管理
  #   CEVは特定のデータベースバージョンとパッチレベルを表します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.preparing.html
  engine_version = "19.cdb_cev1"

  #-------------------------------------------------------------
  # RDS Custom for Oracle 専用パラメータ
  #-------------------------------------------------------------

  # database_installation_files_s3_bucket_name (Optional)
  # 設定内容: データベースインストールファイルを含むAmazon S3バケットの名前を指定します。
  # 設定可能な値: 有効なS3バケット名
  # 用途: RDS Custom for Oracle で必須。データベースソフトウェアの配布場所を指定
  # 注意: バケットはCEVを作成するリージョンと同じリージョンに存在する必要があります
  # 関連機能: RDS Custom for Oracle インストールメディア
  #   OracleインストールファイルをS3に配置し、CEV作成時に参照します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.preparing.html
  database_installation_files_s3_bucket_name = "my-oracle-installation-files"

  # database_installation_files_s3_prefix (Optional)
  # 設定内容: データベースインストールファイルを含むAmazon S3バケット内のディレクトリを指定します。
  # 設定可能な値: S3プレフィックス (ディレクトリパス)
  # 用途: RDS Custom for Oracle で必須。S3バケット内のインストールファイルの場所を指定
  # 例: "oracle/19c/", "database_files/"
  # 関連機能: RDS Custom for Oracle インストールメディア
  #   S3バケット内の特定のディレクトリを指定して、複数のバージョンを管理可能。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.preparing.html
  database_installation_files_s3_prefix = "oracle/19.15/"

  # kms_key_id (Optional, Computed)
  # 設定内容: データベースインストールファイルの暗号化に使用するAWS KMSキーのARNを指定します。
  # 設定可能な値: AWS KMS キーのARN
  # 用途: RDS Custom for Oracle で必須。データベースファイルの暗号化に使用
  # 注意: KMSキーは同じリージョンに存在する必要があり、適切なポリシーが設定されている必要があります
  # 関連機能: RDS Custom 暗号化
  #   データベースインストールファイルとデータベースインスタンスの暗号化に使用。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.preparing.html#custom-cev.preparing.iam
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # manifest (Optional)
  # 設定内容: データベースインストールファイルのリストを含むJSON形式のマニフェストを指定します。
  # 設定可能な値: JSON形式の文字列
  # 用途: RDS Custom for Oracle で必須 (filenameと排他)。インストールファイルの構成を定義
  # 注意: filenameパラメータと同時に使用できません
  # 例: マニフェストには以下の情報を含みます
  #   - databaseInstallationFileNames: インストールファイル名のリスト
  # 関連機能: RDS Custom for Oracle マニフェスト
  #   インストールに必要なファイルとその順序を定義します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.preparing.html#custom-cev.preparing.manifest
  manifest = <<-JSON
  {
    "databaseInstallationFileNames": [
      "V982063-01.zip"
    ]
  }
  JSON

  # filename (Optional)
  # 設定内容: ローカルファイルシステム内のマニフェストファイルの名前を指定します。
  # 設定可能な値: ファイルパス
  # 用途: manifestパラメータの代わりにファイルからマニフェストを読み込む場合に使用
  # 注意: manifestパラメータと同時に使用できません
  # 関連機能: RDS Custom for Oracle 外部マニフェスト
  #   マニフェストを外部ファイルとして管理する場合に使用。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.preparing.html#custom-cev.preparing.manifest
  filename = null

  # manifest_hash (Optional)
  # 設定内容: マニフェストファイルの変更を検知するためのハッシュ値を指定します。
  # 設定可能な値: Base64エンコードされたSHA256ハッシュ
  # 用途: filenameで指定したマニフェストファイルの更新をトリガーするために使用
  # 使用方法: filebase64sha256("manifest.json") のように設定
  # 注意: filenameパラメータと組み合わせて使用します
  # 関連機能: Terraform ファイルハッシュ
  #   マニフェストファイルの内容変更時にTerraformが更新を検知するための仕組み。
  manifest_hash = null

  #-------------------------------------------------------------
  # RDS Custom for SQL Server 専用パラメータ
  #-------------------------------------------------------------

  # source_image_id (Optional)
  # 設定内容: CEVを作成するために使用するAMIのIDを指定します。
  # 設定可能な値: 有効なAMI ID (ami-xxxxxxxxxxxxxxxxx)
  # 用途:
  #   - RDS Custom for SQL Server: 必須。SQL ServerがインストールされたAMIを指定
  #   - RDS Custom for Oracle: オプション。別のOracle CEVで使用されたAMI IDを指定可能
  # 注意: AMIはオペレーター (AWSアカウント) が所有している必要があります
  # 関連機能: RDS Custom for SQL Server AMI
  #   SQL ServerのインストールメディアとOSカスタマイズを含むAMIから作成。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev-sqlserver.html
  source_image_id = null

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: CEVの説明を指定します。
  # 設定可能な値: 任意の文字列 (最大1000文字)
  # 用途: CEVの目的や内容を記述して管理を容易にします
  # 関連機能: リソース管理
  #   複数のCEVを管理する際の識別と説明に使用。
  description = "Oracle 19c custom engine version for production"

  # status (Optional, Computed)
  # 設定内容: CEVのステータスを指定します。
  # 設定可能な値:
  #   - "available": CEVが使用可能 (デフォルト)
  #   - "inactive": CEVが非アクティブ (新しいDBインスタンスの作成に使用不可)
  #   - "inactive-except-restore": リストアのみ可能 (新規作成は不可)
  # 用途: CEVのライフサイクル管理。古いバージョンを非アクティブ化する場合に使用
  # 注意: inactive状態のCEVは新しいインスタンスの作成には使用できません
  # 関連機能: RDS Custom CEV ライフサイクル
  #   CEVのステータスを管理し、使用可能性を制御します。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.managing.html
  status = "available"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: CEVはリージョン固有のリソースです
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
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Tagging.html
  tags = {
    Name        = "oracle-19c-cev"
    Environment = "production"
    Version     = "19.15"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はエンジン名:バージョンの形式
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # Timeouts設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: CEV作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "120m", "2h")
    # 省略時: デフォルトは2時間
    # 注意: Oracle CEVの作成には時間がかかる場合があります (検証プロセスを含む)
    create = "120m"

    # update (Optional)
    # 設定内容: CEV更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # 省略時: デフォルトは30分
    update = "30m"

    # delete (Optional)
    # 設定内容: CEV削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "30m", "1h")
    # 省略時: デフォルトは30分
    # 注意: 使用中のDBインスタンスがある場合、削除は失敗します
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタムエンジンバージョンのAmazon Resource Name (ARN)
#   例: arn:aws:rds:us-east-1:123456789012:cev:custom-oracle-ee-cdb/19.cdb_cev1
#
# - create_time: CEVが作成された日時 (RFC3339形式)
#   例: 2024-01-15T10:30:00Z
#
# - db_parameter_group_family: CEVのDBパラメータグループファミリー名
#   例: custom-oracle-ee-cdb-19
#   用途: このCEVで使用可能なパラメータグループのファミリーを示します
#
# - image_id: CEVで作成されたAMIのID
#   例: ami-0123456789abcdef0
#   用途: このCEVから作成されるRDS Customインスタンスが使用するAMI
#
# - major_engine_version: データベースエンジンのメジャーバージョン
#   例: "19" (Oracle 19c の場合)
#
# - manifest_computed: サービスが生成した実際のマニフェストファイル (JSON形式)
#   注意: 入力したmanifestとは異なる場合があります (サービス側で追加情報が含まれる)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
# 使用例とベストプラクティス
#---------------------------------------------------------------
#
# 1. RDS Custom for Oracle の例:
#    - S3バケットにOracleインストールファイルを配置
#    - KMS キーを作成して暗号化を設定
#    - マニフェストでインストールファイルを指定
#    - CEV作成後、aws_db_instance リソースで使用
#
# 2. RDS Custom for SQL Server の例:
#    - SQL ServerがインストールされたAMIを準備
#    - source_image_idにAMI IDを指定
#    - engine_versionをAMIのSQL Serverバージョンに合わせる
#
# 3. ライフサイクル管理:
#    - 新しいCEVを作成する前に、古いCEVのstatusを"inactive"に設定
#    - 使用中のDBインスタンスがないことを確認してからCEVを削除
#
# 4. セキュリティ:
#    - KMSキーには適切なキーポリシーを設定
#    - S3バケットには適切なアクセス権限を設定
#    - AMIは信頼できるソースから取得
#
#---------------------------------------------------------------
