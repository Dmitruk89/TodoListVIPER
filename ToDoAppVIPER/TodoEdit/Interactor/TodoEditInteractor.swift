//
//  TodoEditInteractor.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//

protocol TodoEditInteractorInput: AnyObject {}

protocol TodoEditInteractorOutput: AnyObject {}

final class TodoEditInteractor: TodoEditInteractorInput {
    weak var output: TodoEditInteractorOutput?
}
