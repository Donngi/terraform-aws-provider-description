#---------------------------------------------------------------
# AWS MSK Serverless Cluster
#---------------------------------------------------------------
#
# Amazon Managed Streaming for Apache Kafka (MSK) Serverlessクラスターを
# プロビジョニングするリソースです。
# MSK Serverlessは、Apache Kafkaをサーバーレスで実行できるクラスタータイプで、
# クラスターの容量管理やスケーリングを自動的に行います。
# スループットベースの料金モデルにより、使用した分だけ支払います。
#
# 注意: プロビジョンドMSKクラスターを管理する場合は、aws_msk_clusterリソースを使用してください。
#
# AWS公式ドキュメント:
#   - MSK Serverless概要: https://docs.aws.amazon.com/msk/latest/developerguide/serverless.html
#   - MSK Serverlessクラスターの作成: https://docs.aws.amazon.com/msk/latest/developerguide/create-serverless-cluster.html
#   - MSK Serverless設定プロパティ: https://docs.aws.amazon.com/msk/latest/developerguide/serverless-config.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_serverless_cluster
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_msk_serverless_cluster" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # cluster_name (Required)
  # 設定内容: サーバーレスクラスターの名前を指定します。
  # 設定可能な値: 文字列
  # 注意: リソース作成後の変更はできません（Forces new resource）
  cluster_name = "example-serverless-cluster"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: MSK Serverlessは特定のリージョンでのみ利用可能です
  #       （US East (Ohio), US East (N. Virginia), US West (Oregon),
  #        Canada (Central), Asia Pacific (Mumbai, Singapore, Sydney, Tokyo, Seoul),
  #        Europe (Frankfurt, Stockholm, Ireland, Paris, London) など）
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
    Name        = "example-serverless-cluster"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # クライアント認証設定 (client_authentication)
  #-------------------------------------------------------------
  # サーバーレスクラスターのクライアント認証情報を指定します。
  # 注意: MSK ServerlessではIAMアクセスコントロールが必須です。
  #       Apache Kafka ACLはサポートされていません。

  client_authentication {
    #-----------------------------------------------------------
    # SASL認証設定 (sasl)
    #-----------------------------------------------------------
    # SASLを使用したクライアント認証の詳細を指定します。

    sasl {
      #---------------------------------------------------------
      # IAM認証設定 (iam)
      #---------------------------------------------------------
      # IAMを使用したクライアント認証の詳細を指定します。

      iam {
        # enabled (Required)
        # 設定内容: SASL/IAM認証を有効にするかどうかを指定します。
        # 設定可能な値:
        #   - true: IAM認証を有効にする（MSK Serverlessでは必須）
        #   - false: IAM認証を無効にする
        # 注意: MSK Serverlessでは、全てのクラスターでIAMアクセスコントロールが必要です。
        # 参考: https://docs.aws.amazon.com/msk/latest/developerguide/iam-access-control.html
        enabled = true
      }
    }
  }

  #-------------------------------------------------------------
  # VPC設定 (vpc_config)
  #-------------------------------------------------------------
  # サーバーレスクラスターのVPC設定情報を指定します。
  # 注意: 少なくとも2つの異なるアベイラビリティゾーンのサブネットが必要です。
  #       複数のvpc_configブロックを指定できます。

  vpc_config {
    # subnet_ids (Required)
    # 設定内容: クライアントアプリケーションをホストするサブネットのリストを指定します。
    # 設定可能な値: サブネットIDの配列
    # 注意: 少なくとも2つの異なるアベイラビリティゾーンのサブネットが必要です。
    #       これらのサブネット内からMSK Serverlessクラスターに接続します。
    subnet_ids = [
      "subnet-xxxxxxxxxxxxxxxxx",
      "subnet-yyyyyyyyyyyyyyyyy",
    ]

    # security_group_ids (Optional)
    # 設定内容: サーバーレスクラスターの受信・送信トラフィックを制御する
    #          セキュリティグループを最大5つまで指定します。
    # 設定可能な値: セキュリティグループIDの配列（最大5つ）
    # 省略時: MSKがデフォルトのセキュリティグループを作成します
    # 注意: クライアントアプリケーションからクラスターへのアクセスを許可する
    #       インバウンドルールを持つセキュリティグループを指定してください。
    security_group_ids = [
      "sg-xxxxxxxxxxxxxxxxx",
    ]
  }

  # 複数のVPC設定例（オプション）
  # 複数のVPCからアクセスする場合は、追加のvpc_configブロックを指定できます。
  # vpc_config {
  #   subnet_ids = [
  #     "subnet-aaaaaaaaaaaaaaa",
  #     "subnet-bbbbbbbbbbbbbbb",
  #   ]
  #   security_group_ids = [
  #     "sg-aaaaaaaaaaaaaaa",
  #   ]
  # }

  #-------------------------------------------------------------
  # タイムアウト設定 (timeouts)
  #-------------------------------------------------------------
  # リソースの作成・削除時のタイムアウトを指定します。

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルト値が適用されます
    # 注意: サーバーレスクラスターの作成には数分かかる場合があります。
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルト値が適用されます
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: サーバーレスクラスターのAmazon Resource Name (ARN)
#
# - bootstrap_brokers_sasl_iam: 1つ以上のDNS名（またはIPアドレス）と
#   SASL IAMポートのペア。
#   例: boot-abcdefg.c2.kafka-serverless.eu-central-1.amazonaws.com:9098
#   注意: リソースはリストをアルファベット順にソートします。
#         AWSが常に全てのエンドポイントを返すとは限らないため、
#         値はapply間で安定しない可能性があります。
#
# - cluster_uuid: サーバーレスクラスターのUUID。IAMポリシーで使用します。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
