#---------------------------------------------------------------
# AWS Systems Manager Parameter Store パラメーター
#---------------------------------------------------------------
#
# AWS Systems Manager Parameter StoreにSSMパラメーターをプロビジョニングするリソースです。
# Parameter Storeは設定データ（データベース文字列、APIキー、ライセンスコードなど）を
# 安全に保存・管理するための仕組みです。プレーンテキスト（String、StringList）および
# 暗号化（SecureString）のパラメータータイプをサポートします。
#
# AWS公式ドキュメント:
#   - Parameter Store概要: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html
#   - パラメータータイプ: https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-about-examples.html
#   - PutParameter API: https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_PutParameter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ssm_parameter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: パラメーターの名前（パス）を指定します。
  # 設定可能な値: 1〜2048文字の文字列。スラッシュで始まる階層パスも使用可能（例: /app/db/password）
  # 注意: 名前は一意である必要があります。階層パスを使用する場合は "/"で始め、
  #       最大15階層まで指定できます。
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-paramstore-su-create.html
  name = "/myapp/production/db_password"

  # type (Required)
  # 設定内容: パラメーターのデータ型を指定します。
  # 設定可能な値:
  #   - "String": プレーンテキスト文字列
  #   - "StringList": カンマ区切りの値のリスト
  #   - "SecureString": KMSキーで暗号化された文字列（機密情報に推奨）
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-about-examples.html
  type = "SecureString"

  #-------------------------------------------------------------
  # 値設定
  #-------------------------------------------------------------

  # value (Optional)
  # 設定内容: パラメーターの値を指定します。
  # 設定可能な値: 文字列（valueまたはvalue_woのどちらか一方を指定する必要があります）
  # 注意: このフィールドはセンシティブフィールドです。Terraform stateに平文で保存されます。
  #       機密情報の場合はvalue_woを使用することを検討してください。
  #       typeが"StringList"の場合はカンマ区切りの文字列を指定します。
  # 省略時: value_woを使用する場合は省略可能です
  value = "MySecretPassword123"

  # value_wo (Optional, Write-Only)
  # 設定内容: パラメーターの値をwrite-onlyフィールドとして指定します。
  # 設定可能な値: 文字列
  # 注意: このフィールドはwrite-onlyフィールドです。Terraform stateには保存されません。
  #       機密性の高いパラメーターに推奨します。valueとvalue_woは排他的です。
  #       value_woを使用する場合はvalue_wo_versionも合わせて指定することを推奨します。
  # 省略時: valueを使用する場合は省略可能です
  value_wo = null

  # value_wo_version (Optional)
  # 設定内容: value_woの変更を検知するためのバージョン番号を指定します。
  # 設定可能な値: 整数（0以上）
  # 注意: value_woと合わせて使用します。この値を変更することでvalue_woの再適用をトリガーできます。
  # 省略時: null（value_wo未使用の場合は省略可能）
  value_wo_version = null

  # insecure_value (Optional)
  # 設定内容: typeが"String"または"StringList"のパラメーターの値を平文で指定します。
  # 設定可能な値: 文字列
  # 注意: typeが"SecureString"の場合は使用できません。
  #       このフィールドを使用する場合、valueとは排他的です。
  # 省略時: valueを使用する場合は省略可能です
  insecure_value = null

  #-------------------------------------------------------------
  # メタデータ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: パラメーターの説明を指定します。
  # 設定可能な値: 1〜1024文字の文字列
  # 省略時: 説明なし
  description = "Production database password for MyApp"

  # allowed_pattern (Optional)
  # 設定内容: パラメーター値を検証するための正規表現パターンを指定します。
  # 設定可能な値: 正規表現パターン文字列（例: "[a-zA-Z0-9]+"）
  # 省略時: バリデーションなし
  allowed_pattern = null

  # data_type (Optional)
  # 設定内容: パラメーターのデータ型を指定します（AWS固有の形式用）。
  # 設定可能な値:
  #   - "text" (デフォルト): 通常のテキスト
  #   - "aws:ec2:image": EC2 AMI IDとして扱う（AMIの検証が行われる）
  #   - "aws:ssm:integration": SSM統合用
  # 省略時: "text"が使用されます
  data_type = "text"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # arn (Optional)
  # 設定内容: パラメーターのARNを明示的に指定します。
  # 設定可能な値: 有効なAWS SSMパラメーターのARN文字列
  # 省略時: AWSが自動的にARNを割り当てます（通常は省略します）
  arn = null

  # key_id (Optional)
  # 設定内容: typeが"SecureString"の場合に使用するKMSキーのIDまたはARNを指定します。
  # 設定可能な値: KMSキーのID、ARN、またはエイリアス（例: "alias/aws/ssm"）
  # 省略時: AWSマネージドキー（alias/aws/ssm）が使用されます
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#aws-managed-key
  key_id = null

  #-------------------------------------------------------------
  # ティア設定
  #-------------------------------------------------------------

  # tier (Optional)
  # 設定内容: パラメーターのストレージティアを指定します。
  # 設定可能な値:
  #   - "Standard" (デフォルト): 無料枠あり（最大4KB、アカウントあたり10,000パラメーター）
  #   - "Advanced": 有料（最大8KB、より多くのパラメーター、パラメーターポリシー利用可能）
  #   - "Intelligent-Tiering": StandardからAdvancedへの自動昇格
  # 省略時: プロバイダーのdefault設定またはAWSデフォルト（Standard）が使用されます
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-advanced-parameters.html
  tier = "Standard"

  #-------------------------------------------------------------
  # 上書き設定
  #-------------------------------------------------------------

  # overwrite (Optional)
  # 設定内容: 既存のパラメーターを上書きするかどうかを指定します。
  # 設定可能な値:
  #   - true: 既存のパラメーターを上書きする
  #   - false: 既存のパラメーターを上書きしない
  # 省略時: null（Terraform管理外の変更を上書きするかどうかはAWSのデフォルトに依存）
  # 注意: 非推奨の属性です。Terraformは通常、変更があれば自動的に更新します。
  overwrite = null

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
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://docs.aws.amazon.com/systems-manager/latest/userguide/tagging-parameters.html
  tags = {
    Name        = "db-password"
    Environment = "production"
    Application = "myapp"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: パラメーターのAmazon Resource Name (ARN)
#
# - has_value_wo: value_woが設定されているかどうかを示すフラグ
#
# - id: パラメーターの名前（nameと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# - version: パラメーターの現在のバージョン番号
#
#---------------------------------------------------------------
