#---------------------------------------------------------------
# AWS VPC Lattice Listener Rule
#---------------------------------------------------------------
#
# Amazon VPC Latticeのリスナールールをプロビジョニングするリソースです。
# リスナールールは、リクエストの属性（HTTPメソッド、パス、ヘッダー等）に基づいて
# トラフィックをターゲットグループへルーティングするか、固定レスポンスを返すかを
# 決定します。優先度（priority）に従ってルールが評価されます。
#
# AWS公式ドキュメント:
#   - VPC Lattice概要: https://docs.aws.amazon.com/vpc-lattice/latest/ug/what-is-vpc-lattice.html
#   - リスナールール: https://docs.aws.amazon.com/vpc-lattice/latest/ug/listeners.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_listener_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpclattice_listener_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # service_identifier (Required)
  # 設定内容: ルールを関連付けるVPC Latticeサービスのリソース識別子を指定します。
  # 設定可能な値: VPC LatticeサービスのIDまたはARN
  service_identifier = "svc-0123456789abcdef0"

  # listener_identifier (Required)
  # 設定内容: ルールを関連付けるリスナーのリソース識別子を指定します。
  # 設定可能な値: VPC LatticeリスナーのIDまたはARN
  listener_identifier = "listener-0123456789abcdef0"

  # name (Required)
  # 設定内容: リスナールールの名前を指定します。
  # 設定可能な値: 文字列（英数字、ハイフン）
  name = "example-listener-rule"

  # priority (Required)
  # 設定内容: リスナールールの優先度を指定します。
  #           数値が小さいほど優先度が高く、先に評価されます。
  # 設定可能な値: 1〜100の整数
  priority = 10

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # action (Required)
  # 設定内容: ルールにマッチしたリクエストに対して実行するアクションを指定します。
  #           forward（ターゲットグループへ転送）または
  #           fixed_response（固定レスポンス返却）のどちらか一方を指定します。
  action {
    # forward (Optional)
    # 設定内容: リクエストを1つ以上のターゲットグループへ転送するアクションです。
    #           fixed_responseと同時には指定できません。
    forward {
      # target_groups (Required, min: 1)
      # 設定内容: 転送先ターゲットグループとその重みを指定します。
      #           複数指定した場合は重みに応じて加重ルーティングされます。
      target_groups {
        # target_group_identifier (Required)
        # 設定内容: 転送先ターゲットグループのIDまたはARNを指定します。
        # 設定可能な値: VPC LatticeターゲットグループのIDまたはARN
        target_group_identifier = "tg-0123456789abcdef0"

        # weight (Optional)
        # 設定内容: このターゲットグループへのトラフィックの重みを指定します。
        #           複数のターゲットグループを使用する場合、重みの合計に対する
        #           このグループの割合でトラフィックが分散されます。
        # 設定可能な値: 0〜999の整数
        # 省略時: デフォルトの重みが適用されます
        weight = 100
      }
    }

    # fixed_response (Optional)
    # 設定内容: リクエストに対して固定のHTTPステータスコードを返すアクションです。
    #           forwardと同時には指定できません。
    # fixed_response {
    #   # status_code (Required)
    #   # 設定内容: レスポンスとして返すHTTPステータスコードを指定します。
    #   # 設定可能な値: 有効なHTTPステータスコード（例: 404, 503）
    #   status_code = 404
    # }
  }

  #-------------------------------------------------------------
  # マッチ条件設定
  #-------------------------------------------------------------

  # match (Required)
  # 設定内容: ルールを適用するリクエストのマッチ条件を指定します。
  #           現在はhttp_matchのみサポートされています。
  match {
    # http_match (Required, min: 1, max: 1)
    # 設定内容: HTTPリクエストの属性に基づくマッチ条件を指定します。
    http_match {
      # method (Optional)
      # 設定内容: マッチ対象のHTTPメソッドを指定します。
      # 設定可能な値: "GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"
      # 省略時: 全てのHTTPメソッドにマッチします
      method = "GET"

      # header_matches (Optional, max: 5)
      # 設定内容: マッチ対象のHTTPヘッダー条件を指定します。
      #           最大5つのヘッダー条件を指定できます。
      header_matches {
        # name (Required)
        # 設定内容: マッチ対象のHTTPヘッダー名を指定します。
        # 設定可能な値: 有効なHTTPヘッダー名（例: "content-type", "authorization"）
        name = "content-type"

        # case_sensitive (Optional)
        # 設定内容: ヘッダー値のマッチングで大文字・小文字を区別するかどうかを指定します。
        # 設定可能な値: true（区別する）/ false（区別しない）
        # 省略時: false（区別しない）
        case_sensitive = false

        # match (Required, min: 1, max: 1)
        # 設定内容: ヘッダー値のマッチング方式を指定します。
        #           contains、exact、prefixのいずれか一つを指定します。
        match {
          # contains (Optional)
          # 設定内容: ヘッダー値が指定した文字列を含む場合にマッチします。
          # 設定可能な値: 文字列
          # 省略時: このマッチング方式は使用されません
          contains = "application/json"

          # exact (Optional)
          # 設定内容: ヘッダー値が指定した文字列と完全一致する場合にマッチします。
          # 設定可能な値: 文字列
          # 省略時: このマッチング方式は使用されません
          # exact = "application/json"

          # prefix (Optional)
          # 設定内容: ヘッダー値が指定した文字列で始まる場合にマッチします。
          # 設定可能な値: 文字列
          # 省略時: このマッチング方式は使用されません
          # prefix = "application"
        }
      }

      # path_match (Optional, max: 1)
      # 設定内容: リクエストパスに基づくマッチ条件を指定します。
      path_match {
        # case_sensitive (Optional)
        # 設定内容: パスのマッチングで大文字・小文字を区別するかどうかを指定します。
        # 設定可能な値: true（区別する）/ false（区別しない）
        # 省略時: false（区別しない）
        case_sensitive = true

        # match (Required, min: 1, max: 1)
        # 設定内容: パスのマッチング方式を指定します。
        #           exactまたはprefixのいずれか一つを指定します。
        match {
          # exact (Optional)
          # 設定内容: パスが指定した文字列と完全一致する場合にマッチします。
          # 設定可能な値: 文字列（スラッシュ始まり、例: "/api/v1/users"）
          # 省略時: このマッチング方式は使用されません
          # exact = "/api/v1/users"

          # prefix (Optional)
          # 設定内容: パスが指定した文字列で始まる場合にマッチします。
          # 設定可能な値: 文字列（スラッシュ始まり、例: "/api/"）
          # 省略時: このマッチング方式は使用されません
          prefix = "/api/"
        }
      }
    }
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
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
  tags = {
    Name        = "example-listener-rule"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 各操作のタイムアウト時間を指定します。
  # 関連機能: Terraform Operation Timeouts
  #   リソースの作成・更新・削除操作に対するタイムアウトをカスタマイズできます。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リスナールールのAmazon Resource Name (ARN)
#
# - id: リスナールールのID
#
# - rule_id: リスナールールの一意の識別子
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
