protocol IManageAccountsView: class {
    func set(viewItems: [ManageAccountViewItem])
    func show(error: Error)
    func showSuccess()
    func showBackupRequired(predefinedAccountType: PredefinedAccountType)
}

protocol IManageAccountsViewDelegate {
    func viewDidLoad()

    func didTapUnlink(index: Int)
    func didTapBackup(index: Int)
    func didTapCreate(index: Int)
    func didTapRestore(index: Int)

    func didRequestBackup()
}

protocol IManageAccountsInteractor {
    var predefinedAccountTypes: [PredefinedAccountType] { get }
    func account(predefinedAccountType: PredefinedAccountType) -> Account?
}

protocol IManageAccountsInteractorDelegate: class {
    func didUpdateAccounts()
}

protocol IManageAccountsRouter {
    func showUnlink(account: Account, predefinedAccountType: PredefinedAccountType)
    func showBackup(account: Account, predefinedAccountType: PredefinedAccountType)
    func showCreateWallet(predefinedAccountType: PredefinedAccountType)
    func showRestore(predefinedAccountType: PredefinedAccountType, delegate: ICredentialsCheckDelegate)
    func showSettings(coins: [Coin], delegate: IBlockchainSettingsDelegate?)
    func showRestoreCoins(predefinedAccountType: PredefinedAccountType, accountType: AccountType, proceedMode: RestoreRouter.ProceedMode, delegate: IRestoreCoinsDelegate)
    func closeRestore()
}
