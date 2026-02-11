#---------------------------------------------------------------
# Amazon Route 53 Hosted Zone
#---------------------------------------------------------------
#
# Amazon Route 53のホストゾーンをプロビジョニングするリソースです。
# ホストゾーンは、特定のドメイン（example.comなど）とそのサブドメイン
# （acme.example.com、zenith.example.comなど）に対してトラフィックを
# ルーティングする方法に関する情報を含むレコードのコンテナです。
# パブリックホストゾーンとプライベートホストゾーンの2種類があります。
#
# AWS公式ドキュメント:
#   - ホストゾーンの使用: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html
#   - パブリックホストゾーンの使用: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/AboutHZWorkingWith.html
#   - プライベートホストゾーンの使用: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_route53_zone" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ホストゾーンの名前を指定します。
  # 設定可能な値: 完全修飾ドメイン名（FQDN）形式の文字列（例: example.com）
  # 関連機能: Route 53 ホストゾーン
  #   ホストゾーンと対応するドメインは同じ名前を持ちます。
  #   パブリックホストゾーンはインターネット上のトラフィックルーティングに、
  #   プライベートホストゾーンはAmazon VPC内のトラフィックルーティングに使用されます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html
  name = "example.com"

  # comment (Optional)
  # 設定内容: ホストゾーンに関するコメントを指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" がデフォルトとして設定されます。
  # 用途: ホストゾーンの用途や管理情報を記録する際に使用します。
  comment = "Managed by Terraform"

  #-------------------------------------------------------------
  # 委任セット設定
  #-------------------------------------------------------------

  # delegation_set_id (Optional)
  # 設定内容: ホストゾーンに割り当てる再利用可能な委任セットのIDを指定します。
  # 設定可能な値: 再利用可能な委任セットのID
  # 関連機能: Route 53 再利用可能な委任セット
  #   複数のホストゾーンに同じネームサーバーを割り当てることで、
  #   DNSサービスをRoute 53に移行する際の作業を簡素化できます。
  #   デフォルトでは、Route 53は各ホストゾーンに一意の委任セットを割り当てますが、
  #   再利用可能な委任セットをプログラムで作成することができます。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-public-considerations.html
  # 注意: vpcブロックと競合します。委任セットはパブリックホストゾーンにのみ使用できます。
  delegation_set_id = null

  #-------------------------------------------------------------
  # 高速復旧設定
  #-------------------------------------------------------------

  # enable_accelerated_recovery (Optional)
  # 設定内容: ホストゾーンの高速復旧を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 高速復旧を有効化
  #   - false (デフォルト): 高速復旧を無効化
  # 省略時: false が設定されます。
  # 注意: 一度設定すると、falseに戻す場合は引数を削除するのではなく、
  #      明示的にfalseを指定する必要があります。
  enable_accelerated_recovery = false

  #-------------------------------------------------------------
  # 削除動作設定
  #-------------------------------------------------------------

  # force_destroy (Optional)
  # 設定内容: ホストゾーンを削除する際に、ゾーン内のすべてのレコード
  #          （Terraform外で管理されている可能性のあるレコードを含む）を
  #          破棄するかを指定します。
  # 設定可能な値:
  #   - true: ホストゾーン削除時に全レコードを削除
  #   - false (デフォルト): レコードが存在する場合、削除を拒否
  # 省略時: false が設定されます。
  # 用途: テスト環境や一時的なホストゾーンで、クリーンアップを簡素化する際に使用します。
  # 注意: 本番環境での使用には十分注意してください。
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: ホストゾーンに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-hosted-zone"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # VPC関連付け設定（プライベートホストゾーン用）
  #-------------------------------------------------------------

  # vpc (Optional)
  # 設定内容: プライベートホストゾーンに関連付けるVPCを指定します。
  # 注意: delegation_set_id引数およびaws_route53_zone_associationリソースと競合します。
  #      委任セットはパブリックホストゾーンにのみ使用できます。
  # 関連機能: Route 53 プライベートホストゾーン
  #   プライベートホストゾーンは、1つ以上のVPC内でDNSクエリを管理するための
  #   コンテナです。プライベートホストゾーンを作成するには、関連付けるVPCを
  #   指定し、ドメインとサブドメインに対するRoute 53の応答方法を決定する
  #   レコードを追加します。
  #   - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html
  # 用途: 複数のvpcブロックを追加して、追加のVPCを関連付けることができます。
  vpc {
    # vpc_id (Required)
    # 設定内容: 関連付けるVPCのIDを指定します。
    # 設定可能な値: 有効なVPC ID
    # 注意: VPCでは、DNSホスト名とDNSサポートを有効にする必要があります。
    #      - https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-considerations.html
    vpc_id = "vpc-12345678"

    # vpc_region (Optional)
    # 設定内容: 関連付けるVPCのリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
    # 省略時: AWSプロバイダーのリージョン設定を使用します。
    # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
    vpc_region = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  # 用途: デフォルトのタイムアウト時間では不十分な場合に調整します。
  timeouts {
    # create (Optional)
    # 設定内容: ホストゾーン作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = null

    # update (Optional)
    # 設定内容: ホストゾーン更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    update = null

    # delete (Optional)
    # 設定内容: ホストゾーン削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ホストゾーンのAmazon Resource Name (ARN)
#
# - zone_id: ホストゾーンID。ゾーンレコードから参照できます。
#
# - name_servers: 関連付けられた（またはデフォルトの）委任セット内の
#                ネームサーバーのリスト。
#                委任セットの詳細については、AWSドキュメントを参照してください。
#                - https://docs.aws.amazon.com/Route53/latest/APIReference/actions-on-reusable-delegation-sets.html
#
# - primary_name_server: SOAレコードを作成したRoute 53ネームサーバー。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#            リソースに割り当てられたすべてのタグのマップ。
#            - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#---------------------------------------------------------------
