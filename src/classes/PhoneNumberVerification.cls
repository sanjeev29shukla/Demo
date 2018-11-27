public class PhoneNumberVerification{
    @RemoteAction
    public static String verifyPhoneNumber(String phoneNumber, String importUserName) {
        String status   =   '';
        String url      =   'https://app2.businessmessenger.com/api/4.0/account/' + phoneNumber ;
        
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
        System.debug('Status*** '+status);
        return status;
    }
}