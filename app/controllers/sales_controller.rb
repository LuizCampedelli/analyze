# app/controllers/sales_controller.rb
class SalesController < ApplicationController
  def index
    @sales = Sale.all
    analyze_data
  end

  def import
    Sale.import(params[:file])
    analyze_data
    # Send email after analyzing the data
    AnalyzeMailer.sales_analysis_complete.deliver_now

    redirect_to root_url, notice: "Data imported."
  end

  private

  def analyze_data
    @anomalies = Sale.anomalies_over_time
  end
end
