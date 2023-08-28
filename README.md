# Trivy_Zip
Unzip and scan multiple container images with csv output for easy reporting

# Trivy_Zip
Unzips Container Images and Vuln Scans with Trivy.

Go on Bitbucket, find the Container(s) and download it 

![image](https://github.com/deeexcee-io/Trivy_Zip/assets/130473605/4b2e7002-5608-48cb-b281-3d056878c80d)

Put all the zip files in the same folder

![image](https://github.com/deeexcee-io/Trivy_Zip/assets/130473605/e395a5dc-6b1c-4ddd-af07-f0cf56176de6)


**Run in the same folder as the container zip files.**

`./Trivy_Zip.sh`

It also has pretty colours and some dependacy checks.

Outputs .csv file on each container for easy reporting.

Handy if you are assessing multiple Containers.

![image](https://github.com/deeexcee-io/Trivy_Zip/assets/130473605/801ef1da-e8c7-428f-824d-7a79eea25f54)

Trivy doesnt output .csv by default so jq has been configured to pull CVE, Package Name, Severity etc

This can be changed in the script if you require different options

`jq -r '.Results[].Vulnerabilities[] | [.VulnerabilityID, .PkgName, .InstalledVersion, .FixedVersion, .Title, .Description, .Severity]`

![image](https://github.com/deeexcee-io/Trivy_Zip/assets/130473605/30481ff2-c901-4835-aec3-b90a7d725312)

**Bit messy, my Bash skills are amateur at best, works though = )**
