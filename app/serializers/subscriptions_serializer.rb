class SubscriptionsSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :status, :frequency

  attribute :total_active_customers do |subscription|
    subscription.subscription_teas.where(status: true).distinct.count(:customer_id)
  end

  attribute :teas, if: Proc.new { |_subscription, params| params && params[:include_teas] } do |subscription|
    subscription.teas.map do |tea|
      {
        title: tea.title,
        description: tea.description,
        temp: tea.temp,
        brew_time: tea.brew_time
      }
    end
  end

  attribute :customers, if: Proc.new { |_subscription, params| params && params[:include_customers] } do |subscription|
    subscription.subscription_teas.includes(:customer).map do |sub_tea|
      {
        first_name: sub_tea.customer.first_name,
        last_name: sub_tea.customer.last_name,
        email: sub_tea.customer.email,
        address: sub_tea.customer.address,
        sub_status: sub_tea.status
      }
    end
  end
end

