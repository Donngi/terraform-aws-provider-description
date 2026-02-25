#---------------------------------------------------------------
# Amazon SageMaker AI Image Version
#---------------------------------------------------------------
#
# Amazon SageMaker AI イメージのバージョンをプロビジョニングするリソースです。
# イメージバージョンは、Amazon ECR コンテナイメージの特定バージョンを表し、
# SageMaker AI ジョブ（トレーニング、推論、ノートブックカーネル）で使用される
# Docker コンテナイメージのバージョン管理を行います。
#
# AWS公式ドキュメント:
#   - CreateImageVersion API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_CreateImageVersion.html
#   - DescribeImageVersion API: https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_DescribeImageVersion.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/sagemaker_image_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
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
  # 設定内容: バージョンを作成するSageMaker AIイメージの名前を指定します。
  # 設定可能な値: アカウント内で一意の文字列
  image_name = "my-sagemaker-image"

  # base_image (Required)
  # 設定内容: このイメージバージョンのベースとなるコンテナイメージのレジストリパスを指定します。
  # 設定可能な値: 有効なAmazon ECRイメージURIまたはDockerレジストリのパス
  #   例: "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-image:latest"
  base_image = "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-image:latest"

  #-------------------------------------------------------------
  # エイリアス設定
  #-------------------------------------------------------------

  # aliases (Optional)
  # 設定内容: このイメージバージョンに付けるエイリアスのセットを指定します。
  # 設定可能な値: 文字列のセット（例: ["latest", "stable", "v1.0"]）
  # 省略時: エイリアスなし
  aliases = null

  #-------------------------------------------------------------
  # ジョブ互換性設定
  #-------------------------------------------------------------

  # job_type (Optional)
  # 設定内容: このイメージバージョンが互換性を持つSageMaker AIジョブタイプを指定します。
  # 設定可能な値:
  #   - "TRAINING": トレーニングジョブ互換
  #   - "INFERENCE": 推論ジョブ互換
  #   - "NOTEBOOK_KERNEL": ノートブックカーネル互換
  # 省略時: 指定なし
  job_type = null

  #-------------------------------------------------------------
  # プロセッサー設定
  #-------------------------------------------------------------

  # processor (Optional)
  # 設定内容: このイメージバージョンのCPUまたはGPU互換性を指定します。
  # 設定可能な値:
  #   - "CPU": CPUのみで動作
  #   - "GPU": GPUで動作
  # 省略時: 指定なし
  processor = null

  # horovod (Optional)
  # 設定内容: Horovod（分散ディープラーニングフレームワーク）との互換性を指定します。
  # 設定可能な値:
  #   - true: Horovod互換
  #   - false: Horovod非互換
  # 省略時: false
  horovod = null

  #-------------------------------------------------------------
  # フレームワーク・言語設定
  #-------------------------------------------------------------

  # ml_framework (Optional)
  # 設定内容: このイメージバージョンに含まれる機械学習フレームワークとそのバージョンを指定します。
  # 設定可能な値: フレームワーク名とバージョンの文字列（例: "PyTorch 1.10.0"、"TensorFlow 2.8.0"）
  # 省略時: 指定なし
  ml_framework = null

  # programming_lang (Optional)
  # 設定内容: このイメージバージョンでサポートされるプログラミング言語とバージョンを指定します。
  # 設定可能な値: 言語名とバージョンの文字列（例: "Python 3.9"）
  # 省略時: 指定なし
  programming_lang = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # release_notes (Optional)
  # 設定内容: イメージバージョンのメンテナーによるリリースノート・説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 指定なし
  release_notes = null

  # vendor_guidance (Optional)
  # 設定内容: メンテナーによるイメージバージョンの安定性・利用ガイダンスを指定します。
  # 設定可能な値:
  #   - "NOT_PROVIDED": ガイダンスなし
  #   - "STABLE": 安定版。本番環境での利用推奨
  #   - "TO_BE_ARCHIVED": 将来的にアーカイブ予定。移行を推奨
  #   - "ARCHIVED": アーカイブ済み。使用非推奨
  # 省略時: 指定なし
  vendor_guidance = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: イメージバージョンに割り当てられたAmazon Resource Name (ARN)
# - image_arn: このバージョンのベースとなるイメージのARN
# - container_image: このイメージバージョンを含むコンテナイメージのレジストリパス
# - version: イメージのバージョン番号
#---------------------------------------------------------------
