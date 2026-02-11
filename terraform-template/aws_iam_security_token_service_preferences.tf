#---------------------------------------------------------------
# AWS IAM Security Token Service Preferences
#---------------------------------------------------------------
#
# AWS Security Token Service (STS) のグローバルエンドポイントで発行される
# セッショントークンのバージョンを設定するリソースです。
#
# AWS STS はデフォルトでグローバルエンドポイント (https://sts.amazonaws.com) を
# 提供しますが、AWSではレイテンシーの削減、冗長性の向上、セッショントークンの
# 有効性向上のため、リージョナルエンドポイントの使用を推奨しています。
#
# グローバルエンドポイントから発行されるセッショントークンには2つのバージョンがあります:
#   - v1Token: デフォルトで有効なAWSリージョンでのみ有効。
#              手動で有効化したリージョン（例: アジアパシフィック（香港））では使用不可。
#   - v2Token: すべてのAWSリージョンで有効。
#              ただしトークン文字列が長くなるため、トークンを一時保存する
#              システムに影響を与える可能性があります。
#
# AWS公式ドキュメント:
#   - STS リージョン管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_enable-regions.html
#   - SetSecurityTokenServicePreferences API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_SetSecurityTokenServicePreferences.html
#   - STS エンドポイントとクォータ: https://docs.aws.amazon.com/general/latest/gr/sts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_security_token_service_preferences
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_security_token_service_preferences" "example" {
  #-------------------------------------------------------------
  # グローバルエンドポイントトークンバージョン設定 (Required)
  #-------------------------------------------------------------

  # global_endpoint_token_version (Required)
  # 設定内容: グローバルエンドポイント (https://sts.amazonaws.com) から
  #           発行されるセッショントークンのバージョンを指定します。
  # 設定可能な値:
  #   - "v1Token": バージョン1トークン
  #                デフォルトで有効なAWSリージョンでのみ有効です。
  #                手動で有効化が必要なリージョン（アジアパシフィック（香港）、
  #                中東（バーレーン）等のオプトインリージョン）では使用できません。
  #   - "v2Token": バージョン2トークン
  #                すべてのAWSリージョンで有効です。
  #                ただし、v1Tokenよりも文字列が長くなるため、
  #                トークンを一時的に保存するシステムに影響する可能性があります。
  # 推奨事項: オプトインリージョンを使用する場合や、将来的にリージョンを
  #           追加する可能性がある場合は "v2Token" を設定してください。
  #           AWSリージョナルSTSエンドポイントを使用している場合、
  #           リージョナルエンドポイントのトークンはこの設定に関係なく
  #           すべてのリージョンで有効です。
  # 注意: この設定はAWSアカウント全体に影響します。
  #       既存のシステムでトークン長に依存した処理がある場合、
  #       v2Tokenへの変更前に影響を確認してください。
  # 関連API: iam:SetSecurityTokenServicePreferences
  #   - https://docs.aws.amazon.com/IAM/latest/APIReference/API_SetSecurityTokenServicePreferences.html
  global_endpoint_token_version = "v2Token"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWSアカウントID
#       このリソースはAWSアカウント単位の設定であるため、
#       アカウントIDが識別子として使用されます。
#---------------------------------------------------------------
