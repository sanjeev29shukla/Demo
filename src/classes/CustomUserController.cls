/*
* Created By : Sanjeev Shukla
* Description : This class is used to assign/reassign user to phone number and verify phone number also.
*/

public class CustomUserController {
	
    @AuraEnabled
    public static Boolean save(Import_User__c cusUser) {
        try{
            update cusUser;
            try{
                User us = [SELECT Id,Username,Phone FROM User WHERE Username =: cusUser.User__c];
                us.Phone = cusUser.Phone_Number__c;
                update us;
            }catch(Exception ex){system.debug('*******user update exception*******'+ex);}
        }catch(Exception ex){return true;}
        return true;
    }
    
    
    /*
    * Created By : Sanjeev Shukla
    * Description : This method is used to assign/reassign user to phone number.
    */
    
    @AuraEnabled
    public static List<User> getListUsers(String usrName) {
        System.debug('user nme'+usrName);
        List<User> listUser = new List<User>();
        if(usrName.length() >0){
            listUser = [SELECT Username,Phone FROM User WHERE Username LIKE : usrName +'%'];
        }
        System.debug('list of user'+listUser);
        if(!listUser.isEmpty()){
            return listUser;
        }
        return NULL;
    }
    
    
    /*
    * Created By : Sanjeev Shukla
    * Description : This class is used to verify phone number also.
    */
    
    @AuraEnabled
    public static String verify(Import_User__c custUser) {
        String status   =   '';
        String url      =   'https://app2.businessmessenger.com/api/4.0/account/' + String.valueOf(custUser.Phone_Number__c) ;
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('AdminAccountId', 'A0FM8820-FFL3-2FM3-0FMV-AFMV39L2I4H3');
        req.setHeader('AdminPassword', 'MB9DNEOI-EDFN-3SF3-FDAL-EFFM3LIW3I32');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);                                         System.debug('HTTP Response Body *** '+res.getBody()); System.debug('HTTP Status Code ***'+res.getStatusCode());    
        
        if(res.getStatusCode() == 404) {
             status  =   'Inactive';
        }
        
        // Parsing HttpResponse body of JSON type
        if( !String.isBlank(res.getBody()) && res.getStatusCode() == 200) {
            JSONParser parser   =   JSON.createParser(res.getBody());             System.debug('parser*** '+parser);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();                          System.debug('fieldName*** '+fieldName);
                    parser.nextToken();
                    if (fieldName == 'IsActive' && parser.getText() != null && parser.getText() == 'true') {
                        status  =   'Active' ;                                    System.debug('parser.getText() '+parser.getText());
                    }
                }
            }
        }
        if(status == 'Active' && custUser.Id != null ) {
            Import_User__c oImportUser    =    new Import_User__c();
            oImportUser.Id                =    custUser.Id;
            oImportUser.Status__c         =    status;
            try{
                update oImportUser;
            } catch (Exception e) {system.debug('***Exception ****'+e);}
        }
        System.debug('Status*** '+status);
        return status;
        
    }
}