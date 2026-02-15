#---------------------------------------------------------------
# AWS Connect Contact Flow
#---------------------------------------------------------------
#
# Amazon Connectインスタンス内でコンタクトフロー（通話フロー）を
# 作成・管理するリソースです。
# コンタクトフローは、顧客との対話を設計し、
# 通話のルーティング、キュー配置、プロンプト再生などを定義します。
#
# AWS公式ドキュメント:
#   - Amazon Connectコンタクトフロー: https://docs.aws.amazon.com/connect/latest/adminguide/concepts-contact-flows.html
#   - コンタクトフローの作成: https://docs.aws.amazon.com/connect/latest/adminguide/create-contact-flow.html
#   - CreateContactFlow API: https://docs.aws.amazon.com/connect/latest/APIReference/API_CreateContactFlow.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_contact_flow
#
# Provider Version: 6.28.0
# Generated: 2026-02-13
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_connect_contact_flow" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # instance_id (Required, Forces new resource)
  # 設定内容: コンタクトフローを作成するAmazon ConnectインスタンスのIDを指定します。
  # 設定可能な値: 有効なAmazon ConnectインスタンスのID
  # 関連機能: Amazon Connect インスタンス
  #   コンタクトフローは特定のConnectインスタンスに紐付けられ、
  #   そのインスタンス内でのみ使用可能です。
  #   - https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-instances.html
  # 注意: この値の変更はリソースの再作成を引き起こします。
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

  # name (Required)
  # 設定内容: コンタクトフローの名前を指定します。
  # 設定可能な値: 任意の文字列（1～127文字）
  # 制約: 同一インスタンス内でコンタクトフロー名は一意である必要があります
  name = "example-contact-flow"

  #-------------------------------------------------------------
  # コンタクトフロー定義
  #-------------------------------------------------------------

  # content (Optional, Computed)
  # 設定内容: コンタクトフローのJSON定義を指定します。
  # 設定可能な値: Amazon Connectコンタクトフロー言語で記述されたJSON文字列
  # 省略時: AWS側で自動生成されたデフォルトフローが使用されます
  # 関連機能: コンタクトフロー言語
  #   コンタクトフローはJSON形式で定義され、ブロックとアクションで構成されます。
  #   Amazon Connect管理コンソールのフローデザイナーでエクスポートしたJSONを使用できます。
  #   - https://docs.aws.amazon.com/connect/latest/adminguide/contact-flow-language.html
  # 注意:
  #   - filenameとcontentは同時に指定できません（排他的）
  #   - JSONの構文が正しいことを確認してください
  content = <<-JSON
  {
    "Version": "2019-10-30",
    "StartAction": "12345678-1234-1234-1234-123456789012",
    "Actions": []
  }
  JSON

  # filename (Optional)
  # 設定内容: コンタクトフロー定義を含むJSONファイルのパスを指定します。
  # 設定可能な値: 有効なファイルパス
  # 関連機能: 外部ファイル参照
  #   大規模なコンタクトフロー定義を外部ファイルで管理する際に使用します。
  # 注意:
  #   - contentとfilenameは同時に指定できません（排他的）
  #   - ファイルが存在し、有効なJSONである必要があります
  filename = null

  # content_hash (Optional)
  # 設定内容: コンタクトフローのコンテンツハッシュを指定します。
  # 設定可能な値: ハッシュ値を表す文字列
  # 用途: コンテンツの変更を検出するために使用されます
  # 注意:
  #   - filenameを使用する場合、content_hashを設定することで
  #     ファイル内容の変更を自動的に検出できます
  content_hash = null

  #-------------------------------------------------------------
  # コンタクトフロー設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: コンタクトフローの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: コンタクトフローの目的や機能を記述します
  description = "メインカスタマーサポート用コンタクトフロー"

  # type (Optional, Forces new resource)
  # 設定内容: コンタクトフローのタイプを指定します。
  # 設定可能な値:
  #   - "CONTACT_FLOW": 標準的なコンタクトフロー（インバウンドまたはアウトバウンド通話用）
  #   - "CUSTOMER_QUEUE": キュー内での顧客体験を定義するフロー
  #   - "CUSTOMER_HOLD": 保留中の顧客体験を定義するフロー
  #   - "CUSTOMER_WHISPER": エージェント接続前に顧客に再生されるメッセージ
  #   - "AGENT_HOLD": 保留中のエージェント体験を定義するフロー
  #   - "AGENT_WHISPER": 顧客接続前にエージェントに再生されるメッセージ
  #   - "OUTBOUND_WHISPER": アウトバウンド通話前に再生されるメッセージ
  #   - "AGENT_TRANSFER": エージェント転送時のフロー
  #   - "QUEUE_TRANSFER": キュー転送時のフロー
  # 省略時: "CONTACT_FLOW"
  # 関連機能: コンタクトフロータイプ
  #   各タイプは異なる目的と機能セットを持ちます。
  #   - https://docs.aws.amazon.com/connect/latest/adminguide/contact-flow-types.html
  # 注意: この値の変更はリソースの再作成を引き起こします。
  type = "CONTACT_FLOW"

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-contact-flow"
    Environment = "production"
    Purpose     = "customer-support"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コンタクトフローのAmazon Resource Name (ARN)
#
# - contact_flow_id: コンタクトフローの識別子
#
# - id: コンタクトフローの識別子（contact_flow_idと同じ）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
