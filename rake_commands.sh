#!/bin/bash

rake load_jenkins_data["Sun - Firefox Tests - Regression","/ws/sol-automation/sun-online/src/test/resources/report/"] 
rake load_jenkins_data["Sun - Chrome Tests - Regression","/ws/sol-automation/sun-online/src/test/resources/report/"]
rake load_jenkins_data["Sun - IE Tests - Regression","/ws/sol-automation/sun-online/src/test/resources/report/"]

