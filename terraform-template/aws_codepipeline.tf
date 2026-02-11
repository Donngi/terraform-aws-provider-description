#---------------------------------------------------------------
# AWS CodePipeline
#---------------------------------------------------------------
#
# AWS CodePipelineリソースをプロビジョニングします。
# CodePipelineは、コードの継続的デリバリー（CI/CD）を自動化するフルマネージドサービスです。
# ソースコード取得、ビルド、テスト、デプロイメントのフェーズを定義し、コードの変更を
# 自動的にリリースまで進めることができます。
#
# AWS公式ドキュメント:
#   - CodePipeline概要: https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html
#   - パイプライン実行の仕組み: https://docs.aws.amazon.com/codepipeline/latest/userguide/concepts-how-it-works.html
#   - パイプライン宣言構造: https://docs.aws.amazon.com/codepipeline/latest/userguide/pipeline-requirements.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codepipeline" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: パイプラインの名前を指定します。
  # 設定可能な値: 1-100文字。英数字、ドット(.)、ハイフン(-)、アンダースコア(_)のみ使用可能
  # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/pipeline-requirements.html
  name = "example-pipeline"

  # role_arn (Required)
  # 設定内容: CodePipelineがAWSサービスの呼び出しを行うためのIAMロールARNを指定します。
  # 設定可能な値: 有効なIAM Role ARN
  # 注意: このロールには、CodePipelineがS3、CodeBuild、CodeDeploy等のサービスにアクセスするための
  #       適切な権限が必要です。
  # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/security-iam.html
  role_arn = "arn:aws:iam::123456789012:role/codepipeline-service-role"

  #-------------------------------------------------------------
  # パイプライン設定
  #-------------------------------------------------------------

  # pipeline_type (Optional)
  # 設定内容: パイプラインのタイプを指定します。
  # 設定可能な値:
  #   - "V1": 従来のパイプラインタイプ（デフォルト）
  #   - "V2": V2パイプラインタイプ。trigger、variable、execution_mode等の追加機能が利用可能
  # 省略時: "V1"
  # 注意: V2パイプラインを作成または更新すると、V2に関連するコストが発生します
  # 関連機能: CodePipeline パイプラインタイプ
  #   V2パイプラインでは、リリースセーフティとトリガー設定のための追加パラメーターが利用可能。
  #   - https://docs.aws.amazon.com/codepipeline/latest/userguide/pipeline-requirements.html
  pipeline_type = "V1"

  # execution_mode (Optional)
  # 設定内容: パイプラインの実行モードを指定します。
  # 設定可能な値:
  #   - "SUPERSEDED": 実行は順番に処理され、後続の実行が先行の実行を置き換えることができます
  #   - "QUEUED": 実行はロックされたステージのエントリーポイントでキューに入り待機します
  #   - "PARALLEL": 実行は独立して実行され、他の実行の完了を待ちません
  # 注意: QUEUEDまたはPARALLELモードは、pipeline_typeが"V2"の場合のみ使用可能
  #       PARALLELモードでは、ステージのロールバックは利用できません
  # 関連機能: CodePipeline 実行モード
  #   実行モードは複数のパイプライン実行がどのように処理されるかを決定します。
  #   - https://docs.aws.amazon.com/codepipeline/latest/userguide/execution-modes.html
  execution_mode = null

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
  # 注意: プロバイダーのdefault_tags設定ブロックで定義されたタグと一致するキーを持つタグは、
  #       このタグ定義で上書きされます
  # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/tag-resources.html
  tags = {
    Environment = "production"
    Project     = "example"
  }

  #-------------------------------------------------------------
  # アーティファクトストア設定（必須）
  #-------------------------------------------------------------

  artifact_store {
    # location (Required)
    # 設定内容: アーティファクトを保存するS3バケットの名前を指定します。
    # 設定可能な値: 既存のS3バケット名
    # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/concepts.html#concepts-artifacts
    location = "example-pipeline-artifacts-bucket"

    # type (Required)
    # 設定内容: アーティファクトストアのタイプを指定します。
    # 設定可能な値: "S3"（現在はS3のみサポート）
    type = "S3"

    # region (Optional)
    # 設定内容: アーティファクトストアが配置されるリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード
    # 用途: クロスリージョンパイプラインの場合に必要。単一リージョンパイプラインでは指定不要
    region = null

    # encryption_key (Optional)
    # 設定内容: アーティファクトストア内のデータ暗号化に使用する暗号化キーを指定します。
    # 注意: 指定しない場合、S3のデフォルト暗号化キーが使用されます
    encryption_key {
      # id (Required)
      # 設定内容: KMSキーのARNまたはIDを指定します。
      # 設定可能な値: 有効なKMS Key ARNまたはID
      id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

      # type (Required)
      # 設定内容: 暗号化キーのタイプを指定します。
      # 設定可能な値: "KMS"（現在はKMSのみサポート）
      type = "KMS"
    }
  }

  #-------------------------------------------------------------
  # ステージ設定（必須、最小2ステージ）
  #-------------------------------------------------------------

  stage {
    # name (Required)
    # 設定内容: ステージの名前を指定します。
    # 設定可能な値: 文字列（パイプライン内で一意である必要があります）
    # 注意: 最初のステージには少なくとも1つのソースアクションが必要です
    name = "Source"

    # action (Required)
    # 設定内容: ステージ内で実行されるアクションを定義します。
    # 注意: 各ステージには少なくとも1つのアクションが必要です
    action {
      # name (Required)
      # 設定内容: アクションの名前を指定します。
      # 設定可能な値: ステージ内で一意の文字列
      name = "Source"

      # category (Required)
      # 設定内容: ステージで実行できるアクションの種類を定義します。
      # 設定可能な値: "Approval", "Build", "Deploy", "Invoke", "Source", "Test"
      # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html
      category = "Source"

      # owner (Required)
      # 設定内容: アクションの所有者を指定します。
      # 設定可能な値:
      #   - "AWS": AWSが提供するアクション
      #   - "ThirdParty": サードパーティが提供するアクション
      #   - "Custom": カスタムアクション
      owner = "AWS"

      # provider (Required)
      # 設定内容: アクションで呼び出されるサービスのプロバイダーを指定します。
      # 設定可能な値: アクションカテゴリーによって有効なプロバイダーが決まります
      # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html
      provider = "CodeStarSourceConnection"

      # version (Required)
      # 設定内容: アクションタイプを識別する文字列を指定します。
      # 設定可能な値: 通常は "1"
      version = "1"

      # configuration (Optional)
      # 設定内容: アクション宣言の設定を指定します。
      # 設定可能な値: アクションタイプとプロバイダーによって異なるキーと値のマップ
      # 注意: DetectChangesパラメーター（オプション、デフォルトtrue）を使用すると、
      #       新しいコミット時にCodePipelineが自動的にパイプラインを開始します
      # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements
      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:ap-northeast-1:123456789012:connection/example"
        FullRepositoryId = "example-org/example-repo"
        BranchName       = "main"
      }

      # output_artifacts (Optional)
      # 設定内容: 出力するアーティファクトの名前のリストを指定します。
      # 設定可能な値: 文字列のリスト
      # 注意: 出力アーティファクト名はパイプライン内で一意である必要があります
      output_artifacts = ["source_output"]

      # input_artifacts (Optional)
      # 設定内容: 処理対象となるアーティファクトの名前のリストを指定します。
      # 設定可能な値: 文字列のリスト
      input_artifacts = []

      # role_arn (Optional)
      # 設定内容: 宣言されたアクションを実行するIAMサービスロールのARNを指定します。
      # 設定可能な値: 有効なIAM Role ARN
      # 注意: このロールは、パイプラインのroleArnを通じて引き継がれます
      role_arn = null

      # run_order (Optional, Computed)
      # 設定内容: アクションが実行される順序を指定します。
      # 設定可能な値: 正の整数
      # 省略時: 自動的に割り当てられます
      run_order = null

      # region (Optional, Computed)
      # 設定内容: アクションが実行されるリージョンを指定します。
      # 設定可能な値: 有効なAWSリージョンコード
      # 省略時: パイプラインのリージョンが使用されます
      region = null

      # namespace (Optional)
      # 設定内容: すべての出力変数がアクセスされる名前空間を指定します。
      # 設定可能な値: 文字列
      # 用途: アクションの出力変数を後続のアクションで参照する際に使用
      namespace = null

      # timeout_in_minutes (Optional)
      # 設定内容: アクションのタイムアウト時間（分）を指定します。
      # 設定可能な値: 正の整数
      timeout_in_minutes = null
    }

    # before_entry (Optional)
    # 設定内容: ステージが開始する前に評価される条件を設定します。
    # 関連機能: ステージ開始前条件
    #   条件が満たされた場合にのみステージへのエントリーを許可します。
    before_entry {
      condition {
        # result (Optional)
        # 設定内容: 条件が満たされた場合のアクションを指定します。
        # 設定可能な値: "ROLLBACK", "FAIL", "RETRY", "SKIP"
        result = null

        # rule (Optional)
        # 設定内容: 条件を構成するルールを定義します。
        # 注意: 最大5つのルールを指定可能
        rule {
          # name (Required)
          # 設定内容: 条件用に作成されるルールの名前を指定します。
          # 設定可能な値: 文字列（例: VariableCheck）
          name = "VariableCheck"

          # rule_type_id (Required)
          # 設定内容: ルールタイプのIDを指定します。
          rule_type_id {
            # category (Required)
            # 設定内容: ステージで実行できるルールの種類を定義します。
            # 設定可能な値: "Rule"
            category = "Rule"

            # provider (Required)
            # 設定内容: ルールプロバイダーを指定します。
            # 設定可能な値: DeploymentWindowルール等
            # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/rule-reference.html
            provider = "DeploymentWindow"

            # owner (Optional)
            # 設定内容: 呼び出されるルールの作成者を指定します。
            # 設定可能な値: "AWS"（Ownerフィールドの有効な値）
            owner = "AWS"

            # version (Optional)
            # 設定内容: ルールのバージョンを説明する文字列を指定します。
            # 設定可能な値: 文字列
            version = null
          }

          # configuration (Optional)
          # 設定内容: ルールのアクション設定フィールドを指定します。
          # 設定可能な値: ルールタイプとプロバイダーによって異なるキーと値のマップ
          # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/rule-reference.html
          configuration = {}

          # input_artifacts (Optional)
          # 設定内容: ルールの入力アーティファクトフィールドのリストを指定します。
          # 設定可能な値: 文字列のリスト
          input_artifacts = []

          # region (Optional)
          # 設定内容: ルールに関連付けられた条件のリージョンを指定します。
          # 設定可能な値: 有効なAWSリージョンコード
          region = null

          # role_arn (Optional)
          # 設定内容: ルールに関連付けられたパイプラインロールARNを指定します。
          # 設定可能な値: 有効なIAM Role ARN
          role_arn = null

          # timeout_in_minutes (Optional)
          # 設定内容: ルールのアクションタイムアウトを指定します。
          # 設定可能な値: 正の整数（分）
          timeout_in_minutes = null

          # commands (Optional)
          # 設定内容: CodePipelineでコマンドルールと共に実行するシェルコマンドを指定します。
          # 設定可能な値: 文字列のリスト
          # 注意: 複数行形式以外のすべてのコマンドがサポートされます
          commands = []
        }
      }
    }

    # on_success (Optional)
    # 設定内容: ステージが成功した際に使用するメソッドを設定します。
    # 関連機能: ステージ成功時の条件
    #   条件が満たされた場合にステージを成功とします。
    on_success {
      condition {
        # result (Optional)
        # 設定内容: 条件が満たされた場合のアクションを指定します。
        # 設定可能な値: "ROLLBACK", "FAIL", "RETRY", "SKIP"
        result = null

        # rule (Optional)
        # 設定内容: 条件を構成するルールを定義します。
        # 注意: 最大5つのルールを指定可能
        rule {
          # name (Required)
          # 設定内容: 条件用に作成されるルールの名前を指定します。
          name = "SuccessRule"

          # rule_type_id (Required)
          rule_type_id {
            # category (Required)
            category = "Rule"

            # provider (Required)
            provider = "DeploymentWindow"

            # owner (Optional)
            owner = "AWS"

            # version (Optional)
            version = null
          }

          # configuration (Optional)
          configuration = {}

          # input_artifacts (Optional)
          input_artifacts = []

          # region (Optional)
          region = null

          # role_arn (Optional)
          role_arn = null

          # timeout_in_minutes (Optional)
          timeout_in_minutes = null

          # commands (Optional)
          commands = []
        }
      }
    }

    # on_failure (Optional)
    # 設定内容: ステージが成功しなかった場合に使用するメソッドを設定します。
    # 関連機能: ステージ失敗時のロールバック
    #   ロールバックを設定すると、失敗したステージを最後に成功したパイプライン実行に
    #   自動的にロールバックできます。
    #   - https://aws.amazon.com/about-aws/whats-new/2024/10/aws-codepipeline-automatic-retry-stage-failure/
    on_failure {
      # result (Optional)
      # 設定内容: 条件が満たされた場合のアクションを指定します。
      # 設定可能な値: "ROLLBACK", "FAIL", "RETRY", "SKIP"
      result = "RETRY"

      # condition (Optional)
      # 設定内容: 失敗条件として設定される条件を定義します。
      condition {
        # result (Optional)
        result = null

        # rule (Optional)
        rule {
          # name (Required)
          name = "FailureRule"

          # rule_type_id (Required)
          rule_type_id {
            # category (Required)
            category = "Rule"

            # provider (Required)
            provider = "DeploymentWindow"

            # owner (Optional)
            owner = "AWS"

            # version (Optional)
            version = null
          }

          # configuration (Optional)
          configuration = {}

          # input_artifacts (Optional)
          input_artifacts = []

          # region (Optional)
          region = null

          # role_arn (Optional)
          role_arn = null

          # timeout_in_minutes (Optional)
          timeout_in_minutes = null

          # commands (Optional)
          commands = []
        }
      }

      # retry_configuration (Optional)
      # 設定内容: 失敗したステージの自動再試行の設定を指定します。
      # 関連機能: ステージ失敗時の自動再試行
      #   設定された再試行モードに従って、自動的にステージを再試行します。
      #   - https://aws.amazon.com/about-aws/whats-new/2024/10/aws-codepipeline-automatic-retry-stage-failure/
      retry_configuration {
        # retry_mode (Optional)
        # 設定内容: ステージ失敗時の自動再試行方法を設定します。
        # 設定可能な値:
        #   - "FAILED_ACTIONS": 失敗したアクションのみを再試行
        #   - "ALL_ACTIONS": ステージ内のすべてのアクションを再試行
        retry_mode = "FAILED_ACTIONS"
      }
    }
  }

  # 2つ目のステージ（最低2ステージ必要）
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "example-build-project"
      }
    }
  }

  #-------------------------------------------------------------
  # トリガー設定（V2パイプラインのみ）
  #-------------------------------------------------------------

  # trigger (Optional)
  # 設定内容: トリガーブロックを定義します。
  # 注意: pipeline_typeが"V2"の場合のみ有効。最大50個のトリガーを指定可能
  # 関連機能: CodePipeline トリガー
  #   パイプラインを特定のイベントタイプで開始させ、ブランチ、ファイルパス、タグ、
  #   プルリクエストイベントに基づいてフィルタリングできます。
  #   - https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-filter.html
  # trigger {
  #   # provider_type (Required)
  #   # 設定内容: イベントのソースプロバイダーを指定します。
  #   # 設定可能な値: "CodeStarSourceConnection"
  #   provider_type = "CodeStarSourceConnection"
  #
  #   # git_configuration (Required)
  #   # 設定内容: パイプラインを開始するリポジトリイベントのフィルター条件とソースステージを提供します。
  #   git_configuration {
  #     # source_action_name (Required)
  #     # 設定内容: Gitタグなどのトリガー設定が指定されているパイプラインソースアクションの名前を指定します。
  #     # 注意: 指定された変更時にのみトリガー設定はパイプラインを開始します
  #     source_action_name = "Source"
  #
  #     # pull_request (Optional)
  #     # 設定内容: プルリクエストとして指定されたリポジトリイベントのフィールドを定義します。
  #     # 注意: 最大3つのpull_requestブロックを指定可能
  #     pull_request {
  #       # events (Optional)
  #       # 設定内容: トリガー設定でフィルタリングするプルリクエストイベントを指定します。
  #       # 設定可能な値: "OPEN", "UPDATED", "CLOSED"
  #       events = ["OPEN", "UPDATED"]
  #
  #       # branches (Optional)
  #       # 設定内容: プルリクエストトリガー設定のブランチフィルターを指定します。
  #       branches {
  #         # includes (Optional)
  #         # 設定内容: コミットがプッシュされた際にパイプラインを開始する条件として
  #         #           含めるGitブランチのパターンのリストを指定します。
  #         # 設定可能な値: Gitブランチパターンの文字列リスト
  #         includes = ["main", "develop"]
  #
  #         # excludes (Optional)
  #         # 設定内容: コミットがプッシュされた際にパイプラインの開始から
  #         #           除外するGitブランチのパターンのリストを指定します。
  #         # 設定可能な値: Gitブランチパターンの文字列リスト
  #         excludes = ["feature/*"]
  #       }
  #
  #       # file_paths (Optional)
  #       # 設定内容: プルリクエストトリガー設定のファイルパスフィルターを指定します。
  #       file_paths {
  #         # includes (Optional)
  #         # 設定内容: コミットがプッシュされた際にパイプラインを開始する条件として
  #         #           含めるGitリポジトリファイルパスのパターンのリストを指定します。
  #         includes = ["src/**"]
  #
  #         # excludes (Optional)
  #         # 設定内容: コミットがプッシュされた際にパイプラインの開始から
  #         #           除外するGitリポジトリファイルパスのパターンのリストを指定します。
  #         excludes = ["README.md"]
  #       }
  #     }
  #
  #     # push (Optional)
  #     # 設定内容: Gitタグのプッシュなど、パイプラインを開始するリポジトリイベントのフィールドを定義します。
  #     # 注意: 最大3つのpushブロックを指定可能
  #     push {
  #       # branches (Optional)
  #       # 設定内容: プッシュトリガー設定のブランチフィルターを指定します。
  #       branches {
  #         # includes (Optional)
  #         includes = ["main"]
  #
  #         # excludes (Optional)
  #         excludes = []
  #       }
  #
  #       # file_paths (Optional)
  #       # 設定内容: プッシュトリガー設定のファイルパスフィルターを指定します。
  #       file_paths {
  #         # includes (Optional)
  #         includes = []
  #
  #         # excludes (Optional)
  #         excludes = []
  #       }
  #
  #       # tags (Optional)
  #       # 設定内容: Gitタグトリガー設定の詳細を含むフィールドを指定します。
  #       tags {
  #         # includes (Optional)
  #         # 設定内容: プッシュされた際にパイプラインを開始する条件として
  #         #           含めるGitタグのパターンのリストを指定します。
  #         includes = ["v*"]
  #
  #         # excludes (Optional)
  #         # 設定内容: プッシュされた際にパイプラインの開始から
  #         #           除外するGitタグのパターンのリストを指定します。
  #         excludes = []
  #       }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # 変数設定（V2パイプラインのみ）
  #-------------------------------------------------------------

  # variable (Optional)
  # 設定内容: パイプラインレベルの変数ブロックを定義します。
  # 注意: pipeline_typeが"V2"の場合のみ有効
  # 関連機能: パイプラインレベル変数
  #   パイプラインレベルで変数を定義し、パイプライン実行時に解決されます。
  #   - https://docs.aws.amazon.com/codepipeline/latest/userguide/pipeline-requirements.html
  # variable {
  #   # name (Required)
  #   # 設定内容: パイプラインレベル変数の名前を指定します。
  #   # 設定可能な値: 文字列
  #   name = "ENVIRONMENT"
  #
  #   # default_value (Optional)
  #   # 設定内容: パイプラインレベル変数のデフォルト値を指定します。
  #   # 設定可能な値: 文字列
  #   default_value = "production"
  #
  #   # description (Optional)
  #   # 設定内容: パイプラインレベル変数の説明を指定します。
  #   # 設定可能な値: 文字列
  #   description = "Deployment environment"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: CodePipeline ID
#
# - arn: CodePipeline ARN
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - trigger_all: パイプライン上に存在するすべてのトリガーのリスト。
#                明示的なtrigger定義を省略したV2パイプライン用にAWSが追加した
#                デフォルトトリガーを含みます
#---------------------------------------------------------------
