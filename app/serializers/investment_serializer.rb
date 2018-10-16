class InvestmentSerializer < ActiveModel::Serializer
  include DashboardsHelper
  attributes :id, :name, :invested, :earnings, :currency

  def invested
    unless object.currency.nil? && object.invested_amount.nil?
      object.invested_amount
    else
      0.0
    end
  end

  def currency
    object.currency.upcase unless object.currency.nil?
  end

  def earnings
    unless object.currency.nil?
      object.earned ? object.earned : 0
    else
      0.0
    end
  end
end
