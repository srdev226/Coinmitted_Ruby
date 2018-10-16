namespace :payout do
  desc "Run Payout checking"
  task :check => :environment do
    PayoutsCheckJob.new.perform
  end
end
