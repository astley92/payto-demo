class SettlementAccountsController < ApplicationController
  def show
    render locals: {
      settlement_account: SettlementAccount.find(params[:id]),
    }
  end

  def update
    if settlement_account.update(**settlement_account_params)
      flash[:notice] = "Settlement account updated successfully"
    else
      flash[:alert] = settlement_account.errors.full_messages.to_sentence
    end
    redirect_to settlement_account_path(params[:id])
  end

  private

  def settlement_account_params
    params.require(:settlement_account).permit(
      :account_name,
      :branch_code,
      :account_number,
    )
  end

  def settlement_account
    @settlement_account ||= SettlementAccount.find(params[:id])
  end
end
