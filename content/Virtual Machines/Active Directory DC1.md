Before I start, shout out: I am following along a great cybersecurity course: [Complete Hands-On Cybersecurity Analyst Course](https://wgu.udemy.com/course/the-complete-hands-on-cybersecurity-analyst-course) by [Mike S](https://wgu.udemy.com/user/mike-sterrett-2/) and [Josh G](https://wgu.udemy.com/user/josh-5966/)
## Set Up Users

I have set up my Server Manager dashboard prior this post. I did not feel the need to make snippets for that process as there a lot of free tutorials on how to do so. I wanted to take time to showcase the setup of Lord of the Ring based users and group :P. 

![[ServerManagerWin.png]]

From the Server Manager dashboard, I select AD Users and Computers. 

![[ADU&C.png]]

Btoh Users and Groups are initially under the Ecorp.local -> Users. From here, I select my ECorp.local -> New -> OU to start a new Organizational Unit. 

![[OU_New.png]]

![[Groups.png]]

I can then tidy up my Users folder by moving all of the Group Types in my newly made Group OU. 

![[YesGroup.png]]

After this, I am going to create another Admin account. I make a new admin account with user name of Frodo Baggins. 

![[CopyAdmin.png]]


![[Frodo.png]]


I then set up a SQL account under the Gimli SQL user with a password of MYpassword123#. I selected the option for the password set to never expire. I follow a bad practice of listing this in the user's properties. 

![[Description.png]]
 
I added a few more users. 

![[lotrcast.png]]


## Set Up File Share

![[FileShare.png]]

Select file File and Storage Services -> Shares -> New Share

![[NewShare 1.png]]

Select Profile > SMB Share - Quick > Next > Next.

![[Quick.png]]

Name it -> Next -> Under Other Settings, keep default of "Allow caching of share" -> Next on Permissions -> Confirmation -> Create. 

![[Shire.png]]

![[ShireCreated.png]]


## Configure Service Principle Name (SPN)

An *SPN* is a unique identifier for a service running on a computer. In Active Directory, *Kerberos* uses it to find the account associated with that service so it can authenticate a connection—for example, a client connecting to a web server or *SQL Server*. A service’s SPN must be registered to the account it runs under.

I went back and updated my SQL user's profile to make the verbiage of the command make more sense. 

Launching command via Admin...

```
setspn -a ECorp/Gimli_SQL.ECORP.local:60111 ECORP\Gimli_SQL
```


![[Gimli.png]]

Run the command below to confirm the change. 

```
setspn -T ECORP.local -Q */*
```

![[Gimli_SQL.png]]


## Set up Group Policy

![[GPM.png]]

Drop down the Forest: Ecorp.Local and then drop down Domains -> Right click ECorp.Local and select "Create a GPO in this domain..."

![[CreatingDomain.png]]

I name it "Disable Windows Defender". 

![[DisableWindows.png]]

Now to edit the configurations. 

![[EditGP.png]]

Computer Comfiguration -> Policies -> Admin Template -> Windows Component. 

![[WindowsComp.png]]

Under Windows Components -> Microsoft Defender Antivirus.


![[Antivirus.png]]

Once double clicked -> Select "Turn off Microsoft Defender Antivirus" -> Enabled

![[TurnOff.png]]


![[Enabled.png]]

Going back to GPM, right click Disable Windows Defender -> Enforced

![[Enforced.png]]

This setup will be used in later posts. Thank you. 