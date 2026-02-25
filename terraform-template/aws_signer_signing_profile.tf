#---------------------------------------------------------------
# AWS Signer 署名プロファイル
#---------------------------------------------------------------
#
# AWS Signerの署名プロファイルをプロビジョニングするリソースです。
# 署名プロファイルにはコード署名設定パラメーターの情報が含まれており、
# Lambda関数等のコードに対して署名ジョブを実行する際に使用されます。
#
# AWS公式ドキュメント:
#   - AWS Signer とは: https://docs.aws.amazon.com/signer/latest/developerguide/Welcome.html
#   - 署名プロファイルの管理: https://docs.aws.amazon.com/signer/latest/developerguide/gs-profile-managed.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/signer_signing_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_signer_signing_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # platform_id (Required, Forces new resource)
  # 設定内容: ターゲット署名プロファイルが使用するプラットフォームIDを指定します。
  # 設定可能な値: "AWSLambda-SHA384-ECDSA" など、AWS SignerがサポートするプラットフォームID
  platform_id = "AWSLambda-SHA384-ECDSA"

  # name (Optional, Forces new resource)
  # 設定内容: 署名プロファイルの一意な名前を指定します。
  # 設定可能な値: 英数字・アンダースコア・ハイフンを含む任意の文字列
  # 省略時: Terraformが自動生成します（name_prefix と排他的）
  # 注意: 署名プロファイル名はキャンセル後に再利用できません
  name = null

  # name_prefix (Optional, Forces new resource)
  # 設定内容: 署名プロファイル名のプレフィックスを指定します。Terraformが一意なサフィックスを付与します。
  # 設定可能な値: 任意のプレフィックス文字列
  # 省略時: name を使用するか、Terraformが完全な名前を自動生成
  # 注意: name と排他的
  name_prefix = "example_sp_"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 署名有効期間設定
  #-------------------------------------------------------------

  # signature_validity_period (Optional, Forces new resource)
  # 設定内容: 署名ジョブの有効期間の設定ブロックです。
  # 関連機能: AWS Signer 署名有効期間
  #   署名が有効とみなされる期間を指定します。
  signature_validity_period {

    # value (Required, Forces new resource)
    # 設定内容: 署名有効期間の数値を指定します。
    # 設定可能な値: 正の整数
    value = 5

    # type (Required, Forces new resource)
    # 設定内容: 署名有効期間の時間単位を指定します。
    # 設定可能な値:
    #   - "DAYS": 日単位
    #   - "MONTHS": 月単位
    #   - "YEARS": 年単位
    type = "YEARS"
  }

  #-------------------------------------------------------------
  # 署名マテリアル設定
  #-------------------------------------------------------------

  # signing_material (Optional, Forces new resource)
  # 設定内容: コード署名に使用するAWS Certificate Manager証明書の設定ブロックです。
  # 関連機能: AWS Certificate Manager との統合
  #   ACMの証明書を使用してコードに署名します。
  signing_material {

    # certificate_arn (Required, Forces new resource)
    # 設定内容: コード署名に使用する証明書のARNを指定します。
    # 設定可能な値: 有効なACM証明書ARN
    certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/example-certificate-id"
  }

  #-------------------------------------------------------------
  # 署名パラメーター設定
  #-------------------------------------------------------------

  # signing_parameters (Optional, Forces new resource)
  # 設定内容: 署名時に使用するキーと値のパラメーターマップを指定します。
  # 設定可能な値: 文字列キーと文字列値のマップ
  # 省略時: パラメーターなし
  signing_parameters = {
    # "param_key" = "param_value"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: プロバイダーレベルの default_tags と一致するキーはプロバイダー定義を上書きします
  tags = {
    Name        = "example-signing-profile"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 署名プロファイルのARN
# - name: ターゲット署名プロファイルの名前
# - platform_display_name: 署名プロファイルに関連付けられた署名プラットフォームの表示名
# - status: ターゲット署名プロファイルのステータス
# - version: 署名プロファイルの現在のバージョン
# - version_arn: プロファイルバージョンを含む署名プロファイルのARN
# - revocation_record: 署名プロファイルの失効情報（revocation_effective_from, revoked_at, revoked_by）
# - tags_all: プロバイダーのdefault_tagsを含む全タグマップ
#---------------------------------------------------------------
