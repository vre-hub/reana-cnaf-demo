# Infrastructure as Code Setup Documentation

This terraform setup uses the openstack, k8s and helm provider to setup the openstack cluster, a storage class for the helm deployment and finally the reana helm chart, which is defined as a [tf module](modules/reana/main.tf).

**Note: Due to the limitations in authentication and config setup, the resources need to be dismantled piece by piece and applied via terraform.**
