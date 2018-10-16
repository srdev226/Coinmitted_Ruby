namespace :rate do
  desc "Run currency rates syncronisation"
  task :run => :environment do
    RateRunJob.new.perform
  end
end
