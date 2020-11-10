#!/usr/bin/env bash
# @---lm_copyright_start
# 5737-I23, 5900-A30
# Copyright IBM Corp. 2018 - 2020. All Rights Reserved.
# U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#@---lm_copyright_end

. ./ScriptFunctions.sh

if [[ -z $INPUT_PROPS_FILENAME ]]; then
    INPUT_PROPS_FILENAME="./common_for_DB2_Tenant_Upgrade.sh"
fi

if [ -f $INPUT_PROPS_FILENAME ]; then
   echo "Found a $INPUT_PROPS_FILENAME.  Reading in variables from that script."
   . $INPUT_PROPS_FILENAME
fi

echo -e "\n-- This script will upgrade tenant DB from v1.3 to v1.4"
echo

while [[ $tenant_db_name == '' ]]
do
  echo "Please enter a valid value for the tenant database name :"
  read tenant_db_name
  while [ ${#tenant_db_name} -gt 8 ];
  do
    echo "Please enter a valid value for the tenant database name :"
    read tenant_db_name;
    echo ${#tenant_db_name};
  done
done

while [[ -z "$tenant_db_user" ||  $tenant_db_user == "" ]]
do
  echo "Please enter a valid value for the tenant database user name :"
  read tenant_db_user
done

while [[ $tenant_ontology == '' ]]
do
  echo "Please enter a valid value for the tenant ontology name :"
  read tenant_ontology
done

echo
echo "-- Please confirm these are the desired settings:"
echo " - ontology: $tenant_ontology"
echo " - tenant database name: $tenant_db_name"
echo " - tenant database user name: $tenant_db_user"
askForConfirmation

echo " -- upgrade from 1.3 to 1.4 ---"
cp sql/UpgradeTenantDB_1.3_to_1.4.sql.template sql/UpgradeTenantDB_1.3_to_1.4.sql
sed -i s/\$tenant_db_name/"$tenant_db_name"/ sql/UpgradeTenantDB_1.3_to_1.4.sql
sed -i s/\$tenant_ontology/"$tenant_ontology"/ sql/UpgradeTenantDB_1.3_to_1.4.sql
sed -i s/\$tenant_db_user/"$tenant_db_user"/ sql/UpgradeTenantDB_1.3_to_1.4.sql
echo
echo "Running upgrade script: sql/UpgradeTenantDB_1.3_to_1.4.sql"
db2 -stvf sql/UpgradeTenantDB_1.3_to_1.4.sql
