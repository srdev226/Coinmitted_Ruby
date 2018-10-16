
User.create(email: 'admin@test.com', password: "123123", superadmin: true, role: "admin")

# Profile.create(
#   user_id: User.first.id,
#   name: "John Doe", bio: "text", gender: 0, language: "en", currency: "USD", country: "ru",
#   member: "VIP", notification_news: true, notification_deposit: true, notification_payout: true,
#   notification_alert: true, deleted: false, wallet_pin_enabled: true, wallet_pin: "hello", balance: 0.0
# )

# # Generate Wallets for users
# users = User.all
# users.each do |user|
#   if user.wallet.nil?
#     wallet_params = { user_id: user.id }
#     wallet = Wallet.create(wallet_params)
#     currency_params = [{ name: "Bitcoin", ticker: "BTC", wallet_id: wallet.id, amount: 0.0 },{ name: "Ethereum", ticker: "ETH", wallet_id: wallet.id, amount: 0.0 },{ name: "Litecoin", ticker: "LTC", wallet_id: wallet.id, amount: 0.0 }]
#     currency_params.each do |item|
#       WalletCurrency.create(item)
#     end
#   end
# end

User.find_by_email('admin@test.com').confirm

#User.find_by_email('admin@test.com').profile.update!(currency: 'USD')


#   User.create(email: 'none@none.com', password: "qwerty1", superadmin: true, role: "admin")

  InvestmentPlan.delete_all
  InvestmentPlan.create(title: "Basic", subtitle: "$50-$1K", description: "<ul><li>Lorem Ipsum</li><li>Lorem Ipsum</li><li>Lorem Ipsum</li></ul>", min: 50, max: 999)
  InvestmentPlan.create(title: "Blue", subtitle: "$1K-$10K", description: "<ul><li>Lorem Ipsum</li><li>Lorem Ipsum</li><li>Lorem Ipsum</li></ul>", min: 1000, max: 9999)
  InvestmentPlan.create(title: "VIP", subtitle: "$10K +", description: "<ul><li>Lorem Ipsum</li><li>Lorem Ipsum</li><li>Lorem Ipsum</li></ul>", min: 10000, max: 10000000)

  PayoutFrequency.delete_all
  PayoutFrequency.create(title: "Weekly", subtitle: "", description: "(Every Week)", promo: "", name: "weekly")
  PayoutFrequency.create(title: "Twice a Month", subtitle: "", description: "(1st and 15th)", promo: "", name: "twice")
  PayoutFrequency.create(title: "Monthly", subtitle: "", description: "(1st business day of the month)", promo: "", name: "monthly")
  PayoutFrequency.create(title: "At the end of investment period.", subtitle: "", description: "", promo: "+5% return", name: "end_of_period")

  PaymentMethod.delete_all
  PaymentMethod.create(name: "Balance", ticker: "balance")
  PaymentMethod.create(name: "Bitcoin", ticker: "btc")
  PaymentMethod.create(name: "Ethereum", ticker: "eth")
  PaymentMethod.create(name: "Litecoin", ticker: "ltc")

  36.times { |n|
    date = Date.parse("2018-01-04")
    date += n * 7
    WeekPercentage.create(
      first_date: date.at_beginning_of_week,
      last_date: date.at_end_of_week,
      date: date.at_beginning_of_week,
      percentage: 10
      )
    }
  #

  #User Profile
  Profile.create(
    user_id: User.first.id,
    name: "John Doe", bio: "text", gender: 0, language: "en", currency: "USD", country: "ru",
    member: "VIP", notification_news: true, notification_deposit: true, notification_payout: true,
    notification_alert: true, deleted: false, wallet_pin_enabled: true, wallet_pin: "hello", balance: 0.0
  )

  #### SET RATES TABLE WITH DATA
   CURRENCIES = ["USD","EUR","GBP","CAD","CNY","JPY","RUB"].freeze
   all_combinations = CURRENCIES.repeated_permutation(2).to_a
   # Rate create
   Rate.delete_all
   all_combinations.each do |item|
     unless item[0] === item[1]
       Rate.create(from: item[0], to: item[1])
     end
   end

  # Set Crypto Currecies to rates table
   CRYPTOS = ['LTC','ETH','BTC'].freeze
   CURRENCIES = ["USD","EUR","GBP","CAD","CNY","JPY","RUB"].freeze
   CRYPTOS.each do |crypto|
     CURRENCIES.each do |currency|
       Rate.create(from: crypto, to: currency, rate: 0.0, old_rate: 0.0)
     end
   end


  # Generate Wallets for users
   users = User.all
   users.each do |user|
     if user.wallet.nil?
       wallet_params = { user_id: user.id }
       wallet = Wallet.create(wallet_params)
       currency_params = [{ name: "Bitcoin", ticker: "BTC", wallet_id: wallet.id, amount: 0.0 },{ name: "Ethereum", ticker: "ETH", wallet_id: wallet.id, amount: 0.0 },{ name: "Litecoin", ticker: "LTC", wallet_id: wallet.id, amount: 0.0 }]
       currency_params.each do |item|
         WalletCurrency.create(item)
       end
     end
   end

  # create affiliate_levels
   levels = [
     {
       name: :starter,
       range_start: 0,
       range_end: 10,
       commision: 0.10
     },
     {
       name: :silver,
       range_start: 11,
       range_end: 50,
       commision: 0.15
     },
     {
       name: :gold,
       range_start: 51,
       range_end: 100,
       commision: 0.20
     },
     {
       name: :diamond,
       range_start: 101,
       range_end: 100000,
       commision: 0.20
     }
   ]

   levels.each do |level|
     AffiliateLevel.create(name: level[:name],
       range_start: level[:range_start],
       range_end: level[:range_end],
       commision: level[:commision]
     )
   end
