# qnap-newrelic-agent
Non official QPKG of New Relic Infrastructure agent build using the QNAP SDK (QSDK). 
Can be installed manually on QNAP storage systems through the App Center (upload .qpkg file in build directory).

The agent was built for x86_64 and only includes binaries for this architecture.

This app was tested on:
  - TS-873U-RP (firmware 4.3.6.1040)
  
Feel free to make further improvements as this was just a quickly thrown-together tool to have "something" that lets me monitor our storage servers in New Relic Infrastructure, since I couldn't find any existing way of doing that.

This QPKG includes the New Relic Infrastructure Agent binary found on https://download.newrelic.com/infrastructure_agent/binaries/linux/amd64/

Specifically version newrelic-infra_linux_1.11.22_amd64 is supplied in this package.
