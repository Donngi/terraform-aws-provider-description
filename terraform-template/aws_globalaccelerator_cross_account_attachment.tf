#---------------------------------------------------------------
# AWS Global Accelerator Cross Account Attachment
#---------------------------------------------------------------
#
# AWS Global Acceleratorのクロスアカウントアタッチメントをプロビジョニングするリソースです。
# クロスアカウントアタッチメントは、リソースの所有者が他のAWSアカウントや
# アクセラレーターARNに対して、自身のアカウントのリソースをアクセラレーターの
# エンドポイントとして追加することを許可するための仕組みです。
# プリンシパル（AWSアカウントIDまたはアクセラレーターARN）を指定し、
# 共有するリソース（エンドポイントARNまたはCIDRブロック）を定義します。
#
# AWS公式ドキュメント:
#   - クロスアカウントアタッチメントの操作: https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.work-with-attachments.html
#   - クロスアカウントの仕組み: https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.how-it-works.html
#   - クロスアカウント設定の概要: https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_cross_account_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_globalaccelerator_cross_account_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: クロスアカウントアタッチメントの名前を指定します。
  # 設定可能な値: 最大64文字の文字列
  name = "example-cross-account-attachment"

  #-------------------------------------------------------------
  # プリンシパル設定
  #-------------------------------------------------------------

  # principals (Optional)
  # 設定内容: アクセラレーターにリソースを関連付けることを許可するAWSアカウントIDまたは
  #           アクセラレーターARNのセットを指定します。
  # 設定可能な値:
  #   - AWSアカウントID（12桁の数字）: 指定したアカウントがリソースを使用可能
  #   - アクセラレーターARN（"arn:..."形式）: 指定したアクセラレーターがリソースを使用可能
  # 省略時: プリンシパルを設定しない（後から追加可能）
  # 参考: https://docs.aws.amazon.com/global-accelerator/latest/api/API_Attachment.html
  principals = [
    "123456789012",
  ]

  #-------------------------------------------------------------
  # リソース設定
  #-------------------------------------------------------------

  # resource (Optional)
  # 設定内容: アクセラレーターに関連付けるリソースの設定ブロックです。
  #           エンドポイントリソース（ARN指定）またはBYOIP CIDRブロックを指定します。
  # 関連機能: Global Accelerator クロスアカウントリソース共有
  #   リソース所有者がアクセラレーターのエンドポイントとして使用を許可する
  #   リソース（Network Load Balancer等）やBYOIP IPアドレス範囲を定義します。
  #   - https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.work-with-attachments.html
  resource {

    # endpoint_id (Optional)
    # 設定内容: AWSリソースとして指定するエンドポイントIDを指定します。
    # 設定可能な値: サポートされるAWSリソースのARN
    #   （例: Network Load BalancerのARN）
    # 注意: cidr_blockとendpoint_idはどちらか一方のみ指定します
    endpoint_id = "arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/50dc6c495c0c9188"

    # region (Optional)
    # 設定内容: 共有エンドポイントリソースが存在するAWSリージョンを指定します。
    # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, ap-northeast-1）
    # 省略時: リージョンを指定しない
    region = "us-west-2"

    # cidr_block (Optional)
    # 設定内容: リソースとして指定するIPアドレス範囲をCIDR形式で指定します。
    #           BYOIPプロセスでGlobal Acceleratorにプロビジョニング済みのIPアドレス範囲を指定します。
    # 設定可能な値: CIDR形式のIPアドレス範囲（例: "203.0.113.0/24"）
    # 省略時: CIDRブロックを指定しない
    # 注意: endpoint_idとcidr_blockはどちらか一方のみ指定します
    # 参考: https://docs.aws.amazon.com/global-accelerator/latest/dg/cross-account-resources.how-it-works.html
    cidr_block = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-cross-account-attachment"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: クロスアカウントアタッチメントのARN
# - id: クロスアカウントアタッチメントのID
# - created_time: クロスアカウントアタッチメントの作成日時
# - last_modified_time: クロスアカウントアタッチメントの最終更新日時
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
