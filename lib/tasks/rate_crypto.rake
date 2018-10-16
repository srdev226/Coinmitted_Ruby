namespace :rate_crypto do
  desc "Run crypto-currency syncronisation"
  task :run => :environment do
    RateCryptoRunJob.new.perform
  end
end
