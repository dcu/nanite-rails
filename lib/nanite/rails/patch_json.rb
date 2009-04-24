require 'json/add/rails'

class Array
  def to_json(*a)
    "["+self.map {|e| ActiveSupport::JSON.encode(e, *a) }.join(", ")+"]"
  end
end

class Hash
  def to_json(*a)
    "{"+
    self.map do |k, v|
      ActiveSupport::JSON.encode(k, *a)+":"+ ActiveSupport::JSON.encode(v, *a)
    end.join(", ") + "}"
  end
end
