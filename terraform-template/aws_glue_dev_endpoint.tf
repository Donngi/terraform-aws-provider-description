#---------------------------------------------------------------
# AWS Glue Development Endpoint
#---------------------------------------------------------------
#
# AWS Glueの開発エンドポイント（Development Endpoint）をプロビジョニングするリソースです。
# 開発エンドポイントは、ETLスクリプトを反復的に開発・テストするための環境です。
# SageMaker Notebookや PyCharm IDE から接続して、AWS Glue拡張機能付きの
# PySpark を使用したスクリプト開発・デバッグが可能です。
# なお、開発エンドポイントはAWS Glueバージョン2.0以降ではサポートされていません。
#
# AWS公式ドキュメント:
#   - Development endpoints概要: https://docs.aws.amazon.com/glue/latest/dg/dev-endpoint.html
#   - 開発エンドポイントの追加: https://docs.aws.amazon.com/glue/latest/dg/add-dev-endpoint.html
#   - ネットワーク設定: https://docs.aws.amazon.com/glue/latest/dg/start-development-endpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_dev_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_dev_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 開発エンドポイントの名前を指定します。アカウント内で一意である必要があります。
  # 設定可能な値: 文字列
  name = "example-dev-endpoint"

  # role_arn (Required)
  # 設定内容: この開発エンドポイントで使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: ロールには AWSGlueServiceRole 管理ポリシーなど、必要なGlueサービス権限が必要です。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/dev-endpoint.html
  role_arn = "arn:aws:iam::123456789012:role/AWSGlueServiceRole-example"

  #-------------------------------------------------------------
  # バージョン設定
  #-------------------------------------------------------------

  # glue_version (Optional)
  # 設定内容: 使用するPythonおよびApache SparkのGlueバージョンを指定します。
  # 設定可能な値:
  #   - "0.9": デフォルト。Python 2、Spark 2.2
  #   - "1.0": Python 2/3、Spark 2.4
  # 省略時: "0.9" (AWS Glue version 0.9)
  # 注意: 開発エンドポイントはAWS Glueバージョン2.0以降ではサポートされていません。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/add-dev-endpoint.html
  glue_version = "1.0"

  #-------------------------------------------------------------
  # ワーカー設定
  #-------------------------------------------------------------

  # worker_type (Optional)
  # 設定内容: このエンドポイントに割り当てる定義済みワーカーのタイプを指定します。
  # 設定可能な値:
  #   - "Standard": 標準ワーカータイプ
  #   - "G.1X": 1 DPU相当のメモリ最適化ワーカー。メモリ集約型ジョブに適用
  #   - "G.2X": 2 DPU相当のメモリ最適化ワーカー。より大規模なメモリ集約型ジョブに適用
  # 省略時: null (number_of_nodesで指定する場合は省略)
  # 注意: number_of_nodes と排他的です。worker_type を指定する場合は number_of_workers を使用してください。
  worker_type = "G.1X"

  # number_of_workers (Optional)
  # 設定内容: このエンドポイントに割り当てる定義済みワーカータイプのワーカー数を指定します。
  # 設定可能な値: 数値。G.1X は最大299、G.2X は最大149
  # 省略時: null
  # 注意: このフィールドはworker_typeがG.1XまたはG.2Xの場合のみ使用可能です。
  number_of_workers = 5

  # number_of_nodes (Optional)
  # 設定内容: このエンドポイントに割り当てるAWS Glueデータ処理ユニット（DPU）の数を指定します。
  # 設定可能な値: 数値（最小2）
  # 省略時: null (worker_typeを使用する場合は省略)
  # 注意: worker_type と競合します。どちらか一方のみ指定してください。
  number_of_nodes = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_id (Optional)
  # 設定内容: 新しいエンドポイントが使用するサブネットIDを指定します。
  # 設定可能な値: 有効なVPCサブネットID
  # 省略時: null (VPC外でエンドポイントを作成)
  # 注意: VPC内でエンドポイントを作成する場合は security_group_ids も合わせて指定が必要です。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/start-development-endpoint.html
  subnet_id = "subnet-0123456789abcdef0"

  # security_group_ids (Optional)
  # 設定内容: このエンドポイントで使用するセキュリティグループIDのセットを指定します。
  # 設定可能な値: セキュリティグループIDの集合（set of strings）
  # 省略時: null
  # 注意: VPC内でエンドポイントを作成する場合は subnet_id も合わせて指定が必要です。
  #       セルフ参照型のセキュリティグループルールが必要です。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/start-development-endpoint.html
  security_group_ids = ["sg-0123456789abcdef0"]

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # public_key (Optional)
  # 設定内容: このエンドポイントの認証に使用する公開鍵（SSH公開鍵）を指定します。
  # 設定可能な値: SSH公開鍵の文字列
  # 省略時: null
  # 注意: public_keys との組み合わせも可能ですが、合計で最大5つの公開鍵まで登録可能です。
  public_key = "ssh-rsa AAAA..."

  # public_keys (Optional)
  # 設定内容: このエンドポイントの認証に使用する公開鍵のリストを指定します。
  # 設定可能な値: SSH公開鍵文字列のセット（最大5件）
  # 省略時: null
  public_keys = null

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # security_configuration (Optional)
  # 設定内容: このエンドポイントで使用するセキュリティ設定（Security Configuration）の名前を指定します。
  # 設定可能な値: 有効なGlueセキュリティ設定名
  # 省略時: null (セキュリティ設定なし)
  # 関連機能: AWS Glue セキュリティ設定
  #   暗号化設定（CloudWatch Logs暗号化、ジョブブックマーク暗号化、S3暗号化）を定義するリソースです。
  #   - https://docs.aws.amazon.com/glue/latest/dg/encryption-security-configuration.html
  security_configuration = null

  #-------------------------------------------------------------
  # ライブラリ設定
  #-------------------------------------------------------------

  # extra_jars_s3_path (Optional)
  # 設定内容: このエンドポイントにロードするJavaライブラリ（Jarファイル）のS3パスを指定します。
  # 設定可能な値: S3パスの文字列（カンマ区切りで複数指定可能）
  #   例: "s3://my-bucket/jars/my-library.jar"
  # 省略時: null
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/dev-endpoint.html
  extra_jars_s3_path = null

  # extra_python_libs_s3_path (Optional)
  # 設定内容: このエンドポイントにロードするPythonライブラリのS3パスを指定します。
  # 設定可能な値: S3パスの文字列（カンマ区切りで複数指定可能）
  #   例: "s3://my-bucket/libs/my-library.zip,s3://my-bucket/libs/other-library.zip"
  # 省略時: null
  # 注意: 純粋なPythonライブラリのみサポート。Cエクステンションに依存するライブラリは非対応。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-python-libraries.html
  extra_python_libs_s3_path = null

  #-------------------------------------------------------------
  # 引数設定
  #-------------------------------------------------------------

  # arguments (Optional)
  # 設定内容: エンドポイントの設定に使用する引数のマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（map of strings）
  #   例: "--enable-glue-datacatalog" の設定や Python バージョン指定など
  #   - "--python-version": "3" でPython 3を指定
  # 省略時: null
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/add-dev-endpoint.html
  arguments = {
    "--enable-glue-datacatalog" = "true"
  }

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
  # 省略時: null
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-dev-endpoint"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 開発エンドポイントのARN
# - availability_zone: このエンドポイントが配置されているAWSアベイラビリティゾーン
# - failure_reason: このエンドポイントの現在の障害理由
# - private_address: VPC内でエンドポイントにアクセスするためのプライベートIPアドレス（VPC内作成時のみ）
# - public_address: このエンドポイントが使用するパブリックIPアドレス（非VPC作成時のみ）
# - status: このエンドポイントの現在のステータス
# - vpc_id: このエンドポイントが使用するVPCのID
# - yarn_endpoint_address: このエンドポイントが使用するYARNエンドポイントアドレス
# - zeppelin_remote_spark_interpreter_port: リモートApache SparkインタープリターのApache Zeppelinポート番号
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
