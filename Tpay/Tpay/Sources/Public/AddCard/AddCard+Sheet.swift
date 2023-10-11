//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension AddCard {
    
    /// `AddCard.Sheet` is a component that provides a user interface for adding a new card for future payment. It is designed to be presented as a sheet within your application and facilitates the tokenization of credit card information for future transactions.
    
    public final class Sheet: Presentable {
        
        // MARK: - Properties
        
        private weak var delegate: AddCardDelegate?
        
        private var coordinator: AddCardCoordinator?
        
        private let configurationValidator = DefaultConfigurationValidator(resolver: ModuleContainer.instance.resolver)
        private let disposer = Disposer()
        
        private let payer: Payer?
        
        // MARK: - Initializers
        
        /// Initializes an `AddCard.Sheet` instance.
        ///
        /// - Parameters:
        ///   - payer: An optional `Payer` instance that represents the payer context for the card tokenization process.
        ///   - delegate: An optional delegate responsible for handling events related to card tokenization.

        public init(payer: Payer? = nil, delegate: AddCardDelegate? = nil) {
            self.payer = payer
            self.delegate = delegate
        }
        
        // MARK: - API
        
        /// Presents the sheet from a specified view controller.
        ///
        /// - Parameter from: The view controller from which to present the sheet.
        /// - Throws: A configuration error if the ``TpayModule`` is not properly configured. See: <doc:Basics>.
        
        public func present(from: UIViewController) throws {
            if case ConfigurationCheckResult.invalid(let error) = configurationValidator.checkProvidedConfiguration() {
                throw(error)
            }
            
            let coordinator = AddCardCoordinator(payer: payer)
            self.coordinator = coordinator
            
            let sheetViewController = coordinator.sheetViewController
            startObservingEvents()
            
            from.present(sheetViewController, animated: true)
            coordinator.start()
        }
        
        /// Dismisses the sheet.
        
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
            
            coordinator?.tokenizationCompleted
                .subscribe(onNext: { [weak self] in
                    self?.delegate?.onTokenizationCompleted()
                    self?.coordinator?.stop()
                })
                .add(to: disposer)
            
            coordinator?.tokenizationFailed
                .subscribe(onNext: { [weak self] in
                    self?.delegate?.onTokenizationCancelled()
                    self?.coordinator?.stop()
                })
                .add(to: disposer)
        }
    }
}
