################################################################################
# AWS Glue Security Configuration
# Terraform Resource: aws_glue_security_configuration
# AWS Provider Version: 6.28.0
#
# リソース概要:
# AWS Glue のセキュリティ設定を管理します。このリソースは、クローラー、ETLジョブ、
# 開発エンドポイントで使用される暗号化プロパティを含むセキュリティ設定を定義します。
# データカタログ、CloudWatch Logs、S3データ、ジョブブックマークに対して
# 暗号化設定を構成できます。
#
# ユースケース:
# - ETLジョブのデータ保護: AWS Glue ETLジョブで処理されるデータの暗号化
# - コンプライアンス要件: GDPR、HIPAA等の規制要件を満たすための暗号化設定
# - ログの保護: CloudWatch Logsに出力されるログデータの暗号化
# - ジョブブックマークの保護: ジョブの進行状況を追跡するブックマークデータの暗号化
# - マルチレイヤーセキュリティ: S3、CloudWatch、ブックマークそれぞれに異なる暗号化設定
#
# 注意事項:
# - セキュリティ設定の名前は一意である必要があります
# - KMS暗号化を使用する場合、適切なIAMロールにKMS権限が必要です
# - AWS Glueは対称カスタマーマスターキー（CMK）のみをサポートします
# - VPC内でKMSを使用する場合、VPCエンドポイントの作成が必要な場合があります
# - 暗号化されたデータにアクセスするクライアントには、適切なKMS権限が必要です
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/glue/latest/dg/console-security-configurations.html
# https://docs.aws.amazon.com/glue/latest/dg/set-up-encryption.html
################################################################################

resource "aws_glue_security_configuration" "example" {
  # ============================================================================
  # 基本設定
  # ============================================================================

  # name - (必須) セキュリティ設定の名前
  #
  # 説明:
  # セキュリティ設定を識別するための一意の名前を指定します。
  # この名前は、Glueジョブやクローラーにセキュリティ設定をアタッチする際に使用されます。
  #
  # 要件:
  # - アカウント内で一意である必要があります
  # - 最大255文字まで指定可能
  # - 英数字、ハイフン、アンダースコアを使用できます
  #
  # 推奨事項:
  # - 環境名やプロジェクト名を含めることで識別しやすくなります
  # - 命名規則: <環境>-<プロジェクト名>-glue-security-config
  # - 例: "prod-data-pipeline-glue-security-config"
  #
  # セキュリティ考慮事項:
  # - 設定名から機密情報が推測されないよう注意してください
  #
  # タイプ: string
  # デフォルト: なし
  name = "example-glue-security-config"

  # ============================================================================
  # 暗号化設定
  # ============================================================================

  # encryption_configuration - (必須) 暗号化設定を含む設定ブロック
  #
  # 説明:
  # AWS Glueが扱うデータの暗号化方法を定義します。
  # CloudWatch Logs、ジョブブックマーク、S3データに対して
  # それぞれ独立した暗号化設定を構成できます。
  #
  # 構成要素:
  # - cloudwatch_encryption: CloudWatch Logsの暗号化設定
  # - job_bookmarks_encryption: ジョブブックマークの暗号化設定
  # - s3_encryption: S3データの暗号化設定
  #
  # ベストプラクティス:
  # - 本番環境では全ての暗号化を有効化することを推奨します
  # - 開発環境ではコスト削減のため一部の暗号化を無効化することも検討できます
  # - KMSキーの管理コストとセキュリティ要件のバランスを考慮してください
  #
  # 注意事項:
  # - すべての子ブロック（cloudwatch_encryption、job_bookmarks_encryption、s3_encryption）は必須です
  # - 暗号化を無効にする場合でも、ブロック自体は定義する必要があります
  #
  # タイプ: block
  # デフォルト: なし
  encryption_configuration {

    # ==========================================================================
    # CloudWatch暗号化設定
    # ==========================================================================

    # cloudwatch_encryption - (必須) CloudWatch Logsの暗号化設定ブロック
    #
    # 説明:
    # AWS Glueジョブが出力するCloudWatch Logsの暗号化方法を定義します。
    # ETLジョブの実行ログ、エラーログ、診断情報などが対象となります。
    #
    # ユースケース:
    # - コンプライアンス要件でログデータの暗号化が必要な場合
    # - ログに機密情報が含まれる可能性がある場合
    # - 監査要件でログの完全性保護が必要な場合
    #
    # セキュリティ考慮事項:
    # - KMS暗号化を使用する場合、CloudWatch Logsサービスに適切なKMS権限が必要です
    # - IAMロールにcloudwatch:PutLogEvents権限とKMS暗号化/復号権限が必要です
    #
    # コスト考慮事項:
    # - SSE-KMSを使用する場合、KMS APIコール料金が発生します
    # - 大量のログを出力するジョブでは、コストが増加する可能性があります
    #
    # タイプ: block
    # デフォルト: なし
    cloudwatch_encryption {

      # cloudwatch_encryption_mode - (オプション) CloudWatch Logsの暗号化モード
      #
      # 説明:
      # CloudWatch Logsに書き込まれるデータの暗号化方法を指定します。
      #
      # 有効な値:
      # - "DISABLED": 暗号化を無効化（デフォルト）
      #   - ログは暗号化されずにCloudWatch Logsに保存されます
      #   - 開発環境やテスト環境で使用を検討できます
      #   - KMSコストが発生しません
      #
      # - "SSE-KMS": AWS KMS暗号化を使用
      #   - kms_key_arnで指定したKMSキーを使用してログを暗号化します
      #   - 本番環境やコンプライアンス要件がある場合に推奨します
      #   - ログの書き込み時と読み取り時にKMS APIコールが発生します
      #   - KMSキーポリシーでCloudWatch Logsサービスに権限を付与する必要があります
      #
      # IAM権限要件（SSE-KMS使用時）:
      # - kms:Decrypt: ログを読み取る際に必要
      # - kms:Encrypt: ログを書き込む際に必要
      # - kms:GenerateDataKey: データキーの生成に必要
      # - kms:CreateGrant: CloudWatch Logsサービスに必要
      #
      # ベストプラクティス:
      # - 本番環境では"SSE-KMS"を使用してください
      # - 開発環境では"DISABLED"でコスト削減も検討できます
      # - カスタマーマネージドキーを使用する場合、キーのローテーションを有効化してください
      #
      # タイプ: string
      # デフォルト: "DISABLED"
      cloudwatch_encryption_mode = "SSE-KMS"

      # kms_key_arn - (オプション) 暗号化に使用するKMSキーのARN
      #
      # 説明:
      # CloudWatch Logsデータの暗号化に使用するAWS KMSキーのAmazon Resource Name（ARN）を指定します。
      # cloudwatch_encryption_modeが"SSE-KMS"の場合に必要です。
      #
      # フォーマット:
      # - arn:aws:kms:<region>:<account-id>:key/<key-id>
      # - 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      #
      # キーの種類:
      # - カスタマーマネージドキー（推奨）:
      #   - 完全な制御と監査が可能です
      #   - キーポリシーで詳細なアクセス制御ができます
      #   - 自動キーローテーションを有効化できます
      #
      # - AWSマネージドキー（aws/glue）:
      #   - AWS Glueサービスが管理するデフォルトキーです
      #   - キーポリシーのカスタマイズはできません
      #   - 追加のKMS料金は発生しません
      #
      # キーポリシー要件:
      # - Glueジョブに使用するIAMロールに以下の権限を付与:
      #   {
      #     "Effect": "Allow",
      #     "Principal": {
      #       "Service": "logs.amazonaws.com"
      #     },
      #     "Action": [
      #       "kms:Encrypt",
      #       "kms:Decrypt",
      #       "kms:ReEncrypt*",
      #       "kms:GenerateDataKey*",
      #       "kms:CreateGrant",
      #       "kms:DescribeKey"
      #     ],
      #     "Resource": "*",
      #     "Condition": {
      #       "ArnLike": {
      #         "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:<region>:<account-id>:*"
      #       }
      #     }
      #   }
      #
      # セキュリティ考慮事項:
      # - キーポリシーで最小権限の原則を適用してください
      # - キーの削除には30日間の待機期間を設定してください
      # - CloudTrailでKMSキーの使用状況を監視してください
      #
      # 運用考慮事項:
      # - KMSキーは使用前に有効化されている必要があります
      # - マルチリージョン展開の場合、各リージョンでキーを作成するか、マルチリージョンキーを使用してください
      # - キーのエイリアスを使用すると管理が容易になります
      #
      # 注意事項:
      # - cloudwatch_encryption_modeが"DISABLED"の場合、この値は無視されます
      # - VPC内でGlueを実行する場合、VPCエンドポイント経由でKMSにアクセスできることを確認してください
      #
      # タイプ: string
      # デフォルト: なし
      kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }

    # ==========================================================================
    # ジョブブックマーク暗号化設定
    # ==========================================================================

    # job_bookmarks_encryption - (必須) ジョブブックマークの暗号化設定ブロック
    #
    # 説明:
    # AWS Glueジョブブックマークデータの暗号化方法を定義します。
    # ジョブブックマークは、ETLジョブが処理済みのデータを追跡するために使用される
    # メタデータで、増分処理を実現するために重要です。
    #
    # ジョブブックマークとは:
    # - ETLジョブの実行状態と進行状況を保存します
    # - 前回の実行で処理したデータの位置を記録します
    # - 増分データ処理を可能にし、重複処理を防ぎます
    # - S3のオブジェクト、データベースのタイムスタンプなどを追跡します
    #
    # ユースケース:
    # - 増分データ処理を行うETLジョブでジョブブックマークを使用する場合
    # - コンプライアンス要件でメタデータの暗号化が必要な場合
    # - ジョブブックマークに機密情報が含まれる可能性がある場合
    #
    # セキュリティ考慮事項:
    # - ジョブブックマークにはデータソースのパスやキー情報が含まれる可能性があります
    # - 本番環境では暗号化を有効化することを推奨します
    # - KMS暗号化を使用する場合、Glueサービスロールに適切なKMS権限が必要です
    #
    # パフォーマンス考慮事項:
    # - ジョブブックマークの読み書きは頻繁に発生するため、KMS APIコール数が増加します
    # - CSE-KMSはクライアント側暗号化のため、追加のレイテンシが発生する可能性があります
    #
    # タイプ: block
    # デフォルト: なし
    job_bookmarks_encryption {

      # job_bookmarks_encryption_mode - (オプション) ジョブブックマークの暗号化モード
      #
      # 説明:
      # ジョブブックマークデータの暗号化方法を指定します。
      #
      # 有効な値:
      # - "DISABLED": 暗号化を無効化（デフォルト）
      #   - ジョブブックマークは暗号化されずに保存されます
      #   - 開発環境やテスト環境で使用を検討できます
      #   - KMSコストが発生しません
      #   - セキュリティ要件が低い環境に適しています
      #
      # - "CSE-KMS": クライアント側暗号化（Client-Side Encryption with KMS）
      #   - kms_key_arnで指定したKMSキーを使用してクライアント側で暗号化します
      #   - Glueサービスがデータを暗号化してから保存します
      #   - 本番環境やコンプライアンス要件がある場合に推奨します
      #   - エンドツーエンドの暗号化が提供されます
      #   - データはAWS Glueサービス内でのみ復号化されます
      #
      # CSE-KMSの特徴:
      # - クライアント（Glueサービス）側で暗号化/復号化を実行します
      # - データはネットワーク転送中も暗号化されたままです
      # - より高いセキュリティレベルを提供します
      # - サーバー側暗号化（SSE）よりも強力な保護を提供します
      #
      # IAM権限要件（CSE-KMS使用時）:
      # Glueジョブに使用するIAMロールに以下の権限が必要です:
      # - kms:Decrypt: ジョブブックマークを読み取る際に必要
      # - kms:Encrypt: ジョブブックマークを書き込む際に必要
      # - kms:GenerateDataKey: データキーの生成に必要
      # - kms:DescribeKey: キー情報の取得に必要
      #
      # ベストプラクティス:
      # - 本番環境では"CSE-KMS"を使用してください
      # - 開発環境では"DISABLED"でコスト削減も検討できます
      # - 増分処理を使用するETLジョブでは暗号化を有効化してください
      # - 規制対象データを扱う場合は暗号化が必須です
      #
      # 注意事項:
      # - S3暗号化やCloudWatch暗号化とは独立した設定です
      # - 暗号化を有効化した後、既存のジョブブックマークは再暗号化されません
      # - KMSキーを削除すると、ジョブブックマークにアクセスできなくなります
      #
      # タイプ: string
      # デフォルト: "DISABLED"
      job_bookmarks_encryption_mode = "CSE-KMS"

      # kms_key_arn - (オプション) 暗号化に使用するKMSキーのARN
      #
      # 説明:
      # ジョブブックマークデータの暗号化に使用するAWS KMSキーのAmazon Resource Name（ARN）を指定します。
      # job_bookmarks_encryption_modeが"CSE-KMS"の場合に必要です。
      #
      # フォーマット:
      # - arn:aws:kms:<region>:<account-id>:key/<key-id>
      # - 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      #
      # キーの選択:
      # - CloudWatch、S3と同じキーを使用することも、別のキーを使用することも可能です
      # - 同じキーを使用する場合:
      #   - 管理が簡素化されます
      #   - KMSコストが削減される可能性があります
      #   - キーポリシーの管理が容易になります
      #
      # - 異なるキーを使用する場合:
      #   - より細かいアクセス制御が可能です
      #   - セキュリティ境界を分離できます
      #   - 監査トレイルが明確になります
      #
      # キーポリシー要件:
      # Glueジョブに使用するIAMロールに以下の権限を付与:
      #   {
      #     "Effect": "Allow",
      #     "Principal": {
      #       "AWS": "arn:aws:iam::<account-id>:role/<glue-job-role>"
      #     },
      #     "Action": [
      #       "kms:Decrypt",
      #       "kms:Encrypt",
      #       "kms:GenerateDataKey",
      #       "kms:DescribeKey"
      #     ],
      #     "Resource": "*"
      #   }
      #
      # セキュリティ考慮事項:
      # - キーへのアクセスを必要最小限のIAMロールに制限してください
      # - キーポリシーとIAMポリシーの両方でアクセス制御を実装してください
      # - CloudTrailでKMSキーの使用状況を監視してください
      # - 定期的にキーのアクセスパターンをレビューしてください
      #
      # 運用考慮事項:
      # - KMSキーは使用前に有効化されている必要があります
      # - キーのエイリアスを使用すると、キーのローテーション時に設定変更が不要です
      # - マルチリージョン展開の場合、レプリケーションを考慮してください
      # - キーの削除には30日間の待機期間を設定してください
      #
      # トラブルシューティング:
      # - "Access Denied"エラーが発生する場合、IAMロールとキーポリシーを確認してください
      # - VPC内でGlueを実行する場合、VPCエンドポイント経由でKMSにアクセスできることを確認してください
      # - キーが無効化されている場合、ジョブが失敗します
      #
      # 注意事項:
      # - job_bookmarks_encryption_modeが"DISABLED"の場合、この値は無視されます
      # - AWS Glueは対称カスタマーマスターキー（CMK）のみをサポートします
      # - 非対称キーは使用できません
      #
      # タイプ: string
      # デフォルト: なし
      kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }

    # ==========================================================================
    # S3暗号化設定
    # ==========================================================================

    # s3_encryption - (必須) S3データの暗号化設定ブロック
    #
    # 説明:
    # AWS GlueジョブがS3に書き込むデータの暗号化方法を定義します。
    # ETLジョブの出力データ、クローラーが検出したデータなどが対象となります。
    #
    # 対象となるデータ:
    # - ETLジョブの出力データ（変換後のデータ）
    # - 中間データ（一時的な処理結果）
    # - クローラーが作成するメタデータ
    # - データカタログのパーティション情報
    #
    # ユースケース:
    # - データレイクの構築: S3に保存される大量のデータを暗号化
    # - コンプライアンス対応: GDPR、HIPAA、PCI DSSなどの要件を満たす
    # - データの機密性保護: 個人情報や機密ビジネスデータの保護
    # - マルチテナント環境: テナントごとに異なる暗号化キーを使用
    #
    # セキュリティ考慮事項:
    # - S3バケット自体の暗号化設定とは独立しています
    # - Glueジョブの出力に対してのみ適用されます
    # - 既存のS3オブジェクトには影響しません
    # - KMS暗号化を使用する場合、S3サービスとGlueサービスの両方にKMS権限が必要です
    #
    # タイプ: block
    # デフォルト: なし
    s3_encryption {

      # s3_encryption_mode - (オプション) S3データの暗号化モード
      #
      # 説明:
      # AWS GlueがS3に書き込むデータの暗号化方法を指定します。
      #
      # 有効な値:
      # - "DISABLED": 暗号化を無効化（デフォルト）
      #   - データは暗号化されずにS3に保存されます
      #   - S3バケットのデフォルト暗号化設定が適用される場合があります
      #   - 開発環境やパブリックデータで使用を検討できます
      #   - KMSコストが発生しません
      #
      # - "SSE-KMS": サーバー側暗号化（Server-Side Encryption with KMS）
      #   - kms_key_arnで指定したKMSキーを使用してS3側で暗号化します
      #   - 本番環境で推奨される暗号化方式です
      #   - データはS3に到達した時点で暗号化されます
      #   - 詳細なアクセス制御と監査が可能です
      #   - KMS APIコール料金が発生します
      #   - きめ細かいアクセス制御とキーローテーションをサポートします
      #
      # - "SSE-S3": サーバー側暗号化（Server-Side Encryption with S3-Managed Keys）
      #   - S3が管理するキーを使用して暗号化します
      #   - AES-256暗号化アルゴリズムを使用します
      #   - kms_key_arnの指定は不要です
      #   - 追加のKMS料金は発生しません
      #   - 基本的な暗号化要件を満たす場合に適しています
      #   - キーの管理がS3サービスに委譲されます
      #   - 詳細なアクセス制御はできません
      #
      # 暗号化方式の比較:
      #
      # SSE-KMS（推奨）:
      # メリット:
      #   - 詳細なアクセス制御が可能（キーポリシー、IAMポリシー）
      #   - CloudTrailで暗号化/復号化操作を監査可能
      #   - 自動キーローテーションをサポート
      #   - マルチリージョンキーを使用可能
      #   - クロスアカウントアクセスの制御が容易
      # デメリット:
      #   - KMS APIコール料金が発生（月額$1 per key + $0.03/10,000 requests）
      #   - レイテンシがわずかに増加
      #   - 追加のIAM権限設定が必要
      #
      # SSE-S3:
      # メリット:
      #   - 追加コストなし
      #   - 設定が簡単
      #   - パフォーマンスへの影響が最小限
      #   - S3が自動的にキーを管理
      # デメリット:
      #   - 詳細なアクセス制御ができない
      #   - 監査トレイルが限定的
      #   - キーローテーションの制御ができない
      #   - クロスアカウントアクセスの制御が困難
      #
      # DISABLED:
      # メリット:
      #   - コストが最も低い
      #   - 設定が不要
      # デメリット:
      #   - データが暗号化されない（S3バケットのデフォルト暗号化に依存）
      #   - コンプライアンス要件を満たさない可能性がある
      #
      # IAM権限要件（SSE-KMS使用時）:
      # Glueジョブに使用するIAMロールに以下の権限が必要です:
      # - s3:PutObject: オブジェクトの書き込み
      # - kms:Encrypt: データの暗号化
      # - kms:GenerateDataKey: データキーの生成
      # - kms:DescribeKey: キー情報の取得
      #
      # データを読み取る側（データ消費者）に必要な権限:
      # - s3:GetObject: オブジェクトの読み取り
      # - kms:Decrypt: データの復号化
      #
      # ベストプラクティス:
      # - 本番環境では"SSE-KMS"を使用してください
      # - 規制対象データには必ずSSE-KMSを使用してください
      # - 開発環境では"SSE-S3"または"DISABLED"でコスト削減を検討できます
      # - パブリックデータセットには"SSE-S3"または"DISABLED"が適しています
      # - データ分類に基づいて適切な暗号化方式を選択してください
      #
      # パフォーマンス考慮事項:
      # - SSE-KMSは大量のファイル書き込みでKMS APIスロットリングが発生する可能性があります
      # - 高スループットが必要な場合、KMS APIのクォータ引き上げを検討してください
      # - SSE-S3はKMS APIコールが不要なため、スロットリングリスクがありません
      #
      # セキュリティ考慮事項:
      # - クロスアカウントアクセスが必要な場合、SSE-KMSとキーポリシーの組み合わせを使用してください
      # - データ分類ポリシーに基づいて暗号化方式を選択してください
      # - 暗号化を有効化しても、S3バケットポリシーとIAMポリシーは別途必要です
      #
      # 注意事項:
      # - S3バケットのデフォルト暗号化設定とGlueセキュリティ設定は独立しています
      # - Glueセキュリティ設定が優先されます
      # - 既存のS3オブジェクトは再暗号化されません
      #
      # タイプ: string
      # デフォルト: "DISABLED"
      s3_encryption_mode = "SSE-KMS"

      # kms_key_arn - (オプション) 暗号化に使用するKMSキーのARN
      #
      # 説明:
      # S3データの暗号化に使用するAWS KMSキーのAmazon Resource Name（ARN）を指定します。
      # s3_encryption_modeが"SSE-KMS"の場合に必要です。
      #
      # フォーマット:
      # - arn:aws:kms:<region>:<account-id>:key/<key-id>
      # - 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      #
      # キーの選択:
      # - CloudWatch、ジョブブックマークと同じキーを使用することも、別のキーを使用することも可能です
      # - 同じキーを使用する場合:
      #   - 管理が簡素化されます
      #   - KMSコストが削減される可能性があります（キー単位の月額料金）
      #   - キーポリシーの管理が容易になります
      #
      # - 異なるキーを使用する場合（推奨）:
      #   - データの種類ごとに異なるアクセス制御が可能です
      #   - セキュリティ境界を明確に分離できます
      #   - 監査トレイルが詳細になります
      #   - コンプライアンス要件に対応しやすくなります
      #   - キーの侵害時の影響範囲を限定できます
      #
      # キーポリシー要件:
      # Glueジョブに使用するIAMロールに以下の権限を付与:
      #   {
      #     "Effect": "Allow",
      #     "Principal": {
      #       "AWS": "arn:aws:iam::<account-id>:role/<glue-job-role>"
      #     },
      #     "Action": [
      #       "kms:Encrypt",
      #       "kms:GenerateDataKey",
      #       "kms:DescribeKey"
      #     ],
      #     "Resource": "*"
      #   }
      #
      # データ消費者（読み取り側）に必要な権限:
      #   {
      #     "Effect": "Allow",
      #     "Principal": {
      #       "AWS": "arn:aws:iam::<account-id>:role/<consumer-role>"
      #     },
      #     "Action": [
      #       "kms:Decrypt",
      #       "kms:DescribeKey"
      #     ],
      #     "Resource": "*"
      #   }
      #
      # クロスアカウントアクセス:
      # 他のAWSアカウントからS3データにアクセスする場合:
      # 1. KMSキーポリシーで対象アカウントに権限を付与:
      #    {
      #      "Effect": "Allow",
      #      "Principal": {
      #        "AWS": "arn:aws:iam::<other-account-id>:root"
      #      },
      #      "Action": [
      #        "kms:Decrypt",
      #        "kms:DescribeKey"
      #      ],
      #      "Resource": "*"
      #    }
      # 2. S3バケットポリシーで対象アカウントに権限を付与
      # 3. 対象アカウントのIAMロールにKMSとS3の権限を付与
      #
      # セキュリティ考慮事項:
      # - キーへのアクセスを必要最小限のIAMロールに制限してください
      # - キーポリシーで条件キーを使用して、特定のS3バケットへの暗号化のみを許可することを検討してください:
      #   "Condition": {
      #     "StringEquals": {
      #       "kms:EncryptionContext:aws:s3:arn": "arn:aws:s3:::<bucket-name>/*"
      #     }
      #   }
      # - CloudTrailでKMSキーの使用状況を監視してください
      # - 定期的にキーのアクセスパターンをレビューしてください
      # - 使用されなくなったキーは無効化または削除してください
      #
      # 運用考慮事項:
      # - KMSキーは使用前に有効化されている必要があります
      # - キーのエイリアスを使用すると、キーのローテーション時に設定変更が不要です
      # - 自動キーローテーションを有効化することを推奨します（年次ローテーション）
      # - マルチリージョン展開の場合、マルチリージョンキーの使用を検討してください
      # - キーの削除には30日間の待機期間を設定してください
      #
      # パフォーマンス考慮事項:
      # - 大量のファイルを書き込む場合、KMS APIのスロットリングに注意してください
      # - KMS APIのクォータ:
      #   - GenerateDataKey: 5,500リクエスト/秒（米国東部、調整可能）
      #   - Decrypt: 5,500リクエスト/秒（米国東部、調整可能）
      # - 必要に応じて、AWS Supportに連絡してクォータの引き上げを依頼してください
      #
      # コスト考慮事項:
      # - KMSキー: $1/月（カスタマーマネージドキー）
      # - KMS APIコール: $0.03/10,000リクエスト
      # - 大量のファイル書き込みでコストが増加する可能性があります
      # - AWS Cost Explorerで実際のKMSコストを監視してください
      #
      # トラブルシューティング:
      # - "Access Denied"エラー:
      #   - IAMロールにkms:Encrypt、kms:GenerateDataKey権限があるか確認
      #   - キーポリシーでIAMロールが許可されているか確認
      #   - KMSキーが有効化されているか確認
      #
      # - "KMS.ThrottlingException"エラー:
      #   - KMS APIのクォータを超えている可能性があります
      #   - 書き込み速度を調整するか、クォータの引き上げを依頼してください
      #
      # - VPC内でGlueを実行する場合の注意:
      #   - VPCエンドポイント経由でKMSにアクセスできることを確認してください
      #   - KMS用のVPCエンドポイント（com.amazonaws.<region>.kms）を作成してください
      #   - または、NATゲートウェイ経由でインターネットアクセスを提供してください
      #
      # 注意事項:
      # - s3_encryption_modeが"SSE-S3"または"DISABLED"の場合、この値は無視されます
      # - AWS Glueは対称カスタマーマネージドキー（CMK）のみをサポートします
      # - 非対称キーは使用できません
      # - S3バケットと同じリージョンのKMSキーを使用する必要があります
      #
      # タイプ: string
      # デフォルト: なし
      kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    }
  }

  # ============================================================================
  # リージョン設定（オプション）
  # ============================================================================

  # region - (オプション) このリソースを管理するリージョン
  #
  # 説明:
  # セキュリティ設定を作成するAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 使用シナリオ:
  # - マルチリージョン展開: 複数のリージョンで同じセキュリティ設定を作成する場合
  # - リージョン固有の要件: 特定のリージョンでのみセキュリティ設定が必要な場合
  # - リージョンごとのKMSキー: 各リージョンで異なるKMSキーを使用する場合
  #
  # 考慮事項:
  # - セキュリティ設定はリージョナルリソースです（グローバルではありません）
  # - 各リージョンで独立して作成する必要があります
  # - KMSキーもリージョナルリソースなため、同じリージョンのキーを使用する必要があります
  # - Glueジョブとセキュリティ設定は同じリージョンに存在する必要があります
  #
  # マルチリージョン展開のベストプラクティス:
  # - 各リージョンで同じ名前のセキュリティ設定を作成することを検討してください
  # - リージョンごとに異なるKMSキーを使用してください
  # - またはマルチリージョンKMSキーを使用して管理を簡素化してください
  # - Terraformのfor_eachを使用して、複数リージョンに一括デプロイできます
  #
  # 例:
  # region = "us-west-2"
  #
  # マルチリージョンの例（for_eachを使用）:
  # locals {
  #   regions = ["us-east-1", "us-west-2", "eu-west-1"]
  # }
  #
  # resource "aws_glue_security_configuration" "multi_region" {
  #   for_each = toset(local.regions)
  #
  #   name   = "multi-region-glue-security-config"
  #   region = each.value
  #
  #   encryption_configuration {
  #     # ... 暗号化設定 ...
  #   }
  # }
  #
  # 注意事項:
  # - この属性を指定すると、プロバイダーのデフォルトリージョンが上書きされます
  # - リージョンを指定する場合、そのリージョンで有効なKMSキーARNを使用してください
  # - リージョン間でのセキュリティ設定の移行やコピーは自動的には行われません
  #
  # タイプ: string
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-east-1"
}

################################################################################
# Terraform出力値の例
################################################################################

# セキュリティ設定のIDを出力
output "glue_security_configuration_id" {
  description = "The ID (name) of the Glue security configuration"
  value       = aws_glue_security_configuration.example.id
}

# セキュリティ設定の名前を出力
output "glue_security_configuration_name" {
  description = "The name of the Glue security configuration"
  value       = aws_glue_security_configuration.example.name
}

################################################################################
# 使用例: Glueジョブにセキュリティ設定をアタッチ
################################################################################

# Glueジョブの例（セキュリティ設定を使用）
resource "aws_glue_job" "example" {
  name     = "example-glue-job"
  role_arn = aws_iam_role.glue_job_role.arn

  # セキュリティ設定をアタッチ
  security_configuration = aws_glue_security_configuration.example.name

  command {
    name            = "glueetl"
    script_location = "s3://my-bucket/scripts/my-script.py"
    python_version  = "3"
  }

  # その他のジョブ設定...
}

# Glueクローラーの例（セキュリティ設定を使用）
resource "aws_glue_crawler" "example" {
  name          = "example-crawler"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.example.name

  # セキュリティ設定をアタッチ
  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      SecurityConfiguration = aws_glue_security_configuration.example.name
    }
  })

  s3_target {
    path = "s3://my-bucket/data/"
  }
}

################################################################################
# IAMロールの例: Glueジョブに必要な権限
################################################################################

# Glueジョブ用のIAMロール
resource "aws_iam_role" "glue_job_role" {
  name = "example-glue-job-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Glue基本ポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# KMS権限のカスタムポリシー（セキュリティ設定でKMSを使用する場合）
resource "aws_iam_role_policy" "glue_kms_policy" {
  name = "glue-kms-policy"
  role = aws_iam_role.glue_job_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Resource = [
          "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
        ]
      }
    ]
  })
}

# S3アクセス権限のカスタムポリシー
resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "glue-s3-policy"
  role = aws_iam_role.glue_job_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::my-bucket/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::my-bucket"
        ]
      }
    ]
  })
}

################################################################################
# KMSキーポリシーの例
################################################################################

# KMSキーの作成（セキュリティ設定で使用）
resource "aws_kms_key" "glue_encryption" {
  description             = "KMS key for AWS Glue encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Glue to use the key"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.glue_job_role.arn
        }
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs to use the key"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:us-east-1:123456789012:*"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "glue-encryption-key"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# KMSキーエイリアスの作成
resource "aws_kms_alias" "glue_encryption" {
  name          = "alias/glue-encryption"
  target_key_id = aws_kms_key.glue_encryption.key_id
}

################################################################################
# 追加のベストプラクティスとパターン
################################################################################

# 環境別のセキュリティ設定パターン
# 本番環境: すべての暗号化を有効化
resource "aws_glue_security_configuration" "production" {
  name = "production-glue-security-config"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "SSE-KMS"
      kms_key_arn                = aws_kms_key.glue_encryption.arn
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "CSE-KMS"
      kms_key_arn                   = aws_kms_key.glue_encryption.arn
    }

    s3_encryption {
      s3_encryption_mode = "SSE-KMS"
      kms_key_arn        = aws_kms_key.glue_encryption.arn
    }
  }
}

# 開発環境: コスト削減のため最小限の暗号化
resource "aws_glue_security_configuration" "development" {
  name = "development-glue-security-config"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "DISABLED"
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "DISABLED"
    }

    s3_encryption {
      s3_encryption_mode = "SSE-S3" # S3管理キーで基本的な暗号化
    }
  }
}

# 異なるKMSキーを使用するパターン（より細かいアクセス制御）
resource "aws_glue_security_configuration" "separate_keys" {
  name = "separate-keys-glue-security-config"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "SSE-KMS"
      kms_key_arn                = aws_kms_key.cloudwatch_logs.arn # CloudWatch専用キー
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "CSE-KMS"
      kms_key_arn                   = aws_kms_key.job_bookmarks.arn # ジョブブックマーク専用キー
    }

    s3_encryption {
      s3_encryption_mode = "SSE-KMS"
      kms_key_arn        = aws_kms_key.s3_data.arn # S3データ専用キー
    }
  }
}

################################################################################
# トラブルシューティングガイド
################################################################################

# よくあるエラーと解決方法:
#
# 1. "User is not authorized to perform: kms:GenerateDataKey"
#    原因: GlueジョブのIAMロールにKMS権限がない
#    解決: IAMロールにkms:GenerateDataKey権限を追加
#
# 2. "The provided KMS key is not valid"
#    原因: KMSキーが無効化されているか、ARNが間違っている
#    解決: KMSキーの状態を確認し、有効化する。ARNが正しいか確認
#
# 3. "Access Denied when writing to S3"
#    原因: KMS暗号化されたS3バケットへの書き込み権限がない
#    解決: IAMロールにkms:Encrypt、kms:GenerateDataKey権限を追加
#
# 4. "KMS.ThrottlingException"
#    原因: KMS APIのクォータを超えている
#    解決: 書き込み速度を調整するか、KMSクォータの引き上げを依頼
#
# 5. "CloudWatch Logs encryption failed"
#    原因: CloudWatch Logsサービスに対するKMS権限が不足
#    解決: KMSキーポリシーにCloudWatch Logsサービスへの権限を追加
#
# 6. "VPC内でKMSにアクセスできない"
#    原因: VPCエンドポイントが設定されていない
#    解決: KMS用のVPCエンドポイントを作成するか、NATゲートウェイを使用
#
# 7. "Job bookmark encryption failed"
#    原因: ジョブブックマーク用のKMS権限が不足
#    解決: IAMロールにkms:Decrypt、kms:Encrypt権限を追加
#
# 8. "Security configuration not found"
#    原因: Glueジョブとセキュリティ設定が異なるリージョンにある
#    解決: 同じリージョンにセキュリティ設定を作成

################################################################################
# セキュリティチェックリスト
################################################################################

# デプロイ前に確認すること:
# □ すべてのKMSキーが有効化されている
# □ GlueジョブのIAMロールに必要なKMS権限がある
# □ KMSキーポリシーでGlueサービスロールが許可されている
# □ CloudWatch Logs用のKMS権限がキーポリシーに含まれている
# □ S3バケットポリシーとKMSキーポリシーが一致している
# □ VPC内でGlueを実行する場合、VPCエンドポイントが設定されている
# □ 自動キーローテーションが有効化されている（推奨）
# □ CloudTrailでKMSキーの監視が有効化されている
# □ キーの削除保護（30日間の待機期間）が設定されている
# □ 環境に応じた適切な暗号化レベルが選択されている
# □ コスト試算が完了している（KMS APIコール料金）
# □ クロスアカウントアクセスが必要な場合、適切な権限が設定されている

################################################################################
# コスト最適化のヒント
################################################################################

# 1. 環境ごとに異なる暗号化レベルを使用:
#    - 本番環境: SSE-KMS（すべて有効）
#    - ステージング環境: SSE-KMS（S3のみ）または SSE-S3
#    - 開発環境: SSE-S3 または DISABLED
#
# 2. KMSキーの共有:
#    - 複数のGlueジョブで同じKMSキーを使用してキーの月額料金を削減
#    - ただし、セキュリティ境界の分離が必要な場合は別のキーを使用
#
# 3. S3暗号化の選択:
#    - 詳細なアクセス制御が不要な場合、SSE-S3を使用してKMSコストを削減
#    - パブリックデータセットの場合、DISABLEDも検討
#
# 4. CloudWatch Logsの保持期間:
#    - ログの保持期間を適切に設定してストレージコストを削減
#    - 古いログはS3 Glacierにアーカイブすることを検討
#
# 5. KMS APIコールの削減:
#    - データエンベロープ暗号化を使用（SSE-KMSは自動的に実装）
#    - 小さいファイルを結合して書き込み回数を削減

################################################################################
# コンプライアンスガイドライン
################################################################################

# GDPR準拠:
# - すべてのデータ（S3、CloudWatch、ジョブブックマーク）でSSE-KMS暗号化を使用
# - カスタマーマネージドキーを使用して完全な制御を確保
# - データ削除時にKMSキーを削除して復号化不可能にする
# - CloudTrailで暗号化/復号化操作を監査
#
# HIPAA準拠:
# - すべてのデータでSSE-KMS暗号化を使用
# - 自動キーローテーションを有効化
# - アクセスログを有効化して監査トレイルを保持
# - キーへのアクセスを最小権限に制限
#
# PCI DSS準拠:
# - カード会員データを含むデータでSSE-KMS暗号化を使用
# - キーのアクセスログを保持（最低1年間）
# - 定期的なアクセスレビューを実施
# - 強力な暗号化アルゴリズム（AES-256）を使用（SSE-KMSは自動的に使用）

################################################################################
# タグ付けのベストプラクティス
################################################################################

# タグは直接サポートされていませんが、関連リソース（KMSキー、IAMロールなど）にタグを付けることで
# コスト管理と監査を容易にできます:
#
# - Environment: production, staging, development
# - Application: data-pipeline, analytics, etl
# - CostCenter: finance, marketing, engineering
# - Owner: team-name@company.com
# - Compliance: gdpr, hipaa, pci-dss
# - ManagedBy: terraform
# - DataClassification: public, internal, confidential, restricted
