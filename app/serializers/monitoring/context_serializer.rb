class Monitoring::ContextSerializer < ActiveModel::Serializer
  attribute :id
  attribute :url, key: :address

  has_one :latest_result

  class ResultSerializer < ActiveModel::Serializer
    attribute :status do
      if is_error? then :error else :content end
    end

    attribute :content_url, unless: :is_error?

    attribute :error_code, if: :is_error?

    def content_url
      Rails.application.routes.url_helpers.monitoring_result_url(object)
    end

    def is_error?
      not object.error_code.nil?
    end

  end

end
