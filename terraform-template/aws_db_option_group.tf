#---------------------------------------------------------------
# RDS DB Option Group
#---------------------------------------------------------------
#
# RDS DB オプショングループをプロビジョニングするリソースです。
# オプショングループは、データベースエンジンに追加機能を提供するオプションの
# コレクションを定義します。例えば、SQL Serverのバックアップ/リストア機能や
# Oracleのトランスペアレントデータ暗号化(TDE)などが利用可能です。
#
# 利用可能なオプションの詳細は以下のドキュメントを参照してください:
#   - MariaDB Options: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.MariaDB.Options.html
#   - Microsoft SQL Server Options: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.Options.html
#   - MySQL Options: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.MySQL.Options.html
#   - Oracle Options: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.Oracle.Options.html
#
# AWS公式ドキュメント:
#   - RDS オプショングループの概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html
#   - RDS API リファレンス: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_db_option_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: オプショングループの名前を指定します。
  # 設定可能な値: 小文字の英数字とハイフンのみ。最大255文字
  # 省略時: Terraformが自動的にランダムでユニークな名前を生成します
  # 注意: AWSに保存されるため、必ず小文字で指定してください
  # 関連機能: RDS オプショングループ命名規則
  #   name_prefixと競合するため、どちらか一方のみを指定してください。
  #   変更すると新しいリソースが作成されます。
  name = "option-group-test-terraform"

  # name_prefix (Optional, Forces new resource)
  # 設定内容: 指定したプレフィックスで始まるユニークな名前を生成します。
  # 設定可能な値: 小文字の英数字とハイフンのみ
  # 省略時: nameが指定されていない場合、terraform-が使用されます
  # 注意: nameと競合します。AWSに保存されるため、必ず小文字で指定してください
  # 関連機能: RDS オプショングループ命名規則
  #   自動生成される名前の衝突を避けたい場合に有用です。
  name_prefix = null

  # option_group_description (Optional)
  # 設定内容: オプショングループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" がデフォルト値として設定されます
  # 関連機能: RDS オプショングループのメタデータ
  #   コンソールやAPIで表示される説明文として使用されます。
  option_group_description = "Terraform Option Group"

  # engine_name (Required)
  # 設定内容: このオプショングループを関連付けるエンジンの名前を指定します。
  # 設定可能な値:
  #   - "mariadb": MariaDB
  #   - "mysql": MySQL
  #   - "oracle-ee": Oracle Enterprise Edition
  #   - "oracle-ee-cdb": Oracle Enterprise Edition Container Database
  #   - "oracle-se2": Oracle Standard Edition 2
  #   - "oracle-se2-cdb": Oracle Standard Edition 2 Container Database
  #   - "postgres": PostgreSQL
  #   - "sqlserver-ee": SQL Server Enterprise Edition
  #   - "sqlserver-ex": SQL Server Express Edition
  #   - "sqlserver-se": SQL Server Standard Edition
  #   - "sqlserver-web": SQL Server Web Edition
  # 関連機能: RDS データベースエンジン
  #   選択したエンジンで利用可能なオプションが決まります。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html
  engine_name = "sqlserver-ee"

  # major_engine_version (Required)
  # 設定内容: このオプショングループを関連付けるエンジンのメジャーバージョンを指定します。
  # 設定可能な値: エンジンに応じたメジャーバージョン番号 (例: "11.00", "5.7", "19")
  # 関連機能: RDS エンジンバージョン
  #   メジャーバージョンごとに利用可能なオプションが異なります。
  #   DBインスタンスのエンジンバージョンと互換性のあるメジャーバージョンを指定してください。
  #   - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Upgrading.html
  major_engine_version = "11.00"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # option (Optional)
  # 設定内容: 適用するオプションを指定します。
  # 用途: データベースエンジンに追加機能を提供
  # 注意: 複数のoptionブロックを定義可能です
  option {
    # option_name (Required)
    # 設定内容: オプションの名前を指定します。
    # 設定可能な値: エンジンとバージョンに応じて異なります
    #   例: "Timezone", "MEMCACHED", "NATIVE_NETWORK_ENCRYPTION", "TDE"
    # 関連機能: RDS オプション
    #   各エンジンで利用可能なオプションは公式ドキュメントを参照してください。
    option_name = "Timezone"

    # option_settings (Optional)
    # 設定内容: オプションに適用する設定を指定します。
    # 用途: オプションの詳細な動作を制御
    # 注意: 複数のoption_settingsブロックを定義可能です
    option_settings {
      # name (Required)
      # 設定内容: 設定の名前を指定します。
      # 設定可能な値: オプションに応じて異なります
      #   例: "TIME_ZONE", "IAM_ROLE_ARN", "CHUNK_SIZE"
      name = "TIME_ZONE"

      # value (Required)
      # 設定内容: 設定の値を指定します。
      # 設定可能な値: 設定に応じて異なります
      #   例: "UTC", "Asia/Tokyo", IAM Role ARN
      value = "UTC"
    }

    # port (Optional)
    # 設定内容: オプションに接続する際のポート番号を指定します。
    # 設定可能な値: 1150～65535の整数
    # 省略時または削除時: AWSがデフォルトポートを割り当てる場合があります
    # 注意: 設定から削除してもAWSからポートは削除されません
    # 用途: MEMCACHED等のネットワークベースのオプションで使用
    # 関連機能: RDS オプションのネットワーク設定
    #   セキュリティグループのルールでこのポートを許可する必要があります。
    port = null

    # version (Optional)
    # 設定内容: オプションのバージョンを指定します。
    # 設定可能な値: オプションに応じて異なります (例: "13.1.0.0")
    # 省略時または削除時: AWSがデフォルトバージョンを割り当てる場合があります
    # 注意: 設定から削除してもAWSからバージョンは削除されません
    # 関連機能: RDS オプションバージョニング
    #   一部のオプションは複数のバージョンをサポートしています。
    version = null

    # db_security_group_memberships (Optional)
    # 設定内容: オプションを有効にするDBセキュリティグループのリストを指定します。
    # 設定可能な値: DBセキュリティグループ名のリスト
    # 用途: EC2-Classic環境でのネットワークベースのオプションに使用
    # 注意: VPCではvpc_security_group_membershipsを使用してください
    db_security_group_memberships = []

    # vpc_security_group_memberships (Optional)
    # 設定内容: オプションを有効にするVPCセキュリティグループのリストを指定します。
    # 設定可能な値: VPCセキュリティグループIDのリスト
    # 用途: VPC環境でのネットワークベースのオプション (例: MEMCACHED) に使用
    # 関連機能: VPC セキュリティグループ
    #   オプションへのネットワークアクセスを制御します。
    vpc_security_group_memberships = []
  }

  # 追加のオプション例: SQL Server のバックアップ/リストア
  option {
    option_name = "SQLSERVER_BACKUP_RESTORE"

    option_settings {
      name  = "IAM_ROLE_ARN"
      value = "arn:aws:iam::123456789012:role/rds-backup-restore-role"
    }
  }

  # 追加のオプション例: SQL Server のトランスペアレントデータ暗号化
  option {
    option_name = "TDE"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 削除動作の制御
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: 削除時にオプショングループをTerraformの状態から削除するが、
  #          AWS上では削除しないかどうかを指定します。
  # 設定可能な値:
  #   - true: AWS上のリソースを保持し、Terraformの状態からのみ削除
  #   - false (デフォルト): 通常通りAWS上のリソースも削除
  # 用途: 破棄時にオプショングループを保持したい場合に使用
  # 関連機能: Terraform ライフサイクル管理
  #   DBインスタンスで使用中のオプショングループは削除できないため、
  #   依存関係を慎重に管理する必要があります。
  skip_destroy = false

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
    Name        = "example-option-group"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はオプショングループ名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null

  #-------------------------------------------------------------
  # 依存関係の推奨設定
  #-------------------------------------------------------------
  # オプショングループをDBインスタンスに関連付ける場合、
  # DBインスタンスより先にオプショングループを作成し、
  # 削除する際はDBインスタンスを先に削除する必要があります。
  # depends_onを使用して明示的に依存関係を定義することを推奨します。
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DBオプショングループ名
#
# - arn: DBオプショングループのAmazon Resource Name (ARN)
#   形式: arn:aws:rds:region:account-id:og:option-group-name
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
# 使用例: DBインスタンスとの関連付け
#---------------------------------------------------------------
# DBインスタンスでこのオプショングループを使用するには、
# aws_db_instance リソースの option_group_name 属性に
# このオプショングループの名前を指定します:
#
# resource "aws_db_instance" "example" {
#   ...
#   option_group_name = aws_db_option_group.example.name
#   ...
# }
#---------------------------------------------------------------
