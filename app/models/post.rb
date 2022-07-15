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
		post.rotate = 
		post.top = 0
		post.left = 0
		post.color = "Transparent"

		post
	end

	def style
		style_hash = JSON.parse(css)
		<<-STYLE
			transform: rotate(#{style_hash["rotate"] || 0}deg);
			top: #{style_hash["top"] || 0}px;
			left: #{style_hash["left"] || 0}px;
			background-color: #{style_hash["color"] || 'transparent'};
		STYLE
	end
end
