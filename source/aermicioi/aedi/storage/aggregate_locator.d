/**

License:
	Boost Software License - Version 1.0 - August 17th, 2003
    
    Permission is hereby granted, free of charge, to any person or organization
    obtaining a copy of the software and accompanying documentation covered by
    this license (the "Software") to use, reproduce, display, distribute,
    execute, and transmit the Software, and to prepare derivative works of the
    Software, and to permit third-parties to whom the Software is furnished to
    do so, all subject to the following:
    
    The copyright notices in the Software and this entire statement, including
    the above license grant, this restriction and the following disclaimer,
    must be included in all copies of the Software, in whole or in part, and
    all derivative works of the Software, unless such copies or derivative
    works are solely in the form of machine-executable object code generated by
    a source language processor.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
    SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
    FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

Authors:
	Alexandru Ermicioi
**/
module aermicioi.aedi.storage.aggregate_locator;

import aermicioi.aedi.storage.locator;
import aermicioi.aedi.exception.not_found_exception;
import std.conv : to;

/**
An implementation of AggregateLocator.
**/
class AggregateLocatorImpl(Type = Object, KeyType = string, LocatorKeyType = KeyType) : AggregateLocator!(Type, KeyType, LocatorKeyType) {
    
    private {
        
        Locator!(Type, KeyType)[LocatorKeyType] locators;
    }
    
    public {
        
        /**
        Add a Locator by key.
        
        Params:
        	key = key by which to identify the locator.
        	locator = the Locator that will be added to AggregateLocator
        **/
        void add(LocatorKeyType key, Locator!(Type, KeyType) locator) {
            
            this.locators[key] = locator;
        }
        
        /**
        Removes a Locator by key.
        
        Params:
        	key = the identity of locator that should be removed.
        **/
        void remove(LocatorKeyType key) {
            
            this.locators.remove(key);
        }
        
        /**
		Get an Type that is associated with key.
		
		Params:
			identity = the element id.
			
		Throws:
			NotFoundException in case if the element wasn't found.
		
		Returns:
			Type element if it is available.
		**/
        Type get(KeyType identity) {
            
            foreach (locator; this.locators) {
                
                if (locator.has(identity)) {
                    return locator.get(identity);
                }
            }
            
            throw new NotFoundException("Could not find an object with " ~ identity.to!string ~ " identity.");
        }
        
        /**
        Check if an element is present in Locator by key id.
        
        Note:
        	This check should be done for elements that locator actually contains, and
        	not in chained locator (when locator is also a DelegatingLocator) for example.
        Params:
        	identity = identity of element.
        	
    	Returns:
    		bool true if an element by key is present in Locator.
        **/
        bool has(KeyType identity) inout {
            
            foreach (locator; this.locators) {
                
                if (locator.has(identity)) {
                    return true;
                }
            }
            
            return false;
        }
    }
}