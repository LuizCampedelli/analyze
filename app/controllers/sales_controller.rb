# app/controllers/sales_controller.rb
class SalesController < ApplicationController
  def index
    @sales = Sale.all
    @anomalies = Sale.anomalies_over_time || []
  end

  def import
    Sale.import(params[:file])
    redirect_to root_url, notice: "Data imported."
  end
end
