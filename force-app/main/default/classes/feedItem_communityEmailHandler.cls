//this runs WITHOUT SHARING as the system determines the visibility
public without sharing class feedItem_communityEmailHandler
{
	public static void setVisibility(FeedItem[] feedItems,Map<Id,EmailMessage> emailMessageMap)
    {
        system.debug(SYSTEM.LoggingLevel.DEBUG,'Go through all of the Feed Items');

        FeedItem[] feedItemsToUpdate = new FeedItem[]{};

        for(FeedItem feedItem:feedItems)
        {
            system.debug(SYSTEM.LoggingLevel.DEBUG,'Processing Feed Item: '+feedItem.Id);
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(null,feedItem.Id);

            if(feedElement.capabilities != null)
            {
                system.debug(SYSTEM.LoggingLevel.DEBUG,'Feed Item Has Capabilities');
                if(feedElement.capabilities.emailMessage != null)
                {
                    system.debug(SYSTEM.LoggingLevel.DEBUG,'Feed Item is linked to Email Message: '+feedElement.capabilities.emailMessage.emailMessageId);

                    //we check for the presence of the email message in the map, as we are processing ALL
                    //feed items, but only processing new emails, so there can be more feed items than email messages
                    //when we can query just the feed items linked to the email messages the collections will be the same
                    if(emailMessageMap.containsKey(feedElement.capabilities.emailMessage.emailMessageId)) {

                        if(emailMessageMap.get(feedElement.capabilities.emailMessage.emailMessageId).IsExternallyVisible)
                        {
                            if(feedItem.Visibility != 'AllUsers')
                            {
                                feedItem.Visibility = 'AllUsers';
                                feedItemsToUpdate.add(feedItem);
                            }
                        }
                        else
                        {
                            if(feedItem.Visibility != 'InternalUsers')
                            {
                                feedItem.Visibility = 'InternalUsers';
                                feedItemsToUpdate.add(feedItem);
                            }
                        }
                    }
                }
            }
        }

        update feedItemsToUpdate;
    }
}