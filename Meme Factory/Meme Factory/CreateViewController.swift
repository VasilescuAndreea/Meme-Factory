//
//  CreateViewController.swift
//  Meme Factory
//
//  Created by Alex Weng on 07.05.2022.
//

import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var MemeView: UIView!
    @IBOutlet weak var MemeCaption: UILabel!
    @IBOutlet weak var MemeCaptionInput: UITextField!
    @IBOutlet weak var MemeImage: UIImageView!
    
    var setForEdit = false
    var memeInstance: Meme!
    
    var firstCaption: String?
    var firstImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MemeCaptionInput.text = firstCaption
        MemeCaption.text = MemeCaptionInput.text
        
        MemeImage.image = firstImg
    }

    @IBAction func CaptionChanged(_ sender: Any) {
        MemeCaption.text = MemeCaptionInput.text
    }
    
    @IBAction func CaptionEditChanged(_ sender: Any) {
        MemeCaption.text = MemeCaptionInput.text
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func saveMeme(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: MemeView.bounds.size)
        let image = renderer.image { ctx in
            MemeView.drawHierarchy(in: MemeView.bounds, afterScreenUpdates: true)
        }
        
        if setForEdit == false {
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            if let memeImageData = MemeImage.image?.pngData() {
                DataManager.shared.saveMeme(caption: MemeCaption.text ?? "", img: memeImageData, thumbnail: image.pngData()!)
            }
        } else {
            memeInstance.caption = MemeCaption.text
            memeInstance.img = MemeImage.image?.pngData()!
            memeInstance.thumbnail = image.pngData()!
            DataManager.shared.saveContext()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: MemeView.bounds.size)
        let image = renderer.image { ctx in
            MemeView.drawHierarchy(in: MemeView.bounds, afterScreenUpdates: true)
        }

        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setForEdit(meme: Meme) {
        self.title = "Editor"
        firstCaption = meme.caption!
        firstImg = UIImage(data: meme.img!)
        setForEdit = true
        memeInstance = meme
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        MemeImage.image = image
        dismiss(animated: true)
    }
}
