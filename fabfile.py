from fabric.api import *
import fabric.contrib.project as project
import os
import shutil
import sys
import SocketServer

def pushfrankie():
    local('git push frankie develop')

def pushcarm():
    local('git push origin develop')

def push():
    pushfrankie()
    pushcarm()
