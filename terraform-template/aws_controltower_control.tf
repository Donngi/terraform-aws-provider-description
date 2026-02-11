#---------------------------------------------------------------
# AWS Control Tower Control
#---------------------------------------------------------------
#
# AWS Control Towerのコントロール（旧称: ガードレール）をOrganizational Unit (OU)に
# 適用するためのリソースです。コントロールとは、OU全体に適用されるハイレベルな
# ルールであり、その中の全てのアカウントに影響を与えます。
#
# コントロールは、動作（preventive、detective、proactive）とガイダンス
# （mandatory、strongly recommended、elective）によって分類されます。
# このリソースでは、Strongly recommendedとElectiveのコントロール、および
# Region deny guardrailのみが許可されています。
#
# AWS公式ドキュメント:
#   - AWS Control Tower概要: https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html
#   - コントロールの有効化: https://docs.aws.amazon.com/controltower/latest/userguide/enable-guardrails.html
#   - コントロールの動作とガイダンス: https://docs.aws.amazon.com/controltower/latest/controlreference/control-behavior.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/controltower_control
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_controltower_control" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # control_identifier (Required)
  # 設定内容: 有効化するコントロールのARNを指定します。
  # 設定可能な値: AWS Control TowerコントロールのARN形式
  #   形式: arn:aws:controltower:{region}::control/{CONTROL_NAME}
  #   例: arn:aws:controltower:us-east-1::control/AWS-GR_EC2_VOLUME_INUSE_CHECK
  # 制限事項: Strongly recommendedとElectiveのコントロールのみ許可
  #           （Region deny guardrailは例外として許可）
  # 参考: https://docs.aws.amazon.com/controltower/latest/userguide/enable-guardrails.html
  control_identifier = "arn:aws:controltower:us-east-1::control/AWS-GR_EC2_VOLUME_INUSE_CHECK"

  # target_identifier (Required)
  # 設定内容: コントロールを適用する対象のOrganizational Unit (OU)のARNを指定します。
  # 設定可能な値: AWS OrganizationsのOU ARN形式
  #   形式: arn:aws:organizations::{account_id}:ou/o-{org_id}/ou-{ou_id}
  #   例: arn:aws:organizations::123456789012:ou/o-exampleorgid/ou-examplerootid-exampleouid
  # 注意: コントロールはOU配下の全てのアカウントに適用されます
  # 参考: https://docs.aws.amazon.com/controltower/latest/userguide/enable-guardrails.html
  target_identifier = "arn:aws:organizations::123456789012:ou/o-exampleorgid/ou-examplerootid-exampleouid"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: AWSが自動的に生成（通常はtarget_identifierの値が使用されます）
  # 注意: 通常は明示的に指定する必要はありません
  id = null

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルエンドポイント
  #   AWS Control Towerは複数リージョンで利用可能ですが、リソース管理は
  #   指定されたリージョンで行われます。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # パラメータ設定（オプション）
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: コントロールを有効化する際に設定するパラメータ値を指定します。
  # 設定可能な値: keyとvalueのペアを持つブロックのセット
  # 用途: コントロールの動作をカスタマイズする場合に使用
  # 注意: コントロールによって利用可能なパラメータは異なります
  # 例: Region deny guardrailの場合、許可するリージョンのリストを指定
  parameters {
    # key (Required)
    # 設定内容: パラメータの名前を指定します。
    # 設定可能な値: コントロールでサポートされるパラメータ名
    #   例: "AllowedRegions", "ExemptedActions" など
    # 注意: 有効なパラメータ名はコントロールごとに異なります
    key = "AllowedRegions"

    # value (Required)
    # 設定内容: パラメータの値を指定します。
    # 設定可能な値: 文字列（JSON形式でエンコードされた配列やオブジェクトも可能）
    # 例: jsonencode(["us-east-1", "us-west-2"])
    # 注意: 値の形式はパラメータのkeyに応じて変わります
    value = jsonencode(["us-east-1"])
  }

  #-------------------------------------------------------------
  # タイムアウト設定（オプション）
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: Terraform操作のタイムアウト時間を指定します。
  # 用途: コントロールの有効化・無効化には時間がかかる場合があるため、
  #       必要に応じてタイムアウト値を調整します。
  timeouts {
    # create (Optional)
    # 設定内容: コントロールの有効化操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    # デフォルト: 60分
    create = "60m"

    # update (Optional)
    # 設定内容: コントロールの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    # デフォルト: 60分
    update = "60m"

    # delete (Optional)
    # 設定内容: コントロールの無効化操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    # デフォルト: 60分
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 有効化されたコントロールリソースのAmazon Resource Name (ARN)
#        形式: arn:aws:controltower:{region}:{account_id}:enabledcontrol/{id}
#
# - id: Organizational UnitのARN（target_identifierと同じ値）
#---------------------------------------------------------------
