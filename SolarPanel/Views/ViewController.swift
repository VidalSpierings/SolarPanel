//
//  ViewController.swift
//  SolarPanel
//
//  Created by Vidal on 02/05/2024.
//

import UIKit
import Cards
import DGCharts

class ViewController: UIViewController {
        
        private var card: FoldOutCard? = nil
        
        private var snapshotsCard: SnapshotsCard!
    
        private var snapshotStatsCard: SnapshotStatsCard!
    
        private var dataSnapshots: [DataSnapshots]?
    
        private var myWebSocket: MyWebSocket?
    
        private var voltageBatteryCard: BatteryCard!
        private var voltageSolarPanelCard: VoltageCard!
        private var currentSolarPanelCard: CurrentCard!
    
        // Variables are made forced unwrapped: Not doing this, will result in the build process expierencing stack overflow (In a real project, I would not use UIKit programmatically like this. I just want to demonstrate that I know how to make programmatic UIKit, function)
    
        var viewModel: MyViewModel? = nil
    
        override func viewDidLoad() {
            super.viewDidLoad()
                    
            do {
                
                try viewModel = MyViewModel()
                
                viewModel?.myViewModelDelegate = self
                
            } catch {
                
                let alert = UIAlertController(title: "Interne fout", message: "Er heeft zich een interne fout voorgedaan. De app functioneert mogelijk niet zoals verwacht", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
                                                    
                print("unable to retrieve datasnapshots")
                
            }
                    
            do {
                
                try dataSnapshots = viewModel?.getDataSnapshots()
                                
                card = FoldOutCard(onCardTapped: MyGestureRecognizer(action: {
                    
                    try? FoldingCommand().activate(foldingCommand: Constants.Repository.SubmitToAPI.unfold)
                    
                }))
                            
            } catch {
                
                let alert = UIAlertController(title: "Geen momentopnames", message: "Momentopnames konden niet worden opgehaald", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
                                                    
                print("unable to retrieve datasnapshots")
                
            }
            
            //MARK: - SECTION DIVIDER
            
            let liveDataLabel = createSectionLabel("Live gegevens")
            
            // MARK: - Live data label
            
            let historicDataLabel = createSectionLabel("Historische gegevens")
            
            // MARK: - Live data label
                    
            let liveDataSectionDivider = createSectionDivider()
            
            // MARK: - Live data divider
            
            let historicalDataSectionDivider = createSectionDivider()
            
            // MARK: - Historical data divider
                    
            let foldInCard = FoldInCard(onCardTapped: MyGestureRecognizer(action: {
                
                do {
                    
                    try VouwConfiguratie().sendFoldingState(command: Constants.Repository.SubmitToAPI.fold)
                    
                    self.showLoadingProgressScreen(submittedFoldingState: Constants.Repository.SubmitToAPI.fold)
                    
                } catch {
                    
                    let alert = UIAlertController(title: "Kan commando niet versturen", message: "Er heeft zich een onbekende fout voorgedaan. Het commando kon niet verstuurt worden", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                    
                }
                            
            }))
            
            // MARK: - Fold in card
                            
            let foldOutCard = FoldOutCard(onCardTapped: MyGestureRecognizer(action: {
                
                do {
                    
                    try VouwConfiguratie().sendFoldingState(command: Constants.Repository.SubmitToAPI.unfold)
                    
                    self.showLoadingProgressScreen(submittedFoldingState: Constants.Repository.SubmitToAPI.unfold)
                    
                } catch {
                    
                    let alert = UIAlertController(title: "Kan commando niet versturen", message: "Er heeft zich een onbekende fout voorgedaan. Het commando kon niet verstuurt worden", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                    
                }
                            
            }))
            
            // MARK: - Fold out card
                                                
            voltageBatteryCard = BatteryCard(amount: String(format: "%d Volt", 0))
            
            // MARK: - Battery voltage card
                                                
            voltageSolarPanelCard = VoltageCard(amount: String(format: "%.1f Volt", 0))
            
            // MARK: - Solar panel voltage card
                                                
            currentSolarPanelCard = CurrentCard(amount: String(format: "%d mA", 0))
            
            // MARK: - Solar panel current card
                            
            let refreshHistoryCard = RefreshHistoryCard(onCardTapped: MyGestureRecognizer(action: {
                
                do {
                                               
                    try self.snapshotsCard.myTableView?.list = self.viewModel?.getDataSnapshots()
                                   
                    self.snapshotsCard.myTableView?.reloadData()
                                           
                   // update the list that contains the source text for all tableView items, then reload the tableView
                       
                   } catch {
                       
                       let alert = UIAlertController(title: "JSON fout", message: "Kon JSON niet decoderen", preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alert, animated: true)
                                                                           
                       print("error:\(error)")
                       
                   }
            }))
            
            // MARK: - Refresh history card

            let aaadImage = UIImageView(image: UIImage(named: "Logo"))
            
            // MARK: - AAADLander logo image
                                            
            snapshotsCard = try? SnapshotsCard(list: dataSnapshots ?? [DataSnapshots()])
        
            snapshotsCard.myTableView?.snapshotsCardDelegate = self
            
            // MARK: - Snapshots card
            
            snapshotStatsCard = SnapshotStatsCard(batteryVoltage: 0.0, solarPanelVoltage: 0.0, solarPanelCurrent: 0, timestamp: "(Geen selectie)")
            
            // MARK: - Snapshots stats card
            
            foldInCard.translatesAutoresizingMaskIntoConstraints = false
            foldOutCard.translatesAutoresizingMaskIntoConstraints = false
            voltageBatteryCard.translatesAutoresizingMaskIntoConstraints = false
            voltageSolarPanelCard.translatesAutoresizingMaskIntoConstraints = false
            currentSolarPanelCard.translatesAutoresizingMaskIntoConstraints = false
            refreshHistoryCard.translatesAutoresizingMaskIntoConstraints = false
            aaadImage.translatesAutoresizingMaskIntoConstraints = false
            snapshotsCard.translatesAutoresizingMaskIntoConstraints = false
            snapshotStatsCard.translatesAutoresizingMaskIntoConstraints = false
                            
            view.addSubview(liveDataLabel)
            view.addSubview(historicDataLabel)
            view.addSubview(liveDataSectionDivider)
            view.addSubview(historicalDataSectionDivider)
            view.addSubview(foldInCard)
            view.addSubview(foldOutCard)
            view.addSubview(voltageBatteryCard)
            view.addSubview(voltageSolarPanelCard)
            view.addSubview(currentSolarPanelCard)
            view.addSubview(refreshHistoryCard)
            view.addSubview(aaadImage)
            view.addSubview(snapshotStatsCard)
            view.addSubview(snapshotsCard)
            
            NSLayoutConstraint.activate([
                                
                aaadImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -85),
                aaadImage.bottomAnchor.constraint(equalTo: snapshotsCard.bottomAnchor),
                aaadImage.heightAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.SmallCard.height)),
                //aaadImage.widthAnchor.constraint(equalToConstant: CGFloat(Constants.Dimensions.SmallCard.width)),
                
                liveDataLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                liveDataLabel.leadingAnchor.constraint(equalTo: liveDataSectionDivider.leadingAnchor),
                liveDataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                liveDataLabel.heightAnchor.constraint(equalToConstant: 27),
                
                liveDataSectionDivider.topAnchor.constraint(equalTo: liveDataLabel.bottomAnchor, constant: 4),
                liveDataSectionDivider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                liveDataSectionDivider.centerXAnchor.constraint(equalTo: voltageBatteryCard.centerXAnchor),
                liveDataSectionDivider.trailingAnchor.constraint(equalTo: historicalDataSectionDivider.trailingAnchor),
                liveDataSectionDivider.leadingAnchor.constraint(equalTo: historicDataLabel.leadingAnchor),
                
                foldInCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -763),
                foldInCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
                foldInCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 77),
                foldInCard.topAnchor.constraint(equalTo: liveDataSectionDivider.bottomAnchor, constant: 31),
                //foldInCard.trailingAnchor.constraint(equalTo: snapshotsCard.trailingAnchor),
                foldInCard.leadingAnchor.constraint(equalTo: historicDataLabel.leadingAnchor),
                foldInCard.bottomAnchor.constraint(equalTo: foldOutCard.bottomAnchor),
                foldInCard.topAnchor.constraint(equalTo: foldOutCard.topAnchor),
                
                foldOutCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -960),
                foldOutCard.leadingAnchor.constraint(equalTo: foldInCard.trailingAnchor, constant: 65),
                foldOutCard.topAnchor.constraint(equalTo: voltageBatteryCard.topAnchor),

                historicDataLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 422),
                historicDataLabel.leadingAnchor.constraint(equalTo: historicalDataSectionDivider.leadingAnchor),
                historicDataLabel.heightAnchor.constraint(equalToConstant: 27),

                historicalDataSectionDivider.topAnchor.constraint(equalTo: voltageBatteryCard.bottomAnchor, constant: 91),
                historicalDataSectionDivider.topAnchor.constraint(equalTo: historicDataLabel.bottomAnchor, constant: 8),
                
                refreshHistoryCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -362),
                refreshHistoryCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 489),
                refreshHistoryCard.topAnchor.constraint(equalTo: historicalDataSectionDivider.bottomAnchor, constant: 30),
                refreshHistoryCard.trailingAnchor.constraint(equalTo: aaadImage.trailingAnchor),
                refreshHistoryCard.leadingAnchor.constraint(equalTo: aaadImage.leadingAnchor),
                refreshHistoryCard.topAnchor.constraint(equalTo: snapshotsCard.topAnchor),
                
                voltageBatteryCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 597),
                voltageBatteryCard.bottomAnchor.constraint(equalTo: voltageSolarPanelCard.bottomAnchor),
                voltageBatteryCard.topAnchor.constraint(equalTo: voltageSolarPanelCard.topAnchor),
                
                snapshotsCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 358),
                snapshotsCard.bottomAnchor.constraint(equalTo: aaadImage.bottomAnchor),
                snapshotsCard.topAnchor.constraint(equalTo: snapshotStatsCard.topAnchor),
                
                voltageSolarPanelCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -308),
                voltageSolarPanelCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 886),
                voltageSolarPanelCard.leadingAnchor.constraint(equalTo: snapshotStatsCard.leadingAnchor),
                voltageSolarPanelCard.bottomAnchor.constraint(equalTo: currentSolarPanelCard.bottomAnchor),
                voltageSolarPanelCard.topAnchor.constraint(equalTo: currentSolarPanelCard.topAnchor),

                snapshotStatsCard.leadingAnchor.constraint(equalTo: snapshotsCard.leadingAnchor, constant: 78),
                snapshotStatsCard.topAnchor.constraint(equalTo: snapshotsCard.topAnchor),
                snapshotStatsCard.bottomAnchor.constraint(equalTo: aaadImage.bottomAnchor),
                //snapshotStatsCard.leadingAnchor.constraint(equalTo: currentSolarPanelCard.leadingAnchor),
                
                currentSolarPanelCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1164),
                currentSolarPanelCard.trailingAnchor.constraint(equalTo: snapshotStatsCard.trailingAnchor)
                                            
            ])
            
            // layout every single constraint for the UI-components on the screen
                            
        }
        
        #if DEBUG
        private func loadSimulatedJson() -> Zonnepaneel {
            if let url = Bundle.main.url(forResource: "testjson", withExtension: "json") {
                do {
                    return try JSONDecoder().decode(Zonnepaneel.self, from: Data(contentsOf: url))
                    // attempt to decode the testing json file, which can be used at times when the server cannot be accessed
                } catch {
                    
                    let alert = UIAlertController(title: "JSON error", message: "Kon JSON niet decoderen", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                                                                        
                    print("error:\(error)")
                }
            } else {
                
                print("it failed")
                
            }
            
            return Zonnepaneel(
                stroom_zonnepaneel: 0,
                spanning_zonnepaneel: 0,
                spanning_batterij: 0,
                positie: 0,
                timestamp: "1970-01-01T00:00:00Z"
            )
        }
        #endif
        
        private func createAAADImage(){
            
            
            
        }
        
        // MARK: WebSocket reading
        // https://stackoverflow.com/questions/35963128/swift-understanding-mark
        
        override func viewDidAppear(_ animated: Bool) {
            
            do {
                
                myWebSocket = MyWebSocket()
                
                myWebSocket?.myWebSocketDelegate = self
                
                try myWebSocket?.activate()
                
            } catch {
                
                let alert = UIAlertController(title: "Geen verbinding", message: "Kon niet verbinden met satteliet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
                                                                    
                print("connection with sattelite could not be made")
                                
            }
                                    
        }
        
        private func createSectionLabel(_ labelText: String) -> UILabel {
            
            let label = UILabel()
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.text = labelText
            
            label.textColor = UIColor(named: Constants.AppColors.textColorPrimary)
            
            label.font = UIFont.boldSystemFont(ofSize: 22)
            
            return label
            
        }
        
        private func createSectionDivider() -> UIView {
            
            let liveDataSectionDivider = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 2))
            
            liveDataSectionDivider.backgroundColor = UIColor(named: Constants.AppColors.iconColorPrimary)
            
            liveDataSectionDivider.translatesAutoresizingMaskIntoConstraints = false
            
            return liveDataSectionDivider
            
        }
    
    private func showLoadingProgressScreen(submittedFoldingState: String) {
        
        var loadingScreenFoldingStateText: String?
        
        switch submittedFoldingState {
            
        case Constants.Repository.SubmitToAPI.fold:
            loadingScreenFoldingStateText = "Inklappen"
            
        case Constants.Repository.SubmitToAPI.unfold:
            loadingScreenFoldingStateText = "Uitklappen"
            
        default:
            loadingScreenFoldingStateText = "Beweging"
        }
        
        /*
        
        - Decide whether loading screen will be shown for user request to fold or to unfold the solar panel,
          then change the loading screen text accordingly
        
        */
        
        let alertController =
        UIAlertController(title: "", message: String(format: "\(loadingScreenFoldingStateText ?? "Beweging"): %.0f%%", 0.0), preferredStyle: .alert)
        
        /*
        
        - show alert Controller, which informs the user whether the solar panel is being folded out or in,
          together with the completion percentage. The initial progress value is (of course) 0
        
        */
        
        let progressView = UIProgressView(progressViewStyle: .default)
                
        var loadingProgress: Float = 0.0
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
        
            loadingProgress += 0.036363664
            
            alertController.message = String(format: "\(loadingScreenFoldingStateText ?? "Beweging"): %.0f%%", loadingProgress * 100)
            
            progressView.progress = loadingProgress
            
            // progressView.progress = 0.0 |Empty progress view| progressVew.progress = 1.0 |Full progress view|
            
            if loadingProgress >= 1.0 {
                
                timer.invalidate()
                
                alertController.message = "\(loadingScreenFoldingStateText ?? "Beweging"): Voltooid"
                                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    
                    alertController.dismiss(animated: true)
                    
                }
                
            }
            
            #if DEBUG
            print("Progress (complete = 1.0): \(loadingProgress )")
            #endif
            
        })
        
        progressView.progressTintColor = UIColor(named: Constants.AppColors.secondary)
        progressView.trackTintColor = UIColor(named: Constants.AppColors.tertiary)
                
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        alertController.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            
            progressView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
            progressView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20),
            progressView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -10)
            
            // pin progressview to bottom of screen (with respect to margins)
        
        ])
                
        self.present(alertController, animated: true)
                        
    }
    
    private func hideLoadingScreen(loadingProgressScreen: UIAlertController){
        
        DispatchQueue.main.async {
            
            loadingProgressScreen.dismiss(animated: true)
            
        }
        
    }

    }

extension ViewController: MyViewModelDelegate, MyWebSocketDelegate, SnapshotsCardDelegate {
    
    func didFinishDataSubmission() {
        
    }
    
    
    
    
    func didSelectCell(solarPanel: Zonnepaneel) {
        
        DispatchQueue.global(qos: .background).async {
            
            let voltageBatteryNewValue = [BarChartDataEntry(x: 0, y: solarPanel.spanning_batterij)]
            
            let voltageBatteryNewDataSet = BarChartDataSet(entries: voltageBatteryNewValue, label: "Voltage")
            voltageBatteryNewDataSet.colors = [UIColor(named: Constants.AppColors.secondary) ?? .red]
            
            let voltageBatteryChartData = BarChartData(dataSet: voltageBatteryNewDataSet)
            voltageBatteryChartData.setDrawValues(false)
                            
            // MARK: - codes for battery voltage
            
            let voltageSolarPanelNewValue = [BarChartDataEntry(x: 0, y: solarPanel.spanning_zonnepaneel)]
            
            let voltageSolarPanelNewDataSet = BarChartDataSet(entries: voltageSolarPanelNewValue, label: "Voltage")
            voltageSolarPanelNewDataSet.colors = [UIColor(named: Constants.AppColors.secondary) ?? .red]
            
            let voltageSolarPanelChartData = BarChartData(dataSet: voltageSolarPanelNewDataSet)
            voltageSolarPanelChartData.setDrawValues(false)
                            
            // MARK: - codes for solar panel voltage
        
            let currentSolarPanelNewValue = [BarChartDataEntry(x: 0, y: Double(solarPanel.stroom_zonnepaneel))]
            
            let currentSolarPanelNewDataSet = BarChartDataSet(entries: currentSolarPanelNewValue, label: "mA")
            currentSolarPanelNewDataSet.colors = [UIColor(named: Constants.AppColors.secondary) ?? .red]
            
            let currentSolarPanelChartData = BarChartData(dataSet: currentSolarPanelNewDataSet)
            currentSolarPanelChartData.setDrawValues(false)
            
            // MARK: - codes for solar panel current
            
            //prepare new data to be inserted on the background thread
            
            DispatchQueue.main.async {
                
                self.snapshotStatsCard.timestampLabel?.text = solarPanel.timestamp
                
                self.snapshotStatsCard.batteryBarChart?.chart.data = voltageBatteryChartData
                self.snapshotStatsCard.voltageBarChart?.chart.data = voltageSolarPanelChartData
                self.snapshotStatsCard.currentBarChart?.chart.data = currentSolarPanelChartData
                
                self.snapshotStatsCard.batteryBarChart?.chart.animate(yAxisDuration: 0.35)
                self.snapshotStatsCard.voltageBarChart?.chart.animate(yAxisDuration: 0.35)
                self.snapshotStatsCard.currentBarChart?.chart.animate(yAxisDuration: 0.35)
                
                // show and animate new data on main (UI) thread
                                
            }
            
        }

    }
    
    
func didFinishServerDataRetrieval(data: Zonnepaneel) {
    
    let spanning_batterij: Double = data.spanning_batterij
    let spanning_zonnepaneel: Double = data.spanning_zonnepaneel
    let stroom_zonnepaneel: Int16 = data.stroom_zonnepaneel
    
    DispatchQueue.main.async {
        
        self.voltageBatteryCard.title = String(format: "%.1f Volt", spanning_batterij)
        self.voltageSolarPanelCard.title = String(format: "%.1f Volt", spanning_zonnepaneel)
        self.currentSolarPanelCard.title = String(format: "%d mA", stroom_zonnepaneel)
        
        // "%.1f" = show one decimal value
        
    }
    
        try? viewModel?.addDataSnapshot(
            timestamp: data.timestamp,
            spanningZonnepaneel: spanning_zonnepaneel,
            spanningAccu: spanning_batterij,
            stroomZonnepaneel: stroom_zonnepaneel
        )
    
            
}

    
    
    
    
    
    
}



