#---------------------------------------------------------------
# AWS Device Farm Upload
#---------------------------------------------------------------
#
# AWS Device Farmのアップロードを管理するリソースです。
# Device Farmでテストを実行するために必要なアプリケーションや
# テストスクリプトをアップロードする際に使用します。
#
# AWS公式ドキュメント:
#   - Device Farm概要: https://docs.aws.amazon.com/devicefarm/latest/developerguide/welcome.html
#   - CreateUpload API: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateUpload.html
#   - Device Farmエンドポイントとクォータ: https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_upload
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要: AWS Device Farmは限られたリージョンでのみ利用可能です（例: us-west-2）。
#       サポートされるリージョンについては上記エンドポイントドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_devicefarm_upload" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: アップロードのファイル名を指定します。
  # 設定可能な値: 最大256文字の文字列
  # 注意:
  #   - ファイル名にスラッシュ（/）を含めることはできません
  #   - iOSアプリの場合: .ipa拡張子で終わる必要があります
  #   - Androidアプリの場合: .apk拡張子で終わる必要があります
  #   - その他の場合: .zip拡張子で終わる必要があります
  name = "example-test-spec.zip"

  # project_arn (Required)
  # 設定内容: アップロード先となるDevice Farmプロジェクトの ARN を指定します。
  # 設定可能な値: 有効なDevice FarmプロジェクトのARN
  # 形式: arn:aws:devicefarm:{region}:{account-id}:project:{project-id}
  # 参照: aws_devicefarm_projectリソースの.arn属性を使用することを推奨
  project_arn = aws_devicefarm_project.example.arn

  # type (Required)
  # 設定内容: アップロードのタイプを指定します。
  # 設定可能な値:
  #   【アプリケーション】
  #   - "ANDROID_APP": Androidアプリケーション（.apk）
  #   - "IOS_APP": iOSアプリケーション（.ipa）
  #   - "WEB_APP": Webアプリケーション（注: CreateUpload APIでは使用不可）
  #   - "EXTERNAL_DATA": 外部データファイル
  #
  #   【テストパッケージ】
  #   - "APPIUM_JAVA_JUNIT_TEST_PACKAGE": Appium Java JUnitテストパッケージ
  #   - "APPIUM_JAVA_TESTNG_TEST_PACKAGE": Appium Java TestNGテストパッケージ
  #   - "APPIUM_PYTHON_TEST_PACKAGE": Appium Pythonテストパッケージ
  #   - "APPIUM_NODE_TEST_PACKAGE": Appium Node.jsテストパッケージ
  #   - "APPIUM_RUBY_TEST_PACKAGE": Appium Rubyテストパッケージ
  #   - "APPIUM_WEB_JAVA_JUNIT_TEST_PACKAGE": Appium Web Java JUnitテストパッケージ
  #   - "APPIUM_WEB_JAVA_TESTNG_TEST_PACKAGE": Appium Web Java TestNGテストパッケージ
  #   - "APPIUM_WEB_PYTHON_TEST_PACKAGE": Appium Web Pythonテストパッケージ
  #   - "APPIUM_WEB_NODE_TEST_PACKAGE": Appium Web Node.jsテストパッケージ
  #   - "APPIUM_WEB_RUBY_TEST_PACKAGE": Appium Web Rubyテストパッケージ
  #   - "CALABASH_TEST_PACKAGE": Calabashテストパッケージ（廃止予定）
  #   - "INSTRUMENTATION_TEST_PACKAGE": Android Instrumentationテストパッケージ
  #   - "UIAUTOMATION_TEST_PACKAGE": UI Automationテストパッケージ（廃止予定）
  #   - "UIAUTOMATOR_TEST_PACKAGE": UIAutomatorテストパッケージ（廃止予定）
  #   - "XCTEST_TEST_PACKAGE": XCTestテストパッケージ
  #   - "XCTEST_UI_TEST_PACKAGE": XCTest UIテストパッケージ
  #
  #   【テストスペック（カスタムテスト設定）】
  #   - "APPIUM_JAVA_JUNIT_TEST_SPEC": Appium Java JUnitテストスペック
  #   - "APPIUM_JAVA_TESTNG_TEST_SPEC": Appium Java TestNGテストスペック
  #   - "APPIUM_PYTHON_TEST_SPEC": Appium Pythonテストスペック
  #   - "APPIUM_NODE_TEST_SPEC": Appium Node.jsテストスペック
  #   - "APPIUM_RUBY_TEST_SPEC": Appium Rubyテストスペック
  #   - "APPIUM_WEB_JAVA_JUNIT_TEST_SPEC": Appium Web Java JUnitテストスペック
  #   - "APPIUM_WEB_JAVA_TESTNG_TEST_SPEC": Appium Web Java TestNGテストスペック
  #   - "APPIUM_WEB_PYTHON_TEST_SPEC": Appium Web Pythonテストスペック
  #   - "APPIUM_WEB_NODE_TEST_SPEC": Appium Web Node.jsテストスペック
  #   - "APPIUM_WEB_RUBY_TEST_SPEC": Appium Web Rubyテストスペック
  #   - "INSTRUMENTATION_TEST_SPEC": Android Instrumentationテストスペック
  #   - "XCTEST_UI_TEST_SPEC": XCTest UIテストスペック
  #
  # 参考: https://docs.aws.amazon.com/devicefarm/latest/APIReference/API_CreateUpload.html
  type = "APPIUM_JAVA_TESTNG_TEST_SPEC"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # content_type (Optional)
  # 設定内容: アップロードするファイルのコンテンツタイプを指定します。
  # 設定可能な値: 最大64文字のMIMEタイプ文字列
  # 例: "application/octet-stream", "application/zip"
  # 省略時: AWSが自動的にコンテンツタイプを判定します
  content_type = "application/octet-stream"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Device Farmはus-west-2など限られたリージョンでのみ利用可能です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アップロードのAmazon Resource Name (ARN)
#
# - id: アップロードのARN
#
# - url: アップロードに使用される署名付きAmazon S3 URL
#        このURLを使用してPUTリクエストでファイルをアップロードします
#
# - category: アップロードのカテゴリ
#             例: "CURATED", "PRIVATE"など
#
# - metadata: アップロードのメタデータ
#             例: Androidアプリの場合、マニフェストから解析された情報が含まれます
#---------------------------------------------------------------
