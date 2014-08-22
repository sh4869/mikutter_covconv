# -*- coding: utf-8 -*-
require 'net/http'
require 'uri'
require 'rexml/document' 

Plugin.create(:mikutter_covconv) do
  UserConfig[:covconv] = false 

  filter_gui_postbox_post do |gui_postbox|
	if UserConfig[:covconv] == true 
	  text =	Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text
	  response = Net::HTTP.post_form(URI.parse('http://api.ghippos.net/covlang/'),
									 {'ja_JP'=> text})
	  xml = REXML::Document.new(response.body)
	  tweet = xml.elements['covconv/covlang'].text
	  Service.primary.post :message => tweet
	  Plugin.call(:before_postbox_post, tweet)
	  Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text = ''
	  Plugin.filter_cancel!
	end
  end
  settings("けんこふ") do
	boolean('けんこふ語を使用する',:covconv)
  end
end
