import distance from 'distance';
import textDiff from 'diff';

document.addEventListener('turbo:load', () => runPostForm());
document.addEventListener('turbo:render', () => runPostForm());

function runPostForm(){
	const form = document.getElementById("new-post");

	if(form){
		const elements = {
			form: document.querySelector('#post-form'),
			textArea: document.querySelector('#post_words'),
			distanceSpan: document.querySelector('#distance'),
			distanceDiv: document.querySelector('#distance').parentNode,
			resetButton: document.querySelector('#reset-button'),
			submitButton: document.querySelector('#submit-button'),
			originalText: document.querySelector('#original-text')
		};

		let rootWords = elements.originalText.innerHTML;

		setDiff();

		elements.textArea.addEventListener('input', (event) => setDiff());

		elements.resetButton.addEventListener('click', (event) => {
			event.preventDefault();
			event.stopPropagation();
			setForm(rootWords);
			updateFromDistance();
			elements.originalText.innerHTML = rootWords;
			return false;
		});

		function setDiff(){
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
		}

		function updateFromDistance(){
			const currentWords = elements.textArea.value;
			const dist = distance(currentWords, rootWords);

			elements.distanceSpan.innerHTML = dist;
			if(dist > 15){
				elements.distanceDiv.classList.add('red');
				elements.form.disabled = true;
				elements.submitButton.disabled = true;
			} else if(dist <= 0){
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
	}
}