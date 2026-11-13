Now that I have set up AD in DC1, it's time to configure the Windows VM to join the domain. I blurred the network information out to continue good security hygiene when it comes to documenting network setup. 

I go into the Network settings to update and configure the IP address. 

![[Pasted image 20261113181727.png]]

I change it from Automatic (DHCP) -> Manual with a manual IPv4 address of 10.0.x.x. After this, I had to do a restart for the affects to fully change. 

![[Pasted image 20261113181050.png]]

Next via Windows search, type in domain -> Access work or school

![[Pasted image 20261113181810.png]]

![[Pasted image 20261113181843.png]]

Click Connect then -> click "Join this device to a local AD domain"

![[Pasted image 20261113181945.png]]


![[Pasted image 20261113182414.png]]

After entering my DC's Admin and password, I changed the following.

![[AdminUpgrade.png]]

Windows prompted me to perform a restart after this selection. I did so and switched back to the DC-1 to confirm the change. 

![[Confirmed.png]]


After I confirmed this, I went back to the Windows 11 host and confirmed that I am now able to login to the Frodo Baggins user on the computer.

![[Success 1.png]]

Once logged in, I can see that the user is attached to ECorp.local. Successful joining to Domain!