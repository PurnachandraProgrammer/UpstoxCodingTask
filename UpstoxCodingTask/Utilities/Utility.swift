import Foundation
import UIKit

protocol AlertPresenter {
    func presentAlert(_ alert: UIAlertController, animated: Bool)
}

extension UIViewController: AlertPresenter {
    func presentAlert(_ alert: UIAlertController, animated: Bool) {
        self.present(alert, animated: animated, completion: nil)
    }
}

final class Utility {
    static func showAlert(for error: NSError, withPresenter presenter: AlertPresenter) {
        let alert = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presenter.presentAlert(alert, animated: true)
    }
    
    static func showAlert(title: String, message: String, withPresenter presenter: AlertPresenter) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presenter.presentAlert(alert, animated: true)
    }
}

/*
final class Utility {

    static func showAlert(for error: NSError,withPresenter presenter: UIViewController) {
        // Present the alert on the main thread
        let alert = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(title:String,message:String,withPresenter presenter: UIViewController) {
        // Present the alert on the main thread
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
}
*/

