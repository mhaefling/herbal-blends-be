class TeasSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :temp, :brew_time
end
