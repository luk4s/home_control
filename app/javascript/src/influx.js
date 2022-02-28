import Chart from 'chart.js/auto';

document.addEventListener('DOMContentLoaded', () => {
  fetch('/home/history.json')
    .then(response => response.json())
    .then(data => {
      const ctx = document.querySelector("#modeHistory");
      if (ctx) {
        window.chart = new Chart(ctx, {
          type: 'line',
          data: {
            datasets: [{
              label: "Power",
              data: data
            }]
          }
        });
      }
    });
});

