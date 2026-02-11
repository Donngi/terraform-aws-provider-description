#---------------------------------------------------------------
# AWS DataZone Domain
#---------------------------------------------------------------
#
# Amazon DataZoneドメインを管理するためのリソースです。
# DataZoneは、AWS全体でデータを安全に共有・管理するためのデータ管理サービスで、
# ドメインはデータ資産、プロジェクト、ユーザーを整理するための最上位のコンテナです。
#
# AWS公式ドキュメント:
#   - DataZone概要: https://docs.aws.amazon.com/datazone/latest/userguide/what-is-datazone.html
#   - ドメインの作成: https://docs.aws.amazon.com/datazone/latest/userguide/create-domain.html
#   - IAM Identity Center統合: https://docs.aws.amazon.com/datazone/latest/userguide/enable-IAM-identity-center-for-datazone.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_domain
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_datazone_domain" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: DataZoneドメインの名前を指定します。
  # 設定可能な値: 文字列
  name = "my-datazone-domain"

  # description (Optional)
  # 設定内容: DataZoneドメインの説明を指定します。
  # 設定可能な値: 文字列
  description = "My DataZone domain for data management"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # domain_execution_role (Required)
  # 設定内容: DataZoneがドメインを設定するために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: このロールにはDataZone、RAM、SSO、KMSなどへのアクセス権限が必要です。
  #       信頼関係にdatazone.amazonaws.comとcloudformation.amazonaws.comを含める必要があります。
  domain_execution_role = "arn:aws:iam::123456789012:role/datazone-domain-execution-role"

  # service_role (Optional)
  # 設定内容: DataZoneが使用するサービスロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 注意: domain_versionが"V2"の場合は必須です。
  #       信頼関係にdatazone.amazonaws.comを含める必要があります。
  service_role = null

  #-------------------------------------------------------------
  # ドメインバージョン設定
  #-------------------------------------------------------------

  # domain_version (Optional)
  # 設定内容: DataZoneドメインのバージョンを指定します。
  # 設定可能な値:
  #   - "V1": 従来のドメインバージョン（デフォルト）
  #   - "V2": 新しいドメインバージョン（追加機能あり、service_roleが必須）
  # 注意: V2を使用する場合はservice_roleの指定が必須となります。
  domain_version = "V1"

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

  # kms_key_identifier (Optional)
  # 設定内容: DataZoneドメイン、メタデータ、レポートデータの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 注意: 省略した場合、AWSマネージドキーが使用されます。
  kms_key_identifier = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # skip_deletion_check (Optional)
  # 設定内容: ドメイン削除時の検証チェックをスキップするかを指定します。
  # 設定可能な値:
  #   - true: 削除チェックをスキップ
  #   - false: 削除チェックを実行（デフォルト）
  # 注意: trueに設定すると、ドメイン内にプロジェクトやアセットが存在しても削除されます。
  skip_deletion_check = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-datazone-domain"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # single_sign_on ブロック (Optional)
  #-------------------------------------------------------------
  # シングルサインオン（SSO）の設定を定義します。
  # AWS IAM Identity Centerを使用してDataZoneへのアクセスを管理できます。
  # 関連機能: IAM Identity Center統合
  #   - https://docs.aws.amazon.com/datazone/latest/userguide/enable-IAM-identity-center-for-datazone.html

  single_sign_on {
    # type (Optional)
    # 設定内容: シングルサインオンのタイプを指定します。
    # 設定可能な値:
    #   - "IAM_IDC": AWS IAM Identity Centerを使用したSSO
    #   - "DISABLED": SSOを無効化
    type = "DISABLED"

    # user_assignment (Optional)
    # 設定内容: ユーザーのアサイン方法を指定します。
    # 設定可能な値:
    #   - "AUTOMATIC": IAM Identity Centerディレクトリに追加された全ユーザーがアクセス可能（暗黙的アサイン）
    #   - "MANUAL": 特定のユーザーまたはグループを明示的に追加する必要あり（明示的アサイン）
    # 注意: typeが"IAM_IDC"の場合にのみ有効
    user_assignment = null
  }

  #-------------------------------------------------------------
  # timeouts ブロック (Optional)
  #-------------------------------------------------------------
  # リソースの作成・削除操作のタイムアウト値を指定します。

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト値を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト値を指定します。
    # 設定可能な値: 期間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: DataZoneドメインのAmazon Resource Name (ARN)
#
# - id: DataZoneドメインのID
#
# - portal_url: DataZoneドメインのデータポータルURL
#   ユーザーはこのURLを通じてDataZoneポータルにアクセスできます。
#
# - root_domain_unit_id: ルートドメインユニットのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
