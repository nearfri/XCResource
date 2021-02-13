import UIKit

class ViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(key: .places_authArrow)
        
        label.textColor = UIColor(key: .coralPink)
        label.text = String(key: .alert_failedToLoadImage)
        label.text = String(form: .alert_saveBeforeClose(documentTitle: "document.txt"))
    }
}
