module CourierRails
  module DataOptions
    def self.included(base)
      base.class_eval do
        prepend InstanceMethods
      end
    end

    module InstanceMethods
      def mail(headers = {}, &block)
        headers = headers.clone
        courier_data = headers.delete(:courier_data)
        courier_data ||= {}
        super(headers, &block).tap do |message|
          message.singleton_class.class_eval { attr_accessor "courier_data" }
          message.courier_data = courier_data
        end
      end
    end
  end
end
