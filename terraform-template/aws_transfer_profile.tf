#---------------------------------------------------------------
# AWS Transfer Family AS2 Profile
#---------------------------------------------------------------
#
# AWS Transfer FamilyのAS2（Applicability Statement 2）プロファイルを
# プロビジョニングするリソースです。AS2プロファイルは、ローカル組織または
# パートナー組織を定義し、AS2メッセージングによるEDI文書の交換に使用されます。
#
# AWS公式ドキュメント:
#   - AS2プロファイルの作成: https://docs.aws.amazon.com/transfer/latest/userguide/configure-as2-profile.html
#   - AS2設定のセットアップ: https://docs.aws.amazon.com/transfer/latest/userguide/as2-example-tutorial.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # as2_id (Required)
  # 設定内容: AS2 IDを指定します。RFC 4130で定義されるAS2名です。
  # 設定可能な値: 文字列（スペースを含めることはできません）
  # 用途:
  #   - インバウンド転送: パートナーから送信されるAS2メッセージのAS2-Fromヘッダー
  #   - アウトバウンド転送: パートナーに送信するAS2メッセージのAS2-Toヘッダー
  # 関連機能: AS2プロトコル
  #   AS2プロトコルでは、as2-fromおよびas2-toヘッダーを使用して取引パートナーシップを
  #   識別します。これにより、使用する証明書などが決定されます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/configure-as2-profile.html
  as2_id = "example-as2-id"

  # profile_type (Required)
  # 設定内容: プロファイルタイプを指定します。
  # 設定可能な値:
  #   - "LOCAL": ローカルプロファイル（AS2対応のTransfer Familyサーバー組織を定義）
  #   - "PARTNER": パートナープロファイル（Transfer Family外部のリモートパートナー組織を定義）
  # 関連機能: AS2プロファイルタイプ
  #   ローカルプロファイルはAS2対応のTransfer Familyサーバー組織またはパーティを定義します。
  #   パートナープロファイルはTransfer Family外部のリモートパートナー組織を定義します。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/configure-as2-profile.html
  profile_type = "LOCAL"

  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate_ids (Optional)
  # 設定内容: インポートした証明書操作から取得した証明書IDのリストを指定します。
  # 設定可能な値: Transfer Familyにインポートした証明書のIDのセット
  # 省略時: 証明書なしでプロファイルが作成されます（後で追加可能）
  # 関連機能: AS2証明書
  #   AS2プロファイルを作成する前に、必要な証明書をインポートする必要があります。
  #   証明書は、AS2メッセージの暗号化と署名に使用されます。
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/managing-as2-partners.html#configure-as2-certificate
  certificate_ids = ["c-1234567890abcdef0"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
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
  #   - https://docs.aws.amazon.com/transfer/latest/userguide/configure-as2-profile.html
  tags = {
    Name        = "example-as2-profile"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: プロファイルのAmazon Resource Name (ARN)
#
# - profile_id: AS2プロファイルの一意な識別子
#
#---------------------------------------------------------------
