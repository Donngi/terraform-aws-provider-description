#---------------------------------------------------------------
# AWS Service Catalog Provisioning Artifact
#---------------------------------------------------------------
#
# AWS Service Catalog の指定したプロダクトに対するプロビジョニングアーティファクト
# （バージョン）をプロビジョニングするリソースです。
# プロビジョニングアーティファクトは、プロダクトの特定バージョンであり、
# CloudFormation テンプレートや Terraform テンプレート等のソースを指定します。
#
# 注意: 共有されたプロダクトに対してプロビジョニングアーティファクトを作成することはできません。
# 注意: template_physical_id を使用する場合は cloudformation:GetTemplate IAM ポリシー権限が必要です。
#
# AWS公式ドキュメント:
#   - CreateProvisioningArtifact API: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_CreateProvisioningArtifact.html
#   - ProvisioningArtifactProperties: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_ProvisioningArtifactProperties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_provisioning_artifact
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_servicecatalog_provisioning_artifact" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # product_id (Required)
  # 設定内容: プロビジョニングアーティファクトを追加するプロダクトの識別子を指定します。
  # 設定可能な値: 有効な Service Catalog プロダクト ID 文字列
  product_id = "prod-xxxxxxxxxxxx"

  # name (Optional)
  # 設定内容: プロビジョニングアーティファクトの名前を指定します（例: v1, v2beta）。
  # 設定可能な値: スペースを含まない文字列（最大8192文字）
  # 省略時: Terraform が管理する名前が設定されます。
  name = "v1"

  # description (Optional)
  # 設定内容: プロビジョニングアーティファクト（バージョン）の説明を指定します。
  #           前バージョンとの相違点等を記載するのに適しています。
  # 設定可能な値: 文字列（最大8192文字）
  # 省略時: 説明なし
  description = "最初のバージョン"

  # type (Optional)
  # 設定内容: プロビジョニングアーティファクトのタイプを指定します。
  # 設定可能な値:
  #   - "CLOUD_FORMATION_TEMPLATE": AWS CloudFormation テンプレート
  #   - "TERRAFORM_OPEN_SOURCE": Terraform オープンソーステンプレート
  #   - "TERRAFORM_CLOUD": Terraform Cloud テンプレート
  #   - "EXTERNAL": 外部テンプレート
  #   - "MARKETPLACE_AMI": AWS Marketplace AMI
  #   - "MARKETPLACE_CAR": AWS Marketplace Clusters and AWS Resources
  # 省略時: プロダクトの種別に依存します。
  # 参考: https://docs.aws.amazon.com/servicecatalog/latest/dg/API_ProvisioningArtifactProperties.html
  type = "CLOUD_FORMATION_TEMPLATE"

  #-------------------------------------------------------------
  # テンプレートソース設定
  #-------------------------------------------------------------

  # template_url (Optional)
  # 設定内容: Amazon S3 上の CloudFormation テンプレートの URL を指定します。
  #           template_physical_id が指定されない場合は必須です。
  # 設定可能な値: Amazon S3 上の CloudFormation テンプレートの URL（JSON 形式）
  # 注意: template_physical_id と排他的（どちらか一方のみ指定可能）
  template_url = "https://s3.amazonaws.com/mybucket/mytemplate.json"

  # template_physical_id (Optional)
  # 設定内容: テンプレートを含むリソースの物理 ID をテンプレートソースとして指定します。
  #           template_url が指定されない場合は必須です。
  #           現在は CloudFormation スタック ARN のみサポートしています。
  # 設定可能な値: CloudFormation スタック ARN
  #   形式: arn:[partition]:cloudformation:[region]:[account ID]:stack/[stack name]/[resource ID]
  # 注意: この引数を使用するには cloudformation:GetTemplate IAM ポリシー権限が必要です。
  # 注意: template_url と排他的（どちらか一方のみ指定可能）
  template_physical_id = null

  # disable_template_validation (Optional)
  # 設定内容: 指定したプロビジョニングアーティファクトテンプレートが無効な場合でも、
  #           AWS Service Catalog がテンプレートの検証を停止するかどうかを指定します。
  # 設定可能な値:
  #   - true: テンプレートの検証を無効化
  #   - false (デフォルト): テンプレートの検証を有効化
  # 注意: TERRAFORM_OS プロダクトタイプではテンプレート検証はサポートされません。
  disable_template_validation = false

  #-------------------------------------------------------------
  # 公開状態・ガイダンス設定
  #-------------------------------------------------------------

  # active (Optional)
  # 設定内容: プロダクトバージョン（プロビジョニングアーティファクト）をアクティブにするかを指定します。
  #           非アクティブのアーティファクトはエンドユーザーには非表示となり、
  #           非アクティブなバージョンからプロビジョンドプロダクトの起動・更新はできません。
  # 設定可能な値:
  #   - true (デフォルト): アクティブ状態
  #   - false: 非アクティブ状態
  active = true

  # guidance (Optional)
  # 設定内容: 管理者がエンドユーザーに対して、どのプロビジョニングアーティファクトを使用すべきかの
  #           ガイダンス情報を設定します。
  # 設定可能な値:
  #   - "DEFAULT" (デフォルト): 標準のアーティファクト
  #   - "DEPRECATED": 非推奨のアーティファクト。非推奨バージョンからの更新は可能ですが、
  #                   新規プロビジョンドプロダクトの起動には使用できません。
  guidance = "DEFAULT"

  #-------------------------------------------------------------
  # 言語設定
  #-------------------------------------------------------------

  # accept_language (Optional)
  # 設定内容: API レスポンスの言語コードを指定します。
  # 設定可能な値:
  #   - "en" (デフォルト): 英語
  #   - "jp": 日本語
  #   - "zh": 中国語
  # 省略時: "en"（英語）が使用されます。
  accept_language = "jp"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # read (Optional)
    # 設定内容: リソース読み取り時のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 文字列（例: "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    read = "10m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Go の duration 文字列（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: プロビジョニングアーティファクト識別子とプロダクト識別子をコロンで区切った文字列
#
# - provisioning_artifact_id: プロビジョニングアーティファクトの識別子
#
# - created_time: プロビジョニングアーティファクトが作成された日時（UTC）
#---------------------------------------------------------------
