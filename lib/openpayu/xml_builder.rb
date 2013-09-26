require 'builder/xmlmarkup'

module OpenPayU
  class XmlBuilder < ::Builder::XmlMarkup

    def initialize(req_type, options={})
      @req_type = req_type
      super(options)
    end

    def tag!(sym, *args, &block)
      if @level == 0 # Root element
        args << {"xsi:type" => @req_type, "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"}
      end
      super(sym, *args, &block)
    end

  end
end
