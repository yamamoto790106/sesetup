public with sharing  class EventEditController {

 Event event;
 Opportunity opp;

    //行動の情報を取得
    public Event getEvent() {
      if(event ==null)
        event = [select id, Location, Subject,ActivityDatetime,Description from Event where id = :ApexPages.currentPage().getParameters().get('id')];
      return event;
    }
 
    //商談の情報を取得
    public Opportunity getOpportunity() {
      String strWhatId = ApexPages.currentPage().getParameters().get('whatid');
      if(strWhatId == ''){
        opp = new Opportunity();
      }else if(opp == null){
        opp= [select id,Name,StageName,Description,CloseDate,Amount from Opportunity where id = :strWhatId ];
      }
      return opp;
    }
    
    //保存処理
    public PageReference save(){
      update event;
      String strWhatId = System.currentPageReference().getParameters().get('whatid');
      
      if(strWhatId != ''){
        update opp;
      }
      
      //保存後のページにリダイレクト
      PageReference eventPage = new PageReference('/apex/eventeditresult?id=' + event.id);
      eventPage.setRedirect(true);
      return eventPage;

    }
    
    //キャンセル処理
    public PageReference cancel(){
      
      //キャンセル時のページにリダイレクト
      PageReference eventPage = new PageReference('/' + event.id);
      eventPage.setRedirect(true);
      return eventPage;

    }
}