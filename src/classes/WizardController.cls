public class WizardController{
    
    public Contact con{get;set;}
    public WizardController(){
        con = new Contact();
    }
    
    public PageReference save(){
        try{
            insert con;
            return new PageReference('/'+con.Id);
        }catch(Exception ex){system.debug('Error: '+ex.getMessage());}
        return NULL;
    }
}