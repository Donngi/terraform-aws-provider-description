#---------------------------------------------------------------
# AWS Route 53 Recovery Readiness Recovery Group
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) の Recovery Readiness
# 機能におけるリカバリグループをプロビジョニングするリソースです。
# リカバリグループはアプリケーション全体を表し、各セル（アプリケーションの
# レプリカ）を集約することで、フェイルオーバーの準備状況を一元的に監視します。
#
# AWS公式ドキュメント:
#   - Recovery Readiness概要: https://docs.aws.amazon.com/recovery-readiness/latest/api/what-is-recovery-readiness.html
#   - Recovery GroupsとReadiness Checks: https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.recovery-groups-and-readiness-checks.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_recovery_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoveryreadiness_recovery_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # recovery_group_name (Required)
  # 設定内容: リカバリグループを識別するための一意の名前を指定します。
  # 設定可能な値: 文字列。AWSアカウント内で一意である必要があります
  # 用途: アプリケーション全体の準備状況を集約的に監視するための
  #       リカバリグループの識別子として使用されます。各セル（リージョンや
  #       AZごとのアプリケーションレプリカ）をまとめて管理します。
  # 参考: https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.recovery-groups-and-readiness-checks.html
  recovery_group_name = "my-high-availability-app"

  #-------------------------------------------------------------
  # セル設定
  #-------------------------------------------------------------

  # cells (Optional)
  # 設定内容: このリカバリグループにネストされた障害ドメインとして追加するセルARNのリストを指定します。
  # 設定可能な値: セルARNのリスト
  # 省略時: セルが関連付けられていない空のリカバリグループが作成されます
  # 関連機能: Recovery Readiness Cell
  #   セルは、アプリケーションの個別のレプリカ（通常は異なるAWSリージョンまたは
  #   アベイラビリティゾーンにデプロイされたもの）を表します。リカバリグループに
  #   セルを追加すると、ARCが各セル内のリソースの準備状況を継続的に監視し、
  #   アプリケーション全体の準備状況を集約して提供します。
  #   - https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.recovery-groups-and-readiness-checks.html
  # 注意: 各セルは1つのリカバリグループにのみ関連付けることができます
  cells = [
    # aws_route53recoveryreadiness_cell.us_east_1.arn,
    # aws_route53recoveryreadiness_cell.us_west_2.arn,
  ]

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-high-availability-app"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リカバリグループのAmazon Resource Name (ARN)
#        形式: arn:aws:route53-recovery-readiness::account-id:recovery-group/recovery-group-name
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
