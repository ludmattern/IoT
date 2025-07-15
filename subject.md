# Inception-of-Things (IoT)

## Summary

This document is a System Administration related exercise.

**Version:** 2.1

---

## Contents

* I. Preamble
* II. Introduction
* III. General guidelines
* IV. Mandatory part

  * IV.1 Part 1: K3s and Vagrant
  * IV.2 Part 2: K3s and three simple applications
  * IV.3 Part 3: K3d and Argo CD
* V. Bonus part
* VI. Submission and peer-evaluation

---

## I. Preamble

*

---

## II. Introduction

This project aims to deepen your knowledge by making you use **K3d** and **K3s** with Vagrant.

You will learn how to set up a personal virtual machine with Vagrant and the distribution of your choice. Then, you will learn how to use K3s and its Ingress. Last but not least, you will discover K3d that will simplify your life.

These steps will get you started with Kubernetes.

> This project is a minimal introduction to Kubernetes. Indeed, this tool is too complex to be mastered in a single subject.

---

## III. General guidelines

* The whole project has to be done in a virtual machine.
* You have to put all the configuration files of your project in folders located at the root of your repository (see Submission and peer-evaluation for more info).
* The folders of the mandatory part will be named: `p1`, `p2`, and `p3`. The bonus one: `bonus`.
* This topic requires you to apply concepts that, depending on your background, you may not have covered yet. We therefore advise you not to be afraid to read a lot of documentation to learn how to use K8s with K3s, as well as K3d.

> You can use any tools you want to set up your host virtual machine as well as the provider used in Vagrant.

---

## IV. Mandatory part

This project will consist of setting up several environments under specific rules. It is divided into three parts you have to do in the following order:

1. Part 1: K3s and Vagrant
2. Part 2: K3s and three simple applications
3. Part 3: K3d and Argo CD

---

### IV.1 Part 1: K3s and Vagrant

To begin, you have to set up **2 machines**.

* Write your first `Vagrantfile` using the latest stable version of the distribution of your choice as your operating system. It is STRONGLY advised to allow only the bare minimum in terms of resources: **1 CPU, 512 MB of RAM (or 1024)**. The machines must be run using Vagrant.

Expected specifications:

* The machine names must be the login of someone in your team. The hostname of the first machine must be followed by the capital letter **S** (like Server). The hostname of the second machine must be followed by **SW** (like ServerWorker).
* Have a dedicated IP on the eth1 interface. The IP of the first machine (Server) will be **192.168.56.110**, and the IP of the second machine (ServerWorker) will be **192.168.56.111**.
* Be able to connect with SSH on both machines with no password.

> Set up your Vagrantfile according to modern practices.

Install K3s on both machines:

* On the first one (**Server**), install in controller mode.
* On the second one (**ServerWorker**), install in agent mode.

> You will have to use `kubectl` (and therefore install it too).

#### Example Vagrantfile

Here is an example basic Vagrantfile:

```shell
Vagrant.configure(2) do |config|
  [...]
  config.vm.box = REDACTED
  config.vm.box_url = REDACTED

  config.vm.define "wilS" do |control|
    control.vm.hostname = "wilS"
    control.vm.network REDACTED, ip: "192.168.56.110"
    control.vm.provider REDACTED do |v|
      v.customize ["modifyvm", :id, "--name", "wilS"]
      [...]
    end
    control.vm.provision "shell", :inline => SHELL
    [...]
    SHELL
    control.vm.provision "shell", path: REDACTED
  end

  config.vm.define "wilSW" do |control|
    control.vm.hostname = "wilSW"
    control.vm.network REDACTED, ip: "192.168.56.111"
    control.vm.provider REDACTED do |v|
      v.customize ["modifyvm", :id, "--name", "wilSW"]
      [...]
    end
    control.vm.provision "shell", inline: <<-SHELL
    [..]
    SHELL
    control.vm.provision "shell", path: REDACTED
  end
end
```

##### Exemple de lancement des VMs

* Here is an example when the virtual machines are launched:

```shell
$> p1 vagrant up
Bringing machine 'wilS' up with 'virtualbox' provider...
Bringing machine 'wilSW' up with 'virtualbox' provider...
          [...]
$> p1 vagrant ssh wilS               $> p1 vagrant ssh wilSW
[vagrant@wilS ~]$                    [vagrant@wilSW ~]$
```

* Here is an example when the configuration is not complete: :

```shell
[vagrant@wilS ~]$ k get nodes -o wide
NAME     STATUS   ROLES                   AGE      VERSION         INTERNAL-IP       EXTERNAL-IP    OS-IMAGE          KERNEL-VERSION           CONTAINER-RUNTIME
wilS     Ready    control-plane,master    4m37s    v1.21.4+k3s1    192.168.42.110    <none>         CentOS Linux 8    4.18.0-240.el8.x86_64    containerd://1.4.4-k3s1
[vagrant@wilSW ~]$ ifconfig eth1
eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.42.111  netmask 255.255.255.0  broadcast 192.168.42.255
        inet6 fe80::a00:27ff:fe3e:1c2b  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:3e:1c:2b  txqueuelen 1000  (Ethernet)
        RX packets 10 bytes 2427 (2.3 KB)
        RX errors 0 dropped 0 overruns 0 frame 0
        TX packets 28 bytes 3702 (3.6 KB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0
```

* Here is an example when the machines are correctly configured:

```shell
[vagrant@wilS ~]$ k get nodes -o wide
NAME     STATUS   ROLES                   AGE      VERSION         INTERNAL-IP       EXTERNAL-IP    OS-IMAGE          KERNEL-VERSION           CONTAINER-RUNTIME
wilS     Ready    control-plane,master    16m      v1.21.4+k3s1    192.168.42.110    <none>         CentOS Linux 8    4.18.0-240.el8.x86_64    containerd://1.4.4-k3s1
wilSW    Ready    <none>                  78s      v1.21.4+k3s1    192.168.42.111    <none>         CentOS Linux 8    4.18.0-240.el8.x86_64    containerd://1.4.4-k3s1
[vagrant@wilSW ~]$
[vagrant@wilSW ~]$ ifconfig eth1
eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.42.111  netmask 255.255.255.0  broadcast 192.168.42.255
        inet6 fe80::a00:27ff:fe3e:1c2b  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:3e:1c:2b  txqueuelen 1000  (Ethernet)
        RX packets 446 bytes 322199 (314.3 KB)
        RX errors 0 dropped 0 overruns 0 frame 0
        TX packets 472 bytes 101181 (98.8 KB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0

[vagrant@wilSW ~]$
```

> On the example above the use of ifconfig eth1 is done under macOS, if you are under the latest version of linux the command is: ip a show
eth1

---

### IV.2 Part 2: K3s and three simple applications

* For this part, use **one virtual machine** with the distribution of your choice (latest stable version) and K3s in server mode installed.
* Set up **3 web applications** of your choice that will run in your K3s instance.
* You will have to be able to access them depending on the HOST used when making a request to the IP address **192.168.56.110**. The name of this machine will be your login followed by S (e.g., `wilS`). Here is a simple example diagram:

```text

                         App 3
                      +----------+
                      |   www    |
                      +----------+        App 2
        App 1              |          +----------+
    +----------+           |          |   www    |
    |   www    |-----------|----------|   www    |
    +----------+           |          |   www    |
                           |          +----------+
                           |
                         -----
                       /       \
                       |  K3s  |
                       \       /
                         -----
                           |
                      +----------+
                      |   host   |
                      +----------+ 
```

> As you can see, application number 2 has **3 replicas**. Adapt your configuration to create the replicas.

When a client inputs the IP `192.168.56.110` in their web browser with the HOST `app1.com`, the server must display `app1`. When the HOST `app2.com` is used, the server must display `app2`. Otherwise, `app3` will be selected by default.

> The ingress is not displayed here on purpose. You will have to show it during the defense.

---

### IV.3 Part 3: K3d and Argo CD

* Install **K3D** on your virtual machine (**no Vagrant this time**).
* Docker is required for K3d to work, and possibly other software. Write a script to install every necessary package and tool.
* Understand the difference between K3s and K3d.

Set up a small infrastructure following this logic:

* Create **two namespaces**:

  * The first one dedicated to **Argo CD**.
  * The second one named **dev** and containing an application automatically deployed by Argo CD using your online Github repository.

> You must create a public repository on Github where you will push your configuration files. Put the login of a member of the group in the name of your repository.

The application deployed must have **two different versions** (use tagging if you don’t know about it).

You have two options:

1. Use the ready-made application created by Wil (available on Dockerhub at [https://hub.docker.com/r/wil42/playground](https://hub.docker.com/r/wil42/playground), uses port 8888, two versions: v1 and v2).
2. Or create and use your own application. Create a public Dockerhub repository and tag its two versions: v1 and v2. The two versions must have a few differences.

You must be able to change the version from your public Github repository and check that the application has been correctly updated by Argo CD.

#### Exemple de manipulation et résultats attendus :

* Vérification des namespaces et des pods :

```shell
$> k get ns
NAME     STATUS   AGE
argocd   Active   19h
dev      Active   19h
$> k get pods -n dev
NAME                               READY   STATUS    RESTARTS   AGE
wil-playground-65f745fdf4-d2l2r    1/1     Running   0          8m9s
```

* Vérification que l’application utilise bien la version attendue (ici v1) :

```shell
$> cat deployment.yaml | grep v1
- image: wil42/playground:v1
$> curl http://localhost:8888/
{"status":"ok", "message": "v1"}
```

* Mise à jour en v2 via le dépôt Github :

```shell
$> sed -i 's/wil42\/playground\:v1/wil42\/playground\:v2/g' deploy.yaml
$> g up "v2" # git add+commit+push
[..]
a773f39..999b9fe master -> master
$> cat deployment.yaml | grep v2
- image: wil42/playground:v2
```

* Synchronisation Argo CD :

* Nouvelle version déployée :

```shell
$> curl http://localhost:8888/
{"status":"ok", "message": "v2"}
```

> Pendant la soutenance, il faudra faire cette opération avec l’application choisie (celle de Wil ou la vôtre).

---

## V. Bonus part

* Add **Gitlab** in the lab from Part 3.
* The latest version of Gitlab from the official website is expected.
* You may use any tools needed (e.g., Helm).
* Your Gitlab instance must run locally.
* Configure Gitlab to work with your cluster.
* Create a dedicated namespace named **gitlab**.
* Everything you did in Part 3 must work with your local Gitlab.
* Put this extra work in a new folder named `bonus` at the root of your repository.

> The bonus part will only be assessed if the mandatory part is **PERFECT** (i.e., all requirements done and working).

---

## VI. Submission and peer-evaluation

* Turn in your assignment in your Git repository as usual. Only the work inside your repository will be evaluated during the defense.
* Double-check the names of your folders and files to ensure they are correct.

#### Reminder:

* Mandatory part: `p1`, `p2`, `p3` folders at the root of your repository
* Bonus part: optional, in `bonus` folder

#### Example directory structure:

```shell
$> find -maxdepth 2 -ls
424242 4 drwxr-xr-x 6 wandre wil42 4096 sept. 17 23:42 .
424242 4 drwxr-xr-x 3 wandre wil42 4096 sept. 17 23:42 ./p1
424242 4 -rw-r--r-- 1 wandre wil42 XXXX sept. 17 23:42 ./p1/Vagrantfile
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./p1/scripts
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./p1/confs
424242 4 drwxr-xr-x 3 wandre wil42 4096 sept. 17 23:42 ./p2
424242 4 -rw-r--r-- 1 wandre wil42 XXXX sept. 17 23:42 ./p2/Vagrantfile
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./p2/scripts
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./p2/confs
424242 4 drwxr-xr-x 3 wandre wil42 4096 sept. 17 23:42 ./p3
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./p3/scripts
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./p3/confs
424242 4 drwxr-xr-x 3 wandre wil42 4096 sept. 17 23:42 ./bonus
424242 4 -rw-r--r-- 1 wandre wil42 XXXX sept. 17 23:42 ./bonus/Vagrantfile
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./bonus/scripts
424242 4 drwxr-xr-x 2 wandre wil42 4096 sept. 17 23:42 ./bonus/confs
```

> Tout script doit être mis dans le dossier `scripts`, et les fichiers de configuration dans le dossier `confs`.

> L’évaluation se déroulera sur la machine du groupe évalué.
