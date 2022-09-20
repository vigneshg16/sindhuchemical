<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Custom_Email_Alert_To_User</fullName>
        <description>Send Custom Email Alert To User</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_User_Task_Is_Created</template>
    </alerts>
</Workflow>
