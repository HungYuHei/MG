# coding: utf-8

require 'spec_helper'

describe WeiboTopic do
  let(:weibo_info) {
    {
      'created_at' => "Thu Mar 29 22:08:16 +0800 2012",
      'id' => 3429039115033720,
      'text' => "【协会微博新小编",
      'source' => "<a href='http://weibo.com'>d</a>",
      'favorited' => false,
      'thumbnail_pic' => "http://ww1.sinaimg.cn/t7ra7vj.jpg",
      'bmiddle_pic' => "http://ww1.sinaimg.cn/77a7vj.jpg",
      'original_pic' => "http://ww1.sinaimg.cn/777vj.jpg",
      'user' => {
        'id' => 1997612611,
        'screen_name' => "佛大自行车协会",
        'name' => "佛大自行车协会",
        'province' => "44",
        'description' => '关注环保',
        'profile_image_url' => "http://tp4.sinaimg.cn/1997612611/50/5599477104/1"
      }
    }
  }
  let(:retweet_info) {
    {
      'retweeted_status' => {
        'text' => "text",
        'thumbnail_pic' => "http://ww3.jpg",
        'bmiddle_pic' => "http://ww3.s.jpg",
        'original_pic' => "http://ww3.jpg"
      }
    }
  }

  before(:each) do
    @weibo_topic = WeiboTopic.build_with_weibo_info(weibo_info)
  end

  it 'should create a new WeiboTopic' do
    @weibo_topic.should be_a(WeiboTopic)
  end

  it "should embed_images" do
    @weibo_topic.should be_embed_images
  end

  it "should not retweeted" do
    @weibo_topic.should_not be_retweeted
  end

  describe 'retweet info' do
    before(:each) do
      @retweet_topic = WeiboTopic.build_with_weibo_info(weibo_info.merge!(retweet_info))
    end

    it "should retweeted" do
      @retweet_topic.should be_retweeted
    end

    it "should has retweet text" do
      @retweet_topic.retweet_text.should be_present
    end

  end

  describe 'created_at field' do
    it "should be Time" do
      @weibo_topic.sent_at.should be_a(Time)
    end
  end

  describe 'user_url field' do
    it "should start with 'http://weibo.com'" do
      @weibo_topic.user_url.should be_start_with('http://weibo.com')
    end
  end

  describe 'user field' do
    it "should only has 3 keys" do
      @weibo_topic.user.size.should eq(3)
    end
    it "should include id, screen_name, profile_image_url keys" do
      @weibo_topic.user.each_key { |key| %w(id screen_name profile_image_url).should include(key) }
    end
  end
end
