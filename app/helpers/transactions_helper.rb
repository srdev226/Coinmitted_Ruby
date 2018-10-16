module TransactionsHelper

  def transaction_create_path(action, edit_user)
    if action == 'edit'
      @transaction
    elsif edit_user == true
      [:wallet, :user, @transaction]
    else
      [:wallet, @transaction]
    end
  end

end
