//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension CardTokenPayment {
    
    public final class Sheet: Presentable {
        
        // MARK: - Properties
        
        private let transaction: Transaction
        private weak var delegate: CardTokenPaymentDelegate?
        
        private var coordinator: CardTokenPaymentCoordinator?
        private let configurationValidator = DefaultConfigurationValidator(resolver: ModuleContainer.instance.resolver)
        private let disposer = Disposer()
        
        // MARK: - Initializers
        
        public init(transaction: Transaction, delegate: CardTokenPaymentDelegate? = nil) {
            self.transaction = transaction
            self.delegate = delegate
        }
        
        // MARK: - API
        
        public func present(from: UIViewController) throws {
            if case ConfigurationCheckResult.invalid(let error) = configurationValidator.checkProvidedConfiguration() {
                throw(error)
            }
            
            let coordinator = CardTokenPaymentCoordinator(transaction: transaction)
            self.coordinator = coordinator
            
            let sheetViewController = coordinator.sheetViewController
            startObservingEvents()
            
            from.present(sheetViewController, animated: true)
            coordinator.start()
        }
        
        public func dismiss() {
            coordinator?.sheetViewController.dismiss(animated: true, completion: nil)
            coordinator = nil
        }
        
        // MARK: - Private
        
        private func startObservingEvents() {
            coordinator?.closeModule
                .subscribe(onNext: { [weak self] in
                    self?.coordinator?.stop()
                    self?.dismiss()
                })
                .add(to: disposer)
            
            coordinator?.paymentCompleted
                .subscribe(onNext: { [weak self] transactionId in
                    self?.delegate?.onCardTokenPaymentCompleted(transactionId: transactionId)
                    self?.coordinator?.stop()
                })
                .add(to: disposer)
            
            coordinator?.paymentFailed
                .subscribe(onNext: { [weak self] transactionId in
                    self?.delegate?.onCardTokenPaymentCancelled(transactionId: transactionId)
                    self?.coordinator?.stop()
                })
                .add(to: disposer)
            
            coordinator?.errorOccured
                .subscribe(onNext: { [weak self] error in
                    self?.delegate?.onCardTokenErrorOccured(error: error)
                    self?.coordinator?.stop()
                })
                .add(to: disposer)
        }
    }
}
