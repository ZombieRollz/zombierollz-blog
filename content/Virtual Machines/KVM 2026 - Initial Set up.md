I decided to switch my VM set up due to my main OS being Parrot OS. I did some research and found out that: [Virtual Machine Manager](https://virt-manager.org/) is the better route to go. Previously, I had set up VMWare. The reasons I decided to switch is: 1. Performance and 2. Because of my upcoming focus on setting up different VMs and wanted a permanent set up for my personal projects.

I am following along a great cybersecurity course: [Complete Hands-On Cybersecurity Analyst Course](https://wgu.udemy.com/course/the-complete-hands-on-cybersecurity-analyst-course) by [Mike S](https://wgu.udemy.com/user/mike-sterrett-2/) and [Josh G](https://wgu.udemy.com/user/josh-5966/)

The instructors use a different VM than me. Most VMs are similar, but my following set up is tied to virt-manager.

## Step 1: Install KVM and Virtual Machine Manager

```
sudo apt update
sudo apt install qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
```


## Step 2: Enable and Start the Libvirt Service

```
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```

Verify it's running per:

```
sudo systemctl status libvirtd
```

I had issues with this initially, as it was displaying an inactive status. I restarted it via:

```
sudo systemctl restart libvirtd
```

and checked it again via:

```
sudo systemctl status libvirtd
```

to see that it was running successfully.

![[Screenshot_20261018_130251.png]]

## Step 3: Add Your User to the Libvirt Group


```
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```

## Step 4: Launch Virtual Machine Manager



```
virt-manager
```


![[Screenshot_20261018_130517.png]]
Success!


I am wanting to make a Windows 11 VM. 

[Windows 11](https://www.microsoft.com/en-us/software-download/windows11)


![[Windows11Download.png]]

This download takes a bit just FYI. After it's downloaded, go back to VMM. 

![[VMM_Windows 1.png]]

![[BrowseLocal.png]]

![[Ram_CPU.png]]

![[Disk.png]]

![[Name.png]]
![[Virtual_Network.png]]

After this installed, I was greeted with a boot Window. I tried a couple of things, but this did not work. I had to force shut down the VM and manually configure the settings. 

## Manually Attach the ISO


1. Right-click the VM → Details
2. Click Add Hardware (bottom left)
3. Select Storage
4. Choose Select or create custom storage
5. Click Browse → Browse Local
6. Navigate to your Windows 11 ISO (`~/Downloads/Windows11.iso`)
7. Click Choose Volume
8. Under Device type, select CDROM device
9. Click Finish
10. Make sure CDROM is the first boot device (drag it to the top if needed)
11. Run the VM



![[Pasted image 20261107190326.png]]

After this, once it boots, I had to go into settings and select the CD Rom selection that is now available to be greeted by the Windows setup screen. 

![[WindowsPrompt.png]]
![[Pro.png]]

During install, Windows was insisting I use an email to sign in with. In order to get around this and do a local account instead, I had to go into the NIC settings and de-select as active. 


![[Pasted image 20261107190544.png]]

So I tried a few things with getting around this. If you are connected to the network via the above, MS wants you to sign in using an email. 

![[NoNetwork.png]]

In order to get around this, do the following:

```
Shift + F10
start ms-cxh:localonly
```

Once you do this, it will prompt you to create a user. After I created my user, User, I went back to the VM settings and re-connected my network. To make sure it worked successfully in the VM, I pinged google. Success!


![[Success.png]]
I made sure to make a snapshot after the successful install. 

![[Snapshot.png]]


Next I am going to set up Windows Server 2025.

[Windows Server 2025](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2025)

This defaulted to Windows Server 2022. I had to deselect this and choose 2025. 

![[WindowsServer.png]]

![[WindowsServerMemory.png]]

I did 100.0 for the disk image

![[WindowsSeverGiB.png]]
Getting DC-1 going!
![[WindowsServerDC.png]]

I selected the Desktop Experience in order to obtain the GUI + Server features. 
![[WindowsStandard.png]]

![[WindowsServerSetup.png]]

![[ServerManager.png]]

![[DC 2.png]]

This was fun. I am going to be adding more to this setup. If you have a Debian based OS, I hope this helps in getting your VM set up. Thank you!