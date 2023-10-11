//
//  Copyright © 2023 Tpay. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, *)
extension AddCard.SwiftUI {
    
    struct Sheet: UIViewControllerRepresentable {
        
        // MARK: - Properties
        
        private let payer: Payer?
        
        private var onTokenizationCompleted: (() -> Void)?
        private var onTokenizationCancelled: (() -> Void)?
        private let onErrorOccured: ((ModuleError) -> Void)?
        private let onDismissed: (() -> Void)?
        
        // MARK: - Initializers
        
        init(for payer: Payer? = nil,
             onTokenizationCompleted: (() -> Void)? = nil,
             onTokenizationCancelled: (() -> Void)? = nil,
             onErrorOccured: ((ModuleError) -> Void)? = nil,
             onDismissed: (() -> Void)? = nil) {
            self.payer = payer
            self.onTokenizationCompleted = onTokenizationCompleted
            self.onTokenizationCancelled = onTokenizationCancelled
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
            Coordinator(self, payer: payer)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
        
        final class Coordinator: NSObject {
            
            // MARK: - Properties
            
            private let parent: Sheet
            private let payer: Payer?
            
            private var coordinator: AddCardCoordinator?
            private let configurationValidator = DefaultConfigurationValidator(resolver: ModuleContainer.instance.resolver)
            private let disposer = Disposer()
            
            // MARK: - Initializers
            
            init(_ sheet: Sheet, payer: Payer?) {
                self.parent = sheet
                self.payer = payer
            }
            
            // MARK: - API
            
            func start() throws -> SheetViewController {
                if case ConfigurationCheckResult.invalid(let error) = configurationValidator.checkProvidedConfiguration() {
                    throw(error)
                }
                
                let coordinator = AddCardCoordinator(payer: payer)
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
                
                coordinator?.tokenizationCompleted
                    .subscribe(onNext: { [weak self] in
                        self?.parent.onTokenizationCompleted?()
                        self?.coordinator?.stop()
                    })
                    .add(to: disposer)
                
                coordinator?.tokenizationFailed
                    .subscribe(onNext: { [weak self] in
                        self?.parent.onTokenizationCancelled?()
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
    
    /// Presents the Card Tokenization Sheet within a SwiftUI view.
    ///
    /// Use this method to display the Card Tokenization Sheet within your SwiftUI-based application.
    ///
    /// - Parameters:
    ///   - payer: The payer for whom the Card Tokenization Sheet is presented (optional).
    ///   - isPresented: A binding to control the presentation and dismissal of the Card Tokenization Sheet.
    ///   - onTokenizationCompleted: A closure to be executed when the card tokenization is successfully completed.
    ///   - onTokenizationCancelled: A closure to be executed when the card tokenization is cancelled.
    ///   - onErrorOccured: A closure to be executed when an error occurs during the tokenization process, providing the error details.
    ///
    /// - Returns: A SwiftUI view that can be used to present the Card Tokenization Sheet when the specified conditions are met.
    
    func presentCardTokenizationSheet(for payer: Payer? = nil,
                                      isPresented: Binding<Bool>,
                                      onTokenizationCompleted: (() -> Void)? = nil,
                                      onTokenizationCancelled: (() -> Void)? = nil,
                                      onErrorOccured: ((ModuleError) -> Void)? = nil) -> some SwiftUI.View {
        fullScreenCover(isPresented: isPresented) {
            AddCard.SwiftUI.Sheet(for: payer,
                                  onTokenizationCompleted: onTokenizationCompleted,
                                  onTokenizationCancelled: onTokenizationCancelled,
                                  onErrorOccured: onErrorOccured,
                                  onDismissed: { isPresented.wrappedValue = false })
            .ignoresSafeArea()
            .background(ClearBackgroundView())
        }
    }
}

#endif
