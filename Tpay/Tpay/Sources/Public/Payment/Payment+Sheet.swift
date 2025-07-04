//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Payment {
    
    ///  The `Payment.Sheet` class provides a streamlined way to present payment transactions within your app.
    ///
    ///  This class encapsulates the necessary configuration and presentation logic, offering a user-friendly sheet-style interface for conducting payments.
    
    public final class Sheet: Presentable {
        
        // MARK: - Properties
        
        private let transaction: Transaction
        private weak var delegate: PaymentDelegate?
        
        private var coordinator: PaymentCoordinator?
        private let configurationValidator = DefaultConfigurationValidator(resolver: ModuleContainer.instance.resolver)
        private let disposer = Disposer()
        
        // MARK: - Initializers
        
        /// Initializes a new instance of the `Sheet` class.
        ///
        /// - Parameter transaction: The payment transaction to be presented.
        /// - Parameter delegate: An optional delegate to receive payment-related callbacks.
        
        public init(transaction: Transaction, delegate: PaymentDelegate? = nil) {
            self.transaction = transaction
            self.delegate = delegate
        }
        
        // MARK: - API
        
        /// Presents the payment sheet from a specified view controller.
        ///
        /// This method presents the payment sheet using a modal-style presentation, providing a focused payment interaction.
        ///
        /// - Parameter from: The view controller from which to present the payment sheet.
        /// - Throws: A configuration error if the ``TpayModule`` is not properly configured. See: <doc:Basics>.
        
        public func present(from: UIViewController) throws {
            if case ConfigurationCheckResult.invalid(let error) = configurationValidator.checkProvidedConfiguration() {
                throw(error)
            }
            
            let coordinator = PaymentCoordinator(transaction: transaction)
            self.coordinator = coordinator
            
            let sheetViewController = coordinator.sheetViewController
            startObservingEvents()
            
            from.present(sheetViewController, animated: true)
            coordinator.start()
        }
        
        /// Dismisses the payment sheet.
        ///
        /// Use this method to manually dismiss the payment sheet.
        
        public func dismiss() {
            coordinator?.sheetViewController.dismiss(animated: true, completion: nil)
            coordinator = nil
        }
        
        // MARK: - Private
        
        private func startObservingEvents() {
            coordinator?.closeModule
                .subscribe(onNext: { [weak self] in
                    self?.delegate?.onPaymentClosed()
                    self?.coordinator?.stop()
                    self?.dismiss()
                })
                .add(to: disposer)
            
            coordinator?.paymentCreated
                .subscribe(onNext: { [weak self] transactionId in
                    self?.delegate?.onPaymentCreated(transactionId: transactionId)
                })
                .add(to: disposer)
            
            coordinator?.paymentCompleted
                .subscribe(onNext: { [weak self] transactionId in
                    self?.delegate?.onPaymentCompleted(transactionId: transactionId)
                    self?.coordinator?.stop()
                })
                .add(to: disposer)
            
            coordinator?.paymentFailed
                .subscribe(onNext: { [weak self] transactionId in
                    self?.delegate?.onPaymentCancelled(transactionId: transactionId)
                    self?.coordinator?.stop()
                })
                .add(to: disposer)
        }
    }
}
