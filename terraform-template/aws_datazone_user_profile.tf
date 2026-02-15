#---------------------------------------
# DataZone User Profile
#---------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-14
#
# NOTE:
# Amazon DataZoneのユーザープロファイルを作成・管理します。
# ユーザープロファイルは、DataZoneドメイン内でユーザーがプロジェクトやデータ資産にアクセスするための
# 権限とIDを定義します。IAMユーザー/ロール、またはSSOユーザーに対して作成できます。
#
# ユースケース:
# - DataZoneドメイン内でIAMユーザーまたはロールのアクセスを有効化
# - SSO統合されたユーザーのDataZoneアクセスを構成
# - ユーザーのプロファイルステータス（有効化/無効化）を管理
# - プロジェクトメンバーシップとデータアクセス権限の基盤を確立
#
# 制限事項と注意点:
# - user_identifierはIAMユーザー/ロールのARN、またはSSOユーザーIDを指定
# - user_typeはIAM_USER、IAM_ROLE、SSO_USERのいずれかを指定（省略時は自動判定）
# - statusはASSIGNED、NOT_ASSIGNED、ACTIVATED、DEACTIVATEDのいずれか
# - 同一ドメイン内で同じuser_identifierを持つプロファイルは1つのみ作成可能
# - プロファイル削除時は関連するプロジェクトメンバーシップも解除される
#
# 関連ドキュメント:
# https://docs.aws.amazon.com/datazone/latest/userguide/user-management-console.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/datazone_user_profile

#-------
# 基本設定
#-------

resource "aws_datazone_user_profile" "example" {
  # 必須パラメータ

  # 設定内容: DataZoneドメインの識別子
  # 補足: ユーザープロファイルを作成するDataZoneドメインのID
  # 形式: dzd-から始まる英数字の文字列
  domain_identifier = "dzd-example123456"

  # 設定内容: ユーザーの識別子
  # 補足: IAMユーザー/ロールの場合はARN、SSOユーザーの場合はSSOユーザーID
  # 形式: IAM ARN（arn:aws:iam::123456789012:user/example）またはSSOユーザーID
  user_identifier = "arn:aws:iam::123456789012:user/example-user"

  #-------
  # ユーザータイプとステータス設定
  #-------

  # 設定内容: ユーザーのタイプ
  # 設定可能な値: IAM_USER, IAM_ROLE, SSO_USER
  # 省略時: user_identifierから自動判定
  # 補足: IAMとSSOで管理方法が異なるため、明示的に指定することを推奨
  user_type = "IAM_USER"

  # 設定内容: ユーザープロファイルのステータス
  # 設定可能な値: ASSIGNED, NOT_ASSIGNED, ACTIVATED, DEACTIVATED
  # 省略時: ASSIGNED
  # 補足: ACTIVATEDはユーザーがDataZoneポータルにアクセス可能な状態
  status = "ACTIVATED"

  #-------
  # リージョン設定
  #-------

  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョン
  # 補足: マルチリージョン構成でドメインと異なるリージョンを指定する場合に使用
  region = "us-west-2"

  #-------
  # タイムアウト設定
  #-------

  # timeouts {
  #   # 設定内容: ユーザープロファイル作成のタイムアウト時間
  #   # 省略時: 30m
  #   # 形式: 数値と単位（s, m, h）の組み合わせ（例: "30m", "1h"）
  #   create = "30m"
  #
  #   # 設定内容: ユーザープロファイル更新のタイムアウト時間
  #   # 省略時: 30m
  #   # 形式: 数値と単位（s, m, h）の組み合わせ（例: "30m", "1h"）
  #   update = "30m"
  # }

  #-------
  # タグ設定（注意: このリソースはタグをサポートしていません）
  #-------
  # aws_datazone_user_profileはタグ付けをサポートしていません
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースでは以下の属性がエクスポートされます。
#
# id                   - ユーザープロファイルの識別子
# domain_identifier    - DataZoneドメインの識別子
# user_identifier      - ユーザーの識別子
# type                 - プロファイルタイプ（IAMまたはSSO）
# status               - ステータス（ASSIGNED、ACTIVATED等）
# region               - リソースのリージョン
# user_type            - ユーザータイプ（IAM_USER、IAM_ROLE、SSO_USER）
# details              - プロファイル詳細情報（IAM ARNまたはSSO情報を含む）
#   details[0].iam[0].arn         - IAMユーザー/ロールのARN
#   details[0].sso[0].user_name   - SSOユーザー名
#   details[0].sso[0].first_name  - SSOユーザーの名
#   details[0].sso[0].last_name   - SSOユーザーの姓
#
# 参照例:
# aws_datazone_user_profile.example.id
# aws_datazone_user_profile.example.type
# aws_datazone_user_profile.example.details[0].iam[0].arn
