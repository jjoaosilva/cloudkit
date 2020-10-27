//
//  Alunos.swift
//  estudandoCloudKit
//
//  Created by José João Silva Nunes Alves on 19/10/20.
//

import Foundation
import CloudKit


class Alunos {
    static let recordType = "Alunos"
    let id: CKRecord.ID
    
    let nome: String?
    let numero: Int?
    
    init(record: CKRecord) {
        self.id = record.recordID
        
        if let nome = record["Nome"] as? String, let numero = record["Numero"] as? Int {
            self.nome  = nome
            self.numero = numero
        } else {
            self.nome  = nil
            self.numero = nil
        }
    }
}
