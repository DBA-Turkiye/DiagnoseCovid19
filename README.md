<!-- vscode-markdown-toc -->
* 1. [Summary](#Summary)
* 2. [Shared Know-How](#SharedKnow-How)
* 3. [Product Versions](#ProductVersions)
* 4. [PreRequirements](#PreRequirements)
* 5. [ODM - Operational Decision Manager](#ODM-OperationalDecisionManager)
	* 5.1. [Importing the decision service](#Importingthedecisionservice)
	* 5.2. [Deploying the service](#Deployingtheservice)
	* 5.3. [Exposing the rule via REST API](#ExposingtheruleviaRESTAPI)
	* 5.4. [ODM Decision Service Details](#ODMDecisionServiceDetails)
		* 5.4.1. [Draw a decision model and define input and output data types](#Drawadecisionmodelanddefineinputandoutputdatatypes)
* 6. [BAW - Business Automation Workflow](#BAW-BusinessAutomationWorkflow)
	* 6.1. [Execute DB Scripts](#ExecuteDBScripts)
	* 6.2. [ Import Process Application](#ImportProcessApplication)
	* 6.3. [Change ODM Host Information](#ChangeODMHostInformation)
	* 6.4. [Add Environment Variable](#AddEnvironmentVariable)
	* 6.5. [Starting the Process from Process Portal](#StartingtheProcessfromProcessPortal)
	* 6.6. [BPMN 2.0 Workflow](#BPMN2.0Workflow)
	* 6.7. [User Interface](#UserInterface)
	* 6.8. [Recommendation & Home Quarantine Email Content](#RecommendationHomeQuarantineEmailContent)
* 7. [Business Automation Insights](#BusinessAutomationInsights)
	* 7.1. [BAI Architecture](#BAIArchitecture)
	* 7.2. [COVID - 19 Dashboard](#COVID-19Dashboard)
	* 7.3. [WhatisaKibanadashboard](#WhatisaKibanadashboard)
		* 7.3.1 [How do I create dashboards in Kibana?](#HowdoIcreatedashboardsinKibana)
	* 7.3. [Data Transmitted to the BAI form BAW](#DataTransmittedtotheBAIformBAW)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->


# Implementing COVID-19 Symptom Diagnosing by Using IBM Automation Solutions
* 🧿

***Disclaimer:** If you are planning to open this diagnosing tool to public, It is highly recommended to change the rules implemented inside ODM which combines symptoms and diseases with the help of a health professional before going live.*

##  1. <a name='Summary'></a>Summary

This asset is created to show how to define a workflow inside [IBM BAW](https://www.ibm.com/products/business-automation-workflow) (Business Automation Workflow) including UI designs, service integration, database integration and ODM integration. It also gives information about how to integrate workflow data with [IBM BAI](https://www.ibm.com/support/knowledgecenter/SSYHZ8_19.0.x/com.ibm.dba.bai/topics/con_bai_overview.html) (Business Automation Insights) and generate custom graphics and reports from the data transferred to BAI. 

It can be used by Ministry of Health or healthcare organizations in order to gather symptoms, disease history and physical information from citizens and diagnose if they are infected by COVID-19 or not.  It also helps these organizations to manage inform the citizens and conduct the emergency situations like quarantine / sending ambulance / monitoring the patient during home quarantine if required. 

Required rules to diagnose symptoms are defined inside [IBM ODM](https://www.ibm.com/products/operational-decision-manager) (Operational Decision Manager) to make them easy to change quickly without the need of IT. 
It is very important to provide a flexible and easy to change platform in such situations. Since it is a new epidemic and each day as citizens, we and health organizations are learning a new behaviour of this virus. So, the symptoms and affect on cronical diseases may differ day by day.  
All of the rulesets implemented inside ODM can easily be changed with the light of recommendations of medical boards. 

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Scenario.png)

##  2. <a name='SharedKnow-How'></a>Shared Know-How
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

##  3. <a name='ProductVersions'></a>Product Versions
| Product       | Version       | 
| ------------- |:-------------:| 
| BAW       | 19.0.0.3		|	 
| ODM    |  8.9.2     |
| BAI	 |  19.0.0.3	|


##  4. <a name='PreRequirements'></a>PreRequirements
* DB2 Database
* Common Toolkit should be imported to your BAW. Check the [repository](https://github.com/DBA-Turkiye/BAWCommonToolkit) and documentation for more information. 


You can find the summary of required actions in order to import ODM & BPM project below. 

##  5. <a name='ODM-OperationalDecisionManager'></a>ODM - Operational Decision Manager

###  5.1. <a name='Importingthedecisionservice'></a>Importing the decision service
* Open Decision Center - https://YOURIP:PORT/decisioncenter/login
* Open Decision Service Library
* Click Import button on the upper left side of the window. 
* Choose .zip file that you downloaded from this repo under [ODM folder](https://github.com/DBA-Turkiye/DiagnoseCovid19/tree/master/ODM). - Be sure that you downloaded the latest version.
* After uploading file, click Import. 

###  5.2. <a name='Deployingtheservice'></a>Deploying the service
* Click on the name of the Decision Service that you recently imported. 
* From Branches tab, Click main 
* From the toolbar, click Deploy to deploy this decision service. 
* Click deploy on the pop-up. 
* From Deployments tab, you can track the status of your deployment. 
  
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Decision%20Center%20Deploy.png)

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Decision%20Center%20Deploy%20-%202.png)

###  5.3. <a name='ExposingtheruleviaRESTAPI'></a>Exposing the rule via REST API

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

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/RES%20-%20RuleApps%20View.png)
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/RES%20-%20RuleSet%20View.png)

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/RES%20-%20REST%20API.png)

###  5.4. <a name='ODMDecisionServiceDetails'></a>ODM Decision Service Details

Followed below steps to generate ODM Decision Model;

####  5.4.1. <a name='Drawadecisionmodelanddefineinputandoutputdatatypes'></a>Draw a decision model and define input and output data types

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/odm-decisionservice/DecisionModel.png)

As you can see from the decision model, our first step to get Diagnose Input Data from BAw. Inside this data model, we are receiving the symptoms, medical history, age and abroad travel history of the patient. 

By using this data, in the first step - Identify Risk - we are defining a risk (Healthy, LowRisk, MediumRisk or HighRisk) for the patient.

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/odm-decisionservice/Healthy.png)

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/odm-decisionservice/LowRisk.png)

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/odm-decisionservice/MediumRisk.png)

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/odm-decisionservice/HighRisk.png)

You can also find these rules inside [this folder](https://github.com/DBA-Turkiye/DiagnoseCovid19/tree/master/ODM/Rules). 

After defining risk, in our decision table we are defining the required action by combining risk, age and abroad travel history of the patient. And using this information inside BAW to calculate the direction of the workflow.  

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/odm-decisionservice/DecisionTable.png)



##  6. <a name='BAW-BusinessAutomationWorkflow'></a>BAW - Business Automation Workflow

###  6.1. <a name='ExecuteDBScripts'></a>Execute DB Scripts

Execute scripts inside [SQL Scripts](https://github.com/DBA-Turkiye/DiagnoseCovid19/tree/master/SQL%20Scripts) folder. Be sure that you have followed the required steps to import Common Toolkit [repository](https://github.com/DBA-Turkiye/BAWCommonToolkit) and executed DB Scripts inside there.

These scripts includes required parameters to be use inside this project such Sypmtoms for COVID-19, Gender, Medical Disease types, City, County information and some approval status parameters. 


###  6.2. <a name='ImportProcessApplication'></a> Import Process Application

For more details you can check: [Importing and Exporting Process Applications](https://www.ibm.com/support/knowledgecenter/SS8JB4/com.ibm.wbpm.admin.doc/topics/managing_process_applications_E.html)

* Open IBM Workflow Center - https://YOURIP:PORT/WorkflowCenter/
* Click Import Process App
* Click Choose File to select Process Application file with .twx extension. You can download the latest version of the Process App from [BAW folder](https://github.com/DBA-Turkiye/DiagnoseCovid19/tree/master/BAW) under this repo.  
* In the Import Process App window, a name and acronym have been specified based on information in the file you selected.
* You can filter the messages by clicking Errors or Warnings.

###  6.3. <a name='ChangeODMHostInformation'></a>Change ODM Host Information
* Open Process App Settings
* Click Servers
* You will see a server named DiagnoseSymptomsServer, click on this.
* Change Host Name and Port with your ODM server host and port info. 
* Save changes. 

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/BAW%20-%20ODM%20Server.png)

###  6.4. <a name='AddEnvironmentVariable'></a>Add Environment Variable

* Open Process App Settings
* Click Environment Variables
* Add a new Environment Variable with below parameters if not exists
  * Key: DataSourceName
  * Default: jdbc/IBMCloudDB2 - Be sure that you have defined Data source inside WAS as defined in the toolkit repository [documentation](https://github.com/DBA-Turkiye/BAWCommonToolkit#define-jdbc-resource-on-was).


###  6.5. <a name='StartingtheProcessfromProcessPortal'></a>Starting the Process from Process Portal

* Go to Process Portal https://YOURIP:PORT/ProcessPortal
* Find Corona Diagnosis Process and click to start
* First step with name Step: Self Assessment will be assigned to current user. 
* Click on the name of the step to open Self Assessment UI. 
* Fill Citizen Info, Address, Medical History and Symptoms.
  * In order to pass meaningful structured data to BAI, filling below fields are recommended;
    * Did you traveled abroad within the past 14 days?
    * Country
    * City
    * State
    * BirthDate
    * Symptom Details
    * Medical History
* After clicking on Submit button, all above information gathered from UI are consolidated and sent to the ODM to get if a patient with given symptoms, personal information and medical history is under risk or not. If the system can not decide a new task is assigned to a medical team to allow them investigate and decide the necessary action to take. 
  * If the customer is not under risk;
    * An e-mail including information about how to prevent from COVID-19 is sent to the patient. 
  * If the system decides the informations needs to be reviewed by a doctor.
    * A new task is assigned to a medical team. They will check information and decide if the patient;
      * Needs to be quarantined
        * A new task is assigned to emergency team to send an ambulance to the address of the patient. 
      * Needs to stay at home for 14 days;
        * A new task is assigned to call center team and they give information to patient on the call. Also, an e-mail including preventive information is going to be sent to the patient. 
        * After 14 days, a new task is assigned to the medical team to let them check the status of the patient. 
      * Is healthy
        * An e-mail including preventive information is going to be sent to the patient. 

###  6.6. <a name='BPMN2.0Workflow'></a>BPMN 2.0 Workflow

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/BPMN%20-%20Workflow.png)

###  6.7. <a name='UserInterface'></a>User Interface
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Citizen%20Info.png)
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Address.png)
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Medical%20History.png)
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Symptom%20List.png)

###  6.8. <a name='RecommendationHomeQuarantineEmailContent'></a>Recommendation & Home Quarantine Email Content
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Recommendation%20Email.png)

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/Home%20Quarantine%20-%20Email.png)


##  7. <a name='BusinessAutomationInsights'></a>Business Automation Insights

IBM Business Automation Insights allows you to capture all events that are generated by the operational systems that are implemented with the Digital Business Automation products, aggregate them into business-relevant KPIs, and present them in meaningful dashboards for lines of business to have a near real-time view on their business operations. For more [details](https://www.ibm.com/support/knowledgecenter/SSYHZ8_19.0.x/com.ibm.dba.bai/topics/con_bai_overview.html)

In this scenario, we passed the information gathered from patients to the BAI from BAW. And generated dashboards to make it possible to analyze the breakdown of sypmtoms, medical history, age and location. 

###  7.1. <a name='BAIArchitecture'></a>BAI Architecture
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/diag_bai.jpg)

###  7.2. <a name='COVID-19Dashboard'></a>COVID - 19 Dashboard

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/BAI%20-%20Full%20Dashboard%20-%202.jpeg)

![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/BAI%20-%20Process%20Dashboard.jpeg)

###  7.3. <a name='WhatisaKibanadashboard'></a>What is a Kibana dashboard

A Kibana dashboard is a collection of charts, graphs, metrics, searches, and maps that have been collected together onto a single pane. Dashboards provide at-a-glance insights into data from multiple perspectives and enable users to drill down into the details.

###  7.3.1. <a name='HowdoIcreatedashboardsinKibana'></a>How do I create dashboards in Kibana?

To build a dashboard in Kibana, users must have data indexed in Elasticsearch and have already built a search, visualization, or map. From within Kibana, click Dashboard in the side navigation. When opening the Dashboard interface, an overview of existing dashboards is presented. If there are no dashboards, sample data sets can be added, which include pre-built dashboards.

To build a dashboard, users can follow these steps:

* 1 - In the side navigation, click Dashboard.
* 2 - Click Create new dashboard.
* 3 - Click Add.
* 4 - Use Add Panels to add visualizations and saved searches to the dashboard. If there are a large number of visualizations, the lists can be filtered.


###  7.4. <a name='DataTransmittedtotheBAIformBAW'></a>Data Transmitted to the BAI form BAW
![](https://raw.githubusercontent.com/DBA-Turkiye/DiagnoseCovid19/master/Documentation/images/BAI%20-%20Json.png)

You can import prepared Kibana dashboards to your BAI environment by using [this json file](https://github.com/DBA-Turkiye/DiagnoseCovid19/blob/master/BAI/BAI%20Export.json).

Also you can find the full version of the json data from [here](https://github.com/DBA-Turkiye/DiagnoseCovid19/blob/master/BAI/SampleData.json). 
