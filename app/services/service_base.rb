class ServiceBase
  attr_reader :errors

  def initialize(*params)
    @errors = []
  end

  def add_error(error)
    if error.is_a?(Array)
      @errors += error
    else
      @errors << error
    end
  end

  def success?
    @errors.empty?
  end

  def self.call(params)
    new(params).call
  end
end
