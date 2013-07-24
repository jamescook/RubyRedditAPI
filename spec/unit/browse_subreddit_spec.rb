require_relative "../spec_helper"

WebMock.disable_net_connect!

describe Reddit::Api do
  describe "#browse" do
    context "with an invalid subreddit" do
      let(:invalid_subreddit_headers) {
        {
          "content-type"      => ["text/html; charset=UTF-8"],
          "server"            => ["'; DROP TABLE servertypes; --"],
          "vary"              => ["accept-encoding"],
          "date"              => ["Sat, 20 Jul 2013 01:38:44 GMT"],
          "transfer-encoding" => ["chunked"],
          "connection"        => ["close", "Transfer-Encoding"]
        }
      }

      before do
        WebMock.stub_request(:get, "http://www.reddit.com/r/men-bathing-in-bird-baths.json?").
                 to_return(:status => 200, :body => "", :headers => invalid_subreddit_headers)

      end

      it "gives an error" do
        subject.browse("men-bathing-in-bird-baths").should be_false
      end
    end

    context "with a valid subreddit" do
      let(:valid_subreddit_headers) {
        {
          "content-type"   => ["application/json; charset=UTF-8"],
          "server"         => ["'; DROP TABLE servertypes; --"],
          "vary"           => ["accept-encoding"],
          "date"           => ["Sat, 20 Jul 2013 01:46:59 GMT"],
          "content-length" => ["1013"],
          "connection"     => ["keep-alive"]}
      }

      before do
        WebMock.stub_request(:get, "http://www.reddit.com/r/ruby.json?limit=1").
                 to_return(:status  => 200,
                           :body    => read_fixture("browse_subreddit.json"),
                           :headers => valid_subreddit_headers)
      end

      it "returns an array of Reddit::Submission" do
        subject.browse("ruby", :limit => 1).first.should be_an_instance_of(Reddit::Submission)
      end
    end
  end
end
