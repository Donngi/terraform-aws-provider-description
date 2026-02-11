# AWS ImageBuilder Image Recipe - Terraform Resource Template
# Provider Version: 6.28.0
# Resource: aws_imagebuilder_image_recipe
# AWS Documentation: https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html
# Terraform Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_recipe

# 概要 (Overview)
# EC2 Image Builder Image Recipeは、カスタマイズされたAMIやコンテナイメージを作成するための
# 設定を定義するリソースです。Image Recipeには、ベースイメージ、コンポーネント、ブロックデバイス
# マッピング、およびその他のカスタマイズ設定が含まれます。
# Image Recipeを使用すると、一貫性のある再現可能な方法でイメージを作成できます。

resource "aws_imagebuilder_image_recipe" "example" {
  # ====================
  # 必須パラメータ (Required Parameters)
  # ====================

  # name (必須)
  # Image Recipeの名前を指定します。
  # この名前は、AWS Image BuilderコンソールやAPIで表示される識別子として使用されます。
  # 命名規則に従い、わかりやすい名前を付けることを推奨します。
  name = "example-image-recipe"

  # version (必須)
  # Image Recipeのセマンティックバージョンを指定します。
  # 形式: major.minor.patch (例: 1.0.0)
  # バージョン管理により、異なるバージョンのレシピを追跡し、管理できます。
  version = "1.0.0"

  # parent_image (必須)
  # カスタマイズのベースとなる親イメージを指定します。
  # 指定できる値:
  #   - Image Builder managed imageのARN
  #   - AMI ID
  #   - SSM Parameterの参照 (プレフィックス "ssm:" を使用)
  # 例:
  #   - ARN: "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
  #   - AMI ID: "ami-0abcdef1234567890"
  #   - SSM Parameter: "ssm:/ImageBuilder/BaseAMI"
  parent_image = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"

  # component (必須)
  # Image Recipeに含まれるコンポーネントを定義します。
  # コンポーネントは、イメージのカスタマイズ、テスト、検証を行うための
  # 再利用可能なビルドブロックです。
  # 複数のコンポーネントを順序付けて指定できます。
  component {
    # component_arn (必須)
    # 関連付けるImage Builder ComponentのARNを指定します。
    # このコンポーネントがイメージのビルドプロセスで実行されます。
    component_arn = "arn:aws:imagebuilder:us-east-1:123456789012:component/example-component/1.0.0/1"

    # parameter (オプション)
    # コンポーネントに渡すパラメータを設定します。
    # コンポーネントの動作をカスタマイズするために使用します。
    # 複数のパラメータを指定できます。
    parameter {
      # name (必須)
      # コンポーネントパラメータの名前を指定します。
      # コンポーネントドキュメントで定義されているパラメータ名と一致する必要があります。
      name = "Parameter1"

      # value (必須)
      # 指定されたパラメータの値を設定します。
      # コンポーネントの実行時にこの値が使用されます。
      value = "Value1"
    }

    parameter {
      name  = "Parameter2"
      value = "Value2"
    }
  }

  # ====================
  # オプションパラメータ (Optional Parameters)
  # ====================

  # region (オプション)
  # このリソースが管理されるリージョンを指定します。
  # デフォルトでは、プロバイダー設定のリージョンが使用されます。
  # 明示的に指定する場合は、有効なAWSリージョンコードを使用してください。
  # 例: "us-east-1", "eu-west-1", "ap-northeast-1"
  # region = "us-east-1"

  # description (オプション)
  # Image Recipeの説明を指定します。
  # この説明は、レシピの目的や内容を理解するために役立ちます。
  # 最大1024文字まで指定できます。
  description = "Example image recipe for Amazon Linux 2"

  # block_device_mapping (オプション)
  # イメージのブロックデバイスマッピングを定義します。
  # EC2インスタンスのストレージ設定をカスタマイズするために使用します。
  # 複数のブロックデバイスを指定できます。
  block_device_mapping {
    # device_name (オプション)
    # デバイスの名前を指定します。
    # 例: "/dev/sda", "/dev/xvdb", "/dev/sdf"
    # オペレーティングシステムによって命名規則が異なる場合があります。
    device_name = "/dev/xvdb"

    # ebs (オプション)
    # Elastic Block Storage (EBS)のブロックデバイスマッピング設定を構成します。
    # EBSボリュームの詳細な設定を行います。
    ebs {
      # delete_on_termination (オプション)
      # インスタンス終了時にボリュームを削除するかどうかを指定します。
      # true: 削除する、false: 削除しない
      # デフォルトは未設定で、親イメージから継承されます。
      delete_on_termination = true

      # encrypted (オプション)
      # ボリュームを暗号化するかどうかを指定します。
      # true: 暗号化する、false: 暗号化しない
      # デフォルトは未設定で、親イメージから継承されます。
      # encrypted = true

      # iops (オプション)
      # io1またはio2ボリュームタイプの場合にプロビジョニングするIOPS数を指定します。
      # gp3ボリュームの場合もIOPSを指定できます。
      # ボリュームタイプに応じて有効な範囲が異なります。
      # iops = 3000

      # kms_key_id (オプション)
      # 暗号化に使用するKMS KeyのARNを指定します。
      # encrypted = true の場合に有効です。
      # 指定しない場合は、デフォルトのEBS暗号化キーが使用されます。
      # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

      # snapshot_id (オプション)
      # 使用するEC2ボリュームスナップショットのIDを指定します。
      # 既存のスナップショットからボリュームを作成する場合に使用します。
      # snapshot_id = "snap-0123456789abcdef0"

      # throughput (オプション)
      # gp3ボリュームタイプの場合のみ有効です。
      # ボリュームがサポートするスループット(MiB/s)を指定します。
      # 範囲: 125 MiB/s - 1000 MiB/s
      # throughput = 125

      # volume_size (オプション)
      # ボリュームのサイズをGiB単位で指定します。
      # ボリュームタイプに応じて最小値と最大値が異なります。
      # 例: gp2/gp3は1 GiB - 16384 GiB
      volume_size = 100

      # volume_type (オプション)
      # ボリュームのタイプを指定します。
      # 有効な値: "standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"
      # gp3が最新の汎用SSDボリュームタイプで、コストパフォーマンスに優れています。
      volume_type = "gp3"
    }

    # no_device (オプション)
    # 親イメージからマッピングを削除する場合にtrueに設定します。
    # デバイスのアタッチを無効にする場合に使用します。
    # no_device = true

    # virtual_name (オプション)
    # 仮想デバイス名を指定します。
    # インスタンスストアボリュームの場合に使用します。
    # 例: "ephemeral0", "ephemeral1", "ephemeral2", "ephemeral3"
    # インスタンスストアボリュームは0から始まる番号が付けられます。
    # virtual_name = "ephemeral0"
  }

  # systems_manager_agent (オプション)
  # Image Builderがデフォルトでインストールする Systems Manager Agentの設定を行います。
  # イメージのビルド後にエージェントを削除するかどうかを制御できます。
  # systems_manager_agent {
  #   # uninstall_after_build (必須)
  #   # イメージのビルド後にSystems Manager Agentを削除するかどうかを指定します。
  #   # true: ビルド後に削除、false: インストールしたまま
  #   # セキュリティ要件に応じて設定してください。
  #   uninstall_after_build = false
  # }

  # user_data_base64 (オプション)
  # Base64エンコードされたユーザーデータを指定します。
  # ビルドインスタンスの起動時に実行するコマンドやスクリプトを提供する場合に使用します。
  # EC2インスタンスのユーザーデータと同様の機能を持ちます。
  # 例: user_data_base64 = base64encode("#!/bin/bash\necho 'Hello World'")
  # user_data_base64 = ""

  # working_directory (オプション)
  # ビルドおよびテストワークフロー中に使用する作業ディレクトリを指定します。
  # コンポーネントスクリプトが実行される際のカレントディレクトリとなります。
  # 絶対パスで指定してください。
  # 例: "/tmp", "/home/ec2-user/build"
  # working_directory = "/tmp"

  # ami_tags (オプション)
  # Image Builderがビルドフェーズ中に作成するAMIに適用するタグを指定します。
  # イメージの配布前、ビルド段階でAMIにタグ付けされます。
  # 最大50個のタグを指定できます。
  # タグは、AMIの管理、コスト配分、アクセス制御などに使用されます。
  # ami_tags = {
  #   Environment = "Development"
  #   BuildDate   = "2024-01-01"
  #   Purpose     = "WebServer"
  # }

  # tags (オプション)
  # Image Recipeリソースに適用するタグを指定します。
  # リソースの整理、管理、コスト配分、アクセス制御などに使用されます。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 同じキーのタグはここで定義された値で上書きされます。
  tags = {
    Name        = "example-image-recipe"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # ====================
  # 出力属性 (Attributes)
  # ====================
  # これらの属性は、リソース作成後に参照可能になります。
  # 他のリソースやモジュールの出力として使用できます。

  # arn
  # Image RecipeのAmazon Resource Name (ARN)
  # 他のImage Builderリソース(パイプライン、イメージなど)から参照する際に使用します。
  # 出力例: aws_imagebuilder_image_recipe.example.arn

  # date_created
  # Image Recipeが作成された日時
  # ISO 8601形式のタイムスタンプ
  # 出力例: aws_imagebuilder_image_recipe.example.date_created

  # owner
  # Image Recipeの所有者
  # AWSアカウントIDが表示されます。
  # 出力例: aws_imagebuilder_image_recipe.example.owner

  # platform
  # Image Recipeのプラットフォーム
  # 親イメージから自動的に決定されます。
  # 例: "Linux", "Windows"
  # 出力例: aws_imagebuilder_image_recipe.example.platform

  # tags_all
  # リソースに割り当てられたすべてのタグのマップ
  # プロバイダーのdefault_tags設定ブロックから継承されたタグを含みます。
  # 出力例: aws_imagebuilder_image_recipe.example.tags_all
}

# ====================
# 使用例 (Usage Examples)
# ====================

# 例1: シンプルなImage Recipe
# 基本的な設定のみを含むImage Recipe
# resource "aws_imagebuilder_image_recipe" "simple" {
#   name         = "simple-recipe"
#   version      = "1.0.0"
#   parent_image = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
#
#   component {
#     component_arn = aws_imagebuilder_component.update.arn
#   }
#
#   tags = {
#     Name = "simple-recipe"
#   }
# }

# 例2: 複数のコンポーネントを持つImage Recipe
# 複数のカスタマイズコンポーネントを順序付けて実行
# resource "aws_imagebuilder_image_recipe" "multi_component" {
#   name         = "multi-component-recipe"
#   version      = "1.0.0"
#   parent_image = "arn:aws:imagebuilder:us-east-1:aws:image/ubuntu-server-20-lts-x86/x.x.x"
#
#   component {
#     component_arn = aws_imagebuilder_component.security_hardening.arn
#   }
#
#   component {
#     component_arn = aws_imagebuilder_component.application_install.arn
#
#     parameter {
#       name  = "AppVersion"
#       value = "2.3.4"
#     }
#   }
#
#   component {
#     component_arn = aws_imagebuilder_component.monitoring.arn
#   }
#
#   tags = {
#     Name = "multi-component-recipe"
#   }
# }

# 例3: 詳細なブロックデバイス設定を持つImage Recipe
# カスタムストレージ構成を含むレシピ
# resource "aws_imagebuilder_image_recipe" "custom_storage" {
#   name         = "custom-storage-recipe"
#   version      = "2.0.0"
#   parent_image = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
#
#   component {
#     component_arn = aws_imagebuilder_component.base_config.arn
#   }
#
#   # ルートボリューム
#   block_device_mapping {
#     device_name = "/dev/xvda"
#
#     ebs {
#       delete_on_termination = true
#       encrypted             = true
#       kms_key_id            = aws_kms_key.ebs.arn
#       volume_size           = 50
#       volume_type           = "gp3"
#       iops                  = 3000
#       throughput            = 125
#     }
#   }
#
#   # データボリューム
#   block_device_mapping {
#     device_name = "/dev/xvdb"
#
#     ebs {
#       delete_on_termination = true
#       encrypted             = true
#       volume_size           = 200
#       volume_type           = "gp3"
#       throughput            = 250
#     }
#   }
#
#   tags = {
#     Name = "custom-storage-recipe"
#   }
# }

# 例4: SSM Parameterを使用したImage Recipe
# Systems Manager Parameter Storeからベースイメージを参照
# resource "aws_imagebuilder_image_recipe" "ssm_param" {
#   name         = "ssm-param-recipe"
#   version      = "1.0.0"
#   parent_image = "ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
#
#   component {
#     component_arn = aws_imagebuilder_component.custom.arn
#   }
#
#   description = "Recipe using SSM parameter for base image"
#
#   tags = {
#     Name = "ssm-param-recipe"
#   }
# }

# 例5: Systems Manager Agentの削除設定を含むImage Recipe
# ビルド後にSSM Agentを削除するセキュアな設定
# resource "aws_imagebuilder_image_recipe" "secure" {
#   name         = "secure-recipe"
#   version      = "1.0.0"
#   parent_image = "arn:aws:imagebuilder:us-east-1:aws:image/windows-server-2022-english-full-base-x86/x.x.x"
#
#   component {
#     component_arn = aws_imagebuilder_component.security.arn
#   }
#
#   systems_manager_agent {
#     uninstall_after_build = true
#   }
#
#   working_directory = "C:\\BuildTemp"
#
#   tags = {
#     Name        = "secure-recipe"
#     Compliance  = "high"
#   }
# }

# ====================
# 関連リソース (Related Resources)
# ====================

# Image Recipeは、以下のリソースと組み合わせて使用されます:

# 1. aws_imagebuilder_component
#    - Image Recipeで使用するカスタマイズコンポーネントを定義
#    - ビルド、テスト、検証のロジックを含む

# 2. aws_imagebuilder_image
#    - Image Recipeを使用して実際のイメージをビルド
#    - ビルドプロセスを実行し、AMIまたはコンテナイメージを作成

# 3. aws_imagebuilder_image_pipeline
#    - Image Recipeを使用した自動化されたイメージビルドパイプライン
#    - スケジュールに基づいてイメージを定期的に更新

# 4. aws_imagebuilder_distribution_configuration
#    - ビルドされたイメージの配布設定
#    - 複数リージョンやアカウントへの配布を管理

# 5. aws_imagebuilder_infrastructure_configuration
#    - イメージビルドに使用するインフラストラクチャの設定
#    - インスタンスタイプ、IAMロール、VPC設定などを定義

# ====================
# ベストプラクティス (Best Practices)
# ====================

# 1. バージョン管理
#    - セマンティックバージョニングを使用して、レシピのバージョンを明確に管理
#    - 変更履歴をドキュメント化し、トレーサビリティを確保

# 2. コンポーネントの再利用
#    - 汎用的なカスタマイズはコンポーネントとして分離し、複数のレシピで再利用
#    - コンポーネントのパラメータ化により、柔軟性を向上

# 3. セキュリティ
#    - EBSボリュームの暗号化を有効化
#    - 必要に応じてSystems Manager Agentをビルド後に削除
#    - AMIタグを使用してセキュリティコンプライアンスを追跡

# 4. タグ付け
#    - 一貫性のあるタグ付け戦略を使用
#    - コスト配分、環境識別、管理目的でタグを活用

# 5. ベースイメージの管理
#    - 公式のAWS管理イメージまたは信頼できるソースのイメージを使用
#    - SSM Parameterを使用して、ベースイメージの更新を自動化

# 6. ストレージ最適化
#    - ワークロードに適したボリュームタイプとサイズを選択
#    - gp3ボリュームタイプを使用してコストとパフォーマンスのバランスを最適化

# 7. 説明の記載
#    - わかりやすいdescriptionを記載し、レシピの目的を明確化
#    - 変更履歴やメンテナンス情報を含める

# 8. テストコンポーネントの追加
#    - ビルドされたイメージの品質を保証するため、テストコンポーネントを含める
#    - 自動化されたテストにより、リグレッションを防止

# ====================
# 注意事項 (Important Notes)
# ====================

# 1. Image Recipeは作成後、不変(immutable)です
#    - 既存のレシピを変更する場合は、新しいバージョンを作成する必要があります
#    - バージョン番号を変更して新しいリソースを作成してください

# 2. 親イメージの指定形式
#    - ARN、AMI ID、SSM Parameterの3つの形式で指定可能
#    - SSM Parameterを使用する場合は、プレフィックス "ssm:" が必要

# 3. コンポーネントの実行順序
#    - componentブロックの定義順序で実行されます
#    - 依存関係を考慮して適切な順序で定義してください

# 4. プラットフォームの互換性
#    - コンポーネントとベースイメージのプラットフォーム(LinuxまたはWindows)は一致する必要があります

# 5. IAM権限
#    - Image Builderが動作するために適切なIAMロールと権限が必要です
#    - aws_imagebuilder_infrastructure_configurationで指定されたIAMロールが使用されます

# 6. コスト
#    - Image Builderの使用自体は無料ですが、以下のコストが発生します:
#      - EC2インスタンスの実行時間
#      - EBSスナップショットのストレージ
#      - AMIのストレージ
#      - ログ保存用のS3ストレージ

# 7. リージョンの考慮
#    - Image Recipeはリージョナルリソースです
#    - 複数リージョンで使用する場合は、各リージョンで作成する必要があります

# 8. 削除保護
#    - 使用中のImage Recipeを削除すると、関連するパイプラインやイメージに影響します
#    - 削除前に依存関係を確認してください
