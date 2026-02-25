#---------------------------------------------------------------
# AWS Image Builder Image
#---------------------------------------------------------------
#
# AWS Image Builder のイメージをプロビジョニングするリソースです。
# イメージレシピまたはコンテナレシピと、インフラストラクチャ設定を使用して
# AMI またはコンテナイメージを構築します。ワークフロー、イメージテスト、
# イメージスキャンなどのオプションも構成可能です。
#
# AWS公式ドキュメント:
#   - Image Builder イメージ概要: https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html
#   - Image Builder イメージの管理: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-images.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_image" "example" {
  #-------------------------------------------------------------
  # インフラストラクチャ設定
  #-------------------------------------------------------------

  # infrastructure_configuration_arn (Required)
  # 設定内容: Image Builder インフラストラクチャ設定のARNを指定します。
  # 設定可能な値: 有効な aws_imagebuilder_infrastructure_configuration リソースのARN
  infrastructure_configuration_arn = "arn:aws:imagebuilder:ap-northeast-1:123456789012:infrastructure-configuration/example"

  #-------------------------------------------------------------
  # レシピ設定
  #-------------------------------------------------------------

  # image_recipe_arn (Optional)
  # 設定内容: イメージレシピのARNを指定します。AMIイメージを構築する場合に使用します。
  # 設定可能な値: 有効な aws_imagebuilder_image_recipe リソースのARN
  # 注意: image_recipe_arn または container_recipe_arn のいずれか一方を指定する必要があります。
  image_recipe_arn = "arn:aws:imagebuilder:ap-northeast-1:123456789012:image-recipe/example/1.0.0"

  # container_recipe_arn (Optional)
  # 設定内容: コンテナレシピのARNを指定します。コンテナイメージを構築する場合に使用します。
  # 設定可能な値: 有効な aws_imagebuilder_container_recipe リソースのARN
  # 注意: image_recipe_arn または container_recipe_arn のいずれか一方を指定する必要があります。
  container_recipe_arn = null

  #-------------------------------------------------------------
  # ディストリビューション設定
  #-------------------------------------------------------------

  # distribution_configuration_arn (Optional)
  # 設定内容: Image Builder ディストリビューション設定のARNを指定します。
  # 設定可能な値: 有効な aws_imagebuilder_distribution_configuration リソースのARN
  # 省略時: イメージはデフォルトのディストリビューション設定で構築されます。
  distribution_configuration_arn = "arn:aws:imagebuilder:ap-northeast-1:123456789012:distribution-configuration/example"

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # enhanced_image_metadata_enabled (Optional)
  # 設定内容: イメージ作成時に追加のメタデータ（AMI情報等）を収集するかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 追加メタデータを収集します。
  #   - false: 追加メタデータを収集しません。
  # 省略時: true
  enhanced_image_metadata_enabled = true

  #-------------------------------------------------------------
  # 実行ロール設定
  #-------------------------------------------------------------

  # execution_role (Optional)
  # 設定内容: Image Builder がワークフローを実行するために使用するサービスリンクロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: Image Builder はデフォルトのサービスロールを使用します。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-image-workflows.html
  execution_role = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # イメージスキャン設定
  #-------------------------------------------------------------

  # image_scanning_configuration (Optional)
  # 設定内容: Amazon Inspector によるイメージの脆弱性スキャン設定ブロックです。
  # 関連機能: Image Builder イメージスキャン
  #   Amazon Inspector を使用してビルドインスタンスの脆弱性スキャンを実施し、
  #   スナップショットを保持することができます。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-scanning.html
  image_scanning_configuration {

    # image_scanning_enabled (Optional)
    # 設定内容: Amazon Inspector による脆弱性スキャンのスナップショットを保持するかを指定します。
    # 設定可能な値:
    #   - true: スキャンスナップショットを保持します。
    #   - false (デフォルト): スキャンスナップショットを保持しません。
    # 省略時: false
    image_scanning_enabled = false

    #-----------------------------------------------------------
    # ECR設定
    #-----------------------------------------------------------

    # ecr_configuration (Optional)
    # 設定内容: Amazon Inspector がスキャンするECRリポジトリの設定ブロックです。
    ecr_configuration {

      # repository_name (Optional)
      # 設定内容: Amazon Inspector がスキャンするコンテナリポジトリの名前を指定します。
      # 設定可能な値: 有効なECRリポジトリ名
      repository_name = "example-repository"

      # container_tags (Optional)
      # 設定内容: Amazon Inspector がスキャンするコンテナイメージに適用するタグのセットを指定します。
      # 設定可能な値: タグ文字列のセット
      container_tags = ["latest", "production"]
    }
  }

  #-------------------------------------------------------------
  # イメージテスト設定
  #-------------------------------------------------------------

  # image_tests_configuration (Optional)
  # 設定内容: イメージテストの設定ブロックです。
  # 関連機能: Image Builder イメージテスト
  #   構築後のイメージに対して自動テストを実施する機能です。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-testing.html
  image_tests_configuration {

    # image_tests_enabled (Optional)
    # 設定内容: イメージテストを有効にするかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): イメージテストを有効にします。
    #   - false: イメージテストを無効にします。
    # 省略時: true
    image_tests_enabled = true

    # timeout_minutes (Optional)
    # 設定内容: イメージテストのタイムアウト時間を分単位で指定します。
    # 設定可能な値: 60 〜 1440 の整数
    # 省略時: 720 (12時間)
    timeout_minutes = 720
  }

  #-------------------------------------------------------------
  # ロギング設定
  #-------------------------------------------------------------

  # logging_configuration (Optional)
  # 設定内容: ログの送信先に関する設定ブロックです。
  logging_configuration {

    # log_group_name (Required)
    # 設定内容: ログの送信先となる CloudWatch Logs グループ名を指定します。
    # 設定可能な値: 有効な CloudWatch Logs グループ名
    log_group_name = "/aws/imagebuilder/example"
  }

  #-------------------------------------------------------------
  # ワークフロー設定
  #-------------------------------------------------------------

  # workflow (Optional)
  # 設定内容: イメージ構築に使用するワークフローの設定ブロックです（複数指定可）。
  # 関連機能: Image Builder ワークフロー
  #   イメージ構築プロセスをカスタマイズするためのワークフローを指定します。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-image-workflows.html
  workflow {

    # workflow_arn (Required)
    # 設定内容: Image Builder ワークフローのARNを指定します。
    # 設定可能な値: 有効な Image Builder ワークフローのARN
    workflow_arn = "arn:aws:imagebuilder:ap-northeast-1:123456789012:workflow/build/example/1.0.0"

    # on_failure (Optional)
    # 設定内容: ワークフローが失敗した場合のアクションを指定します。
    # 設定可能な値:
    #   - "CONTINUE": ワークフロー失敗時も後続の処理を継続します。
    #   - "ABORT": ワークフロー失敗時に処理を中止します。
    # 省略時: Image Builder のデフォルト動作に従います。
    on_failure = "ABORT"

    # parallel_group (Optional)
    # 設定内容: テストワークフローを並列実行するグループ名を指定します。
    # 設定可能な値: グループ名の文字列
    # 省略時: 並列グループは設定されません。
    parallel_group = null

    # parameter (Optional)
    # 設定内容: ワークフローのパラメータ設定ブロックです（複数指定可）。
    parameter {

      # name (Required)
      # 設定内容: ワークフローパラメータの名前を指定します。
      # 設定可能な値: 有効なパラメータ名の文字列
      name = "example-parameter"

      # value (Required)
      # 設定内容: ワークフローパラメータの値を指定します。
      # 設定可能な値: パラメータ値の文字列
      value = "example-value"
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "60m", "1h30m" 等の Go duration 形式の文字列
    # 省略時: Terraform のデフォルトタイムアウトが適用されます。
    create = "60m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-image"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: イメージのAmazon Resource Name (ARN)。id と同じ値です。
# - date_created: イメージが作成された日時。
# - name: イメージの名前。
# - os_version: イメージのオペレーティングシステムバージョン。
# - platform: イメージのプラットフォーム（例: Linux, Windows）。
# - version: イメージのバージョン。
# - output_resources: イメージによって作成されたリソースのリスト。
#   - amis: 作成された各AMIオブジェクトのセット（account_id, description, image, name, region）。
#   - containers: 作成された各コンテナイメージのセット（image_uris, region）。
# - tags_all: プロバイダーの default_tags 設定から継承されたタグを含む全タグマップ。
#---------------------------------------------------------------
