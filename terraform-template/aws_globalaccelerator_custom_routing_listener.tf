#---------------------------------------------------------------
# AWS Global Accelerator Custom Routing Listener
#---------------------------------------------------------------
#
# AWS Global Acceleratorのカスタムルーティングアクセラレーターに
# リスナーをプロビジョニングするリソースです。
# リスナーは、クライアントからアクセラレーターへの接続のポート範囲を処理し、
# VPCサブネットエンドポイントの特定のEC2インスタンスへトラフィックを
# 静的ポートマッピングで転送します。
#
# AWS公式ドキュメント:
#   - カスタムルーティングリスナーの概要: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-listeners.html
#   - カスタムルーティングアクセラレーターの仕組み: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-how-it-works.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_custom_routing_listener
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_custom_routing_listener" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # accelerator_arn (Required)
  # 設定内容: このリスナーを関連付けるカスタムルーティングアクセラレーターのARNを指定します。
  # 設定可能な値: 有効なカスタムルーティングアクセラレーターのARN文字列
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-listeners.html
  accelerator_arn = "arn:aws:globalaccelerator::123456789012:accelerator/1234abcd-abcd-1234-abcd-1234abcdefgh"

  #-------------------------------------------------------------
  # ポート範囲設定
  #-------------------------------------------------------------

  # port_range (Required, セット型, 最小1件・最大10件)
  # 設定内容: クライアントからアクセラレーターへの接続に使用するポート範囲を指定します。
  # 設定可能な値: from_port と to_port の組み合わせ（ポート番号: 1-65535）
  # 注意: リスナーあたり最大10件のポート範囲を設定可能。
  #       各ポート範囲は最低16ポートを含む必要があります。
  #       リスナー作成後にポート範囲を縮小することはできません。
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-custom-routing-guidelines.html
  port_range {
    # from_port (Optional)
    # 設定内容: ポート範囲の開始ポート番号（範囲に含む）を指定します。
    # 設定可能な値: 1-65535 の整数
    from_port = 80

    # to_port (Optional)
    # 設定内容: ポート範囲の終了ポート番号（範囲に含む）を指定します。
    # 設定可能な値: 1-65535 の整数
    to_port = 80
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間文字列形式（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間文字列形式（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goの時間文字列形式（例: "30m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタムルーティングリスナーのAmazon Resource Name (ARN)
#---------------------------------------------------------------
