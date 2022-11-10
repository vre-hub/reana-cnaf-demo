# Manual Setup

After the cluster is provisioned through the [GRyCAP IM](https://appsgrycap.i3m.upv.es:31443/im-dashboard/login), logon `ssh -i <keyfile.pem> <username>@<ip>` to the the master VM using the cloud credentials accessible from the IM Dashboard (see [documentation(https://imdocs.readthedocs.io/en/latest/dashboard.html#infrastructures)).

Check the volume is attached, the NFS server is running and publishing the attached volume:

```bash
df -h
systemctl | grep nfs
showmount --exports # to check from another device run: showmount -e <ip>
```

Switch to the K8s cluster and create a *StorageClass* for the REANA Helm chart to use (this might require to install an [external NFS provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)):

```yml

```



![](../media/pv.png)

