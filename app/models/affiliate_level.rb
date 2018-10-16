class AffiliateLevel < ApplicationRecord

  enum name: [:starter, :silver, :gold, :diamond]

  def range=(rstart, rend)
    self.range_start = rstart
    self.range_end = rend
  end

  def range
    (range_start..range_end)
  end

  def progress_step
    100 / self.range_end
  end

  def next_level_name
    value = AffiliateLevel.names[self.name].next
    AffiliateLevel.names.key(value)
  end
end
