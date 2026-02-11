#---------------------------------------------------------------
# EC2 Image Builder イメージパイプライン
#---------------------------------------------------------------
#
# EC2 Image Builderのイメージパイプラインをプロビジョニングするリソースです。
# イメージパイプラインは、カスタムAMIまたはコンテナイメージを作成および
# メンテナンスするための自動化フレームワークを提供します。
# ベースイメージの組み立て、ビルド・テストコンポーネント、インフラ設定、
# 配布設定を統合し、定期的な自動メンテナンスやイベント駆動の実行をサポートします。
#
# AWS公式ドキュメント:
#   - Image Builder パイプライン管理: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-pipelines.html
#   - Image Builder の仕組み: https://docs.aws.amazon.com/imagebuilder/latest/userguide/how-image-builder-works.html
#   - AMI イメージパイプラインの作成: https://docs.aws.amazon.com/imagebuilder/latest/userguide/ami-image-pipelines.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_pipeline
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_image_pipeline" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: イメージパイプラインの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 注意: パイプライン名は一意である必要があります。
  name = "example-image-pipeline"

  # description (Optional)
  # 設定内容: イメージパイプラインの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしでパイプラインが作成されます。
  description = "Example image pipeline for custom AMI creation"

  # status (Optional)
  # 設定内容: イメージパイプラインのステータスを指定します。
  # 設定可能な値:
  #   - "ENABLED" (デフォルト): パイプラインが有効で、スケジュールに従って実行されます
  #   - "DISABLED": パイプラインが無効で、スケジュールされた実行が停止されます
  # 省略時: ENABLED として扱われます。
  # 注意: 無効化してもパイプラインは削除されず、手動実行は可能です。
  status = "ENABLED"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # レシピ設定
  #-------------------------------------------------------------

  # infrastructure_configuration_arn (Required)
  # 設定内容: Image Builderインフラストラクチャ設定のARNを指定します。
  # 設定可能な値: 有効なインフラストラクチャ設定ARN
  # 注意: このARNは、ビルドおよびテストインスタンスの起動設定を定義します。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-infra-config.html
  infrastructure_configuration_arn = "arn:aws:imagebuilder:ap-northeast-1:123456789012:infrastructure-configuration/example"

  # image_recipe_arn (Optional)
  # 設定内容: イメージレシピのARNを指定します。
  # 設定可能な値: 有効なイメージレシピARN
  # 省略時: container_recipe_arnを指定する必要があります。
  # 注意: container_recipe_arnと排他的（どちらか一方のみ指定可能）。
  #       AMIイメージを作成する場合はこちらを使用します。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-recipes.html
  image_recipe_arn = "arn:aws:imagebuilder:ap-northeast-1:123456789012:image-recipe/example/1.0.0"

  # container_recipe_arn (Optional)
  # 設定内容: コンテナレシピのARNを指定します。
  # 設定可能な値: 有効なコンテナレシピARN
  # 省略時: image_recipe_arnを指定する必要があります。
  # 注意: image_recipe_arnと排他的（どちらか一方のみ指定可能）。
  #       コンテナイメージを作成する場合はこちらを使用します。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/container-image-pipelines.html
  container_recipe_arn = null

  #-------------------------------------------------------------
  # 配布設定
  #-------------------------------------------------------------

  # distribution_configuration_arn (Optional)
  # 設定内容: Image Builder配布設定のARNを指定します。
  # 設定可能な値: 有効な配布設定ARN
  # 省略時: イメージは作成されますが、他のリージョンやアカウントには配布されません。
  # 関連機能: イメージの配布設定
  #   作成したAMIやコンテナイメージを複数のリージョンやアカウントに配布する設定を定義します。
  #   暗号化キーの設定、AMI共有、ライセンス設定、起動テンプレートの作成などが可能です。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-distribution-settings.html
  distribution_configuration_arn = null

  #-------------------------------------------------------------
  # メタデータ・ロギング設定
  #-------------------------------------------------------------

  # enhanced_image_metadata_enabled (Optional)
  # 設定内容: 拡張イメージメタデータの収集を有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): イメージに関する追加情報を収集します
  #   - false: 追加情報の収集を無効化します
  # 省略時: true として扱われます。
  # 関連機能: 拡張イメージメタデータ
  #   作成されるイメージに関する詳細情報（インストールされたパッケージ、
  #   セキュリティ脆弱性など）を自動的に収集します。
  enhanced_image_metadata_enabled = true

  # execution_role (Optional)
  # 設定内容: Image Builderがワークフローを実行する際に使用するサービスリンクロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: ワークフロー実行時にロールが指定されていない場合、デフォルトの権限で実行されます。
  # 関連機能: イメージワークフローの実行
  #   Image Builderがカスタムワークフローを実行するために必要な権限を提供します。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-image-workflows.html
  execution_role = null

  #-------------------------------------------------------------
  # スケジュール設定
  #-------------------------------------------------------------

  # schedule (Optional, max_items: 1)
  # 設定内容: パイプラインのスケジュール設定を定義します。
  # 省略時: スケジュールされた自動実行は行われず、手動実行のみとなります。
  # 関連機能: パイプラインスケジューリング
  #   cron式を使用して定期的な自動メンテナンスプロセスを設定できます。
  #   変更検知機能により、ベースイメージやコンポーネントに変更がない場合は
  #   スケジュールされたビルドを自動的にスキップします。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/schedule-pipeline.html
  schedule {
    # schedule_expression (Required)
    # 設定内容: パイプライン開始条件の評価頻度をcron式で指定します。
    # 設定可能な値: 6フィールドcron式（例: cron(0 0 * * ? *)）
    # 注意: 5フィールド構文（cron(0 0 * * *)）は非推奨です。
    #       6フィールド構文に更新する必要があります。
    # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/cron-expressions.html
    schedule_expression = "cron(0 0 * * ? *)"

    # pipeline_execution_start_condition (Optional)
    # 設定内容: パイプラインが新しいイメージビルドをトリガーする条件を指定します。
    # 設定可能な値:
    #   - "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE" (デフォルト): cron式が一致し、かつベースイメージまたはコンポーネントに更新がある場合に実行
    #   - "EXPRESSION_MATCH_ONLY": cron式が一致した場合に常に実行（変更の有無に関わらず）
    # 省略時: EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE として扱われます。
    # 関連機能: 変更検知
    #   ベースイメージとコンポーネントの変更を自動的に検知し、
    #   変更がない場合はスケジュールされたビルドをスキップします。
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"

    # timezone (Optional)
    # 設定内容: スケジュール式に適用するタイムゾーンを指定します。
    # 設定可能な値: IANA タイムゾーン形式（例: "Etc/UTC", "America/Los_Angeles", "Asia/Tokyo"）
    # 省略時: UTC として扱われます。
    # 参考: https://www.joda.org/joda-time/timezones.html
    timezone = "Asia/Tokyo"
  }

  #-------------------------------------------------------------
  # イメージテスト設定
  #-------------------------------------------------------------

  # image_tests_configuration (Optional, max_items: 1)
  # 設定内容: イメージテストの設定を定義します。
  # 省略時: デフォルト設定（テスト有効、タイムアウト720分）でテストが実行されます。
  # 関連機能: イメージテスト
  #   Image Builderは、イメージ作成後に自動的にテストを実行し、
  #   イメージが正しく機能することを検証します。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-component-manager.html
  image_tests_configuration {
    # image_tests_enabled (Optional)
    # 設定内容: イメージテストを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): イメージテストを実行します
    #   - false: イメージテストをスキップします
    # 省略時: true として扱われます。
    # 注意: 本番環境では、テストを有効にしてイメージの品質を確保することを推奨します。
    image_tests_enabled = true

    # timeout_minutes (Optional)
    # 設定内容: イメージテストがタイムアウトするまでの時間（分）を指定します。
    # 設定可能な値: 60～1440の整数
    # 省略時: 720分（12時間）として扱われます。
    # 注意: 複雑なテストを実行する場合は、十分な時間を設定してください。
    timeout_minutes = 720
  }

  #-------------------------------------------------------------
  # イメージスキャン設定
  #-------------------------------------------------------------

  # image_scanning_configuration (Optional, max_items: 1)
  # 設定内容: イメージスキャンの設定を定義します。
  # 省略時: イメージスキャンは実行されません。
  # 関連機能: Amazon Inspectorによるイメージスキャン
  #   Image Builderは、Amazon Inspectorと統合してイメージの脆弱性スキャンを実行できます。
  #   露出、脆弱性、ベストプラクティスからの逸脱、コンプライアンス基準を評価します。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-inspector.html
  image_scanning_configuration {
    # image_scanning_enabled (Optional)
    # 設定内容: イメージスキャンを有効にするかを指定します。
    # 設定可能な値:
    #   - true: イメージスキャンを実行します
    #   - false (デフォルト): イメージスキャンをスキップします
    # 省略時: false として扱われます。
    # 注意: スキャンを有効にするには、Amazon Inspector サービスへのアクセス権限が必要です。
    image_scanning_enabled = false

    # ecr_configuration (Optional, max_items: 1)
    # 設定内容: ECR（Elastic Container Registry）スキャン設定を定義します。
    # 省略時: デフォルトのECR設定でスキャンが実行されます。
    # 注意: この設定は、コンテナイメージパイプライン（container_recipe_arn使用時）でのみ有効です。
    ecr_configuration {
      # repository_name (Optional)
      # 設定内容: スキャン対象のECRリポジトリ名を指定します。
      # 設定可能な値: 有効なECRリポジトリ名
      # 省略時: デフォルトのリポジトリが使用されます。
      repository_name = null

      # container_tags (Optional)
      # 設定内容: スキャンされるイメージに適用するタグのリストを指定します。
      # 設定可能な値: タグ文字列のセット
      # 省略時: タグなしでイメージがスキャンされます。
      container_tags = []
    }
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_configuration (Optional, max_items: 1)
  # 設定内容: パイプラインとイメージビルドのロギング設定を定義します。
  # 省略時: ログはCloudWatch Logsに出力されません。
  # 関連機能: CloudWatch Logsとの統合
  #   パイプライン実行ログとイメージビルドログをCloudWatch Logsに送信して、
  #   デバッグやトラブルシューティングを容易にします。
  logging_configuration {
    # pipeline_log_group_name (Optional)
    # 設定内容: パイプラインログを送信するCloudWatch Log Group名を指定します。
    # 設定可能な値: 有効なCloudWatch Log Group名
    # 省略時: パイプラインログは記録されません。
    # 注意: 指定するLog Groupは事前に作成されている必要があります。
    pipeline_log_group_name = null

    # image_log_group_name (Optional)
    # 設定内容: イメージビルドログを送信するCloudWatch Log Group名を指定します。
    # 設定可能な値: 有効なCloudWatch Log Group名
    # 省略時: イメージビルドログは記録されません。
    # 注意: 指定するLog Groupは事前に作成されている必要があります。
    image_log_group_name = null
  }

  #-------------------------------------------------------------
  # ワークフロー設定
  #-------------------------------------------------------------

  # workflow (Optional)
  # 設定内容: パイプラインで実行するワークフローを定義します。
  # 省略時: カスタムワークフローは実行されません。
  # 関連機能: Image Builderワークフロー
  #   ビルド、テスト、配布の各フェーズでカスタムワークフローを実行できます。
  #   ワークフローにより、イメージビルドプロセスをさらに自動化・カスタマイズできます。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-image-workflows.html
  # workflow {
  #   # workflow_arn (Required)
  #   # 設定内容: Image BuilderワークフローのARNを指定します。
  #   # 設定可能な値: 有効なワークフローARN
  #   # 注意: ワークフローは事前に作成されている必要があります。
  #   workflow_arn = "arn:aws:imagebuilder:ap-northeast-1:123456789012:workflow/build/example/1.0.0"
  #
  #   # on_failure (Optional)
  #   # 設定内容: ワークフローが失敗した場合のアクションを指定します。
  #   # 設定可能な値:
  #   #   - "CONTINUE": ワークフローが失敗しても次のステップに進みます
  #   #   - "ABORT": ワークフローが失敗した場合、パイプライン実行を中止します
  #   # 省略時: デフォルトの動作（通常はABORT）が適用されます。
  #   on_failure = "ABORT"
  #
  #   # parallel_group (Optional)
  #   # 設定内容: テストワークフローを並列実行するグループを指定します。
  #   # 設定可能な値: 任意の文字列（グループ識別子）
  #   # 省略時: ワークフローは順次実行されます。
  #   # 注意: 同じparallel_groupを持つワークフローは並列に実行されます。
  #   parallel_group = null
  #
  #   # parameter (Optional)
  #   # 設定内容: ワークフローに渡すパラメータを定義します。
  #   # 省略時: パラメータなしでワークフローが実行されます。
  #   # parameter {
  #   #   # name (Required)
  #   #   # 設定内容: ワークフローパラメータの名前を指定します。
  #   #   # 設定可能な値: ワークフロー定義で指定されたパラメータ名
  #   #   name = "ParameterName"
  #   #
  #   #   # value (Required)
  #   #   # 設定内容: ワークフローパラメータの値を指定します。
  #   #   # 設定可能な値: パラメータの型に応じた値（文字列として指定）
  #   #   value = "ParameterValue"
  #   # }
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-image-pipeline"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: イメージパイプラインのAmazon Resource Name (ARN)
#
# - arn: イメージパイプラインのAmazon Resource Name (ARN)
#
# - date_created: イメージパイプラインが作成された日時
#
# - date_last_run: イメージパイプラインが最後に実行された日時
#
# - date_next_run: イメージパイプラインが次に実行される日時
#
# - date_updated: イメージパイプラインが更新された日時
#
# - platform: イメージパイプラインのプラットフォーム（Linux, Windows等）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
