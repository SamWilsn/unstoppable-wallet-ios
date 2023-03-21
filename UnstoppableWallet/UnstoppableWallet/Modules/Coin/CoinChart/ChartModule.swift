import Foundation
import UIKit
import RxCocoa
import CurrencyKit
import Chart

struct ChartModule {

    struct ViewItem {
        let value: String?
        let valueDescription: String?
        let rightSideMode: RightSideMode

        let chartData: ChartData
        let chartTrend: MovementTrend
        let chartDiff: Decimal?

        let minValue: String?
        let maxValue: String?
    }

    struct SelectedPointViewItem {
        let value: String?
        let diff: Decimal?
        let date: String
        let rightSideMode: RightSideMode

        init(value: String?, diff: Decimal? = nil, date: String, rightSideMode: RightSideMode) {
            self.value = value
            self.diff = diff
            self.date = date
            self.rightSideMode = rightSideMode
        }
    }

    enum RightSideMode {
        case none
        case volume(value: String?)
        case dominance(value: Decimal?, diff: Decimal?)
    }

}

enum MovementTrend {
    case ignore
    case neutral
    case down
    case up
}

protocol IChartViewModel {
    var intervals: [String] { get }
    var intervalsUpdatedWithCurrentIndexDriver: Driver<Int> { get }
    var intervalIndexDriver: Driver<Int> { get }
    var pointSelectedItemDriver: Driver<ChartModule.SelectedPointViewItem?> { get }
    var loadingDriver: Driver<Bool> { get }
    var chartInfoDriver: Driver<ChartModule.ViewItem?> { get }
    var errorDriver: Driver<Bool> { get }

    func onSelectInterval(at index: Int)
    func start()
    func retry()
}
