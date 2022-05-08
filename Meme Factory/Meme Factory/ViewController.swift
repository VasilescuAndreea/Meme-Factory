//
//  ViewController.swift
//  Meme Factory
//
//  Created by Alex Weng on 07.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var memeTableView: UITableView!
    
    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memeTableView.delegate = self
        memeTableView.dataSource = self
        memes = DataManager.shared.fetchMeme()
        memeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = DataManager.shared.fetchMeme()
        memeTableView.reloadData()
    }
    
    @IBSegueAction func showCreate(_ coder: NSCoder) -> CreateViewController? {
        return CreateViewController(coder: coder)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "createvc") as? CreateViewController else {return}
        vc.setForEdit(meme: memes[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = memes[indexPath.row].caption
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteMeme(meme: memes[indexPath.row])
            memes = DataManager.shared.fetchMeme()
            tableView.reloadData()
        }
    }
}

