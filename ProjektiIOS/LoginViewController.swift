import UIKit
import SQLite3
import CryptoKit

class LoginViewController: UIViewController {

    @IBOutlet var email:UITextField!
    @IBOutlet var password:UITextField!
    var db: OpaquePointer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Open or create the SQLite database
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("users.db").path {
            if sqlite3_open(path, &db) == SQLITE_OK {
                // Database opened successfully
            } else {
                print("Error opening database")
            }
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if validateFields() {
            if loginUser() {
                // Login successful
                //showAlert1(message:"Login successful")
                performSegue(withIdentifier: "Weather", sender: self)
                email.text = ""
                password.text = ""
                
                            
            } else {
                // Login failed
                showAlert(message:"Invalid email or password")
                email.text = ""
                password.text = ""
            }
        }
    }

    func validateFields() -> Bool {
        guard let email = email.text, !email.isEmpty else {
            showAlert(message: "Enter Your Email Please")
            return false
        }
        
        guard let password = password.text, !password.isEmpty else {
            showAlert(message: "Enter Your Password Please")
            return false
        }
        
        return true
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title:"Error",message:message,preferredStyle:.alert)
        
        let okAction = UIAlertAction(title:"OK",style:.default,handler: nil)
        
        alert.addAction(okAction)
        present(alert,animated:true,completion: nil)
    }
    
    func showAlert1(message:String) {
        let alert = UIAlertController(title:"Success",message:message,preferredStyle:.alert)
        
        let okAction = UIAlertAction(title:"OK",style:.default,handler: nil)
        
        alert.addAction(okAction)
        present(alert,animated:true,completion: nil)
    }

    func loginUser() -> Bool {
        let query = "SELECT * FROM users WHERE email = ?;"
        var statement: OpaquePointer?
        guard let email = email.text, let password = password.text else {
            return false
        }
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, email, -1, nil)
            if sqlite3_step(statement) == SQLITE_ROW {
                let storedPassword = String(cString: sqlite3_column_text(statement, 3))
                if verifyPassword(password, storedPassword) {
                
                    sqlite3_finalize(statement)
                    return true
                }
            }
        }
        sqlite3_finalize(statement)
        return false
    }

    func verifyPassword(_ inputPassword: String, _ storedPassword: String) -> Bool {
        guard let hashedInputPassword = hashPassword(inputPassword) else {
            return false
        }
        return hashedInputPassword == storedPassword
    }

    func hashPassword(_ password: String) -> String? {
       guard let data = password.data(using: .utf8) else {
                return nil
            }
            let hashed = SHA256.hash(data: data)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        }
    
}

