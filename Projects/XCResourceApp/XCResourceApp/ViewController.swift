import UIKit

class ViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = .named(.places_authArrow)
        
        label.textColor = .named(.coralPink)
        label.text = .localized(.alert_failedToLoadImage)
        label.text = .formatted(.alert_saveBeforeClose(documentTitle: "document.txt"))
    }
}
