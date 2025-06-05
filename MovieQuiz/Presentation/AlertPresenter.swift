import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showResults(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }

    func show(alert model: AlertModel) {
            let alert = UIAlertController(
                title: model.title,
                message: model.message,
                preferredStyle: .alert
            )
            
            let action = UIAlertAction(
                title: model.buttonText,
                style: .default
            ) { _ in
                model.completion?()
            }
            
            alert.addAction(action)
            viewController?.present(alert, animated: true)
        }
}
