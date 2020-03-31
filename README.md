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
	* Transfer data from BPM & ODM
	* Creating dashboards from collected data. 
	* Using emitters to collect data. 

## Product Versions
| Product       | Version       | 
| ------------- |:-------------:| 
| BAW       | 19.0.0.3		|	 
| ODM    |       |
| BAI |       |

## PreRequirements
* DB2 Database
* Common Toolkit should be imported to your BAW. Check the [repository](https://github.com/DBA-Turkiye/BAWCommonToolkit) and documentation for more information. 
* 

## Importing Projects

You can find the summary of required actions in order to import ODM & BPM project. 

# ODM - Operational Decision Manager

**Importing the decision service**
* Open Decision Center - https://YOURIP:PORT/decisioncenter/login
* Open Decision Service Library
* Click Import button on the upper left side of the window. 
* Choose .zip file that you downloaded from this repo under ODM folder. - Be sure that you have donwloaded the latest version.
* After uploading file, click Import. 

**Deploying the service**
* Click on the name of the Decision Service that you recently imported. 
* From Branches tab, Click main 
* From the toolbar, click Deploy to deploy this decision service. 
* Click deploy on the pop-up. 
* From Deployments tab, you can track the status of your deployment. 

**Exposing the rule via REST API**

* After successful deployment, open Rule Execution Server - https://YOURIP:PORT/res
* Click Explore Tab
* Click on the RuleApp named Corona_Diagnosing_RuleApp
* In the RuleApp View window, you will see all of the snapshots belong to your Rule App. 
* Click to latest snapshot to open Ruleset View.
* On the right upper side of the window, click "Retrieve HTDS Description File"
* Set below parameters;
  * Service Protocol Type: REST
  * Format: Open API/JSON
  * [x] Latest ruleset version
  * [x] Latest RuleApp version
  * [ ] Decision trace information
  * [ ] Inline types in separate XSD files
* Click download to download Swagger Json file of the REST API. You can use this json file to implement this REST Service inside IBM BAW. Since it has been done before inside Process Application, you don't need to take this action. If you need to make any changes in the Decision Service, you have to follow above steps. 
* By clicking Test button, you can make calls to the REST API and test your decision service.

# BAW - Business Automation Workflow

## Execute DB Scripts

Execute scripts inside SQL Scripts folder. Be sure that you have followed the required steps to import Common Toolkit [repository](https://github.com/DBA-Turkiye/BAWCommonToolkit) and executed DB Scripts inside there.

These scripts includes required parameters to be use inside this project such Sypmtoms for COVID-19, Gender, Medical Disease types, City, County information and some approval status parameters. 

##  Import Process Application

For more details you can check: [Importing and Exporting Process Applications](https://www.ibm.com/support/knowledgecenter/SS8JB4/com.ibm.wbpm.admin.doc/topics/managing_process_applications_E.html)

* Open IBM Workflow Center - https://YOURIP:PORT/WorkflowCenter/
* Click Import Process App
* Click Choose File to select Process Application file with .twx extension. You can download the latest version of the Process App from BAW folder under this repo.  
* In the Import Process App window, a name and acronym have been specified based on information in the file you selected.
* You can filter the messages by clicking Errors or Warnings.












