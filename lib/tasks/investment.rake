namespace :investment do
  desc "Run investment status check"
  task :status_check => :environment do
    InvestmentStatusCheckJob.new.perform_all
  end
end
