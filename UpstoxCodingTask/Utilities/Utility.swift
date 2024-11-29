import Foundation
import UIKit

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

