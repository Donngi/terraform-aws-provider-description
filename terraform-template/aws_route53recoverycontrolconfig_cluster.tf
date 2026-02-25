#---------------------------------------------------------------
# AWS Route 53 Application Recovery Controller - クラスター
#---------------------------------------------------------------
#
# Amazon Route 53 Application Recovery Controller (ARC) のクラスターを
# プロビジョニングするリソースです。クラスターは、ルーティングコントロールの
# 状態を管理するための論理的なコンテナであり、高可用性を実現するために
# 5つのリージョンに分散されたエンドポイントを提供します。
#
# クラスターはコントロールプレーン全体の基盤となり、アプリケーションの
# フェイルオーバーを制御するルーティングコントロールおよびコントロールパネルを
# 格納します。
#
# AWS公式ドキュメント:
#   - ARCクラスターの作成: https://docs.aws.amazon.com/r53recovery/latest/dg/introduction-components-routing.html
#   - Application Recovery Controller概要: https://docs.aws.amazon.com/r53recovery/latest/dg/index.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/route53recoverycontrolconfig_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53recoverycontrolconfig_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: クラスターを識別するための一意の名前を指定します。
  # 設定可能な値: 文字列。AWSアカウント内で一意である必要があります
  # 用途: Route 53 ARCの管理コンソールやAPIで識別するために使用されます
  name = "my-recovery-cluster"

  # network_type (Optional)
  # 設定内容: クラスターのネットワークタイプを指定します。
  # 設定可能な値:
  #   - "IPV4": IPv4のみのエンドポイントを使用（デフォルト）
  #   - "DUALSTACK": IPv4とIPv6の両方のエンドポイントを使用
  # 省略時: "IPV4" が使用されます
  # 関連機能: デュアルスタック対応
  #   IPv6をサポートするネットワーク環境でARCのエンドポイントに
  #   アクセスする場合は "DUALSTACK" を選択します。
  network_type = "IPV4"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "my-recovery-cluster"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クラスターのAmazon Resource Name (ARN)
#
# - cluster_endpoints: クラスターと通信するための5リージョンの
#        エンドポイントリスト。各エントリに endpoint と region が含まれます
#
# - status: クラスターのステータス
#        作成中: "PENDING"
#        削除中: "PENDING_DELETION"
#        それ以外: "DEPLOYED"
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
