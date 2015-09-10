/**
** Created by Fusako Kato (fkato@salesforce.com) 3/30/2015
**/
public class WebToLeadFKSettingController {

    public WebToLead_fk_Setting__c setting{get;set;} 
    public String settingName{get;set;}
    public String settingId{get;set;}
    public String logoId{get;set;}
    public String staticResourceLogoName{get;set;}

    public WebToLeadFKSettingController() {

        settingName = ApexPages.currentPage().getParameters().get('settingName');
        logoId = '';
        if(settingName == null){
            settingName = 'default';
        }
        setting = new WebToLead_fk_Setting__c();
        List<WebToLead_fk_Setting__c> settings = [SELECT Id, LogoSRName__c , TabActiveBackgroundColor__c , PanelInsideBackgroundColor__c, HeaderBorderColor__c , BodyBackgroundColor__c, PanelLabelColor__c , LabelColor__c , IsDeleted, Name, SetupOwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, TabTitle__c, PanelTitle__c, ThanksMsg__c, TabBackgroundColor__c, TabActiveColor__c, PanelBackgroundColor__c, TabLabelColor__c, PanelBorderColor__c, TabActiveLabelColor__c FROM WebToLead_fk_Setting__c Where Name = :settingName];
        if(settings.size()==1){
            setting = settings[0];
            settingId = setting.Id;
            staticResourceLogoName = 'WebToLeadFKLogo_'+setting.name;
            List<StaticResource> srl = [Select id, Name, Body From StaticResource Where Name = :staticResourceLogoName Limit 1];
            //Update sr_default;
            if(srl.size() > 0){
                logoId = srl[0].Id;
            }
        }
    }
}