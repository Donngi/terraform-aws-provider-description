#---------------------------------------------------------------
# EC2 Image Builder コンポーネント
#---------------------------------------------------------------
#
# EC2 Image Builderのコンポーネントをプロビジョニングするリソースです。
# コンポーネントは、イメージ構築時に実行されるビルド・テスト・検証ステップを
# YAMLドキュメント形式で定義します。
# インラインYAML文字列またはS3 URIからコンポーネントドキュメントを読み込めます。
# Linux/Windowsプラットフォームをサポートし、KMSによる暗号化にも対応します。
#
# AWS公式ドキュメント:
#   - Image Builder コンポーネント管理: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-components.html
#   - コンポーネントドキュメント構文: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-component-manager.html
#   - コンポーネントのバージョン管理: https://docs.aws.amazon.com/imagebuilder/latest/userguide/manage-component-versions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_component
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_imagebuilder_component" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コンポーネントの名前を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  # 注意: コンポーネント名は一意である必要があります。
  name = "example-component"

  # platform (Required)
  # 設定内容: コンポーネントが対応するプラットフォームを指定します。
  # 設定可能な値:
  #   - "Linux": Linuxベースのイメージに使用するコンポーネント
  #   - "Windows": Windowsベースのイメージに使用するコンポーネント
  platform = "Linux"

  # version (Required)
  # 設定内容: コンポーネントのバージョンをセマンティックバージョニング形式で指定します。
  # 設定可能な値: "MAJOR.MINOR.PATCH" 形式の文字列（例: "1.0.0", "2.3.1"）
  # 注意: dataまたはuriを変更する場合は、新しいバージョンを指定する必要があります。
  #       バージョンを変更するとリソースが再作成されます。
  version = "1.0.0"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # コンポーネントドキュメント設定
  #-------------------------------------------------------------

  # data (Optional)
  # 設定内容: コンポーネントのYAMLドキュメントをインライン文字列で指定します。
  # 設定可能な値: Image Builder コンポーネントドキュメント形式のYAML文字列
  # 省略時: uriを指定する必要があります。
  # 注意: dataとuriはどちらか一方のみ指定可能です。
  #       Terraformはこの値が設定に存在する場合のみドリフト検知を行います。
  #       dataまたはuriを変更する場合は、新しいversionの指定が必要です。
  # 参考: https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-component-manager.html
  data = yamlencode({
    schemaVersion = 1.0
    phases = [
      {
        name = "build"
        steps = [
          {
            name      = "example"
            action    = "ExecuteBash"
            onFailure = "Continue"
            inputs = {
              commands = ["echo 'hello world'"]
            }
          }
        ]
      }
    ]
  })

  # uri (Optional)
  # 設定内容: コンポーネントドキュメントが格納されたS3 URIを指定します。
  # 設定可能な値: "s3://bucket-name/key" 形式のS3 URI
  # 省略時: dataを指定する必要があります。
  # 注意: dataとuriはどちらか一方のみ指定可能です。
  #       uriを変更する場合は、新しいversionの指定が必要です。
  #       skip_destroy引数を使用することで旧バージョンを保持できます。
  uri = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: コンポーネントの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なしでコンポーネントが作成されます。
  description = "Example Image Builder component for demonstration"

  # change_description (Optional)
  # 設定内容: コンポーネントの変更内容の説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 変更説明なしでコンポーネントが作成されます。
  change_description = "Initial version"

  # supported_os_versions (Optional)
  # 設定内容: コンポーネントがサポートするオペレーティングシステムのバージョンセットを指定します。
  # 設定可能な値: OSバージョン文字列のセット（例: ["Amazon Linux 2", "Amazon Linux 2023"]）
  # 省略時: サポートするOSバージョンが未指定のコンポーネントが作成されます。
  # 注意: この設定はコンポーネントの互換性を文書化するためのメタデータです。
  supported_os_versions = ["Amazon Linux 2", "Amazon Linux 2023"]

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: コンポーネントの暗号化に使用するKMSキーのARNを指定します。
  # 設定可能な値: 有効なKMSキーARN（例: arn:aws:kms:ap-northeast-1:123456789012:key/...）
  # 省略時: AWSマネージドキーによる暗号化が適用されます。
  # 関連機能: KMSによるコンポーネント暗号化
  #   カスタマーマネージドKMSキーを使用してコンポーネントを暗号化し、
  #   セキュリティ要件やコンプライアンス基準を満たすことができます。
  #   - https://docs.aws.amazon.com/imagebuilder/latest/userguide/security-encryption.html
  kms_key_id = null

  #-------------------------------------------------------------
  # ライフサイクル設定
  #-------------------------------------------------------------

  # skip_destroy (Optional)
  # 設定内容: リソースが破棄または置換される際に旧バージョンを保持するかを指定します。
  # 設定可能な値:
  #   - false (デフォルト): リソース破棄時にコンポーネントを削除します
  #   - true: リソース破棄時にコンポーネントを保持します
  # 省略時: false として扱われます。
  # 注意: dataまたはuriを変更するとリソースが再作成されます。
  #       skip_destroy = true に設定すると、旧バージョンのコンポーネントが
  #       AWSアカウントに残り続けるため、コスト管理に注意が必要です。
  skip_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなしでリソースが作成されます。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "example-component"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コンポーネントのAmazon Resource Name (ARN)
#
# - arn: コンポーネントのAmazon Resource Name (ARN)
#
# - date_created: コンポーネントが作成された日時
#
# - encrypted: コンポーネントの暗号化ステータス（true/false）
#
# - owner: コンポーネントの所有者（AWSアカウントID）
#
# - type: コンポーネントのタイプ（BUILD、TEST等）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
