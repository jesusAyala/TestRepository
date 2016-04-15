/**
 * Trigger centual adapter for all EmailMessage
 * @author Nikhil Pimpale
 */
trigger EmailMessageTrigger on EmailMessage (before insert,after insert) {
    ClsTriggerFactory.createHandler(EmailMessage.sObjectType);
}