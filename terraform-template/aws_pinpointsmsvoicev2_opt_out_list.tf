#---------------------------------------------------------------
# AWS End User Messaging SMS - Opt-Out List
#---------------------------------------------------------------
#
# AWS End User Messaging SMS (旧 Pinpoint SMS Voice V2) のオプトアウトリストを管理するリソースです。
# オプトアウトリストは、SMSメッセージの受信を希望しない電話番号のリストです。
#
# 主な機能:
#   - オプトアウトリストの作成と管理
#   - 電話番号やプールへのオプトアウトリストの関連付け
#   - デフォルトでは「Default opt-out list」が各プールと電話番号に割り当てられます
#   - オプトアウトリストに登録された電話番号はメッセージを受信しません
#
# AWS公式ドキュメント:
#   - オプトアウトリストの作成: https://docs.aws.amazon.com/sms-voice/latest/userguide/opt-out-list-create.html
#   - オプトアウトリストの詳細表示: https://docs.aws.amazon.com/sms-voice/latest/userguide/opt-out-list-view.html
#   - 電話番号の追加: https://docs.aws.amazon.com/sms-voice/latest/userguide/opt-out-list-add-phone-number.html
#   - プールへの関連付け: https://docs.aws.amazon.com/sms-voice/latest/userguide/phone-pool-manage-opt-out-list.html
#   - AWS End User Messaging SMS 概要: https://docs.aws.amazon.com/sms-voice/latest/userguide/what-is-service.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpointsmsvoicev2_opt_out_list
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_pinpointsmsvoicev2_opt_out_list" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: オプトアウトリストの名前を指定します。
  # 設定可能な値: 英数字とハイフンを含む文字列
  # 用途: オプトアウトリストの識別子として使用されます
  # 注意事項:
  #   - 作成後は変更できません (強制的な再作成が発生)
  #   - この名前はアカウント内で一意である必要があります
  # 関連機能: オプトアウトリスト管理
  #   リストは電話番号やプールに関連付けて使用します。
  #   デフォルトの「Default opt-out list」以外のカスタムリストを作成できます。
  #   AWS CLI コマンド例:
  #     aws pinpoint-sms-voice-v2 create-opt-out-list --opt-out-list-name example-opt-out-list
  #   - https://docs.aws.amazon.com/sms-voice/latest/userguide/opt-out-list-create.html
  name = "example-opt-out-list"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 用途: リージョン間でリソースを管理する場合に使用
  # 関連機能: リージョン間リソース管理
  #   AWS End User Messaging SMS はリージョナルサービスです。
  #   各リージョンで個別にオプトアウトリストを管理する必要があります。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの分類、コスト管理、検索などに使用
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   タグはコスト配分、リソース管理、アクセス制御などに活用できます。
  #   - https://docs.aws.amazon.com/tag-editor/latest/userguide/tagging.html
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-opt-out-list"
    Environment = "production"
    Purpose     = "SMS opt-out management"
    ManagedBy   = "Terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はオプトアウトリスト名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: オプトアウトリストのAmazon Resource Name (ARN)
#   形式: arn:aws:sms-voice:region:account-id:opt-out-list/opt-out-list-name
#   用途: 他のリソースやポリシーでこのオプトアウトリストを参照する際に使用
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
# 関連リソース
#---------------------------------------------------------------
# このリソースと一緒に使用される主なリソース:
#
# 1. aws_pinpointsmsvoicev2_phone_number:
#    電話番号にオプトアウトリストを関連付ける
#    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpointsmsvoicev2_phone_number
#
# 2. aws_pinpointsmsvoicev2_pool:
#    プール (送信元IDのグループ) にオプトアウトリストを関連付ける
#    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpointsmsvoicev2_pool
#
#---------------------------------------------------------------
