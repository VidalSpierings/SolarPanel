//
//  SnapshotStatsCard.swift
//  SolarPanel
//
//  Created by Vidal on 14/05/2024.
//

// See image 'cardscomponents_structure' for visual representation of inheritance structure
// (Documentation.docc/Resources/cardscomponents_structure)

import UIKit
import DGCharts

class SnapshotStatsCard: MyPhoneyCardComponent {
    
    var batteryBarChart: MyBarChart?
    
    var voltageBarChart: MyBarChart?
    
    var currentBarChart: MyBarChart?
    
    var timestampLabel: UILabel?
        
    // initialisers in this class created in accordance with "Initializer Chaining" rules in Swift
    
    private override init(background: UIColor){
                
        super.init(background: background)
    }
        
    /*
    
    - private initialiser, because this initialiser ought only to be called in the convenience initialiser,
      and not when making an instance of this class.
    
    */
    
    convenience init(batteryVoltage: Double, solarPanelVoltage: Double, solarPanelCurrent: Int, timestamp: String) {
                
        self.init(background: UIColor(named: Constants.AppColors.whiteCardColor) ?? .white)
        
        initLayout(batteryVoltage: batteryVoltage, solarPanelVoltage: solarPanelVoltage, solarPanelCurrent: solarPanelCurrent, timestamp: timestamp)
                        
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported from within this class")
    }
    
    private func initLayout(batteryVoltage: Double, solarPanelVoltage: Double, solarPanelCurrent: Int, timestamp: String){
        
        self.backgroundColor = UIColor(named: Constants.AppColors.whiteCardColor)
        
        timestampLabel = topLabel(UILabel(), timestamp)
        
        batteryBarChart = MyBarChart(
            label: UILabel(),
            chart: BarChartView(),
            labelText: "spanning \n (batterij)",
            maxValue: 5,
            measuredValue: batteryVoltage,
            unitOfMeasurement: "Voltage")
        
        voltageBarChart = MyBarChart(
            label: UILabel(),
            chart: BarChartView(),
            labelText: "spanning (zonnepaneel)",
            maxValue: 8.2,
            measuredValue: solarPanelVoltage,
            unitOfMeasurement: "Voltage")
        
        currentBarChart = MyBarChart(
            label: UILabel(),
            chart: BarChartView(),
            labelText: "stroom (zonnepaneel)",
            maxValue: 170,
            measuredValue: Double(solarPanelCurrent),
            unitOfMeasurement: "mA")
        
        // Note: Measured values can only be of the Double type, because this is the only datatype that DGCharts supports for declaring barChart chart values
                
        let graphTextsStackView = UIStackView(arrangedSubviews: [
            batteryBarChart?.label ?? UIView(),
            voltageBarChart?.label ?? UIView(),
            currentBarChart?.label ?? UIView()
        ]
        )
        
        graphTextsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let graphsStackView = UIStackView(arrangedSubviews:[
            batteryBarChart?.chart ?? UIView(),
            voltageBarChart?.chart ?? UIView(),
            currentBarChart?.chart ?? UIView()
        ])
        
        graphsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        graphsStackView.backgroundColor = .green
        
        lazy var nullableBarChart = MyBarChart(
            label: UILabel(),
            chart: BarChartView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)),
            labelText: "",
            maxValue: 0.0,
            measuredValue: 0.0,
            unitOfMeasurement: ""
        )
        
        // nullable barchart type. Declared lazy, so value is not calculated until first called
            
        self.addSubview(timestampLabel ?? UIView())
        self.addSubview(graphsStackView)
        self.addSubview(graphTextsStackView)
        
        applyLayoutConstraints(
            batteryBarChart ?? nullableBarChart,
            voltageBarChart ?? nullableBarChart,
            currentBarChart ?? nullableBarChart,
            timestampLabel ?? UILabel(),
            graphTextsStackView,
            graphsStackView,
            self
        )
                
    }
    
    private func createBarChart(maxValue: Double, measuredValue: Double, unitOfMeasurement: String) -> BarChartView {
        
        let yValues = [BarChartDataEntry(x: 0, y: measuredValue)]
        
        let dataSet = BarChartDataSet(entries: yValues, label: unitOfMeasurement)
        dataSet.colors = [UIColor(named: Constants.AppColors.secondary) ?? .red]
            
        let chartData = BarChartData(dataSet: dataSet)
        chartData.setDrawValues(false)
                        
        let chartView = BarChartView()
        
        chartView.backgroundColor = .white
        chartView.legend.formSize = 0
        chartView.data = chartData
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = maxValue
        chartView.leftAxis.labelTextColor = .black
        chartView.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.minimumFractionDigits = 0
        
        numberFormatter.maximumFractionDigits = 1
                
        chartView.leftAxis.valueFormatter =  DefaultAxisValueFormatter(formatter: numberFormatter)
        
        chartView.leftAxis.setLabelCount(3, force: true)
                
        chartView.animate(yAxisDuration: 0.35)
        
        return chartView
        
    }
    
    //MARK: - Closures for SnapshotStatsCard class
    
    private let topLabel: (UILabel, String) -> UILabel = { label, text in
                            
        label.text = text
        
        label.textColor = UIColor(named: Constants.AppColors.textColorSecondary)
        
        label.textAlignment = .center
                
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private let applyLayoutConstraints: (
        MyBarChart,
        MyBarChart,
        MyBarChart,
        UILabel,
        UIStackView,
        UIStackView,
        MyPhoneyCardComponent) -> () = {
        batteryBarChart,
        voltageBarChart,
        currentBarChart,
        label,
        graphTextsStackView,
        graphsStackView,
        myPhoneyCardComponent in
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: myPhoneyCardComponent.leadingAnchor),
            label.topAnchor.constraint(equalTo: myPhoneyCardComponent.topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: myPhoneyCardComponent.trailingAnchor),
            //constraints for the top label
            
            graphTextsStackView.bottomAnchor.constraint(equalTo: myPhoneyCardComponent.bottomAnchor, constant: -25),
            graphTextsStackView.trailingAnchor.constraint(equalTo: myPhoneyCardComponent.trailingAnchor, constant: -25),
            graphTextsStackView.leadingAnchor.constraint(equalTo: myPhoneyCardComponent.leadingAnchor, constant: 25),
            graphTextsStackView.heightAnchor.constraint(equalToConstant: 40),
            // constraints for stackview that contains the label 'indicators' for the grpahs
            
            batteryBarChart.label.trailingAnchor.constraint(equalTo: voltageBarChart.label.leadingAnchor),
            // constraint(s) for battery percentage label
            
            voltageBarChart.label.widthAnchor.constraint(equalToConstant: 133),
            voltageBarChart.label.trailingAnchor.constraint(equalTo: currentBarChart.label.leadingAnchor),
            voltageBarChart.label.leadingAnchor.constraint(equalTo: batteryBarChart.label.trailingAnchor),
            voltageBarChart.label.centerXAnchor.constraint(equalTo: graphTextsStackView.centerXAnchor),
            // constraints for voltage label
            
            currentBarChart.label.leadingAnchor.constraint(equalTo: voltageBarChart.label.trailingAnchor),
            // constraints for current label
            
            graphsStackView.bottomAnchor.constraint(equalTo: graphTextsStackView.topAnchor, constant: -20),
            graphsStackView.trailingAnchor.constraint(equalTo: myPhoneyCardComponent.trailingAnchor, constant: -25),
            graphsStackView.leadingAnchor.constraint(equalTo: myPhoneyCardComponent.leadingAnchor, constant: 25),
            graphsStackView.heightAnchor.constraint(equalToConstant: 300),
            // constraints for stackview that contains the graphs
            
            batteryBarChart.chart.leadingAnchor.constraint(equalTo: graphsStackView.leadingAnchor),
            batteryBarChart.chart.topAnchor.constraint(equalTo: graphsStackView.topAnchor),
            batteryBarChart.chart.bottomAnchor.constraint(equalTo: graphsStackView.bottomAnchor),
            
            voltageBarChart.chart.centerXAnchor.constraint(equalTo: graphsStackView.centerXAnchor),
            voltageBarChart.chart.widthAnchor.constraint(equalToConstant: 133),
            voltageBarChart.chart.leadingAnchor.constraint(equalTo: batteryBarChart.chart.trailingAnchor),
            voltageBarChart.chart.bottomAnchor.constraint(equalTo: graphsStackView.bottomAnchor),
            voltageBarChart.chart.topAnchor.constraint(equalTo: graphsStackView.topAnchor),
            // voltage barchart constraints

            currentBarChart.chart.trailingAnchor.constraint(equalTo: graphsStackView.trailingAnchor),
            currentBarChart.chart.bottomAnchor.constraint(equalTo: graphsStackView.bottomAnchor),
            currentBarChart.chart.topAnchor.constraint(equalTo: graphsStackView.topAnchor),
            // voltage barchart constraints

            ])
        
    }
    
}

class MyBarChart {
    
    // custom object for BarChart related data and UI-components
    
    var label: UILabel
    var chart: BarChartView
    
    init (label: UILabel,
          chart: BarChartView,
          labelText: String,
          maxValue: Double,
          measuredValue: Double,
          unitOfMeasurement: String) {
        
        self.label = graphLabelIndicator(label, labelText)
        self.chart = barChart(chart, maxValue, measuredValue, unitOfMeasurement)
        
    }
    
}

//MARK: - Closures for MyBarChart class

private let barChart: (BarChartView, Double, Double, String) -> BarChartView = { chart, maxValue, measuredValue, unitOfMeasurement in
    
    let yValues = [BarChartDataEntry(x: 0, y: measuredValue)]
    
    let dataSet = BarChartDataSet(entries: yValues, label: unitOfMeasurement)
    dataSet.colors = [UIColor(named: Constants.AppColors.secondary) ?? .red]
    
    let chartData = BarChartData(dataSet: dataSet)
    chartData.setDrawValues(false)
    
    //let chartView = BarChartView()
    
    chart.translatesAutoresizingMaskIntoConstraints = false
    
    chart.backgroundColor = .white
    chart.legend.formSize = 0
    chart.data = chartData
    chart.rightAxis.enabled = false
    chart.xAxis.enabled = false
    chart.leftAxis.axisMinimum = 0
    chart.leftAxis.axisMaximum = maxValue
    chart.leftAxis.labelTextColor = .black
    chart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
    
    let numberFormatter = NumberFormatter()
    
    numberFormatter.minimumFractionDigits = 0
    
    numberFormatter.maximumFractionDigits = 1
    
    chart.leftAxis.valueFormatter =  DefaultAxisValueFormatter(formatter: numberFormatter)
    
    chart.leftAxis.setLabelCount(3, force: true)
    
    chart.animate(yAxisDuration: 0.35)
    
    return chart
    
}

private let graphLabelIndicator: (UILabel, String) -> UILabel = { label, labelText in
                        
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = labelText
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.numberOfLines = 2
    label.textColor = UIColor(named: Constants.AppColors.textColorSecondary)
    
    return label
}
