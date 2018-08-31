import UIKit

class ImageInformationViewController : UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var BtnClose: UIButton!
    @IBOutlet weak var BtnPlay: UIButton!
    var imageInformation : ImageInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BtnClose.layer.borderWidth = 1.0
        BtnClose.layer.borderColor = UIColor.blue.cgColor
        BtnClose.layer.cornerRadius = 10
        BtnClose.clipsToBounds = true
        BtnPlay.layer.borderWidth = 1.0
        BtnPlay.layer.borderColor = UIColor.blue.cgColor
        BtnPlay.layer.cornerRadius = 10
        BtnPlay.clipsToBounds = true
        
        if let actualImageInformation = imageInformation {
            self.nameLabel.text = actualImageInformation.name
            self.imageView.image = actualImageInformation.image
            self.descriptionText.text = actualImageInformation.description
            //self.BtnPlay.addTarget(self, action: Selector("buttonAction"), for: .touchUpInside)
        }
    }
    
    @IBAction func openLink(_ sender: Any) {
        if let url = NSURL(string: (imageInformation?.buttonAction)!){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
