class RenameKindToTransactionTypeInTransactions < ActiveRecord::Migration[8.0]
  def change
    rename_column :transactions, :kind, :transaction_type
  end
end
