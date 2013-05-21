Ruby Altmetric API Client
-------------------------

A simple Ruby client for the [Altmetric API](http://api.altmetric.com/).

Provides a basic client object for interacting with the API. Provides quick access to the JSON
results or direct access to API responses.

Installation
------------

	[sudo] gem install altmetric.rb
	
Relies on the `json`, `uri_template` and `httpclient` gems.

Creating A Client
-----------------

The client can be created with an API key which is required to raise usage limits and also to access 
the commercial parts of the API (the `fetch`) calls

	opts = {
	  :apikey => "12345",
	  :user_agent => "MyCoolApp/1.0"
	}

	client = Altmetric::Client.new(opts)
		
Default `User-Agent` is currently `altmetric-ruby-client/0.0.1`
	
Basic Usage
-----------

	require 'altmetric'

	client = Altmetric::Client.new()
	stats = client.doi("10.1038/news.2011.490")
	#do something with the stats
	
There are methods on the client object that match each of the Altmetric API entry points, e.g. `doi`, 
`arxiv`, `pmid`, etc.

Read the Altmetric API documentation for notes on the structure of the responses and additional API parameters.

Rate Limiting
-------------

The client object will automatically inspect all responses and extract the HTTP headers that Altmetric 
uses for [rate limiting](http://api.altmetric.com/index.html#rate_limiting). 

The latest header values are automatically added as integers to the `Altmetric::Client::LIMITS` hash, 
keyed on the header name. This simplifies monitoring limits over several requests, which may use different 
clients.
	
License
-------

This work is hereby released into the Public Domain.

To view a copy of the public domain dedication, visit http://creativecommons.org/licenses/publicdomain or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
 