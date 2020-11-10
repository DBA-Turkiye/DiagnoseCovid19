#Load Images
podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false default-route-openshift-image-registry.apps.hb.neareasttech.local

./loadimages_2.sh -p CP4Auto_20.0.2-opf.tgz -r default-route-openshift-image-registry.apps.hb.neareasttech.local/ibmcp4a

oc create secret generic ldap-bind-secret --from-literal=ldapUsername="ibmbinduser" --from-literal=ldapPassword="hg5li:=4"
#ldap-bind-secret 

oc create secret generic odm-users-secret --from-file=webSecurity.xml=webSecurity.xml
#odm-users-secret 

oc apply -f bai_odm_cr.yaml

oc apply -f custom-bpc-secret.yaml 

#CUSTOM DATASOURCE - ORACLE - customdatasource-secret
kubectl create secret generic customdatasource-secret --from-file datasource-ds.xml --from-file datasource-dc.xml

#datasource-dc.xml ve datasource-ds.xml de databaseName yerine serviceName kullanılmalı.

oc apply -f customdatasource-pvc.yaml

oc apply -f icp4adeploy-default-deny.yaml

