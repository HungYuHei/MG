# coding: utf-8

require 'net/http'

class WeiboTopicsController < ApplicationController
  def index
    uri = URI('http://api.t.sina.com.cn/trends/statuses.json')
    params = { source: Setting.weibo_token, trend_name: Setting.weibo_trend_name }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)

    @weibo_topics = []
    if res.is_a?(Net::HTTPSuccess)
      MultiJson.decode(res.body).each do |weibo_topic|
        @weibo_topics << WeiboTopic.build_with_weibo_info(weibo_topic)
      end
    end
  end
end
