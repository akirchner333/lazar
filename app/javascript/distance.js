// Taken whole cloth from https://github.com/gustf/js-levenshtein
// Copyright (c) 2017 Gustaf Andersson

function _min(d0, d1, d2, bx, ay){
  return d0 < d1 || d2 < d1
      ? d0 > d2
          ? d2 + 1
          : d0 + 1
      : bx === ay
          ? d1
          : d1 + 1;
}

export default function distance(a, b){
  // If they're the same, return 0, obv
  if (a === b) {
    return 0;
  }

  // b is always longer than a
  if (a.length > b.length) {
    var tmp = a;
    a = b;
    b = tmp;
  }

  var la = a.length;
  var lb = b.length;

  // Remove any identical elements at the end of the string
  // So abba vs coba, we treat the lengths like 2 and 2
  // since the last two characters are the same
  while (la > 0 && (a.charCodeAt(la - 1) === b.charCodeAt(lb - 1))) {
    la--;
    lb--;
  }

  var offset = 0;

  // Same, only going from the front
  while (offset < la && (a.charCodeAt(offset) === b.charCodeAt(offset))) {
    offset++;
  }

  la -= offset;
  lb -= offset;

  // la can't be more than lb
  // So if lb = 0, then la must = 0
  // if lb = 1, then la must = 1, so the edit distance is 1 (change that char)
  // if lb = 2, then la may be 1 or 2, but the edit distance is still 2
  // Only when lb >= 3 do we run into complications
  // Specifically, some middle characters might be the same
  if (la === 0 || lb < 3) {
    return lb;
  }

  // Now we have two strings, that start with a different character
  // and end with a different character
  // b is longer than or equal to a in length

  var x = 0;
  var y;
  var d0;
  var d1;
  var d2;
  var d3;
  var dd;
  var dy;
  var ay;
  var bx0;
  var bx1;
  var bx2;
  var bx3;

  var vector = [];

  for (y = 0; y < la; y++) {
    vector.push(y + 1);
    vector.push(a.charCodeAt(offset + y));
  }
  // So for a = cbabac, b = abcabba vector would be
  // [1, c, 2, b, 3, a, etc...]
  // I don't know why is necessary - couldn't index do the same thing?

  var len = vector.length - 1;

  // Why is this using weird four loops instead of while loops here?
  for (; x < lb - 3;) {
    bx0 = b.charCodeAt(offset + (d0 = x));
    bx1 = b.charCodeAt(offset + (d1 = x + 1));
    bx2 = b.charCodeAt(offset + (d2 = x + 2));
    bx3 = b.charCodeAt(offset + (d3 = x + 3));
    // First the first chunk, bx0 = a, bx1 = b, bx2 = c, bx3 = a
    dd = (x += 4);
    for (y = 0; y < len; y += 2) {
      dy = vector[y];
      ay = vector[y + 1];
      d0 = _min(dy, d0, d1, bx0, ay);
      d1 = _min(d0, d1, d2, bx1, ay);
      d2 = _min(d1, d2, d3, bx2, ay);
      dd = _min(d2, d3, dd, bx3, ay);
      vector[y] = dd;
      d3 = d2;
      d2 = d1;
      d1 = d0;
      d0 = dy;
    }
  }

  for (; x < lb;) {
    bx0 = b.charCodeAt(offset + (d0 = x));
    dd = ++x;
    for (y = 0; y < len; y += 2) {
      dy = vector[y];
      vector[y] = dd = _min(dy, d0, dd, bx0, vector[y + 1]);
      d0 = dy;
    }
  }

  return dd;
};