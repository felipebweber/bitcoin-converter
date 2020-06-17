// MARK: - Mocks generated from file: bitcoin-converter/Model/CoinManager.swift at 2020-06-17 00:28:38 +0000

//
//  CoinManager.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Cuckoo
@testable import bitcoin_converter

import CoreData
import Foundation
import UIKit


 class MockCoinManagerDelegate: CoinManagerDelegate, Cuckoo.ProtocolMock {
    
     typealias MocksType = CoinManagerDelegate
    
     typealias Stubbing = __StubbingProxy_CoinManagerDelegate
     typealias Verification = __VerificationProxy_CoinManagerDelegate

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CoinManagerDelegate?

     func enableDefaultImplementation(_ stub: CoinManagerDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func didUpdateFail()  {
        
    return cuckoo_manager.call("didUpdateFail()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didUpdateFail())
        
    }
    
    
    
     func didUpdateData()  {
        
    return cuckoo_manager.call("didUpdateData()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.didUpdateData())
        
    }
    

	 struct __StubbingProxy_CoinManagerDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func didUpdateFail() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCoinManagerDelegate.self, method: "didUpdateFail()", parameterMatchers: matchers))
	    }
	    
	    func didUpdateData() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCoinManagerDelegate.self, method: "didUpdateData()", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_CoinManagerDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func didUpdateFail() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("didUpdateFail()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func didUpdateData() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("didUpdateData()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class CoinManagerDelegateStub: CoinManagerDelegate {
    

    

    
     func didUpdateFail()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func didUpdateData()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

