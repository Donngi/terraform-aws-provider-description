#---------------------------------------------------------------
# AWS EC2 Image Builder Component
#---------------------------------------------------------------
#
# EC2 Image Builderのコンポーネントを管理するリソースです。
# コンポーネントは、イメージのビルド、検証、テストに使用される
# 再利用可能なビルドブロックです。YAMLまたはJSONで定義された
# ビルドステップやテストステップを含めることができます。
#
# AWS公式ドキュメント:
#   - EC2 Image Builder概要: https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html
#   - コンポーネント: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-components.html
#   - コンポーネントドキュメント形式: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-application-documents.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_component
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_component" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須項目）
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コンポーネントの名前を指定します。
  # 設定可能な値: 1文字以上の文字列
  # 注意: リソース識別に使用される重要な属性です
  name = "example-component"

  # platform (Required)
  # 設定内容: コンポーネントのプラットフォームを指定します。
  # 設定可能な値:
  #   - "Linux": Linuxベースのイメージ用
  #   - "Windows": Windowsベースのイメージ用
  # 注意: プラットフォームに応じて使用可能なアクションやコマンドが異なります
  platform = "Linux"

  # version (Required)
  # 設定内容: コンポーネントのバージョンを指定します。
  # 設定可能な値: セマンティックバージョニング形式（例: 1.0.0, 2.1.3）
  # 重要: dataまたはuriを更新する場合は、必ず新しいversionを指定してください
  #      これによりリソースが置き換えられます（Forces new resource）
  # ベストプラクティス: セマンティックバージョニングに従うことを推奨
  version = "1.0.0"

  #-------------------------------------------------------------
  # コンポーネントデータ設定（data または uri のいずれか必須）
  #-------------------------------------------------------------

  # data (Optional - dataまたはuriのいずれか1つが必須)
  # 設定内容: コンポーネントのデータを含むインラインYAML文字列を指定します。
  # 設定可能な値: YAML形式の文字列（yamlencodeを使用推奨）
  # 注意: dataとuriは排他的で、どちらか一方のみを指定できます
  # ドリフト検出: Terraformは設定に存在する場合のみドリフト検出を実行します
  # 関連機能: コンポーネントドキュメント
  #   Image Builderのコンポーネントは、phases（フェーズ）とsteps（ステップ）で構成されます。
  #   - phases: build, validate, test の3つのフェーズがあります
  #   - steps: 各フェーズ内で実行される個別のアクション
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-application-documents.html
  data = yamlencode({
    phases = [{
      name = "build"
      steps = [{
        action = "ExecuteBash"
        inputs = {
          commands = [
            "echo 'Installing packages'",
            "yum install -y httpd",
          ]
        }
        name      = "InstallHttpd"
        onFailure = "Abort"
      }]
    }]
    schemaVersion = 1.0
  })

  # uri (Optional - dataまたはuriのいずれか1つが必須)
  # 設定内容: コンポーネントデータを含むS3 URIを指定します。
  # 設定可能な値: s3://bucket-name/key-path 形式のURI
  # 注意: dataとuriは排他的で、どちらか一方のみを指定できます
  # 重要: dataまたはuriを更新する場合は、新しいversionの指定が必要です
  # 例: "s3://my-bucket/components/my-component.yaml"
  # uri = "s3://${aws_s3_bucket.components.bucket}/${aws_s3_object.component.key}"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: コンポーネントの説明を記載します。
  # 設定可能な値: 文字列
  # ベストプラクティス: コンポーネントの目的や機能を明確に記述
  description = "Example component for installing Apache web server"

  # change_description (Optional)
  # 設定内容: コンポーネントの変更説明を記載します。
  # 設定可能な値: 文字列
  # 用途: バージョン間の変更内容を追跡する際に有用です
  # 例: "Updated security patches", "Added new configuration step"
  change_description = "Initial version"

  # kms_key_id (Optional)
  # 設定内容: コンポーネントの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: KMSキーのARN
  # 注意: KMSキーポリシーでImage Builderサービスに適切な権限が必要です
  # 関連機能: KMS暗号化
  #   指定しない場合、デフォルトの暗号化が適用されます。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/security-encryption.html
  # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # supported_os_versions (Optional)
  # 設定内容: コンポーネントがサポートするオペレーティングシステム（OS）のバージョンを指定します。
  # 設定可能な値: OS名とバージョンの文字列のセット
  # 用途: 特定のOSバージョンでのみコンポーネントを使用可能にする場合に指定
  # 例: ["Amazon Linux 2", "Ubuntu 20.04", "Ubuntu 22.04"]
  # supported_os_versions = [
  #   "Amazon Linux 2",
  #   "Ubuntu 20.04",
  #   "Ubuntu 22.04",
  # ]

  # skip_destroy (Optional)
  # 設定内容: リソースの破棄または置き換え時に古いバージョンを保持するかどうかを指定します。
  # 設定可能な値: true, false
  # 省略時: false
  # 挙動: trueに設定すると、リソース削除時に実際のAWSコンポーネントは削除されません
  # 用途: バージョン履歴を保持したい場合や、他のリソースが旧バージョンを参照している可能性がある場合に有用
  # ベストプラクティス: 本番環境では履歴保持のためtrueを検討
  skip_destroy = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: コンポーネントに付与するタグのキーと値のマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-component"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# 使用例: インラインYAMLを使用した基本的なコンポーネント
#---------------------------------------------------------------
# resource "aws_imagebuilder_component" "basic_example" {
#   name     = "basic-component"
#   platform = "Linux"
#   version  = "1.0.0"
#
#   data = yamlencode({
#     phases = [{
#       name = "build"
#       steps = [{
#         action = "ExecuteBash"
#         inputs = {
#           commands = ["echo 'hello world'"]
#         }
#         name      = "example"
#         onFailure = "Continue"
#       }]
#     }]
#     schemaVersion = 1.0
#   })
# }

#---------------------------------------------------------------
# 使用例: S3 URIを使用したコンポーネント
#---------------------------------------------------------------
# resource "aws_s3_bucket" "components" {
#   bucket = "my-imagebuilder-components"
# }
#
# resource "aws_s3_object" "component_definition" {
#   bucket = aws_s3_bucket.components.id
#   key    = "components/web-server-setup.yaml"
#   content = yamlencode({
#     phases = [{
#       name = "build"
#       steps = [{
#         action = "ExecuteBash"
#         inputs = {
#           commands = [
#             "yum install -y httpd",
#             "systemctl enable httpd",
#           ]
#         }
#         name      = "InstallWebServer"
#         onFailure = "Abort"
#       }]
#     }]
#     schemaVersion = 1.0
#   })
# }
#
# resource "aws_imagebuilder_component" "from_s3" {
#   name        = "web-server-component"
#   platform    = "Linux"
#   version     = "1.0.0"
#   description = "Component stored in S3"
#   uri         = "s3://${aws_s3_bucket.components.bucket}/${aws_s3_object.component_definition.key}"
#
#   tags = {
#     Source = "S3"
#   }
# }

#---------------------------------------------------------------
# 使用例: KMS暗号化とタグ付きコンポーネント
#---------------------------------------------------------------
# resource "aws_kms_key" "imagebuilder" {
#   description             = "KMS key for Image Builder components"
#   deletion_window_in_days = 10
#
#   tags = {
#     Name = "imagebuilder-key"
#   }
# }
#
# resource "aws_imagebuilder_component" "encrypted" {
#   name        = "secure-component"
#   platform    = "Linux"
#   version     = "1.0.0"
#   description = "Encrypted component with security configurations"
#   kms_key_id  = aws_kms_key.imagebuilder.arn
#
#   data = yamlencode({
#     phases = [{
#       name = "build"
#       steps = [{
#         action = "ExecuteBash"
#         inputs = {
#           commands = [
#             "echo 'Configuring security settings'",
#             "yum update -y",
#             "yum install -y aide",
#           ]
#         }
#         name      = "SecuritySetup"
#         onFailure = "Abort"
#       }]
#     }]
#     schemaVersion = 1.0
#   })
#
#   tags = {
#     Environment = "production"
#     Compliance  = "required"
#     ManagedBy   = "terraform"
#   }
# }

#---------------------------------------------------------------
# 使用例: 特定のOSバージョンをサポートするコンポーネント
#---------------------------------------------------------------
# resource "aws_imagebuilder_component" "os_specific" {
#   name        = "ubuntu-component"
#   platform    = "Linux"
#   version     = "2.0.0"
#   description = "Component optimized for Ubuntu distributions"
#
#   supported_os_versions = [
#     "Ubuntu 20.04",
#     "Ubuntu 22.04",
#   ]
#
#   data = yamlencode({
#     phases = [{
#       name = "build"
#       steps = [{
#         action = "ExecuteBash"
#         inputs = {
#           commands = [
#             "apt-get update",
#             "apt-get install -y nginx",
#           ]
#         }
#         name      = "InstallNginx"
#         onFailure = "Abort"
#       }]
#     }]
#     schemaVersion = 1.0
#   })
#
#   tags = {
#     OS = "Ubuntu"
#   }
# }

#---------------------------------------------------------------
# 使用例: バージョン履歴保持設定
#---------------------------------------------------------------
# resource "aws_imagebuilder_component" "versioned" {
#   name               = "my-application"
#   platform           = "Linux"
#   version            = "1.1.0"
#   change_description = "Added new feature X"
#   skip_destroy       = true  # 古いバージョンを保持
#
#   data = yamlencode({
#     phases = [{
#       name = "build"
#       steps = [{
#         action = "ExecuteBash"
#         inputs = {
#           commands = [
#             "echo 'Version 1.1.0 - New Feature X'",
#           ]
#         }
#         name      = "VersionInfo"
#         onFailure = "Continue"
#       }]
#     }]
#     schemaVersion = 1.0
#   })
# }

#---------------------------------------------------------------
# 使用例: 複数フェーズのコンポーネント
#---------------------------------------------------------------
# resource "aws_imagebuilder_component" "multi_phase" {
#   name        = "comprehensive-component"
#   platform    = "Linux"
#   version     = "1.0.0"
#   description = "Component with build, validate, and test phases"
#
#   data = yamlencode({
#     phases = [
#       {
#         name = "build"
#         steps = [{
#           action = "ExecuteBash"
#           inputs = {
#             commands = [
#               "yum install -y nginx",
#               "systemctl enable nginx",
#             ]
#           }
#           name      = "InstallNginx"
#           onFailure = "Abort"
#         }]
#       },
#       {
#         name = "validate"
#         steps = [{
#           action = "ExecuteBash"
#           inputs = {
#             commands = [
#               "nginx -t",
#             ]
#           }
#           name      = "ValidateNginxConfig"
#           onFailure = "Abort"
#         }]
#       },
#       {
#         name = "test"
#         steps = [{
#           action = "ExecuteBash"
#           inputs = {
#             commands = [
#               "curl -I http://localhost",
#             ]
#           }
#           name      = "TestNginxRunning"
#           onFailure = "Continue"
#         }]
#       },
#     ]
#     schemaVersion = 1.0
#   })
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンポーネントのAmazon Resource Name (ARN)
#   形式: arn:aws:imagebuilder:region:account-id:component/name/version
#   例: arn:aws:imagebuilder:us-east-1:123456789012:component/my-component/1.0.0
#
# - date_created: コンポーネントが作成された日時
#   形式: ISO 8601形式のタイムスタンプ
#   例: 2024-01-15T10:30:00Z
#
# - encrypted: コンポーネントの暗号化ステータス
#   型: bool
#   値: true（暗号化されている）、false（暗号化されていない）
#
# - owner: コンポーネントの所有者
#   値: AWSアカウントID、または "Amazon"（AWS管理コンポーネントの場合）
#   例: 123456789012
#
# - type: コンポーネントのタイプ
#   値: "BUILD" または "TEST"
#   説明: コンポーネントがビルドフェーズかテストフェーズで使用されるかを示します
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のImage BuilderコンポーネントをTerraformにインポートできます。
# コンポーネントのARNを使用してインポートします。
#
# コマンド例:
# terraform import aws_imagebuilder_component.example arn:aws:imagebuilder:us-east-1:123456789012:component/my-component/1.0.0
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
# 1. バージョニング:
#    - dataまたはuriを更新する場合は、必ず新しいversionを指定してください
#    - これによりリソースが置き換えられます（Forces new resource）
#    - セマンティックバージョニングの使用を推奨します
#
# 2. 排他的引数:
#    - dataとuriは同時に指定できません
#    - どちらか一方のみを使用してください
#
# 3. ドリフト検出:
#    - data属性のドリフト検出は、設定ファイルに存在する場合のみ実行されます
#    - uriで参照されるS3オブジェクトの内容変更は自動検出されません
#
# 4. バージョン保持:
#    - skip_destroy = trueを設定すると、Terraformがリソースを削除または置き換える際に
#      実際のAWSコンポーネントは削除されません
#    - これは他のイメージレシピが旧バージョンを参照している場合に有用です
#
# 5. コンポーネントドキュメント形式:
#    - dataまたはuriで指定するコンポーネントドキュメントは、Image Builderの
#      スキーマに準拠したYAML形式である必要があります
#    - schemaVersionは1.0を指定します
#    - phases: build, validate, testの3つのフェーズが使用可能です
#
# 6. KMS暗号化:
#    - kms_key_idを指定する場合、KMSキーポリシーでImage Builderサービスに
#      適切な権限が付与されていることを確認してください
#    - 必要な権限: kms:Decrypt, kms:GenerateDataKey
#
# 7. プラットフォーム固有のアクション:
#    - Linuxプラットフォーム: ExecuteBash, ExecuteBinary など
#    - Windowsプラットフォーム: ExecutePowerShell, ExecuteBinary など
#    - プラットフォームに応じて適切なアクションを使用してください
#
# 8. onFailure設定:
#    - Abort: ステップ失敗時にビルドを中止
#    - Continue: ステップ失敗時も後続ステップを継続
#    - 重要なステップにはAbortを、オプショナルなステップにはContinueを推奨
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# - aws_imagebuilder_image_recipe: イメージレシピの管理
#   コンポーネントを組み合わせてAMIを作成するレシピを定義
#
# - aws_imagebuilder_image_pipeline: イメージパイプラインの管理
#   イメージの自動ビルドとテストのパイプラインを設定
#
# - aws_imagebuilder_infrastructure_configuration: インフラストラクチャ設定の管理
#   イメージビルド時に使用するインスタンスタイプやネットワーク設定を定義
#
# - aws_imagebuilder_distribution_configuration: ディストリビューション設定の管理
#   ビルドしたイメージの配布先リージョンやアカウントを設定
#
# - aws_kms_key: KMS暗号化キーの管理
#   コンポーネントの暗号化に使用するKMSキーを作成
#
# - aws_s3_bucket: S3バケットの管理
#   コンポーネントドキュメントの保存先として使用
#
# - aws_s3_object: S3オブジェクトの管理
#   コンポーネントドキュメントファイルをS3にアップロード
#---------------------------------------------------------------
