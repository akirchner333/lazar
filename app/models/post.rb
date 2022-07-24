class Post < ApplicationRecord
	belongs_to :user
	
	attr_accessor :rotate, :top, :left, :color

	def self.css_create(params)
		style = {}

		style[:rotate] = "#{params["rotate"]}".to_i
		style[:top] = "#{params["top"]}".to_i
		style[:left] = "#{params["left"]}".to_i
		style[:color] = self.colors[params["color"].to_i]

		JSON.generate(style)
	end

	def self.colors
		%w[Transparent Black White Coral Cornsilk ForestGreen MediumSlateBlue Teal]
	end

	def self.new(**args)
		post = super(**args)
		post.rotate = 0
		post.top = 0
		post.left = 0
		post.color = "Transparent"

		post
	end

	def style
		@style ||= JSON.parse(css)
	end

	def style_tag
		<<-STYLE
			transform: rotate(#{style["rotate"] || 0}deg);
			top: #{style["top"] || 0}px;
			left: #{style["left"] || 0}px;
			background-color: #{style["color"] || 'transparent'};
		STYLE
	end

	def aria_label
		attributes = []
		attributes.push("is rotated #{style["rotate"]} degrees") if style["rotate"] != 0

		offset = []
		if style['left'] != 0
			offset.push("#{style["left"].abs} pixels #{style["left"] > 0 ? 'right' : 'left'}")
		end
		if style['top'] != 0
			offset.push("#{style["top"].abs} pixels #{style["top"] > 0 ? 'down' : 'up'}")
		end
		attributes.push("is offset by #{offset.to_sentence}") if offset.length > 0

		attributes.push("has a #{style["color"].titleize.downcase} background")

		"This post #{attributes.to_sentence}."
	end
end
