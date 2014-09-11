class FakeResponse
  attr_reader :code
  attr_reader :body
  def initialize(body, code)
    @code = code.to_s
    @body = body.to_s
  end
end