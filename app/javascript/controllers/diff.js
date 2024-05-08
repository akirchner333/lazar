function textDiff(a, b)
{
	const aLng = a.length;
	const bLng = b.length;

	function editGraph(){
		// v maps k values to x values
		// it answers the question: what is the highest x value we have
		// gotten to for this k value?
		const v = {1: 0};
		const trace = [];
		for(var depth = 0; depth <= (aLng + bLng); depth++){
			trace.push({...v});
			for(var k = -depth; k <= depth; k += 2){
				// This bit here contains out preference for deletion over
				// insertion
				// Most of the time, move rightward
				let x = v[k-1] + 1;
				
				// I still don't /fully/ understand the conditions under which
				// we move downward.
				// if k = -depth, then k-1 doesn't exist yet
				// cause we just started this sweep
				// If k = depth, then k + 1 doesn't exist (too big)
				// And then if v[k-1] > v[k+1]... something about a better path
				if(k === -depth || (k != depth && v[k - 1] < v[k + 1])){
					// Move downward
					x = v[k + 1];
				}

				let y = x - k;

				// Slide down the diagonal
				while(x < aLng && y < bLng && a[x] === b[y]){
					x++;
					y++;
				}
				v[k] = x;

				// We've hit the end
				if(x >= aLng && y >= bLng){
					return trace;
				}
			}
		}
	}

	function backtrack(trace){
		let x = aLng;
		let y = bLng;
		const steps = [];
		for(var depth = trace.length -1; depth >= 0; depth--){
			const v = trace[depth];
			const k = x - y;
			let prev_k = k - 1
			if(k == -depth || (k != depth && v[k-1] < v[k+1])){
				prev_k = k + 1;
			}

			const prev_x = v[prev_k]
			const prev_y = prev_x - prev_k
			while(x > prev_x && y > prev_y){
				x--;
				y--;
			}

			if(depth > 0){
				steps.push([prev_x === x ? 'insert' : 'delete', prev_x, prev_y]);
			}

			x = prev_x;
			y = prev_y;
		}
		return steps.reverse();
	}

	// Can I combine buildDiff and compress?
	function buildDiff(steps){
		let newText = [
			...a.split('').map((c, i) => ({char: c, index: i, source: 'a'})),
			{char: '', index: a.length, source: 'a'}
		];

		for(var i = 0; i < steps.length; i++){
			const [instruction, x, y] = steps[i];
			let index = newText.findIndex(c => {
				return c.index == x && c.source == 'a'
			});

			if(instruction == 'insert'){
				newText = [
					...newText.slice(0, index),
					{char: b[y], index: y, source: 'b', insert: true},
					...newText.slice(index)
				];
			}else{
				newText[index].delete = true;
			}
		}

		return newText;
	}

	const graph = editGraph();
	const editSteps = backtrack(graph);
	const diff = buildDiff(editSteps);
	return compress(diff);
}

function compress(steps){
	return steps.reduce((acc, c) => {
		if(acc.length == 0){
			return [c];
		}
		else
		{
			const prev = acc[acc.length - 1];
			if(
				prev.source === c.source &&
				prev.delete == c.delete &&
				prev.insert == c.insert
			){
				acc[acc.length - 1].char += c.char;
			}else{
				acc.push(c);
			}
			return acc;
		}
	}, []);
}