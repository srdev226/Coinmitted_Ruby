require 'rails_helper'

RSpec.describe InvestmentStatusCheckJob, type: :job do

  describe "#perform later" do
    it "change investment status" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        InvestmentStatusCheckJob.perform_later('check')
      }.to have_enqueued_job
    end

    it "queue the job" do
      expect {
        InvestmentStatusCheckJob.perform_later('check')
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end
end
