public class TestLookUp{
    public  Review__c newRw {get;set;}
    public  Contact con {get;set;}
    public TestLookUp(){
        newRw = new Review__c();
        con = new Contact();
    }
}