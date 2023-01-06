const min = document.querySelector('#min');
const max = document.querySelector('#max');
const span = document.querySelector('#val');
const slide = document.querySelector('#slide');
const button = document.querySelector('#limitButton');

displayValue.call(slide, {});

function displayValue (e) {
  const inp = e.target || this;
  const value = +inp.value;
  const min = inp.min;
  const max = inp.max;
  const width = inp.offsetWidth;
  const offset = -20;
  const percent = (value - min) / (max - min);
  const pos = percent * (width + offset) - 40;
  span.style.left = `${pos}px`;
  span.innerHTML = value;
}

function changeLimits () {
  const minVal = +min.value;
  const maxVal = +max.value;
  const value = Math.floor((maxVal - minVal) * (Math.random()*(0.8-0.2) + 0.2) + minVal);
  slide.setAttribute('min', minVal);
  slide.setAttribute('max', maxVal);
  slide.setAttribute('value', value);
  displayValue.call(slide, {});
}

function checkPostiveInteger (e) {
  let c = e.keyCode;
  if ((c < 37 && c != 8 && c != 9) || (c > 40 && c < 48 && c != 46) || (c > 57 && c < 96) || (c > 105 && c != 109 && c != 189)) {
    e.preventDefault();
  }
  if (c === 13 && checkValidLimits()) {
    changeLimits();
  }
}

function checkValidLimits () {
  return (!min.value || !max.value || +max.value <= +min.value) ? (button.disabled = true, false) : (button.disabled = false, true);
}
