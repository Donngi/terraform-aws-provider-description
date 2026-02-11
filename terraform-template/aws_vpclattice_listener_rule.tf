#---------------------------------------------------------------
# VPC Lattice Listener Rule
#
# VPC Lattice リスナールールを管理します。
# リスナーに対してルーティングルールを定義し、条件に基づいて
# リクエストをターゲットグループに転送したり、固定レスポンスを返したりします。
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/vpc-lattice/latest/ug/listener-rules.html
#
# Terraform AWS Provider Documentation:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpclattice_listener_rule
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
#
# NOTE: このテンプレートはリソースの理解を助けるためのものです。
# 実際の使用時は、環境に応じて適切な値を設定してください。
#---------------------------------------------------------------

resource "aws_vpclattice_listener_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: リスナールールの名前
  # 設定可能な値: a-z、0-9、ハイフン(-)の組み合わせ。先頭・末尾・連続してハイフンは使用不可
  # 省略時: 省略不可
  # 関連機能: VPC Lattice Listener - https://docs.aws.amazon.com/vpc-lattice/latest/ug/listeners.html
  name = "api-routing-rule"

  # listener_identifier (Required)
  # 設定内容: リスナーのIDまたはARN
  # 設定可能な値: VPC Lattice リスナーのIDまたはARN
  # 省略時: 省略不可
  # 関連機能: VPC Lattice Listener - https://docs.aws.amazon.com/vpc-lattice/latest/ug/listeners.html
  listener_identifier = "listener-0a1b2c3d4e5f6g7h8"

  # service_identifier (Required)
  # 設定内容: サービスのIDまたはARN
  # 設定可能な値: VPC Lattice サービスのIDまたはARN
  # 省略時: 省略不可
  # 関連機能: VPC Lattice Service - https://docs.aws.amazon.com/vpc-lattice/latest/ug/services.html
  service_identifier = "svc-0a1b2c3d4e5f6g7h8"

  # priority (Required)
  # 設定内容: ルールの優先度（数値が小さいほど優先度が高い）
  # 設定可能な値: 1〜100の整数（リスナー内でユニークである必要がある）
  # 省略時: 省略不可
  # 関連機能: Listener Rules - https://docs.aws.amazon.com/vpc-lattice/latest/ug/listener-rules.html
  priority = 10

  #-------------------------------------------------------------
  # マッチング条件
  #-------------------------------------------------------------

  # match (Required)
  # 設定内容: ルールのマッチング条件を定義
  # 設定可能な値: http_matchブロック
  # 省略時: 省略不可
  match {
    http_match {
      # method (Optional)
      # 設定内容: HTTPメソッドのマッチング
      # 設定可能な値: GET、POST、PUT、DELETE、PATCH、HEAD、OPTIONS、CONNECT、TRACE
      # 省略時: すべてのHTTPメソッドにマッチ
      method = "GET"

      # path_match (Optional)
      # 設定内容: URLパスのマッチング条件
      # 設定可能な値: path_matchブロック
      # 省略時: すべてのパスにマッチ
      path_match {
        # case_sensitive (Optional)
        # 設定内容: パスマッチングの大文字小文字を区別するか
        # 設定可能な値: true（区別する）、false（区別しない）
        # 省略時: false
        case_sensitive = false

        match {
          # exact (Optional)
          # 設定内容: 完全一致パス
          # 設定可能な値: 完全一致させるパス文字列
          # 省略時: exactまたはprefixのいずれかを指定
          # 関連機能: Path-based Routing - https://docs.aws.amazon.com/vpc-lattice/latest/ug/listener-rules.html
          exact = "/api/v1/users"

          # prefix (Optional)
          # 設定内容: プレフィックス一致パス
          # 設定可能な値: プレフィックスとして一致させるパス文字列
          # 省略時: exactまたはprefixのいずれかを指定
          # prefix = "/api/"
        }
      }

      # header_matches (Optional)
      # 設定内容: HTTPヘッダーのマッチング条件（複数指定可能）
      # 設定可能な値: header_matchesブロックのリスト
      # 省略時: ヘッダーのマッチングは行わない
      header_matches {
        # name (Required)
        # 設定内容: マッチング対象のHTTPヘッダー名
        # 設定可能な値: 任意のHTTPヘッダー名
        # 省略時: 省略不可
        name = "X-Custom-Header"

        # case_sensitive (Optional)
        # 設定内容: ヘッダー値のマッチングで大文字小文字を区別するか
        # 設定可能な値: true（区別する）、false（区別しない）
        # 省略時: false
        case_sensitive = false

        match {
          # contains (Optional)
          # 設定内容: ヘッダー値に特定の文字列が含まれることをチェック
          # 設定可能な値: 任意の文字列
          # 省略時: contains、exact、prefixのいずれかを指定
          contains = "mobile"

          # exact (Optional)
          # 設定内容: ヘッダー値の完全一致
          # 設定可能な値: 完全一致させる文字列
          # 省略時: contains、exact、prefixのいずれかを指定
          # exact = "application/json"

          # prefix (Optional)
          # 設定内容: ヘッダー値のプレフィックス一致
          # 設定可能な値: プレフィックスとして一致させる文字列
          # 省略時: contains、exact、prefixのいずれかを指定
          # prefix = "application/"
        }
      }
    }
  }

  #-------------------------------------------------------------
  # アクション設定
  #-------------------------------------------------------------

  # action (Required)
  # 設定内容: ルールにマッチした際のアクション
  # 設定可能な値: forwardまたはfixed_responseブロック
  # 省略時: 省略不可
  action {
    # forward (Optional)
    # 設定内容: ターゲットグループへのリクエスト転送
    # 設定可能な値: forwardブロック
    # 省略時: forwardまたはfixed_responseのいずれかを指定
    # 関連機能: Target Groups - https://docs.aws.amazon.com/vpc-lattice/latest/ug/target-groups.html
    forward {
      # target_groups (Optional)
      # 設定内容: 転送先のターゲットグループ（最大2つ）
      # 設定可能な値: target_groupsブロックのリスト
      # 省略時: 空のリスト（デフォルトターゲットグループが使用される）
      target_groups {
        # target_group_identifier (Required)
        # 設定内容: ターゲットグループのIDまたはARN
        # 設定可能な値: VPC Lattice ターゲットグループのIDまたはARN
        # 省略時: 省略不可
        target_group_identifier = "tg-0a1b2c3d4e5f6g7h8"

        # weight (Optional)
        # 設定内容: ターゲットグループへのトラフィック配分の重み
        # 設定可能な値: 0〜999の整数
        # 省略時: 1（複数ターゲットグループがある場合は均等配分）
        weight = 100
      }
    }

    # fixed_response (Optional)
    # 設定内容: 固定HTTPレスポンスを返す（リクエストをドロップ）
    # 設定可能な値: fixed_responseブロック
    # 省略時: forwardまたはfixed_responseのいずれかを指定
    # 関連機能: Fixed Response Actions - https://docs.aws.amazon.com/vpc-lattice/latest/ug/listener-rules.html
    # fixed_response {
    #   # status_code (Required)
    #   # 設定内容: 返却するHTTPステータスコード
    #   # 設定可能な値: 200〜599の整数
    #   # 省略時: 省略不可
    #   status_code = 404
    # }
  }

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに付与するタグ
  # 設定可能な値: キーと値のマップ
  # 省略時: タグなし
  # 関連機能: Tagging AWS Resources - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "api-routing-rule"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # region (Optional)
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョン
  # 関連機能: AWS Regions - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
# 以下の属性は、リソース作成後に参照可能です:
#
# arn
#   リスナールールのARN
#   例: arn:aws:vpc-lattice:us-east-1:123456789012:service/svc-0a1b2c3d4e5f6g7h8/listener/listener-0a1b2c3d4e5f6g7h8/rule/rule-0a1b2c3d4e5f6g7h8
#
# rule_id
#   リスナールールの一意なID
#   例: rule-0a1b2c3d4e5f6g7h8
#
# tags_all
#   プロバイダーのdefault_tagsとリソースのtagsをマージしたすべてのタグ
#---------------------------------------------------------------
