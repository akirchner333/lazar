# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

Post.where(generation: 6).delete_all

previous = false
start = DateTime.now
CSV.foreach('./db/macbeth.csv', headers: true) do |line|
	character = User.find_or_initialize_by(
		username: line['character'],
		email: "#{line['character'].downcase.gsub(" ", "_")}@macbeth.com"
	)
	if character.has_changes_to_save?
		character.password = "#{line[:character]}_4bx9s"
		character.password_confirmation = "#{line[:character]}_4bx9s"
		character.save
	end

	post = Post.create(
		words: line['line'],
		user_id: character.id,
		generation: 6,
		created_at: start + 10 * line['num'].to_i,
		css: ""
	)
	if previous
		previous.replies << post
	end
	previous = post
end