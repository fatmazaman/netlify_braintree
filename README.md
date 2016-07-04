BrainTree Project
------------------

This is an example Rails application where failed transaction are listed through braintree API.

REST API side
-------------
* Fetched failed transaction using below piece of code
	```ruby
	@search_results = Braintree::Transaction.search do |search|
  		search.status.in(
    	Braintree::Transaction::Status::ProcessorDeclined,
    	Braintree::Transaction::Status::GatewayRejected
  		)
	end
	```

* API has built using rails inbuilt API functionalities.
* Used rack cors gem to allow cross origin request.
* Used Basic Auth for authentication over API.
* Used devise gem for user authentication through UI.

Client side
-----------
* Created a sign in form and listening for submit event through jQuery.
* Made an ajax call to authenticate and consume API.
 
  ```javascript
  	$.ajax({
  			url: 'http://localhost:3000/api/braintrees',
  			beforeSend: function (xhr) {
   			 xhr.setRequestHeader ("Authorization", "Basic " + btoa('braintree' + ":" + 'password'));
 			}
		})
  		.done(function(data) {
    	 	showTransaction(data);
    	 	console.log(data);
  		})
  		.fail(function() {
    	alert( "error" );
  		});
  	});
  	```

