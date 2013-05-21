$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'altmetric'
require 'mocha/setup'

class AltmetricTest < Test::Unit::TestCase
  
  def test_make_url
    assert_equal("http://api.altmetric.com/v1/doi", 
      Altmetric::Client.make_url(Altmetric::Client::URI_TEMPLATE, {:path => "doi"} ) )
  end
  
  def test_update_limits
    headers = {
      "X-HourlyRateLimit-Limit" => "10",
      "X-DailyRateLimit-Limit" => "100",
      "X-HourlyRateLimit-Remaining" => "9",
      "X-DailyRateLimit-Remaining" => "99"        
    }
    Altmetric::Client::update_limits(headers)
    
    assert_equal(10, Altmetric::Client::LIMITS["X-HourlyRateLimit-Limit"])
    assert_equal(100, Altmetric::Client::LIMITS["X-DailyRateLimit-Limit"])
    assert_equal(9, Altmetric::Client::LIMITS["X-HourlyRateLimit-Remaining"])
    assert_equal(99, Altmetric::Client::LIMITS["X-DailyRateLimit-Remaining"])    
  end
  
  def test_get
    http_client = mock()
    http_client.expects(:get).with(
        "http://api.altmetric.com/v1/doi/123", {}, {"Accept"=>"application/json"}).returns(
          HTTP::Message.new_response("{}") )
    
    client = Altmetric::Client::new({:client=>http_client})    
    response = client.get("http://api.altmetric.com/v1/doi/123")
    assert_equal("{}", response.content)
  end
  
  def test_get_with_apikey
    http_client = mock()
    http_client.expects(:get).with(
        "http://api.altmetric.com/v1/doi/123", {"key"=>"abc"}, {"Accept"=>"application/json"}).returns(
          HTTP::Message.new_response("{}") )
    
    client = Altmetric::Client::new({:apikey=>"abc", :client=>http_client})    
    response = client.get("http://api.altmetric.com/v1/doi/123")
    assert_equal("{}", response.content)
  end
  
  def test_get_metrics
    http_client = mock()
    http_client.expects(:get).with(
        "http://api.altmetric.com/v1/doi/123", {}, {"Accept"=>"application/json"}).returns(
          HTTP::Message.new_response("{}") )
    
    client = Altmetric::Client::new({:client=>http_client})    
    response = client.get_metrics(["doi", "123"])
    assert_equal({}, response)
  end  

  def test_get_metrics_with_key
    http_client = mock()
    http_client.expects(:get).with(
        "http://api.altmetric.com/v1/doi/123", {"key"=>"abc"}, {"Accept"=>"application/json"}).returns(
          HTTP::Message.new_response("{}") )
    
    client = Altmetric::Client::new({:apikey=>"abc", :client=>http_client}) 
    response = client.get_metrics(["doi", "123"])
    assert_equal({}, response)
  end  
    
end