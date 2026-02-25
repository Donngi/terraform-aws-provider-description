#---------------------------------------------------------------
# AWS Image Builder コンテナレシピ
#---------------------------------------------------------------
#
# AWS Image Builder でコンテナイメージを構築するためのレシピをプロビジョニングするリソースです。
# コンテナレシピは、Dockerfileテンプレートとコンポーネントの組み合わせにより、
# コンテナイメージのビルド手順を定義します。
# ビルドしたイメージはAmazon ECRなどのコンテナリポジトリに配信できます。
#
# AWS公式ドキュメント:
#   - Image Builder コンテナレシピ: https://docs.aws.amazon.com/imagebuilder/latest/userguide/create-container-recipes.html
#   - Image Builder コンポーネント: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-components.html
#   - Image Builder コンテナイメージ: https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_container_recipe
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_container_recipe" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コンテナレシピの名前を指定します。
  # 設定可能な値: 最大128文字の英字、数字、ハイフン、アンダースコア
  name = "example-container-recipe"

  # version (Required)
  # 設定内容: コンテナレシピのバージョンを指定します。
  # 設定可能な値: セマンティックバージョン形式（major.minor.patch）
  # 注意: バージョンを変更するとリソースが再作成されます
  version = "1.0.0"

  # container_type (Required)
  # 設定内容: 作成するコンテナの種類を指定します。
  # 設定可能な値:
  #   - "DOCKER": Dockerコンテナイメージを作成する
  container_type = "DOCKER"

  # parent_image (Required)
  # 設定内容: コンテナイメージのベースとなる親イメージを指定します。
  # 設定可能な値:
  #   - Image BuilderのイメージARN（例: arn:aws:imagebuilder:...）
  #   - DockerHubなどのコンテナリポジトリイメージ参照（例: amazonlinux:latest）
  parent_image = "arn:aws:imagebuilder:ap-northeast-1:aws:image/amazon-linux-x86-latest/x.x.x"

  # description (Optional)
  # 設定内容: コンテナレシピの説明を指定します。
  # 設定可能な値: 最大1024文字の文字列
  # 省略時: 説明なし
  description = "Example container recipe"

  # dockerfile_template_data (Optional)
  # 設定内容: Dockerfileテンプレートの内容を直接指定します。
  # 設定可能な値: Dockerfileの内容を含む文字列（Image Builderテンプレート変数が使用可能）
  # 省略時: dockerfile_template_uriで指定するか、デフォルトテンプレートを使用
  # 注意: dockerfile_template_data と dockerfile_template_uri は同時に指定できません
  # 注意: テンプレート変数として {{{ imagebuilder:parentImage }}} などが使用可能です
  dockerfile_template_data = <<-EOT
    FROM {{{ imagebuilder:parentImage }}}
    {{{ imagebuilder:components }}}
  EOT

  # dockerfile_template_uri (Optional)
  # 設定内容: S3に保存されたDockerfileテンプレートのURIを指定します。
  # 設定可能な値: s3://バケット名/キー 形式のS3 URI
  # 省略時: dockerfile_template_dataを使用
  # 注意: dockerfile_template_data と dockerfile_template_uri は同時に指定できません
  dockerfile_template_uri = null

  # kms_key_id (Optional)
  # 設定内容: コンテナレシピを暗号化するKMSキーのIDを指定します。
  # 設定可能な値: KMSキーのARNまたはキーID
  # 省略時: AWSマネージドキーを使用
  kms_key_id = null

  # platform_override (Optional)
  # 設定内容: コンテナレシピのプラットフォームを上書きする値を指定します。
  # 設定可能な値:
  #   - "Linux": Linuxプラットフォーム
  #   - "Windows": Windowsプラットフォーム
  # 省略時: 親イメージから自動的に検出
  platform_override = null

  # working_directory (Optional)
  # 設定内容: ビルド中および実行中に使用するデフォルトの作業ディレクトリを指定します。
  # 設定可能な値: 絶対パスの文字列
  # 省略時: イメージのデフォルト作業ディレクトリを使用
  working_directory = "/tmp"

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
    Name        = "example-container-recipe"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # コンポーネント設定
  #-------------------------------------------------------------

  # component (Required)
  # 設定内容: コンテナレシピに含めるコンポーネントのリストを指定します。
  # 注意: 少なくとも1つのcomponentブロックが必須です
  # 注意: コンポーネントはリスト内の順序で実行されます
  # 関連機能: Image Builder コンポーネント
  #   ビルドおよびテストフェーズで実行するスクリプトと設定を定義します。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-components.html
  component {
    # component_arn (Required)
    # 設定内容: 使用するコンポーネントのARNを指定します。
    # 設定可能な値: aws_imagebuilder_componentリソースのARN、またはAWS管理コンポーネントのARN
    component_arn = "arn:aws:imagebuilder:ap-northeast-1:aws:component/update-linux/x.x.x"

    # parameter (Optional)
    # 設定内容: コンポーネントに渡すパラメーターを指定します。
    # 注意: 複数のparameterブロックを指定できます
    parameter {
      # name (Required)
      # 設定内容: パラメーターの名前を指定します。
      # 設定可能な値: コンポーネントで定義されたパラメーター名
      name = "Parameter1"

      # value (Required)
      # 設定内容: パラメーターの値を指定します。
      # 設定可能な値: パラメーターの型に応じた文字列値
      value = "value1"
    }
  }

  #-------------------------------------------------------------
  # ターゲットリポジトリ設定
  #-------------------------------------------------------------

  # target_repository (Required)
  # 設定内容: ビルドしたコンテナイメージの配信先リポジトリを指定します。
  # 注意: このブロックは必須です（1つのみ指定可能）
  target_repository {
    # repository_name (Required)
    # 設定内容: コンテナイメージを配信するリポジトリの名前を指定します。
    # 設定可能な値: ECRリポジトリ名（例: "my-app/container"）
    repository_name = "my-container-repository"

    # service (Required)
    # 設定内容: 配信先のコンテナサービスを指定します。
    # 設定可能な値:
    #   - "ECR": Amazon Elastic Container Registry
    service = "ECR"
  }

  #-------------------------------------------------------------
  # インスタンス設定
  #-------------------------------------------------------------

  # instance_configuration (Optional)
  # 設定内容: コンテナイメージのビルドに使用するインスタンスの設定を指定します。
  # 省略時: デフォルトのインスタンス設定を使用
  # 注意: このブロックは最大1つまで指定できます
  instance_configuration {
    # image (Optional)
    # 設定内容: ビルドに使用するEC2インスタンスのAMI IDを指定します。
    # 設定可能な値: AMI ID（例: "ami-xxxxxxxxxxxxxxxxx"）またはAMI ARN
    # 省略時: Image Builderがプラットフォームに適切なAMIを自動選択
    image = null

    # block_device_mapping (Optional)
    # 設定内容: ビルドインスタンスにアタッチするブロックデバイスのマッピングを指定します。
    # 注意: 複数のblock_device_mappingブロックを指定できます
    block_device_mapping {
      # device_name (Optional)
      # 設定内容: ボリュームをアタッチするデバイス名を指定します。
      # 設定可能な値: デバイス名（例: "/dev/xvda", "/dev/sda1"）
      # 省略時: デフォルトのデバイス名を使用
      device_name = "/dev/xvda"

      # no_device (Optional)
      # 設定内容: ブロックデバイスを明示的に抑制するかどうかを指定します。
      # 設定可能な値: true, false
      # 省略時: false（デバイスを抑制しない）
      # 注意: trueを指定した場合、ebsやvirtual_nameを同時に指定することはできません
      no_device = false

      # virtual_name (Optional)
      # 設定内容: 仮想デバイスの名前を指定します。
      # 設定可能な値: "ephemeral0"〜"ephemeral23" などの仮想デバイス名（インスタンスストアボリューム用）
      # 省略時: 仮想デバイスを使用しない
      virtual_name = null

      # ebs (Optional)
      # 設定内容: EBSボリュームの設定を指定します。
      # 注意: このブロックは最大1つまで指定できます
      ebs {
        # delete_on_termination (Optional)
        # 設定内容: インスタンス終了時にEBSボリュームを削除するかどうかを指定します。
        # 設定可能な値: "true", "false"（文字列として指定）
        # 省略時: "true"（ルートデバイスの場合）または "false"（その他のデバイスの場合）
        delete_on_termination = "true"

        # encrypted (Optional)
        # 設定内容: EBSボリュームを暗号化するかどうかを指定します。
        # 設定可能な値: "true", "false"（文字列として指定）
        # 省略時: デフォルトの暗号化設定を使用
        encrypted = "true"

        # iops (Optional)
        # 設定内容: EBSボリュームのIOPS数を指定します。
        # 設定可能な値: io1/io2は100〜64000、gp3は3000〜16000
        # 省略時: ボリュームタイプのデフォルト値
        # 注意: volume_typeがio1、io2、またはgp3の場合のみ有効
        iops = null

        # kms_key_id (Optional)
        # 設定内容: EBSボリュームの暗号化に使用するKMSキーのARNを指定します。
        # 設定可能な値: KMSキーのARNまたはキーID
        # 省略時: AWSマネージドキーを使用
        # 注意: encryptedが "true" の場合のみ有効
        kms_key_id = null

        # snapshot_id (Optional)
        # 設定内容: EBSボリュームの作成元スナップショットのIDを指定します。
        # 設定可能な値: EBSスナップショットID（例: "snap-xxxxxxxxxxxxxxxxx"）
        # 省略時: スナップショットからではなく空のボリュームを作成
        snapshot_id = null

        # throughput (Optional)
        # 設定内容: EBSボリュームのスループットをMiB/s単位で指定します。
        # 設定可能な値: 125〜1000（MiB/s）
        # 省略時: ボリュームタイプのデフォルト値
        # 注意: volume_typeがgp3の場合のみ有効
        throughput = null

        # volume_size (Optional)
        # 設定内容: EBSボリュームのサイズをGiB単位で指定します。
        # 設定可能な値: 1〜16384 GiB（ボリュームタイプによって異なる）
        # 省略時: スナップショットのサイズまたはデフォルト値
        volume_size = 30

        # volume_type (Optional)
        # 設定内容: EBSボリュームの種類を指定します。
        # 設定可能な値:
        #   - "gp2": 汎用SSD（旧世代）
        #   - "gp3": 汎用SSD（新世代、デフォルト）
        #   - "io1": プロビジョンドIOPS SSD
        #   - "io2": プロビジョンドIOPS SSD（高耐久性）
        #   - "st1": スループット最適化HDD
        #   - "sc1": コールドHDD
        #   - "standard": マグネティック（旧世代）
        # 省略時: "gp2"
        volume_type = "gp3"
      }
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンテナレシピを識別するARN
#
# - date_created: コンテナレシピが作成された日時（ISO 8601形式）
#
# - encrypted: コンテナレシピが暗号化されているかどうか
#
# - id: コンテナレシピのARN（arnと同じ値）
#
# - owner: コンテナレシピを所有するアカウントのID
#
# - platform: コンテナレシピのプラットフォーム（Linux または Windows）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
