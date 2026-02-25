#---------------------------------------------------------------
# AWS Global Accelerator Listener
#---------------------------------------------------------------
#
# AWS Global Acceleratorのアクセラレーターにリスナーをプロビジョニングする
# リソースです。リスナーは、クライアントからアクセラレーターへの接続を
# ポート範囲とプロトコルに基づいて処理し、設定されたエンドポイントグループへ
# トラフィックを転送します。
#
# AWS公式ドキュメント:
#   - リスナーの概要: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-listeners.html
#   - リスナーの設定: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-listeners.creating-editing.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_listener
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_listener" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # accelerator_arn (Required)
  # 設定内容: このリスナーを関連付けるアクセラレーターのARNを指定します。
  # 設定可能な値: 有効なGlobal AcceleratorアクセラレーターのARN文字列
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-listeners.html
  accelerator_arn = "arn:aws:globalaccelerator::123456789012:accelerator/1234abcd-abcd-1234-abcd-1234abcdefgh"

  # protocol (Required)
  # 設定内容: クライアントからアクセラレーターへの接続に使用するプロトコルを指定します。
  # 設定可能な値: "TCP" | "UDP"
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-listeners.html
  protocol = "TCP"

  #-------------------------------------------------------------
  # クライアントアフィニティ設定
  #-------------------------------------------------------------

  # client_affinity (Optional)
  # 設定内容: 特定のクライアントからのトラフィックを常に同じエンドポイントに
  #           転送するかどうかを制御するクライアントアフィニティを指定します。
  # 設定可能な値: "NONE" | "SOURCE_IP"
  #   - "NONE": クライアントアフィニティを無効にします（デフォルト）。
  #             各接続は独立してエンドポイントに割り当てられます。
  #   - "SOURCE_IP": 同じ送信元IPアドレスからの接続を
  #                  常に同じエンドポイントに転送します。
  # 省略時: "NONE"
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-listeners-client-affinity.html
  client_affinity = "NONE"

  #-------------------------------------------------------------
  # ポート範囲設定
  #-------------------------------------------------------------

  # port_range (Required, セット型, 最小1件・最大10件)
  # 設定内容: クライアントからアクセラレーターへの接続に使用するポート範囲を指定します。
  # 設定可能な値: from_port と to_port の組み合わせ（ポート番号: 1-65535）
  # 注意: リスナーあたり最大10件のポート範囲を設定可能です。
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/about-listeners.html
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
# - id: リスナーのID（ARNと同値）
# - arn: Global AcceleratorリスナーのAmazon Resource Name (ARN)
#---------------------------------------------------------------
