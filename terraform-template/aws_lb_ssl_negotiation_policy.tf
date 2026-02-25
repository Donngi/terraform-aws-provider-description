#---------------------------------------------------------------
# AWS ELB SSL Negotiation Policy
#---------------------------------------------------------------
#
# Classic Load Balancer（ELB）のSSLネゴシエーションポリシーをプロビジョニングするリソースです。
# SSLネゴシエーションポリシーは、クライアントとロードバランサー間のSSLネゴシエーション時に
# サポートされる暗号方式とプロトコルをELBが制御するための設定です。
# このリソースはClassic ELB（aws_elb）のHTTPSリスナーに適用されます。
#
# AWS公式ドキュメント:
#   - ELBセキュリティポリシー: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
#   - SSLネゴシエーションの設定: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/ssl-config-update.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_ssl_negotiation_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_ssl_negotiation_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: SSLネゴシエーションポリシーの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-ssl-negotiation-policy"

  # load_balancer (Required)
  # 設定内容: ポリシーをアタッチするClassic Load BalancerのIDを指定します。
  # 設定可能な値: aws_elbリソースのID（ELB名）
  load_balancer = aws_elb.example.id

  # lb_port (Required)
  # 設定内容: ポリシーを適用するロードバランサーのポート番号を指定します。
  # 設定可能な値: ロードバランサーのアクティブなリスナーに設定されているポート番号（例: 443）
  # 注意: 指定するポートはロードバランサーのアクティブなHTTPSリスナーポートである必要があります。
  lb_port = 443

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 再デプロイトリガー設定
  #-------------------------------------------------------------

  # triggers (Optional)
  # 設定内容: 変更時にリソースの再デプロイをトリガーする任意のキーバリューマップを指定します。
  # 設定可能な値: 文字列のキーバリューマップ
  # 省略時: トリガーなし（attribute等の変更のみでデプロイが制御される）
  # 注意: キーや値を変更することでポリシーの強制的な再作成が可能です。
  triggers = {}

  #-------------------------------------------------------------
  # SSLポリシー属性設定
  #-------------------------------------------------------------

  # attribute (Optional)
  # 設定内容: SSLネゴシエーションポリシーの属性を指定するブロックです。
  #   各ブロックでSSLプロトコル、SSLオプション、SSLサイファーを個別に設定します。
  # 関連機能: ELB SSLセキュリティポリシー
  #   サポートされるSSLプロトコル、SSLオプション、SSLサイファーの一覧は
  #   AWS Elastic Load Balancing デベロッパーガイドを参照してください。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html
  # 注意: AWSドキュメントで「Server Order Preference」と記載されている機能は、
  #       API上では "Server-Defined-Cipher-Order" という属性名で設定します。

  # SSLプロトコル設定（古いプロトコルを無効化）
  attribute {
    # name (Required)
    # 設定内容: 属性名を指定します。SSLプロトコル、オプション、またはサイファー名。
    # 設定可能な値: SSLプロトコル（例: Protocol-TLSv1, Protocol-TLSv1.1, Protocol-TLSv1.2）、
    #   SSLオプション（例: Server-Defined-Cipher-Order）、
    #   SSLサイファー（例: ECDHE-RSA-AES128-GCM-SHA256, AES128-GCM-SHA256）
    name = "Protocol-TLSv1"

    # value (Required)
    # 設定内容: 属性の値を指定します。
    # 設定可能な値: "true"（有効化）または "false"（無効化）
    value = "false"
  }

  attribute {
    name  = "Protocol-TLSv1.1"
    value = "false"
  }

  attribute {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }

  # サーバー優先順位設定
  attribute {
    name  = "Server-Defined-Cipher-Order"
    value = "true"
  }

  # サイファー設定
  attribute {
    name  = "ECDHE-RSA-AES128-GCM-SHA256"
    value = "true"
  }

  attribute {
    name  = "AES128-GCM-SHA256"
    value = "true"
  }

  attribute {
    name  = "EDH-RSA-DES-CBC3-SHA"
    value = "false"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーのID
#---------------------------------------------------------------
