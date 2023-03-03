class PurchasesController < ApplicationController
  def show
    purchase = Purchase.find(params[:id])
    render locals: {
      purchase: purchase,
      item: purchase.item,
    }
  end

  def create
    outcome = Command::Purchase::CreateNew.run(**purchase_params)
    if outcome.valid?
      purchase = outcome.result
      Command::Purchase::CreateAgreement.perform_in(2.seconds, purchase.id)
      redirect_to purchase_path(purchase.id)
    else
      flash[:alert] = outcome.errors.full_messages.to_sentence
      redirect_to new_purchase_path(item_id: purchase_params[:item_id])
    end
  end

  def new
    render locals: {
      item: Item.find(params[:item_id])
    }
  end

  private

  def purchase_params
    params.require(:purchase).permit(:item_id, :account_number, :branch_code, :account_name)
  end
end
