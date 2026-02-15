#---------------------------------------
# AWS Data Pipeline パイプライン定義
#---------------------------------------
# Provider Version: 6.28.0
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/datapipeline_pipeline_definition
# Generated: 2026-02-13
#
# NOTE: AWS Data Pipelineは新規顧客への提供を終了しています（既存顧客は継続利用可能）
#
# 用途: Data Pipelineのパイプライン定義を管理する
# 機能:
#   - パイプラインオブジェクトの定義
#   - パラメータオブジェクトとパラメータ値の設定
#   - パイプラインコンポーネント間の参照関係の構築
#   - オブジェクトフィールドによる詳細な設定
#
# 制約事項:
#   - 最低1つのpipeline_objectブロックが必須
#   - pipeline_idは既存のData Pipelineを参照する必要がある
#   - フィールドのstring_valueとref_valueは排他的（両方指定不可）
#
# 注意事項:
#   - パイプライン定義の変更はパイプラインの再アクティベーションが必要になる場合がある
#   - パラメータオブジェクトはパイプライン実行時に値を注入するために使用
#   - 各オブジェクトのidはパイプライン定義内で一意である必要がある
#
# 関連リソース:
#   - aws_datapipeline_pipeline: パイプライン本体の定義
#---------------------------------------

resource "aws_datapipeline_pipeline_definition" "example" {
  #---------------------------------------
  # 基本設定
  #---------------------------------------
  # 設定内容: 定義を適用するData PipelineのID
  # 設定可能な値: 既存のData Pipeline ID
  pipeline_id = "df-1234567890ABCDEFGHIJ"

  #---------------------------------------
  # パイプラインオブジェクト設定
  #---------------------------------------
  # パイプラインの構成要素を定義するオブジェクト
  # 最低1つのオブジェクトが必須
  pipeline_object {
    # 設定内容: パイプラインオブジェクトの一意識別子
    # 設定可能な値: 1-256文字の文字列
    id = "Default"

    # 設定内容: オブジェクトの名前
    # 設定可能な値: 任意の文字列
    name = "Default"

    # オブジェクトのプロパティを定義するフィールド
    field {
      # 設定内容: フィールドのキー名
      # 設定可能な値: 1-256文字の文字列
      key = "failureAndRerunMode"

      # 設定内容: フィールドの文字列値
      # 設定可能な値: 0-10240文字の文字列
      # 省略時: ref_valueとどちらか一方が必須
      string_value = "CASCADE"
    }

    field {
      key = "scheduleType"
      string_value = "cron"
    }

    field {
      key = "schedule"
      # 設定内容: 他のオブジェクトへの参照
      # 設定可能な値: パイプライン内の別のオブジェクトID
      # 省略時: string_valueとどちらか一方が必須
      ref_value = "DefaultSchedule"
    }
  }

  pipeline_object {
    id   = "DefaultSchedule"
    name = "RunOnce"

    field {
      key          = "type"
      string_value = "Schedule"
    }

    field {
      key          = "period"
      string_value = "1 Day"
    }

    field {
      key          = "startDateTime"
      string_value = "2024-01-01T00:00:00"
    }

    field {
      key          = "occurrences"
      string_value = "1"
    }
  }

  pipeline_object {
    id   = "MyActivity"
    name = "MyActivity"

    field {
      key          = "type"
      string_value = "EmrActivity"
    }

    field {
      key       = "emrCluster"
      ref_value = "MyEmrCluster"
    }

    field {
      key          = "step"
      string_value = "s3://mybucket/mypath/myscript.jar,arg1,arg2"
    }
  }

  pipeline_object {
    id   = "MyEmrCluster"
    name = "MyEmrCluster"

    field {
      key          = "type"
      string_value = "EmrCluster"
    }

    field {
      key          = "keyPair"
      string_value = "my-key-pair"
    }

    field {
      key          = "masterInstanceType"
      string_value = "m5.xlarge"
    }

    field {
      key          = "coreInstanceType"
      string_value = "m5.large"
    }

    field {
      key          = "coreInstanceCount"
      string_value = "2"
    }

    field {
      key          = "releaseLabel"
      string_value = "emr-5.36.0"
    }
  }

  #---------------------------------------
  # パラメータオブジェクト設定（オプション）
  #---------------------------------------
  # パイプライン実行時に値を注入するためのパラメータ定義
  parameter_object {
    # 設定内容: パラメータオブジェクトの一意識別子
    # 設定可能な値: 1-256文字の文字列
    id = "myS3InputLoc"

    # パラメータの属性を定義
    attribute {
      # 設定内容: 属性のキー名
      # 設定可能な値: 1-256文字の文字列
      key = "type"

      # 設定内容: 属性の値
      # 設定可能な値: 0-10240文字の文字列
      string_value = "AWS::S3::ObjectKey"
    }

    attribute {
      key          = "description"
      string_value = "S3 input location"
    }

    attribute {
      key          = "default"
      string_value = "s3://mybucket/input/"
    }
  }

  parameter_object {
    id = "myS3OutputLoc"

    attribute {
      key          = "type"
      string_value = "AWS::S3::ObjectKey"
    }

    attribute {
      key          = "description"
      string_value = "S3 output location"
    }

    attribute {
      key          = "default"
      string_value = "s3://mybucket/output/"
    }
  }

  #---------------------------------------
  # パラメータ値設定（オプション）
  #---------------------------------------
  # パラメータオブジェクトに実際の値を設定
  parameter_value {
    # 設定内容: 値を設定するパラメータオブジェクトのID
    # 設定可能な値: parameter_objectで定義したID
    id = "myS3InputLoc"

    # 設定内容: パラメータに設定する値
    # 設定可能な値: 0-10240文字の文字列
    string_value = "s3://mybucket/custom-input/"
  }

  parameter_value {
    id           = "myS3OutputLoc"
    string_value = "s3://mybucket/custom-output/"
  }

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# このリソースでは以下の属性が参照可能:
#
# id
#   - Terraform内部で使用される一意識別子
#   - 形式: pipeline_id
#
# pipeline_id
#   - Data PipelineのID
#
# region
#   - リソースが管理されているリージョン
#---------------------------------------
