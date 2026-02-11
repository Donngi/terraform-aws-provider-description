#---------------------------------------------------------------
# AWS Device Farm Instance Profile
#---------------------------------------------------------------
#
# AWS Device Farmのインスタンスプロファイルをプロビジョニングするリソースです。
# インスタンスプロファイルは、プライベートデバイスフリートの1つまたは複数の
# デバイスインスタンスに適用できるプロファイルを作成します。
# テスト実行後のデバイスの挙動（再起動、パッケージクリーンアップ等）を制御できます。
#
# AWS公式ドキュメント:
#   - Device Farm概要: https://docs.aws.amazon.com/devicefarm/latest/developerguide/welcome.html
#   - インスタンスプロファイルの作成: https://docs.aws.amazon.com/devicefarm/latest/developerguide/set-up-private-devices-account-settings.html
#   - CreateInstanceProfile API: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateInstanceProfile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_instance_profile
#
# NOTE: AWS Device Farmは現在、限られたリージョンでのみ利用可能です（例: us-west-2）。
#       サポートされるリージョンについては以下を参照:
#       https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_devicefarm_instance_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: インスタンスプロファイルの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: Device Farmコンソールでプロファイルを識別するための名前です。
  name = "example-instance-profile"

  # description (Optional)
  # 設定内容: インスタンスプロファイルの説明を指定します。
  # 設定可能な値: 文字列
  # 省略時: なし
  description = "Example Device Farm instance profile for automated testing"

  #-------------------------------------------------------------
  # デバイス動作設定
  #-------------------------------------------------------------

  # reboot_after_use (Optional)
  # 設定内容: テスト実行後にデバイスを再起動するかどうかを指定します。
  # 設定可能な値:
  #   - true: テスト実行後にデバイスを再起動する
  #   - false: テスト実行後にデバイスを再起動しない
  # 省略時: true
  # 関連機能: Device Farmインスタンス管理
  #   再起動により、次のテスト実行前にデバイスをクリーンな状態にリセットできます。
  reboot_after_use = true

  # package_cleanup (Optional)
  # 設定内容: テスト実行後にDevice Farmがアプリパッケージを削除するかどうかを指定します。
  # 設定可能な値:
  #   - true: テスト実行後にアプリパッケージを削除する
  #   - false: テスト実行後にアプリパッケージを削除しない
  # 省略時: false（プライベートデバイスの場合）
  # 関連機能: Device Farmパッケージ管理
  #   パッケージクリーンアップにより、デバイスのストレージを管理し、
  #   次のテスト実行に影響を与えないようにできます。
  package_cleanup = false

  # exclude_app_packages_from_cleanup (Optional)
  # 設定内容: テスト実行後にクリーンアップしないアプリパッケージのリストを指定します。
  # 設定可能な値: アプリパッケージ名の文字列セット
  # 省略時: なし
  # 注意: package_cleanupがtrueの場合でも、ここで指定したパッケージは保持されます。
  #       繰り返しテストで使用するユーティリティアプリなどを保持する場合に便利です。
  exclude_app_packages_from_cleanup = [
    "com.example.utility",
    "com.example.testhelper",
  ]

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Device Farmは現在、限られたリージョンでのみ利用可能です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
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
    Name        = "example-instance-profile"
    Environment = "testing"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: このインスタンスプロファイルのAmazon Resource Name (ARN)
#
# - id: リソースのID（インスタンスプロファイルのARN）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
