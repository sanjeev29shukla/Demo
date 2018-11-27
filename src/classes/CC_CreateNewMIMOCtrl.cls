public class CC_CreateNewMIMOCtrl{

    public String getMemoAlreadyExists() {
        return null;
    }


    public String getIsMimoButton() {
        return null;
    }


    public String getSErrorMsg() {
        return null;
    }


    public Boolean displayPopUp{get;set;}
    
    public CC_CreateNewMIMOCtrl(){
        displayPopUp = false;
    }
    public void showPopup(){
        displayPopUp = true;
    }
}