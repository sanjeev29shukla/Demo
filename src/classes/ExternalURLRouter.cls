public class ExternalURLRouter {
	@AuraEnabled
    public static String getURL(){
        return 'https://www.google.com/';
    }
}