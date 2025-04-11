//
//  ApiCalls.swift
//
//
//  Created by Jamaluddin Syed on 9/14/23.
//

import Foundation
import Alamofire
import AdSupport

class ApiCalls {
    
    static let sharedCall = ApiCalls()
    
    func categoryListCall(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_CATEGORY_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func addCategoryCall(title: String, description: String, merchant_id: String, admin_id: String,
                         collId: String, cat_show_status: String, use_point: String, earn_point: String,
                         is_lottery: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.INVENTORY_ADD_CATEGORY
        
        let parameters: [String:Any] = [
            "title": title,
            "description": description,
            "merchant_id": merchant_id,
            "collID": collId,
            "admin_id": admin_id,
            "cat_show_status": cat_show_status,
            "use_point": use_point,
            "earn_point": earn_point,
            "is_lottery": is_lottery]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func categoryListById(id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_CATEGORY_BY_ID
        
        let parameters: [String:Any] = [
            "id": id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: id, response: res)
            }
        }
    }
    
    func categoryDelete(id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_DELETE_CATEGORY
        
        let parameters: [String:Any] = [
            "id": id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: id, response: res)
            }
        }
    }
}


extension ApiCalls {
    
    func productListCall(id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_PRODUCT_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: id, response: res)
            }
        }
    }
    
    
    func productAddCall(id: String, title: String, description: String,
                        brand: String, tags: String, price: String,
                        compare_price: String, costperItem: String,
                        margin: String, profit: String, ischargeTax: String,
                        trackqnty: String, isstockcontinue: String,
                        quantity: String, collection: String, isvarient: String,
                        is_lottery: String,
                        created_on: String, optionarray: String,
                        optionarray1: String, optionarray2: String, optionvalue: String,
                        optionvalue1: String, optionvalue2: String,
                        other_taxes: String, bought_product: String, featured_product: String,
                        varvarient: String, varprice: String,
                        varcompareprice: String, varcostperitem: String, varquantity: String,
                        upc: String, custom_code: String, reorder_qty: String,
                        reorder_level: String, reorder_cost: String, is_tobacco: String,
                        disable: String, food_stampable: String, varupc: String, varcustomcode: String,
                        vartrackqnty: String,varcontinue_selling: String,
                        varcheckid: String, vardisable: String, varfood_stampable: String,
                        varmargin: String,varprofit: String,varreorder_qty: String,
                        varreorder_level: String, varreorder_cost: String,
                        completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.INVENTORY_PRODUCT_ADD
        
        let parameters: [String:Any] = [
            "merchant_id": id,
            "title": title,
            "description": description,
            "brand": brand,
            "tags": tags,
            "price": price,
            "compare_price": compare_price,
            "costperItem": costperItem,
            "margin": margin,
            "profit": profit,
            "ischargeTax": ischargeTax,
            "trackqnty": trackqnty,
            "isstockcontinue": isstockcontinue,
            "quantity":quantity,
            "collection":collection,
            "isvarient":isvarient,
            "is_lottery": is_lottery,
            "created_on":created_on,
            "optionarray": optionarray,
            "optionarray1" : optionarray1,
            "optionarray2": optionarray2,
            "optionvalue": optionvalue,
            "optionvalue1": optionvalue1,
            "optionvalue2": optionvalue2,
            "other_taxes": other_taxes,
            "bought_product": bought_product,
            "featured_product": featured_product,
            "varvarient": varvarient,
            "varprice": varprice,
            "varcompareprice": varcompareprice,
            "varcostperitem": varcostperitem,
            "varquantity": varquantity,
            "upc": upc,
            "custom_code": custom_code,
            "reorder_qty": reorder_qty,
            "reorder_level": reorder_level,
            "reorder_cost": reorder_cost,
            "is_tobacco": is_tobacco,
            "disable": disable,
            "food_stampable": food_stampable,
            "varupc": varupc,
            "varcustomcode": varcustomcode,
            "vartrackqnty": vartrackqnty,
            "varcontinue_selling": varcontinue_selling,
            "varcheckid": varcheckid,
            "vardisable": vardisable,
            "varfood_stampable": varfood_stampable,
            "varmargin": varmargin,
            "varprofit": varprofit,
            "varreorder_qty": varreorder_qty,
            "varreorder_level": varreorder_level,
            "varreorder_cost": varreorder_cost
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: id, response: res)
            }
        }
    }
    
    func productEditCall(merchant_id:String, admin_id: String, title:String, alternateName:String, description:String,
                         brand: String, tags: String,price:String, compare_price:String, costperItem:String,
                         margin:String, profit:String, ischargeTax:String, sku:String, upc:String,
                         custom_code:String, barcode:String, trackqnty:String, isstockcontinue:String,
                         quantity:String, ispysical_product:String, country_region:String, collection:String,
                         HS_code:String, isvarient:String, is_lottery: String, multiplefiles:String,
                         img_color_lbl:String, created_on:String, productid:String,
                         optionarray:String, optionarray1:String, optionarray2:String, optionvalue:String,
                         optionvalue1:String, optionvalue2:String, other_taxes:String, bought_product:String,
                         featured_product:String, varvarient:String, varprice:String, varquantity:String, varsku:String,
                         varbarcode:String, files:String, doc_file:String, optionid:String, varupc:String, varcustomcode:String,
                         reorder_qty:String, reorder_level:String, reorder_cost:String, is_tobacco:String, disable:String,
                         food_stampable: String, vartrackqnty:String, varcontinue_selling:String, varcheckid:String, vardisable:String,
                         varfood_stampable: String,varmargin:String, varprofit:String, varreorder_qty:String, varreorder_level:String,
                         varreorder_cost:String, varcostperitem:String, varcompareprice:String, var_id:String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_PRODUCT_EDIT
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "admin_id": admin_id,
            "title": title,
            "alternateName": alternateName,
            "description": description,
            "brand": brand,
            "tags": tags,
            "price": price,
            "compare_price": compare_price,
            "costperItem": costperItem,
            "margin": margin,
            "profit": profit,
            "ischargeTax": ischargeTax,
            "sku": sku,
            "upc": upc,
            "custom_code": custom_code,
            "barcode": barcode,
            "trackqnty": trackqnty,
            "isstockcontinue": isstockcontinue,
            "quantity": quantity,
            "ispysical_product": ispysical_product,
            "country_region": country_region,
            "collection": collection,
            "HS_code": HS_code,
            "isvarient": isvarient,
            "is_lottery": is_lottery,
            "multiplefiles": multiplefiles,
            "img_color_lbl": img_color_lbl,
            "created_on": created_on,
            "productid": productid,
            "optionarray": optionarray,
            "optionarray1": optionarray1,
            "optionarray2": optionarray2,
            "optionvalue": optionvalue,
            "optionvalue1": optionvalue1,
            "optionvalue2": optionvalue2,
            "bought_product": bought_product,
            "featured_product": featured_product,
            "varvarient": varvarient,
            "varprice": varprice,
            "varquantity": varquantity,
            "varsku": varsku,
            "varbarcode": varbarcode,
            "files": files,
            "doc_file": doc_file,
            "optionid": optionid,
            "other_taxes": other_taxes,
            "varupc": varupc,
            "reorder_qty": reorder_qty,
            "reorder_level": reorder_level,
            "reorder_cost": reorder_cost,
            "is_tobacco": is_tobacco,
            "disable": disable,
            "food_stampable": food_stampable,
            "varcustomcode": varcustomcode,
            "vartrackqnty": vartrackqnty,
            "varcontinue_selling": varcontinue_selling,
            "varcheckid": varcheckid,
            "vardisable": vardisable,
            "varfood_stampable": varfood_stampable,
            "varmargin": varmargin,
            "varprofit": varprofit,
            "varreorder_qty": varreorder_qty,
            "varreorder_level": varreorder_level,
            "varreorder_cost": varreorder_cost,
            "varcostperitem": varcostperitem,
            "varcompareprice": varcompareprice,
            "var_id": var_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func productDuplicateProduct(merchant_id:String, admin_id: String, title:String, alternateName:String,
                                 description:String, brand: String, tags: String, price:String,
                                 compare_price:String, costperItem:String, margin:String,
                                 profit:String, ischargeTax:String, sku:String, upc:String, custom_code:String,
                                 barcode:String, trackqnty:String, isstockcontinue:String, quantity:String,
                                 ispysical_product:String, country_region:String, collection:String,
                                 HS_code:String, isvarient:String, is_lottery: String, multiplefiles:String,
                                 img_color_lbl:String, created_on:String,
                                 productid:String, optionarray:String, optionarray1:String,
                                 optionarray2:String, optionvalue:String, optionvalue1:String,
                                 optionvalue2:String, other_taxes:String, bought_product:String,
                                 featured_product:String, varvarient:String, varprice:String,
                                 varquantity:String, varsku: String, varbarcode:String,
                                 files:String, doc_file:String, optionid:String, varupc: String,
                                 varcustomcode:String, reorder_qty:String, reorder_level:String,
                                 reorder_cost:String, is_tobacco: String, disable:String,
                                 food_stampable: String, vartrackqnty:String, varcontinue_selling:String,
                                 varcheckid: String, vardisable:String, varfood_stampable: String,
                                 varmargin:String, varprofit:String, varreorder_qty:String,
                                 varreorder_level:String, varreorder_cost:String, varcostperitem:String,
                                 varcompareprice:String, var_id:String, completion:@escaping(Bool,[String:Any])-> ()) {
        
        let url = AppURLs.INVENTORY_PRODUCT_DUPLICATE
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "admin_id": admin_id,
            "title": title,
            "alternateName": alternateName,
            "description": description,
            "brand": brand,
            "tags": tags,
            "price": price,
            "compare_price": compare_price,
            "costperItem": costperItem,
            "margin": margin,
            "profit": profit,
            "ischargeTax": ischargeTax,
            "sku": sku,
            "upc": upc,
            "custom_code": custom_code,
            "barcode": barcode,
            "trackqnty": trackqnty,
            "isstockcontinue": isstockcontinue,
            "quantity": quantity,
            "ispysical_product": ispysical_product,
            "country_region": country_region,
            "collection": collection,
            "HS_code": HS_code,
            "isvarient": isvarient,
            "is_lottery": is_lottery,
            "multiplefiles": multiplefiles,
            "img_color_lbl": img_color_lbl,
            "created_on": created_on,
            "productid": productid,
            "optionarray": optionarray,
            "optionarray1": optionarray1,
            "optionarray2": optionarray2,
            "optionvalue": optionvalue,
            "optionvalue1": optionvalue1,
            "optionvalue2": optionvalue2,
            "bought_product": bought_product,
            "featured_product": featured_product,
            "varvarient": varvarient,
            "varprice": varprice,
            "varquantity": varquantity,
            "varsku": varsku,
            "varbarcode": varbarcode,
            "files": files,
            "doc_file": doc_file,
            "optionid": optionid,
            "other_taxes": other_taxes,
            "varupc": varupc,
            "reorder_qty": reorder_qty,
            "reorder_level": reorder_level,
            "reorder_cost": reorder_cost,
            "is_tobacco": is_tobacco,
            "disable": disable,
            "food_stampable": food_stampable,
            "varcustomcode": varcustomcode,
            "vartrackqnty": vartrackqnty,
            "varcontinue_selling": varcontinue_selling,
            "varcheckid": varcheckid,
            "vardisable": vardisable,
            "varfood_stampable": varfood_stampable,
            "varmargin": varmargin,
            "varprofit": varprofit,
            "varreorder_qty": varreorder_qty,
            "varreorder_level": varreorder_level,
            "varreorder_cost": varreorder_cost,
            "varcostperitem": varcostperitem,
            "varcompareprice": varcompareprice,
            "var_id": var_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
        
        
    }
    
    func productUpdateStatus(product_id: String, status: String, merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_UPDATE_STATUS
        
        let parameters: [String:Any] = [
            "product_id": product_id,
            "status": status,
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func productById(product_id: String, merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_PRODUCT_BY_ID
        
        let parameters: [String:Any] = [
            "id": product_id,
            "merchant_id": merchant_id
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func productDeleteCall(product_id: String, id: String,
                           completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.INVENTORY_PRODUCT_DELETE
        
        let parameters: [String:Any] = [
            "id": product_id,
            "merchant_id": id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: id, response: res)
            }
        }
    }
    
    func productTaxList(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.TAX_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func inventorySettingCall(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.INVENTORY_SETTINGS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
}

extension ApiCalls {
    
    
    func attributeListCall(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_ATTRIBUTE_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func addAttributeCall(merchant_id: String, varient_id: String, title: String,
                          old_title: String, admin_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_ADD_ATTRIBUTE
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "varient_id": varient_id,
            "title": title,
            "old_title": old_title,
            "admin_id": admin_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true, json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    func passCodeCall(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url =  AppURLs.PASSCODE_LOGIN
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch let error as NSError {
                    print(error)
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                    self.showAlert(title: "Alert", message: "Something went wrong. Please try again")
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
                self.showAlert(title: "Alert", message: "Something went wrong. Please try again")
            }
        }
    }
    
    func logErrorApi(merchant_id: String, response: String) {
        
        let url =  AppURLs.LOGURL
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        
        let comparisonDateString = "2025-04-20 00:00:00"
        
        if let comparisonDate = dateFormatter.date(from: comparisonDateString) {
            // Compare the current date with April 15, 2025
            if currentDate > comparisonDate {
                print("The current date is greater than April 15, 2025.")
            } else {
                print("The current date is not greater than April 15, 2025.")
                
                let parameters: [String:Any] = [
                    "merchant_id": merchant_id,
                    "adv_id": ASIdentifierManager.shared().advertisingIdentifier.uuidString,
                    "datetime": "\(formattedDate)",
                    "source": response
                ]
                
                
                AF.request(url, method: .post, parameters: parameters).responseData { response in
                    
                    switch response.result {
                        
                    case .success(_):
                        do {
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                            
                        }
                        catch let error as NSError {
                            print(error)
                            self.showAlert(title: "Alert", message: "Something went wrong. Please try again")
                        }
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.showAlert(title: "Alert", message: "Something went wrong. Please try again")
                    }
                }
            }
        }else {
            print("Error: Could not parse comparison date.")
        }
    }
    
    func showAlert(title: String, message: String) {
        
        ToastClass.sharedToast.showToast(message: "Something went wrong. Please try again",
                                         font: UIFont(name: "Manrope-SemiBold", size: 14.0)!)
    }
}

extension ApiCalls {
    
    
    func variantListCall(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_VARIANT_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func variantById(var_id: String, name: String, single: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.INVENTORY_VARIANT_BY_ID
        
        let parameters: [String:Any] = [
            "id": var_id,
            "product_name": name,
            "single_product": single
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: "", response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: "", response: res)
            }
        }
    }
    
    
    func variantUpdateCall(var_id: String, name: String, single: String, price: String,compare_price: String,
                           costperItem: String, margin: String, profit: String, quantity: String,
                           upc: String, custom_code: String, reorder_qty: String, reorder_level: String,
                           reorder_cost: String, track_quantity: String, continue_selling: String,
                           checkid: String, disable: String, food_stampable: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.INVENTORY_VARIANT_UPDATE
        
        let parameters: [String:Any] = [
            "id": var_id,
            "product_name": name,
            "single_product": single,
            "price": price,
            "compare_price": compare_price,
            "costperItem": costperItem,
            "margin": margin,
            "profit": profit,
            "quantity": quantity,
            "upc": upc,
            "custom_code": custom_code,
            "reorder_qty": reorder_qty,
            "reorder_level": reorder_level,
            "reorder_cost": reorder_cost,
            "track_quantity": track_quantity,
            "continue_selling": continue_selling,
            "checkid": checkid,
            "disable": disable,
            "food_stampable": food_stampable
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: "", response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: "", response: res)
            }
        }
    }
    
    func variantSavePO(merchant_id: String, product_id: String, variant_id: String, description: String, qty: String,
                       price: String, emp_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.INVENTORY_SAVE_INSTANT_PO
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "product_id": product_id,
            "variant_id": variant_id,
            "description": description,
            "qty": qty,
            "price": price,
            "emp_id": emp_id
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}


extension ApiCalls {
    
    func SyncDataCall(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.INVENTORY_SYNC_DATA
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    func salesHistoryCall(merchant_id: String, product_id : String, variant_id :String , admin_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.SALES_HISTORY
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ,
            "product_id" :product_id  ,
            "variant_id" : variant_id,
            "admin_id" : merchant_id
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
        }
    }
}

extension ApiCalls {
    
    func addBulkPricingApiCall(merchant_id: String, product_id: String, variant_id: String,
                               admin_id: String, bulk_price_tittle: String,bulk_price: String, bulk_qty:String ,
                               is_percentage : String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ADD_BULK_PRICING
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ,
            "product_id" :product_id  ,
            "variant_id" :  variant_id,
            "admin_id" : merchant_id ,
            "bulk_price_tittle" :bulk_price_tittle ,
            "bulk_price" :bulk_price,
            "bulk_qty" :bulk_qty,
            "is_percentage" :is_percentage
        ]
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
        }
    }
    
    func getBulkPricingApiCall(merchant_id: String, bulk_pricing_id : String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.GET_BULK_PRICING
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ,
            "bulk_pricing_id" :bulk_pricing_id
        ]
        
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
        }
    }
    
    func deleteBulkPricingApiCall(id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.DELETE_BULK_PRICING
        
        let parameters: [String:Any] = [
            "id": id
        ]
        
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: id, response: res)
            }
            
        }
    }
    
    
    func updateBulkPricingApiCall(merchant_id: String, bulk_pricing_id: String, product_id: String, is_variant : String,
                                  variant_id: String, bulk_price_title: String,
                                  bulk_qty: String, bulk_price: String, is_percentage: String,
                                  completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.UPDATE_BULK_PRICING
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "bulk_pricing_id" : bulk_pricing_id,
            "product_id" : product_id,
            "is_variant" : is_variant,
            "variant_id" : variant_id,
            "bulk_price_tittle" : bulk_price_title,
            "bulk_qty" : bulk_qty,
            "bulk_price" : bulk_price,
            "is_percentage" : is_percentage
        ]
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
        }
    }
}
// purchase Qty

extension ApiCalls {
    
    func addPurchaseQtyApiCall(merchant_id: String, product_id: String, variant_id: String,
                               is_variant: String, purchase_qty: String,completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ADD_PURCHASE_QUANTITY
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ,
            "product_id" :product_id  ,
            "variant_id" :  variant_id,
            "is_variant" : is_variant ,
            "purchase_qty" : purchase_qty
            
            
        ]
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
        }
    }
    
}

extension ApiCalls {
    
    func getOrderList(merchant_id: String, order_list_type: String, order_status: String,
                      order_0: String, order_1: String, start_date: String, end_date: String,
                      min_amt: String, max_amt: String, search_value: String, paid: Int,
                      page_no: Int, limit: Int, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.ORDERS_LIST
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "order_list_type": order_list_type,
         "order_type[0]": order_0,
         "order_type[1]": order_1,
         "start_date": start_date,
         "end_date": end_date,
         "min_amt": min_amt,
         "max_amt": max_amt,
         "search_value": search_value,
         "order_status": order_status,
         "is_paid": paid,
         "page_no": page_no,
         "limit": limit]
        
        
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
                
            }
        }
    }
    
    func getOrderList(merchant_id: String, order_list_type: String,
                      page_no: Int, limit: Int,
                      completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.ORDERS_LIST
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "order_list_type": order_list_type,
         "page_no": page_no,
         "limit": limit]
        
        
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func getOrderList(merchant_id: String, order_list_type: String, order_status: String, paid: Int,
                      completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.ORDERS_LIST
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "order_list_type": order_list_type,
         "order_status": order_status,
         "is_paid": paid]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
                
            }
        }
    }
    
    func getOrderListStore(merchant_id: String, order_list_type: String, order_status: String, paid: Int, search: String,
                           completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.ORDERS_LIST
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "order_list_type": order_list_type,
         "order_status": order_status,
         "is_paid": paid,
         "search_value": search]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func getOrderDetails(merchant_id: String, order_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ORDER_DETAILS
        
        let parameters : [String: Any] = [
            "merchant_id": merchant_id,
            "order_id" : order_id
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func getOrderStatus(merchant_id: String, order_id: String, status: String,
                        completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.ORDERS_STATUS
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "order_id": order_id,
         "status": status
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    
    func newOrderCount(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.NEW_ORDERS_COUNT
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
}



extension ApiCalls {
    
    
    func setFcmToken(merchant_id: String, adv_id: String, fcm_token: String,
                     completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.FCM_TOKEN
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "adv_id": adv_id,
         "fcm_token":  fcm_token
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    
    func getLoyaltyProgramList(merchant_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.LOYALTY_LIST
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func updateLoyaltyProgram(merchant_id: String, admin_id: String,
                              current_points: String, points_per_dollar: String, redemption_value: String,
                              min_points_redemption: String, enable_loyalty: String, enable_promotion_id: String,
                              completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.UPDATE_LOYALTY_PROGRAM
        
        let parameters : [String: Any] = [
            
            "merchant_id": merchant_id,
            "admin_id": admin_id,
            "enable_loyalty": enable_loyalty,
            "current_points": current_points,
            "points_per_dollar": points_per_dollar,
            "redemption_value": redemption_value,
            "min_points_redemption": min_points_redemption,
            "enable_promotion_id": enable_promotion_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func getBonusById(merchant_id: String, promotion_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.BONUS_BY_ID
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "promotion_id": promotion_id
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func updateBonus(merchant_id: String, promotion_id: String, admin_id: String, enable_promotion: String,
                     current_points: String, promotion_name: String, bonus_points: String,
                     start_date: String, end_date: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.BONUS_UPDATE
        
        let parameters : [String: Any] = [
            "promotion_id": promotion_id,
            "merchant_id": merchant_id,
            "admin_id": admin_id,
            "enable_promotion": enable_promotion,
            "current_points": current_points,
            "promotion_name": promotion_name,
            "bonus_points": bonus_points,
            "start_date": start_date,
            "end_date": end_date
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func deleteBonusPoint(merchant_id: String, promotion_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.DELETE_BONUS
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "promotion_id": promotion_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    
    func setRegisterSettings(merchant_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.SET_REGISTER_SETTINGS
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func updateRegisterSettings(merchant_id: String, regi_setting: String, idel_logout: String,
                                ebt: String, cbenable: String,
                                cblimit: String, cbcharge: String,
                                barcode_msg: String,
                                completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.UPDATE_REGISTER_SETTINGS
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "regi_setting": regi_setting,
         "idel_logout": idel_logout,
         "return_window": "",
         "discount_prompt": "",
         "round_invoice": "",
         "customer_loyalty": "",
         "ebt": ebt,
         "enable_cashback_limit": cbenable,
         "cashback_limit_amount": cblimit,
         "cashback_charge_amount": cbcharge,
         "barcode_msg": barcode_msg
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func checkEndShift(merchant_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.CHECK_END_SHIFT
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    func updateSystemAccess(merchant_id: String, default_cash_drawer: String, clock_in: String, hide_inactive: String,
                            end_day_Allow: String, shift_assign: String,
                            start_date: String, end_date: String, start_time: String, end_time: String,
                            adv_id: String, station_name: String, no_of_station: String,
                            denomination: Int, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.UPDATE_SYSTEM_ACCESS
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "default_cash_drawer": default_cash_drawer,
         "end_day_Allow": end_day_Allow,
         "shift_assign": shift_assign,
         "start_date": start_date,
         "end_date": end_date,
         "start_time": start_time,
         "end_time": end_time,
         "adv_id": adv_id,
         "station_name": station_name,
         "no_of_station": no_of_station,
         "denomination": denomination
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    
    func getEmpList(merchant_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.EMPLOYEE_LIST
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func getEmpById(merchant_id: String, emp_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.EMPLOYEE_BY_ID
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "employee_id": emp_id
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func addEditEmployee(merchant_id: String, admin_id: String, employee_id: String,
                         f_name: String, l_name: String, role:String, pin:String, permissions:String,
                         break_allowed:String, break_time:String, paid_breaks:String, status:String,
                         completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.ADD_EMPLOYEE
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "admin_id": admin_id,
         "employee_id": employee_id,
         "f_name": f_name,
         "l_name": l_name,
         "role": role,
         "pin": pin,
         "permissions": permissions,
         "break_allowed": break_allowed,
         "break_time": break_time,
         "paid_breaks": paid_breaks,
         "status": status
        ]
        
        print(parameters)
        print(parameters)
        
        
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func deleteEmployee(merchant_id: String, emp_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.DELETE_EMPLOYEE
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id,
         "employee_id": emp_id
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}


extension ApiCalls {
    
    func mixnMatchList(merchant_id: String, completion: @escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.MIX_N_MATCH_PRICING_LIST
        
        let parameters : [String: Any] =
        
        ["merchant_id": merchant_id]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseData { (response) in
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    
    func addMixnMatchPricingApiCall(merchant_id: String, items_id: String, deal_name: String,
                                    min_qty: String, is_percent:String ,
                                    discount : String, is_enable: String, description: String , mix_id: String ,completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ADD_MIX_N_MATCH_PRICING
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ,
            "items_id" :items_id  ,
            "deal_name" :  deal_name,
            "min_qty" :min_qty ,
            "is_percent" :is_percent,
            "discount" :discount,
            "is_enable" :is_enable,
            "description" : description,
            "mix_id":mix_id
        ]
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func enableMixnMatch(merchant_id: String, mix_id: String, is_enable: String,
                         completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ENABLE_MIX_N_MATCH_PRICING
        
        let parameters : [String: Any] = [
            "merchant_id":merchant_id,
            "mix_id": mix_id,
            "is_enable": is_enable
        ]
        print(parameters)
        print(parameters)
        
        AF.request(url,method: .post ,parameters: parameters).response{ response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!,options: []) as! [String: Any]
                    print(json)
                    completion(true,json)
                }
                catch{
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
            
        }
        
    }
    
    
    
    
    
    func deleteMixnMatchApiCall(merchant_id: String, mix_id: String ,completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.DELETE_MIX_N_MATCH_PRICING
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ,
            "mix_id":mix_id
        ]
        print(parameters)
        
        AF.request(url,method: .post,parameters: parameters).responseData {response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options:[]) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
            
        }
        
    }
}


extension ApiCalls {
    
    func setInventorySetup(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.SETUP_INVENTORY
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
        }
    }
    
    func updateInventorySetup(merchant_id: String, cost_method: String,
                              by_scanning: String, age_verify: String,
                              inv_setting: String, cost_per: String,
                              completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.UPDATE_SETUP_INVENTORY
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "cost_method": cost_method,
            "by_scanning": by_scanning,
            "age_verify": age_verify,
            "inv_setting": inv_setting,
            "cost_per": cost_per
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    
    func getBrandsTags(merchant_id: String, type: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.GET_BRANDS_TAGS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "type": type
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func brandsTagsAdd(merchant_id: String, type: String, title: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ADD_BRANDS_TAGS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "type": type,
            "title": title
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func brandsTagsUpdate(merchant_id: String, title: String, type: String, id: String,
                          old_title: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.UPDATE_BRANDS_TAGS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "title": title,
            "type": type,
            "id": id,
            "old_title": old_title
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func brandsTagsDelete(merchant_id: String, type: String, id: String, title: String,
                          completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.DELETE_BRANDS_TAGS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "type": type,
            "id": id,
            "title": title
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    func getCustomers(merchant_id: String, page_no: Int,limit: Int, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.CUSTOMERS_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "page_no": page_no,
            "limit": limit
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func findCustomers(merchant_id: String,email: String,phone_no: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.FIND_CUSTOMER
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "email":email,
            "phone_no" : phone_no
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    
    
    func addCustomersAPICall(merchant_id: String,fname: String,lname: String,
                             email: String,phone_no: String,address_line_1: String,
                             address_line_2: String,state: String,
                             city: String,pincode: String,dob: String,notes: String,
                             customer_id: String, order_id: String,note: String,
                             completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.ADD_CUSTOMERS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "fname": fname,
            "lname": lname,
            "email": email,
            "phone_no" : phone_no,
            "address_line_1" : address_line_1,
            "address_line_2" :address_line_2,
            "city" : city,
            "state": state,
            "dob" : dob,
            "notes": notes,
            "customer_id": customer_id,
            "order_id": order_id,
            "pincode"  :pincode,
            "note": note,
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                    
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func deleteCustomers(merchant_id: String,customer_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.DELETE_CUSTOMERS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "customer_id": customer_id,
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    
    func disableCustomers(merchant_id: String,customer_id: String,is_disabled: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.DISABLE_CUSTOMERS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "customer_id": customer_id,
            "is_disabled" :  is_disabled
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func getCustomerPaidRefundOrderList(merchant_id: String,customer_id: String,order_id: String, order_status: String,is_refunded: String,page_no: Int,limit: Int,completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.CUSTOMERS_PAID_REFUND_MERCHANT_LIST
        
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "customer_id":customer_id,
            "order_id" :order_id,
            "order_status" : order_status,
            "is_refunded":is_refunded,
            "page_no": page_no,
            "limit": limit,
        ]
        print(parameters)
        print(parameters)
        
        AF.request(url,method: .post,parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: Any]
                    print(json)
                    completion(true,json)
                    
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func custAddRemoveLoyaltyPoint(merchant_id: String,admin_id: String,customer_id:String,
                                   credit_points: String,credit_amount:String,
                                   debit_points: String,debit_amount: String,reason: String,
                                   date_time: String,emp_id: String,
                                   completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.CUSTOMERS_ADD_REMOVE_LOYALTY_POINTS
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "admin_id": admin_id,
            "customer_id":customer_id,
            "credit_points" :credit_points,
            "credit_amount" : credit_amount,
            "debit_points":debit_points,
            "debit_amount":debit_amount,
            "reason": reason,
            "date_time":date_time,
            "emp_id" : emp_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                    
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func getLoyaltyprogramList(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.LOYALTY_PROGRAM_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func searchCustomers(merchant_id: String, name: String, phone: String,  completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.CUSTOMERS_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "name": name,
            "phone_no": phone
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
}

extension ApiCalls {
    
    func getGiftCardList(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.GIFT_CARD_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func giftCardAddRemoveAPiCall(merchant_id: String, number: String, user_id: String, amount: String,
                                  emp_id: String, created_at: String, location: String, type: String,
                                  desc: String, order_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.GIFT_CARD_ADD_REMOVE
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "number": number,
            "user_id": user_id,
            "amount": amount,
            "emp_id": emp_id,
            "created_at": created_at,
            "location": location,
            "type": type,
            "desc": desc,
            "order_id": order_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
}

extension ApiCalls {
    
    func getStocktakeList(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.STOCKTAKE_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func getStockById(merchant_id: String, id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.STOCK_BY_ID
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "stocktake_id": id
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func saveStockTake(merchant_id: String, employee_id: String, total_qty: String,
                       total_discrepancy: String, total_discrepancy_cost: String,
                       status: String, datetime: String, stocktake_items: String,
                       stocktake_id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.SAVE_STOCK
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "employee_id": employee_id,
            "total_qty": total_qty,
            "total_discrepancy": total_discrepancy,
            "total_discrepancy_cost": total_discrepancy_cost,
            "status": status,
            "datetime": datetime,
            "stocktake_items": stocktake_items,
            "stocktake_id": stocktake_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func deleteStockTake(merchant_id: String, stocktake_id: String,
                         stocktake_item_id: String,
                         completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.STOCK_DELETE
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "stocktake_id": stocktake_id,
            "stocktake_item_id": stocktake_item_id,
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    func stockEmail(email_subject: String, email_body: String,
                    email_to: String, name: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.STOCK_EMAIL
        
        let parameters: [String:Any] = [
            "email_subject": email_subject,
            "email_body": email_body,
            "email_to": email_to,
            "name": name,
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: "", response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: "", response: res)
                
            }
        }
        
    }
    
    func stockVoid(merchant_id: String, stocktake_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.VOID_STOCK
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "stocktake_id": stocktake_id
        ]
        
        print(parameters)
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
                
            }
        }
    }
    
}

extension ApiCalls {
    
    func getBOGOList(merchant_id: String, completion:@escaping(Bool,[String:Any]) -> ()) {
        
        let url = AppURLs.BOGO_LIST
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
        ]
        
        print(parameters)
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    func addBogoApiCall(merchant_id: String, deal_name: String, description: String, no_end_date: String,
                        use_with_coupon: String, buy_qty: String, free_qty: String, discount: String,
                        discount_type: String, items: String, start_date: String, end_date: String,
                        id: String, completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ADD_BOGO
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id,
            "deal_name": deal_name,
            "description": description,
            "no_end_date": no_end_date,
            "use_with_coupon": use_with_coupon,
            "buy_qty": buy_qty,
            "free_qty": free_qty,
            "discount": discount,
            "discount_type" : discount_type,
            "items": items,
            "start_date": start_date,
            "end_date": end_date,
            "id":id
        ]
        
        print(parameters)
        
        AF.request(url, method: .post, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
        }
    }
    
    
    
    func enableBogoApiCall(merchant_id: String, id: String, is_enable: String,
                           completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ENABLE_BOGO
        
        let parameters : [String: Any] = [
            "merchant_id":merchant_id,
            "id": id,
            "status": is_enable
        ]
        
        AF.request(url,method: .post ,parameters: parameters).response{ response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!,options: []) as! [String: Any]
                    completion(true,json)
                }
                catch{
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
            
        }
        
    }
    
    
    func enableAllBogoApiCall(merchant_id: String, enable_all: String,
                              completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.ENABLE_BOGO
        
        let parameters : [String: Any] = [
            "merchant_id":merchant_id,
            "enable_all": enable_all
        ]
        print(parameters)
        print(parameters)
        
        AF.request(url,method: .post ,parameters: parameters).response{ response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!,options: []) as! [String: Any]
                    print(json)
                    completion(true,json)
                }
                catch{
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
            
        }
        
    }
    
    
    
    func deletebogoApiCall(merchant_id: String, bogo_id: String ,completion:@escaping(Bool,[String:Any]) -> ()){
        
        let url = AppURLs.DELETE_BOGO
        
        let parameters: [String:Any] = [
            "merchant_id": merchant_id ,
            "bogo_id": bogo_id
        ]
        print(parameters)
        
        AF.request(url,method: .post,parameters: parameters).responseData {response in
            
            switch response.result {
                
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options:[]) as! [String:Any]
                    print(json)
                    completion(true,json)
                }
                catch {
                    let res = "ios_app\(response.response?.statusCode)"
                    self.logErrorApi(merchant_id: merchant_id, response: res)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let res = "ios_app\(response.response?.statusCode)"
                self.logErrorApi(merchant_id: merchant_id, response: res)
            }
            
            
        }
        
    }
    
    
    
}


//extension  ApiCalls {
//
//    func productLotteryCall(id: String,title: String,price: String,  upc: String, trackqnty: String,
//                            quantity: String, is_lottery: String,collection: String,
//                            completion:@escaping(Bool,[String:Any]) -> ()) {
//
//        let url = AppURLs.INVENTORY_PRODUCT_ADD
//
//        let parameters: [String:Any] = [
//            "merchant_id": id,
//            "is_lottery": is_lottery,
//            "title": title,
//            "collection": collection,
//            "price": price,
//            "trackqnty": trackqnty,
//            "quantity":quantity,
//            "upc": upc,
//            "isvarient": "0"
//        ]
//
//        print(parameters)
//        print(parameters)
//
//        AF.request(url, method: .post, parameters: parameters).responseData { response in
//
//            switch response.result {
//
//            case .success(_):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:Any]
//                    print(json)
//                    completion(true,json)
//                }
//                catch {
//
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}



extension ApiCalls {
    
    func cancelRequest() {
        
        AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
}
