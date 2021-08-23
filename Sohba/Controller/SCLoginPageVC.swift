//
//  SCLoginPageVC.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 30/06/2021.
//

import UIKit
import ProgressHUD
import Firebase


class SCLoginPageVC: UIViewController {
    
    //MARK: - Outlet
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!{didSet{emailTextField.delegate = self}}
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField! {didSet{passwordTextField.delegate = self}}
    @IBOutlet weak var confirmPasswordTextField: UITextField! {didSet{confirmPasswordTextField.delegate = self}}
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var signUpBtnPressed: UIButton!{didSet{signUpBtnPressed.layer.cornerRadius = 10}}
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var forgetPasswordBtnPressed: UIButton!
    
    
    //MARK: - View
    // ---> the 3 var/instance from class ShadowView
    let emailTextFieldView = ShadowView(frame: .zero)
    let passwordTextFieldView = ShadowView(frame: .zero)
    let confirmPasswordTextFieldView = ShadowView(frame: .zero)
    
    //MARK: - textField Buttons
    
    // ---> the left email as Image
    let emailTextFieldBtn = SCDefualtBtn(title: "", imageBtn: "mail.fill", backgroundColor: .black, tintColor: .white ,width: 30,height: 30,cornerRadius: 5)
    
    // ---> the hiden or show password
    let rightPasswordTextFieldBtn = SCDefualtBtn(title: "", imageBtn: "eye.slash.fill", backgroundColor: .black, tintColor: .white ,width: 25,height: 25,cornerRadius: 25/2)
    
    // ---> the hiden or show password
    let rightConfirmPasswordTextFieldBtn = SCDefualtBtn(title: "", imageBtn: "eye.slash.fill", backgroundColor: .black, tintColor: .white ,width: 25,height: 25,cornerRadius: 25/2)

    // ---> the left password as Image
    let leftPasswordTextFieldBtn = SCDefualtBtn(title: "", imageBtn: "key.fill", backgroundColor: .black, tintColor: .white ,width: 30,height: 30,cornerRadius: 5)
    
    // ---> the left Confirmpassword as Image
    let leftConfirmPasswordTextFieldBtn = SCDefualtBtn(title: "", imageBtn: "key.fill", backgroundColor: .black, tintColor: .white ,width: 30,height: 30,cornerRadius: 5 )
    
    //MARK: - Variables
    
    let gesture = UITapGestureRecognizer()
    

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCEmitterCell()
        
        configureNavigation()
        
        configureEmailTextFieldViews()
        configurePasswordTextFieldViews()
        configureConfirmPasswordTextFieldViews()

        configureEmailTextFieldView()
        configurePasswordTextField()
        configureConfirmPasswordTextField()
        
        hideTextLabels()
        gestureLogin()
        
        passwordTextFieldSecurityView()
    }
    
    
    //MARK: -  Action
    
    
    //MARK: - signUp/Login Button Pressed
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        
        // Validation TextField
        configureValidationTextField()
        
        if title == "Register"{
            //----> Register FireBase
            configureRegisterFirebase()
            print("Register")
        }else if title == "Login"{
            //----> Login Firebase
            configureLoginFirebase()
        }
        
    }
    
    
    @IBAction func forgetPasswordBtnPressed(_ sender: UIButton) {
        
        guard !emailTextField.text!.isEmpty else{ProgressHUD.showError("Enter The the Email"); return}
        
        //---> forget password
        resendForgetVarificationPassword()
    }
    
    
    
    //MARK: - action of change the UI
    @objc func loginGestureAction(){
        
        //----> change UI Func
        upDataUILoginPage()
        
    }
    
    
    
    
    //MARK: - Action Of TextFieldViews
    
    
    //MARK: - security Buttons
    private func passwordTextFieldSecurityView(){
        
        // ----> add the actuion for the two buttons of securty
        rightPasswordTextFieldBtn.addTarget(self, action: #selector(securityRightPasswordAction), for: .allEvents)
        rightConfirmPasswordTextFieldBtn.addTarget(self, action: #selector(securityRightConfirmPasswordAction), for: .allEvents)
    }
    
    
    
    //MARK: - action of Security buttons
    
    // ----> password Text Feild
    @objc func securityRightPasswordAction(){
        
        // ----> if true
        if passwordTextField.isSecureTextEntry == true {
            
            passwordTextField.isSecureTextEntry = false
            rightPasswordTextFieldBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            
            // ----> if false
        }else{
            
            passwordTextField.isSecureTextEntry = true
            rightPasswordTextFieldBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    
    
    // ----> confirm password Text Feild
    @objc func securityRightConfirmPasswordAction(){
       
        
        // ----> if false
        if confirmPasswordTextField.isSecureTextEntry == false {
            
            confirmPasswordTextField.isSecureTextEntry = true
            rightConfirmPasswordTextFieldBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
            // ----> if true
        }else{
            
            confirmPasswordTextField.isSecureTextEntry = false
            rightConfirmPasswordTextFieldBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
    
    
    
    
    
    
    //MARK: - Helper Function
    
    //----> edit for the navigation // NOTE : we don't use the navigation but we use the title---> change the UI
    private func configureNavigation(){
        
        title = "Login"
        navigationController?.navigationBar.isHidden = true
        
        //----> func when load the page the UI will be ---< Login
        loginPageSetUp(title: "Login", hidden: true, markText: "I Don't Have an account ?", btnTitle:"Login", loginLabel: "SignUp?")
        
    }
    
    
    // func gesture the label Login
    private func gestureLogin(){
        
        // -----> to be clickable
        loginLabel.isUserInteractionEnabled = true
        
        // ----> add the gesture to login Label
        loginLabel.addGestureRecognizer(gesture)
        
        // ----> add Action of gestue
        gesture.addTarget(self, action: #selector(loginGestureAction))
    }
    
    
    
    //MARK: - go to chatApp
    private func goingToChatsApplication(){
        
        // ---> the SCBaseTabBarController is --> mother of all viewController
        let goingChats = SCBaseTabBarController()
        goingChats.modalPresentationStyle = .fullScreen
        present(goingChats, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - View Shadow constrains
    

    private func configureEmailTextFieldView(){
        // ----> add shadowView to the view.self
        view.addSubview(emailTextFieldView)
        
        // ----> add shadowView Constrains to the view.self
        NSLayoutConstraint.activate([
            emailTextFieldView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailTextFieldView.heightAnchor.constraint(equalToConstant: 1.5),
            emailTextFieldView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailTextFieldView.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])
    }
    
    
    private func configurePasswordTextField(){
        
        // ----> add shadowView to the view.self
        view.addSubview(passwordTextFieldView)
        
        // ----> add shadowView Constrains to the view.self
        NSLayoutConstraint.activate([
            passwordTextFieldView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordTextFieldView.heightAnchor.constraint(equalToConstant: 1.5),
            passwordTextFieldView.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordTextFieldView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
    }
    
    
    
    private func configureConfirmPasswordTextField(){
        
        // ----> add shadowView to the view.self
        view.addSubview(confirmPasswordTextFieldView)
        
        // ----> add shadowView Constrains to the view.self
        NSLayoutConstraint.activate([
            confirmPasswordTextFieldView.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor),
            confirmPasswordTextFieldView.heightAnchor.constraint(equalToConstant: 1.5),
            confirmPasswordTextFieldView.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            confirmPasswordTextFieldView.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor)
        ])
    }
    
    
    
    
    
    //MARK: - UI Update
    
    private func hideTextLabels(){
        
        emailLabel.text = ""
        passwordLabel.text = ""
        confirmPasswordLabel.text = ""
    }
    
    
    private func upDataUILoginPage(){
        
        if title == "Register"{
            loginPageSetUp(title: "Login", hidden: true, markText: "I Don't Have an account ?", btnTitle:"Login", loginLabel: "SignUp?")
        }else if title == "Login"{
            loginPageSetUp(title: "Register", hidden: false, markText: "I Have an account ?", btnTitle: "SignUP", loginLabel: "LogIn?")
        }
    }
    
    
    private func loginPageSetUp(title: String ,hidden: Bool, markText: String ,btnTitle: String , loginLabel: String){
        
        self.title  = title
        self.confirmPasswordLabel.isHidden = hidden
        self.confirmPasswordTextField.isHidden  = hidden
        self.confirmPasswordTextFieldView.isHidden = hidden
        self.markLabel.text = markText
        self.loginLabel.text = loginLabel
        self.signUpBtnPressed.setTitle(btnTitle, for: .normal)
    }
    
    
    
    
    
    
    //MARK: - textField UI
    
    private func configureEmailTextFieldViews(){
        
        emailTextField.leftView = emailTextFieldBtn
        emailTextField.addSubview(emailTextFieldBtn)
        emailTextField.leftViewMode = .always
    }
    
    
    
    private func configurePasswordTextFieldViews(){
        
        passwordTextField.rightView = rightPasswordTextFieldBtn
        passwordTextField.addSubview(rightPasswordTextFieldBtn)
        passwordTextField.rightViewMode = .always
        
        passwordTextField.leftView = leftPasswordTextFieldBtn
        passwordTextField.addSubview(leftPasswordTextFieldBtn)
        passwordTextField.leftViewMode = .always
        
    }
    
    
    
    private func configureConfirmPasswordTextFieldViews(){
        
        confirmPasswordTextField.rightView = rightConfirmPasswordTextFieldBtn
        confirmPasswordTextField.addSubview(rightConfirmPasswordTextFieldBtn)
        confirmPasswordTextField.rightViewMode = .always
        
        confirmPasswordTextField.leftView = leftConfirmPasswordTextFieldBtn
        confirmPasswordTextField.addSubview(leftConfirmPasswordTextFieldBtn)
        confirmPasswordTextField.leftViewMode = .always

    }
    
    
    
    
    //MARK: - Validation If the textField
    
    private func configureValidationTextField(){
        if title == "Register"{
            
            if emailTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true || confirmPasswordTextField.text?.isEmpty == true {
                ProgressHUD.showError("Data is Empty")
            }
            
            if passwordTextField.text != confirmPasswordTextField.text {
                ProgressHUD.showError("confirm password is false")
            }
        }else if title == "Login"{
            if emailTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
                ProgressHUD.showError("Data is Empty")
            }
        }
    }
    
    
    
    
    //MARK: - EmitterUi Animation
    
    
    private func configureCEmitterCell(){
        
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: view.center.x, y: -200)

        let cell = CAEmitterCell()
        cell.scale = 0.005
        cell.emissionRange = .pi * 2
        cell.lifetime = 20
        cell.birthRate = 100
        cell.velocity =  50
        cell.color = UIColor.label.cgColor
        cell.contents = UIImage(named: "image")!.cgImage
        
        layer.emitterCells = [cell]
        view.layer.addSublayer(layer)
        
    }
    
    
    
    
    //MARK: - Login Firebase
    
    private func configureLoginFirebase(){
        if emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false {

            FUserListener.shared.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
                
                if error == nil {
                    if isEmailVerified! {
                        
                        // ToDo Going to the chats Application
                        ProgressHUD.showSucceed("Succeed !")
                        self.goingToChatsApplication()
                    }else {
                        ProgressHUD.showError("Please check your email and verify your registration")
                    }
                    
          
                }else{
                    ProgressHUD.showFailed(error!.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    //MARK: - Register Firebase
    //Register
    private func configureRegisterFirebase(){
        
        if passwordTextField.text! == confirmPasswordTextField.text!{
            FUserListener.shared.registerUser(email: emailTextField.text!, password: passwordTextField.text!) { authResults,error in
                
                if error == nil{
                    ProgressHUD.showSuccess("Please check your email and verify your registration")
                }else{
                    ProgressHUD.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    
    
        
    
    //MARK: - forget password firebase
    
    private func         resendForgetVarificationPassword(){
        
        FUserListener.shared.resetPasswordEmail(email: emailTextField.text!) { error in
            if error == nil {
                
                ProgressHUD.showSucceed("Please check your email and reset Password")
            }else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    
}


//MARK: - Extension
extension SCLoginPageVC: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        emailLabel.text = emailTextField.hasText ? "Email" : ""
        passwordLabel.text = passwordTextField.hasText ? "Password" : ""
        confirmPasswordLabel.text = confirmPasswordTextField.hasText ? "Confirm Password" : ""
        emailTextFieldView.backgroundColor = emailTextField.hasText ? .black : .white
        passwordTextFieldView.backgroundColor = passwordTextField.hasText ? .black : .white
        confirmPasswordTextFieldView.backgroundColor = confirmPasswordTextField.hasText ? .black : .white
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
