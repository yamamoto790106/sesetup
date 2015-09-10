public class EventEditController_Test{
    public static testMethod void testMyController() {
        //テストデータ作成
         Account acc = new Account(name='テスト取引先');
        insert acc;
      
        Opportunity Opp = new Opportunity(Name='テスト商談',StageName='コンタクト',accountId=Acc.id,Amount=10000.0,CloseDate=System.today());        
        insert opp;
        
        Event eve = new Event(Subject='テスト活動',ActivityDate=date.newInstance(2008, 12, 1),ActivityDateTime=datetime.newInstance(2008, 12, 1,12,0,0),DurationInMinutes=60,WhatId=opp.id);
        insert eve;
        
        //コントローラーを作成
         EventEditController controller = new EventEditController();
       
        //ページの引数を渡す。
        ApexPages.currentPage().getParameters().put('id', eve.id);
        ApexPages.currentPage().getParameters().put('WhatId', eve.WhatId);
                
        //コントローラのデータ取得ロジックを呼び出す
        controller.getEvent();
        controller.getOpportunity();
       
        //保存処理を実施
        String nextPage = controller.save().getUrl();
        
        //キャンセル処理を実施
        String ReturnPage = controller.cancel().getUrl();
        
        //assertEqualsテスト実施
        System.assertEquals('/apex/eventeditresult?id=' + eve.id,nextPage);
        System.assertEquals('/' + eve.id,ReturnPage);
        
        Opportunity[] OppResult = [select id,Name,StageName,Description,CloseDate,Amount from Opportunity where Id =: opp.id];
        Event[] EventResult = [select id, Location, Subject,ActivityDatetime,Description from Event where id =: eve.id];

        System.assertEquals(OppResult[0].Name,'テスト商談');
        System.assertEquals(EventResult[0].Subject,'テスト活動');
    }
}