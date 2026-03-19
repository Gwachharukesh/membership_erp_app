
import '../../../common/constants/end_points.dart';

class CrmEndPoint {
  static String clientUrl = Endpoints.baseUrl.replaceFirst('https://', '');

  static const baseUrl = 'https://crm.dynamicerp.online/v1/Common';
  static const imageUrl = 'https://crm.dynamicerp.online/';
  static const crmHeaderKey = 'CRM';
  static const isValidPassKey = '/IsValidPassKey';
  static const crmHeaderValue = 'Crm\$2023#LiveApi';
  static const paymentDueNotifyUrl = '/GetSplash';
  static const generateTicket = '/GenerateTicket';
  static const supportExecutives = '/getsupportexecutive';
  static const ticketApproved = '/ticketApproved';
  static const getTicketList = '/getTicketList';
  static const ticketDashboard = '/getCustomerDashboard';
  static const getKycDetail = '/GetKycDet';
  static const updateKyc = '/updateKyc';
  static const getBaseUrl = '/General/GetBaseUrlList';
}
