public class ConfirmDialodController{
    //public String para {get;set;}
    
    public void display(){
        //String para = ApexPages.currentPage().getParameters().get('indexNo'));
        System.debug('delete parameter---> '+ApexPages.currentPage().getParameters().get('indexNo'));
    }
}