#---------------------------------------------------------------
# AWS Directory Service Shared Directory
#---------------------------------------------------------------
#
# AWS Directory Service 共有ディレクトリをプロビジョニングするリソースです。
# このリソースは、自分のアカウント（ディレクトリ所有者）のManaged Microsoft AD
# ディレクトリを別のAWSアカウント（ディレクトリ利用者）と共有するために使用します。
#
# AWS公式ドキュメント:
#   - AWS Directory Service概要: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html
#   - ディレクトリの共有: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_directory_sharing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_shared_directory
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_directory_service_shared_directory" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # directory_id (Required)
  # 設定内容: 他のアカウントと共有するManaged Microsoft ADディレクトリのIDを指定します。
  # 設定可能な値: 有効なディレクトリID（例: d-1234567890）
  # 注意: 共有できるのはManaged Microsoft ADディレクトリのみです。
  #       Simple ADやAD Connectorは共有できません。
  directory_id = aws_directory_service_directory.example.id

  # method (Optional)
  # 設定内容: ディレクトリを共有する際に使用する方法を指定します。
  # 設定可能な値:
  #   - "HANDSHAKE" (デフォルト): 共有招待を送信し、相手が承認することでディレクトリを共有
  #   - "ORGANIZATIONS": AWS Organizations経由でディレクトリを自動的に共有（組織内のアカウントのみ）
  # 省略時: "HANDSHAKE"
  # 関連機能: AWS Organizations
  #   - ORGANIZATIONSメソッドを使用するには、ディレクトリ所有者アカウントとターゲットアカウントが
  #     同じAWS Organizations組織に属している必要があります。
  #   - https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_directory_sharing.html
  method = "HANDSHAKE"

  # notes (Optional, Sensitive)
  # 設定内容: ディレクトリ所有者からディレクトリ利用者に送信するメッセージを指定します。
  # 設定可能な値: 任意の文字列
  # 用途: ディレクトリ利用者の管理者が共有招待を承認するかどうかを判断するための情報を提供します。
  # 注意: このフィールドはSensitiveとしてマークされており、Terraform出力では非表示になります。
  notes = "共有ディレクトリへのアクセスを許可してください。"

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
  # ターゲット設定
  #-------------------------------------------------------------

  # target (Required)
  # 設定内容: ディレクトリを共有するターゲットアカウントの情報を指定するブロックです。
  # 注意: このブロックは必須であり、正確に1つ指定する必要があります（min_items: 1, max_items: 1）。
  target {
    # id (Required)
    # 設定内容: ディレクトリ利用者アカウントの識別子を指定します。
    # 設定可能な値: AWSアカウントID（12桁の数字）
    # 例: "123456789012"
    id = "123456789012"

    # type (Optional)
    # 設定内容: id フィールドで使用する識別子のタイプを指定します。
    # 設定可能な値:
    #   - "ACCOUNT" (デフォルト): AWSアカウントIDを使用
    # 省略時: "ACCOUNT"
    type = "ACCOUNT"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間をカスタマイズします。
  timeouts {
    # delete (Optional)
    # 設定内容: リソースの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "60m", "2h"）
    # 省略時: デフォルトのタイムアウト値が適用されます
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: 共有ディレクトリの識別子
#
# - shared_directory_id: ディレクトリ利用者アカウントに保存されている、
#                        所有者アカウントの共有ディレクトリに対応するディレクトリの識別子
#---------------------------------------------------------------
