import distance from 'distance';

document.addEventListener('turbo:load', () => {
	const modal = document.getElementById("modal-background");
	var rootWords = '';

	if(modal){
		const elements = {
			form: document.querySelector('#modal-post-form'),
			textArea: document.querySelector('#post_words'),
			distanceSpan: document.querySelector('#distance'),
			distanceDiv: document.querySelector('#distance').parentNode,
			resetButton: document.querySelector('#reset-button'),
			submitButton: document.querySelector('#submit-button')
		};

		// Closes the modal when you click outside it.
		modal.addEventListener('click', (event) => {
			if(event.target.getAttribute('id') === 'modal-background'){
				closeForm();
			}
		});

		// Adds the event listeners to all the buttons on all the reply buttons
		enableButtons(document);
		document.addEventListener('turbo:frame-render', (event) => {
			enableButtons(event.target);
		});

		elements.textArea.addEventListener('input', (event) => {
			updateFromDistance();
		});

		// TODO: Set up the reset button
		elements.resetButton.addEventListener('click', (event) => {
			event.preventDefault();
			event.stopPropagation();
			setForm(rootWords);
			updateFromDistance();
			return false;
		});

		function updateFromDistance(){
			const currentWords = elements.textArea.value;
			const dist = distance(currentWords, rootWords);

			elements.distanceSpan.innerHTML = dist;
			if(dist > 15){
				elements.distanceDiv.classList.add('red');
				elements.form.disabled = true;
				elements.submitButton.disabled = true;
			} else {
				elements.distanceDiv.classList.remove('red');
				elements.form.disabled = false;
				elements.submitButton.disabled = false;
			}
		}

		function setForm(value){
			elements.textArea.innerHTML = value;
			elements.textArea.value = value;
		}

		function enableButtons(target){
			target.querySelectorAll(".reply-button").forEach((item) => {
				item.addEventListener('click', (event) => {
					openForm(item);
				})
			});
		}

		function closeForm(){
			modal.classList.add("hide");
			setForm('');
		}

		function openForm(item){
			modal.classList.remove('hide');

			rootWords = item.parentElement.parentElement
				.querySelector(".words").innerHTML
				.trim();
			document.querySelector('#original-text').innerHTML = rootWords;
			setForm(rootWords);
			const id = item.getAttribute('data-id');
			document.querySelector('#post_parent').setAttribute('value', id);
			updateFromDistance();
		}
	}
});