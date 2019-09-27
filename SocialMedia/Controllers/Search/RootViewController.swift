/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *    *    Redistributions of source code must retain the above copyright notice, this
 *        list of conditions and the following disclaimer.
 *
 *    *    Redistributions in binary form must reproduce the above copyright notice,
 *        this list of conditions and the following disclaimer in the documentation
 *        and/or other materials provided with the distribution.
 *
 *    *    Neither the name of CosmicMind nor the names of its
 *        contributors may be used to endorse or promote products derived from
 *        this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material
import Graph
import Foundation

class RootViewController: UIViewController {
    
    // Model.
    internal var graph: Graph!
    internal var search: Search<Entity>!
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        isMotionEnabled = true
        prepareSearchBar()
        addChildController()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //tableView?.reloadData()
    }
    
    func addChildController() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            ])
        
        // add child view controller view to container
        
        let controller = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: SearchContainerViewController.className)
        // controller.setDelagete
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        controller.didMove(toParent: self)
    }
}

/// Model.
extension RootViewController {
    internal func prepareGraph() {
        graph = Graph()
        
        // Uncomment to clear the Graph data.
        //        graph.clear()
    }
    
    internal func prepareSearch() {
        search = Search<Entity>(graph: graph).for(types: "User").where(properties: "name")
        
        search.async { [weak self] (data) in
            if 0 == data.count {
                // SampleData.createSampleData()
            }
            // self?.reloadData()
        }
    }
}

extension RootViewController: SearchBarDelegate {
    
    
    
    internal func prepareSearchBar() {
        // Access the searchBar.
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
        
        searchBar.delegate = self
        searchBar.textField.delegate = self
//        textFieldShouldReturn(searchBar.textField).delegate = self
    }
    
    func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
        //reloadData()
        
        if text == ""{
            let userDefaults = UserDefaults.standard
            userDefaults.set(nil, forKey: "searchString")
            userDefaults.synchronize()
        }else{
            let userDefaults = UserDefaults.standard
            userDefaults.set(text!, forKey: "searchString")
            userDefaults.synchronize()
        }
    }
    
    func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?) {
        
        if text == ""{
            let userDefaults = UserDefaults.standard
            userDefaults.set(nil, forKey: "searchString")
            userDefaults.synchronize()
        }else{
            let userDefaults = UserDefaults.standard
            userDefaults.set(text!, forKey: "searchString")
            userDefaults.synchronize()
        }
    }
 
}

extension RootViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        dismissKeyboard()
        textField.resignFirstResponder()
        let searchType = (UserDefaults.standard.value(forKey: "searchKey") as? String)
        
        if(searchType != nil)
        {
            if(searchType! == "1" ) {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: All_ScreensNotification), object: nil)
            }
            else if searchType! == "2"
            {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: Post_ScreenNotification), object: nil)
            }
            else if searchType! == "3"
            {
                
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: People_ScreensNotification), object: nil)
            }
            else if searchType! == "4"
            {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: photos_ScreensNotification), object: nil)
            }
            else if searchType! == "5"
            {
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: Videos_ScreensNotification), object: nil)
            }
        }
        else
        {
            print("Search Type is Empty")
        }
        
        return true
    }
   
}
