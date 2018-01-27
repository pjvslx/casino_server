#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import shutil

projectRoot = os.path.split(os.path.realpath(__file__))[0]
runtimeRoot = os.path.split(projectRoot)[0]
print "projectRoot = " + projectRoot + "\n"
print "runtimeRoot = " + runtimeRoot + "\n"

def joinDir(root, *dirs):
    for item in dirs:
        root = os.path.join(root, item)
    return root

def copy():
    print "====> Copying res to qumi-dwc...\n"
    originResDir = joinDir(projectRoot,"alipay")
    print "originResDir = " + originResDir + " \n"
    targetResDir = "E:\\wamp\\www\\alipay"
    print "targetResDir = " + targetResDir + " \n"
    if os.path.exists(targetResDir):
        shutil.rmtree(targetResDir)
    shutil.copytree(originResDir,targetResDir)
    print "====> Copy Done\n"


if __name__ == "__main__":
    copy()
