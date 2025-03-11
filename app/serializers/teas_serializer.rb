class TeasSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :temp, :brew_time

  attribute :customer_count, if: Proc.new { |_record, params| params[:include_customer_count] } do |tea|
    tea.customer_count
  end
end
