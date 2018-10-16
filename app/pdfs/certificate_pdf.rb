class CertificatePdf < Prawn::Document
  def initialize(inv, view)
    super(top_margin: 70)
    @inv = inv
    @view = view
    header
    body
    footer
  end

  def header
    image "#{Rails.root}/app/assets/images/certificate_header.png", width: 540
  end

  def body
    move_down 50
    text "This is certify that #{@inv.user.profile.name} has invested", :align => :center
    move_down 30
    text "#{price(@inv.invested_amount)}", :size => 28, :align => :center, :color => "0000ff", :style => :bold
    move_down 40
    text "in <strong>#{@inv.investment_plan.title} #{@inv.investment_plan.subtitle}</strong> on <strong>#{@inv.created_at.strftime("%d %B, %Y")}</strong><br /> for a period of <strong>#{@inv.timeframe_months}</strong> with the investment<br /> being due on #{@inv.end_date.strftime("%d %B, %Y")}", :align => :center, :inline_format => true
  end

  def footer
    move_down 50
    table signature_table, :cell_style => {:inline_format => true} do
      columns(2).align = :right
      row(0).valign = :center
      column(0).padding = [60, 0, 20, 5]
      column(2).padding = [15, 0, 0, 0]
      #column(0).font_style = :underline
      row(0).columns(2).valign = :center
      columns(1).align = :center
      columns(0).width = 190
      self.width = 540
      cells.borders = []
      cells.valign = ['bottom']

    end
  end

  def signature_table
    certify_path = "#{Rails.root}/app/assets/images/certificate_certified.png"
    signature_path = "#{Rails.root}/app/assets/images/certificate_sign.png"
    [[
      "<u>#{@inv.open_date.strftime("%d %m %Y")}</u>",
      {image: certify_path, :image_width => 100, :position => :center},
      {image: signature_path, :image_width => 150, :position => :right}
    ]]
  end

  private

  def price(n)
    @view.number_to_currency(n)
  end

end
