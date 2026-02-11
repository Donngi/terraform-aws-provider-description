#---------------------------------------------------------------
# AWS Systems Manager Incident Manager Replication Set
#---------------------------------------------------------------
#
# AWS Systems Manager Incident Managerのレプリケーションセットをプロビジョニングするリソースです。
# レプリケーションセットは、インシデントデータを複数のAWSリージョンにレプリケートし、
# クロスリージョン冗長性を確保するための設定です。
#
# AWS公式ドキュメント:
#   - レプリケーションセットの設定: https://docs.aws.amazon.com/incident-manager/latest/userguide/general-settings.html
#   - クロスリージョン・クロスアカウント管理: https://docs.aws.amazon.com/incident-manager/latest/userguide/incident-manager-cross-account-cross-region.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssmincidents_replication_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssmincidents_replication_set" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # regions (Required)
  # 設定内容: レプリケーションセットに含めるリージョンを指定します。
  # 少なくとも1つのリージョンが必要です。クロスリージョン冗長性のため、
  # 2つ以上のリージョンを指定することが推奨されます。
  # 注意: Terraformプロバイダーで指定しているリージョンは必ず含める必要があります。
  # 注意: リージョンの追加・削除は一度に1リージョンずつ行う必要があります。
  # 参考: https://docs.aws.amazon.com/incident-manager/latest/userguide/general-settings.html
  regions {
    # name (Required)
    # 設定内容: リージョン名を指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, ap-northeast-1）
    name = "ap-northeast-1"

    # kms_key_arn (Optional)
    # 設定内容: データ暗号化に使用するカスタマー管理キー（CMK）のARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 省略時: AWSマネージドキー（DefaultKey）が使用されます。
    # 注意: レプリケーションセット内の全リージョンで、AWS所有キーまたはCMKのいずれかに統一する必要があります。
    # 注意: 作成後にCMKを変更するには、リージョンを削除して別のキーで再追加する必要があります。
    # 注意: CMKはレプリケーションセットの作成前に作成しておくことを推奨します。
    kms_key_arn = null
  }

  regions {
    name = "us-west-2"

    kms_key_arn = null
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
  #   - https://docs.aws.amazon.com/incident-manager/latest/userguide/general-settings.html
  tags = {
    Name        = "my-replication-set"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます。
    # 注意: レプリケーションセットを削除すると、レスポンスプラン、インシデントレコード、
    #        コンタクト、エスカレーションプランを含むすべてのIncident Manager関連データが削除されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: レプリケーションセットのAmazon Resource Name (ARN)
#
# - created_by: レプリケーションセットを作成したユーザーのARN
#
# - deletion_protected: trueの場合、レプリケーションセットの最後のリージョンを
#                        削除できません。
#
# - last_modified_by: レプリケーションセットを最後に変更したユーザーのARN
#
# - status: レプリケーションセットの全体的なステータス
#           有効な値: ACTIVE | CREATING | UPDATING | DELETING | FAILED
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# regions内の読み取り専用属性:
# - status: リージョンの現在のステータス
#           有効な値: ACTIVE | CREATING | UPDATING | DELETING | FAILED
# - status_message: リージョンのステータスに関する詳細情報
#---------------------------------------------------------------
