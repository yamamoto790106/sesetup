/**
** Created by Fusako Kato (fkato@salesforce.com) 3/30/2015
**/
@isTest(SeeAllData=true)
public class WebToLeadFK_Test{
    
    //test for WebToLeadFKList
    public static testMethod void testMyController1() { 
        WebToLeadFKList wtl = new WebToLeadFKList();
        List<WebToLead_fk_Setting__c> setting = [Select id From WebToLead_fk_Setting__c Limit 1];
        if(setting.size()>0){
            wtl.settingId = setting[0].Id;
        }
        wtl.deleteSetting();
    }
    
    //test for WebToLeadFKList
    public static testMethod void testMyController2() { 
        WebToLeadFKController wt = new WebToLeadFKController();
        WebToLeadFKController.getPicklistValues('Lead','LeadSource');
        WebToLeadFKController.saveLead('test', 'test', 'test', 'test', '', '','', '', '', '','', '', '');
    }

    //test for WebToLeadFKSettingController
    public static testMethod void testMyController3() { 
        WebToLeadFKSettingController wts = new WebToLeadFKSettingController();
    }
}