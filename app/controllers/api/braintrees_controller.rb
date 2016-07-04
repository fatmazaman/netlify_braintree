module Api
	class BraintreesController < ApplicationController
		skip_before_action :verify_authenticity_token
		http_basic_authenticate_with name: "braintree", password: "password"
		respond_to :json
		def index
			@search_results = Braintree::Transaction.search do |search|
  			search.status.in(
    		Braintree::Transaction::Status::ProcessorDeclined,
    		Braintree::Transaction::Status::GatewayRejected
  			)
			end
			# respond_with @search_results
			results = []
			@search_results.each  do |i|
				# results << i.amount
				# puts i.created_at
				# puts i.id
				# puts i.merchant_account_id
 				results << {id: i.id, amount: i.amount, created_at: i.created_at, merchant_account_id: i.merchant_account_id}
			end
			puts results
			respond_with results
		end	
	end
end

