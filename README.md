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
  <summary><h2>How It Works</h2> &rarr; Click here!
  </summary>

  ## KeyboardInterrupt handling

  ![def](/Images/1.png)

  The first line is the Shebang (`#!`), which is used to tell the system where to find the interpreter. This way, you don’t have to specify the interpreter when executing the script. In this case, the interpreter is bash. 
  
  Next, I declared some global variables, colors to be precise, that will be used throughout the entire script. This greatly improves code readability. Following this, I defined the error handling function `ctrl_c`, which simply prints a **red** message and returns an exit status of 1, indicating failure. This function is triggered when a `SIGINT` is detected, which is the signal sent by the keyboard when pressing `CTRL + C` in a Linux OS.

  ## Information gathering
  
  ![def1](/Images/2.png)

  This section consists of three funcions, each of them executes a different tool to enumerate subdomains and applies a basic filter when called. 

  * `extract_crtSh()` &rarr; This script sends a query to the website `crt.sh` using the `curl` command. The response is the page source, which requires significant filtering to extract the relevant information about the target. Fortunately, this task is not difficult in Linux.
  * `extract_asset()` &rarr; Executes the tool `assetfinder`. The filtering done in this function is less complex than the previous, since assetfinder's output is much cleaner. 
  * `extract_subfinder()` &rarr; Executes the tool `subfinder` and applies some basic filtering to deal with the verbose output.

  ## Checking subdomain's status code
  
  ![def2](/Images/3.png)

 Originally, I used the tool `httprobe` for this section. However, after testing the script, I concluded that `httprobe` did not include **alive** subdomains unless they returned a status code of `200 OK`. This meant that domains which were still alive but did not have a `200 OK` status were being ignored. These domains represent a potential attack surface and should not be overlooked.
 For this reason I created my own 'utility'. The function `status()` sends `GET` request to each subdamin provided using `curl` command. Based on the status code of the response categorizes each subdomain address and prints them with the appropriate color, these are: red for the 400 and 500 family
  
  ![def3](/Images/4.png)
  
  ![def4](/Images/5.png)
  
</details>

## Script proof of concept

For this POC, I used [tesla.com](https://www.tesla.com) as target. The use of this tool is actually really simple, you have to provide the domain you want to enumerate as argument in the terminal, and that is it! all that's left is waiting for the script to finish executing the tools and creating the reports. 

> [!WARNING]
> The following is public information!

As you can see, the output is color-coded. Moreover, the verification step allows you to see the status code that each subdomain returned.  

![poc1](/Images/6.png)

> [!TIP]
> To avoid typing the full path to the script, <code>/path/to/script/subAlive.sh tesla.com</code>. You can use a bash alias!

When the execution finishes, the final number of **alive** hosts is displayed, along with some tips for filtering the report from the Linux terminal. It’s important to note that the reports are formatted in key:value pairs, where each pair represents a subdomain and its status, for example `www.tesla.com:200`.

![poc2](/Images/7.png)

And finally, if you were to interrupt the execution with `CTRL + C`, KeyboardInterrupt, then you would see the following message:

![poc2](/Images/8.png)




