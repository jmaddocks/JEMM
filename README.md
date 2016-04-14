# JEMM

This repository contains the deliverables from the assigned uppet Project. This project creates a virtualised environment using Vagrant to automate the process including packages that are relevant to us. 

On top of this, 6 puppet modules are written to be installed and configured ready to be used by the user.

### Modules

We have the following:
<ul>
<li> Git     - JM </li>
<li> Java    - JM </li>
<li> Jenkins - JM </li>
<li> Jira    - JM </li>
<li> Zabbix  - EM </li>
<li> Maven   - EM </li>
</ul>

### Vagrant File

The vagrant file contains information for a master and an agent. The bootstrap files will download the binary files and tarball for the modules and install the packages ssh, putty, vim and puppet.

### To start

Create a Project_setup folder in your chosen local directory and create a shared folder in this Project setup. To use Vagrant it will need to be installed from it's website (or from C:\LocalInstall) and place the Chad Thompson box into the 'vagrant.d' folder if not already done.
Download the git repository into project setup and git bash into this directory and type the command 'vagrant up'. This will start the virtual machines and will be able to install the modules.

<p>Possibly.</p>

### Thanks for Reading

Jessica Maddocks, Elliot Marsh

