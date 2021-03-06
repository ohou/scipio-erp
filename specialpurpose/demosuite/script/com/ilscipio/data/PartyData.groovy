import java.sql.Timestamp

import org.ofbiz.base.crypto.HashCrypt
import org.ofbiz.base.util.Debug
import org.ofbiz.base.util.UtilDateTime
import org.ofbiz.base.util.UtilMisc
import org.ofbiz.base.util.UtilProperties
import org.ofbiz.base.util.UtilRandom
import org.ofbiz.base.util.UtilValidate
import org.ofbiz.common.login.LoginServices
import org.ofbiz.entity.*
import org.ofbiz.entity.util.*
import org.ofbiz.service.ServiceUtil

import com.ilscipio.scipio.ce.demoSuite.dataGenerator.DemoSuiteDataWorker
import com.ilscipio.scipio.ce.demoSuite.dataGenerator.MockarooDataGenerator
import com.ilscipio.scipio.ce.demoSuite.dataGenerator.dataObject.DemoDataPerson
import com.ilscipio.scipio.ce.demoSuite.dataGenerator.dataObject.DemoDataUserLogin

public Map createDemoParty() {
    final String resource_error = "DemoSuiteUiLabels";
    
    final String DEFAULT_USER_LOGIN_PWD = "ofbiz";
    
    // PartyTypeIds
    List<String> partyTypeIds = [
//        "AUTOMATED_AGENT",
//        "CORPORATION",
//        "FAMILY",
//        "GOVERNMENT_AGENCY",
//        "INFORMAL_GROUP",
//        "LEGAL_ORGANIZATION",
        "PARTY_GROUP",
        "PERSON"
//        "TEAM"
    ]
    
    // PartyStatus
    List<String> partyStatus = [
        "PARTY_DISABLED",
        "PARTY_ENABLED"
    ]
    
    // RoleTypeIds (only the parent ones though it would be great to have a list of roles identified by a main one to bring coherence)
     List<String> roleTypeIds = [
        "_NA_",
        "ACCOUNT_LEAD",
        "ACCOUNTANT",
        "ADMIN",
        "AGENT",
        "APPROVER",
        "AUTOMATED_AGENT_ROLE",
        "CALENDAR_ROLE",
        "CLIENT",
        "COMMENTATOR",
        "COMMEVENT_ROLE",
        "CONSUMER",
        "CONTENT",
        "CONTRACTOR",
        "CUSTOMER",
        "DISTRIBUTION_CHANNEL",
        "EBAY_ACCOUNT",
        "FAM_ASSIGNEE",
        "HOSTING_SERVER",
        "IMAGEAPPROVER",
        "ISP",
        "LOGGEDIN",
        "MAIN_ROLE",
        "MANUFACTURER",
        "OWNER",
        "PERSON_ROLE",
        "PROJECT_TEAM",
        "PROSPECT",
        "REFERRER",
        "REQUEST_ROLE",
        "REVIEWER",
        "SCRUM_MEMBER",
        "SHAREHOLDER",
        "SUBSCRIBER",
        "VENDOR",
        "VISITOR",
        "WEB_MASTER",
        "WORKFLOW_ROLE"
    ]

    Debug.logInfo("-=-=-=- DEMO DATA CREATION SERVICE - PARTY DATA-=-=-=-", "");
    Map result = ServiceUtil.returnSuccess();
    
    List<GenericValue> toBeStored = new ArrayList<GenericValue>();
    List<GenericValue> partyEntrys = new ArrayList<GenericValue>();
    int num = context.num;
    
    List<DemoDataPerson> generatedPersons = DemoSuiteDataWorker.generatePerson(num, MockarooDataGenerator.class);
    List<DemoDataUserLogin> generatedUserLogins = DemoSuiteDataWorker.generateUserLogin(num, MockarooDataGenerator.class);
     
    if ( (UtilValidate.isNotEmpty(generatedPersons) && generatedPersons.size() == num) 
        && (UtilValidate.isNotEmpty(generatedUserLogins) && generatedUserLogins.size() == num)) {
        for(int i = 0; i <num; i++) {
            String partyId = "GEN_" + delegator.getNextSeqId("demo-partyId");
            String partyTypeId = partyTypeIds.get(UtilRandom.random(partyTypeIds));        
            String partyStatusId = partyStatus.get(UtilRandom.random(partyStatus)); 
            minDate = UtilDateTime.nowDate();
            if (context.minDate != null)
                minDate = new Date(context.minDate.getTime());
            Timestamp createdDate = Timestamp.valueOf(UtilRandom.generateRandomDate(minDate, context));
            Debug.log("partyId ====> " + partyId + " partyTypeId ======> " + partyTypeId + " partyStatusId ==========> " + partyStatusId);        
            Map fields = UtilMisc.toMap("partyId", partyId, "partyTypeId", partyTypeId, "statusId", partyStatusId, "description", partyId + " description", "createdDate", createdDate);    
            GenericValue party = delegator.makeValue("Party", fields);
            toBeStored.add(party);

            String roleTypeId = roleTypeIds.get(UtilRandom.random(roleTypeIds));
            fields = UtilMisc.toMap("roleTypeId", roleTypeId, "partyId", partyId);        
            GenericValue partyRole = delegator.makeValue("PartyRole", fields);        
            toBeStored.add(partyRole);
            
            DemoDataPerson demoDataPerson = generatedPersons.get(i);            
            String salutation = demoDataPerson.getTitle();
            String firstName = demoDataPerson.getFirstName();
            String lastName = demoDataPerson.getLastName();
            String gender = demoDataPerson.getGender();
            
            g = "M";
            if (gender.toUpperCase().startsWith("F"))
                g = "F";
            fields = UtilMisc.toMap("partyId", partyId, "salutation", salutation, "firstName", firstName, "lastName", lastName, "gender", g);
            Debug.log("partyId ========> " + partyId + "  salutation ==========> " + salutation + "    firstName ===============> " + firstName + "          lastName ===============> " + lastName + "   gender ===========> " + g);
            GenericValue person = delegator.makeValue("Person", fields);
            toBeStored.add(person);
            
            DemoDataUserLogin demoDataUserLogin = generatedUserLogins.get(0);
            String userLoginId = demoDataUserLogin.getUserLoginId();
            String currentPassword = demoDataUserLogin.getCurrentPassword();
            if (!context.generatePassword)
                currentPassword = DEFAULT_USER_LOGIN_PWD;
            boolean useEncryption = "true".equals(EntityUtilProperties.getPropertyValue("security.properties", "password.encrypt", delegator));
            if (useEncryption)
                currentPassword = HashCrypt.cryptUTF8(LoginServices.getHashType(), null, currentPassword)
            userLoginEnabled = "Y";
            if (partyStatusId.equals("PARTY_DISABLED"))
                userLoginEnabled = "N";
            
            fields = UtilMisc.toMap("partyId", partyId, "userLoginId", userLoginId, "currentPassword", currentPassword, "enabled", userLoginEnabled);
            Debug.log("partyId ========> " + partyId + "  userLoginId ==========> " + userLoginId);
            GenericValue userLogin = delegator.makeValue("UserLogin", fields);
            toBeStored.add(userLogin);
        }
    }
    
    // store the changes
    if (toBeStored.size() > 0) {
        try {
            Debug.log("Storing parties")
            delegator.storeAll(toBeStored);
            result.put("generatedData", toBeStored);
        } catch (GenericEntityException e) {
            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
                "PartyErrorCannotStoreChanges", locale) + e.getMessage());
        }
    }
    
    return result;
}

