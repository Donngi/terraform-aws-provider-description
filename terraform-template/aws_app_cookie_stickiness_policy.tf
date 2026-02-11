#---------------------------------------------------------------
# AWS ELB Application Cookie Stickiness Policy
#---------------------------------------------------------------
#
# Classic Load Balancer（ELB）のアプリケーションCookieスティッキネスポリシーを
# プロビジョニングするリソースです。
#
# このポリシーは、アプリケーションが生成するCookieの有効期限に基づいて、
# ELBのスティッキーセッションを制御します。ELBが生成するスティッキーCookie
# （AWSELB）は、アプリケーションが生成するCookieのライフタイムに従います。
#
# アプリケーションCookieが削除または期限切れになると、新しいアプリケーション
# Cookieが発行されるまでセッションはスティッキーではなくなります。
#
# AWS公式ドキュメント:
#   - Classic Load Balancer スティッキーセッション: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-sticky-sessions.html
#   - CreateAppCookieStickinessPolicy API: https://docs.aws.amazon.com/elasticloadbalancing/2012-06-01/APIReference/API_CreateAppCookieStickinessPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/app_cookie_stickiness_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_app_cookie_stickiness_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: スティッキネスポリシーの名前を指定します。
  # 設定可能な値: ロードバランサー内で一意の文字列
  # 注意: 同じロードバランサー内でポリシー名が重複するとエラーになります。
  name = "my-app-cookie-policy"

  # load_balancer (Required)
  # 設定内容: ポリシーをアタッチするロードバランサーの名前を指定します。
  # 設定可能な値: 既存のClassic Load Balancerの名前
  load_balancer = "my-classic-elb"

  # lb_port (Required)
  # 設定内容: ポリシーを適用するロードバランサーのポート番号を指定します。
  # 設定可能な値: ロードバランサー上のアクティブなリスナーのポート番号
  # 注意: 指定するポートはロードバランサー上でアクティブなリスナーである必要があります。
  #       HTTP/HTTPSリスナーにのみ適用可能です。
  lb_port = 80

  # cookie_name (Required)
  # 設定内容: ELBのCookieがライフタイムを追従するアプリケーションCookieの名前を指定します。
  # 設定可能な値: アプリケーションが生成するCookieの名前
  # 関連機能: Application-controlled session stickiness
  #   アプリケーションが生成するCookieに基づいてセッションの維持を制御します。
  #   ELBはアプリケーションレスポンスに新しいアプリケーションCookieが含まれている
  #   場合にのみ、新しいスティッキネスCookieを挿入します。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-sticky-sessions.html
  cookie_name = "MyAppCookie"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ポリシーのID
# - name: スティッキネスポリシーの名前
# - load_balancer: ポリシーがアタッチされているロードバランサーの名前
# - lb_port: ポリシーが適用されているロードバランサーのポート
# - cookie_name: ELBのCookieがライフタイムを追従するアプリケーションCookieの名前
#---------------------------------------------------------------
