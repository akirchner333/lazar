document.addEventListener('turbo:load', () => {
	document.querySelectorAll('.posts-carousel').forEach((carousel) => {
		loadCarousel(carousel)
	});
});

document.addEventListener('turbo:frame-render', (event) => {
	event.target.querySelectorAll('.posts-carousel').forEach((carousel) => {
		loadCarousel(carousel)
	});
});

function loadCarousel(carousel){
	const posts = carousel.querySelectorAll('.carousel-post')
	if(posts.length > 0){
		const length = posts.length;
		let index = 0;

		updateActive();

		 carousel.querySelectorAll('.left').forEach(button => {
			button.addEventListener('click', () => {
				index -= 1;
				if(index < 0){
					index = 0
				}
				updateActive();
			});
		});

		carousel.querySelectorAll('.right').forEach(button => {
			button.addEventListener('click', () => {
				index += 1;
				if(index >= length){
					index = length - 1;
				}
				updateActive();
			});
		});

		function updateActive(){
			for(let i = 0; i < carousel.children.length; i++){
				carousel.children[i].classList.remove('carousel-active');
			}
			posts[index].classList.add('carousel-active');
		}
	}
};
