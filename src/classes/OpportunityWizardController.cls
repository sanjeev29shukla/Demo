public class OpportunityWizardController {
	
    public Boolean isAccount{get;set;}
    public Boolean isOpportunity{get;set;}
    public Boolean isDetails{get;set;}
    public Boolean isSuccess{get;set;}
    
    public Account theAcc{get;set;}
    public Contact theCon{get;set;}
    public Opportunity theOpp{get;set;}
    public OpportunityWizardController(){
        isAccount 		= true;
        isOpportunity 	= false;
        isDetails 		= false;
        isSuccess 		= false;
        theAcc 			= new Account();
        theCon			= new Contact();
    }
    
    public void next(){
        if(isAccount){
            isAccount = false;
            isOpportunity = true;
            theOpp = new Opportunity();
        }else if(isOpportunity){
            isDetails = true;
            isopportunity = false;
        }
    }
    
    public void save(){
        isSuccess = true;
        isDetails = false;
        insert theAcc;
        
        theCon.AccountId = theAcc.Id;
        insert theCon;
        
        theOpp.AccountId = theAcc.Id;
        insert theOpp;
        
        OpportunityContactRole theConRole = new OpportunityContactRole(ContactId=theCon.Id, OpportunityId = theOpp.Id, Role='Business User', IsPrimary=true);
        insert theConRole;
    }
    
    public PageReference cancel(){
        return new PageReference('/home/home.jsp');
    }
}