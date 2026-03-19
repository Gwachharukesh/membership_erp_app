// ignore_for_file: unused_field

class Endpoints {
  Endpoints._();
  static int branchId = 0;
  static String socketUrl = _socketUrlMain;
  static String localSocket = 'ws://192.168.18.58:7792/GPS';
  static const _socketUrlMain = 'ws://202.51.3.113:7792/GPS';
  static const _socketUrlAtf = 'ws://139.5.73.19:7792/GPS';
  static const _localhost = 'ws://10.0.2.2:7792/GPS';

  static String baseUrl = 'https://mkt.dynamicerp.online';

  static const imageUrl = 'https://crm.dynamicerp.online/';

  static const _dynamicNepal = 'https://nepal.dynamicerp.online/';
  static const _baseUrlDemo1 = 'https://demo1.dynamicerp.online/';
  static const _baseUrlNmc = 'https://dynamic.nmc.coop.np:81';
  static const _baseUrlatf = 'https://atfint.rumpum.co.in';
  static const _baseUrlPetroleum = 'https://petroleum.dynamicerp.online/';

  static const String version = '/v1/';
  static const String sendWaitingNotice = 'Agent/WaitingFrom';

  static String? companyCode = '2150';
  static const saveGps = 'General/SaveManualGps';
  static const String customerLedgerVoucher = 'Customer/getLedgerVoucher';
  static const String pastTransitionledgerVoucher = 'account/getLedgerVoucher';
  static const String isValidCompanyCode = 'General/IsValidCompanyCode';

  // notifications
  static const String readNotificationLog = 'General/ReadNotificationLog';
  static const String readAllNotificationLog = 'General/ReadAllNotificationLog';

  // pre login endpoints
  static const String onesignal = 'General/SMSThrowNotification';
  static const String getSliderList = 'CMS/GetSliderList';
  static const String getProductList = 'CMS/GetProductList';
  static const String getNoticeList = 'CMS/GetNoticeList';
  static const String getIntroduction = 'CMS/GetIntroduction';
  static const String getWhoWeAre = 'CMS/GetWhoWeAre';
  static const String videos = 'CMS/GetVideosList';
  static const String gallery = 'CMS/GetGalleryList';
  static const String serviceAndFascilities =
      'CMS/GetServicesAndFacilitiesList';
  static const String getLeaveBalance = 'Employee/GetLeaveBalance';
  static const String getAcademicCalendar = 'getAcademicCalendar';
  static const String getLeaveApprovalTypes = 'Employee/LeaveApprovedTypes';
  //dealer

  static const String dealerDashboardData = 'General/GetMRSCustomData';

  //payment wallet
  static const khaltiWallet = '/wallet/khaltipayment';
  static const khaltiPaymentConfirm = '/wallet/khaltipaymentconfirm';
  static const paymentSucessUrl = '/wallet/OnlinePayment';
  static const getPaymentGateways = '/Wallet/GetPaymentGateWays';
  static const String getToken = 'token';
  static const String getDashboard = 'General/GetDashboard';
  static const getAllUsers = 'admin/GetWebUsers';
  static const String getDayBookSummary = 'Account/GetDayBookSummary';
  static const String getLeaveRequestListFor =
      'Employee/LeaveRequestListForApprove';
  static const String getLeaveList = 'Employee/LeaveList';
  static const String putApprovedLeave = 'Employee/PutApprovedLeave';
  //working
  static const String putLeaveRequest = 'Agent/AddLeaveRequest';

  //old
  static const String getTransactionForRef = 'General/GetTransactionForRef';
  static const String refreshToken = 'token';
  static const String getGoogleMapKey = '/Common/GetGoogleMapKey';

  static const salesmanWisePartyList = 'account/SalesmanWiseLedgerList';
  static const getSalesPaymentTerms = 'account/GetSalesPaymentTerms';
  static const getDistributorList = 'General/GetCustomData';
  static const getDistributorSalesmanList = 'General/GetCustomData';
  static const getOutLetListforDistributor = 'General/GetCustomData';
  static const autoCompleteLedgerList = 'account/AutoCompleteLedgerList';

  static const String getAllPaymentTerms = 'Inventory/GetAllPaymentTerms';
  static const String saveSalesOrder = 'Inventory/SaveSalesOrder';
  static const String salesreturnproducts = 'Inventory/GetPendingSI';
  static const getCompetitorCompany = 'inventory/GetAllCompetitorCompany';
  static const getCompetitorProduct = 'inventory/GetAllCompetitorProduct ';
  static const getPartyAgeing = 'inventory/GetPartyAgeing';
  static const getProductAgeing = 'inventory/GetProductAgeing';
  static const getBillWiseAgeing = 'inventory/GetBillWiseAgeing';
  static const getProductVoucher = 'inventory/GetProductVoucher';
  static const getAllProductReport = 'inventory/GetAllProductRpt';
  static const getAutoCompleteProductList = 'inventory/AutoCompleteProductList';
  static const getCRLimitExpiredParty = 'inventory/GetCRLimitExpiredParty';
  static const String getPumpList = '/Inventory/GetPumpList';
  static const String saveMeterReading = 'Inventory/SaveMeterReading';
  static const String getToGoDownList = 'Inventory/GetGodownList';
  static const String getPendingStockList = 'Inventory/GetPendingDemand';
  static const String saveStockDemand = 'inventory/SaveStockDemand';
  static const String saveStockTransfer = 'inventory/SaveStockTransfer';
  static const String getStockGodamList = 'inventory/GetGodownForStockDemand';
  static const getSaveMonthlyProjection = 'inventory/SaveMonthlyProjection';
  static const getProductDetail = 'inventory/GetProductDetail';

  static const getLedgerGroupSummary = 'Account/GetLedgerGroupSummary';
  static const getDashboardTypes = 'StaticValues/GetDashboardTypes';
  static const getLedgerTypes = 'StaticValues/GetLedgerTypes';
  static const getCompanyDetail = 'General/GetCompanyDetail';
  static const getVoucherType = 'account/GetVoucherModes?VoucherType';
  static const getVoucherModeType = 'account/GetVoucherModes?VoucherType=';
  static const getLedgerVoucher = 'Account/GetLedgerVoucher';
  static const getLedgerVoucherDet = 'Account/GetLedgerVoucherDet';
  static const getLedgerDetails = 'Account/GetLedgerDetail';
  static const getbgList = 'Account/GetBGList';
  static const getNewVatRegister = 'Account/GetNewVatRegister';
  static const getVoucherNo = 'General/GetVoucherNo';
  static const checkappVersion = '/General/GetAppVer';
  static const getPendingSalesOrder = 'agent/GetPendingSalesOrder';
  // static const getPendingSalesOrderDet = 'agent/GetPendingSalesOrderDet';
  static const getCustomData = 'General/GetCustomData';
  static const getRoutePartyList = 'agent/GetPartyList';
  static const getRoutesForWS = 'General/GetRoutesForWS';
  static const attandanceStatus = '/General/CheckAppAttendance';
  static const startVisit = '/Agent/StartVisit';
  static const endVisit = '/Agent/endVisit';
  static const getCashBankBookAsGroup = 'Account/GetCashBankBookAsGroup';
  static const getBalanceSheet = 'Account/GetBSAsT';
  static const getProfitAndLoss = 'Account/GetPLAsT';
  static const getPartyDuesBill = 'Account/GetPartyDuesBill';
  static const getDebtorType = 'Account/GetDebtorType';
  static const getDebtorRoute = 'Account/GetDebtorRoute';
  static const getledgerDetail = 'account/GetLedgerDetail';
  static const getLedgerGroupList = 'Account/GetLedgerGroupList';

  static const getCompanyPeriodMonth = 'General/GetCompanyPeriodMonth';
  static const getAppAttendanceLog = 'General/GetAppAttendanceLog';
  static const getSalesmanDailyAttendanceLog = 'agent/GetDailyAppAttendance';

  static const addAppAttendance = 'General/AddAppAttendance';
  static const addEmployeeAppAttendance = 'Employee/AddAppAttendance';
  static const putAgentUpdatePhoto = 'Agent/UpdatePhoto';

  static const saveVoucher = 'Account/SaveReceipt';
  static const getCompanyEntity =
      'StaticValues/GetCompanyList'; //StaticValues/GetCompanyList
  static const getTodaySales = 'agent/GetTodaySales';
  static const getSalesReceipt = 'agent/GetSalesReceipt';
  static const oneSignalSms = 'SMSThrowNotification';

  static const String getLeaveTypes = 'Agent/GetLeaveTypes';
  static const String getLeaveRequests = 'Agent/GetLeaveReq';
  static const String getEmployeeRequests = 'employee/GetLeaveReq';
  static const String addLeaveRequests = 'Agent/AddLeaveRequest';
  static const String approveLeaveRequest = 'Agent/LeaveApprove';

  static const String staticVoucherTypes = 'General/GetVoucherType';

  static const String getPendingStockCustom = 'General/GetCustomData';

  static const String saveRoutePlan = 'Agent/UpdateRoutePlan';
  static const String getVoucherDetail = 'general/GetVoucherDetails';
  static const String printVoucherPdf = 'General/PrintVoucher';
  static const String newCustomer = 'Agent/NewCustomer';
  static const String customerDeactive = 'Agent/CustomerDeactive';

  static const String getOutletDetail = '/Agent/GetOutletForEdit';
  static const String saveOutletDetail = '/Agent/UpdateOutletForEdit';
  static const String updateOutletAddress = 'Agent/UpdateOutletAddress';
  static const String updateOutletChannel = 'Agent/UpdateOutletChannel';
  static const String updateOutletCategory = 'Agent/UpdateOutletCategory';

  static const String getBranchList = 'general/getBranchList';

  static const String updateRoute = 'Agent/UpdateRoute';
  static const String getUserDetail = 'General/GetUserDetail';
  static const String getPaySlip = 'Employee/PaySlip';
  static const String getCustomerProfile = 'Customer/GetProfile';
  static const String newRegister = 'Customer/Register';
  static const String generateOtp = 'Customer/GenerateOTP';
  static const String verifyOtp = 'Customer/IsValidOTP';
  static const String isValidUser = 'General/GetUserDetail';

  static String hrmEmployeeProfile = 'employee/getprofile';
  static const String putAttendanceApprovedAppeal =
      'Employee/PutApprovedAttendanceAppeals';
  static const String getMonthlyAttendanceLog =
      'Employee/GetMonthlyAttendanceLog';
  static const String getAttendanceAppealList =
      'Employee/AttendanceAppealsList';
  static const String getAttendanceAppealsForApproval =
      'Employee/AttendanceAppealsListForApproved';
  //isValidUser
  static const String hrmFeaturesList = 'Employee/FeaturesList';
  static const String getLastPunch = 'Employee/GetLastPunch';
  static const String getInOutModes = 'Employee/GetInOutModeList';
  //Clock in out
  static const String getEmployeeAttendanceLog =
      'Employee/GetDateWiseAttendance';
  static const String printPdf = '/General/PrintVoucher';
  static const String getAttendanceDetails = 'Employee/GetAttendanceDetails';
  static const String putAttendance = 'Employee/Attendance';
  static const String putAttendanceAppeal = 'Employee/PutAttendanceAppeals';
  static const String getLoanDetails = 'Employee/LoanDetails';
  static const String getAdvanceDetails = 'Employee/AdvanceDetails';
  static const String getExpenseCategory = 'Employee/ExpensesCategory';
  static const String putExpenseClaim = 'Employee/PutExpensesClaim';
  static const String getAssetList = 'Employee/AssetList';
  static const String putAssetRequest = 'Employee/AssetRequest';
  static const String getAssetCategory = 'Employee/AssetCategory';

  static const String getGrievanceTypes = 'Employee/GrievanceTypes';
  static const String getGrievanceUserList = 'Employee/GetUserList';
  static const String putGrievance = 'Employee/PutGrievance';

  static const String getTravelTypes = 'Employee/TravelTypes';
  static const String getTravelFundingTypes = 'Employee/TravelFunding';
  static const String putEmployeeTravel = 'Employee/PutTravels';

  // receiveTimeout
  static const int receiveTimeout = 100000;
  // connectTimeout
  static const int connectionTimeout = 50000;
  // download timeout
  static const int downloadTimeout = 500000;

  static const assignTask = 'Common/AssignTask';
  static const getTaskList = 'Common/GetTaskList';

  static const addTaskStatus = 'Common/AddTaskStatus';
  static const addTaskComment = 'Common/AddTaskComment';
  static const addAssignTo = 'Common/ReTaskAssign';
  static const getTaskHistory = 'Common/GetTaskHistory';
  static const addTaskApprove = 'Common/AddTaskApproved';
}
