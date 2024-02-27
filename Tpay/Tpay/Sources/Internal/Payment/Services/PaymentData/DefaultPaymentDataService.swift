//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultPaymentDataService: PaymentDataService {
    
    private let networkingService: NetworkingService
    private let paymentMethodsService: PaymentMethodsService
    private let transportationMapper: TransportationToDomainModelsMapper
    
    // MARK: - Initializers
    
    convenience init(resolver: ServiceResolver) {
        self.init(networkingService: resolver.resolve(),
                  paymentMethodsService: resolver.resolve(),
                  transportationMapper: DefaultTransportationToDomainModelsMapper())
    }
    
    init(networkingService: NetworkingService,
         paymentMethodsService: PaymentMethodsService,
         transportationMapper: TransportationToDomainModelsMapper) {
        self.networkingService = networkingService
        self.paymentMethodsService = paymentMethodsService
        self.transportationMapper = transportationMapper
    }
    
    // MARK: - API
    
    func fetchChannels(then: @escaping Completion) {
        let request = TransactionsController.Channels()
        networkingService.execute(request: request)
            .onSuccess { [weak self] response in self?.handle(response, completion: then) }
            .onError { error in then(.failure(error)) }
    }
    
    func fetchBankGroups(then: @escaping Completion) {
        let request = TransactionsController.BankGroups()
        networkingService.execute(request: request)
            .onSuccess { [weak self] response in self?.handle(response, completion: then) }
            .onError { error in then(.failure(error)) }
    }
    
    func getAvailableBanks(then: @escaping (Result<[Domain.PaymentMethod.Bank], Error>) -> Void) {
        let request = TransactionsController.BankGroups()
        networkingService.execute(request: request)
            .onSuccess { [weak self] response in
                let banks = self?.paymentMethods(from: response).allBanks() ?? []
                then(.success(banks))
            }
            .onError { error in then(.failure(error)) }
    }
    
    func getAvailableDigitalWallets(then: @escaping (Result<[Domain.PaymentMethod.DigitalWallet], Error>) -> Void) {
        let request = TransactionsController.BankGroups()
        networkingService.execute(request: request)
            .onSuccess { [weak self] response in
                let banks = self?.paymentMethods(from: response).allWallets() ?? []
                then(.success(banks))
            }
            .onError { error in then(.failure(error)) }
    }
    
    func getAvailablePaymentMethods(then: @escaping (Result<[Domain.PaymentMethod], Error>) -> Void) {
        let request = TransactionsController.BankGroups()
        networkingService.execute(request: request)
            .onSuccess { [weak self] response in
                let paymentMethods = self?.paymentMethods(from: response) ?? []
                then(.success(paymentMethods))
            }
            .onError { error in then(.failure(error)) }
    }
    
    // MARK: - Private
    
    private func handle(_ response: TransactionsController.BankGroups.Response, completion: @escaping Completion) {
        let availablePaymentMethods = paymentMethods(from: response)
        Invocation.Queue()
            .append(method: paymentMethodsService.store, with: availablePaymentMethods)
            .invoke(completion: completion)
    }
    
    private func handle(_ response: TransactionsController.Channels.Response, completion: @escaping Completion) {
        let availablePaymentMethods = paymentMethods(from: response)
        let paymentChannels = paymentChannels(from: response)
        Invocation.Queue()
            .append(method: paymentMethodsService.store, with: availablePaymentMethods)
            .append(method: paymentMethodsService.store, with: paymentChannels)
            .invoke(completion: completion)
    }
    
    private func paymentMethods(from response: TransactionsController.BankGroups.Response) -> [Domain.PaymentMethod] {
        let paymentMethods = response.bankGroups.compactMap { [weak self] in self?.transportationMapper.makePaymentMethod(from: $0) }
        return paymentMethods
    }
    
    private func paymentMethods(from response: TransactionsController.Channels.Response) -> [Domain.PaymentMethod] {
        let paymentMethods = response.channels
            .filter(\.isAvailable)
            .compactMap { [weak self] in self?.transportationMapper.makePaymentMethod(from: $0) }
        return paymentMethods
    }
    
    private func paymentChannels(from response: TransactionsController.Channels.Response) -> [Domain.PaymentChannel] {
        let paymentChannels = response.channels
            .compactMap { [weak self] in self?.transportationMapper.makePaymentChannel(from: $0) }
        return paymentChannels
    }
}
