#---------------------------------------
# CloudFront Function
#---------------------------------------
# CloudFrontディストリビューションのエッジロケーションで実行される軽量なJavaScript関数
# ビューアリクエスト/レスポンスを操作してCDNカスタマイズを実現
# サブミリ秒の起動時間で毎秒数百万リクエストをスケール処理可能
#
# Provider Version: 6.28.0
# Generated: 2026-02-12
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/cloudfront_function
#
# NOTE: KeyValueStoreを使用する場合はruntime = "cloudfront-js-2.0" が必須

resource "aws_cloudfront_function" "example" {
  #-------
  # 基本設定
  #-------

  # 設定内容: 関数の一意名（CloudFront全体で一意である必要がある）
  # 設定可能な値: 1～64文字の英数字・ハイフン・アンダースコア
  # 制約: 作成後の変更は関数の再作成をトリガーする
  name = "example-cloudfront-function"

  # 設定内容: JavaScriptランタイムバージョン
  # 設定可能な値:
  #   - cloudfront-js-1.0: ECMAScript 5.1 + ES 6-9の一部機能をサポート
  #   - cloudfront-js-2.0: ECMAScript 5.1 + ES 6-12の一部機能をサポート（推奨）
  # 注記: KeyValueStoreを使用する場合は cloudfront-js-2.0 が必須
  runtime = "cloudfront-js-2.0"

  # 設定内容: 関数のJavaScriptコード
  # 設定可能な値: 最大10KBのJavaScriptコード（圧縮前）
  # 注記: viewer-request/viewer-response/origin-request/origin-responseイベントハンドラーを含む
  code = <<-EOT
function handler(event) {
    var request = event.request;
    var headers = request.headers;

    // セキュリティヘッダーの追加
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload' };
    headers['x-content-type-options'] = { value: 'nosniff' };
    headers['x-frame-options'] = { value: 'DENY' };
    headers['x-xss-protection'] = { value: '1; mode=block' };

    return request;
}
EOT

  #-------
  # 説明とメタデータ
  #-------

  # 設定内容: 関数の説明（オプション）
  # 設定可能な値: 最大256文字の任意のテキスト
  # 省略時: 空文字列
  comment = "セキュリティヘッダーを追加するビューアレスポンス関数"

  #-------
  # 公開設定
  #-------

  # 設定内容: 関数をLIVEステージに自動公開するか
  # 設定可能な値:
  #   - true: 変更時に自動的にLIVEステージに公開（本番環境で即座に有効化）
  #   - false: DEVELOPMENTステージに保持（手動公開が必要）
  # 省略時: false（手動公開モード）
  # 注記: 本番環境では慎重にテスト後に公開することを推奨
  publish = true

  #-------
  # Key Value Store連携
  #-------

  # 設定内容: 関数に関連付けるKey Value StoreのARNセット
  # 設定可能な値: Key Value StoreのARN文字列のセット（最大1個まで）
  # 省略時: Key Value Storeを使用しない
  # 注記: KeyValueStoreを使用する場合はruntime = "cloudfront-js-2.0" が必須
  # 用途: URL書き換え/リダイレクト、A/Bテスト、フィーチャーフラグ、アクセス認可など
  key_value_store_associations = [
    # aws_cloudfront_key_value_store.example.arn
  ]
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# arn                 - 関数のARN（例: arn:aws:cloudfront::123456789012:function/example-function）
# etag                - 現在のバージョンのETag（更新操作の競合検出に使用）
# id                  - 関数の識別子（通常は関数名と同じ）
# live_stage_etag     - LIVEステージのETag（公開されたバージョンの識別に使用）
# status              - 関数のステータス（UNPUBLISHED/UNASSOCIATED/ASSOCIATED）
