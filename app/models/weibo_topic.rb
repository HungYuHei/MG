class WeiboTopic
  include Mongoid::Document

  field :content
  field :user_url
  field :user, type: Hash, default: {}
  field :images, type: Hash, default: {}
  field :sent_at
  field :retweet_text
  field :retweeted, type: Boolean, default: false

  def self.build_with_weibo_info(weibo_info)
    weibo_info['user'].keep_if { |key, _| %w(id screen_name profile_image_url).include?(key) }

    retweeted = weibo_info['retweeted_status'].present?
    if retweeted
      retweet_info = weibo_info['retweeted_status']
      images = { thumb: retweet_info['bmiddle_pic'], original: retweet_info['original_pic'] }
      retweet_text = retweet_info['text']
    else
      images = { thumb: weibo_info['bmiddle_pic'], original: weibo_info['original_pic'] }
    end

    self.new(content: weibo_info['text'], sent_at: Time.parse(weibo_info['created_at']),
             user: weibo_info['user'], images: images, retweeted: retweeted, retweet_text: retweet_text,
             user_url: 'http://weibo.com/' << weibo_info['user']['id'].to_s)
  end

  def embed_images?
    images[:thumb].present? and images[:original].present?
  end
end
