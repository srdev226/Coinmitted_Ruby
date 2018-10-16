module InvestmentsHelper

    # current_user
    # @return amount in current selected currency
    def total_user_invested(user,user_currency='USD')
        result = 0.0
        user.investments.each do |item|
            unless item.status == 'draft'
                amount = item.invested_amount.to_f
                rate = rate(item.currency.upcase,user_currency)
                result += amount * rate.to_f
            end
        end
        result
    end

    # current_user
    # @return amount in current selected currency
    def total_user_earning(user, user_currency='USD')
        result = 0.0
        user.investments.each do |item|
            unless item.status == 'draft'
                amount = item.earned.to_f
                rate = rate(item.currency.upcase,user_currency)
                result += amount * rate.to_f
            end
        end
        result
    end

    def user_next_payout(user)
        payouts = []
        user.investments.each do |inv|
            inv.payouts.each do |item|
                if item.pay_date >= Date.today
                    payouts << item.pay_date
                end
            end
        end
        payout = payouts.sort_by { |date| (date.to_time - Date.today.to_time).abs }.first
        payout.strftime("%B %d, %Y") unless payout.nil?
    end

    def investment_next_payout(inv)
        payouts = []
        inv.payouts.each do |item|
            if item.pay_date >= Date.today
                payouts << item.pay_date
            end
        end
        payouts.sort_by { |date| (date.to_time - Date.today.to_time).abs }.first
    end

    def rate(from,to)
        Currency::Converter.new(from,to).get_rate
    end

end
