
######################20.0.2

#Create NFS Server & Deploy Dynamic Provisioning 
https://medium.com/faun/openshift-dynamic-nfs-persistent-volume-using-nfs-client-provisioner-fcbb8c9344e

helm install nfs-provisioner stable/nfs-client-provisioner --set nfs.server=192.168.100.137 --set nfs.path=/data --set storageClass.name=ibmcp4a
oc adm policy add-scc-to-user hostmount-anyuid -z nfs-provisioner-nfs-client-provisioner
oc adm policy add-scc-to-user hostmount-anyuid -z nfs-provisioner

oc adm policy add-scc-to-group ibm-privileged-scc system:authenticated

#Create a user by using htpasswd command. It will generate a users.htpasswod file under working directory. Open OCP
#dashboard User Management > Users > Add IDP select HTPasswd and upload users.htpasswd file and save. 
htpasswd -c -B -b users.htpasswd cp4a-user passw0rd

#After creating the user, login to OCP dashboard by using the credentials.

./scripts/cp4a-clusteradmin-setup.sh

podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false default-route-openshift-image-registry.apps.hb.neareasttech.local

./loadimages_2.sh -p CP4Auto_20.0.2-opf.tgz -r default-route-openshift-image-registry.apps.hb.neareasttech.local/ibmcp4a
./loadimages_2.sh -p CP4Auto_20.0.2-bai.tgz -r default-route-openshift-image-registry.apps.hb.neareasttech.local/ibmcp4a
./loadimages_2.sh -p ICPA_V20.0.2_CNCK.tgz -r default-route-openshift-image-registry.apps.hb.neareasttech.local/ibmcp4a
./loadimages_2.sh -p CP4Auto_20.0.2-ums.tgz -r default-route-openshift-image-registry.apps.hb.neareasttech.local/ibmcp4a

./loadimages.sh -p ICP4A20.0.1-opf.tgz -r default-route-openshift-image-registry.apps.hb.neareasttech.local/baiproject
./loadimages_2.sh -p CP4Auto_20.0.2-aae.tgz -r default-route-openshift-image-registry.apps.hb.neareasttech.local/ibmcp4a

#Route HostName: apps.hb.neareasttech.local

#Deploy Kafka
helm install --namespace ibmcp4a my-kafka incubator/kafka -f kafka-values.yaml
helm install --namespace baiproject my-kafka2 incubator/kafka -f kafka-values.yaml

#To Test Kafka
oc apply -f testclient.yaml
kubectl -n ibmcp4a exec testclient -- /usr/bin/kafka-topics --zookeeper my-kafka-zookeeper:2181 --list 

# Apply BAI PSP
oc apply -f bai-psp.yaml 

#Change NFS IP and create folders under NFS
oc apply -f operator-shared-pv.yaml
oc apply -f operator-shared-pvc.yaml

chmod -R g=u /data/persistentvolumes/operator
chmod g+rw /data/persistentvolumes/operator

#Goto descriptors/operator.yaml and remove resources parts with resources: {}
cd cert-kubernetes-20.0.2
./scripts/deployOperator.sh -i image-registry.openshift-image-registry.svc:5000/ibmcp4a/icp4a-operator:20.0.2 -a accept -n ibmcp4a -p deployer-dockercfg-s2fdp


oc apply -f bai_cr.yaml


helm install --namespace ibmcp4a ibmcp4a-nfs-provisioner stable/nfs-client-provisioner --set nfs.server=192.168.100.137 --set nfs.path=/data/persistenvolumes/bai


#POST INSTALLATION TASKS

#elastic search
oc create route passthrough --namespace ibmcp4a --service=icp4adeploy-ibm-dba-ek-client
oc label namespace openshift-ingress-operator 'network.openshift.io/policy-group=ingress'
oc get --namespace openshift-ingress-operator ingresscontrollers/default --output jsonpath='{.status.endpointPublishingStrategy.type}'

#kibana
oc create route passthrough --namespace ibmcp4a --service=icp4adeploy-ibm-dba-ek-kibana
oc get --namespace ibmcp4a ingresscontrollers/default --output jsonpath='{.status.endpointPublishingStrategy.type}'

#flink
oc create route passthrough --namespace ibmcp4a --service=icp4adeploy-bai-flink-jobmanager --port=8081 --hostname=<host>

oc label namespace default 'network.openshift.io/policy-group=ingress'


#REST API
oc create route passthrough --namespace ibmcp4a --service=icp4adeploy-bai-admin-service