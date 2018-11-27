public class SearchCityController{
    
    public City__c city {get;set;}
    public Boolean flag{get;set;}
    public SearchCityController(){
        city = new City__c();
        flag = true;
    }
    
    public void searchCity(){
        
        if(city.Name == NULL){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter City Name'));
            return;
        }
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        
        String url = 'https://maps.googleapis.com/maps/api/geocode/json?address='+city.Name+'&key=AIzaSyBrOs9dEpZ3i1TmtR_89oKw0UK7cVStR_k';
        req.setEndPoint(url);
        req.setMethod('GET');
        HttpResponse res = ht.send(req);
        System.debug('*********body********* '+res.getBody());
        Map<String,Object> body = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        
        List<Object> results = (List<Object>)body.get('results');
        
        System.debug('****************** '+results);
        Map<String, Object> resultsMap = (Map<String, Object>)results[0];
        city.Address__c = String.ValueOf(resultsMap.get('formatted_address'));
        System.debug('****************** '+resultsMap.get('formatted_address'));
        Map<String, Object> geoMetryMap = (Map<String, Object>)resultsMap.get('geometry');
        System.debug('*********geoMetry********* '+geoMetryMap);
    }
    
    public void saveCity(){
        if(city.Name == NULL){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter City Name'));
        }else if(city.Address__c == NULL){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Search Your City Address'));
        }
        City__c dupCity = new City__c();
        try{
            dupCity = [SELECT Name FROM City__c WHERE Name =: city.Name LIMIT 1];
        }catch(Exception ex){}
        if(dupCity.Name != NULL && dupCity.Name == city.Name){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate City'));
        }else{
            insert city;
            flag = false;
        }
        return;
    }
    public void reset(){
        flag = true;
        city = new City__c();
    }
}