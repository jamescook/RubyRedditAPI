require_relative "../spec_helper"

WebMock.disable_net_connect!

describe Reddit::Submission do
  let(:headers)  { { "Cookie" => "reddit_session", "User-Agent" => "Ruby Reddit Client v#{Reddit::VERSION}"} }
  let(:modhash)   { "b2cqiesw9o09937c00e4c94374b3e89e956cb54ef5525f953a" }
  let(:reddit_id) { "1i1lel" }

  before do
    Reddit::Base.instance_variable_set("@modhash", modhash)
  end

  describe "voting" do
    subject { described_class.new("id" => reddit_id, "author" => "I_CAPE_RATS", "subreddit" => "ruby", "kind" => "t3") }

    before do
      Reddit::Base.instance_variable_set("@cookie", 'reddit_session')
    end

    it "can be upvoted" do
      WebMock.stub_request(:post, "http://www.reddit.com/api/vote").
               with(:body => "id=t3_#{reddit_id}&dir=1&uh=#{modhash}").
               to_return(:status => 200, :body => "", :headers => {})

      subject.upvote.should be_true
    end

    it "can be downvoted" do
      WebMock.stub_request(:post, "http://www.reddit.com/api/vote").
               with(:body => "id=t3_#{reddit_id}&dir=-1&uh=#{modhash}").
               to_return(:status => 200, :body => "", :headers => {})

      subject.downvote.should be_true
    end
  end

  describe "#author" do
    let(:headers) { { "content-type"   => ["application/json; charset=UTF-8"] }}
    subject { described_class.new("id" => reddit_id, "author" => "I_CAPE_RATS", "subreddit" => "ruby", "kind" => "t3") }

    it "returns the author" do
      WebMock.stub_request(:get, "http://www.reddit.com/user/I_CAPE_RATS/about.json?").
               to_return(:status => 200, :headers => headers, :body => {"kind" => "t2", "data" => {"has_mail" => nil, "name" => "I_CAPE_RATS"}}.to_json)
      subject.author.should be_an_instance_of(Reddit::User)
    end
  end

  describe "#save" do
    describe "when logged in" do
      subject { described_class.new("id" => reddit_id, "subreddit" => "ruby", "kind" => "t3") }
      let(:reddit_id) { "1i1lel" }

      before do
        Reddit::Base.instance_variable_set("@cookie", 'reddit_session')
        WebMock.stub_request(:post, "http://www.reddit.com/api/save").
                 with(:body => "id=t3_#{reddit_id}&uh=#{modhash}&r=ruby&executed=save",
                 :headers => headers).
                 to_return(:status => 200)
      end

      it "saves the submission for later" do
        subject.save.should be_true
      end
    end
  end
end
