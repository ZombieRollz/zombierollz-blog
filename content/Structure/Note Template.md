
# *Feel free to use the note template below!*

# Case Name Writeup

*Prepared by:* Your Name  
*Date:* YYYY-MM-DD  
*Lab/Case:* Name

## Executive Summary
1 concise paragraph: what happened, how access was gained, what persistence or post-exploitation occurred, and the main takeaway

## Scenario
Brief incident context and what the investigation is about

## Artifacts Provided
- artifact 1
- artifact 2
- hash/source if relevant

## Initial Triage
What the artifacts are, why they matter, and any preprocessing or conversion performed

### Artifact Handling
- tool/process used
- format caveat
- timezone or encoding note

## Methodology
1. Identify the relevant artifact for the question
2. Filter for the relevant indicators
3. Correlate events across logs
4. Normalize timestamps to UTC
5. Validate the result against the full timeline

## Question 1
##### Question: question text

*Methodology:*  
Short, direct explanation

*Commands Used:*
```bash
command
```

_Findings:_  
Relevant output or evidence

_Answer:_  
final answer

_Analysis:_  
Why this answer is supported by the evidence


## Timeline

|UTC Time|Event|
|---|---|
|timestamp|event|
|timestamp|event|

## MITRE ATT&CK Mapping

|Tactic|Technique|ID|Evidence|
|---|---|---|---|
|tactic|technique|ID|log line or artifact|

## IOCs

|Type|Value|Context|
|---|---|---|
|IP|value|attacker source|
|User|value|persistence account|
|Command|value|post-exploitation command|

## Conclusion

Short final summary of the intrusion chain and lessons learned
