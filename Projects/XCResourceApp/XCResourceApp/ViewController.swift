import UIKit

class ViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(key: .icoSoundPressed)
        
        label.textColor = UIColor(key: .coralPink)
        label.text = String(key: .alert_failedToLoadImage)
    }
}
