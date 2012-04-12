#encoding: utf-8
require "spec_helper"

describe HomeController do
  describe ":index" do
    let(:user) { Factory :user }
    it "should show sns-login link and not show register link if user not signed in and un-registerable" do
      Setting['registerable'] = false
      get :index
      response.should be_success
      visit '/'
      get :index
      page.should_not have_content('注册')
      page.should have_content('新浪微博登录')
      page.should have_content('豆瓣登录')
    end
  end
end
