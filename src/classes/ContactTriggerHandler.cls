public class ContactTriggerHandler{
    public static void firstMethod(List<Contact> conList){
        for(Contact theCon : conList){
            System.debug('****** Contact Info ***** '+theCon.lastName);
        }
    }
}