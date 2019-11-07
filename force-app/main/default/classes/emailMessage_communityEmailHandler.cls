//this runs WITHOUT SHARING as the system determines the visibility
public without sharing class emailMessage_communityEmailHandler {

    @future
    public static void setVisibility(Set<Id> emailRecordIds)
    {
        system.debug(system.LoggingLevel.DEBUG,'Received Email Records: ' + emailRecordIds);
        //this only gets email messages where the parent Id is a case, key prefix is 500
        EmailMessage[] emailMessages = [SELECT Id, toAddress, ccAddress, Subject, IsExternallyVisible, ParentId, FromAddress FROM EmailMessage WHERE Id IN :emailRecordIds AND ParentId <> NULL];
        setvisibility(emailMessages);
    }

    //this sets the visibility
    @TestVisible
    private static void setvisibility(EmailMessage[] emailMessages)
    {
        //now we need to get the contact from the cases
        Set<Id> caseIds = new Set<Id>();
        for(EmailMessage emailMessage:emailMessages)
        {
            if(String.isNotBlank(emailMessage.ParentId))
            {
                if(String.ValueOf(emailMessage.ParentId).startsWith('500'))
                {
                    caseIds.add(emailMessage.ParentId);
                }
            }
        }

        //now we get the cases and the contacts into a map
        Map<Id,Case> caseToContactMap = new Map<Id,Case>([SELECT Id, ContactId, Contact.Id, Contact.Email FROM Case WHERE Id IN :caseIds]);

        for(EmailMessage emailMessage:emailMessages)
        {
            Contact caseContact = caseToContactMap.get(emailMessage.ParentId).Contact;
            system.debug(system.LoggingLevel.DEBUG,'caseContact: '+caseContact);
            try
            {
                system.debug(system.LoggingLevel.DEBUG,'Email Subject: '+emailMessage.subject);
                system.debug(system.LoggingLevel.DEBUG,'Email is linked to contact: '+caseContact.Email);
                system.debug(system.LoggingLevel.DEBUG,'Email was sent to: '+emailMessage.toAddress);
                system.debug(system.LoggingLevel.DEBUG,'Email ccd to: '+emailMessage.ccAddress);
                emailMessage.IsExternallyVisible = false;

                if(string.isNotBlank(emailMessage.toAddress))
                {
                    if(emailMessage.toAddress.containsIgnoreCase(caseContact.Email))
                    {
                        system.debug(system.LoggingLevel.DEBUG,'Email was sent to Case Contact: '+caseContact.Email +' Setting to Visible.');
                        emailMessage.IsExternallyVisible = true;
                    }
                }

                if(string.isNotBlank(emailMessage.ccAddress))
                {
                    if(emailMessage.ccAddress.containsIgnoreCase(caseContact.Email))
                    {
                        system.debug(system.LoggingLevel.DEBUG,'Email was cc\'d to Case Contact: '+caseContact.Email +' Setting to Visible.');
                        emailMessage.IsExternallyVisible = true;
                    }
                }

                if(string.isNotBlank(emailMessage.FromAddress))
                {
                    if(emailMessage.FromAddress.containsIgnoreCase(caseContact.Email))
                    {
                        system.debug(system.LoggingLevel.DEBUG,'Email was from the Case Contact: '+caseContact.Email +' Setting to Visible.');
                        emailMessage.IsExternallyVisible = true;
                    }
                }
            }
            catch(exception e)
            {
                system.debug(system.LoggingLevel.ERROR,'Email is private as error occurred. Setting to Hidden.');
                system.debug(system.LoggingLevel.ERROR,e);
                emailMessage.IsExternallyVisible = false;
            }

            system.debug(system.LoggingLevel.DEBUG,'Email: '+emailMessage);
        }

        update emailMessages;

        Map<Id,EmailMessage> emailMessageMap = new Map<Id,EmailMessage>();
        emailMessageMap.putAll(emailMessages);

        //now we get all the feed items linked to emails and the case
        //at time of writing there is no way to only get the feed items linked to the email messages via SOQL
        FeedItem[] feedItems = [SELECT Id, Visibility FROM FeedItem WHERE ParentId IN :caseIds AND Type = 'EmailMessageEvent'];
        system.debug(system.LoggingLevel.DEBUG,'Retrieved FeedItems: '+feedItems);

        //now call the feed item update
        feedItem_communityEmailHandler.setVisibility(feedItems,emailMessageMap);
    }
}
