/**
** Created by Fusako Kato (fkato@salesforce.com) 3/30/2015
**/
global class WebToLeadFKController{
    public Case c{get;set;}
    public WebToLead_fk_Setting__c setting{get;set;} 
    public String settingName{get;set;}
    
    public WebToLeadFKController(){
        c = new Case();
        setting = new WebToLead_fk_Setting__c();
        settingName = ApexPages.currentPage().getParameters().get('settingName');
        if(settingName == null){
            settingName = 'default';
        }
        List<WebToLead_fk_Setting__c> settings = [SELECT Id, LogoSRName__c , TabActiveBackgroundColor__c , PanelInsideBackgroundColor__c, HeaderBorderColor__c , BodyBackgroundColor__c, PanelLabelColor__c , LabelColor__c , IsDeleted, Name, SetupOwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, TabTitle__c, PanelTitle__c, ThanksMsg__c, TabBackgroundColor__c, TabActiveColor__c, PanelBackgroundColor__c, TabLabelColor__c, PanelBorderColor__c, TabActiveLabelColor__c FROM WebToLead_fk_Setting__c Where Name = :settingName];
        if(settings.size()==1){
            setting = settings[0];
            setting.ThanksMsg__c = setting.ThanksMsg__c.replace('\n\r' , '</br>');
            setting.ThanksMsg__c = setting.ThanksMsg__c.replace('\r' , '</br>');
            setting.ThanksMsg__c = setting.ThanksMsg__c.replace('\n' , '</br>');
        }
    }
    
    @RemoteAction
    global static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
    
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        return lstPickvals;
    }
    
    @RemoteAction
    global static String saveLead(String lastName, String firstName, 
                                String companyName, String role, String tel, String email, 
                                String zip, String state, String city, String street, 
                                String campaign, String leadSource, String description){
        
        try{
            Lead newLead = new Lead();
            newLead.lastName = lastName;
            newLead.firstName = firstName;
            newLead.Company = CompanyName;
            newLead.Title = role;
            newLead.Phone = Tel;
            newLead.Email = Email;
            newLead.PostalCode = zip;
            if(State != ''){
                newLead.State = state;
            }
            newLead.City = city;
            newLead.Street = street;
            if(leadSource != ''){
                newLead.LeadSource = leadSource;
            }
            newLead.Description = Description;
            Insert newLead;
            
            if(campaign != '' && campaign != null ){
                CampaignMember cm = new CampaignMember();
                cm.CampaignId = campaign;
                cm.LeadId = newLead.Id;
                Insert cm;
            }
        }catch(Exception ex){
            return ex.getMessage();
        }
        return 'OK';
    }
}