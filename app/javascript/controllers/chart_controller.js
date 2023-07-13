import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Create a new property on the class to store the charts
    this.charts = {};
    // Get all the chart elements
    const chartElements = this.element.querySelectorAll("div[data-chartkick-chart]");

    chartElements.forEach((chartElement) => {
      // Get the chart data for this chart
      const chartData = JSON.parse(chartElement.dataset.chartData);

      chartElement.style.height = "400px"; // Optional: Set the desired height of the chart container

      // Store the chart in the charts property, using the chart's ID as the key
      this.charts[chartElement.id] = Chartkick.createChart(chartElement, chartData);
    });

    this.subscription = App.cable.subscriptions.create("TransactionsChannel", {
      received: (data) => {
        this.updateChart(data);
      },
    });
  }

  disconnect() {
    this.subscription.unsubscribe();
  }

  updateChart(data) {
    // Use the chart's ID that comes with the data to find the correct chart
    const chart = this.charts[data.chartId];
    if (chart) {
      chart.updateData([data.newData]);
    }
  }
}

