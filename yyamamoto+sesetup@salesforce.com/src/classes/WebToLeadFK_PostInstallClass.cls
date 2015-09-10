global class WebToLeadFK_PostInstallClass implements InstallHandler {
  global void onInstall(InstallContext context) {
    WebToLead_fk_Setting__c wtls = new WebToLead_fk_Setting__c();
    wtls.Name = 'Default';
    Insert wtls;
  }
}