class WalletService
  def initialize(wallet) = @wallet = wallet

  def credit!(amount, reference:)
    ActiveRecord::Base.transaction do
      @wallet.update!(balance: @wallet.balance + amount)
      tx(:credit, amount, reference)
    end
  end

  def debit!(amount, reference:)
    raise "Insufficient" if @wallet.available < amount
    ActiveRecord::Base.transaction do
      @wallet.update!(balance: @wallet.balance - amount)
      tx(:debit, amount, reference)
    end
  end

  def lock!(amount, reference:)
    raise "Insufficient available" if @wallet.available < amount
    ActiveRecord::Base.transaction do
      @wallet.update!(locked_amount: @wallet.locked_amount + amount)
      tx(:lock, amount, reference)
    end
  end

  def unlock!(amount, reference:)
    ActiveRecord::Base.transaction do
      @wallet.update!(locked_amount: [@wallet.locked_amount - amount, 0].max)
      tx(:unlock, amount, reference)
    end
  end

  def penalty!(amount, reference:)
    ActiveRecord::Base.transaction do
      @wallet.update!(
        locked_amount: [@wallet.locked_amount - amount, 0].max,
        balance:       [@wallet.balance       - amount, 0].max
      )
      tx(:penalty, amount, reference)
    end
  end

  private

  def tx(transaction_type, amount, reference)
    Transaction.create!(wallet: @wallet, transaction_type: transaction_type, amount: amount,
                        status: :completed, reference: reference)
  end
end