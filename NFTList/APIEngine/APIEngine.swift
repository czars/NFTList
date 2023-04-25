//
//  APIEngine.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/18.
//

import Foundation
import RxSwift
import Alamofire

class APIEngine {
    func sendingRequest<T: Codable>(request: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            
            let encoding: ParameterEncoding = request.method == .get ? URLEncoding.default : JSONEncoding.default
            let apiRequest = AF.request(
                request.path,
                method: request.method,
                parameters: request.parameters,
                encoding: encoding).responseDecodable { (response: DataResponse<T, AFError>) in
                    switch response.result {
                    case let .success(value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case let .failure(error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                apiRequest.cancel()
            }
        }
        
    }
}
