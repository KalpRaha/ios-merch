//
//  AppURLs.swift
//
//
//  Created by Jamaluddin Syed on 7/20/23.
//

import Foundation

struct AppURLs {
    
    static let ORDERS_LIST = "https://uat.quickvee.net/orders/order_list"
    static let ORDER_DETAILS = "https://uat.quickvee.net/orders/order_details"
    static let ORDERS_STATUS = "https://uat.quickvee.net/orders/change_order_status"
    static let NEW_ORDERS_COUNT = "https://uat.quickvee.net/orders/new_order_count"
    
    static let ORDER_ITEM_REFUND = "https://uat.quickvee.net/orders/save_line_item_refund"
    static let FILTER_CATEGORY = "https://uat.quickvee.net/Categoryapi/category_list"
    static let ITEMWISE_SALE = "https://uat.quickvee.net/Report_api/itemwise_sale"
    static let ORDERTYPE_SALE = "https://uat.quickvee.net/Report_api/order_type"
    static let SALES_OVERVIEW = "https://uat.quickvee.net/Report_api/new_sale_overview"
    static let TAXES_SALE = "https://uat.quickvee.net/Report_api/taxes"
    static let HOME_ALL_DATA = "https://uat.quickvee.net/Dashboard/allData"
    static let ALL_STORES = "https://uat.quickvee.net/app/all_stores"
    
    static let LOGIN = "https://uat.quickvee.net/App/new_login_via_storename"
    static let FORGOT_PASSWORD = "https://uat.quickvee.net/app/forgot_password"
    
    static let REGISTER = "https://uat.quickvee.net/app/register_merchant"
    
    static let UPDATE_BUSINESS_HOURS = "https://uat.quickvee.net/Settingapi/update_business_hours"
    static let GET_BUSINESS_HOURS = "https://uat.quickvee.net/Settingapi/get_business_hours"
    
    static let EDIT_COUPON = "https://uat.quickvee.net/Couponapi/edit_coupon"
    static let ADD_COUPON = "https://uat.quickvee.net/Couponapi/add_coupon"
    static let GET_COUPON_DETAILS = "https://uat.quickvee.net/Couponapi/get_coupon_details"
    static let COUPON_SHOW_ONLINE = "https://uat.quickvee.net/Couponapi/show_online"
    static let COUPON_DELETE = "https://uat.quickvee.net/Couponapi/delete_coupon"
    
    static let ADD_EDIT_VENDOR = "https://uat.quickvee.net/app/add_edit_vendor"
    static let VENDOR_PAYMENT_LIST = "https://uat.quickvee.net/app/vendor_payment_list"
    static let VENDOR_BY_ID = "https://uat.quickvee.net/app/get_vendorById"
    static let VENDOR_PAYMENT_DETAILS = "https://uat.quickvee.net/app/vendor_payment_report"
    
    static let CHANGE_PASSWORD = "https://uat.quickvee.net/profile/change_password"
    
    static let TAX_LIST = "https://uat.quickvee.net/Settingapi/tax_list"
    static let ADD_TAX = "https://uat.quickvee.net/Settingapi/addnewtax"
    static let DELETE_TAX = "https://uat.quickvee.net/Settingapi/deletetax"
    
    static let UPDATE_STORE_ALERTS = "https://uat.quickvee.net/Settingapi/update_store_alerts"
    
    static let PROFILE = "https://uat.quickvee.net/profile"
    static let UPDATE_PROFILE = "https://uat.quickvee.net/profile/update_profile"
    static let LOGOUT = "https://uat.quickvee.net/App/logout"
    
    static let STORE_DETAILS = "https://uat.quickvee.net/Settingapi/store_details"
    static let STORE_LOGO = "https://uat.quickvee.net/upload/"
    static let STORE_BANNER = "https://uat.quickvee.net/upload/banner/"
    
    static let UPDATE_STORE_OPTIONS = "https://uat.quickvee.net/Settingapi/update_store_option"
    static let UPDATE_STORE_SETUP = "https://uat.quickvee.net/Settingapi/update_store_setup"
    
    static let INVENTORY_CATEGORY_LIST = "https://uat.quickvee.net/Categoryapi/category_list"
    static let INVENTORY_ADD_CATEGORY = "https://uat.quickvee.net/Categoryapi/add_category"
    static let INVENTORY_EDIT_CATEGORY = "https://uat.quickvee.net/Categoryapi/"
    static let INVENTORY_DELETE_CATEGORY = "https://uat.quickvee.net/Categoryapi/delete_category"
    static let INVENTORY_CATEGORY_BY_ID = "https://uat.quickvee.net/Categoryapi/get_categoryById"
    
    static let INVENTORY_PRODUCT_LIST = "https://uat.quickvee.net/Productapi/products_list"
    static let INVENTORY_PRODUCT_ADD = "https://uat.quickvee.net/Productapi/add_product"
    static let INVENTORY_PRODUCT_DUPLICATE = "https://uat.quickvee.net/Productapi/duplicate_product"
    static let INVENTORY_PRODUCT_EDIT = "https://uat.quickvee.net/Productapi/edit_produt"
    static let INVENTORY_PRODUCT_BY_ID = "https://uat.quickvee.net/Productapi/get_productdata_ById"
    static let INVENTORY_UPDATE_STATUS = "https://uat.quickvee.net/Productapi/product_show_status_update"
    static let INVENTORY_PRODUCT_DELETE = "https://uat.quickvee.net/Productapi/delete_product"
    
    static let INVENTORY_ATTRIBUTE_LIST = "https://uat.quickvee.net/Varientsapi/varients_list"
    static let INVENTORY_ADD_ATTRIBUTE = "https://uat.quickvee.net/Varientsapi/add_varient"
    
    static let INVENTORY_VARIANT_LIST = "https://uat.quickvee.net/productapi/variant_list"
    static let INVENTORY_UPDATE_PRODUCT_VARIANT = "https://uat.quickvee.net/productapi/update_product_variant"
    static let INVENTORY_VARIANT_BY_ID = "https://uat.quickvee.net/productapi/get_variantdata_ById"
    static let INVENTORY_VARIANT_UPDATE = "https://uat.quickvee.net/productapi/update_product_variant"
    static let INVENTORY_SAVE_INSTANT_PO = "https://uat.quickvee.net/productapi/save_instant_po"
    
    static let INVENTORY_SETTINGS  = "https://uat.quickvee.net/Profile_setup/inventory_register_setting"
    static let INVENTORY_SYNC_DATA  = "https://uat.quickvee.net/App/sync_app"
    static let PASSCODE_LOGIN = "https://uat.quickvee.net/App/employee_list"
    static let INVENTORY_PASSCODE = "https://uat.quickvee.net/productapi/"
    
    static let SALES_HISTORY = "https://uat.quickvee.net/productapi/saleshistory"
    
    static let ADD_BULK_PRICING = "https://uat.quickvee.net/Productapi/add_bulk_pricing"
    static let GET_BULK_PRICING = "https://uat.quickvee.net/productapi/get_bulk_pricing_ById"
    static let DELETE_BULK_PRICING = "https://uat.quickvee.net/productapi/delete_bulk_pricing"
    static let UPDATE_BULK_PRICING = "https://uat.quickvee.net/productapi/edit_bulk_pricing"
    
    static let ADD_PURCHASE_QUANTITY = "https://uat.quickvee.net/Productapi/update_purchase_qty"
    
    static let FCM_TOKEN = "https://uat.quickvee.net/App/save_fcm_token/1"
    
    static let LOYALTY_LIST = "https://uat.quickvee.net/Loyalty_program_api/loyalty_program_list"
    static let UPDATE_LOYALTY_PROGRAM = "https://uat.quickvee.net/Loyalty_program_api/save_loyalty_program"
    
    static let BONUS_BY_ID = "https://uat.quickvee.net/Loyalty_program_api/bouns_point_promotions_list"
    static let BONUS_UPDATE = "https://uat.quickvee.net/Loyalty_program_api/add_bouns_point_promotions"
    static let DELETE_BONUS = "https://uat.quickvee.net/Loyalty_program_api/delete_loyalty_program"
    
    static let SET_REGISTER_SETTINGS = "https://uat.quickvee.net/Profile_setup/inventory_register_setting"
    static let UPDATE_REGISTER_SETTINGS = "https://uat.quickvee.net/Profile_setup/register_setting"
    
    static let UPDATE_SYSTEM_ACCESS = "https://uat.quickvee.net/Profile_setup/system_access"
    static let CHECK_END_SHIFT = "https://uat.quickvee.net/Shift_inout/check_eod"
    
    static let EMPLOYEE_LIST = "https://uat.quickvee.net/App/employee_list"
    static let EMPLOYEE_BY_ID = "https://uat.quickvee.net/App/getEmployeeByEmpid"
    static let ADD_EMPLOYEE = "https://uat.quickvee.net/App/addEdit_employee"
    static let DELETE_EMPLOYEE = "https://uat.quickvee.net/App/delete_employee"
    
    static let SETUP_INVENTORY = "https://uat.quickvee.net/Profile_setup/inventory_register_setting"
    static let UPDATE_SETUP_INVENTORY = "https://uat.quickvee.net/Profile_setup/inventory_setting"
    
    static let ADD_BRANDS_TAGS = "https://uat.quickvee.net/Productapi/add_brand_tag"
    static let UPDATE_BRANDS_TAGS = "https://uat.quickvee.net/Productapi/update_brand_tag"
    static let GET_BRANDS_TAGS = "https://uat.quickvee.net/Productapi/list_brand_tag"
    static let DELETE_BRANDS_TAGS = "https://uat.quickvee.net/Productapi/delete_brand_tag"
    
    static let MIX_N_MATCH_PRICING_LIST = "https://uat.quickvee.net/Mix_match_pricing_api/mix_match_pricing_list"
    static let ADD_MIX_N_MATCH_PRICING = "https://uat.quickvee.net/Mix_match_pricing_api/add_mix_match_pricing"
    static let DELETE_MIX_N_MATCH_PRICING = "https://uat.quickvee.net/Mix_match_pricing_api/delete_mix_match_pricing"
    static let ENABLE_MIX_N_MATCH_PRICING = "https://uat.quickvee.net/Mix_match_pricing_api/enable_mix_match_pricing"
    
    
    static let GIFT_CARD_LIST = "https://uat.quickvee.net/Gift_Ebt_api/get_giftcard"
    static let GIFT_CARD_ADD_REMOVE = "https://uat.quickvee.net/Gift_Ebt_api/adjust_giftcard"
    
    static let CUSTOMERS_LIST = "https://uat.quickvee.net/Customer_merchant_api/new_customer_list"
    static let CUSTOMERS_PAID_REFUND_MERCHANT_LIST = "https://uat.quickvee.net/Customer_merchant_api/new_mrtwise_customer_list_api"
    static let FIND_CUSTOMER = "https://uat.quickvee.net/App/find_customer"
    
    static let DELETE_CUSTOMERS = "https://uat.quickvee.net/Customer_merchant_api/delete_customer"
    static let DISABLE_CUSTOMERS = "https://uat.quickvee.net/Customer_merchant_api/disable_customer"
    static let ADD_CUSTOMERS = "https://uat.quickvee.net/App/save_customer_details"
    static let CUSTOMERS_ADD_REMOVE_LOYALTY_POINTS = "https://uat.quickvee.net/Loyalty_program_api/loyality_point_transaction"
    static let LOYALTY_PROGRAM_LIST = "https://uat.quickvee.net/Loyalty_program_api/loyalty_program_list"
    
    static let STOCKTAKE_LIST = "https://uat.quickvee.net/Stocktake_api/stocktake_list"
    static let STOCK_BY_ID = "https://uat.quickvee.net/Stocktake_api/get_stocktake_details_by_id"
    static let SAVE_STOCK = "https://uat.quickvee.net/Stocktake_api/create_stocktake"
    static let STOCK_DELETE = "https://uat.quickvee.net/Stocktake_api/delete_stocktake_item"
    static let STOCK_EMAIL = "https://uat.quickvee.net/Purchase_orders_api/email_po"
    static let VOID_STOCK = "https://uat.quickvee.net/Stocktake_api/void_stocktake"
    
    static let BOGO_LIST = "https://uat.quickvee.net/Bogoapi/bogo_list"
    static let ADD_BOGO = "https://uat.quickvee.net/Bogoapi/add_bogo"
    static let ENABLE_BOGO = "https://uat.quickvee.net/Bogoapi/bogo_status"
    static let DELETE_BOGO = "https://uat.quickvee.net/Bogoapi/delete_bogo"
    
    
    //gomerchantech
    
//    static let ORDERS_LIST = "http://pos.gomerchantech.com/orders/order_list"
//    static let ORDER_DETAILS = "http://pos.gomerchantech.com/orders/order_details"
//    static let ORDERS_STATUS = "http://pos.gomerchantech.com/orders/change_order_status"
//    static let NEW_ORDERS_COUNT = "http://pos.gomerchantech.com/orders/new_order_count"
//    
//    static let ORDER_ITEM_REFUND = "http://pos.gomerchantech.com/orders/save_line_item_refund"
//    static let FILTER_CATEGORY = "http://pos.gomerchantech.com/Categoryapi/category_list"
//    static let ITEMWISE_SALE = "http://pos.gomerchantech.com/Report_api/itemwise_sale"
//    static let ORDERTYPE_SALE = "http://pos.gomerchantech.com/Report_api/order_type"
//    static let SALES_OVERVIEW = "http://pos.gomerchantech.com/Report_api/new_sale_overview"
//    static let TAXES_SALE = "http://pos.gomerchantech.com/Report_api/taxes"
//    static let HOME_ALL_DATA = "http://pos.gomerchantech.com/Dashboard/allData"
//    static let ALL_STORES = "http://pos.gomerchantech.com/app/all_stores"
//    
//    static let LOGIN = "http://pos.gomerchantech.com/App/new_login_via_storename"
//    static let FORGOT_PASSWORD = "http://pos.gomerchantech.com/app/forgot_password"
//    
//    static let REGISTER = "http://pos.gomerchantech.com/app/register_merchant"
//    
//    static let UPDATE_BUSINESS_HOURS = "http://pos.gomerchantech.com/Settingapi/update_business_hours"
//    static let GET_BUSINESS_HOURS = "http://pos.gomerchantech.com/Settingapi/get_business_hours"
//    
//    static let EDIT_COUPON = "http://pos.gomerchantech.com/Couponapi_live/edit_coupon"
//    static let ADD_COUPON = "http://pos.gomerchantech.com/Couponapi_live/add_coupon"
//    static let GET_COUPON_DETAILS = "http://pos.gomerchantech.com/Couponapi_live/get_coupon_details"
//    static let COUPON_SHOW_ONLINE = "http://pos.gomerchantech.com/Couponapi_live/show_online"
//    static let COUPON_DELETE = "http://pos.gomerchantech.com/Couponapi_live/delete_coupon"
//    
//    static let ADD_EDIT_VENDOR = "http://pos.gomerchantech.com/app/add_edit_vendor"
//    static let VENDOR_PAYMENT_LIST = "http://pos.gomerchantech.com/app/vendor_payment_list"
//    static let VENDOR_BY_ID = "http://pos.gomerchantech.com/app/get_vendorById"
//    static let VENDOR_PAYMENT_DETAILS = "http://pos.gomerchantech.com/app/vendor_payment_report"
//    
//    static let CHANGE_PASSWORD = "http://pos.gomerchantech.com/profile/change_password"
//    
//    static let TAX_LIST = "http://pos.gomerchantech.com/Settingapi/tax_list"
//    static let ADD_TAX = "http://pos.gomerchantech.com/Settingapi/addnewtax"
//    static let DELETE_TAX = "http://pos.gomerchantech.com/Settingapi/deletetax"
//    
//    static let UPDATE_STORE_ALERTS = "http://pos.gomerchantech.com/Settingapi/update_store_alerts"
//    
//    static let PROFILE = "http://pos.gomerchantech.com/profile"
//    static let UPDATE_PROFILE = "http://pos.gomerchantech.com/profile/update_profile"
//    static let LOGOUT = "http://pos.gomerchantech.com/App/logout"
//    
//    static let STORE_DETAILS = "http://pos.gomerchantech.com/Settingapi/store_details"
//    static let STORE_LOGO = "http://pos.gomerchantech.com/upload/"
//    static let STORE_BANNER = "http://pos.gomerchantech.com/upload/banner/"
//    
//    static let UPDATE_STORE_OPTIONS = "http://pos.gomerchantech.com/Settingapi/update_store_option"
//    static let UPDATE_STORE_SETUP = "http://pos.gomerchantech.com/Settingapi/update_store_setup"
//    
//    static let INVENTORY_CATEGORY_LIST = "http://pos.gomerchantech.com/Categoryapi/category_list"
//    static let INVENTORY_ADD_CATEGORY = "http://pos.gomerchantech.com/Categoryapi/add_category"
//    static let INVENTORY_EDIT_CATEGORY = "http://pos.gomerchantech.com/Categoryapi/"
//    static let INVENTORY_DELETE_CATEGORY = "http://pos.gomerchantech.com/Categoryapi/delete_category"
//    static let INVENTORY_CATEGORY_BY_ID = "http://pos.gomerchantech.com/Categoryapi/get_categoryById"
//    
//    static let INVENTORY_PRODUCT_LIST = "http://pos.gomerchantech.com/Productapi/products_list"
//    static let INVENTORY_PRODUCT_ADD = "http://pos.gomerchantech.com/Productapi/add_product"
//    static let INVENTORY_PRODUCT_DUPLICATE = "http://pos.gomerchantech.com/Productapi/duplicate_product"
//    static let INVENTORY_PRODUCT_EDIT = "http://pos.gomerchantech.com/Productapi/edit_produt"
//    static let INVENTORY_PRODUCT_BY_ID = "http://pos.gomerchantech.com/Productapi/get_productdata_ById"
//    static let INVENTORY_UPDATE_STATUS = "http://pos.gomerchantech.com/Productapi/product_show_status_update"
//    static let INVENTORY_PRODUCT_DELETE = "http://pos.gomerchantech.com/Productapi/delete_product"
//    
//    static let INVENTORY_ATTRIBUTE_LIST = "http://pos.gomerchantech.com/Varientsapi/varients_list"
//    static let INVENTORY_ADD_ATTRIBUTE = "http://pos.gomerchantech.com/Varientsapi/add_varient"
//    
//    static let INVENTORY_VARIANT_LIST = "http://pos.gomerchantech.com/productapi/variant_list"
//    static let INVENTORY_UPDATE_PRODUCT_VARIANT = "http://pos.gomerchantech.com/productapi/update_product_variant"
//    static let INVENTORY_VARIANT_BY_ID = "http://pos.gomerchantech.com/productapi/get_variantdata_ById"
//    static let INVENTORY_VARIANT_UPDATE = "http://pos.gomerchantech.com/productapi/update_product_variant"
//    static let INVENTORY_SAVE_INSTANT_PO = "http://pos.gomerchantech.com/productapi/save_instant_po"
//    
//    static let INVENTORY_SETTINGS  = "http://pos.gomerchantech.com/Profile_setup/inventory_register_setting"
//    static let INVENTORY_SYNC_DATA  = "http://pos.gomerchantech.com/App/sync_app"
//    static let PASSCODE_LOGIN = "http://pos.gomerchantech.com/App/employee_list"
//    static let INVENTORY_PASSCODE = "http://pos.gomerchantech.com/productapi/"
//    
//    static let SALES_HISTORY = "http://pos.gomerchantech.com/productapi/saleshistory"
//    
//    static let ADD_BULK_PRICING = "http://pos.gomerchantech.com/Productapi/add_bulk_pricing"
//    static let GET_BULK_PRICING = "http://pos.gomerchantech.com/productapi/get_bulk_pricing_ById"
//    static let DELETE_BULK_PRICING = "http://pos.gomerchantech.com/productapi/delete_bulk_pricing"
//    static let UPDATE_BULK_PRICING = "http://pos.gomerchantech.com/productapi/edit_bulk_pricing"
//    
//    static let ADD_PURCHASE_QUANTITY = "http://pos.gomerchantech.com/Productapi/update_purchase_qty"
//    
//    static let FCM_TOKEN = "http://pos.gomerchantech.com/App/save_fcm_token/1"
//    
//    static let LOYALTY_LIST = "http://pos.gomerchantech.com/Loyalty_program_api/loyalty_program_list"
//    static let UPDATE_LOYALTY_PROGRAM = "http://pos.gomerchantech.com/Loyalty_program_api/save_loyalty_program"
//    
//    static let BONUS_BY_ID = "http://pos.gomerchantech.com/Loyalty_program_api/bouns_point_promotions_list"
//    static let BONUS_UPDATE = "http://pos.gomerchantech.com/Loyalty_program_api/add_bouns_point_promotions"
//    static let DELETE_BONUS = "http://pos.gomerchantech.com/Loyalty_program_api/delete_loyalty_program"
//    
//    static let SET_REGISTER_SETTINGS = "http://pos.gomerchantech.com/Profile_setup/inventory_register_setting"
//    static let UPDATE_REGISTER_SETTINGS = "http://pos.gomerchantech.com/Profile_setup/register_setting"
//    
//    static let UPDATE_SYSTEM_ACCESS = "http://pos.gomerchantech.com/Profile_setup/system_access"
//    static let CHECK_END_SHIFT = "http://pos.gomerchantech.com/Shift_inout/check_eod"
//    
//    static let EMPLOYEE_LIST = "http://pos.gomerchantech.com/App/employee_list"
//    static let EMPLOYEE_BY_ID = "http://pos.gomerchantech.com/App/getEmployeeByEmpid"
//    static let ADD_EMPLOYEE = "http://pos.gomerchantech.com/App/addEdit_employee"
//    static let DELETE_EMPLOYEE = "http://pos.gomerchantech.com/App/delete_employee"
//    
//    static let SETUP_INVENTORY = "http://pos.gomerchantech.com/Profile_setup/inventory_register_setting"
//    static let UPDATE_SETUP_INVENTORY = "http://pos.gomerchantech.com/Profile_setup/inventory_setting"
//    
//    static let ADD_BRANDS_TAGS = "http://pos.gomerchantech.com/Productapi/add_brand_tag"
//    static let UPDATE_BRANDS_TAGS = "http://pos.gomerchantech.com/Productapi/update_brand_tag"
//    static let GET_BRANDS_TAGS = "http://pos.gomerchantech.com/Productapi/list_brand_tag"
//    static let DELETE_BRANDS_TAGS = "http://pos.gomerchantech.com/Productapi/delete_brand_tag"
//    
//    static let MIX_N_MATCH_PRICING_LIST = "http://pos.gomerchantech.com/Mix_match_pricing_api/mix_match_pricing_list"
//    static let ADD_MIX_N_MATCH_PRICING = "http://pos.gomerchantech.com/Mix_match_pricing_api/add_mix_match_pricing"
//    static let DELETE_MIX_N_MATCH_PRICING = "http://pos.gomerchantech.com/Mix_match_pricing_api/delete_mix_match_pricing"
//    static let ENABLE_MIX_N_MATCH_PRICING = "http://pos.gomerchantech.com/Mix_match_pricing_api/enable_mix_match_pricing"
//    
//    
//    static let GIFT_CARD_LIST = "http://pos.gomerchantech.com/Gift_Ebt_api/get_giftcard"
//    static let GIFT_CARD_ADD_REMOVE = "http://pos.gomerchantech.com/Gift_Ebt_api/adjust_giftcard"
//    
//    static let CUSTOMERS_LIST = "http://pos.gomerchantech.com/Customer_merchant_api/new_customer_list"
//    static let CUSTOMERS_PAID_REFUND_MERCHANT_LIST = "http://pos.gomerchantech.com/Customer_merchant_api/new_mrtwise_customer_list_api"
//    static let FIND_CUSTOMER = "http://pos.gomerchantech.com/App/find_customer"
//    
//    static let DELETE_CUSTOMERS = "http://pos.gomerchantech.com/Customer_merchant_api/delete_customer"
//    static let DISABLE_CUSTOMERS = "http://pos.gomerchantech.com/Customer_merchant_api/disable_customer"
//    static let ADD_CUSTOMERS = "http://pos.gomerchantech.com/App/save_customer_details"
//    static let CUSTOMERS_ADD_REMOVE_LOYALTY_POINTS = "http://pos.gomerchantech.com/Loyalty_program_api/loyality_point_transaction"
//    static let LOYALTY_PROGRAM_LIST = "http://pos.gomerchantech.com/Loyalty_program_api/loyalty_program_list"
//    
//    static let STOCKTAKE_LIST = "http://pos.gomerchantech.com/Stocktake_api/stocktake_list"
//    static let STOCK_BY_ID = "http://pos.gomerchantech.com/Stocktake_api/get_stocktake_details_by_id"
//    static let SAVE_STOCK = "http://pos.gomerchantech.com/Stocktake_api/create_stocktake"
//    static let STOCK_DELETE = "http://pos.gomerchantech.com/Stocktake_api/delete_stocktake_item"
//    static let STOCK_EMAIL = "http://pos.gomerchantech.com/Purchase_orders_api/email_po"
//    static let VOID_STOCK = "http://pos.gomerchantech.com/Stocktake_api/void_stocktake"
//    
//    static let BOGO_LIST = "http://uat.quickvee.net/Bogoapi/bogo_list"
//    static let ADD_BOGO = "http://uat.quickvee.net/Bogoapi/add_bogo"
//    static let ENABLE_BOGO = "http://uat.quickvee.net/Bogoapi/bogo_status"
//    static let DELETE_BOGO = "http://uat.quickvee.net/Bogoapi/delete_bogo"
//    
    static let LOGURL = "https://www.quickvees.com/internet_log.php"
}
