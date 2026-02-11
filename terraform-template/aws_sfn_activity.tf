#---------------------------------------------------------------
# AWS Step Functions Activity
#---------------------------------------------------------------
#
# AWS Step Functionsのアクティビティをプロビジョニングするリソースです。
# アクティビティは、ステートマシン内のタスクを外部のワーカー（EC2インスタンス、
# ECSコンテナ、モバイルデバイス等）で実行するための仕組みを定義します。
# アクティビティワーカーはGetActivityTask APIでタスクをポーリングし、
# 処理完了後にSendTaskSuccessまたはSendTaskFailureで結果を報告します。
#
# AWS公式ドキュメント:
#   - Step Functionsアクティビティの概要: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-activities.html
#   - CreateActivity API: https://docs.aws.amazon.com/step-functions/latest/apireference/API_CreateActivity.html
#   - 保管時の暗号化: https://docs.aws.amazon.com/step-functions/latest/dg/encryption-at-rest.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_activity
#
# Provider Version: 6.28.0
# Generated: 2026-02-08
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sfn_activity" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: アクティビティの名前を指定します。
  # 設定可能な値: 1-80文字の文字列
  # 注意: アクティビティ名はアカウントとリージョン内で90日間一意である必要があります。
  #       角括弧(<>)、波括弧({})、疑問符(?)、アスタリスク(*)、
  #       ダブルクォート(")、ハッシュ(#)、パーセント(%)、バックスラッシュ(\)、
  #       キャレット(^)、パイプ(|)、チルダ(~)、バッククォート(`)、
  #       ドル記号($)、カンマ(,)、セミコロン(;)、コロン(:)、スラッシュ(/)は使用不可。
  #       ASCII制御文字(U+0000-001F, U+007F-009F)も使用できません。
  # 参考: https://docs.aws.amazon.com/step-functions/latest/apireference/API_CreateActivity.html
  name = "my-activity"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_configuration (Optional)
  # 設定内容: アクティビティのデータ暗号化設定を定義します。
  # 関連機能: Step Functions 保管時の暗号化
  #   Step Functionsはデフォルトで透過的なサーバーサイド暗号化を提供します。
  #   カスタマーマネージドKMSキーを使用して、より厳密な暗号化制御を行うことも可能です。
  #   - https://docs.aws.amazon.com/step-functions/latest/dg/encryption-at-rest.html
  encryption_configuration {

    # type (Optional)
    # 設定内容: アクティビティに適用する暗号化タイプを指定します。
    # 設定可能な値:
    #   - "AWS_KMS_KEY": AWSマネージドKMSキーによる暗号化
    #   - "CUSTOMER_MANAGED_KMS_KEY": カスタマーマネージドKMSキーによる暗号化。
    #     kms_key_idの指定が必要です
    type = "CUSTOMER_MANAGED_KMS_KEY"

    # kms_key_id (Optional)
    # 設定内容: データキーの暗号化に使用する対称暗号化KMSキーを指定します。
    # 設定可能な値: KMSキーのエイリアス、エイリアスARN、キーID、またはキーARN
    # 注意: 別のAWSアカウントのKMSキーを指定する場合は、キーARNまたはエイリアスARNを使用する必要があります。
    # 参考: https://docs.aws.amazon.com/kms/latest/APIReference/API_DescribeKey.html#API_DescribeKey_RequestParameters
    kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

    # kms_data_key_reuse_period_seconds (Optional)
    # 設定内容: アクティビティがデータキーを再利用する最大期間（秒）を指定します。
    # 設定可能な値: 60〜900の整数（秒）
    # 省略時: 300秒（5分）
    # 注意: この設定はカスタマーマネージドKMSキー（CUSTOMER_MANAGED_KMS_KEY）の場合のみ適用されます。
    #       AWSマネージドKMSキー（AWS_KMS_KEY）の場合は適用されません。
    #       期間が満了すると、アクティビティは次回にGenerateDataKeyを呼び出します。
    kms_data_key_reuse_period_seconds = 900
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-activity"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アクティビティのAmazon Resource Name (ARN)
#
# - arn: アクティビティのAmazon Resource Name (ARN)
#
# - creation_date: アクティビティが作成された日時
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
