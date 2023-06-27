import Combine
import UIKit
import SnapKit
import ThemeKit
import ComponentKit
import SectionsTableView


class ChartIndicatorsViewController: ThemeViewController {
    private let viewModel: ChartIndicatorsViewModel
    private var cancellables = Set<AnyCancellable>()

    private let tableView = SectionsTableView(style: .grouped)
    private var viewItems = [ChartIndicatorsViewModel.ViewItem]()

    init(viewModel: ChartIndicatorsViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "chart_indicators.title".localized
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "button.close".localized, style: .plain, target: self, action: #selector(onTapClose))

        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        tableView.sectionDataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        onDeinit = { [weak self] in
            self?.viewModel.saveIndicators()
        }

        viewModel.$viewItems
                .receive(on: DispatchQueue.main)
                .sink { [weak self] viewItems in
                    self?.viewItems = viewItems
                    self?.tableView.reload()
                }
                .store(in: &cancellables)

        viewItems = viewModel.viewItems
        tableView.buildSections()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.deselectCell(withCoordinator: transitionCoordinator, animated: animated)
    }

    @objc func onTapClose() {
        dismiss(animated: true)
    }

}

extension ChartIndicatorsViewController {

    private func indicatorRow(viewItem: ChartIndicatorsViewModel.IndicatorViewItem, rowInfo: RowInfo) -> RowProtocol {
        let elements: [CellBuilderNew.CellElement] = [
            .imageElement(image: .local(viewItem.image), size: .image24),
            .textElement(text: .body(viewItem.name)),
            .imageElement(image: .local(UIImage(named: "edit_20")), size: .image20),
            .switch { component in
                component.switchView.isOn = viewItem.enabled
                component.onSwitch = { [weak self] in self?.viewModel.onToggle(viewItem: viewItem, $0) }
            }
        ]

        return CellBuilderNew.row(
                rootElement: .hStack(elements),
                tableView: tableView,
                id: viewItem.name,
                hash: viewItem.name + viewItem.enabled.description,
                height: .heightCell48,
                autoDeselect: true,
                bind: { cell in
                    cell.set(backgroundStyle: .lawrence, isFirst: rowInfo.isFirst, isLast: rowInfo.isLast)
                },
                action: { [weak self] in self?.viewModel.onEdit(viewItem: viewItem) }
        )

    }


    private func section(viewItem: ChartIndicatorsViewModel.ViewItem) -> SectionProtocol {
        Section(
                id: viewItem.category,
                headerState: tableView.sectionHeader(text: viewItem.category),
                footerState: .margin(height: .margin24),
                rows: viewItem.indicators.enumerated().map { index, item in
                    indicatorRow(viewItem: item, rowInfo: RowInfo(index: index, count: viewItem.indicators.count))
                }
        )
    }

}

extension ChartIndicatorsViewController: SectionsDataSource {

    func buildSections() -> [SectionProtocol] {
        viewItems.map { section(viewItem: $0) }
    }

}