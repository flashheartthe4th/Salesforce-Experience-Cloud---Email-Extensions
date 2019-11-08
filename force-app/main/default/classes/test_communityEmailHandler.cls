@isTest
public class test_communityEmailHandler {
    
    @TestSetup
    static void makeData(){
        //create account
        Account newAccount = new Account();
        newAccount.Name = 'Test Case';
        insert newAccount;

        //create contact
        Contact toContact = new Contact();
        toContact.FirstName = 'Test';
        toContact.LastName = 'Contact';
        toContact.Email = 'ToAddress@theusefulautomation.dev';
        insert toContact;

        Contact ccContact = new Contact();
        ccContact.FirstName = 'Test';
        ccContact.LastName = 'Contact';
        ccContact.Email = 'CCAddress@theusefulautomation.dev';
        insert ccContact;

        //create case
        Case newCase = new Case();
        newCase.AccountId = newAccount.Id;
        newCase.ContactId = toContact.Id;
        newCase.Subject = 'Test Case Subject';
        newCase.Description = 'Test Case Description';
        insert newCase;

        EmailMessage emailMessage = new EmailMessage();
        emailMessage.ToAddress = 'ToAddress@theusefulautomation.dev';
        emailMessage.ParentId = [SELECT Id FROM Case LIMIT 1].Id;
        emailMessage.Subject = 'To Public';
        insert emailMessage;

        emailMessage = new EmailMessage();
        emailMessage.ToAddress = 'Noone@theusefulautomation.dev';
        emailMessage.CCAddress = 'ToAddress@theusefulautomation.dev';
        emailMessage.ParentId = [SELECT Id FROM Case LIMIT 1].Id;
        emailMessage.Subject = 'CC Public';
        insert emailMessage;

        emailMessage = new EmailMessage();
        emailMessage.ToAddress = 'Noone@theusefulautomation.dev';
        emailMessage.ParentId = [SELECT Id FROM Case LIMIT 1].Id;
        emailMessage.Subject = 'To Private';
        insert emailMessage;

        emailMessage = new EmailMessage();
        emailMessage.FromAddress = 'ToAddress@theusefulautomation.dev';
        emailMessage.ToAddress = 'paul@theusefulautomation.dev';
        emailMessage.ParentId = [SELECT Id FROM Case LIMIT 1].Id;
        emailMessage.Subject = 'Inbound Public';
        insert emailMessage;

        emailMessage = new EmailMessage();
        emailMessage.FromAddress = 'Private@theusefulautomation.dev';
        emailMessage.ToAddress = 'paul@theusefulautomation.dev';
        emailMessage.ParentId = [SELECT Id FROM Case LIMIT 1].Id;
        emailMessage.Subject = 'Inbound Private';
        insert emailMessage;

        emailMessage = new EmailMessage();
        emailMessage.ToAddress = 'Noone@theusefulautomation.dev';
        emailMessage.CCAddress = 'TOADDRESS@theusefulautomation.dev';
        emailMessage.ParentId = [SELECT Id FROM Case LIMIT 1].Id;
        emailMessage.Subject = 'UPPER CASE';
        insert emailMessage;

        Case noContactCase = new Case();
        noContactCase.AccountId = newAccount.Id;
        noContactCase.Subject = 'Test Case No Contact';
        noContactCase.Description = 'Test Case Description';
        insert noContactCase;

        emailMessage = new EmailMessage();
        emailMessage.ToAddress = 'Noone@theusefulautomation.dev';
        emailMessage.ParentId = noContactCase.Id;
        emailMessage.Subject = 'NO CONTACT CASE';
        insert emailMessage;
    }
    
    @IsTest
    static void publicOutboundTo(){
        
        test.startTest();

            system.assertEquals(true,[SELECT Id, IsExternallyVisible FROM EmailMessage WHERE Subject = 'To Public' LIMIT 1].IsExternallyVisible);

        test.stopTest();
        
    }

    @IsTest
    static void publicOutboundCC(){
               
        test.startTest();

            system.assertEquals(true,[SELECT Id, IsExternallyVisible FROM EmailMessage WHERE Subject = 'CC Public' LIMIT 1].IsExternallyVisible);

        test.stopTest();
        
    }

    @IsTest
    static void privateOutbound(){
                
        test.startTest();

            system.assertEquals(false,[SELECT Id, IsExternallyVisible FROM EmailMessage WHERE Subject = 'To Private' LIMIT 1].IsExternallyVisible);

        test.stopTest();
        
    }

    @IsTest
    static void publicInbound(){
                
        test.startTest();

            system.assertEquals(true,[SELECT Id, IsExternallyVisible FROM EmailMessage WHERE Subject = 'Inbound Public' LIMIT 1].IsExternallyVisible);

        test.stopTest();
        
    }

    @IsTest
    static void privateInbound(){
                
        test.startTest();

            system.assertEquals(false,[SELECT Id, IsExternallyVisible FROM EmailMessage WHERE Subject = 'Inbound Private' LIMIT 1].IsExternallyVisible);

        test.stopTest();
        
    }

    @IsTest
    static void publicUPPERCASE(){
                
        test.startTest();

            system.assertEquals(true,[SELECT Id, IsExternallyVisible FROM EmailMessage WHERE Subject = 'UPPER CASE' LIMIT 1].IsExternallyVisible);

        test.stopTest();
        
    }

    @IsTest
    static void privateDefault(){
                
        test.startTest();

            system.assertEquals(false,[SELECT Id, IsExternallyVisible FROM EmailMessage WHERE Subject = 'NO CONTACT CASE' LIMIT 1].IsExternallyVisible);

        test.stopTest();
        
    }
}