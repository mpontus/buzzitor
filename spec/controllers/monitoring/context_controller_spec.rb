require 'rails_helper'

RSpec.describe Monitoring::ContextsController, type: :controller do

  let(:valid_attributes) {
    { url: "http://example.org/" }
  }

  let(:invalid_attributes) {
    { url: "foobar" }
  }

  setup do
    @original_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
  end

  teardown do
    ActiveJob::Base.queue_adapter = @original_queue_adapter
  end

  describe "POST #create" do

    context "with valid params" do

      it "creates new context" do
        expect {
          post :create, xhr: true, format: :json, params: {monitoring_context: valid_attributes}
        }.to change(Monitoring::Context, :count).by(1)
      end

      it "enqueues FetchJob for newly created context" do
        expect {
          post :create, xhr: true, format: :json, params: {monitoring_context: valid_attributes}
        }.to have_enqueued_job(FetchJob)
      end

      it "returns newly created object serialized into json" do
        post :create, xhr: true, format: :json, params: {monitoring_context: valid_attributes}
        expect(response).to have_node(:id).with(Monitoring::Context.last.id)
      end

    end

    context "with invalid params" do

      it "returns json status error" do
        post :create, xhr: true, format: :json, params: {monitoring_context: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end

  end

end
