class Monitoring::NotificationSerializer < ActiveModel::Serializer
  attribute :tag do
    object.context.id
  end
  attribute :title
  attribute :body
  attribute :icon
end
