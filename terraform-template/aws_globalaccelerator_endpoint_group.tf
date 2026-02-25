#---------------------------------------------------------------
# AWS Global Accelerator エンドポイントグループ
#---------------------------------------------------------------
#
# AWS Global Accelerator のリスナーに関連付けるエンドポイントグループを
# プロビジョニングするリソースです。エンドポイントグループは特定のAWSリージョンに
# 紐づき、そのリージョン内のエンドポイント（ALB、NLB、EC2インスタンス、EIPなど）
# へのトラフィック分散を制御します。ヘルスチェックやポートオーバーライドなどの
# 詳細な設定が可能です。
#
# AWS公式ドキュメント:
#   - エンドポイントグループ: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-endpoint-groups.html
#   - ヘルスチェック: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-endpoint-groups-health-check-options.html
#   - ポートオーバーライド: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-endpoint-groups-port-override.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_endpoint_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_endpoint_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # listener_arn (Required)
  # 設定内容: エンドポイントグループを関連付けるリスナーのARNを指定します。
  # 設定可能な値: aws_globalaccelerator_listener リソースのARN
  listener_arn = aws_globalaccelerator_listener.example.id

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # endpoint_group_region (Optional)
  # 設定内容: エンドポイントグループが属するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  endpoint_group_region = "ap-northeast-1"

  #-------------------------------------------------------------
  # トラフィック制御
  #-------------------------------------------------------------

  # traffic_dial_percentage (Optional)
  # 設定内容: このエンドポイントグループに送信するトラフィックの割合を指定します。
  # 設定可能な値: 0〜100 の数値（小数点以下も指定可能）
  # 省略時: 100（全トラフィックをこのグループに送信）
  # 注意: 段階的なデプロイや障害時の切り替えに利用できます
  traffic_dial_percentage = 100

  #-------------------------------------------------------------
  # ヘルスチェック設定
  #-------------------------------------------------------------

  # health_check_protocol (Optional)
  # 設定内容: エンドポイントのヘルスチェックに使用するプロトコルを指定します。
  # 設定可能な値:
  #   - "HTTP": HTTPプロトコルを使用
  #   - "HTTPS": HTTPSプロトコルを使用
  #   - "TCP": TCPプロトコルを使用
  # 省略時: リスナーのプロトコルに応じて自動決定（TCPリスナーは "TCP"、それ以外は "HTTP"）
  health_check_protocol = "HTTP"

  # health_check_port (Optional)
  # 設定内容: ヘルスチェックを実行するポート番号を指定します。
  # 設定可能な値: 1〜65535 の整数
  # 省略時: リスナーポートを使用
  health_check_port = 80

  # health_check_path (Optional)
  # 設定内容: HTTP/HTTPSヘルスチェックのリクエストパスを指定します。
  # 設定可能な値: スラッシュ（/）で始まるパス文字列
  # 省略時: "/"
  # 注意: health_check_protocol が "TCP" の場合は無効
  health_check_path = "/"

  # health_check_interval_seconds (Optional)
  # 設定内容: ヘルスチェックの実行間隔を秒単位で指定します。
  # 設定可能な値: 10 または 30
  # 省略時: 30
  health_check_interval_seconds = 30

  # threshold_count (Optional)
  # 設定内容: エンドポイントを正常または異常と判断するために必要な連続したヘルスチェック数を指定します。
  # 設定可能な値: 1〜10 の整数
  # 省略時: 3
  threshold_count = 3

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # endpoint_configuration (Optional)
  # 設定内容: グループに追加するエンドポイントの設定を指定するブロックです。
  # 注意: 複数のエンドポイントを追加する場合は、ブロックを繰り返して指定します
  endpoint_configuration {
    # endpoint_id (Optional)
    # 設定内容: エンドポイントのIDを指定します。
    # 設定可能な値:
    #   - ALB の場合: ALB の ARN
    #   - NLB の場合: NLB の ARN
    #   - EC2インスタンスの場合: インスタンスID
    #   - EIPの場合: Elastic IP アロケーションID
    endpoint_id = aws_lb.example.arn

    # weight (Optional)
    # 設定内容: このエンドポイントへのトラフィックの重み（割合）を指定します。
    # 設定可能な値: 0〜255 の整数
    # 省略時: 128
    # 注意: 値が0の場合、ヘルスチェックは継続しますがトラフィックは送信されません
    weight = 128

    # client_ip_preservation_enabled (Optional)
    # 設定内容: クライアントIPアドレスの保持を有効にするかどうかを指定します。
    # 設定可能な値: true, false
    # 省略時: ALBエンドポイントは true、その他のエンドポイントは false
    # 注意: ALBエンドポイントでのみサポートされます
    client_ip_preservation_enabled = true

    # attachment_arn (Optional)
    # 設定内容: クロスアカウントアタッチメントのARNを指定します。
    # 設定可能な値: aws_globalaccelerator_cross_account_attachment リソースのARN
    # 注意: クロスアカウントリソースをエンドポイントとして使用する場合に必要です
    attachment_arn = null
  }

  #-------------------------------------------------------------
  # ポートオーバーライド設定
  #-------------------------------------------------------------

  # port_override (Optional)
  # 設定内容: リスナーポートとエンドポイントポートのマッピングを指定するブロックです。
  # 注意: 最大10件まで指定できます
  #       リスナーポートとエンドポイントポートが異なる場合に設定します
  port_override {
    # listener_port (Required)
    # 設定内容: マッピング元となるリスナーのポート番号を指定します。
    # 設定可能な値: 1〜65535 の整数
    # 注意: リスナーに設定されたポート範囲内の値である必要があります
    listener_port = 443

    # endpoint_port (Required)
    # 設定内容: マッピング先となるエンドポイントのポート番号を指定します。
    # 設定可能な値: 1〜65535 の整数
    endpoint_port = 8443
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）、"Xh"（時間）などの期間文字列
    # 省略時: 30m
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）、"Xh"（時間）などの期間文字列
    # 省略時: 30m
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "Xm"（分）、"Xh"（時間）などの期間文字列
    # 省略時: 30m
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: エンドポイントグループのARN
#
# - arn: エンドポイントグループのARN
#
# - endpoint_group_region: エンドポイントグループが属するAWSリージョン
#---------------------------------------------------------------
