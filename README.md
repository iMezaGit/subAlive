# subAlive
Bash script for automatic subdomain enumeration

## Project Description
This tool automates passive reconnaissance tasks, focusing specifically on subdomain enumeration. Subdomain enumeration is a crucial step in any web penetration testing or bug bounty reconnaissance process. It largely determines the attack surface available to a security researcher. 

This phase of the enumeration process is often time consuming, since you use multiple tools, each of them with hundreds or even thousands of results, the amount of data to process is not negligible, leading to mistakes, for example a typo or leaving a subdomain, that might be important, out of the final list. By automating this process, the tool enhances efficiency and accuracy reducing human error.

For this reason, I created this script, subAlive. It utilizes three tools to gather as many subdomains as possible, then filters the results. Afterward, it tests if the domains are **alive** and finally generates two reports: one for the **alive** hosts and another for the non-responsive hosts. This is done in case the user wishes to manually test each of them.

The tools used in this project are:
* crt.sh
* Assetfinder
* Subfinder

<details>
  <summary><h2>How It Works</h2></summary>
</details>

## Script proof of concept

For this POC, I used [tesla.com](https://www.tesla.com) as target. The use of this tool is actually really simple, you have to provide the domain you want to enumerate as argument in the terminal, and that is it! all that's left is waiting for the script to finish executing the tools and creating the reports.

> [!WARNING]
> The following is public information!

As you can see the the output is color coded, and 

![poc1](/Images/6.png)\

> [!TIP]
> To avoid typing the full path to the script, <code>/path/to/script/subAlive.sh tesla.com</code>. You can use a bash alias!

