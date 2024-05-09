import distance from 'distance';
import textDiff from 'diff';

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
			submitButton: document.querySelector('#submit-button'),
			originalText: document.querySelector('#original-text')
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
			var text = elements.textArea.value;
			var dif = textDiff(rootWords, text);
			elements.originalText.innerHTML = "";
			dif.forEach(c => {
				const div = document.createElement('div')
				div.textContent = c.char;
				div.classList.add('char');
				if(c.char == ' '){
					div.classList.add('space');
				}
				if(c.delete){
					div.classList.add('delete')
				}
				if(c.insert){
					div.classList.add('insert')
				}
				elements.originalText.appendChild(div);
			});
		});

		elements.resetButton.addEventListener('click', (event) => {
			event.preventDefault();
			event.stopPropagation();
			setForm(rootWords);
			updateFromDistance();
			elements.originalText.innerHTML = rootWords;
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

			rootWords = item.closest(".post")
				.querySelector(".words").innerHTML
				.trim();
			elements.originalText.innerHTML = rootWords;
			setForm(rootWords);
			const id = item.getAttribute('data-id');
			document.querySelector('#post_parent').setAttribute('value', id);
			updateFromDistance();
		}
	}
});