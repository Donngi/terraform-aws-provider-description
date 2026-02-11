#---------------------------------------------------------------
# AWS Directory Service RADIUS Settings
#---------------------------------------------------------------
#
# AWS Directory ServiceのRADIUS設定を管理するリソースです。
# Multi-Factor Authentication (MFA) を Remote Authentication Dial In User Service
# (RADIUS) サーバーを使用して有効化します。
#
# このリソースはAWS Managed Microsoft ADまたはAD Connectorディレクトリに対して
# RADIUSベースのMFAを設定する際に使用します。RADIUSサーバーは
# ワンタイムパスコード (OTP) を実装している必要があります。
#
# AWS公式ドキュメント:
#   - Managed Microsoft ADでのMFA有効化: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_mfa.html
#   - AD ConnectorでのMFA有効化: https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ad_connector_mfa.html
#   - EnableRadius API: https://docs.aws.amazon.com/directoryservice/latest/devguide/API_EnableRadius.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_radius_settings
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_directory_service_radius_settings" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # directory_id (Required)
  # 設定内容: RADIUS設定を有効化するディレクトリの識別子を指定します。
  # 設定可能な値: 有効なディレクトリID（例: d-1234567890）
  # 注意: AWS Managed Microsoft ADまたはAD Connectorディレクトリで使用可能です。
  #       Simple ADではMFAは利用できません。
  directory_id = aws_directory_service_directory.example.id

  # display_label (Required)
  # 設定内容: 表示ラベルを指定します。
  # 設定可能な値: 任意の文字列
  # 注意: MFAログイン画面でユーザーに表示されるラベルです。
  display_label = "example-mfa"

  #-------------------------------------------------------------
  # RADIUSサーバー設定
  #-------------------------------------------------------------

  # radius_servers (Required)
  # 設定内容: RADIUSサーバーエンドポイントのFQDNまたはIPアドレスを指定します。
  # 設定可能な値: RADIUSサーバーのFQDNまたはIPアドレスの配列
  # 注意: RADIUSサーバーロードバランサーのFQDNまたはIPアドレスも指定可能です。
  #       複数のサーバーを指定することで冗長性を確保できます。
  radius_servers = ["10.0.1.5"]

  # radius_port (Required)
  # 設定内容: RADIUSサーバーが通信に使用するポート番号を指定します。
  # 設定可能な値: 有効なポート番号（通常は1812）
  # 注意: セルフマネージドネットワークは、AWS Directory Serviceサーバーからの
  #       このポートへのインバウンドトラフィックを許可する必要があります。
  #       VPCセキュリティグループでポート1812（UDP）を開放してください。
  radius_port = 1812

  # radius_timeout (Required)
  # 設定内容: RADIUSサーバーからの応答を待機する秒数を指定します。
  # 設定可能な値: 1〜50の整数
  # 注意: タイムアウト値が短すぎるとネットワーク遅延時に認証失敗が発生する
  #       可能性があります。適切な値を設定してください。
  radius_timeout = 1

  # radius_retries (Required)
  # 設定内容: RADIUSサーバーとの通信を試行する最大回数を指定します。
  # 設定可能な値: 0〜10の整数
  # 注意: リトライ回数を増やすと、ネットワーク問題発生時の耐障害性が向上しますが、
  #       認証応答時間が長くなる可能性があります。
  radius_retries = 4

  #-------------------------------------------------------------
  # 認証設定
  #-------------------------------------------------------------

  # authentication_protocol (Required)
  # 設定内容: RADIUSエンドポイントで使用する認証プロトコルを指定します。
  # 設定可能な値:
  #   - "PAP": Password Authentication Protocol（最もシンプル、パスワードが平文で送信）
  #   - "CHAP": Challenge Handshake Authentication Protocol
  #   - "MS-CHAPv1": Microsoft CHAP version 1
  #   - "MS-CHAPv2": Microsoft CHAP version 2（推奨、最もセキュア）
  # 注意: セキュリティ上の理由から、可能であればMS-CHAPv2の使用を推奨します。
  authentication_protocol = "PAP"

  # shared_secret (Required, Sensitive)
  # 設定内容: RADIUSサーバーとの通信で使用する共有シークレットを指定します。
  # 設定可能な値: 任意の文字列（十分な長さと複雑さを持つものを推奨）
  # 注意: この値はセンシティブ属性としてマークされており、
  #       Terraformの出力やログには表示されません。
  #       シークレットはRADIUSサーバー側と一致する必要があります。
  #       本番環境では、環境変数や秘密管理サービス（AWS Secrets Manager等）から
  #       取得することを推奨します。
  shared_secret = "your-secure-shared-secret"

  # use_same_username (Optional)
  # 設定内容: 同じユーザー名を使用するかどうかを指定します。
  # 設定可能な値: true または false
  # 省略時: 設定されません
  # 注意: 現在このパラメータは使用されていません（AWSドキュメントより）。
  use_same_username = null

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディレクトリの識別子（directory_idと同じ値）
#
#---------------------------------------------------------------
