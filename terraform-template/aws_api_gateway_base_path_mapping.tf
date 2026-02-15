#---------------------------------------
# AWS API Gateway Base Path Mapping
#---------------------------------------
# カスタムドメイン名とAPI Gatewayのデプロイステージを接続し、
# カスタムドメイン経由でAPIメソッドを呼び出せるようにするリソース
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
#
# 主な用途:
# - カスタムドメイン名でのAPI公開
# - 複数APIの単一ドメイン配下での管理
# - ベースパスによるAPIのルーティング制御
#
# 前提条件:
# - aws_api_gateway_domain_nameによるカスタムドメイン名の登録
# - aws_api_gateway_deploymentによるAPIのデプロイ
# - aws_api_gateway_stageによるステージの作成
#
# 関連リソース:
# - aws_api_gateway_domain_name: カスタムドメイン名の登録
# - aws_api_gateway_stage: デプロイステージの定義
# - aws_api_gateway_rest_api: REST APIの定義
#
# NOTE: このテンプレートはプロバイダースキーマから自動生成されています
#
# Terraformドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping

#---------------------------------------
# カスタムドメイン名とAPIの接続設定
#---------------------------------------

resource "aws_api_gateway_base_path_mapping" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # 設定内容: カスタムドメイン名
  # 設定可能な値: aws_api_gateway_domain_nameで登録済みのドメイン名
  # 注意事項: 既に登録されているドメイン名である必要があります
  domain_name = aws_api_gateway_domain_name.example.domain_name

  # 設定内容: 接続するAPIのID
  # 設定可能な値: REST APIまたはHTTP APIのID
  # 注意事項: デプロイ済みのAPIである必要があります
  api_id = aws_api_gateway_rest_api.example.id

  #---------------------------------------
  # ステージとパス設定
  #---------------------------------------

  # 設定内容: 公開するデプロイステージ名
  # 設定可能な値: 有効なステージ名（dev、prod等）
  # 省略時: 呼び出し元がパス要素でステージ名を指定可能
  # 注意事項: 省略するとベースパス後にステージ名の指定が必要
  stage_name = aws_api_gateway_stage.example.stage_name

  # 設定内容: APIアクセス時に前置するパスセグメント
  # 設定可能な値: 任意のパス文字列（例: api、v1、myapp等）
  # 省略時: ドメインのルートパスでAPIを公開
  # 注意事項: (none)またはempty stringを指定するとルートパスになります
  base_path = "api"

  #---------------------------------------
  # プライベートカスタムドメイン設定
  #---------------------------------------

  # 設定内容: プライベートカスタムドメイン名のリソースID
  # 設定可能な値: aws_api_gateway_domain_nameのid
  # 省略時: パブリックカスタムドメイン名として扱われます
  # 注意事項: プライベートカスタムドメイン名の場合のみ使用
  domain_name_id = null

  #---------------------------------------
  # リージョン設定
  #---------------------------------------

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョン名（us-east-1、ap-northeast-1等）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意事項: エッジ最適化カスタムドメイン名の場合はus-east-1推奨
  region = null
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# このリソースでは以下の属性が参照可能:
#
# - id - ベースパスマッピングのID（domain_name/base_path形式）
# - region - リソースが管理されているAWSリージョン
