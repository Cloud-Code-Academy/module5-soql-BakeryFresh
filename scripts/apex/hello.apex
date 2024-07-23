// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
        
        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : closedWonOpps) {
            accountIds.add(opp.AccountId);
        }
        // Query the Contacts
        List<Contact> contacts = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId IN :accountIds];
        // Create a map of Account Ids to the first Contact
        Map<Id, Id> accountToContactMap = new Map<Id, Id>();
        // Loop through each Contact and add the Account Id and Contact to the map
        for (Contact contact : contacts) {
            // If the Account Id is not already in the map, add it with the Contact Id
            if (!accountToContactMap.containsKey(contact.AccountId)) {
                accountToContactMap.put(contact.AccountId, contact.Id);
            }
        }
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        // Loop through each Opportunity        
        for (Opportunity opp : closedWonOpps) {
            if (accountToContactMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId);
                oppsToUpdate.add(opp);
            }
        }
        // Update the Opportunities
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }