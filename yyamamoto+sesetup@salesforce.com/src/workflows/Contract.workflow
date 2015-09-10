<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ActionEmail2</fullName>
        <description>法人契約申請承認</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>アシスタント</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>リーダー</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>リーダー補佐</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>責任者</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EmailTemplate2</template>
    </alerts>
    <alerts>
        <fullName>ActionEmail3</fullName>
        <description>法人契約申請却下</description>
        <protected>false</protected>
        <recipients>
            <recipient>アシスタント</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>リーダー</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>リーダー補佐</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>責任者</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EmailTemplate5</template>
    </alerts>
    <fieldUpdates>
        <fullName>ActionFieldUpdate1</fullName>
        <field>Status</field>
        <literalValue>有効</literalValue>
        <name>有効化</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ActionFieldUpdate2</fullName>
        <field>ActivatedDate</field>
        <formula>NOW()</formula>
        <name>有効日更新</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>statusupdate1</fullName>
        <field>Status</field>
        <literalValue>承認処理中</literalValue>
        <name>ステータス更新</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>