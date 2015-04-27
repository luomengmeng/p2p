class Dict::CashFlowDescription < Dictionary
  translate_name
  FORSEARCH = %w{charge pay_bid repay withdraw withdraw_return withdraw_apply return_pay_bid transfer_to_borrower offline_recharge sell_bid sell_bid_fee prize_first prize_max prize_last prize_register}
  scope :can_be_search, -> {where(["name in (?)", FORSEARCH])}
  class << self

    %w{charge pay_bid repay platform risk_fee withdraw withdraw_return withdraw_apply input_fee output_fee return_pay_bid transfer_to_borrower offline_recharge sell_bid sell_bid_fee promote_prize prize_first prize_max prize_last prize_register}.each do |t|

      define_method t do
        self.find_by_name(t)
      end
    end
  end
end