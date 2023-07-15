# app/controllers/sales_controller.rb
class SalesController < ApplicationController
  def index
    @sales = Sale.all
    analyze_data
    # @anomalies = Sale.anomalies_over_time || []
  end

  def import
    Sale.import(params[:file])
    analyze_data
    redirect_to root_url, notice: "Data imported."
  end

  private

  def analyze_data
    @anomalies = Sale.anomalies_over_time
  end
end
