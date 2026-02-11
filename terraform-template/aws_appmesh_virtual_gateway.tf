#---------------------------------------------------------------
# AWS App Mesh Virtual Gateway
#---------------------------------------------------------------
#
# AWS App Meshのバーチャルゲートウェイをプロビジョニングするリソースです。
# バーチャルゲートウェイは、メッシュ外部のリソースがメッシュ内部のリソースと
# 通信することを可能にします。Envoyプロキシを単独でデプロイする形態を表し、
# Amazon ECS、Kubernetes、またはAmazon EC2インスタンス上で実行されます。
#
# AWS公式ドキュメント:
#   - Virtual gateways: https://docs.aws.amazon.com/app-mesh/latest/userguide/virtual_gateways.html
#   - App Mesh Concepts: https://docs.aws.amazon.com/app-mesh/latest/userguide/concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_virtual_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_appmesh_virtual_gateway" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: バーチャルゲートウェイの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  name = "example-virtual-gateway"

  # mesh_name (Required, Forces new resource)
  # 設定内容: バーチャルゲートウェイを作成するサービスメッシュの名前を指定します。
  # 設定可能な値: 1-255文字の文字列
  mesh_name = "example-service-mesh"

  # mesh_owner (Optional)
  # 設定内容: サービスメッシュ所有者のAWSアカウントIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID
  # 省略時: 現在接続されているAWSプロバイダーのアカウントIDを使用
  # 用途: 別アカウントが所有するメッシュにリソースを作成する場合に使用
  mesh_owner = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # スペック設定
  #-------------------------------------------------------------

  # spec (Required)
  # 設定内容: バーチャルゲートウェイの仕様を定義します。
  spec {

    #-----------------------------------------------------------
    # リスナー設定 (Required)
    #-----------------------------------------------------------

    # listener (Required)
    # 設定内容: メッシュエンドポイントが受信トラフィックを受け取るリスナーを定義します。
    # 注意: 1つ以上のリスナーを指定する必要があります
    listener {

      #---------------------------------------------------------
      # ポートマッピング設定 (Required)
      #---------------------------------------------------------

      # port_mapping (Required)
      # 設定内容: リスナーのポートマッピング情報を定義します。
      port_mapping {
        # port (Required)
        # 設定内容: ポートマッピングに使用するポート番号を指定します。
        # 設定可能な値: 1-65535の整数
        port = 8080

        # protocol (Required)
        # 設定内容: ポートマッピングに使用するプロトコルを指定します。
        # 設定可能な値:
        #   - "http": HTTP プロトコル（WebSocket接続への移行が可能）
        #   - "http2": HTTP/2 プロトコル
        #   - "grpc": gRPC プロトコル
        #   - "tcp": TCP プロトコル
        protocol = "http"
      }

      #---------------------------------------------------------
      # コネクションプール設定 (Optional)
      #---------------------------------------------------------

      # connection_pool (Optional)
      # 設定内容: リスナーのコネクションプール情報を定義します。
      # 関連機能: コネクションプール
      #   バーチャルゲートウェイのEnvoyが同時に確立できる接続数を制限します。
      #   Envoyインスタンスを接続過多から保護し、トラフィックシェーピングを調整できます。
      # 注意: プロトコルに応じて適切なブロックを選択してください
      connection_pool {

        # grpc (Optional)
        # 設定内容: gRPCリスナーのコネクションプール設定を定義します。
        # 注意: port_mappingのprotocolが"grpc"の場合に使用
        # grpc {
        #   # max_requests (Required)
        #   # 設定内容: 上流クラスタ内のホスト間でEnvoyが同時にサポートできる最大リクエスト数
        #   # 設定可能な値: 1以上の整数
        #   max_requests = 100
        # }

        # http (Optional)
        # 設定内容: HTTPリスナーのコネクションプール設定を定義します。
        # 注意: port_mappingのprotocolが"http"の場合に使用
        http {
          # max_connections (Required)
          # 設定内容: 上流クラスタ内の全ホストに対してEnvoyが同時に確立できる最大TCP接続数
          # 設定可能な値: 1以上の整数
          max_connections = 100

          # max_pending_requests (Optional)
          # 設定内容: max_connections後にEnvoyが上流クラスタにキューイングするオーバーフローリクエスト数
          # 設定可能な値: 1以上の整数
          # 省略時: 2147483647
          max_pending_requests = 1000
        }

        # http2 (Optional)
        # 設定内容: HTTP/2リスナーのコネクションプール設定を定義します。
        # 注意: port_mappingのprotocolが"http2"の場合に使用
        # http2 {
        #   # max_requests (Required)
        #   # 設定内容: 上流クラスタ内のホスト間でEnvoyが同時にサポートできる最大リクエスト数
        #   # 設定可能な値: 1以上の整数
        #   max_requests = 100
        # }
      }

      #---------------------------------------------------------
      # ヘルスチェック設定 (Optional)
      #---------------------------------------------------------

      # health_check (Optional)
      # 設定内容: リスナーのヘルスチェック情報を定義します。
      # 関連機能: ヘルスチェック
      #   リスナーの健全性を監視するためのヘルスチェックポリシーを設定できます。
      health_check {
        # healthy_threshold (Required)
        # 設定内容: リスナーを正常と宣言するために必要な連続成功ヘルスチェック回数
        # 設定可能な値: 正の整数
        healthy_threshold = 2

        # interval_millis (Required)
        # 設定内容: 各ヘルスチェック実行間の時間間隔（ミリ秒）
        # 設定可能な値: 正の整数（ミリ秒単位）
        interval_millis = 5000

        # protocol (Required)
        # 設定内容: ヘルスチェックリクエストのプロトコルを指定します。
        # 設定可能な値:
        #   - "http": HTTP プロトコル
        #   - "http2": HTTP/2 プロトコル
        #   - "grpc": gRPC プロトコル（GRPC Health Checking Protocolに準拠が必要）
        # 参考: https://github.com/grpc/grpc/blob/master/doc/health-checking.md
        protocol = "http"

        # timeout_millis (Required)
        # 設定内容: ヘルスチェックからの応答を待つ時間（ミリ秒）
        # 設定可能な値: 正の整数（ミリ秒単位）
        timeout_millis = 2000

        # unhealthy_threshold (Required)
        # 設定内容: バーチャルゲートウェイを異常と宣言するために必要な連続失敗ヘルスチェック回数
        # 設定可能な値: 正の整数
        unhealthy_threshold = 3

        # path (Optional)
        # 設定内容: ヘルスチェックリクエストの宛先パスを指定します。
        # 設定可能な値: パス文字列
        # 注意: protocolが"http"または"http2"の場合にのみ必要
        path = "/health"

        # port (Optional)
        # 設定内容: ヘルスチェックリクエストの宛先ポートを指定します。
        # 設定可能な値: 1-65535の整数
        # 省略時: port_mappingで定義されたポートを使用
        # 注意: port_mappingで定義されたポートと一致する必要があります
        port = 8080
      }

      #---------------------------------------------------------
      # TLS設定 (Optional)
      #---------------------------------------------------------

      # tls (Optional)
      # 設定内容: リスナーのTransport Layer Security (TLS) プロパティを定義します。
      # 関連機能: TLS終端
      #   バーチャルゲートウェイでTLS終端を有効にし、暗号化された通信を実現できます。
      #   - https://docs.aws.amazon.com/app-mesh/latest/userguide/tls.html
      tls {
        # mode (Required)
        # 設定内容: リスナーのTLSモードを指定します。
        # 設定可能な値:
        #   - "STRICT": TLSが必須。TLS接続のみを受け入れます
        #   - "PERMISSIVE": TLSとプレーンテキストの両方の接続を受け入れます
        #   - "DISABLED": TLSを無効化
        mode = "STRICT"

        # certificate (Required)
        # 設定内容: リスナーのTLS証明書を定義します。
        # 注意: acm、file、sdsのいずれか1つを指定
        certificate {

          # acm (Optional)
          # 設定内容: AWS Certificate Manager (ACM) 証明書を使用する場合に設定します。
          acm {
            # certificate_arn (Required)
            # 設定内容: ACM証明書のARNを指定します。
            # 設定可能な値: 有効なACM証明書ARN
            certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
          }

          # file (Optional)
          # 設定内容: ローカルファイルの証明書を使用する場合に設定します。
          # file {
          #   # certificate_chain (Required)
          #   # 設定内容: 証明書チェーンのファイルパスを指定します。
          #   # 設定可能な値: 1-255文字のファイルパス
          #   certificate_chain = "/path/to/certificate-chain.pem"
          #
          #   # private_key (Required)
          #   # 設定内容: 秘密鍵のファイルパスを指定します。
          #   # 設定可能な値: 1-255文字のファイルパス
          #   private_key = "/path/to/private-key.pem"
          # }

          # sds (Optional)
          # 設定内容: Secret Discovery Service (SDS) 証明書を使用する場合に設定します。
          # 関連機能: Envoy Secret Discovery Service
          #   - https://www.envoyproxy.io/docs/envoy/latest/configuration/security/secret#secret-discovery-service-sds
          # sds {
          #   # secret_name (Required)
          #   # 設定内容: SDSプロバイダーから取得するシークレット名を指定します。
          #   secret_name = "my-tls-secret"
          # }
        }

        # validation (Optional)
        # 設定内容: TLS検証コンテキストを定義します。
        # 用途: mTLS（相互TLS認証）を設定する場合に使用
        # validation {
        #   # trust (Required)
        #   # 設定内容: TLS検証コンテキストのトラストを定義します。
        #   # 注意: fileまたはsdsのいずれか1つを指定
        #   trust {
        #     # file (Optional)
        #     # 設定内容: ローカルファイルの証明書トラストを使用する場合に設定します。
        #     file {
        #       # certificate_chain (Required)
        #       # 設定内容: 証明書トラストチェーンのファイルパスを指定します。
        #       # 設定可能な値: 1-255文字のファイルパス
        #       certificate_chain = "/path/to/ca-certificate.pem"
        #     }
        #
        #     # sds (Optional)
        #     # 設定内容: SDSの証明書トラストを使用する場合に設定します。
        #     # sds {
        #     #   # secret_name (Required)
        #     #   # 設定内容: TLS SDSの検証コンテキストトラスト用のシークレット名を指定します。
        #     #   secret_name = "my-ca-secret"
        #     # }
        #   }
        #
        #   # subject_alternative_names (Optional)
        #   # 設定内容: TLS検証コンテキストのSAN（Subject Alternative Names）を定義します。
        #   # subject_alternative_names {
        #   #   # match (Required)
        #   #   # 設定内容: SANのマッチング条件を定義します。
        #   #   match {
        #   #     # exact (Required)
        #   #     # 設定内容: 完全一致する必要があるSAN値のセットを指定します。
        #   #     # 設定可能な値: FQDNまたはURI形式の文字列のセット
        #   #     exact = ["example.com", "www.example.com"]
        #   #   }
        #   # }
        # }
      }
    }

    #-----------------------------------------------------------
    # バックエンドデフォルト設定 (Optional)
    #-----------------------------------------------------------

    # backend_defaults (Optional)
    # 設定内容: バックエンドのデフォルト設定を定義します。
    # 用途: バーチャルゲートウェイがバックエンドサービスに接続する際のデフォルトポリシーを設定
    backend_defaults {

      # client_policy (Optional)
      # 設定内容: バーチャルゲートウェイバックエンドのデフォルトクライアントポリシーを定義します。
      client_policy {

        # tls (Optional)
        # 設定内容: Transport Layer Security (TLS) クライアントポリシーを定義します。
        # 関連機能: バックエンド接続のTLS設定
        #   バーチャルゲートウェイからバックエンドサービスへの接続にTLSを適用します。
        tls {
          # enforce (Optional)
          # 設定内容: ポリシーを強制するかどうかを指定します。
          # 設定可能な値:
          #   - true (デフォルト): TLSポリシーを強制
          #   - false: TLSポリシーを強制しない
          enforce = true

          # ports (Optional)
          # 設定内容: ポリシーを強制するポートを指定します。
          # 設定可能な値: ポート番号のセット
          # 省略時: すべてのポートにポリシーを適用
          ports = [443]

          # validation (Required)
          # 設定内容: TLS検証コンテキストを定義します。
          validation {
            # trust (Required)
            # 設定内容: TLS検証コンテキストのトラストを定義します。
            # 注意: acm、file、sdsのいずれか1つを指定
            trust {
              # acm (Optional)
              # 設定内容: ACMの証明書トラストを使用する場合に設定します。
              acm {
                # certificate_authority_arns (Required)
                # 設定内容: ACM認証局のARNを指定します。
                # 設定可能な値: ACM認証局ARNのセット
                certificate_authority_arns = ["arn:aws:acm-pca:ap-northeast-1:123456789012:certificate-authority/12345678-1234-1234-1234-123456789012"]
              }

              # file (Optional)
              # 設定内容: ローカルファイルの証明書トラストを使用する場合に設定します。
              # file {
              #   # certificate_chain (Required)
              #   # 設定内容: 証明書トラストチェーンのファイルパスを指定します。
              #   # 設定可能な値: 1-255文字のファイルパス
              #   certificate_chain = "/path/to/ca-certificate.pem"
              # }

              # sds (Optional)
              # 設定内容: SDSの証明書トラストを使用する場合に設定します。
              # sds {
              #   # secret_name (Required)
              #   # 設定内容: TLS SDSの検証コンテキストトラスト用のシークレット名を指定します。
              #   secret_name = "my-ca-secret"
              # }
            }

            # subject_alternative_names (Optional)
            # 設定内容: TLS検証コンテキストのSAN（Subject Alternative Names）を定義します。
            # subject_alternative_names {
            #   # match (Required)
            #   # 設定内容: SANのマッチング条件を定義します。
            #   match {
            #     # exact (Required)
            #     # 設定内容: 完全一致する必要があるSAN値のセットを指定します。
            #     # 設定可能な値: FQDNまたはURI形式の文字列のセット
            #     exact = ["backend.example.com"]
            #   }
            # }
          }

          # certificate (Optional)
          # 設定内容: クライアント証明書を定義します。
          # 用途: mTLS（相互TLS認証）でサーバーがクライアント証明書を要求する場合に使用
          # 注意: fileまたはsdsのいずれか1つを指定
          # certificate {
          #   # file (Optional)
          #   # 設定内容: ローカルファイルのクライアント証明書を使用する場合に設定します。
          #   file {
          #     # certificate_chain (Required)
          #     # 設定内容: 証明書チェーンのファイルパスを指定します。
          #     certificate_chain = "/path/to/client-certificate.pem"
          #
          #     # private_key (Required)
          #     # 設定内容: 秘密鍵のファイルパスを指定します。
          #     private_key = "/path/to/client-private-key.pem"
          #   }
          #
          #   # sds (Optional)
          #   # 設定内容: SDSのクライアント証明書を使用する場合に設定します。
          #   # sds {
          #   #   # secret_name (Required)
          #   #   # 設定内容: SDSプロバイダーから取得するシークレット名を指定します。
          #   #   secret_name = "my-client-cert-secret"
          #   # }
          # }
        }
      }
    }

    #-----------------------------------------------------------
    # ロギング設定 (Optional)
    #-----------------------------------------------------------

    # logging (Optional)
    # 設定内容: バーチャルゲートウェイのインバウンドおよびアウトバウンドアクセスログ情報を定義します。
    logging {

      # access_log (Optional)
      # 設定内容: バーチャルゲートウェイのアクセスログ設定を定義します。
      access_log {

        # file (Optional)
        # 設定内容: バーチャルゲートウェイのアクセスログを送信するファイルを定義します。
        file {
          # path (Required)
          # 設定内容: アクセスログを書き込むファイルパスを指定します。
          # 設定可能な値: 1-255文字のファイルパス
          # 推奨: /dev/stdout を使用してDockerログドライバーでAmazon CloudWatch Logsに送信
          # 注意: ログは依然としてアプリケーション内のエージェントによって取り込み・送信される必要があります
          path = "/dev/stdout"

          # format (Optional)
          # 設定内容: ログの出力フォーマットを定義します。
          # 注意: jsonまたはtextのいずれか1つを指定
          format {
            # text (Optional)
            # 設定内容: テキスト形式のログフォーマットを指定します。
            # 設定可能な値: 1-1000文字のフォーマット文字列
            # text = "[%START_TIME%] \"%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%\""

            # json (Optional)
            # 設定内容: JSON形式のログフォーマットを定義します。
            # 注意: 複数のキー・値ペアを指定可能
            json {
              # key (Required)
              # 設定内容: JSONのキーを指定します。
              # 設定可能な値: 1-100文字の文字列
              key = "start_time"

              # value (Required)
              # 設定内容: JSONの値を指定します。
              # 設定可能な値: 1-100文字の文字列（Envoyの変数を使用可能）
              value = "%START_TIME%"
            }

            json {
              key   = "method"
              value = "%REQ(:METHOD)%"
            }

            json {
              key   = "path"
              value = "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
            }

            json {
              key   = "response_code"
              value = "%RESPONSE_CODE%"
            }
          }
        }
      }
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-virtual-gateway"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: バーチャルゲートウェイのID
#
# - arn: バーチャルゲートウェイのAmazon Resource Name (ARN)
#
# - created_date: バーチャルゲートウェイの作成日
#
# - last_updated_date: バーチャルゲートウェイの最終更新日
#
# - resource_owner: リソース所有者のAWSアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
