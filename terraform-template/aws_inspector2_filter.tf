#---------------------------------------------------------------
# AWS Inspector2 Filter
#---------------------------------------------------------------
#
# AWS Inspector2のフィルターをプロビジョニングするリソースです。
# Inspector2フィルターは、脆弱性や露出した認証情報などのセキュリティ検出結果を
# 特定の条件でフィルタリングし、重要な検出結果の優先順位付けや不要な検出結果の
# 抑制(SUPPRESS)に役立ちます。
#
# AWS公式ドキュメント:
#   - Amazon Inspector概要: https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html
#   - 検出結果の管理: https://docs.aws.amazon.com/inspector/latest/user/findings-managing.html
#   - 検出結果の抑制ルール: https://docs.aws.amazon.com/inspector/latest/user/findings-managing-supression-rules.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_filter
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_inspector2_filter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: フィルターの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: わかりやすい命名規則を使用してフィルターの目的を明確にすることを推奨
  name = "example-inspector-filter"

  # action (Required)
  # 設定内容: フィルターに一致する検出結果に適用するアクションを指定します。
  # 設定可能な値:
  #   - "NONE": 検出結果をフィルタリングしますが、抑制しません
  #   - "SUPPRESS": 検出結果を抑制し、Security HubやEventBridgeに送信しません
  # ユースケース:
  #   - "NONE": 検出結果のビューをフィルタリングして特定の条件の結果のみを表示
  #   - "SUPPRESS": 誤検知や受容済みのリスクを持つ検出結果を非表示にする
  # 参考: https://docs.aws.amazon.com/inspector/latest/user/findings-managing-supression-rules.html
  action = "SUPPRESS"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: フィルターの説明を指定します。
  # 設定可能な値: 文字列
  # 推奨: フィルターの目的や適用条件を明確に記述することを推奨
  description = "Suppress low severity findings for specific AWS accounts"

  # reason (Optional)
  # 設定内容: フィルターを作成する理由を指定します。
  # 設定可能な値: 文字列
  # 推奨: 監査やコンプライアンスの観点から、抑制する理由を記録することを推奨
  reason = "Low severity findings are acceptable in test environments"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-inspector-filter"
    Environment = "production"
    Purpose     = "suppress-low-severity"
  }

  #-------------------------------------------------------------
  # フィルター条件 (filter_criteria)
  #-------------------------------------------------------------
  # 設定内容: 検出結果をフィルタリングするための詳細な条件を指定します。
  # 注意: 複数の条件を組み合わせることができ、すべての条件に一致する検出結果がフィルタリングされます
  filter_criteria {
    #-----------------------------------------------------------
    # AWSアカウントID条件 (aws_account_id)
    #-----------------------------------------------------------
    # 設定内容: 検出結果が生成されたAWSアカウントIDでフィルタリングします。
    # ユースケース: 特定のアカウント（例: 開発環境、テスト環境）の検出結果を抑制
    aws_account_id {
      # comparison (Required)
      # 設定内容: 比較演算子を指定します。
      # 設定可能な値: "EQUALS", "PREFIX", "NOT_EQUALS"
      comparison = "EQUALS"

      # value (Required)
      # 設定内容: 比較する値を指定します。
      # 設定可能な値: AWSアカウントID（12桁の数字）
      value = "111222333444"
    }

    #-----------------------------------------------------------
    # 重大度条件 (severity)
    #-----------------------------------------------------------
    # 設定内容: 検出結果の重大度でフィルタリングします。
    # 設定可能な値: "CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL", "UNTRIAGED"
    # ユースケース: 低い重大度の検出結果を抑制
    # severity {
    #   comparison = "EQUALS"
    #   value      = "LOW"
    # }

    #-----------------------------------------------------------
    # 検出結果ステータス条件 (finding_status)
    #-----------------------------------------------------------
    # 設定内容: 検出結果のステータスでフィルタリングします。
    # 設定可能な値: "ACTIVE", "SUPPRESSED", "CLOSED"
    # ユースケース: アクティブな検出結果のみを表示、または抑制された検出結果を表示
    # finding_status {
    #   comparison = "EQUALS"
    #   value      = "ACTIVE"
    # }

    #-----------------------------------------------------------
    # 検出結果タイプ条件 (finding_type)
    #-----------------------------------------------------------
    # 設定内容: 検出結果のタイプでフィルタリングします。
    # 設定可能な値: "NETWORK_REACHABILITY", "PACKAGE_VULNERABILITY", "CODE_VULNERABILITY"
    # ユースケース: 特定のタイプの検出結果（例: ネットワーク到達可能性のみ）を抑制
    # finding_type {
    #   comparison = "EQUALS"
    #   value      = "PACKAGE_VULNERABILITY"
    # }

    #-----------------------------------------------------------
    # 脆弱性ID条件 (vulnerability_id)
    #-----------------------------------------------------------
    # 設定内容: CVE IDなどの脆弱性IDでフィルタリングします。
    # ユースケース: 特定のCVE（例: 受容済みのリスク）を抑制
    # vulnerability_id {
    #   comparison = "EQUALS"
    #   value      = "CVE-2023-12345"
    # }

    #-----------------------------------------------------------
    # Inspectorスコア条件 (inspector_score)
    #-----------------------------------------------------------
    # 設定内容: Inspectorが付与したスコアでフィルタリングします。
    # 注意: number-filterを使用（lower_inclusive、upper_inclusiveで範囲指定）
    # ユースケース: 低スコア（例: 5.0未満）の検出結果を抑制
    # inspector_score {
    #   lower_inclusive = 0.0
    #   upper_inclusive = 5.0
    # }

    #-----------------------------------------------------------
    # EPSSスコア条件 (epss_score)
    #-----------------------------------------------------------
    # 設定内容: EPSS（Exploit Prediction Scoring System）スコアでフィルタリングします。
    # 注意: EPSSスコアは、脆弱性が実際に悪用される確率を予測するスコアです
    # ユースケース: 悪用確率が低い脆弱性を抑制
    # epss_score {
    #   lower_inclusive = 0.0
    #   upper_inclusive = 0.1
    # }

    #-----------------------------------------------------------
    # 修正可用性条件 (fix_available)
    #-----------------------------------------------------------
    # 設定内容: 修正が利用可能かどうかでフィルタリングします。
    # 設定可能な値: "YES", "NO", "PARTIAL"
    # ユースケース: 修正が利用できない検出結果を抑制（対処不可能なため）
    # fix_available {
    #   comparison = "EQUALS"
    #   value      = "NO"
    # }

    #-----------------------------------------------------------
    # エクスプロイト可用性条件 (exploit_available)
    #-----------------------------------------------------------
    # 設定内容: エクスプロイトが利用可能かどうかでフィルタリングします。
    # 設定可能な値: "YES", "NO"
    # ユースケース: エクスプロイトが存在しない脆弱性を低優先度として扱う
    # exploit_available {
    #   comparison = "EQUALS"
    #   value      = "NO"
    # }

    #-----------------------------------------------------------
    # リソースタイプ条件 (resource_type)
    #-----------------------------------------------------------
    # 設定内容: リソースタイプでフィルタリングします。
    # 設定可能な値: "AWS_EC2_INSTANCE", "AWS_ECR_CONTAINER_IMAGE", "AWS_LAMBDA_FUNCTION"など
    # ユースケース: 特定のリソースタイプ（例: Lambda関数のみ）の検出結果を抑制
    # resource_type {
    #   comparison = "EQUALS"
    #   value      = "AWS_LAMBDA_FUNCTION"
    # }

    #-----------------------------------------------------------
    # リソースID条件 (resource_id)
    #-----------------------------------------------------------
    # 設定内容: リソースIDでフィルタリングします。
    # ユースケース: 特定のリソース（例: EC2インスタンスID）の検出結果を抑制
    # resource_id {
    #   comparison = "EQUALS"
    #   value      = "i-1234567890abcdef0"
    # }

    #-----------------------------------------------------------
    # EC2インスタンス条件
    #-----------------------------------------------------------
    # EC2インスタンスのイメージID、サブネットID、VPC IDでフィルタリング可能
    # ec2_instance_image_id {
    #   comparison = "EQUALS"
    #   value      = "ami-12345678"
    # }
    #
    # ec2_instance_subnet_id {
    #   comparison = "EQUALS"
    #   value      = "subnet-12345678"
    # }
    #
    # ec2_instance_vpc_id {
    #   comparison = "EQUALS"
    #   value      = "vpc-12345678"
    # }

    #-----------------------------------------------------------
    # ECRイメージ条件
    #-----------------------------------------------------------
    # ECRイメージのリポジトリ名、タグ、アーキテクチャなどでフィルタリング可能
    # ecr_image_repository_name {
    #   comparison = "EQUALS"
    #   value      = "my-app-repo"
    # }
    #
    # ecr_image_tags {
    #   comparison = "EQUALS"
    #   value      = "latest"
    # }
    #
    # ecr_image_architecture {
    #   comparison = "EQUALS"
    #   value      = "amd64"
    # }
    #
    # ecr_image_hash {
    #   comparison = "EQUALS"
    #   value      = "sha256:abcdef1234567890"
    # }
    #
    # ecr_image_registry {
    #   comparison = "EQUALS"
    #   value      = "123456789012.dkr.ecr.us-east-1.amazonaws.com"
    # }
    #
    # ecr_image_pushed_at {
    #   start_inclusive = "2024-01-01T00:00:00Z"
    #   end_inclusive   = "2024-12-31T23:59:59Z"
    # }
    #
    # ecr_image_in_use_count {
    #   lower_inclusive = 0
    #   upper_inclusive = 10
    # }
    #
    # ecr_image_last_in_use_at {
    #   start_inclusive = "2024-01-01T00:00:00Z"
    # }

    #-----------------------------------------------------------
    # Lambda関数条件
    #-----------------------------------------------------------
    # Lambda関数名、ランタイム、レイヤーなどでフィルタリング可能
    # lambda_function_name {
    #   comparison = "PREFIX"
    #   value      = "dev-"
    # }
    #
    # lambda_function_runtime {
    #   comparison = "EQUALS"
    #   value      = "nodejs18.x"
    # }
    #
    # lambda_function_execution_role_arn {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:iam::123456789012:role/lambda-execution-role"
    # }
    #
    # lambda_function_layers {
    #   comparison = "EQUALS"
    #   value      = "arn:aws:lambda:us-east-1:123456789012:layer:my-layer:1"
    # }
    #
    # lambda_function_last_modified_at {
    #   start_inclusive = "2024-01-01T00:00:00Z"
    # }

    #-----------------------------------------------------------
    # 日付範囲条件
    #-----------------------------------------------------------
    # 検出結果の初回観測日時、最終観測日時、更新日時でフィルタリング可能
    # 注意: RFC 3339形式、タイムゾーンはUTCに設定
    # first_observed_at {
    #   start_inclusive = "2024-01-01T00:00:00Z"
    #   end_inclusive   = "2024-12-31T23:59:59Z"
    # }
    #
    # last_observed_at {
    #   start_inclusive = "2024-01-01T00:00:00Z"
    #   end_inclusive   = "2024-12-31T23:59:59Z"
    # }
    #
    # updated_at {
    #   start_inclusive = "2024-01-01T00:00:00Z"
    #   end_inclusive   = "2024-12-31T23:59:59Z"
    # }

    #-----------------------------------------------------------
    # リソースタグ条件 (resource_tags)
    #-----------------------------------------------------------
    # 設定内容: リソースに付与されたタグでフィルタリングします。
    # 注意: map-filterを使用（comparison, key, valueで指定）
    # ユースケース: 特定のタグを持つリソース（例: Environment=dev）の検出結果を抑制
    # resource_tags {
    #   comparison = "EQUALS"
    #   key        = "Environment"
    #   value      = "dev"
    # }

    #-----------------------------------------------------------
    # ネットワーク条件
    #-----------------------------------------------------------
    # ネットワークプロトコルやポート範囲でフィルタリング可能
    # network_protocol {
    #   comparison = "EQUALS"
    #   value      = "TCP"
    # }
    #
    # port_range {
    #   begin_inclusive = 80
    #   end_inclusive   = 443
    # }

    #-----------------------------------------------------------
    # 脆弱なパッケージ条件 (vulnerable_packages)
    #-----------------------------------------------------------
    # 設定内容: 脆弱性を含むパッケージの詳細でフィルタリングします。
    # 注意: package-filterを使用
    # ユースケース: 特定のパッケージバージョンの検出結果を抑制
    # vulnerable_packages {
    #   # パッケージ名
    #   name {
    #     comparison = "EQUALS"
    #     value      = "openssl"
    #   }
    #
    #   # パッケージバージョン
    #   version {
    #     comparison = "EQUALS"
    #     value      = "1.0.2k"
    #   }
    #
    #   # パッケージアーキテクチャ
    #   architecture {
    #     comparison = "EQUALS"
    #     value      = "x86_64"
    #   }
    #
    #   # パッケージエポック（number-filter）
    #   epoch {
    #     lower_inclusive = 0
    #     upper_inclusive = 1
    #   }
    #
    #   # パッケージリリース
    #   release {
    #     comparison = "PREFIX"
    #     value      = "1.el7"
    #   }
    #
    #   # ファイルパス
    #   file_path {
    #     comparison = "PREFIX"
    #     value      = "/usr/lib/"
    #   }
    #
    #   # ソースLambdaレイヤーARN
    #   source_lambda_layer_arn {
    #     comparison = "PREFIX"
    #     value      = "arn:aws:lambda:us-east-1:123456789012:layer:"
    #   }
    #
    #   # ソースレイヤーハッシュ
    #   source_layer_hash {
    #     comparison = "EQUALS"
    #     value      = "sha256:abcdef"
    #   }
    # }

    #-----------------------------------------------------------
    # コード脆弱性条件
    #-----------------------------------------------------------
    # コードリポジトリのプロジェクト名、プロバイダタイプなどでフィルタリング可能
    # code_repository_project_name {
    #   comparison = "EQUALS"
    #   value      = "my-project"
    # }
    #
    # code_repository_provider_type {
    #   comparison = "EQUALS"
    #   value      = "GITHUB"
    # }
    #
    # code_vulnerability_file_path {
    #   comparison = "PREFIX"
    #   value      = "/src/"
    # }
    #
    # code_vulnerability_detector_name {
    #   comparison = "EQUALS"
    #   value      = "detector-name"
    # }
    #
    # code_vulnerability_detector_tags {
    #   comparison = "EQUALS"
    #   value      = "security"
    # }

    #-----------------------------------------------------------
    # その他の条件
    #-----------------------------------------------------------
    # 検出結果ARN、タイトル、関連脆弱性、ベンダー重大度、
    # 脆弱性ソースなどでもフィルタリング可能
    # finding_arn {
    #   comparison = "PREFIX"
    #   value      = "arn:aws:inspector2:"
    # }
    #
    # title {
    #   comparison = "PREFIX"
    #   value      = "CVE-2023"
    # }
    #
    # related_vulnerabilities {
    #   comparison = "EQUALS"
    #   value      = "CVE-2023-12345"
    # }
    #
    # vendor_severity {
    #   comparison = "EQUALS"
    #   value      = "LOW"
    # }
    #
    # vulnerability_source {
    #   comparison = "EQUALS"
    #   value      = "NVD"
    # }
    #
    # component_id {
    #   comparison = "EQUALS"
    #   value      = "component-123"
    # }
    #
    # component_type {
    #   comparison = "EQUALS"
    #   value      = "LIBRARY"
    # }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: フィルターのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 運用上の注意事項
#---------------------------------------------------------------
# 1. 抑制ルールの適用範囲
#    - 組織の委任管理者アカウントのみが抑制ルールを作成・管理できます
#    - スタンドアロンアカウントも自身のアカウント内で抑制ルールを管理可能
#
# 2. Security HubとEventBridgeへの影響
#    - action = "SUPPRESS"の場合、一致する検出結果はSecurity HubやEventBridgeに送信されません
#    - 既存の抑制ルールを削除すると、抑制されていた検出結果が再度公開されます
#
# 3. フィルター条件の設計
#    - 複数の条件を組み合わせることで、精密なフィルタリングが可能
#    - 過度に広範なフィルターは重要な検出結果を見逃すリスクがあるため注意
#---------------------------------------------------------------
