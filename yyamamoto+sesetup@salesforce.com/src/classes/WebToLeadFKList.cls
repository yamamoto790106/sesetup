/**
** Created by Fusako Kato (fkato@salesforce.com) 3/30/2015
**/
public class WebToLeadFKList {
    public List<WebToLead_fk_Setting__c> settings{get;set;} 
    public String newSettingName{get;set;}
    public String settingId{get;set;}
    
    public WebToLeadFKList(){
        settings = getAllSettingList();
        
    }
    
    public void deleteSetting(){
        WebToLead_fk_Setting__c delSetting = [Select id From WebToLead_fk_Setting__c Where id = :settingId];
        Delete delSetting;
        settings = getAllSettingList();
    }
    
    private List<WebToLead_fk_Setting__c> getAllSettingList(){
        return [SELECT Id, LogoSRName__c , TabActiveBackgroundColor__c , PanelInsideBackgroundColor__c, HeaderBorderColor__c , BodyBackgroundColor__c, PanelLabelColor__c , LabelColor__c , IsDeleted, Name, SetupOwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, TabTitle__c, PanelTitle__c, ThanksMsg__c, TabBackgroundColor__c, TabActiveColor__c, PanelBackgroundColor__c, TabLabelColor__c, PanelBorderColor__c, TabActiveLabelColor__c FROM WebToLead_fk_Setting__c];
    }
}