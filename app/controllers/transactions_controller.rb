class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_currencies, only: [:new, :create, :edit]
  before_action :admin_role?, only: [:index, :edit, :update, :show]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    unless edit_user? &&  current_user.wallet.id != params[:wallet_id]
      # TODO change later
      raise "error"
    end

    merged_data = {wallet_id: params[:wallet_id], name: "Withdraw to #{transaction_params[:ticker]}"}
    @transaction = Transaction.new(transaction_params.merge(merged_data))

    respond_to do |format|
      if enough_amount && @transaction.save
        format.html { redirect_to wallet_path(current_user), notice: 'Transaction was successfully created.' }
        #format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)

        dedact_from_user_wallet

        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to wallet_path(current_user.wallet.id), notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def enough_amount
    to_transfer = params[:transaction][:amount]
    current_user.wallet.currencies.each do |item|
      if item.ticker == params[:transaction][:ticker]
        return true if item.amount.to_f >= to_transfer.to_f
      end
    end
    false
  end

  def dedact_from_user_wallet
    @transaction.wallet.currencies.each do |item|
      if item.ticker == @transaction.ticker
        new_amount = item.amount.to_f - @transaction.amount.to_f
        item.update(amount: new_amount)
        binding.pry
      end
    end
    @transaction.update(flag: 1)
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      if edit_user?
        @transaction = Transaction.where(id: params[:id], wallet_id: params[:wallet_id]).first
      else
        @transaction = Transaction.where(id: params[:id], wallet_id: current_user.wallet.id).first
      end
    end

    def set_currencies
      cur_params = params[:wallet_id].present? ? { wallet_id: params[:wallet_id] } : { id: Transaction.find(params[:id]).wallet.id }
      @currecies = WalletCurrency.where(cur_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(
        :name, :address, :amount, :ticker, :wallet_id
      )
      #params.fetch(:transaction, {})
    end
end
