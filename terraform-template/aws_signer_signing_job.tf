################################################################################
# AWS Signer Signing Job
################################################################################
#
# AWS Signerの署名ジョブを作成するリソースです。
# コード署名は、ソフトウェアの整合性と出所を検証するための重要なセキュリティメカニズムです。
#
# 【主な機能】
# - S3バケットに保存されたオブジェクト（Lambda関数、コンテナイメージなど）への署名
# - 署名済みオブジェクトの別のS3ロケーションへの保存
# - 署名ジョブのステータス追跡と監視
#
# 【ユースケース】
# - Lambda関数のコード署名による信頼性確保
# - コンテナイメージの署名と検証
# - CI/CDパイプラインでの自動コード署名
# - セキュリティコンプライアンス要件の充足
#
# 【重要な考慮事項】
# - ソースバケットとデスティネーションバケットは同じリージョンに配置する必要があります
# - ソースS3バケットはバージョニングを有効にする必要があります
# - 署名プロファイルは事前に作成しておく必要があります
# - 署名ジョブは非同期で実行され、完了までに時間がかかる場合があります
#
# 【セキュリティベストプラクティス】
# - 署名済みオブジェクトには適切なアクセス制御を設定してください
# - 署名プロファイルへのアクセスを最小限の権限に制限してください
# - CloudTrailで署名ジョブのアクティビティを監視してください
# - 署名の有効期限を適切に設定してください
#
# 【参考ドキュメント】
# - AWS Signer: https://docs.aws.amazon.com/signer/
# - Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/signer_signing_job
# - Lambda Code Signing: https://docs.aws.amazon.com/lambda/latest/dg/governance-code-signing.html
# - Well-Architected Framework Security: https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/
#
################################################################################

resource "aws_signer_signing_job" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 必須パラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # 署名プロファイル名
  # 署名操作を開始するための署名プロファイルの名前を指定します。
  #
  # 【重要】
  # - 署名プロファイルは事前に作成しておく必要があります
  # - プロファイルのプラットフォームID（例: AWSLambda-SHA384-ECDSA）が適切か確認してください
  # - プロファイルの有効期限が切れていないことを確認してください
  #
  # 【設定例】
  # - Lambda関数: aws_signer_signing_profile.lambda_profile.name
  # - コンテナ: aws_signer_signing_profile.container_profile.name
  profile_name = aws_signer_signing_profile.example.name

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ソース設定（必須）
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # 署名対象のオブジェクトが格納されているS3バケット
  #
  # 【前提条件】
  # - S3バケットはバージョニングが有効になっている必要があります
  # - バケットは署名プロファイルと同じリージョンに配置する必要があります
  # - 適切なIAM権限（s3:GetObject、s3:GetObjectVersion）が必要です
  #
  # 【セキュリティ考慮事項】
  # - ソースバケットへのアクセスを最小限の権限に制限してください
  # - バケットポリシーで暗号化を強制することを推奨します
  # - CloudTrailでバケットへのアクセスを監視してください
  source {
    s3 {
      # S3バケット名
      # 署名対象のオブジェクトが格納されているバケット名を指定します。
      #
      # 【注意】
      # - バケット名はグローバルに一意である必要があります
      # - バケットはバージョニングが有効になっている必要があります
      bucket = "my-source-bucket"

      # オブジェクトキー
      # 署名対象のオブジェクトのキー（パス）を指定します。
      #
      # 【設定例】
      # - Lambda関数: "lambda-functions/my-function.zip"
      # - レイヤー: "lambda-layers/my-layer.zip"
      # - コンテナイメージ: "container-images/my-image.tar"
      key = "unsigned-code/my-function.zip"

      # オブジェクトバージョン
      # バージョン有効化されたS3バケット内のオブジェクトバージョンIDを指定します。
      #
      # 【重要】
      # - バージョンIDは必須です
      # - 特定のバージョンを署名することで、署名の整合性を確保します
      # - 最新バージョンのIDを取得するにはaws_s3_object_versionデータソースを使用できます
      #
      # 【設定例】
      # - 固定バージョン: "3/L4kqtJlcpXroDTDmpUMLUo"
      # - 動的取得: data.aws_s3_object_version.source.version_id
      version = "abc123def456ghi789jkl012mno345pqr678"
    }
  }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # デスティネーション設定（必須）
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # 署名済みオブジェクトの保存先S3バケット
  #
  # 【要件】
  # - バケットは署名プロファイルと同じリージョンに配置する必要があります
  # - 適切なIAM権限（s3:PutObject）が必要です
  #
  # 【ベストプラクティス】
  # - 署名済みオブジェクト用に専用のバケットまたはプレフィックスを使用してください
  # - バケットポリシーで署名済みオブジェクトへのアクセスを制限してください
  # - バケットの暗号化を有効にしてください（SSE-S3またはSSE-KMS）
  destination {
    s3 {
      # S3バケット名
      # 署名済みオブジェクトを保存するバケット名を指定します。
      #
      # 【注意】
      # - ソースバケットと同じバケットを使用することも可能ですが、
      #   セキュリティとガバナンスの観点から、別のバケットまたは
      #   異なるプレフィックスの使用を推奨します
      bucket = "my-destination-bucket"

      # オブジェクトキープレフィックス（オプション）
      # 署名済みオブジェクトのキーの先頭に追加するプレフィックスを指定します。
      #
      # 【使用例】
      # - 環境別: "production/signed/" または "staging/signed/"
      # - 日付別: "signed/2024/01/"
      # - 機能別: "signed/lambda-functions/"
      #
      # 【注意】
      # - プレフィックスを指定しない場合、署名済みオブジェクトは
      #   元のキー名で保存されます
      # - プレフィックスは "/" で終わることを推奨します
      prefix = "signed/"
    }
  }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # オプション設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # 署名ジョブの失敗を無視
  # trueに設定すると、署名ジョブが失敗してもリソースの作成エラーとせず、
  # 失敗ステータスと理由を取得できるようにします。
  #
  # 【使用シーン】
  # - CI/CDパイプラインで署名ジョブの失敗を検知したい場合
  # - 署名エラーを手動で調査・修正したい場合
  # - 開発環境で署名の失敗を許容したい場合
  #
  # 【注意】
  # - デフォルトはfalseです
  # - trueに設定すると、署名が失敗してもTerraformはエラーを返しません
  # - status_reason属性で失敗理由を確認できます
  #
  # 【本番環境での推奨】
  # - 本番環境ではfalse（デフォルト）を使用し、
  #   署名の失敗を即座に検知することを推奨します
  ignore_signing_job_failure = false

  # リージョン設定（オプション）
  # このリソースが管理されるAWSリージョンを指定します。
  #
  # 【注意】
  # - 省略した場合、プロバイダー設定のリージョンが使用されます
  # - ソースバケット、デスティネーションバケット、署名プロファイルは
  #   すべて同じリージョンに配置する必要があります
  #
  # 【設定例】
  # region = "us-east-1"
}

################################################################################
# 出力値
################################################################################

# 署名ジョブID
# 署名ジョブの一意の識別子です。
# DescribeSigningJob APIなどで署名ジョブの詳細を取得する際に使用します。
output "signing_job_id" {
  description = "The ID of the signing job"
  value       = aws_signer_signing_job.example.job_id
}

# 署名ジョブのステータス
# 署名ジョブの現在の状態を示します。
#
# 【可能な値】
# - InProgress: 署名処理中
# - Failed: 署名失敗
# - Succeeded: 署名成功
output "signing_job_status" {
  description = "The status of the signing job (InProgress, Failed, or Succeeded)"
  value       = aws_signer_signing_job.example.status
}

# 署名ジョブのステータス理由
# 署名ジョブが失敗した場合の理由を示す文字列です。
# ignore_signing_job_failure = trueの場合に、失敗原因の調査に使用します。
output "signing_job_status_reason" {
  description = "The reason for the signing job status (useful when job fails)"
  value       = aws_signer_signing_job.example.status_reason
}

# 署名済みオブジェクト情報
# 署名が成功した場合の署名済みオブジェクトの情報です。
# S3バケット名とキーが含まれます。
output "signed_object" {
  description = "Information about the signed object in S3"
  value       = aws_signer_signing_job.example.signed_object
}

# 署名の有効期限
# 署名ジョブで生成された署名の有効期限をRFC3339形式で示します。
# この日時を過ぎると署名は無効となります。
output "signature_expires_at" {
  description = "The time when the signature expires (RFC3339 format)"
  value       = aws_signer_signing_job.example.signature_expires_at
}

# プラットフォームID
# 署名済みコードイメージが配布されるプラットフォームの識別子です。
#
# 【例】
# - AWSLambda-SHA384-ECDSA: Lambda関数用
# - AmazonFreeRTOS-Default: FreeRTOS用
# - AWSIoTDeviceManagement-SHA256-ECDSA: IoTデバイス用
output "platform_id" {
  description = "The platform to which the signed code image will be distributed"
  value       = aws_signer_signing_job.example.platform_id
}

# プラットフォーム表示名
# プラットフォームの人間が読める名前です。
output "platform_display_name" {
  description = "The human-readable name for the signing platform"
  value       = aws_signer_signing_job.example.platform_display_name
}

# 署名プロファイルバージョン
# 署名ジョブの開始に使用された署名プロファイルのバージョンです。
output "profile_version" {
  description = "The version of the signing profile used to initiate the signing job"
  value       = aws_signer_signing_job.example.profile_version
}

# ジョブ作成日時
# 署名ジョブが作成された日時（RFC3339形式）です。
output "created_at" {
  description = "The date and time when the signing job was created (RFC3339 format)"
  value       = aws_signer_signing_job.example.created_at
}

# ジョブ完了日時
# 署名ジョブが完了した日時（RFC3339形式）です。
output "completed_at" {
  description = "The date and time when the signing job was completed (RFC3339 format)"
  value       = aws_signer_signing_job.example.completed_at
}

# ジョブ所有者
# 署名ジョブを所有するAWSアカウントIDです。
output "job_owner" {
  description = "The AWS account ID of the job owner"
  value       = aws_signer_signing_job.example.job_owner
}

# ジョブ起動者
# 署名ジョブを開始したIAMエンティティ（ユーザーまたはロール）です。
output "job_invoker" {
  description = "The IAM entity that initiated the signing job"
  value       = aws_signer_signing_job.example.job_invoker
}

# リクエスト元
# 署名ジョブをリクエストしたIAMプリンシパルです。
output "requested_by" {
  description = "The IAM principal that requested the signing job"
  value       = aws_signer_signing_job.example.requested_by
}

# 失効レコード
# 署名ジョブで生成された署名が失効している場合の情報です。
# タイムスタンプと署名を失効させたIAMエンティティのIDが含まれます。
output "revocation_record" {
  description = "Revocation record if the signature has been revoked (includes timestamp and IAM entity ID)"
  value       = aws_signer_signing_job.example.revocation_record
}

################################################################################
# 使用例: Lambda関数の署名
################################################################################

# Lambda関数用の署名プロファイル
resource "aws_signer_signing_profile" "lambda_profile" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  name        = "lambda-signing-profile"

  signature_validity_period {
    value = 5
    type  = "YEARS"
  }

  tags = {
    Environment = "Production"
    Purpose     = "Lambda Code Signing"
  }
}

# Lambda関数コードの署名ジョブ
resource "aws_signer_signing_job" "lambda_function" {
  profile_name = aws_signer_signing_profile.lambda_profile.name

  source {
    s3 {
      bucket  = "my-lambda-code-bucket"
      key     = "functions/my-function.zip"
      version = data.aws_s3_object_version.lambda_source.version_id
    }
  }

  destination {
    s3 {
      bucket = "my-lambda-signed-code-bucket"
      prefix = "signed/functions/"
    }
  }

  ignore_signing_job_failure = false
}

# ソースオブジェクトのバージョンID取得
data "aws_s3_object_version" "lambda_source" {
  bucket = "my-lambda-code-bucket"
  key    = "functions/my-function.zip"
}

################################################################################
# 使用例: CI/CDパイプラインでの自動署名
################################################################################

# CI/CD用の署名ジョブ（失敗を検知して処理）
resource "aws_signer_signing_job" "cicd_signing" {
  profile_name = aws_signer_signing_profile.lambda_profile.name

  source {
    s3 {
      bucket  = "cicd-artifacts-bucket"
      key     = "builds/${var.build_id}/application.zip"
      version = var.source_version_id
    }
  }

  destination {
    s3 {
      bucket = "cicd-signed-artifacts-bucket"
      prefix = "signed/${var.environment}/"
    }
  }

  # CI/CDパイプラインで失敗を検知できるようにする
  ignore_signing_job_failure = true
}

# 署名ジョブの失敗を検出するカスタムロジック
resource "null_resource" "check_signing_status" {
  triggers = {
    job_id = aws_signer_signing_job.cicd_signing.job_id
    status = aws_signer_signing_job.cicd_signing.status
  }

  provisioner "local-exec" {
    command = <<-EOT
      if [ "${aws_signer_signing_job.cicd_signing.status}" = "Failed" ]; then
        echo "Signing job failed: ${aws_signer_signing_job.cicd_signing.status_reason}"
        exit 1
      fi
    EOT
  }
}

################################################################################
# 注意事項とベストプラクティス
################################################################################

# 1. バージョニングの有効化
#    ソースS3バケットでは必ずバージョニングを有効にしてください。
#
#    resource "aws_s3_bucket_versioning" "source" {
#      bucket = aws_s3_bucket.source.id
#      versioning_configuration {
#        status = "Enabled"
#      }
#    }

# 2. IAM権限
#    署名ジョブを実行するには以下の権限が必要です：
#    - signer:StartSigningJob
#    - s3:GetObject (ソースバケット)
#    - s3:GetObjectVersion (ソースバケット)
#    - s3:PutObject (デスティネーションバケット)

# 3. リージョンの整合性
#    署名プロファイル、ソースバケット、デスティネーションバケットは
#    すべて同じリージョンに配置する必要があります。

# 4. 署名の有効期限
#    署名プロファイルで設定した有効期限に注意してください。
#    有効期限が切れた署名は無効となります。

# 5. CloudTrailでの監視
#    署名ジョブのアクティビティをCloudTrailで監視し、
#    不正な署名操作を検出してください。

# 6. コスト最適化
#    署名ジョブには料金が発生します。
#    不要な署名ジョブの実行を避けるため、
#    CI/CDパイプラインでの実行タイミングを最適化してください。

# 7. 非同期処理
#    署名ジョブは非同期で実行されます。
#    Terraformはジョブの完了を待ちますが、
#    大きなファイルの署名には時間がかかる場合があります。

# 8. エラーハンドリング
#    ignore_signing_job_failure = trueを使用する場合は、
#    status_reason属性を確認して適切なエラーハンドリングを実装してください。
