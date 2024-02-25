//
//  SignUpViewController.swift
//  ProjektiIOS
//
//  Created by R-Tech on 23.2.24.
//

import UIKit
import SQLite3
import CryptoKit

class SignUpViewController: UIViewController {

    @IBOutlet var name:UITextField!
    @IBOutlet var email:UITextField!
    @IBOutlet var password:UITextField!
    @IBOutlet var confirm:UITextField!
    @IBOutlet var date:UIDatePicker!
    var db: OpaquePointer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Open or create the SQLite database
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("users.db").path {
            if sqlite3_open(path, &db) == SQLITE_OK {
                let createUserTableQuery = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT, date TEXT);"
                if sqlite3_exec(db, createUserTableQuery, nil, nil, nil) != SQLITE_OK {
                    print("Error creating table")
                }
            }
        }
       
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if validateFields() {
            insertUser()
        }
    }

    func validateFields() -> Bool {
        guard let name = name.text, !name.isEmpty else {
            showAlert(message: "Please enter your name")
            return false
        }
        guard let email = email.text, !email.isEmpty else {
            showAlert(message: "Please enter your email")
            return false
        }
        guard let password = password.text, !password.isEmpty else {
            showAlert(message: "Please enter a password")
            return false
        }
        
        guard password.count >= 8 else {
            showAlert(message: "Password must have at least 8 characters")
            return false
        }
        guard let confirm = confirm.text, !confirm.isEmpty else {
            showAlert(message: "Please confirm your password")
            return false
        }
        guard password == confirm else {
            showAlert(message: "Passwords do not match")
            return false
        }
        
        // Check if a birthday date is selected
        if date.datePickerMode == .date {
            showAlert(message: "Please pick your birthday")
            return false
        }
        
        // Check if the user meets the age requirement (e.g., 18 years old)
        let calendar = Calendar.current
        let currentDate = Date()
        let selectedDate = date.date
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
        guard let age = ageComponents.year, age >= 10 else {
            showAlert(message: "You must be at least 10 years old to sign up")
            return false
        }
        
            //showAlert1(message: "User Added successfully")
        return true
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert1(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func insertUser() {
      
        guard let hashedPassword = hashPassword(password.text ?? "") else {
                    print("Error hashing password")
                    return
                }
        
        let selectQuery = "SELECT COUNT(*) FROM users WHERE email = ?;"
        var selectStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(selectStatement, 1, email.text, -1, nil)
            
            if sqlite3_step(selectStatement) == SQLITE_ROW {
                let userCount = Int(sqlite3_column_int(selectStatement, 0))
                
                if userCount > 0 {
                    // User with the same email already exists
                    showAlert(message:"User with the same email already exists.")
                    return
                }
            }
            sqlite3_finalize(selectStatement)
        }
                
                let insertQuery = "INSERT INTO users (name, email, password, date) VALUES (?, ?, ?, ?);"
                var statement: OpaquePointer?
                if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateString = dateFormatter.string(from: date.date)
                    sqlite3_bind_text(statement, 1, name.text, -1, nil)
                    sqlite3_bind_text(statement, 2, email.text, -1, nil)
                    sqlite3_bind_text(statement, 3, hashedPassword, -1, nil) // Use hashed password
                    sqlite3_bind_text(statement, 4, dateString, -1, nil)
                    if sqlite3_step(statement) != SQLITE_DONE {
                        showAlert(message:"Error inserting user")
                    } else {
                        showAlert1(message:"User inserted successfully")
                        name.text = ""
                        email.text = ""
                        password.text = ""
                        confirm.text = ""
                        date.setDate(Date(), animated: true)
                    }
                    sqlite3_finalize(statement)
                }
            }
    
    
    func hashPassword(_ password: String) -> String? {
       guard let data = password.data(using: .utf8) else {
                return nil
            }
            let hashed = SHA256.hash(data: data)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        }
    

   
}
