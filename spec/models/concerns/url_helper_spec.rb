require 'rails_helper'

RSpec.describe URLHelper, type: :model do

    describe 'valid_url?' do

      it "can't returns false on invalid url" do
        ["hello", "hello.", "http:", "http:/", "http://", "http:/hello", "http//hello"].each do |url|
          expect(URLHelper::valid_url? url).to be_falsey
        end
      end

    end

end
