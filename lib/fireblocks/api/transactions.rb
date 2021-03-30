# frozen_string_literal: true

module Fireblocks
  class API
    class Transactions
      class << self
        VALID_TRANSACTION_KEYS = %i[
          amount
          assetId
          source
          destination
          fee
          gasPrice
          note
          autoStaking
          networkStaking
          cpuStaking
        ].freeze

        def create(options)
          body = options.slice(*VALID_TRANSACTION_KEYS)
          Fireblocks::Request.post(body: body, path: '/v1/transactions')
        end

        def from_vault_to_external_one_time(
          amount:,
          asset_id:,
          source_id:,
          one_time_address:,
          tag: nil
        )
          one_time_address_hash = {
            address: one_time_address
          }
          one_time_address_hash.merge(tag: tag) if tag

          body = {
            amount: amount,
            assetId: asset_id,
            source: {
              type: 'VAULT_ACCOUNT',
              id: source_id
            },
            destination: {
              type: 'ONE_TIME_ADDRESS',
              oneTimeAddress: one_time_address_hash
            }
          }
          create(body)
        end


        def from_vault_to_external(
          amount:,
          asset_id:,
          source_id:,
          destination_id:,
          one_time_address:,
          tag: nil
        )
          one_time_address_hash = {
            address: one_time_address
          }
          one_time_address_hash.merge(tag: tag) if tag

          body = {
            amount: amount,
            assetId: asset_id,
            source: {
              type: 'VAULT_ACCOUNT',
              id: source_id
            },
            destination: {
              type: 'EXTERNAL_WALLET',
              id: destination_id,
              oneTimeAddress: one_time_address_hash
            }
          }
          create(body)
        end

        def from_vault_to_vault(
          amount:,
          asset_id:,
          source_id:,
          destination_id:
        )
          body = {
            amount: amount,
            assetId: asset_id,
            source: {
              type: 'VAULT_ACCOUNT',
              id: source_id
            },
            destination: {
              type: 'VAULT_ACCOUNT',
              id: destination_id
            }
          }
          create(body)
        end
      end
    end
  end
end
