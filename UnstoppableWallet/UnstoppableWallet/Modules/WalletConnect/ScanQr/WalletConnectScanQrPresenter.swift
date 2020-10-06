import RxSwift
import RxRelay
import RxCocoa
import WalletConnect

class WalletConnectScanQrPresenter {
    private let service: WalletConnectService

    private let openMainRelay = PublishRelay<Void>()
    private let openErrorRelay = PublishRelay<Error>()

    init(service: WalletConnectService) {
        self.service = service
    }

}

extension WalletConnectScanQrPresenter {

    var openMainSignal: Signal<Void> {
        openMainRelay.asSignal()
    }

    var openErrorSignal: Signal<Error> {
        openErrorRelay.asSignal()
    }

    func handleScanned(string: String) {
        do {
            try service.connect(uri: string)
            openMainRelay.accept(())
        } catch {
            openErrorRelay.accept(error)
        }
    }

}
