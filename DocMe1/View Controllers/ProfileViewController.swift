
import UIKit
import FirebaseUI

class ProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        checkIfUserIsLoggedIn()
            
        }
    func checkIfUserIsLoggedIn()
    {
         if Auth.auth().currentUser?.uid == nil{
            //perform(#selector(handleLogout), with: nil, afterDelay:0)
            handleLogout()
        }
        else{
            let uid = Auth.auth().currentUser?.uid;
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
              let firstname = value?["firstname"] as? String ?? ""
                let lastname = value?["lastname"] as? String ?? ""
                print(firstname)
                self.userName.text = firstname + " " + lastname;

              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
        func handleLogout()
        {
            //will try to do the following, because sometimes it gives an error
            do {
                try Auth.auth().signOut()
            }
            catch let logoutError
            {
                print(logoutError)
            }
            
            
            let navigationViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationViewController
            
            view.window?.rootViewController = navigationViewController
            view.window?.makeKeyAndVisible()
            
            present(navigationViewController!, animated: true, completion: nil)
             
        }

}
