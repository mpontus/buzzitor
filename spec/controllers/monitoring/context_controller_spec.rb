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
      it "creates a new Monitoring::Context" do
        expect {
          post :create, params: {monitoring_context: valid_attributes}
        }.to change(Monitoring::Context, :count).by(1)
      end

      it "assigns a newly created monitoring_context as @monitoring_context" do
        post :create, params: {monitoring_context: valid_attributes}
        expect(assigns(:context)).to be_a(Monitoring::Context)
        expect(assigns(:context)).to be_persisted
      end

      it "enqueues FetchJob on newly created context" do
        expect {
          post :create, params: {monitoring_context: valid_attributes}
        }.to have_enqueued_job(FetchJob)
      end

      it "redirects to the created monitoring_context" do
        post :create, params: {monitoring_context: valid_attributes}
        expect(response).to redirect_to(Monitoring::Context.last)
      end
    end
  end
end
