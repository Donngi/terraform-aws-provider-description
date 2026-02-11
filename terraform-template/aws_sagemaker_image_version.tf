#---------------------------------------------------------------
# AWS SageMaker Image Version
#---------------------------------------------------------------
#
# SageMaker AIイメージの特定バージョンを管理するリソースです。
# SageMaker AIイメージは、Amazon Elastic Container Registry (ECR)に格納された
# コンテナイメージを表すバージョンのセットであり、SageMaker Studio、
# SageMaker Canvas、SageMaker Notebooksで使用可能なカスタム環境を提供します。
#
# 各イメージバージョンは以下の情報を含みます:
#   - ベースイメージ: ECRのコンテナイメージパス
#   - 互換性情報: Horovod、ジョブタイプ、MLフレームワーク、プロセッサ、プログラミング言語
#   - バージョン管理: エイリアス、リリースノート、ベンダーガイダンス
#
# AWS公式ドキュメント:
#   - イメージバージョン概要: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi.html
#   - CreateImageVersion API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateImageVersion.html
#   - カスタムイメージの作成: https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-create.html
#   - ImageVersion データ型: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_ImageVersion.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sagemaker_image_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sagemaker_image_version" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # image_name (Required)
  # 設定内容: イメージの名前を指定します。
  # 設定可能な値: 既存のSageMaker AIイメージの名前
  # 注意: この名前はAWSアカウント内で一意である必要があります
  # 関連リソース: aws_sagemaker_image リソースで作成されたイメージ名を参照
  # 関連機能: SageMaker Image
  #   イメージはバージョンのコンテナであり、各バージョンは異なるコンテナイメージを指します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateImage.html
  image_name = "example-image"

  # base_image (Required)
  # 設定内容: このイメージバージョンのベースとなるコンテナイメージのレジストリパスを指定します。
  # 設定可能な値: Amazon ECRのコンテナイメージURI
  # 形式: <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
  # 例: "012345678912.dkr.ecr.us-west-2.amazonaws.com/my-image:latest"
  # 注意:
  #   - ECRリポジトリはSageMakerと同じAWSリージョンに存在する必要があります
  #   - イメージはSageMaker AI互換の仕様を満たす必要があります
  # 関連機能: Amazon ECR Integration
  #   SageMakerはECRからコンテナイメージをプルして、Studio環境で使用します。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-specs.html
  base_image = "012345678912.dkr.ecr.us-west-2.amazonaws.com/example-image:latest"

  #-------------------------------------------------------------
  # バージョン管理
  #-------------------------------------------------------------

  # aliases (Optional)
  # 設定内容: イメージバージョンのエイリアスのリストを指定します。
  # 設定可能な値: 文字列のリスト（例: ["latest", "stable", "v1.0"]）
  # 省略時: エイリアスは設定されません
  # 用途:
  #   - 特定のバージョンに分かりやすい名前を付与
  #   - 環境の移行や段階的なデプロイメントをサポート
  # 例: "latest"エイリアスを最新の安定版に割り当て、"dev"を開発版に割り当て
  # 関連機能: Image Version Aliases
  #   エイリアスを使用することで、バージョン番号を直接指定せずにイメージを参照可能。
  #   - https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateImageVersion.html
  aliases = ["latest", "stable"]

  # release_notes (Optional)
  # 設定内容: イメージバージョンのメンテナー説明を指定します。
  # 設定可能な値: リリースノートの文字列（最大255文字）
  # 省略時: リリースノートは設定されません
  # 用途: バージョンの変更内容、追加機能、修正内容などを記録
  # 例: "Added TensorFlow 2.13 support and updated scikit-learn to 1.3.0"
  release_notes = "Initial release with Python 3.10, TensorFlow 2.13, and PyTorch 2.0"

  #-------------------------------------------------------------
  # 互換性情報
  #-------------------------------------------------------------

  # horovod (Optional)
  # 設定内容: Horovod互換性を示すフラグを指定します。
  # 設定可能な値: true または false
  # 省略時: Horovod互換性は設定されません
  # 関連機能: Horovod Framework
  #   Horovodは分散ディープラーニングフレームワークで、TensorFlowやPyTorchの
  #   トレーニングをマルチGPU・マルチノードでスケールさせます。
  #   - https://horovod.ai/
  horovod = false

  # job_type (Optional)
  # 設定内容: SageMaker AIジョブタイプの互換性を示します。
  # 設定可能な値:
  #   - "TRAINING": トレーニングジョブ用
  #   - "INFERENCE": 推論（エンドポイント）用
  #   - "NOTEBOOK_KERNEL": ノートブックカーネル用
  # 省略時: ジョブタイプは指定されません
  # 用途: イメージが特定のSageMaker機能で使用可能かを明示
  # 関連機能: SageMaker Job Types
  #   各ジョブタイプは異なる要件と機能を持ちます。
  #   - Training: モデルトレーニング用の環境
  #   - Inference: モデル推論・デプロイ用の環境
  #   - Notebook Kernel: Studio内のノートブック実行用
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/studio-byoi-specs.html
  job_type = "NOTEBOOK_KERNEL"

  # ml_framework (Optional)
  # 設定内容: イメージバージョンに含まれる機械学習フレームワークを指定します。
  # 設定可能な値: MLフレームワーク名の文字列
  # 例: "TensorFlow", "PyTorch", "Scikit-learn", "XGBoost", "MXNet"
  # 省略時: MLフレームワークは指定されません
  # 用途: イメージに含まれる主要なMLフレームワークを明示
  # 関連機能: ML Framework Support
  #   SageMakerは様々なMLフレームワークをサポートし、各フレームワークに最適化された
  #   ビルトインイメージも提供しています。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/frameworks.html
  ml_framework = "TensorFlow"

  # processor (Optional)
  # 設定内容: CPUまたはGPU互換性を示します。
  # 設定可能な値:
  #   - "CPU": CPUベースのインスタンス用
  #   - "GPU": GPUベースのインスタンス用
  # 省略時: プロセッサタイプは指定されません
  # 用途: イメージがCPUまたはGPUインスタンスで動作するかを明示
  # 関連機能: Instance Type Compatibility
  #   GPUイメージはCUDAやcuDNNなどのGPUライブラリを含む必要があります。
  #   - https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html
  processor = "CPU"

  # programming_lang (Optional)
  # 設定内容: サポートされているプログラミング言語とそのバージョンを指定します。
  # 設定可能な値: プログラミング言語名とバージョンの文字列
  # 例: "Python 3.10", "R 4.2", "Julia 1.8"
  # 省略時: プログラミング言語は指定されません
  # 用途: イメージで使用可能な主要プログラミング言語を明示
  programming_lang = "Python 3.10"

  # vendor_guidance (Optional)
  # 設定内容: メンテナーによって指定されたイメージバージョンの安定性を示します。
  # 設定可能な値:
  #   - "NOT_PROVIDED": ガイダンスが提供されていない（デフォルト）
  #   - "STABLE": 安定版として推奨
  #   - "TO_BE_ARCHIVED": 近くアーカイブ予定
  #   - "ARCHIVED": アーカイブ済み（非推奨）
  # 省略時: "NOT_PROVIDED"
  # 用途: イメージバージョンのライフサイクルステージを示す
  # 関連機能: Version Lifecycle Management
  #   ベンダーガイダンスを使用して、ユーザーに推奨バージョンや非推奨バージョンを
  #   明確に伝えることができます。
  #   - https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateImageVersion.html
  vendor_guidance = "STABLE"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: イメージバージョンはリージョン固有のリソースです
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # id (Optional, Computed)
  # 設定内容: リソースのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: イメージバージョンのID
#
# - arn: AWSによってこのイメージバージョンに割り当てられた
#        Amazon Resource Name (ARN)
#
# - version: イメージのバージョン番号
#   指定しない場合、最新バージョンが記述されます
#
# - container_image: このイメージバージョンを含むコンテナイメージの
#   レジストリパス
#
# - image_arn: このバージョンが基づいているイメージのARN
#---------------------------------------------------------------

#---------------------------------------------------------------
# 基本的な使用例:
#
# # 1. SageMaker Imageの作成
# resource "aws_sagemaker_image" "example" {
#   image_name = "example-image"
#---------------------------------------------------------------
