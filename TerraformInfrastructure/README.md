# GCP Infrastructure


## Provision infrastructure on GCP with Terraform.


### Description:
- VPC with two subnetworks in the same region, management subnetwork and restricted subnetwork.
- The two subnetworks can access internet from Cloud NAT.
- The management subnetwork has a private VM.
- Create service account for the private VM and attach ContainerAdmin role to it to manage the GKE cluster through it.
- Install gcloud cli and kubectl on the private VM with startup [Script](https://github.com/Magdi888/Jenkins-in-GKE-Cluster/blob/master/TerraformInfrastructure/config_gcloud.sh)
- The restricted subnetwork has a private GKE cluster and the node pool.
- Create service account for the the nodes and attach ObjectViewer role to it so we can pull images from GCR
- The nodes image type is ubuntu with docker.
- The restricted subnetwork has two secondary ip rangs one is assigned to pods_CIDR and the other one for services_CIDR.
- Firewall to allow ssh to the private VM.
- Define the variables used in variables.tf file.
- Assigne values to the variables in def.tfvars.
- Package all network component in network module [Network Module](https://github.com/Magdi888/Jenkins-in-GKE-Cluster/tree/master/TerraformInfrastructure/network)
- Package all GKE cluster component in K8s module [K8s Module](https://github.com/Magdi888/Jenkins-in-GKE-Cluster/tree/master/TerraformInfrastructure/K8s_module)


### Infrastructure Digram
![image](https://user-images.githubusercontent.com/91858017/182043708-099c4ac0-223c-40ab-8873-cf05f344a709.png)


### Steps:

- Create Bucket to save Terraform state file.
 ```
  gsutil mb -c standard -b on -p [Project ID] gs://[Bucket Name]
 ```
- Set the bucket name in backend.tf file.

- Run the following:
 ```
  # Initialization terraform
   terraform init
  # Show our Plan
   terraform plan --var-file dev.tfvars
  # Create Dev Workspace
   terraform workspace new dev
  # Select Dev Workspace
   terraform workspace select dev
  # Apply Our Plan
   terraform apply --var-file dev.tfvars
 ```


- Connect to Private VM with ssh.
 ```
   gcloud compute ssh [machine name]
 ```
- Updates a kubeconfig file with appropriate credentials and endpoint information to point kubectl at a our cluster in Google Kubernetes Engine.
 ```
  gcloud container clusters get-credentials [GKE name] --zone [used zone] --project [ProjectId]
 ```

 


 
