#---------------------------------------------------------------
# Amazon SageMaker Notebook Instance
#---------------------------------------------------------------
#
# Amazon SageMaker AI のノートブックインスタンスをプロビジョニングするリソースです。
# ノートブックインスタンスは Jupyter Notebook アプリケーションを実行する
# 機械学習コンピューティングインスタンスです。データの準備・前処理、モデルの
# トレーニング・デプロイ・検証を行う事前設定済み環境を提供します。
#
# AWS公式ドキュメント:
#   - SageMaker Notebook Instances概要: https://docs.aws.amazon.com/sagemaker/latest/dg/nbi.html
#   - ノートブックインスタンスの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/howitworks-create-ws.html
#   - CreateNotebookInstance API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateNotebookInstance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_notebook_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_notebook_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: ノートブックインスタンスの名前を指定します。アカウント内で一意である必要があります。
  # 設定可能な値: 1-63文字の英数字またはハイフン（-）。先頭は英字
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateNotebookInstance.html
  name = "my-notebook-instance"

  # instance_type (Required)
  # 設定内容: ノートブックインスタンスで起動する ML コンピューティングインスタンスのタイプを指定します。
  # 設定可能な値: ml.t2.medium, ml.t2.large, ml.t2.xlarge, ml.t2.2xlarge,
  #   ml.t3.medium, ml.t3.large, ml.t3.xlarge, ml.t3.2xlarge,
  #   ml.m4.xlarge, ml.m4.2xlarge, ml.m4.4xlarge, ml.m4.10xlarge, ml.m4.16xlarge,
  #   ml.m5.xlarge, ml.m5.2xlarge, ml.m5.4xlarge, ml.m5.12xlarge, ml.m5.24xlarge,
  #   ml.c4.xlarge, ml.c4.2xlarge, ml.c4.4xlarge, ml.c4.8xlarge,
  #   ml.c5.xlarge, ml.c5.2xlarge, ml.c5.4xlarge, ml.c5.9xlarge, ml.c5.18xlarge,
  #   ml.p2.xlarge, ml.p2.8xlarge, ml.p2.16xlarge,
  #   ml.p3.2xlarge, ml.p3.8xlarge, ml.p3.16xlarge 等
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateNotebookInstance.html
  instance_type = "ml.t3.medium"

  # role_arn (Required)
  # 設定内容: ノートブックインスタンスが使用する IAM ロールの ARN を指定します。
  #   SageMaker AI が他のサービスを呼び出すための権限を付与します。
  # 設定可能な値: 有効な IAM ロールの ARN
  # 注意: ロールには Amazon S3 へのアクセス権限や SageMaker AI 関連の権限が必要です。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/howitworks-create-ws.html
  role_arn = "arn:aws:iam::123456789012:role/sagemaker-notebook-role"

  #-------------------------------------------------------------
  # プラットフォーム設定
  #-------------------------------------------------------------

  # platform_identifier (Optional, Forces new resource)
  # 設定内容: ノートブックインスタンスのランタイム環境のプラットフォーム識別子を指定します。
  # 設定可能な値:
  #   - "notebook-al1-v1" (非推奨): Amazon Linux 1 ベース
  #   - "notebook-al2-v1" (非推奨): Amazon Linux 2 ベース v1
  #   - "notebook-al2-v2" (非推奨): Amazon Linux 2 ベース v2
  #   - "notebook-al2-v3" (デフォルト): Amazon Linux 2 ベース v3
  #   - "notebook-al2023-v1": Amazon Linux 2023 ベース v1
  # 省略時: "notebook-al2-v3" が使用されます。
  platform_identifier = "notebook-al2-v3"

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # volume_size (Optional)
  # 設定内容: ノートブックインスタンスに接続する ML ストレージボリュームのサイズを GB 単位で指定します。
  # 設定可能な値: 5 〜 16384 の整数（GB）
  # 省略時: 5 GB が使用されます。
  # 注意: ボリュームサイズを縮小することはできません。縮小する場合はインスタンスを再作成する必要があります。
  volume_size = 5

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_id (Optional, Forces new resource)
  # 設定内容: ノートブックインスタンスを配置する VPC のサブネット ID を指定します。
  # 設定可能な値: 有効なサブネット ID
  # 省略時: SageMaker AI のデフォルト VPC に配置されます。
  # 注意: direct_internet_access を "Disabled" にする場合は必須です。
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/howitworks-create-ws.html
  subnet_id = null

  # security_groups (Optional, Forces new resource)
  # 設定内容: ノートブックインスタンスに関連付けるセキュリティグループの ID セットを指定します。
  # 設定可能な値: セキュリティグループ ID の集合
  # 省略時: SageMaker AI がデフォルトのセキュリティグループを作成して使用します。
  security_groups = null

  # direct_internet_access (Optional, Forces new resource)
  # 設定内容: ノートブックインスタンスのインターネットアクセスを制御します。
  # 設定可能な値:
  #   - "Enabled" (デフォルト): インターネットアクセスを有効化
  #   - "Disabled": インターネットアクセスを無効化。VPC 内のリソースのみにアクセス可能
  # 省略時: "Enabled" が使用されます。
  # 注意: "Disabled" に設定する場合は security_groups と subnet_id の指定が必要です。
  #       "Disabled" の場合、SageMaker AI トレーニングおよびエンドポイントサービスへの接続には
  #       VPC に NAT Gateway を設定する必要があります。
  direct_internet_access = "Enabled"

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # kms_key_id (Optional, Forces new resource)
  # 設定内容: Amazon S3 のサーバーサイド暗号化を使用してモデルアーティファクトを保存する際に
  #   Amazon SageMaker AI が使用する AWS KMS キーを指定します。
  # 設定可能な値: KMS キー ID または KMS キーの ARN
  # 省略時: 暗号化なし（またはデフォルトの S3 暗号化が適用）
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/howitworks-create-ws.html
  kms_key_id = null

  # root_access (Optional)
  # 設定内容: ノートブックインスタンスのユーザーに対するルートアクセスの有効・無効を指定します。
  # 設定可能な値:
  #   - "Enabled" (デフォルト): ルートアクセスを有効化
  #   - "Disabled": ルートアクセスを無効化
  # 省略時: "Enabled" が使用されます。
  # 注意: ライフサイクル設定スクリプトはルートとして実行されるため、
  #       ルートアクセスを無効にしてもライフサイクル設定スクリプトは引き続き実行されます。
  root_access = "Enabled"

  #-------------------------------------------------------------
  # コードリポジトリ設定
  #-------------------------------------------------------------

  # default_code_repository (Optional)
  # 設定内容: ノートブックインスタンスのデフォルトコードリポジトリとして関連付ける
  #   Git リポジトリを指定します。
  # 設定可能な値: アカウントに保存された Git リポジトリのリソース名、
  #   または AWS CodeCommit やその他の Git リポジトリの URL
  # 省略時: デフォルトコードリポジトリなし
  # 参考: https://docs.aws.amazon.com/codecommit/latest/userguide/welcome.html
  default_code_repository = null

  # additional_code_repositories (Optional)
  # 設定内容: ノートブックインスタンスに関連付ける追加の Git リポジトリの配列を指定します。
  #   デフォルトリポジトリと同じレベルにクローンされます。
  # 設定可能な値: 最大3つの Git リポジトリ名または URL のセット
  # 省略時: 追加コードリポジトリなし
  # 注意: default_code_repository と合わせて最大4つのリポジトリを関連付けられます。
  additional_code_repositories = null

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # lifecycle_config_name (Optional)
  # 設定内容: ノートブックインスタンスに関連付けるライフサイクル設定の名前を指定します。
  #   ライフサイクル設定スクリプトは、インスタンスの作成時または起動時に実行されます。
  # 設定可能な値: 既存のライフサイクル設定名
  # 省略時: ライフサイクル設定なし
  # 参考: https://docs.aws.amazon.com/sagemaker/latest/dg/notebook-lifecycle-config.html
  lifecycle_config_name = null

  #-------------------------------------------------------------
  # メタデータサービス設定
  #-------------------------------------------------------------

  instance_metadata_service_configuration {
    # minimum_instance_metadata_service_version (Optional)
    # 設定内容: ノートブックインスタンスがサポートする最小 IMDS（Instance Metadata Service）バージョンを指定します。
    # 設定可能な値:
    #   - "1": IMDSv1 と IMDSv2 の両方をサポート
    #   - "2": IMDSv2 のみをサポート（より安全）
    # 省略時: IMDSv1 と IMDSv2 の両方がサポートされます。
    # 注意: IMDSv2 はセキュリティ強化版であり、可能な限り "2" の使用を推奨します。
    # 参考: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_InstanceMetadataServiceConfiguration.html
    minimum_instance_metadata_service_version = "2"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
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
    Name        = "my-notebook-instance"
    Environment = "development"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ノートブックインスタンスの名前
# - arn: ノートブックインスタンスの Amazon Resource Name (ARN)
# - url: ノートブックインスタンスで実行されている Jupyter ノートブックへの接続 URL
# - network_interface_id: SageMaker AI がインスタンス作成時に作成したネットワークインターフェイス ID
#                         (subnet_id を設定した場合のみ利用可能)
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
