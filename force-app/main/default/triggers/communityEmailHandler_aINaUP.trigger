trigger communityEmailHandler_aINaUP on EmailMessage (after insert, after update)
{
    if(!system.isFuture() && !system.isBatch())
    {
    	emailMessage_communityEmailHandler.setVisibility(trigger.newMap.keySet());    
    }
}