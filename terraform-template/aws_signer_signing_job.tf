# aws_signer_signing_job
# AWS Signerの署名ジョブを管理するリソース
# S3上のコードアーティファクトに対して署名を実行し、署名済みオブジェクトを別のS3バケットに出力する
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/signer_signing_job
# NOTE: このリソースはApply時に署名ジョブを即時実行する。ジョブは一度実行すると変更不可のため、変更時は再作成が必要。
#
# Attributes Reference (25行以内):
# - id                   : 署名ジョブのID
# - job_id               : 署名ジョブのID
# - job_owner            : 署名ジョブの所有者のAWSアカウントID
# - job_invoker          : 署名ジョブを呼び出したIAMエンティティのARN
# - platform_id          : 署名プロファイルが使用するプラットフォームのID
# - platform_display_name: プラットフォームの表示名
# - profile_version      : 署名プロファイルのバージョン
# - requested_by         : ジョブをリクエストしたIAMエンティティのARN
# - created_at           : 署名ジョブの作成日時
# - completed_at         : 署名ジョブの完了日時
# - signature_expires_at : 署名の有効期限
# - status               : 署名ジョブのステータス (Succeeded / Failed / InProgress)
# - status_reason        : ステータスの詳細理由
# - revocation_record    : 失効レコード (reason / revoked_at / revoked_by)
# - signed_object        : 署名済みオブジェクトの情報 (s3.bucket / s3.key)

#---------------------------------------
# 署名ジョブ基本設定
#---------------------------------------
resource "aws_signer_signing_job" "example" {
  # 設定内容: 使用する署名プロファイルの名前
  # 設定可能な値: 既存の署名プロファイル名（文字列）
  profile_name = "example_signing_profile"

  # 設定内容: 署名ジョブの失敗を無視するかどうか
  # 設定可能な値: true（失敗を無視）/ false（失敗時にエラー）
  # 省略時: false
  ignore_signing_job_failure = false

  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョン
  region = "ap-northeast-1"

  #---------------------------------------
  # 署名元ソース設定（必須）
  #---------------------------------------
  source {
    s3 {
      # 設定内容: 署名対象オブジェクトが格納されているS3バケット名
      bucket = "source-bucket-name"

      # 設定内容: 署名対象オブジェクトのS3キー（パス）
      key = "path/to/unsigned/artifact.zip"

      # 設定内容: 署名対象オブジェクトのS3バージョンID
      version = "s3-object-version-id"
    }
  }

  #---------------------------------------
  # 署名先出力先設定（必須）
  #---------------------------------------
  destination {
    s3 {
      # 設定内容: 署名済みオブジェクトを出力するS3バケット名
      bucket = "destination-bucket-name"

      # 設定内容: 署名済みオブジェクトのS3キープレフィックス
      # 省略時: ルートに出力される
      # prefix = "signed/"
    }
  }
}
