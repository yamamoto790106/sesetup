global class ApplicationFormPublisherController{
    public Opportunity pdfOpportunity{get; set;}
    public String signatureId{get; set;}
    public String opportunityId{get; set;}
    public Contact mainContact{get; set;}
    
    public ApplicationFormPublisherController(){
    }
    
    public void initPDF(){
        opportunityId = ApexPages.currentPage().getParameters().get('oppId');
        signatureId = ApexPages.currentPage().getParameters().get('attachId');

        if(!String.isEmpty(opportunityId)){
            List<Opportunity> oppList = [select Name, Account.Name, Account.Phone, Account.AccountNumber,
                Account.BillingPostalCode, Account.BillingState, Account.BillingCity, Account.BillingStreet
                from Opportunity where Id=:opportunityId];
            if(oppList!=null && oppList.size()>0){
                pdfOpportunity = oppList.get(0);
            }
            mainContact = initContact(opportunityId);
            System.debug(pdfOpportunity);
        }
    }
    public ApplicationFormPublisherController(ApexPages.StandardController controller) {
        SObject parent = controller.getRecord();
        opportunityId = parent.Id;
        mainContact = initContact(opportunityId);
    }

        
    private Contact initContact(Id oppId){
        List<Contact> contactList = [select Id, Name, Email from Contact where Id in 
            (select ContactId from OpportunityContactRole where OpportunityId=:oppId and IsPrimary=true)];
        if(contactList!=null && contactList.size()>0){
            return contactList.get(0);
        }else return null;
    }
    
    public String getContract(){
        return '本マスターサブスクリプション契約（以下「本契約」といいます）は、お客様による本サービスの取得及び利用に適用されます。'
            + '\n'
            + 'お客様が、本サービスの無料トライアルに登録される場合には、本契約は、その無料トライアルにも適用されることとします。'
            + '\nお客様が、本契約の承諾を示すBOXをクリックするか、又は本契約を参照した注文書に署名もしくは記名捺印することによって本契約を承諾した場合、\n'
            + 'お客様は、本契約の条件に同意したことになります。'
            + '\nお客様が、会社その他の法人を代表して本契約を締結している場合には、お客様は、以下の条件に関して当該法人及びその関係会社を、\n'
            + '本契約により拘束する権限を有することを表明したこととなります。'
            + 'その場合には、「お客様」又は｢お客様の｣という用語は、当該法人又はその関係会社を言うものとします。'
            + '\nお客様がそのような権限を有しない場合、又は本契約に同意されない場合には、本契約を承諾してはならず、本サービスを利用することはできません。\n';
    }
    public String getContractForPDF1(){
        return 'Please read these Terms and Conditions carefully before using the service. \n'
            + 'This Agreement sets forth the legally binding terms and conditions for your use of the service.';
    }
    public String getContractForPDF2(){
        return '\n\n1. Termination. We may terminate the service, without cause or notice, which '
            + 'may result in the forfeiture and destruction of all information associated with '
            + 'you. All provisions of this Agreement that by their nature should survive '
            + 'termination shall survive termination, including, without limitation, ownership '
            + 'provisions, warranty disclaimers, indemnity, and limitations of liability.';
    }
    public String getContractForPDF3(){
        return '\n\n2. Governing Law. This Agreement (and any further rules, polices, or '
            + 'guidelines incorporated by reference) shall be governed and construed in '
            + 'accordance with the laws of Japan, without giving effect to any principles of '
            + 'conflicts of law.';
    }

    private static void saveContractToOpportunity(Blob body, String oppId) {
        Attachment attachment = new Attachment();
        attachment.Name = 'contract.pdf';
        attachment.Body = body;
        attachment.ParentId = oppId;
        attachment.IsPrivate = false;
        insert attachment;
    }

    @RemoteAction    
    global static void emailPDF(String oppId, String signId, String contactEmail){
        PageReference pdf = Page.applicationFormPDF;
        pdf.getParameters().put('oppId', oppId);
        pdf.getParameters().put('attachId', signId);
        Blob body;
        if (Test.IsRunningTest()){
            body=Blob.valueOf('UNIT.TEST');
        }else{
            body = pdf.getContentAsPdf();
        }        
        
        saveContractToOpportunity(body, oppId);
        
        if(!String.isEmpty(contactEmail)){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('ご契約書 複写送付のご連絡');
            String [] toAddresses = new String[] {contactEmail};
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('ご契約ありがとうございました。契約書のコピーをお送りいたしますのでご確認ください。');
    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('contract.pdf');
            efa.setBody(body); //attach the PDF
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            Messaging.SendEmailResult [] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    private static String saveSignature(Id oppId, String signatureData){
        Attachment signature = new Attachment();
        signature.Name = 'signature.png';
        signature.Body = EncodingUtil.base64Decode(signatureData.remove('data:image/png;base64,'));  // data
        signature.ParentId = oppId;  // parent record Id
        signature.IsPrivate = false;
        signature.contentType = 'image/png';
        insert signature;
        return signature.Id;
    }
    private static String saveOpportunity(Opportunity opportunity){
        try{
            upsert opportunity;
            return opportunity.Id;
        }catch(Exception e){
            System.debug('error in upsert opportunity: ' + e);
        }
        return null;
    }
    private static String saveAccount(Account account){
        try{
            upsert account;
            return account.Id;
        }catch(Exception e){
            System.debug('error in upsert account: ' + e);
        }
        return null;
    }
    private static String saveContact(Contact contact){
        if(contact==null) return null;
        try{
            upsert contact;
            return contact.Id;
        }catch(Exception e){
            System.debug('error in upsert contact: ' + e);
        }
        return null;
    }

    @RemoteAction
    global static List<String> createApplicationForm(String signatureData, Opportunity opportunity, Account account, Contact contact){
        saveOpportunity(opportunity);
        saveAccount(account);
        saveContact(contact);
        String signId = saveSignature(opportunity.Id, signatureData);

        List<String> paramList = new List<String>();
        paramList.add(opportunity.Id);
        paramList.add(signId);
        return paramList;
    }

}