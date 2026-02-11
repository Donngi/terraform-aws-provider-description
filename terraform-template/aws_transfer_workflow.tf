#---------------------------------------------------------------
# AWS Transfer Family Workflow
#---------------------------------------------------------------
#
# AWS Transfer Familyのワークフローリソースをプロビジョニングします。
# ワークフローは、ファイル転送完了後に自動的に実行される一連の処理ステップを
# 定義します。COPY、CUSTOM、DECRYPT、DELETE、TAGなどのステップタイプを組み合わせて、
# ファイルのコピー、カスタム処理（Lambda関数）、復号化、削除、タグ付けを自動化できます。
#
# AWS公式ドキュメント:
#   - AWS Transfer Family managed workflows: https://docs.aws.amazon.com/transfer/latest/userguide/transfer-workflows.html
#   - Create a workflow: https://docs.aws.amazon.com/transfer/latest/userguide/create-workflow.html
#   - CreateWorkflow API: https://docs.aws.amazon.com/transfer/latest/APIReference/API_CreateWorkflow.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_workflow
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_transfer_workflow" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: ワークフローの説明を指定します。
  # 設定可能な値: テキスト文字列
  # 省略時: 説明なしでワークフローが作成されます。
  # 用途: ワークフローの目的や処理内容を記述するために使用します。
  description = "File processing workflow for uploaded files"

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: ワークフローがアクセスするすべてのS3バケットは、ワークフローと同じリージョンに存在する必要があります。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最大50タグまで）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/transfer-workflows.html
  tags = {
    Name        = "example-workflow"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ワークフローステップ (必須)
  #-------------------------------------------------------------

  # steps (Required)
  # 設定内容: ワークフローで実行される処理ステップを指定します。
  # 設定可能な値: 最小1個、最大8個のステップブロック
  # 処理順序: ステップは定義された順序で線形に実行されます。
  # 関連機能: ワークフローステップ
  #   各ステップはtype（必須）と、そのタイプに応じた詳細設定ブロックを含みます。
  #   利用可能なステップタイプ: COPY, CUSTOM, DECRYPT, DELETE, TAG
  # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/create-workflow.html
  steps {
    # type (Required)
    # 設定内容: ステップのタイプを指定します。
    # 設定可能な値:
    #   - "COPY": ファイルを別の場所にコピー
    #   - "CUSTOM": Lambda関数を使用したカスタム処理
    #   - "DECRYPT": ファイルを復号化
    #   - "DELETE": ファイルを削除
    #   - "TAG": ファイルにタグを追加
    # 注意: 選択したタイプに応じて、対応する詳細設定ブロック（*_step_details）を1つだけ指定する必要があります。
    type = "DELETE"

    # delete_step_details (Optional)
    # 設定内容: DELETE ステップの詳細設定を指定します。
    # 使用条件: type = "DELETE" の場合に指定
    # 関連機能: ファイル削除ステップ
    #   ワークフローの入力ファイルまたは前のステップの出力ファイルを削除します。
    delete_step_details {
      # name (Optional)
      # 設定内容: ステップの識別名を指定します。
      # 設定可能な値: 文字列
      # 省略時: ステップに名前が付けられません。
      # 用途: ログやモニタリングでステップを識別するために使用
      name = "delete-uploaded-file"

      # source_file_location (Optional)
      # 設定内容: ワークフローステップへの入力ファイルを指定します。
      # 設定可能な値:
      #   - "${previous.file}": 前のステップの出力ファイルを入力として使用（デフォルト）
      #   - "${original.file}": 元のアップロードファイルを入力として使用
      # 省略時: "${previous.file}" がデフォルトとして使用されます。
      # 注意: 最初のステップの場合、"${previous.file}" は元のアップロードファイルを指します。
      source_file_location = "${original.file}"
    }

    # copy_step_details (Optional)
    # 設定内容: COPY ステップの詳細設定を指定します。
    # 使用条件: type = "COPY" の場合に指定
    # 関連機能: ファイルコピーステップ
    #   ファイルを別の場所にコピーします。S3のみサポート。
    # copy_step_details {
    #   name                 = "copy-to-archive"
    #   source_file_location = "${previous.file}"
    #   overwrite_existing   = "FALSE"
    #
    #   destination_file_location {
    #     s3_file_location {
    #       bucket = "example-archive-bucket"
    #       key    = "archived/${transfer:UserName}/${transfer:UploadDate}/"
    #     }
    #   }
    # }

    # custom_step_details (Optional)
    # 設定内容: CUSTOM ステップの詳細設定を指定します。
    # 使用条件: type = "CUSTOM" の場合に指定
    # 関連機能: カスタム処理ステップ
    #   Lambda関数を呼び出してカスタム処理を実行します。
    #   Lambda関数は非同期で実行され、ワークフローと同じリージョンに存在する必要があります。
    # 制限事項:
    #   - クロスアカウント・クロスリージョンのLambda関数はサポートされません
    #   - カスタムステップの最大タイムアウトは30分です
    # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/transfer-workflows.html
    # custom_step_details {
    #   name                 = "validate-file"
    #   source_file_location = "${original.file}"
    #   target               = "arn:aws:lambda:ap-northeast-1:123456789012:function:file-validator"
    #   timeout_seconds      = 60
    # }

    # decrypt_step_details (Optional)
    # 設定内容: DECRYPT ステップの詳細設定を指定します。
    # 使用条件: type = "DECRYPT" の場合に指定
    # 関連機能: ファイル復号化ステップ
    #   PGP暗号化されたファイルを復号化します。秘密鍵はAWS Secrets Managerに保存する必要があります。
    # 制限事項:
    #   - 復号化されたファイルの最大サイズは10GBです
    #   - 1ワークフローあたり、復号化ステップを含む同時実行は最大250まで
    # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/workflow-decrypt-tutorial.html
    # decrypt_step_details {
    #   name                 = "decrypt-file"
    #   type                 = "PGP"
    #   source_file_location = "${original.file}"
    #   overwrite_existing   = "FALSE"
    #
    #   destination_file_location {
    #     s3_file_location {
    #       bucket = "example-decrypted-bucket"
    #       key    = "decrypted/"
    #     }
    #   }
    # }

    # tag_step_details (Optional)
    # 設定内容: TAG ステップの詳細設定を指定します。
    # 使用条件: type = "TAG" の場合に指定
    # 関連機能: ファイルタグ付けステップ
    #   S3オブジェクトにタグを追加します。S3のみサポート。
    # tag_step_details {
    #   name                 = "tag-processed-file"
    #   source_file_location = "${previous.file}"
    #
    #   tags {
    #     key   = "ProcessedBy"
    #     value = "TransferWorkflow"
    #   }
    #
    #   tags {
    #     key   = "ProcessedDate"
    #     value = "${transfer:UploadDate}"
    #   }
    # }
  }

  #-------------------------------------------------------------
  # 例外処理ステップ (オプション)
  #-------------------------------------------------------------

  # on_exception_steps (Optional)
  # 設定内容: ワークフロー実行中にエラーが発生した場合に実行されるステップを指定します。
  # 設定可能な値: 最大8個のステップブロック
  # 関連機能: 例外ハンドリング
  #   通常のステップが失敗または検証エラーを返した場合に、これらのステップが実行されます。
  #   例外ハンドリングステップは、通常ステップと同じ形式で定義されます。
  # 用途: エラー時の通知送信、ファイルの隔離、ログ記録などに使用
  # 参考: https://docs.aws.amazon.com/transfer/latest/userguide/transfer-workflows.html
  # 注意: on_exception_stepsブロックは必要に応じて定義してください。以下はコメントアウトされた実装例です。
  # on_exception_steps {
  #   type = "CUSTOM"
  #
  #   custom_step_details {
  #     name                 = "error-notification"
  #     source_file_location = "${original.file}"
  #     target               = "arn:aws:lambda:ap-northeast-1:123456789012:function:error-notifier"
  #     timeout_seconds      = 30
  #   }
  # }
  #
  # 利用可能なステップタイプと詳細設定ブロックはstepsブロックと同じです:
  # - copy_step_details: ファイルをコピー
  # - custom_step_details: Lambda関数を呼び出し
  # - decrypt_step_details: ファイルを復号化
  # - delete_step_details: ファイルを削除
  # - tag_step_details: ファイルにタグを追加
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ワークフローのAmazon Resource Name (ARN)
#        他のAWSサービスでワークフローを参照する際に使用します。
#
# - id: ワークフローの一意の識別子
#       ワークフローの管理や参照に使用します。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# ステップタイプ詳細リファレンス
#---------------------------------------------------------------
#
# 1. COPY ステップ
#    ファイルを別の場所にコピーします。S3のみサポート。
#    - destination_file_location: コピー先の場所を指定（必須）
#      - s3_file_location または efs_file_location のいずれかを指定
#    - overwrite_existing: 既存ファイルを上書きするか ("TRUE"/"FALSE")
#
#---------------------------------------------------------------
