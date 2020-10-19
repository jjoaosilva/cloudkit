//
//  ViewController.swift
//  estudandoCloudKit
//
//  Created by José João Silva Nunes Alves on 19/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    var alunos: [Alunos] = [Alunos]() {
        didSet{
            DispatchQueue.main.async {
                for aluno in self.alunos {
                    print("Aluno: \(aluno.nome),Numero: \(aluno.numero)")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAlunos()
        // Do any additional setup after loading the view.
    }
    
    func getAlunos() {
        ModelCloudKit.currentModel.fetchAlunos({ response in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let data):
                self.alunos = data
            }
        })
    }


}

