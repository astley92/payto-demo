class ItemsController < ApplicationController
  def index; end

  def show
    render locals: {
      item: Item.find(params[:id])
    }
  end
end
