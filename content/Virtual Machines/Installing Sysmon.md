Before I start, shout out: I am following along a great cybersecurity course: [Complete Hands-On Cybersecurity Analyst Course](https://wgu.udemy.com/course/the-complete-hands-on-cybersecurity-analyst-course) by [Mike S](https://wgu.udemy.com/user/mike-sterrett-2/) and [Josh G](https://wgu.udemy.com/user/josh-5966/)

**Sysmon(System Monitor)** is a Windows service and driver that records detailed system activity in Windows Event Log. It can capture events such as process launches, command lines, network connections, and file or registry activity. No matter if the activity is malicious or not, the event will be collected. This is great for a SIEM such as Wazuh or Splunk(which I will set up later!)

![[Sysmon.png]]

While that is downloaded, I went to [Sysmon](github.com/olafhartong/sysmon-modular). Under Pre-generated configurations, I selected "sysmonconfig.xml". 

![[sysmonconfig.png]]

After downloading it, I open the file and copy the text and save it to notepad with the name "sysmonconfig.xml"

![[sysmonxml.png]]

![[xmltext.png]]

Unzip the Sysmon file in Downloads -> Move the extracted Sysmon file into Downloads as well. Afterwards, launching command prompt via the ECORP administrator. 

![[ECORPAdmin.png]]

Then cd \Users -> fbaggins1 -> cd Downloads -> dir -> confirm my Symon files. 

![[Windowswow.png]]

Then:

```
sysmon64.exe -accepteula -i sysmonconfig.xml
```


![[Pasted image 20261028102516.png]]

Launching Event Viewer as Admin, scroll down under Microsoft -> Windows -> Sysmon to confirm successful install!

![[Pasted image 20261028103257.png]]