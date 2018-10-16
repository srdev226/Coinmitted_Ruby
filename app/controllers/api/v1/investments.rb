module API
  module V1
    class Investments < Grape::API
      include API::V1::Defaults

      resource :investments do
        desc 'Dashboard', headers: Base.headers_definition
        get '/', root: :investments do
          authenticate!
          set_currency
          investments = Investment.where(user_id: current_user.id)
          # investment_plans = @investments.group_by { |i| i.investment_plan }
          week_percentages = WeekPercentage.order(first_date: :asc).where("last_date < ?", Date.today)
          last_week_percentage = week_percentages.present? ? "#{week_percentages.last.percentage.to_f}%" : '+0%'
          render total_invested: amounts_in_cur_currency(investments, "invested"),
                 total_earnings: amounts_in_cur_currency(investments, "earnings"),
                 last_week_percentage: last_week_percentage,
                 currency: @currency,
                 cur_sign: Currency::CUR_SIGNS[@currency],
                 investments: investments.map { |item| InvestmentSerializer.new(item) }
        end

        desc 'get new dashboard values', headers: Base.headers_definition
        get '/values', root: :investments do
          authenticate!
          set_currency
          investment_plans = []
          InvestmentPlan.all.each do |ip|
            investment_plans << { id: ip.id, title: ip.title, subtitle: ip.subtitle, description: ip.description }
          end
          payout_frequency = []
          PayoutFrequency.order(:id).each do |pf|
            payout_frequency << { id: pf.id, title: pf.title, subtitle: pf.subtitle, description: pf.description, promo: pf.promo }
          end
          payment_methods = []
          PaymentMethod.all.each do |pm|
            payment_methods << { id: pm.id, name: pm.name, image: (pm.name == 'Balance' ? nil : pm.name.downcase), ticker: pm.ticker }
          end
          render investment_plans: investment_plans,
                 payout_frequency: payout_frequency,
                 payment_methods: payment_methods,
                 currency: @currency,
                 cur_sign: Currency::CUR_SIGNS[@currency]
        end

        desc 'get expected return', headers: Base.headers_definition
        post '/expected_return', root: :investments do
          authenticate!
          if params[:investment_id].present?
            open_date = Investment.find(params[:investment_id]).open_date
          else
            open_date = Time.now
          end
          end_date = Time.now + params[:investment][:timeframe].months
          inv = ::Wizard::Investment::Amount.new(
              name: params[:investment][:name],
              investment_plan_id: params[:investment][:invested_plan_id].to_i,
              invested_amount: params[:investment][:invested_amount].to_f,
              open_date: open_date.to_date,
              end_date: end_date.to_date,
              user_id: current_user.id,
              timeframe: params[:investment][:timeframe].to_i,
              payout_frequency_id: params[:investment][:payout_frequency_id].to_i
          )
          if inv.present?
            @expected = ::ExpectedReturn.new(inv.investment, inv.investment.payout_frequency.name, inv.user_id.to_i)
          else
            return 0
          end

          render @expected.total_earnings
        end

        desc 'check investment amount', headers: Base.headers_definition
        post '/check_investment', root: :investments do
          authenticate!
          open_date = Time.now
          end_date = Time.now + params[:investment][:timeframe].months
          inv = ::Wizard::Investment::Amount.new(
              name: params[:investment][:name],
              investment_plan_id: params[:investment][:invested_plan_id].to_i,
              invested_amount: params[:investment][:invested_amount].to_f,
              open_date: open_date.to_date,
              end_date: end_date.to_date,
              user_id: params[:investment][:user_id].to_i,
              timeframe: params[:investment][:timeframe].to_i,
              payout_frequency_id: params[:investment][:payout_frequency_id].to_i,
              currency: params[:investment][:currency],
              payment_method_id: params[:investment][:payment_method_id]
          )
          if inv.valid?
            render success: 'Everything looks good'
          else
            render error: inv.errors.full_messages[0]
          end
        end

        desc 'Investment create', headers: Base.headers_definition
        post '/', root: :investments do
          authenticate!
          set_currency
          open_date = Time.now
          end_date = Time.now + params[:investment][:timeframe].months
          inv = ::Wizard::Investment::Amount.new(
              name: params[:investment][:name],
              investment_plan_id: params[:investment][:invested_plan_id].to_i,
              invested_amount: params[:investment][:invested_amount].to_f,
              open_date: open_date.to_date,
              end_date: end_date.to_date,
              user_id: params[:investment][:user_id].to_i,
              timeframe: params[:investment][:timeframe].to_i,
              payout_frequency_id: params[:investment][:payout_frequency_id].to_i,
              currency: params[:investment][:currency],
              payment_method_id: params[:investment][:payment_method_id]
          )
          investment = inv.investment
          if investment.save
            generate_payouts(investment)
            InvestmentStatusCheckJob.set(wait_until: investment.end_date + 5.minutes).perform_later(investment.id)
            investment.update_attributes(:status => 3)
            fiat_rate = fiat_rate(investment.currency, investment.payment_method.ticker,investment.invested_amount.to_f)
            render success: 'Investment created.', id: investment.id, fiat_rate: fiat_rate
          else
            render error: investment.errors.full_messages.first
          end
        end

        desc 'Investment update', headers: Base.headers_definition
        patch '/:id', root: :investments do
          authenticate!
          set_currency
          investment = current_user.investments.find_by id: params[:id]
          if investment.present?
            end_date = investment.open_date + params[:investment][:timeframe].months
            investment.update name: params[:investment][:name], investment_plan_id: params[:investment][:invested_plan_id], end_date: end_date, payout_frequency_id: params[:investment][:payout_frequency_id], payment_method_id: params[:investment][:payment_method_id], invested_amount: params[:investment][:invested_amount].to_f, timeframe: params[:investment][:timeframe]
            if investment.save
              # generate_payouts(investment)
              # InvestmentStatusCheckJob.set(wait_until: investment.end_date + 5.minutes).perform_later(investment.id)
              # investment.update_attributes(:status => 3)
              render success: 'Investment updated.'
            else
              render error: investment.errors.full_messages.first
            end
          else
            render error: 'Investment not present.'
          end
        end

        desc 'Investment Show', headers: Base.headers_definition
        get '/:id', root: :investments do
          authenticate!
          set_currency
          investment = current_user.investments.find_by id: params[:id]
          if investment.present?
            render investment: InvestmentDetailSerializer.new(investment)
          else
            render error: 'Investment not present.'
          end
        end

        desc 'Get Fiat rate', headers: Base.headers_definition
        get '/:id/fiat_rate', root: :investments do
          authenticate!
          set_currency
          investment = current_user.investments.find_by id: params[:id]
          if investment.present?
            fiat_rate = fiat_rate(investment.currency, investment.payment_method.ticker,investment.invested_amount.to_f)
            render fiat_rate: fiat_rate
          else
            render error: 'Investment not present.'
          end
        end

        desc 'Investment Payouts API', headers: Base.headers_definition
        get '/:id/payouts', root: :investments do
          authenticate!
          set_currency
          investment = current_user.investments.find_by id: params[:id]
          if investment.present?
            payouts = Payout.order(pay_date: :desc)
            payouts = payouts.where(user_id: current_user.id)
            next_payout = nil
            payouts.reverse.each do |item|
              if item.pay_date > Date.today
                # distance_of_time_in_words(item.pay_date.to_time, Date.today.to_time),
                next_payout = item.pay_date.strftime("%d.%m.%Y")
                break
              end
            end
            json = []
            payouts.each do |item|
              if item.status == "paid"
                json << {
                    status: item.status,
                    reference_number: item.reference_number,
                    pay_date: item.pay_date.strftime("%d.%m.%Y"),
                    amount: item.amount,
                    cur_signs: Currency::CUR_SIGNS[investment.currency.upcase],
                }
              end
            end
            render next_payout: next_payout, payouts: json
          else
            render error: 'Investment not present.'
          end
        end

        desc 'Weekly Fund Performance API', headers: Base.headers_definition
        get '/weekly/performance', root: :investments do
          authenticate!
          percentage = {}
          years = []
          months = {}
          WeekPercentage.order('first_date desc').each do |item|
            year = item.last_date.strftime('%Y')
            if percentage[year].blank?
              percentage[year] = {}
              years << year
              months[year] = []
            end
            month = item.last_date.strftime('%B %Y')
            if percentage[year][month].blank?
              percentage[year][month] = []
              months[year] << month
            end
            title = "#{item.first_date.strftime('%B %e')} - #{item.last_date.strftime('%B %e')}"
            p = item.percentage.to_f
            percentage[year][month] << { title: title, percentage: p, current: (item.last_date >= Date.today && Date.today >= item.first_date) }
          end
          render years: years, months: months, percentage: percentage
        end
      end
    end
  end
end
