class InvestmentStatusCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    id = args[0]
    investment = Investment.find(id)
    if investment.end_date <= DateTime.now
      investment.update(status: 2)
    end
  end

  def perform_all(*args)
    investments = Investment.all
    investments.each do |item|
      if item.end_date.present? && item.end_date <= DateTime.now
        item.update(status: 2)
      end
    end
  end
end
