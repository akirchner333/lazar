
document.addEventListener('turbo:load', () => {
	const modal = document.getElementById("modal-background");
	let plies = [];
	let replies = [];

	if(modal){
		modal.addEventListener('click', (event) => {
			if(event.target.getAttribute('id') === 'modal-background'){
				closeForm();
			}
		});

		[
			...document.querySelectorAll(".reply-button"),
			...document.querySelectorAll(".ply-button")
		].forEach((item) => {
			item.addEventListener('click', (event) => {
				openForm(item);
			})
		});

		document.querySelector("#likes").addEventListener('turbo:frame-load', (event) => {
			document.querySelectorAll("#likes .add-post").forEach((item) => {
				item.addEventListener('click', (event) => {
					addPost(item)
				})

				const id = item.getAttribute('data-id');
				if(plies.includes(id) || replies.includes(id)){
					item.parentElement.parentElement.classList.add('selected');
				}
			});
		});
	}

	function closeForm(){
		modal.classList.add("hide");
		document.querySelectorAll('.list-post').forEach(item => item.remove())

		plies = [];
		replies = [];
		setResponses();
		document.querySelector('#likes').innerHTML = "";
	}

	function openForm(item){
		modal.classList.remove('hide');
		addPost(item);
	}

	function addPost(item){
		const ply = !item.getAttribute('class').includes('reply-button')
		const responses = getResponses(ply)
		const id = item.getAttribute('data-id');

		if(!responses.includes(id)){
			if(ply){
				plies = [...plies, id]
			}else{
				replies = [...replies, id]
			}
			setResponses(	);
			item.parentElement.parentElement.classList.add('selected');

			const words = item.parentElement.parentElement.querySelector(".words").innerHTML;

			const postItem = document.createElement('li');
			postItem.innerHTML = words;
			postItem.setAttribute('data-id', id)
			postItem.setAttribute('class', 'list-post')
			
			const list = document.querySelector(ply ? ".plies-list" : ".replies-list");
			list.appendChild(postItem)

			postItem.addEventListener('click', () => {
				removePost(id, postItem, ply, item.parentElement.parentElement);
			});
		}
	}

	function removePost(id, item, ply, parent){
		item.remove();
		if(ply){
			const index = plies.indexOf(id);
			plies.splice(index, 1);
		}else{
			const index = replies.indexOf(id);
			replies.splice(index, 1);
		}
		setResponses();

		parent.classList.remove('selected')
	}

	function getResponses(ply){
		return ply ? plies : replies;
	}

	function setResponses(){
		document.querySelector("#post_plies").setAttribute('value', plies.join(' '));
		document.querySelector("#post_replies").setAttribute('value', replies.join(' '));
	}
});