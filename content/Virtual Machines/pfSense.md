Before I start, shout out: I am following along a great cybersecurity course: [Complete Hands-On Cybersecurity Analyst Course](https://wgu.udemy.com/course/the-complete-hands-on-cybersecurity-analyst-course) by [Mike S](https://wgu.udemy.com/user/mike-sterrett-2/) and [Josh G](https://wgu.udemy.com/user/josh-5966/)

**Note**: Most of the blurred aspects of my screenshots are a low risk due to virtual NIC/private identifiers. The reasoning I did this is to keep a good habit of doing so to reflect a live environment. I would encourage you do the same as well. 

**Tip**: I would advise at this point, to create an additional note in your note taking tool, labeled "pfSense Configuration" so you can keep up with how everything is connected. This will help you troubleshoot going forward. I wish I did this when I first started the setup. 

Also **IMPORTANT**: Remember to snapshot while you get everything going!

This is will be in addition to my previous blog post, KVM 2026. Navigating to here, [pfSense](https://www.pfsense.org/download/) I selected the following and used my Shop account to complete the 0.00 order(lol). 


![[Screenshot_20261019_121142.png]]
After downloading the file, I needed to use gunzip to decompress it. 
![[gunzip.png]]
![[Browse_Local.png]]

![[Generic.png]]

![[NewVM.png]]

![[NewVM2.png]]

![[pfSense.png]]

Setting up the install

![[Install.png]]
em0
![[Pasted image 20261113115923.png]]
Continue

![[Continue.png]]

LAN


![[LAN.png]]
InstallCE

![[InstallCE.png]]

Continue with Stripe > Yes. 

![[Stripe.png]]
Install the Current Stable Version. After the install select Ok > Reboot. Once rebooted, I set up 1) Assign Interfaces. 

![[Pasted image 20261113121129.png]]
I select "No" for VLAN set up.

![[Pasted image 20261113120841.png]]

I got ahead of myself during set up and did not have my LAN configured properly in the VM before the set up. 

![[Pasted image 20261113121030.png]]

I go into my VM's Connection Details setting to start a new setup for my LAN.

![[ConnectionDetails.png]]
![[Isolated.png]]

![[Pasted image 20261113121413.png]]

Now I will need to add network hardware to tie my LAN into the VM. 

![[Pasted image 20261113121951.png]]

I had to follow the previous steps again to get back to the WAN/LAN setup but no biggie. Now I see I have the selection of em1(my LAN connection!).

![[Pasted image 20261113122148.png]]

Once selected, I set up my network interfaces. I did option 2 > 1 for my em0 > y > n > Enter for none > N > Enter


![[DHCP.png]]

After I set up my WAN, I set up my LAN. 

![[LANIPv4.png]]

I configured the IPv4 address with my lab internal setups IP range. 

So now that I have that setup and am a little more comfortable with my VM network settings and pfSense, it's time to follow the blog a little more closer. I will need to add an additional network and reconfigure my internal-lan connection: ecorp and allsafe.


![[LANrange.png]]

After reconfiguring everything(basically re-doing the setup from before) I went back into pfsense and updated everything. I also enabled DHCP server on my interfaces. 


I ended up coming back to this to do some tweaking. I needed to uncheck the "enable DHCPv4" since I have pfSense configured for this function already. This caused a huge headache and will be something I'll never forget. That's why the hands on is very important.

![[DisableDHCP.png]]

![[Screenshot_20261019_170055.png]]

Another issue I had was using CIDR notation in pfsense via terminal. When configuring my IP, I was doing, for example, 10.0.x.x/24, when I should have been doing 10.0.x.x -> Setup CIDR notation after this when prompted. This was also something to be aware of when are you configuring your firewall rules. 

Additionally, since the blog is using an attacker machine via VM, I had to update my pfSense rules to add my physical Parrot OS to the allow list to connect to it since my VMs are on their own internal network. This took me a bit to configure. I had to go in to my OS network settings and reroute everything via commands. My Parrot OS kept wanting to default to certain network configurations after every reboot. In the end, what I had to do, via commands, I had to manually change and permanently keep the IP tied to the Parrot OS > VM network in it's own virtual network. I use duckduckgo AI when it comes to anything AI based, and I had to depend on this for help. The frustrating part was AI kept wanting to blame my previous pfSense rules. If you need a prompt for this, I would suggest posting your current configuration, then adding "I need to add my host based OS to a new virtual network in order to add it to the virtual ecosystem. I then need to configure my VM network settings with this new addition as well as update my pfSense settings to update this. It will not be as simple as just adding my public IP to the allow list via pfSense firewall. Please remember this when going forward."


Your OS might take a hit with all of this running. If you need to reconfigure your memory allocation to prevent too much memory usage for performance hits, you can do so if needed. If you do happen to lower it too much, you will be able to tell if it takes a performance hit as soon as you launch the VM. This will cause a slow start up with the OS. So just fyi :). 


![[Screenshot_20261019_181051.png]]

![[WindowsMemory.png]]
