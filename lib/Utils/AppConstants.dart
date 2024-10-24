// const String BaseUrl = 'https://kisanserv.in/'; //Test
// const rzrpy = 'rzp_test_08b70kbWtaFcGh'; //test
// const rzrpySecret = "tBLSUKTmf7jFVJiVckaTaPns"; //test

//////////////////////////////////////////////////////////////////////

const String BaseUrl = 'https://kisanserv.com/'; //Prod
const rzrpy = 'rzp_live_GoB0BPWzm1djOo'; //prod
const rzrpySecret = "BhVI2WPFTP3WOilYzGjcnvI2"; //prodmei

/////////////////////////////////////////////////////////////////////

// const String BaseUrl = 'http://192.168.1.16/'; //localHost
// const rzrpy = 'rzp_test_08b70kbWtaFcGh'; //test

const CAT_IMAGES = 'catimg';
const SEND_OTP = 'Signup.aspx/Sendotpnew';
const checkExistingUser = 'express/expressapi.aspx/ChkmobileNo';
const VERIFY_OTP = 'Signup.aspx/checkotpstore';
const GET_COOKIES = 'kloginapi.aspx/getcookie';
const GET_OTP = 'Signup.aspx/checkotplatest';
const CheckUserInfo = 'Signup.aspx/checkuserifostore';
const CHECK_AVAILABLE_PINCODE = "store/storesapi.aspx/GetLocation";
const Register_Form_Store = "store/storesapi.aspx/insertMemberDetail";
const Update_Profile = "store/storesapi.aspx/updatememberdetails";
const UpdateDeliverySlots = "store/storesapi.aspx/Addupdatedeliveryslots";
const CHECK_PINCODE = 'express/expressapi.aspx/checkpincode';
const GET_CATEGORIES = 'store/storesapi.aspx/getCategoryNew';
const CHECK_OTP = 'Signup.aspx/checkotplatest';
const LOAD_STATE = 'Signup.aspx/loadState';
const LOAD_CITY = 'Signup.aspx/loadCityByState';
const LOAD_LOCATION = 'Signup.aspx/LoadLocationByCity'; //
const GoogleApiKey = "AIzaSyAGR-i5TnTzQnqD83gyRNN16KqiNa_WRaE";
const SUBCAT_IMAGES = 'subcat/';
const GET_SUBCATEGORIES = 'store/storesapi.aspx/getSubcategory';
const GET_PRODUCTS = 'store/storesapi.aspx/loadstoreproductlist';
const GET_PRODUCTS_By_Scan = "store/storesapi.aspx/loadstoreproductlistbarcode";
const GET_COMPANY_INFO = "store/storesapi.aspx/companyinfo";
const GET_ORDER = "store/storesapi.aspx/GetstoreOrderinfo";
const GET_ORDER_DETAILS = "store/storesapi.aspx/GetstoreOrderdetails";
const GET_ORDER_DETAILSByName = "store/storesapi.aspx/GetmyOrderdetailsbyName";
const updateMystock = "store/storesapi.aspx/UpdateStocknew";
const skuImges = "skuimages/";
const Notification = "express/expressapi.aspx/StoremobdevIDUpdate";
const ReadyToPick = "store/storesapi.aspx/ReadytoPickupNew";
const updateHoliday = "/store/storesapi.aspx/Holidayupdate";
const productOutofStock = "store/storesapi.aspx/Setoutofstock";
const productPacked_notPacked = "store/storesapi.aspx/ItemwisePackingDoneNew";
const allPackingDone = "store/storesapi.aspx/AllPackingDoneNew";
const checkStore = "store/storesapi.aspx/companyinfoNew";
const sortQuantity = "store/storesapi.aspx/shortqtyNew";
const storesList = "store/storesapi.aspx/GetStoreLocation";
const cityList = "store/storesapi.aspx/GetStoreCity";
const getStoreLocation = "store/storesapi.aspx/GetStoreLocationnew";
const banner = "store/storesapi.aspx/getflashimg";
const deleteAccount = "store/storesapi.aspx/deleteuserAccount";
const deliveryDone = "store/storesapi.aspx/DeliveryDone";
const sessionId = "store/storesapi.aspx/newsessinId";
const outforDelivery = "store/storesapi.aspx/OutfordeliveryNew";
const sendOtptoDeliveryBoy = "store/storesapi.aspx/SendDelboyOtp";
const setNotificationStatus = "store/storesapi.aspx/changestatus";
const getOnlineStatus = "store/storesapi.aspx/getonliestatus";
const getInvoiceData = "store/storesapi.aspx/loadinvoice";
const checkMobileNo = "store/storesapi.aspx/checkmobileNo";
const ReturnAndReplace = "store/storesapi.aspx/returnReplaceitem";
const deliveryBoyList = "store/storesapi.aspx/getonlinedeboy";
const updateDeliveryBoy = "store/storesapi.aspx/Updatedelboy";
const getStorePayDetails = "store/storesapi.aspx/GetstorefailPaymnt";
const razorPayReplyManually = "express/expressapi.aspx/RazorpayReplymanually";
const checkUserStatus = "/store/storesapi.aspx/getuserstatus";
const GET_WALLET_DETAILS = 'store/storesapi.aspx/GetWalletDetails';
const PAY_BY_WALLET = 'pay/payWallet.aspx/storepaidwallet';
const GET_WALLET_AMOUNT = "store/storesapi.aspx/GetWalletamt";
const PayByWallet_forPayLater = "pay/payWallet.aspx/storepaidwalletlater";
///////////////////////////////////////////////////////////////////////////////////////
//Store api
//////////////////////////////////////////////////////////////////////////
const STORE_ORDERING_GET_CATEGORIES = 'store/storesapi.aspx/getCategoryNew';
const STORE_ORDERING_CHECK_OTP = 'Signup.aspx/checkotplatest';
const STORE_ORDERING_LOAD_STATE = 'Signup.aspx/loadState';
const STORE_ORDERING_LOAD_CITY = 'Signup.aspx/loadCityByState';
const STORE_ORDERING_LOAD_LOCATION = 'Signup.aspx/LoadLocationByCity';
const STORE_ORDERING_GET_BANNERS = 'express/expressapi.aspx/getbanners';
const STORE_ORDERING_GET_SUBCATEGORIES = 'store/storesapi.aspx/getSubcategory';
const STORE_ORDERING_GET_PRODUCTS = 'store/storesapi.aspx/loadstorebookinglist';
const STORE_ORDERING_ADD_PRODUCT = 'store/storesapi.aspx/addproduct';
const STORE_ORDERING_GET_CART_ITEMS = 'store/storesapi.aspx/getcartitems';
const STORE_ORDERING_REMOVE_PRODUCT = 'store/storesapi.aspx/removeproduct';
const STORE_ORDERING_REMOVE_ALLPRODUCTS =
    'store/storesapi.aspx/removeproductAll';
const STORE_ORDERING_GET_CART_TOTAL = 'store/storesapi.aspx/getcartitemstotal';
const STORE_ORDERING_GET_ORDERS = 'express/expressapi.aspx/getorders';
const STORE_ORDERING_GET_ADDRESSES = 'express/expressapi.aspx/getuseraddresses';
const STORE_ORDERING_GET_STORES = 'express/expressapi.aspx/getshopdetails';
const STORE_ORDERING_GET_TIMESLOTS = 'express/expressapi.aspx/gettimeslots';

const CHECKOUT = 'store/storesapi.aspx/chkcheckout';
const ProccedToCheckout = "store/storesapi.aspx/processtocheckout";
const DEVICE_DETAILS = 'express/expressapi.aspx/StoremobdevID';
const RAZORPAY_ORDERID = "pay/razorpay.aspx/dataEncrypPay";
const StoreGetOrderInfo = "store/storesapi.aspx/GetmyOrderinfo";
const StoreGetOrderDetails = "store/storesapi.aspx/GetmyOrderdetails";
const CheckOutOrderWithoutPay = "store/storesapi.aspx/checkoutorder";
const RAZORPAY_REPLY = "store/storesapi.aspx/RazorpayReplyStore";
const storeItemWiseReciveDone = "store/storesapi.aspx/ItemwiseReceiveDoneNew";
const storeMyOrderSortQty = "store/storesapi.aspx/myOrdershortqtyNew";
const storeAllItemsReceived = "store/storesapi.aspx/AllReceiveDoneUpdate";
const orderInvoice = "buyer_invoice.aspx?orderid=";
const expressInvoice = "express_invoice.aspx?orderid=";
const payLater = "pay/razorpay.aspx/dataEncryplater";
const RazorPayLater_Reply = "store/storesapi.aspx/RazorpayReplypaylater";
const returnStoreItems = "store/storesapi.aspx/getReturnItemData";
const storeItemReturn = "store/storesapi.aspx/savestoreReturnQty";
const getStoreItems = "store/storesapi.aspx/getItemsdata";
const returnStoreWastage = "store/storesapi.aspx/getWastageItemdata";
const storeWastageRetrun = "store/storesapi.aspx/StoreWastageqty";
const razorpPayAuth = "https://api.razorpay.com/v1/orders/";
const CartTotalForPayLater = "store/storesapi.aspx/getcartitemstotalpaylater";
const getWareHouseUserDetails = "store/storesapi.aspx/getUserdetails";
const getWareHouseCompany = "store/storesapi.aspx/getCompany";
const getWarehouseStore = "store/storesapi.aspx/getStore";
const warehouseReturnItems = "store/storesapi.aspx/ReturngetData";
const loadReasons = "store/storesapi.aspx/loadReasons";
const WareHouseSaveReturnQty = "store/storesapi.aspx/saveReturnQty";
const PayUMoneyHash = "pay/paypayu.aspx/dataEncryptStorepayu";
const PayUReply = "store/storesapi.aspx/StorePayUReply";
const PayUReplyCancel = "express/expressapi.aspx/PayUReplyCancel";
const PayUPayPaterHash = "pay/paypayu.aspx/dataEncryptStorepayulater";
const storeTransferLoadSkyuType = "store/storesapi.aspx/loadskutype";
const getStoreforStockTransfer = "store/storesapi.aspx/getStorestock";
const storeTransfeAllItems = "/store/storesapi.aspx/getAutoItems";
const getAvailableStock = "store/storesapi.aspx/getAvailableStock";
const add_transfer_qty = "store/storesapi.aspx/add_transfer_qty";
const updateStockTranfer = "store/storesapi.aspx/update_transfer_qty";
const getTransferData = "store/storesapi.aspx/getTransferedData";
const deleteTransferRecord = "store/storesapi.aspx/delete_Record";
const stockSubmit = 'store/storesapi.aspx/Finalsubmit';
const getStockReceiveData = "store/storesapi.aspx/getReceiveData";
const receiveStockQty = "store/storesapi.aspx/receive_stock_qty";
const SEND_OTP_REV_ITEMS = "store/storesapi.aspx/Send_otp_rev_items";
const VERIFYOTPSTORE = "store/storesapi.aspx/verifyotpstore";
