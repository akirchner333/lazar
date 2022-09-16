const modal = document.getElementById("modal-background");

if(modal){
	// Close the modal
	modal.addEventListener('click', () => {
		modal.classList.add("hide");
		// Remove all the elements from the list
		document.querySelectorAll('.list-post').forEach(item => item.remove())

		// Remove all the elements from the hidden field
		document.querySelector('#post_plies').setAttribute('values', '');
		document.querySelector('#post_replies').setAttribute('values', '');
	});

	document.querySelector("#post-form").addEventListener('click', (event) => {
		event.stopPropagation()
	});

	// Open the modal by click on the ply and reply buttons
	[
		...document.querySelectorAll(".reply-button"),
		...document.querySelectorAll(".ply-button")
	].forEach((item) => {
		item.addEventListener('click', (event) => {
			openForm(item, true);
		})
	});
}

function openForm(item, ply){
	modal.classList.remove('hide');
	const id = item.parentElement.parentElement.parentElement.getAttribute('data-id');
	const words = item.parentElement.parentElement.querySelector(".words").innerHTML;

	const postItem = document.createElement('li');
	postItem.innerHTML = words;
	postItem.setAttribute('data-id', id)
	postItem.setAttribute('class', 'list-post')

	const list = document.querySelector(ply ? ".plies-list" : ".replies-list");
	list.appendChild(postItem)

	const hiddenField = document.querySelector(ply ? "#post_plies" : "#post_replies")
	const ids = hiddenField.getAttribute('value')
	hiddenField.setAttribute('value', ids + ' ' + id);
}

// Click on list elements to remove them from the post

// Click on different list elements to add them to the post