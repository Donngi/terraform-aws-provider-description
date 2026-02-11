#---------------------------------------------------------------
# AWS WAF Regional Geo Match Set
#---------------------------------------------------------------
#
# AWS WAF Regional用の地理的マッチセットをプロビジョニングするリソースです。
# 地理的マッチセットは、Webリクエストの発信国に基づいてリクエストを
# 許可またはブロックするための条件を定義します。
#
# 注意: AWS WAF Classicは廃止予定です。新規実装には最新版のAWS WAF
# (aws_wafv2_*)の使用を推奨します。
#
# AWS公式ドキュメント:
#   - Working with geographic match conditions: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-geo-conditions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_geo_match_set
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_geo_match_set" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 地理的マッチセットの名前または説明を指定します。
  # 設定可能な値: 英数字(A-Z, a-z, 0-9)および特殊文字(_-!"#`+*},./)を含む文字列
  # 注意: 作成後に名前を変更することはできません。
  name = "geo_match_set"

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
  # 地理的マッチ制約設定
  #-------------------------------------------------------------

  # geo_match_constraint (Optional)
  # 設定内容: AWS WAFが検索する国を含む地理的マッチ制約オブジェクトを指定します。
  # 省略時: 制約なし（空のセット）
  # 関連機能: 地理的マッチ条件
  #   Webリクエストの発信国に基づいてリクエストを許可またはブロックできます。
  #   複数の国を指定する場合は、複数のgeo_match_constraintブロックを定義します。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-geo-conditions.html

  geo_match_constraint {
    # type (Required)
    # 設定内容: 地理的マッチの種類を指定します。
    # 設定可能な値:
    #   - "Country": 国コードでマッチング（現在サポートされている唯一の値）
    type = "Country"

    # value (Required)
    # 設定内容: マッチングする国のISO 3166-1 alpha-2国コードを指定します。
    # 設定可能な値: 2文字の国コード（例: "US", "JP", "CA", "GB"）
    # 参考: ISO 3166-1 alpha-2国コード一覧
    value = "US"
  }

  # 複数の国を指定する例:
  geo_match_constraint {
    type  = "Country"
    value = "CA"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Regional Geo Match SetのID
#---------------------------------------------------------------
