# -*- coding: utf-8 -*-
require 'net/http'
require 'uri'
require 'rexml/document' 

Plugin.create(:mikutter_covconv) do
  UserConfig[:covconv] ||= false 

  settings("けんこふ") do
	boolean('けんこふ語を使用する',:covconv)
  end

  filter_gui_postbox_post do |gui_postbox|
	text =	Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text
	if UserConfig[:covconv] == true 
	  response = Net::HTTP.post_form(URI.parse('http://api.ghippos.net/covlang/'),
									 {'ja_JP'=> text})
	  xml = REXML::Document.new(response.body)
	  tweet = xml.elements['covconv/covlang'].text
	  text = tweet
	end
	Service.primary.update(message: text)
	Plugin.create(:gtk).widgetof(gui_postbox).widget_post.buffer.text = ''
	Plugin.filter_cancel!
  end

end

