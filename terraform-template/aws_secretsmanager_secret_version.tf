#---------------------------------------------------------------
# AWS Secrets Manager Secret Version
#---------------------------------------------------------------
#
# AWS Secrets Managerのシークレットバージョンをプロビジョニングするリソースです。
# シークレット値（文字列またはバイナリ）を暗号化して保存し、バージョン管理を行います。
# シークレットのメタデータ管理には aws_secretsmanager_secret リソースを使用します。
#
# AWS公式ドキュメント:
#   - Secrets Manager概要: https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html
#   - シークレット値の更新: https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_update-secret-value.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/secretsmanager_secret_version
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_secretsmanager_secret_version" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # secret_id (Required)
  # 設定内容: バージョンを追加するシークレットを指定します。
  # 設定可能な値: シークレットのARN、またはシークレットのフレンドリー名
  # 注意: 指定するシークレットは事前に存在している必要があります。
  secret_id = aws_secretsmanager_secret.example.id

  #-------------------------------------------------------------
  # シークレット値設定
  #-------------------------------------------------------------

  # secret_string (Optional)
  # 設定内容: 暗号化してこのバージョンに保存するテキストデータを指定します。
  # 設定可能な値: 任意の文字列。JSONエンコードしたキーバリューペアを格納するユースケースが一般的
  # 省略時: secret_binary または secret_string_wo のいずれかが必須です。
  # 注意: sensitive属性のため、Terraformのplanやapply出力ではマスクされます。
  #       secret_string_wo と同時に使用することはできません。
  secret_string = jsonencode({
    username = "example-user"
    password = "example-password"
  })

  # secret_binary (Optional)
  # 設定内容: 暗号化してこのバージョンに保存するバイナリデータを指定します。
  # 設定可能な値: base64エンコードされたバイナリ文字列
  # 省略時: secret_string または secret_string_wo のいずれかが必須です。
  # 注意: sensitive属性のため、Terraformのplanやapply出力ではマスクされます。
  #       secret_string と排他的ではなく、同時設定は可能ですが通常はどちらか一方を使用します。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_PutSecretValue.html
  secret_binary = null

  # secret_string_wo (Optional)
  # 設定内容: 暗号化してこのバージョンに保存するテキストデータを指定するWrite-Only引数です。
  # 設定可能な値: 任意の文字列
  # 省略時: secret_string または secret_binary のいずれかが必須です。
  # 注意: Write-Only引数であり、Terraform state には保存されません。
  #       HashiCorp Terraform 1.11.0以降でサポート。
  #       secret_string と同時に使用することはできません。
  # 参考: https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments
  secret_string_wo = null

  # secret_string_wo_version (Optional)
  # 設定内容: secret_string_wo の更新をトリガーするためのバージョン番号を指定します。
  # 設定可能な値: 任意の数値。更新が必要なタイミングでインクリメントします。
  # 省略時: null（secret_string_wo と合わせて使用する場合に設定します）
  # 注意: secret_string_wo を使用する場合、この値をインクリメントすることで更新が発動します。
  secret_string_wo_version = null

  #-------------------------------------------------------------
  # バージョンステージ設定
  #-------------------------------------------------------------

  # version_stages (Optional)
  # 設定内容: このバージョンに付与するステージングラベルのリストを指定します。
  # 設定可能な値: ステージングラベル名の文字列セット
  #   - "AWSCURRENT": 現在のアクティブなバージョンを示すラベル（AWS管理）
  #   - "AWSPREVIOUS": 直前のバージョンを示すラベル（AWS管理）
  #   - "AWSPENDING": ローテーション中のバージョンを示すラベル（AWS管理）
  #   - カスタムラベル: 任意の文字列（ユーザー定義）
  # 省略時: AWS Secrets Managerが自動的に AWSCURRENT ラベルをこの新バージョンに付与します。
  # 注意: ステージングラベルは1つのバージョンにのみ付与できます。
  #       他のバージョンに既に付与されているラベルを指定すると、そちらから自動的に取り外されます。
  #       version_stages を設定する場合、このバージョンが唯一のバージョンか、
  #       現在 AWSCURRENT が付与されているバージョンであれば AWSCURRENT を含める必要があります。
  # 参考: https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_UpdateSecretVersionStage.html
  version_stages = ["AWSCURRENT"]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: シークレットのAmazon Resource Name (ARN)
#
# - version_id: シークレットバージョンの一意識別子
#
# - has_secret_string_wo: secret_string_wo が設定されているかを示すブール値
#
# - id: シークレットIDとバージョンIDをパイプ区切りで結合した値
#---------------------------------------------------------------
