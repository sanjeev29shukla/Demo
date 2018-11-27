public class DynamicRowController{
    public List<WrapperClass> listWrapper {get;set;}
    
    public DynamicRowController(){
        listWrapper = new List<WrapperClass>();
        WrapperClass wc = new WrapperClass('sanjeev', 'allahabad');
        listWrapper.add(wc);
        wc = new WrapperClass('sanjeev', 'bangalore');
        listWrapper.add(wc);
    }
    public void addRow(){
        WrapperClass wc = new WrapperClass('sanjeev', 'allahabad');
        listWrapper.add(wc);
    }
    public void save(){
        for(WrapperClass wc : listWrapper){
            System.debug('Wrapper List Data ---->  '+wc.name+'    *******    '+wc.add);
        }
    }
    public void deleteRow(){
        //System.debug('Parameter Value ---->  '+ApexPages.currentPage().getParameters().get('index'));
        Integer i = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
        listWrapper.remove(i-1);
    }
    public class WrapperClass{
        public Integer index{get;set;}
        public String name {get;set;}
        public String add {get;set;}
        
        public WrapperClass(String name, String add){
            this.name = name;
            this.add = add;
        }
    }
}