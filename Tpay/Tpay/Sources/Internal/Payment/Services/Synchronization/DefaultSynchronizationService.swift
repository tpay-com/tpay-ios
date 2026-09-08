//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultSynchronizationService: SynchronizationService {
    
    // MARK: - Events
    
    let synchronizationStatus: Variable<Domain.SynchronizationStatus> = Variable(.idle)
    
    // MARK: - Properties
    
    private let paymentDataService: PaymentDataService
    private let banksService: BanksService
    private let digitalWalletService: DigitalWalletService

    // MARK: - Initializers

    convenience init(resolver: ServiceResolver) {
        let paymentDataService = DefaultPaymentDataService(resolver: resolver)
        self.init(paymentDataService: paymentDataService,
                  banksService: resolver.resolve(),
                  digitalWalletService: resolver.resolve())
    }

    init(paymentDataService: PaymentDataService,
         banksService: BanksService,
         digitalWalletService: DigitalWalletService) {
        self.paymentDataService = paymentDataService
        self.banksService = banksService
        self.digitalWalletService = digitalWalletService
    }
    
    // MARK: - API
    
    func fetchPaymentData(then: @escaping Completion) {
        synchronizationStatus.value = .syncing
        Invocation.Queue()
            .append(paymentDataService.fetchChannels)
            .invoke(completion: { [weak self] result in
                self?.handleSyncResult(result, then: then)
            })
    }
    
    func prefetchRemoteResources(then: @escaping Completion) {
        Invocation.Group()
            .append(prefetchBankImages)
            .append(prefetchDigitalWalletImages)
            .invoke(completion: then)
    }
    
    // MARK: - Private
    
    private func prefetchBankImages(then: @escaping Completion) {
        RemoteImageProvider.clearAll()
        let imagesToFetch = banksService.banks.compactMap(\.imageUrl)
        RemoteImageProvider.prefetch(urls: imagesToFetch, completion: then)
    }
    
    private func prefetchDigitalWalletImages(then: @escaping Completion) {
        RemoteImageProvider.clearAll()
        let imagesToFetch = digitalWalletService.digitalWallets.compactMap(\.imageUrl)
        RemoteImageProvider.prefetch(urls: imagesToFetch, completion: then)
    }
    
    private func handleSyncResult(_ result: Result<Void, Error>, then: @escaping Completion) {
        switch result {
        case .success:
            synchronizationStatus.value = .finished
            then(.success(()))
        case .failure(let error):
            synchronizationStatus.value = .error(error)
            then(.failure(error))
        }
    }
}
