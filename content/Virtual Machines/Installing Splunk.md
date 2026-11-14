Before I start, shout out: I am following along a great cybersecurity course: [Complete Hands-On Cybersecurity Analyst Course](https://wgu.udemy.com/course/the-complete-hands-on-cybersecurity-analyst-course) by [Mike S](https://wgu.udemy.com/user/mike-sterrett-2/) and [Josh G](https://wgu.udemy.com/user/josh-5966/)

[Splunk](https://www.splunk.com/en_us/download/splunk-enterprise.html)

Though it states "Business email", you can use your personal email to download Splunk. For whatever reason, my Windows 11 VM kept getting hung up at the Splunk login page. So what I did was install the Splunk installer locally From my terminal, I ran: 

```
genisoimage -o splunk-installer.iso splunk-*.msi
```

![[Screenshot_20261028_113215.png]]
 
I proceeded to shut down my VM. From my Virtual Machine Manager -> Virtual Hardware Details -> selected SATA CDROM 2 and then selected the splunk-installer.iso from my local files. 

![[splunksource.png]]

Now from my Windows 11 VM, I have the Splunk installer ready to go via my CDROM. 

![[Screenshot_20261028_122304.png]]

I continued my re-occurring LotR theme and made a Gandalf user for Splunk. 

![[Splunk.png]]

![[Splunklogin.png]]


Now for the add-ons: [Splunk Addons](https://splunkbase.splunk.com/apps?page=1)

I am going to download Splunk Add-on for Windows and Sysmon. 

![[AddOn1.png]]

![[AddOn2.png]]


I ran into a road block here. It was not as simple as it should have been. What should happen: From the Splunk software, go into Apps > Manage Apps. No matter what, I kept getting a 404 error message. 


![[Oops.png]]

So I had to, again from my Parrot OS, download the add on files and upload them via VM. I copied the two files into it's own splunk-addons-iso dir. 

![[Pasted image 20261028195031.png]]

Then I did:

```
xorriso -as mkisofs -o splunk-addons-transfer-iso -V SPLUNK_ADDONS splunk-addons-iso
```

I powered off my VM and uploaded this to my CD-ROM settings via VM. 

![[Pasted image 20261028195349.png]]

I powered on and logged into my Windows VM. From there, I ran command prompt as admin then...

```
cd /d "C:\Program Files\Splunk\bin"
```


```
splunk.exe install app "E:\SPLUNK_0.SPL" -auth username:YOUR_SPLUNK_PASSWORD
```


```
splunk.exe install app "E:\SPLUNK_1.SPL" -auth username:YOUR_SPLUNK_PASSWORD
```

To confirm the change I also ran

```
splunk.exe display app -auth username:YOUR_SPLUNK_PASSWORD
```

![[Pasted image 20261028195745.png]]


![[splun-addon.png]]




![[Pasted image 20261028154911.png]]

![[Manage.png]]

![[Pasted image 20261114001843.png]]


In the above snippet, you can see that microsoft_sysmon and windows are displaying ENABLED.

After this, I configure my Data Inputs. 

![[DataInputs.png]]



![[AddNew 1.png]]

Click Enable -> From command prompt -> ipconfig

![[EnableIt.png]]


Afterwards, go back to Splunk Search and from New Search I type ipconfig to confirm it was logged!

![[ipconfig.png]]