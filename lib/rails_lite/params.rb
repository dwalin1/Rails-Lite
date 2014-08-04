require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params = {}
    parse_www_encoded_form(req.query_string)
    parse_www_encoded_form(req.body)
    @params.merge!(route_params)
    @permitted = []
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
    keys.each do |k|
      @permitted << k
    end
  end

  def require(key)
    raise AttributeNotFoundError unless @params.has_key?(key)
    @params.delete_if do |k, v|
      k != key
    end
  end

  def permitted?(key)
    @permitted.include?(key)
  end

  def to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  
  def parse_www_encoded_form(www_encoded_form)
    return nil if www_encoded_form.nil?
    query = URI.decode_www_form(www_encoded_form)
    params = {}
    
    query.each do |key, value|
      nested_keys = parse_key(key)
      eval_string = ""
      nested_keys.each do |n_k|
        eval_string << "{ \"#{n_k}\" => "
      end
      eval_string << "\"#{value}\""
      nested_keys.count.times { eval_string << " }" }
      params.merge!(eval(eval_string)) 
    end
    
    @params.merge!(params)
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.scan(/\w+/)
  end
end
