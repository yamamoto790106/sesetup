@istest
private class ApplicationFormPublisherTest{
    static testMethod void applicationFormTest(){
        PageReference pageRef = Page.applicationFormPublisher;
        Test.setCurrentPageReference(pageRef);

        
        //create account for opportunity
        Account account = new Account(Name='Switchfoot Kabushikigaisha', AccountNumber='54321',
            Phone='123456789', BillingPostalCode='89811111', BillingState='Kanagawa', BillingCity='Yokohama',
            BillingStreet='The Club of Excellent Coast');
        insert account;
        
        //create opportunity
        Opportunity opportunity = new Opportunity(Name='Opportunity 1', StageName='Open', CloseDate=Date.today(), accountId = account.Id);
        insert opportunity;

        //create contact for opportunity
        Contact contact = new Contact(FirstName='Riezel', LastName='Takahashi', Email='r@test.com');
        insert contact;

        OpportunityContactRole opportunityContact = new OpportunityContactRole(OpportunityId=opportunity.Id, ContactId=contact.Id, IsPrimary=true);
        insert opportunityContact;

        ApexPages.CurrentPage().getparameters().put('id', opportunity.id);
        ApexPages.StandardController sc = new ApexPages.standardController(opportunity);
        ApplicationFormPublisherController ctrl = new ApplicationFormPublisherController(sc);
        System.assertNotEquals('', ctrl.getContract());
        
        //createApplicationForm
        List<String> paramList = ApplicationFormPublisherController.createApplicationForm('test signature', 
            new Opportunity(Id=opportunity.Id, StageName='Closed Won'), 
            new Account(Id=account.Id, Name=account.Name, AccountNumber=account.AccountNumber, Phone=account.Phone,
                BillingPostalCode=account.BillingPostalCode, BillingState=account.BillingState, 
                BillingCity=account.BillingCity, BillingStreet=account.BillingStreet), 
            new Contact(Id=ctrl.mainContact.Id, Email=ctrl.mainContact.Email)); 
        System.assertEquals(2, paramList.size());           
        
        //emailPDF
        ApplicationFormPublisherController.emailPDF(paramList.get(0), paramList.get(1), ctrl.mainContact.Email);        

        //test pdf call
        ApexPages.CurrentPage().getparameters().put('oppId', paramList.get(0));
        ApexPages.CurrentPage().getparameters().put('attachId', paramList.get(1));
        ctrl = new ApplicationFormPublisherController();
        ctrl.initPDF();

        System.assertNotEquals('', ctrl.getContractForPDF1());
        System.assertNotEquals('', ctrl.getContractForPDF2());
        System.assertNotEquals('', ctrl.getContractForPDF3());        
    }

}