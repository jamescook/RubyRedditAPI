require_relative "../spec_helper"

describe Reddit::Api do
  describe "#search" do
    let(:keyword) { "cats" }
    let(:response_headers) { { "content-type"   => ["application/json; charset=UTF-8"] }}

    it "returns an array of submissions" do
      WebMock.stub_request(:get, "http://www.reddit.com/r/cats/search.json?q=#{keyword}&sort=relevance&restrict_sr=1").
               to_return(:status => 200, :body => read_fixture("search_results.json"), :headers => response_headers)

      subject.search(keyword, :in => "cats").first.should be_an_instance_of(Reddit::Submission)
    end
  end
end
