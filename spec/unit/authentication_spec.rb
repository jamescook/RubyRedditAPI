require_relative "../spec_helper"

describe Reddit::Api do
  describe "#login" do
    context "with invalid credentials" do
      before do
        WebMock.stub_request(:post, "http://www.reddit.com/api/login").
                 with(:body => "user=&passwd=").
                 to_return(:status => 200, :body => "", :headers => {})
      end

      it "returns false" do
        subject.login.should be_false
      end
    end

    context "with valid credentials" do
      subject { described_class.new("jimbo", "beans") }

      let(:success_headers) { 
        {"content-type"   => ["application/json; charset=UTF-8"], 
         "content-length" => ["224"],
         "set-cookie"     => ["reddit_session=really-long-string; Domain=reddit.com; Path=/; HttpOnly"],
         "server"         => ["'; DROP TABLE servertypes; --"],
         "date"           => ["Sat, 20 Jul 2013 01:30:10 GMT"],
         "connection"     => ["keep-alive"]
        }
      }

      before do
        WebMock.stub_request(:post, "http://www.reddit.com/api/login").
                 with(:body => "user=jimbo&passwd=beans").
                 to_return(:status => 200, :body => "", :headers => success_headers)
      end

      it "returns true" do
        subject.login.should be_true
      end
    end
  end
end
