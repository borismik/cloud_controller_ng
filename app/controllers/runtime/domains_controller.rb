module VCAP::CloudController
  rest_controller :Domains do
    define_attributes do
      attribute :name, String
      attribute :wildcard, Message::Boolean
      to_one    :owning_organization, :optional_in => :create
      to_many   :spaces
    end

    query_parameters :name, :owning_organization_guid, :space_guid

    def self.translate_validation_exception(e, attributes)
      name_errors = e.errors.on(:name)
      if name_errors && name_errors.include?(:unique)
        Errors::DomainNameTaken.new(attributes["name"])
      else
        Errors::DomainInvalid.new(e.errors.full_messages)
      end
    end
  end
end
