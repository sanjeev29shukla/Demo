public class TestMessageController{
    public Account test{get;set;}
    public String error{get;set;}
    public TestMessageController(){
        test = new Account();
        //test.Id.addError('Correct');
       //test.Name.addError('Wrong');
       error = '';
    }
    /*public void save(){
        if(test.Name == NULL || test.Name == ''){
            
        }
    }*/
}