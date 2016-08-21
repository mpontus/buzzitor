require 'rails_helper'

RSpec.describe Monitoring::SubscribersController, type: :controller do

  let(:valid_attributes) {
    { endpoint: "https://android.googleapis.com/gcm/send/ae5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU" }
  }

  before do
    @context = Monitoring::Context.create! url: "http://example.org/"
    @context.results.create! content: "Foobarbaz"
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Monitoring::Subscriber" do
        expect {
          post :create, params: { context_id: @context.id,
                                  monitoring_subscriber: valid_attributes }
        }.to change(Monitoring::Subscriber, :count).by(1)
      end

      it "does not create duplicate subscription for the same context and endpoint" do
          post :create, params: { context_id: @context.id,
                                  monitoring_subscriber: valid_attributes }
          expect {
            post :create, params: { context_id: @context.id,
                                    monitoring_subscriber: valid_attributes }
          }.not_to change(Monitoring::Subscriber, :count)
      end

      it "sends notification to newly created subscriber if monitoring result has been already fetched" do
        expect {
          post :create, params: { context_id: @context.id,
                                  monitoring_subscriber: valid_attributes }
        }.to change { Rpush::Notification.all.count } .by(1)
      end

      it "does not send welcoming notification for the same endpoint twice" do
        post :create, params: { context_id: @context.id,
                                monitoring_subscriber: valid_attributes }
        expect {
          post :create, params: { context_id: @context.id,
                                  monitoring_subscriber: valid_attributes }
        }.not_to change { Rpush::Notification.all.count }
      end
    end
  end
end
