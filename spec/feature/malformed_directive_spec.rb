require 'spec_helper'

RSpec.describe "Seeding an application" do
  context "with a malformed directive", :type => :integration do
    let(:orm_model) do
        case Sprig.adapter
        when :active_record
          'ActiveRecord::Base'
        when :mongoid
          'Mongoid::Document'
        end
      end
    let(:expected_error_message) { "Sprig::Directive must be instantiated with a(n) #{orm_model} class or a Hash with :class defined" }

    context "including a class that is not a subclass of AR" do
      it "raises an argument error" do
        expect {
          sprig [
            Object
          ]
        }.to raise_error(ArgumentError, expected_error_message)
      end
    end

    context "including a non-class, non-hash" do
      it "raises an argument error" do
        expect {
          sprig [
            42
          ]
        }.to raise_error(ArgumentError, expected_error_message)
      end
    end
  end
end
