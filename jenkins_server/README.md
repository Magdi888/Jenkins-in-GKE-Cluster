# Jenkins Server

## Description:
 Provision Jenkins server on the GKE cluster to run pipeline on it and deploy applications on the same cluster.

## Steps:

- Build image form jenkins/jenkins:lts and add to it [Dockerfile](https://github.com/Magdi888/Jenkins-in-GKE-Cluster/blob/master/jenkins_server/jenkinsDokerfile)
  - Docker
  - Terraform
  - Ansible
  - Kubectl
 ```
  # Build docker image and tag it with GCR hostname
  docker build -t us.gcr.io/us.gcr.io/durable-spot-354112/jenkins_tools -f jenkinsDokerfile .
 ```
- Push the image to GCR:
 ```
  docker push us.gcr.io/us.gcr.io/durable-spot-354112/jenkins_tools
 ```
- Create Namespace for the jenkins server:
 ```
  kubectl create ns jenkins-server
 ```
 - Create Service account for Jenkins in jenkins-server namespace with yaml [File](https://github.com/Magdi888/Jenkins-in-GKE-Cluster/blob/master/jenkins_server/serviceAccount.yaml)
  ```
   kubectl apply -f serviceAccount.yaml
  ```
 - Create Cluster role contains rules that represent a set of permissions, Permissions are full control of all resouces of apiGroups:
   - Core apiGroup
   - App apiGroup
   - networking.k8s.io/v1 apiGroup
 - Create Cluster role binding to grant the permissions in the cluster role to the service account.
  ```
   # Create the ClusterRole and ClusterRoleBinding
    kubectl apply -f clusterroleAndBinding.yaml
  ```
 - Create StorageClass that will create persistent volumes in respect of persistent volumes claim.The storageClass provisioner is kubernetes.io/gce-pd
   that will create GCEPersistentDisk as a persistent volume.
   * Reference: [Storage Class](https://kubernetes.io/docs/concepts/storage/storage-classes/#gce-pd)
  ```
    kubectl apply -f storageClass.yaml
  ```
 - Create persistent volumes claim to claim the persistent volumes.
   ```
    kubectl apply -f jenkins_pvc.yaml
   ```
 - Create Jenkins Deployment:
   - Namespace jenkins-server namespace
   - The image is that we pushed it to GCR.
   - Attach the serviceAccout to the deployment so the jenkins can create resouces on the cluster.
   - Open port 8080 for the container to access the jenkins UI and port 50000 which will be used when you connect a slave agent.
   - Mount the jenkins_home directory of the container to the persistent volume so if the deployment crushed we still have all the configuration saved.
   - Mount the docker daemon on the node the deployment running on to the container of the deployment so we can run docker command on the jenkins server.
   - Define readinessProbe for the container so the application will accept the traffic after period of time.
   - Define livenessProbe for the container so if the application is running but unable to make progress, Container will be restarted.
     *  Reference: [LivenessProbe and ReadinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes)
   ```
    # Deploy the Henkins deployment
     kubectl apply -f jenkins.yaml
   ```
 
 
