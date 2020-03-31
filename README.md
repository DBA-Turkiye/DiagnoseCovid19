# Implementing COVID-19 Symptom Diagnosing by Using IBM Automation Solutions

This asset is created to show how to define a workflow inside [IBM BAW](https://www.ibm.com/products/business-automation-workflow) (Business Automation Workflow) including UI designs, service integration, database integration and ODM integration. It also gives information about how to integrate workflow data with [IBM BAI](https://www.ibm.com/support/knowledgecenter/SSYHZ8_19.0.x/com.ibm.dba.bai/topics/con_bai_overview.html) (Business Automation Insights) and generate custom graphics and reports from the data transferred to BAI. 

We chose a hot topic subject and implemented a workflow and ruleset which is related to COVID-19. It can be used by Ministry of Health or healthcare organizations in order to gather symptoms, disease history and physical information from citizens and diagnose if they are infected by COVID-19 or not.  It also helps these organizations to manage inform the citizens and conduct the emergency situations like quarantine if required. 

Required rules to diagnose symptoms are defined inside [IBM ODM](https://www.ibm.com/products/operational-decision-manager) (Operational Decision Manager) to make them easy to change quickly without the need of IT. 
It is very important to provide a flexible and easy to change platform in such situations. Since it is a new epidemic and each day as citizens we and health organizations are learning a new behaviour of this virus. So, the symptoms and affect on ironical diseases may differ day by day.  
All of the rulesets implemented inside ODM can easily be changed with the light of recommendations of medical boards. 

The know-how shared on this asset;

 * IBM BAW:
    * Implementing a workflow
    * Implementing user interfaces 
    * Implementing service integrations
    * How to call ODM services
    * Database integration
    * Views
    * Sending E-mail
    * Integrate date to IBM BAI using emitters
* IBM ODM:
    * Implementing a Decision Service on IBM ODM
    * Implement rules using decision tables
    * Implement rules by using if/then/else statements
    * Deploy a decision service. 
    * Test decision service through REST API. 
* IBM BAI:



