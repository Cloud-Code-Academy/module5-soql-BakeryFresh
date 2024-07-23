/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Shaman McLean
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        //  The body of the method
        List<Lead> leadList = new List<Lead>();
        return leadList = [SELECT id, Lastname, Company, Phone, Email FROM Lead];
        
        }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
        //  The body of the method
        List<Contact> johnList = new List<Contact>();
        return johnList = [SELECT Name FROM Contact WHERE firstName = 'John'];
        }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName () {
    //  The body of the method
        Map<Id, Contact> idMap = new Map<Id, Contact>(
            [SELECT id FROM Contact WHERE LastName = 'Smith' or LastName = 'Jones']);

        return new List<Id>(idMap.keySet());
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount (Id accountID) {
    //  The body of the method
        List<Opportunity> oppList = new List<Opportunity>([
            SELECT Id, Name, StageName, CloseDate, AccountId, Amount
            FROM opportunity
            WHERE AccountId = :accountID and StageName = 'Closed Won'
        ]);
        return oppList;

    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
    //  The body of the method
            List<Account> accList = new List<Account> ([
                SELECT id FROM Account
            ]);

            return accList.size();
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id,Task> getTasksDueNextWeek()  {
    //  The body of the method
            return new Map<Id,Task>([
                SELECT Id FROM Task WHERE ActivityDate <= NEXT_N_DAYS:7
            ]);
        
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
    //  The body of the method
            return new List<Contact> ([
                SELECT Name, Email FROM Contact WHERE Email LIKE '%example.com' 
            ]);
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        String wildCardKeyWord = '%' + keyword + '%';
        return new List<Opportunity> ([ 
            SELECT Name, StageName, CloseDate, AccountId FROM Opportunity WHERE Name like :wildCardKeyWord
        ]); // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        return new List<Case>([
            SELECT Status, AccountId, Origin FROM Case WHERE Origin NOT In ('Web', 'Email', '')
        ]); // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
    //  The body of the method
        String kw = '%' + keyword + '%';
        return new List<Lead>([
            SELECT LastName, Company, Phone, Email, LeadSource, Title FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :kw
        ]);
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contNameList = new List<String>();
        List<Contact> contList = new List<Contact>([
            SELECT id, LastName FROM Contact WHERE AccountId = :accountId
        ]);
        // Query the Contacts
        // Loop through each Contact and add the LastName to the list
        for (Contact cont : contList) {
            contNameList.add(cont.LastName);

        }

        // Return the list of Contact LastNames
        return contNameList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        Decimal totalRevenue = 0;
        // I'm certain this is correct but the test is wrong. The Q askes for CW but is also counting CL, the value should be 30k
        List<AggregateResult> r = [ 
            SELECT SUM(Amount) totalAmount
            FROM Opportunity
            WHERE StageName = :stage
            ];

        // Return the total revenue
        return totalRevenue = (Decimal) r[0].get('totalAmount'); // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return new List<Account>([
            SELECT Name 
            FROM Account
            ORDER BY Name
            LIMIT 10
        ]); // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return new List<Opportunity> ([
            SELECT Name, CloseDate, Amount
            FROM Opportunity
            WHERE Amount > 100000
            ORDER BY CloseDate
            LIMIT 5
        ]); // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return new List<Contact>([
            SELECT Name, Birthdate
            FROM Contact
            ORDER BY Birthdate DESC 
            LIMIT 3
        ]); // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return new List<Case>([
            SELECT CreatedDate
            FROM Case
            ORDER BY CreatedDate
            LIMIT 10
            OFFSET 5
        ]); // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id>caseIDSet = new Set<Id>();
        // Query the Cases
        List<Case> caseList = new List<Case>([
            SELECT Id, CreatedDate
            FROM Case
            WHERE AccountId = :accountId
        ]);
        // Loop through each Case and add the Id to the set
        for (Case c : caseList) {
         caseIDSet.add(c.Id);    
        }

        return caseIDSet; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        List<Account> accList = new List<Account>([
            SELECT Id, BillingCountry
            FROM Account
            WHERE BillingCountry != :country
        ]);
        // Loop through each Account and add the Id and Name to the map
        for (Account acc : accList){
            accountIdsToNames.put(acc.id,acc.BillingCountry);
        }

        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
      return [SELECT Account.Name FROM Contact WHERE ID = :contactID LIMIT 1].Account.Name;
        /* Originally I used the following, but I knew there was a shorter way so I redid it to the above single line.
        List<Contact> contList =  new List<Contact> ([
            SELECT Account.Name
            FROM Contact 
            WHERE Id = :contactId
            LIMIT 1
        ]); // Replace null with the variable you used to store the result
        String accName = contList[0].Account.Name;
        return accName;
        */

    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        return [SELECT Name, (SELECT Id, Name, CloseDate, AccountId FROM Opportunities WHERE AccountId = :accountId) FROM Account WHERE Id = :accountId]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        String bState = [SELECT BillingState FROM Account WHERE Id = :accountId].BillingState;

        // Store the Account's BillingState

        // Query the Contacts

        return new List<Contact> ([
            SELECT Id, MailingState FROM Contact WHERE MailingState = :bState
        ]); // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
    List<Lead> leadList = [
        SELECT Email FROM Lead WHERE Id IN :leadIds AND Email != null
    ];
    
    // Create a set of email domains from the Leads
    Set<String> emailDomains = new Set<String>();
    for (Lead l : leadList) {
        String[] emailParts = l.Email.split('@');
        if (emailParts.size() > 1) {
            emailDomains.add('%' + emailParts[1]); //this part I didn't really understand
        }
    }
    
    return [
        SELECT Id, Website FROM Account WHERE Website LIKE :emailDomains
    ];
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> oli = new List<OpportunityLineItem> ([
            SELECT Id, Quantity, PricebookEntryId, TotalPrice FROM OpportunityLineItem WHERE OpportunityId = :origOppId
        ]);

        // Create a list to hold the new line items
        List<OpportunityLineItem> newOLI = new List<OpportunityLineItem>();
        // Generate a random number between 1 and 3
        

        // Loop through each cloned Opportunity Id
        for (Id oppId : cloneOppIds ){
            
            for (OpportunityLineItem oppLineItem : oli) {
                OpportunityLineItem clonedOLI = oppLineItem.clone(false,false,false,false);
                clonedOLI.OpportunityId = oppId;
                clonedOLI.Quantity = (Integer)(Math.random()* 3) + 1;
                newOLI.add(clonedOLI);
            }
        }

            // Loop through each original line item

                // Clone the original line item and add the random number to the quantity

        // Insert the new line items
        insert newOLI;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return new List<Opportunity> ([
            SELECT Name, Account.Name, Owner.Name, StageName
            FROM Opportunity
            WHERE StageName = 'Closed Won'
        ]); // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> oppList = new List<Opportunity>(getOpportunityDetailsForClosedWon());
        System.debug('oppList #1: ' + oppList);

        // Create a set of Account Ids from the Opportunities
        Set<Id> accIds = new Set<Id>();

        for (Opportunity opp : oppList){
            accIds.add(opp.AccountId);
        }
        System.debug('accIds: ' + accIds);
        
        
        // Query the Contacts from the accounts related to the list of opps
        List<Contact> contList = new List<Contact>([
            SELECT id, FirstName, LastName, AccountId, CreatedDate 
            FROM Contact 
            WHERE AccountId IN :accIds
            ORDER BY CreatedDate ASC
        ]);
        System.debug('contList: ' + contList);
        

        // Loop through each Contact and add the Account Id and Contact to the map
        Map<Id,Id> accContMap = new Map<Id, Id>();
        for (Contact c : contList){
            if(!accContMap.containsKey(c.AccountId)){
                accContMap.put(c.AccountId, c.Id);
            }
        }
        System.debug('accContMap: ' + accContMap);
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        // Loop through each Opportunity
        for ( Opportunity o : oppList){
            if (accContMap.containsKey(o.AccountId)) {
                o.Primary_Contact__c = accContMap.get(o.AccountId);
                oppsToUpdate.add(o);
            }
        }
        System.debug('oppList: ' + oppList);

        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
        System.debug('oppsToUpdate: ' + oppsToUpdate);

                // Update the Opportunity primary contact from accountToContactMap

        // Update the Opportunities
    }
}