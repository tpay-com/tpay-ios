//
//  Copyright © 2023 Tpay. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, *)
extension Payment.SwiftUI {
    
    struct Sheet: UIViewControllerRepresentable {
        
        // MARK: - Properties
        
        private let transaction: Transaction
        
        private let onPaymentCompleted: ((TransactionId) -> Void)?
        private let onPaymentCancelled: ((TransactionId) -> Void)?
        private let onErrorOccured: ((ModuleError) -> Void)?
        private let onDismissed: (() -> Void)?
        
        // MARK: - Initializers
        
        init(transaction: Transaction,
             onPaymentCompleted: ((TransactionId) -> Void)? = nil,
             onPaymentCancelled: ((TransactionId) -> Void)? = nil,
             onErrorOccured: ((ModuleError) -> Void)? = nil,
             onDismissed: (() -> Void)? = nil) {
            self.transaction = transaction
            self.onPaymentCompleted = onPaymentCompleted
            self.onPaymentCancelled = onPaymentCancelled
            self.onErrorOccured = onErrorOccured
            self.onDismissed = onDismissed
        }
        
        // MARK: - UIViewControllerRepresentable
        
        func makeUIViewController(context: Context) -> some UIViewController {
            do {
                let sheetViewController = try context.coordinator.start()
                return sheetViewController
            } catch let error as ModuleError {
                onErrorOccured?(error)
            } catch {
                Logger.error("Unidentified error during coordinator start")
            }
            
            defer { onDismissed?() }
            return SheetViewController()
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self, transaction: transaction)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
        
        final class Coordinator: NSObject {
            
            // MARK: - Properties
            
            private let parent: Sheet
            private let transaction: Transaction
            
            private var coordinator: PaymentCoordinator?
            private let configurationValidator = DefaultConfigurationValidator(resolver: ModuleContainer.instance.resolver)
            private let disposer = Disposer()
            
            // MARK: - Initializers
            
            init(_ sheet: Sheet, transaction: Transaction) {
                self.parent = sheet
                self.transaction = transaction
            }
            
            // MARK: - API
            
            func start() throws -> SheetViewController {
                if case ConfigurationCheckResult.invalid(let error) = configurationValidator.checkProvidedConfiguration() {
                    throw(error)
                }
                
                let coordinator = PaymentCoordinator(transaction: transaction)
                self.coordinator = coordinator
                
                let sheetViewController = coordinator.sheetViewController
                startObservingEvents()
                
                coordinator.start()
                
                return sheetViewController
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
                        self?.parent.onPaymentCompleted?(transactionId)
                        self?.coordinator?.stop()
                    })
                    .add(to: disposer)
                
                coordinator?.paymentFailed
                    .subscribe(onNext: { [weak self] transactionId in
                        self?.parent.onPaymentCancelled?(transactionId)
                        self?.coordinator?.stop()
                    })
                    .add(to: disposer)
            }
            
            private func dismiss() {
                coordinator?.sheetViewController.dismiss(animated: true, completion: nil)
                coordinator = nil
                parent.onDismissed?()
            }
        }
    }
}

@available(iOS 14.0, *)
public extension SwiftUI.View {
    
    /// Presents the Payment Sheet within a SwiftUI view.
    ///
    /// Use this method to display the Payment Sheet within your SwiftUI-based application.
    ///
    /// - Parameters:
    ///   - transaction: The transaction for which the Payment Sheet is presented.
    ///   - isPresented: A binding to control the presentation and dismissal of the Payment Sheet.
    ///   - onPaymentCompleted: A closure to be executed when the payment is successfully completed, providing the transaction ID.
    ///   - onPaymentCancelled: A closure to be executed when the payment is cancelled, providing the transaction ID.
    ///   - onErrorOccured: A closure to be executed when an error occurs during the payment process, providing the error details.
    ///
    /// - Returns: A SwiftUI view that can be used to present the Payment Sheet when the specified conditions are met.
    
    func presentPaymentSheet(for transaction: Transaction,
                             isPresented: Binding<Bool>,
                             onPaymentCompleted: ((TransactionId) -> Void)? = nil,
                             onPaymentCancelled: ((TransactionId) -> Void)? = nil,
                             onErrorOccured: ((ModuleError) -> Void)? = nil) -> some SwiftUI.View {
        fullScreenCover(isPresented: isPresented) {
            Payment.SwiftUI.Sheet(transaction: transaction,
                                  onPaymentCompleted: onPaymentCompleted,
                                  onPaymentCancelled: onPaymentCancelled,
                                  onErrorOccured: onErrorOccured,
                                  onDismissed: { isPresented.wrappedValue = false })
            .ignoresSafeArea()
            .background(ClearBackgroundView())
        }
    }
}

#endif
