user = User.first_or_create(
	email: "admin@admin.com",
	admin: true,
	username: "ADMIN",
	password: ENV['ADMIN_PASSWORD'],
	password_confirmation: ENV['ADMIN_PASSWORD']
)

Post.where(generation: 6).delete_all
[
	'Nine rows of soldiers stood in line.',
    'The beach is dry and shallow at low tide.',
    'The idea is to sew both edges straight.',
    'The kitten chased the dog down the street.',
    'Pages bound in cloth make a book.',
    'Try to trace the fine lines of the painting.',
    'Women form less than half of the group.',
    'The zones merge in the central part of town.',
    'A gem in the rough needs work to polish.',
    'Code is used when secrets are sent.'
].each do |words|
	p words
	post = Post.new(
		words: words,
		generation: 7,
		user_id: user.id,
		css: ''
	)
	post.save(validate: false)
end