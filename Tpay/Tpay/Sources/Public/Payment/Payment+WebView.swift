//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation
import UIKit

extension Payment {
    
    /// The `WebView` class provides functionality for presenting a web view for externally-generated transaction processing within the payment module.
    
    final public class WebView: Presentable {
        
        // MARK: - Properties
        
        private let transaction: ExternallyGeneratedTransaction
        private weak var delegate: WebViewPaymentDelegate?
        
        private var coordinator: WebViewCoordinator?
        private let disposer = Disposer()
        
        // MARK: - Initializers
        
        /// Initializes a new instance of `WebView`.
        ///
        /// - Parameters:
        ///   - transaction: The externally generated transaction to be processed.
        ///   - delegate: An optional delegate responsible for handling web view payment-related events.
        
        public init(transaction: ExternallyGeneratedTransaction, delegate: WebViewPaymentDelegate? = nil) {
            self.transaction = transaction
            self.delegate = delegate
        }
        
        // MARK: - API
        
        /// Presents the web view for processing the externally-generated transaction.
        /// - Parameter from: The view controller from which to present the web view.
        /// - Throws: An error if there is an issue presenting the web view.
        
        public func present(from: UIViewController) throws {
            let coordinator = WebViewCoordinator(transaction: transaction)
            self.coordinator = coordinator
            
            let sheetViewController = coordinator.sheetViewController
            startObservingEvents()
            
            from.present(sheetViewController, animated: true)
            coordinator.start()
        }
        
        /// Dismisses the web view.
        ///
        /// Use this method to manually dismiss the web view.
        
        public func dismiss() {
            coordinator?.sheetViewController.dismiss(animated: true, completion: nil)
            coordinator = nil
        }
        
        // MARK: - Private
        
        private func startObservingEvents() {
            coordinator?.onPaymentCancelled
                .subscribe(onNext: { [weak self] in
                    self?.delegate?.onPaymentCancelled()
                    self?.coordinator?.stop()
                    self?.dismiss()
                })
                .add(to: disposer)
            
            coordinator?.onPaymentCompleted
                .subscribe(onNext: { [weak self] in
                    self?.delegate?.onPaymentCompleted()
                    self?.coordinator?.stop()
                    self?.dismiss()
                })
                .add(to: disposer)
            
            coordinator?.onPaymentError
                .subscribe(onNext: { [weak self] in
                    self?.delegate?.onPaymentError()
                    self?.coordinator?.stop()
                    self?.dismiss()
                })
                .add(to: disposer)
        }
    }
}

// MARK: - Models

/// A structure representing an externally generated transaction.

public struct ExternallyGeneratedTransaction {
    
    // MARK: - Properties
    
    let transactionPaymentUrl: URL
    let onSuccessRedirectUrl: URL
    let onErrorRedirectUrl: URL
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `ExternallyGeneratedTransaction`.
    ///
    /// - Parameters:
    ///   - transactionPaymentUrl: The URL to be loaded for processing the transaction payment. For more information, you should follow `Transactions` section under [OpenAPI documentation](https://openapi.tpay.com).
    ///   - onSuccessRedirectUrl: The URL to redirect to upon successful completion of the transaction. For more information, you should follow `Transactions` section under [OpenAPI documentation](https://openapi.tpay.com).
    ///   - onErrorRedirectUrl: The URL to redirect to upon unsuccessful completion of the transaction. For more information, you should follow `Transactions` section under [OpenAPI documentation](https://openapi.tpay.com).
    
    public init(transactionPaymentUrl: URL, onSuccessRedirectUrl: URL, onErrorRedirectUrl: URL) {
        self.transactionPaymentUrl = transactionPaymentUrl
        self.onSuccessRedirectUrl = onSuccessRedirectUrl
        self.onErrorRedirectUrl = onErrorRedirectUrl
    }
}

///  The `WebViewPaymentDelegate` protocol defines the methods that a delegate should implement to handle web view payment-related events.

public protocol WebViewPaymentDelegate: AnyObject {
    
    // MARK: - API
    
    /// Notifies the delegate when a payment is successfully completed.
    
    func onPaymentCompleted()
    
    /// Notifies the delegate when a payment is cancelled by the user.
    
    func onPaymentCancelled()
    
    /// Notifies the delegate when an error occurs during the payment process.
    
    func onPaymentError()
}
