#---------------------------------------------------------------
# AWS RDS Custom DB Engine Version (CEV)
#---------------------------------------------------------------
#
# Amazon RDS Custom のカスタムエンジンバージョン (CEV) をプロビジョニングするリソースです。
# RDS Custom for Oracle では S3 に配置したインストールファイルとマニフェストを使って CEV を作成し、
# RDS Custom for SQL Server では AMI を指定して CEV を作成します。
# 作成した CEV は RDS Custom DB インスタンスのエンジンとして使用できます。
#
# AWS公式ドキュメント:
#   - RDS Custom for Oracle の CEV 操作: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.html
#   - RDS Custom for SQL Server の CEV 操作: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev-sqlserver.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_custom_db_engine_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_custom_db_engine_version" "example" {
  #-------------------------------------------------------------
  # エンジン設定
  #-------------------------------------------------------------

  # engine (Required)
  # 設定内容: カスタムエンジンバージョンを作成するデータベースエンジン名を指定します。
  # 設定可能な値:
  #   - "custom-oracle-ee": RDS Custom for Oracle Enterprise Edition (非CDB)
  #   - "custom-oracle-ee-cdb": RDS Custom for Oracle Enterprise Edition (CDB)
  #   - "custom-oracle-se2": RDS Custom for Oracle Standard Edition 2 (非CDB)
  #   - "custom-oracle-se2-cdb": RDS Custom for Oracle Standard Edition 2 (CDB)
  #   - "custom-sqlserver-ee": RDS Custom for SQL Server Enterprise Edition
  #   - "custom-sqlserver-se": RDS Custom for SQL Server Standard Edition
  #   - "custom-sqlserver-web": RDS Custom for SQL Server Web Edition
  #   - "custom-sqlserver-dev": RDS Custom for SQL Server Developer Edition
  engine = "custom-oracle-ee-cdb"

  # engine_version (Required)
  # 設定内容: カスタムエンジンバージョンの識別子を指定します。
  # 設定可能な値:
  #   - Oracle 形式: "{major_version}.{suffix}" 例: "19.cdb_cev1"
  #   - SQL Server 形式: "{major}.{minor}.{build}.{rev}.cev-{n}" 例: "15.00.4249.2.cev-1"
  # 注意: バージョン文字列はエンジンの種類によってフォーマットが異なります。
  engine_version = "19.cdb_cev1"

  #-------------------------------------------------------------
  # S3 インストールファイル設定
  #-------------------------------------------------------------

  # database_installation_files_s3_bucket_name (Optional)
  # 設定内容: データベースインストールファイルが格納されている Amazon S3 バケット名を指定します。
  # 設定可能な値: 有効な S3 バケット名
  # 省略時: null
  # 注意: RDS Custom for Oracle の CEV 作成時に必要です。SQL Server では source_image_id を使用します。
  database_installation_files_s3_bucket_name = "my-rds-custom-bucket"

  # database_installation_files_s3_prefix (Optional)
  # 設定内容: S3 バケット内のデータベースインストールファイルが格納されているプレフィックスを指定します。
  # 設定可能な値: 有効な S3 プレフィックス文字列（例: "1915_GI/"）
  # 省略時: null
  # 注意: RDS Custom for Oracle の CEV 作成時に必要です。
  database_installation_files_s3_prefix = "1915_GI/"

  #-------------------------------------------------------------
  # マニフェスト設定
  #-------------------------------------------------------------

  # manifest (Optional)
  # 設定内容: CEV 作成に使用するデータベースインストールファイルのリストを含むマニフェストを
  #           JSON 形式の文字列で指定します。
  # 設定可能な値: JSON 形式の文字列（databaseInstallationFileNames キーにファイル名配列を指定）
  # 省略時: null
  # 注意: filename と排他的（どちらか一方のみ指定可能）。RDS Custom for Oracle で使用します。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-concept.workflow.html
  manifest = <<JSON
{
  "databaseInstallationFileNames":["V982063-01.zip"]
}
JSON

  # filename (Optional)
  # 設定内容: ローカルファイルシステム上のマニフェストファイルのパスを指定します。
  # 設定可能な値: 有効なローカルファイルパス文字列
  # 省略時: null
  # 注意: manifest と排他的（どちらか一方のみ指定可能）。manifest_hash と組み合わせて使用します。
  filename = null

  # manifest_hash (Optional)
  # 設定内容: filename で指定したマニフェストファイルの Base64 エンコードされた SHA256 ハッシュを指定します。
  # 設定可能な値: Base64 エンコードされた SHA256 ハッシュ文字列
  # 省略時: null
  # 注意: 通常は filebase64sha256("manifest.json") 関数を使用して設定します。
  #       filename を指定した場合にのみ有効です。ファイル変更時に更新をトリガーするために使用します。
  manifest_hash = null

  #-------------------------------------------------------------
  # AMI 設定（SQL Server 用）
  #-------------------------------------------------------------

  # source_image_id (Optional)
  # 設定内容: CEV の作成元となる AMI の ID を指定します。
  # 設定可能な値: 有効な AMI ID（例: "ami-0aa12345678a12ab1"）
  # 省略時: null
  # 注意: RDS Custom for SQL Server の CEV 作成に必要です。
  #       RDS Custom for Oracle では別の Oracle CEV で使用した AMI ID を指定することも可能です。
  #       別リージョンの AMI を使用する場合は aws_ami_copy リソースで事前にコピーが必要です。
  source_image_id = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: データベースインストールファイルの暗号化に使用する AWS KMS キーの ARN を指定します。
  # 設定可能な値: 有効な KMS キー ARN
  # 省略時: AWS マネージドキーを使用
  # 注意: RDS Custom for Oracle の場合は必須です。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev.html
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # ステータス設定
  #-------------------------------------------------------------

  # status (Optional)
  # 設定内容: カスタムエンジンバージョンの可用性ステータスを指定します。
  # 設定可能な値:
  #   - "available": CEV を有効化。RDS Custom DB インスタンスの作成・アップグレードに使用可能。
  #   - "inactive": CEV を無効化。既存インスタンスは継続稼働しますが新規作成は不可。
  #   - "inactive-except-restore": バックアップからのリストアのみ許可する状態。
  # 省略時: "available"
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-cev-sqlserver-modifying.html
  status = "available"

  #-------------------------------------------------------------
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: カスタムエンジンバージョンの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Custom Oracle EE CDB engine version for production"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理する AWS リージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
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
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "custom-oracle-ee-cdb-19"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  # 注意: RDS Custom for Oracle の CEV 作成はインストールファイルの検証・適用に
  #       おおよそ 2 時間かかるため、長めのタイムアウトを設定することを推奨します。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 形式（例: "60m", "3h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "3h"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 形式（例: "60m", "2h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "1h"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 形式（例: "60m", "2h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "1h"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタムエンジンバージョンの Amazon Resource Name (ARN)
# - create_time: CEV が作成された日時
# - db_parameter_group_family: CEV に対応する DB パラメータグループファミリー名
# - image_id: CEV 作成時に使用された AMI の ID
# - major_engine_version: データベースエンジンのメジャーバージョン
# - manifest_computed: サービス側で生成された JSON 形式のマニフェスト（入力 manifest と異なる場合あり）
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
