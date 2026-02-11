#---------------------------------------------------------------
# AWS Secrets Manager Secret Rotation
#---------------------------------------------------------------
#
# AWS Secrets Manager のシークレットに対する自動ローテーション設定を管理するリソースです。
# シークレットのローテーションは、セキュリティベストプラクティスとして定期的な認証情報の
# 更新を自動化します。ローテーションには Lambda 関数が必要で、AWS 管理のテンプレートまたは
# カスタム実装が利用可能です。
#
# ローテーション戦略:
#   1. 単一ユーザー戦略: 既存のユーザー認証情報を更新
#   2. 交互ユーザー戦略: 2つのユーザーを交互に使用し、ダウンタイムなしでローテーション
#
# ローテーションプロセス (4ステップ):
#   1. createSecret: 新しいシークレット値を生成し AWSPENDING ラベルを付与
#   2. setSecret: データベース/サービスの認証情報を新しい値に変更
#   3. testSecret: 新しい認証情報でアクセスをテスト
#   4. finishSecret: AWSCURRENT ラベルを新バージョンに移動
#
# AWS公式ドキュメント:
#   - Secrets Manager ローテーション概要: https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
#   - Lambda ローテーション関数: https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotate-secrets_lambda.html
#   - ローテーション設定 (CLI): https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotate-secrets_turn-on-cli.html
#   - ローテーション関数テンプレート: https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_available-rotation-templates.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_secretsmanager_secret_rotation" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # secret_id (Required)
  # 設定内容: ローテーションを追加するシークレットを指定します。
  # 設定可能な値:
  #   - シークレットの Amazon Resource Name (ARN)
  #   - シークレットのフレンドリー名
  # 注意: シークレットは既に存在している必要があります
  # 関連機能: AWS Secrets Manager シークレット
  #   シークレットは aws_secretsmanager_secret リソースで事前に作成。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_create-basic-secret.html
  secret_id = "example-secret"

  # rotate_immediately (Optional)
  # 設定内容: シークレットを即座にローテーションするか、次のスケジュールされた
  #           ローテーションウィンドウまで待機するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 即座にローテーションを実行
  #   - false: 次のスケジュールまで待機。Lambda ローテーション関数の testSecret
  #           ステップによるテストのみ実行
  # 用途: 初回設定時の動作制御
  # 関連機能: ローテーションテスト
  #   rotate_immediately = false の場合、AWSPENDING バージョンを作成してテスト後に削除。
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotate-secrets_how.html
  rotate_immediately = true

  # rotation_lambda_arn (Optional)
  # 設定内容: シークレットをローテーションできる Lambda 関数の ARN を指定します。
  # 設定可能な値: Lambda 関数の有効な ARN
  # 注意:
  #   - AWS 管理シークレット (RDS等) 以外では必須
  #   - Lambda 関数には Secrets Manager と対象サービスへのアクセス権限が必要
  #   - Lambda リソースポリシーで Secrets Manager からの呼び出しを許可する必要あり
  # 関連機能: Lambda ローテーション関数
  #   AWS提供のテンプレート、またはカスタム実装が利用可能。
  #   データベース種類別テンプレート: RDS MySQL, RDS PostgreSQL, RDS Oracle, etc.
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_available-rotation-templates.html
  #   - https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotate-secrets_lambda-functions.html
  rotation_lambda_arn = "arn:aws:lambda:ap-northeast-1:123456789012:function:example-rotation-function"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ローテーションルール設定
  #-------------------------------------------------------------

  # rotation_rules (Required)
  # 設定内容: このシークレットのローテーション設定を定義します。
  # 注意: automatically_after_days または schedule_expression のいずれかが必須
  rotation_rules {
    # automatically_after_days (Optional)
    # 設定内容: シークレットの自動スケジュールローテーション間隔を日数で指定します。
    # 設定可能な値: 1 以上の整数 (日数)
    # 注意:
    #   - schedule_expression との併用不可 (どちらか一方が必須)
    #   - 最小値は実質的に 1日 (ただしコスト・パフォーマンス考慮が必要)
    #   - 一般的な推奨値: 30日、60日、90日
  # 注意事項とベストプラクティス
  #-------------------------------------------------------------
  # 1. Lambda 関数の権限設定
  #    - Lambda 実行ロールに以下の権限が必要:
  #      * secretsmanager:DescribeSecret
  #      * secretsmanager:GetSecretValue
  #      * secretsmanager:PutSecretValue
  #      * secretsmanager:UpdateSecretVersionStage
  #    - Lambda リソースポリシーで secretsmanager.amazonaws.com からの
  #      lambda:InvokeFunction を許可
  #
  # 2. ネットワーク設定
  #    - Lambda 関数は以下にアクセスできる必要あり:
  #      * Secrets Manager エンドポイント (VPC エンドポイントまたはNAT経由)
  #      * ローテーション対象のデータベース/サービス
  #    - VPC 内の Lambda の場合、VPC エンドポイント推奨
  #
  # 3. ローテーション戦略の選択
  #    - 単一ユーザー: シンプルだが短時間のダウンタイム発生
  #    - 交互ユーザー: ダウンタイムゼロだが設定が複雑
  #
  # 4. テストとモニタリング
  #    - CloudWatch Logs で Lambda 関数のログを確認
  #    - CloudWatch Metrics で RotationAttempt, RotationSuccess を監視
  #    - EventBridge で ローテーション失敗イベントをキャッチ
  #
  # 5. 交互ユーザー戦略の場合
  #    - マスターシークレット (superuser credentials) を別途作成
  #    - 元のシークレットにマスターシークレットのARNを追加
  #      (SecretStringの一部として)
  #
  # 参考:
  #   - ローテーションのトラブルシューティング:
  #     https://docs.aws.amazon.com/secretsmanager/latest/userguide/troubleshoot_rotation.html
  #   - ローテーション用 Lambda のサンプル:
  #     https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: シークレットの Amazon Resource Name (ARN)
#
# - arn: シークレットの Amazon Resource Name (ARN)
#
# - rotation_enabled: このシークレットで自動ローテーションが有効か
#   どうかを示すブール値 (true/false)
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は RDS MySQL データベースの認証情報をローテーションする例です:
#
# # 1. シークレットの作成
# resource "aws_secretsmanager_secret" "db_credentials" {
#   name                    = "production/db/credentials"
#   description             = "RDS MySQL database credentials"
#   recovery_window_in_days = 7
# }
#
# resource "aws_secretsmanager_secret_version" "db_credentials" {
#---------------------------------------------------------------
