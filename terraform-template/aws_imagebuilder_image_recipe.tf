#---------------------------------------------------------------
# Amazon Image Builder イメージレシピ
#---------------------------------------------------------------
#
# Amazon Image Builder のイメージレシピを管理するリソースです。
# イメージレシピは、ベースイメージとコンポーネントの組み合わせを定義し、
# EC2 AMI を構築するための設定を記述します。
# ブロックデバイスマッピングやSystems Manager エージェント設定なども
# 含めることができます。
#
# AWS公式ドキュメント:
#   - Image Builder イメージレシピ: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-recipes.html
#   - Image Builder コンポーネント: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-components.html
#   - Systems Manager エージェント: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-setting-up.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_recipe
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_image_recipe" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: イメージレシピの名前を指定します。
  # 設定可能な値: 最大128文字の英字、数字、ハイフン、アンダースコア
  name = "example-image-recipe"

  # parent_image (Required)
  # 設定内容: ベースイメージを指定します。
  #          このイメージからカスタマイズされたイメージを構築します。
  # 設定可能な値:
  #   - Image Builder ベースイメージのARN
  #     例: arn:aws:imagebuilder:ap-northeast-1:aws:image/amazon-linux-2-x86/x.x.x
  #   - AMI ID（例: ami-0abcdef1234567890）
  #   - SSM パラメーター参照（例: ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2）
  parent_image = "arn:aws:imagebuilder:ap-northeast-1:aws:image/amazon-linux-2-x86/x.x.x"

  # version (Required)
  # 設定内容: イメージレシピのセマンティックバージョンを指定します。
  # 設定可能な値: major.minor.patch 形式（例: 1.0.0）
  # 注意: バージョンは変更後に新しいレシピが作成されます（変更不可）
  version = "1.0.0"

  # description (Optional)
  # 設定内容: イメージレシピの説明を指定します。
  # 設定可能な値: 任意の文字列
  description = null

  #-------------------------------------------------------------
  # コンポーネント設定
  #-------------------------------------------------------------

  # component (Required)
  # 設定内容: イメージレシピに関連付けるコンポーネントを順序付きで指定します。
  #          コンポーネントはビルドフェーズとテストフェーズで実行されます。
  # 注意: 少なくとも1つのコンポーネントを指定する必要があります。
  #       コンポーネントは定義した順序で実行されます。
  component {
    # component_arn (Required)
    # 設定内容: 関連付けるImage Builderコンポーネントの ARN を指定します。
    # 設定可能な値: aws_imagebuilder_component リソースの ARN
    component_arn = "arn:aws:imagebuilder:ap-northeast-1:aws:component/amazon-cloudwatch-agent-linux/x.x.x"

    # parameter (Optional)
    # 設定内容: コンポーネントに渡すパラメーターを指定するブロックです。
    # 注意: 複数のparameterブロックを指定できます
    parameter {
      # name (Required)
      # 設定内容: コンポーネントパラメーターの名前を指定します。
      # 設定可能な値: コンポーネントで定義されたパラメーター名
      name = "Parameter1"

      # value (Required)
      # 設定内容: 名前付きコンポーネントパラメーターの値を指定します。
      # 設定可能な値: パラメーターの型に応じた値
      value = "Value1"
    }
  }

  #-------------------------------------------------------------
  # ブロックデバイスマッピング設定
  #-------------------------------------------------------------

  # block_device_mapping (Optional)
  # 設定内容: イメージレシピのブロックデバイスマッピングを指定するブロックです。
  #          AMI に含まれるボリュームの構成を定義します。
  # 注意: 複数のblock_device_mappingブロックを指定できます
  block_device_mapping {
    # device_name (Optional)
    # 設定内容: デバイス名を指定します。
    # 設定可能な値: デバイス名（例: /dev/sda, /dev/xvdb）
    device_name = "/dev/xvdb"

    # no_device (Optional)
    # 設定内容: 親イメージのマッピングを削除するかどうかを指定します。
    # 設定可能な値: true（マッピングを削除）, false（マッピングを保持）
    # 省略時: false
    no_device = false

    # virtual_name (Optional)
    # 設定内容: 仮想デバイス名を指定します。
    # 設定可能な値: ephemeral0 から始まるインスタンスストアボリューム名
    #              （例: ephemeral0, ephemeral1）
    # 注意: ebsブロックとvirtual_nameは同時に指定できません
    virtual_name = null

    # ebs (Optional)
    # 設定内容: EBS ブロックデバイスマッピングの設定を指定するブロックです。
    # 注意: virtual_nameとebsは同時に指定できません
    ebs {
      # delete_on_termination (Optional)
      # 設定内容: インスタンス終了時にボリュームを削除するかどうかを指定します。
      # 設定可能な値: true（終了時に削除）, false（保持）
      # 省略時: 親イメージから継承した値
      delete_on_termination = true

      # encrypted (Optional)
      # 設定内容: ボリュームを暗号化するかどうかを指定します。
      # 設定可能な値: true（暗号化有効）, false（暗号化無効）
      # 省略時: 親イメージから継承した値
      encrypted = false

      # iops (Optional)
      # 設定内容: io1 または io2 ボリュームにプロビジョニングする
      #          1秒あたりのI/O操作数を指定します。
      # 設定可能な値:
      #   - io1: 100〜64,000 IOPS
      #   - io2: 100〜256,000 IOPS
      # 注意: io1またはio2ボリュームタイプでのみ有効です
      iops = null

      # kms_key_id (Optional)
      # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
      # 設定可能な値: KMSキーのARN
      # 注意: encryptedがtrueの場合に指定します
      kms_key_id = null

      # snapshot_id (Optional)
      # 設定内容: EC2 ボリュームスナップショットのIDを指定します。
      # 設定可能な値: EC2スナップショットID（例: snap-0abcdef1234567890）
      snapshot_id = null

      # throughput (Optional)
      # 設定内容: GP3 ボリュームのスループットを MiB/s 単位で指定します。
      # 設定可能な値: 125〜1000 MiB/s
      # 注意: gp3ボリュームタイプでのみ有効です
      throughput = null

      # volume_size (Optional)
      # 設定内容: ボリュームのサイズを GiB 単位で指定します。
      # 設定可能な値: ボリュームタイプに応じたサイズ（GiB）
      volume_size = 100

      # volume_type (Optional)
      # 設定内容: ボリュームの種類を指定します。
      # 設定可能な値:
      #   - "gp2": 汎用 SSD（旧世代）
      #   - "gp3": 汎用 SSD（推奨）
      #   - "io1": プロビジョンド IOPS SSD（旧世代）
      #   - "io2": プロビジョンド IOPS SSD（推奨）
      #   - "st1": スループット最適化 HDD
      #   - "sc1": コールド HDD
      #   - "standard": マグネティック
      volume_type = "gp3"
    }
  }

  #-------------------------------------------------------------
  # Systems Manager エージェント設定
  #-------------------------------------------------------------

  # systems_manager_agent (Optional)
  # 設定内容: Image Builder がデフォルトでインストールする
  #          Systems Manager エージェントの設定を指定するブロックです。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-setting-up.html
  systems_manager_agent {
    # uninstall_after_build (Required)
    # 設定内容: イメージのビルド後にSystems Manager エージェントを
    #          アンインストールするかどうかを指定します。
    # 設定可能な値: true（ビルド後にアンインストール）, false（インストール済みのまま）
    uninstall_after_build = false
  }

  #-------------------------------------------------------------
  # ユーザーデータ設定
  #-------------------------------------------------------------

  # user_data_base64 (Optional)
  # 設定内容: ビルドインスタンス起動時に実行するコマンドまたはスクリプトを
  #          Base64 エンコード形式で指定します。
  # 設定可能な値: Base64エンコードされたユーザーデータ文字列
  # 注意: filebase64()関数を使用してファイルをBase64エンコードできます
  user_data_base64 = null

  #-------------------------------------------------------------
  # ワーキングディレクトリ設定
  #-------------------------------------------------------------

  # working_directory (Optional)
  # 設定内容: ビルドおよびテストワークフロー中に使用するワーキングディレクトリを指定します。
  # 設定可能な値: 絶対パス（例: /tmp/imagebuilder）
  # 省略時: デフォルトのワーキングディレクトリを使用
  working_directory = null

  #-------------------------------------------------------------
  # AMI タグ設定
  #-------------------------------------------------------------

  # ami_tags (Optional)
  # 設定内容: Image Builder がビルドフェーズで作成するAMIに適用するタグを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグ）
  # 注意: tagsとは異なり、ami_tagsはレシピリソース自体ではなく
  #       生成されるAMIに適用されます
  ami_tags = {
    Name    = "example-ami"
    Builder = "ImageBuilder"
  }

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
  # 設定内容: イメージレシピリソース自体に割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-image-recipe"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: イメージレシピのARN
#
# - arn: イメージレシピのARN
#
# - date_created: イメージレシピが作成された日時
#
# - owner: イメージレシピの所有者
#
# - platform: イメージレシピのプラットフォーム（例: Linux, Windows）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
