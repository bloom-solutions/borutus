module Borutus
  module Accounts
    class BuildRunningBalanceQuery

      STATEMENTS = {
        coalesce_debit: %{ COALESCE("debit_table"."amount", 0) },
        coalesce_credit: %{ COALESCE("credit_table"."amount", 0) },
        amount_sum: %{ SUM("borutus_amounts".amount) AS amount },
      }.freeze

      extend LightService::Action

      expects :account
      promises :joins_statement, :select_statement, :group_statement

      executed do |c|
        account = c.account
        credit_amounts = account.credit_amounts
        debit_amounts = account.debit_amounts

        credit_table = credit_amounts.joins(:entry).select(
          :id,
          :entry_id,
          STATEMENTS[:amount_sum],
        ).group(:entry_id, :id)

        debit_table = debit_amounts.joins(:entry).select(
          :id,
          :entry_id,
          STATEMENTS[:amount_sum],
        ).group(:entry_id, :id)

        sum_statement = sum_statement_from(account)

        c.joins_statement = joins_statement_from(credit_table, debit_table)
        c.select_statement = select_statement_from(sum_statement)
        c.group_statement = group_statement_from
      end

      def self.sum_statement_from(account)
        if account.normal_credit_balance
          %( #{STATEMENTS[:coalesce_credit]} - #{STATEMENTS[:coalesce_debit]} )
        else
          %( #{STATEMENTS[:coalesce_debit]} - #{STATEMENTS[:coalesce_credit]} )
        end
      end
      private_class_method :sum_statement_from

      def self.joins_statement_from(credit_table, debit_table)
        %{
          LEFT OUTER JOIN (#{credit_table.to_sql}) AS "credit_table" ON "credit_table".entry_id = "borutus_entries".id
          LEFT OUTER JOIN (#{debit_table.to_sql}) AS "debit_table" ON "debit_table".entry_id = "borutus_entries".id
        }
      end
      private_class_method :joins_statement_from

      def self.select_statement_from(sum_statement)
        %{
          "borutus_entries".*,
          SUM(#{sum_statement}) OVER(ORDER BY "borutus_entries"."created_at") AS balance,
          #{sum_statement} AS change_amount
        }
      end
      private_class_method :select_statement_from

      def self.group_statement_from
        %( "borutus_entries".id, "debit_table".amount, "credit_table".amount )
      end
      private_class_method :group_statement_from

    end
  end
end
