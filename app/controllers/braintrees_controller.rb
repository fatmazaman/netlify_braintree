class BraintreesController < ApplicationController
  before_action :authenticate_user!
  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]	
  def index
  	@client_token = Braintree::ClientToken.generate
  end

  def create
    amount = params["amount"] # In production you should not take amounts directly from clients
    nonce = 'fake-valid-visa-nonce'

    result = Braintree::Transaction.sale(
      amount: amount,
      payment_method_nonce: nonce,
    )

    if result.success? || result.transaction
      redirect_to braintree_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to braintrees_path
    end
  end

  def show
  	# @transaction = Braintree::Transaction.find(params[:id])
	# @result = _create_result_hash(@transaction)
	@search_results = Braintree::Transaction.search do |search|
  	search.status.in(
    Braintree::Transaction::Status::ProcessorDeclined,
    Braintree::Transaction::Status::GatewayRejected
  	)
	end

  end

  def _create_result_hash(transaction)
    status = transaction.status

    if TRANSACTION_SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Sweet Success!",
        :icon => "success",
        :message => "Your test transaction has been successfully processed. See the Braintree API response and try again."
      }
    else
      result_hash = {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your test transaction has a status of #{status}. See the Braintree API response and try again."
      }
    end
  end
end
