//
//  modelCloudKit.swift
//  estudandoCloudKit
//
//  Created by José João Silva Nunes Alves on 19/10/20.
//

import Foundation
import CloudKit

class ModelCloudKit {
    let container: CKContainer
    let publicDatabase: CKDatabase
    
    static var currentModel = ModelCloudKit()
    
    init() {
        self.container = CKContainer.default()
        self.publicDatabase = container.publicCloudDatabase
    }
    
    func createNewRecord() {
        let aluno = CKRecord(recordType: "Alunos")
        aluno["Nome"] = "Ze Jao"
        aluno["Numero"] = 10
        
        self.container.privateCloudDatabase.save(aluno) { (record, erro) in
            print(record, erro)
        }
    }
    
    func editRecord(aluno: CKRecord) {
        aluno["Numero"] = 1
        
        self.container.privateCloudDatabase.save(aluno) { (record, erro) in
            print(record, erro)
        }
    }

    func delete(aluno: CKRecord.ID) {

        self.container.privateCloudDatabase.delete(withRecordID: aluno) { (record, erro) in
            print(record, erro)
        }
    }
    
    func fetchPrivateDB(_ completion: @escaping (CKRecord) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Alunos", predicate: predicate)
        
        let operation = CKQueryOperation(query: query)
        operation.zoneID = CKRecordZone.default().zoneID
        operation.recordFetchedBlock = { record in
            completion(record)
        }
        
        self.container.privateCloudDatabase.add(operation)
    }
    
//    func addSub() {
//        let sub = CKSubscription(coder: NSCoder())
//
//    }

    func fetchAlunos(_ completion: @escaping (Result<[Alunos], Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Alunos", predicate: predicate)
        
        self.publicDatabase.perform(query, inZoneWith: CKRecordZone.default().zoneID) { (results, error) in
            if let erro = error {
                DispatchQueue.main.async {
                    completion(.failure(erro))
                }
            }
            
            guard let result = results else {return}
            
            let alunos = result.compactMap {
                Alunos(record: $0)
            }
            
            DispatchQueue.main.async {
                completion(.success(alunos))
            }
        }
    }
}
