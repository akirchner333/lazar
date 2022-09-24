document.addEventListener('turbo:load', () => {
	document.querySelectorAll('.posts-carousel').forEach((carousel) => {
		const posts = carousel.querySelectorAll('.carousel-post')
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
			carousel.querySelector('.carousel-active')?.classList?.remove('carousel-active');
			posts[index].classList.add('carousel-active');
		}
	});
});