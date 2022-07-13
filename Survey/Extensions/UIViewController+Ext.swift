//
//  UIViewController+Ext.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(
        title: String? = nil,
        message: String? = nil,
        okActionTitle: String? = "Ok",
        cancelActionTitle: String? = nil,
        okHandler: ((_ action: UIAlertAction) -> Void)? = nil,
        cancelHandler: ((_ action: UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let okActionTitle = okActionTitle {
            alert.addAction(
                UIAlertAction(
                    title: okActionTitle,
                    style: .default,
                    handler: { action in
                        okHandler?(action)
                    }
                )
            )
        }
        if let cancelActionTitle = cancelActionTitle {
            alert.addAction(
                UIAlertAction(
                    title: cancelActionTitle,
                    style: .default,
                    handler: { action in
                        cancelHandler?(action)
                    }
                )
            )
        }
        present(alert, animated: true, completion: nil)
    }
}
