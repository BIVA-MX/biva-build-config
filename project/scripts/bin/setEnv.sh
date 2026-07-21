#!/bin/bash

export PROPERTIES_FILE="@conf.script.start.propertiesFile@"
export LOG_DIRECTORY="@conf.script.start.logDirectory@"
export MAX_LOGS="@conf.script.cleanLog.maxLogFiles@"
export JAVA_HOME="@conf.jdk.home@"
export JVM_EXTRA_ARGS="@conf.script.setEnv.jvmExtraArgs@"
@conf.script.setEnv.inputDirectory@