#---------------------------------------------------------------
# AWS SSO Instance Access Control Attributes
#---------------------------------------------------------------
#
# AWS IAM Identity Center（旧AWS SSO）のインスタンスに対して、
# 属性ベースのアクセス制御（ABAC）の設定をプロビジョニングするリソースです。
# ABACにより、ユーザー属性に基づいたきめ細かなアクセス制御ポリシーを作成できます。
#
# AWS公式ドキュメント:
#   - ABAC概要: https://docs.aws.amazon.com/singlesignon/latest/userguide/abac.html
#   - ABACの有効化と設定: https://docs.aws.amazon.com/singlesignon/latest/userguide/configure-abac.html
#   - ABACのアクセス制御属性: https://docs.aws.amazon.com/singlesignon/latest/userguide/attributesforaccesscontrol.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_instance_access_control_attributes
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssoadmin_instance_access_control_attributes" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # instance_arn (Required, Forces new resource)
  # 設定内容: IAM Identity Center（SSO）インスタンスのARNを指定します。
  # 設定可能な値: 有効なSSOインスタンスARN
  # 注意: data.aws_ssoadmin_instances で取得可能です。
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]

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
  # アクセス制御属性設定
  #-------------------------------------------------------------

  # attribute (Required)
  # 設定内容: ABACで使用するアクセス制御属性を定義します。
  # 複数のattributeブロックを指定可能です。
  # 関連機能: 属性ベースのアクセス制御（ABAC）
  #   ユーザーの属性（部署、役職、コストセンター等）をAWSリソースへの
  #   アクセス制御に使用できます。IAM ポリシーで aws:PrincipalTag 条件キーと
  #   組み合わせて使用します。
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/abac.html

  attribute {
    # key (Required)
    # 設定内容: IDソースの属性名を指定します。
    # AWS SSOの属性にマッピングされる、IDソース側の属性名です。
    # 設定可能な値: 任意の文字列（例: "name", "email", "department", "costCenter"）
    key = "name"

    # value (Required)
    # 設定内容: 属性のマッピング元となるIDソースの値を定義します。
    value {
      # source (Required)
      # 設定内容: 属性のマッピング元となるIDソースのパスを指定します。
      # 設定可能な値: IDソースのパス式のセット
      #   例: "${path:name.givenName}", "${path:name.familyName}",
      #       "${path:emails[primary eq true].value}", "${path:userName}"
      # 注意: SAML IDプロバイダーを使用している場合、SAMLアサーションの
      #       属性名を直接指定することも可能です。
      # 参考: https://docs.aws.amazon.com/singlesignon/latest/userguide/attributesforaccesscontrol.html
      source = ["$${path:name.givenName}"]
    }
  }

  attribute {
    key = "last"

    value {
      source = ["$${path:name.familyName}"]
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: インスタンスアクセス制御属性の識別子（instance_arnと同値）
#
# - status: ABACの設定状態
#
# - status_reason: ABACの設定状態の理由
#---------------------------------------------------------------
