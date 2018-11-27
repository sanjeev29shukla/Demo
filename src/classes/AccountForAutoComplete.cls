public class AccountForAutoComplete
{

    public List<Account> getAccList()
    {
       
        return [select id,name,industry from account ];
        
    }
}