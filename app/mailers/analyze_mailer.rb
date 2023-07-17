class AnalyzeMailer < ApplicationMailer
  default from: 'noreply@analyzeit.com'

  def sales_analysis_complete
    @url  = 'https://analyzeit.herokuapp.com'
    mail(to: 'analyzeit666@gmail.com', subject: 'Checkout Analysis is Complete')
  end

  def transactions_analysis_complete
    @url = 'https://analyzeit.herokuapp.com/transactions'
    mail(to: 'analyzeit666@gmail.com', subject: 'Transactions Analysis Complete')
  end
end

