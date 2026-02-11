#---------------------------------------------------------------
# Amazon SageMaker Notebook Instance
#---------------------------------------------------------------
#
# Amazon SageMaker Notebook Instanceは、Jupyterノートブックアプリケーションを実行する
# マシンラーニング（ML）コンピューティングインスタンスです。
# データの準備と処理、モデルのトレーニング用コードの記述、モデルのデプロイ、
# モデルのテストと検証に使用できます。
#
# インスタンスには、Amazon SageMaker Python SDK、AWS SDK for Python (Boto3)、
# AWS CLI、Conda、Pandas、ディープラーニングフレームワークライブラリ、
# その他のデータサイエンスと機械学習ライブラリが事前設定されています。
#
# AWS公式ドキュメント:
#   - Amazon SageMaker notebook instances: https://docs.aws.amazon.com/sagemaker/latest/dg/nbi.html
#   - Create an Amazon SageMaker notebook instance: https://docs.aws.amazon.com/sagemaker/latest/dg/howitworks-create-ws.html
#   - API Reference - CreateNotebookInstance: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateNotebookInstance.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_notebook_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_notebook_instance" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # name - (必須) ノートブックインスタンスの名前
  # ノートブックインスタンスの一意の識別子として使用されます。
  # 作成後は変更できません。
  # 長さ: 0-63文字
  # パターン: [a-zA-Z0-9](-*[a-zA-Z0-9])*
  name = "example-notebook-instance"

  # role_arn - (必須) ノートブックインスタンスで使用されるIAMロールのARN
  # SageMaker AIが他のAWSサービスを呼び出すために使用します。
  # このロールには、SageMaker AIサービスプリンシパル（sagemaker.amazonaws.com）が
  # このロールを引き受けることを許可するポリシーが必要です。
  # また、このAPIの呼び出し元には iam:PassRole 権限が必要です。
  # 長さ: 20-2048文字
  # パターン: arn:aws[a-z\-]*:iam::\d{12}:role/?[a-zA-Z_0-9+=,.@\-_/]+
  role_arn = "arn:aws:iam::123456789012:role/service-role/AmazonSageMaker-ExecutionRole"

  # instance_type - (必須) ノートブックインスタンス用に起動するMLコンピューティングインスタンスのタイプ
  # 要件に応じてインスタンスタイプを選択してください。
  # より大きなデータセットや計算集約的な前処理には、より大きなインスタンスを推奨します。
  # 利用可能なインスタンスタイプ:
  #   - 汎用: ml.t2.*, ml.t3.*, ml.m4.*, ml.m5.*, ml.m5d.*, ml.m6i.*, ml.m7i.*, ml.m6id.*
  #   - コンピューティング最適化: ml.c4.*, ml.c5.*, ml.c5d.*, ml.c6i.*, ml.c7i.*, ml.c6id.*
  #   - メモリ最適化: ml.r5.*, ml.r6i.*, ml.r7i.*, ml.r6id.*
  #   - GPU: ml.p2.*, ml.p3.*, ml.p3dn.*, ml.p4d.*, ml.p4de.*, ml.p5.*, ml.p6-b200.*
  #   - GPU (経済的): ml.g4dn.*, ml.g5.*, ml.g6.*
  #   - 推論最適化: ml.inf1.*, ml.inf2.*, ml.trn1.*, ml.trn1n.*
  instance_type = "ml.t3.medium"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # additional_code_repositories - (オプション) ノートブックインスタンスに関連付ける最大3つのGitリポジトリの配列
  # アカウントにリソースとして保存されているGitリポジトリの名前、
  # またはAWS CodeCommitや他のGitリポジトリのURLを指定できます。
  # これらのリポジトリは、ノートブックインスタンスのデフォルトリポジトリと同じレベルでクローンされます。
  # 配列メンバー: 0-3個
  # 各要素の長さ: 1-1024文字
  # パターン: https://([^/]+)/?(.*)$|^[a-zA-Z0-9](-*[a-zA-Z0-9])*
  additional_code_repositories = []

  # default_code_repository - (オプション) ノートブックインスタンスのデフォルトコードリポジトリとして関連付けるGitリポジトリ
  # アカウントにリソースとして保存されているGitリポジトリの名前、
  # またはAWS CodeCommitや他のGitリポジトリのURLを指定できます。
  # ノートブックインスタンスを開くと、このリポジトリを含むディレクトリで開きます。
  # 長さ: 1-1024文字
  # パターン: https://([^/]+)/?(.*)$|^[a-zA-Z0-9](-*[a-zA-Z0-9])*
  default_code_repository = null

  # direct_internet_access - (オプション) ノートブックへのインターネットアクセスを無効にする場合は「Disabled」に設定
  # Disabledに設定すると、ノートブックインスタンスはVPC内のリソースにのみアクセスでき、
  # VPCにNATゲートウェイを設定しない限り、SageMaker AIトレーニングおよびエンドポイントサービスに接続できません。
  # security_groupsとsubnet_idの設定が必要です。
  # 有効な値: "Enabled" (デフォルト) | "Disabled"
  direct_internet_access = "Enabled"

  # kms_key_id - (オプション) SageMaker AIがノートブックインスタンスに接続されたストレージボリュームのデータを暗号化するために使用するAWS KMSキーのARN
  # Amazon S3サーバーサイド暗号化を使用してモデルアーティファクトを暗号化します。
  # 指定するKMSキーは有効化されている必要があります。
  # 長さ: 0-2048文字
  # パターン: [a-zA-Z0-9:/_-]*
  kms_key_id = null

  # lifecycle_config_name - (オプション) ノートブックインスタンスに関連付けるライフサイクル設定の名前
  # ライフサイクル設定は、ノートブックインスタンスの作成時や起動時に実行されるスクリプトを定義します。
  # インスタンスのカスタマイズ、パッケージのインストール、設定変更などに使用できます。
  # 長さ: 0-63文字
  # パターン: [a-zA-Z0-9](-*[a-zA-Z0-9])*
  lifecycle_config_name = null

  # platform_identifier - (オプション) ノートブックインスタンスランタイム環境のプラットフォーム識別子
  # ノートブックインスタンスのオペレーティングシステムを指定します。
  # 有効な値:
  #   - "notebook-al2-v3" (推奨、AL2の最新バージョン、JupyterLab 3をサポート)
  #   - "notebook-al2023-v1" (Amazon Linux 2023ベース)
  #   - "notebook-al2-v2" (非推奨、2025年6月30日以降新規作成不可)
  #   - "notebook-al2-v1" (非推奨、2025年6月30日以降新規作成不可)
  #   - "notebook-al1-v1" (非推奨、2023年2月1日以降新規作成不可)
  # 長さ: 0-20文字
  # デフォルト値が指定されていない場合は "notebook-al2-v3" が使用されます
  platform_identifier = "notebook-al2-v3"

  # region - (オプション) このリソースが管理されるリージョン
  # 指定しない場合は、プロバイダー設定で設定されたリージョンがデフォルトとなります。
  region = null

  # root_access - (オプション) ノートブックインスタンスのユーザーに対してルートアクセスを有効化または無効化
  # 注意: ライフサイクル設定はノートブックインスタンスをセットアップするためにルートアクセスが必要です。
  # このため、ライフサイクル設定は、ユーザーのルートアクセスを無効にしても常にルートアクセスで実行されます。
  # 有効な値: "Enabled" (デフォルト) | "Disabled"
  root_access = "Enabled"

  # security_groups - (オプション) 関連するセキュリティグループ
  # VPCセキュリティグループID（sg-xxxxxxxxxの形式）を指定します。
  # セキュリティグループは、subnet_idで指定されたサブネットと同じVPCのものである必要があります。
  # 配列メンバー: 0-5個
  # 各要素の長さ: 0-32文字
  # パターン: [-0-9a-zA-Z]+
  security_groups = []

  # subnet_id - (オプション) VPCサブネットのID
  # MLコンピューティングインスタンスから接続したいVPC内のサブネットのIDを指定します。
  # サブネットを指定すると、SageMaker AIはVPC内にネットワークインターフェースを作成します。
  # 長さ: 0-32文字
  # パターン: [-0-9a-zA-Z]+
  subnet_id = null

  # tags - (オプション) リソースに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグはプロバイダーレベルで定義されたタグを上書きします。
  tags = {
    Name        = "example-notebook-instance"
    Environment = "dev"
  }

  # volume_size - (オプション) ノートブックインスタンスに接続するMLストレージボリュームのサイズ（GB単位）
  # データの保存に使用されるEBSボリュームのサイズです。
  # デフォルト値: 5 GB
  # 最小値: 5 GB
  volume_size = 5

  #---------------------------------------------------------------
  # ネストブロック
  #---------------------------------------------------------------

  # instance_metadata_service_configuration - (オプション) ノートブックインスタンスのIMDS設定に関する情報
  # Instance Metadata Service（IMDS）のバージョンを指定します。
  # 最大1個まで設定可能
  instance_metadata_service_configuration {
    # minimum_instance_metadata_service_version - (オプション) ノートブックインスタンスがサポートする最小IMDSバージョン
    # "1"を渡すと、IMDSv1とIMDSv2の両方がサポートされます。
    # "2"を渡すと、IMDSv2のみがサポートされます。
    # 有効な値: "1" | "2"
    # デフォルト: "1"（両方のバージョンをサポート）
    minimum_instance_metadata_service_version = "1"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、設定はできません。
#
# id - ノートブックインスタンスの名前
#
# arn - AWSによって割り当てられたAmazon Resource Name (ARN)
#
# url - ノートブックインスタンスで実行されているJupyterノートブックに接続するために使用するURL
#
# network_interface_id - インスタンス作成時にAmazon SageMaker AIが作成したネットワークインターフェースID
#   subnet_idを設定した場合のみ利用可能
#
# tags_all - リソースに割り当てられたタグのマップ
#   プロバイダーのdefault_tags設定ブロックから継承されたタグを含む
#---------------------------------------------------------------
