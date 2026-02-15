#######################################################
# DataZone アセットタイプ
#######################################################

# Provider Version: 6.28.0
# Generated: 2025-01-XX
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datazone_asset_type
# NOTE: このテンプレートは実際の使用前に環境に合わせた調整が必要です

# 概要:
# - Amazon DataZoneで使用するカスタムアセットタイプを定義
# - データカタログ内のメタデータ構造を定義してビジネス用語と技術的属性を紐付け
# - フォーム定義を通じてアセットに関連する構造化メタデータを管理

# ユースケース:
# - データガバナンス強化のためカスタムアセット分類を定義
# - ビジネスコンテキストと技術メタデータの統合管理
# - データカタログの拡張と組織固有の分類体系の実装

# 関連サービス:
# - DataZone Domain（ドメイン内でアセットタイプを管理）
# - DataZone Project（プロジェクトが所有するアセットタイプ）
# - DataZone Form Type（フォームテンプレートによるメタデータ構造定義）

#-------
# 基本設定
#-------

resource "aws_datazone_asset_type" "example" {
  # 設定内容: アセットタイプが属するDataZoneドメインの識別子
  # 注意点: ドメインIDは作成後変更不可（新規リソース作成が必要）
  domain_identifier = "dzd-1234567890abcdef"

  # 設定内容: アセットタイプの一意な名前
  # 制約: ドメイン内で一意である必要あり
  # 命名規則: ビジネス用語と技術用語を組み合わせた分かりやすい名前を推奨
  name = "CustomerDataAsset"

  # 設定内容: このアセットタイプを所有するプロジェクトの識別子
  # 注意点: プロジェクトIDは作成後変更不可
  # 権限: 所有プロジェクトがアセットタイプのライフサイクルを管理
  owning_project_identifier = "project-abc123"

  #-------
  # メタデータ設定
  #-------

  # 設定内容: アセットタイプの説明文（最大2048文字）
  # 推奨: ビジネス目的・利用シナリオ・対象データの説明を含める
  # 省略時: 説明なし
  description = "顧客マスタデータを管理するためのカスタムアセットタイプ。PII情報を含むため適切なガバナンスポリシーが必要"

  #-------
  # フォーム入力設定
  #-------

  # 設定内容: アセットに関連付けるメタデータフォームの定義
  # 用途: ビジネス用語・データ品質指標・コンプライアンス情報等の構造化メタデータを管理
  # 複数指定: 異なる目的のフォームを複数設定可能
  # 省略時: フォーム入力なし
  forms_input {
    # 設定内容: フォームのキー名（マッピング識別子）
    # 命名規則: フォームの用途を表す分かりやすい名前を推奨
    map_block_key = "business_glossary"

    # 設定内容: 使用するフォームタイプの識別子
    # 関連リソース: aws_datazone_form_typeで定義したフォームテンプレート
    type_identifier = "formtype-business-1234"

    # 設定内容: フォームタイプのリビジョン番号
    # バージョン管理: フォームスキーマ変更時にリビジョンが更新される
    type_revision = "1"

    # 設定内容: このフォームが必須かどうか
    # true: アセット作成時にフォーム入力が必須
    # false: フォーム入力は任意
    # 省略時: false
    required = true
  }

  forms_input {
    map_block_key       = "data_quality"
    type_identifier     = "formtype-quality-5678"
    type_revision       = "2"
    required            = false
  }

  #-------
  # リージョン設定
  #-------

  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のデフォルトリージョンを使用
  # 注意点: DataZoneドメインと同じリージョンである必要あり
  region = "us-east-1"

  #-------
  # タイムアウト設定
  #-------

  timeouts {
    # 設定内容: アセットタイプ作成のタイムアウト時間
    # 省略時: デフォルトタイムアウト適用
    # 推奨値: フォーム定義が複雑な場合は長めに設定
    create = "30m"
  }
}

#######################################################
# Attributes Reference (参照可能な属性)
#######################################################

# 出力例:
# - created_at: "2024-01-15T10:30:00Z"（アセットタイプの作成日時（ISO 8601形式））
# - created_by: "arn:aws:iam::123456789012:user/admin"（作成者のIAM ARN）
# - revision: "1"（現在のリビジョン番号、スキーマ変更時に自動インクリメント）

# タグ付け:
# - このリソースはタグ付けに対応していません

# インポート:
# terraform import aws_datazone_asset_type.example domain-id:asset-type-id:region
# 例: terraform import aws_datazone_asset_type.example dzd-1234567890abcdef:at-abc123:us-east-1
