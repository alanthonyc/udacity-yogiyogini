from fabric.api import *
import fabric.contrib.project as project
import os
import shutil
import sys
import SocketServer

def pushfrankie():
    local('git push frankie master')

def pushcarm():
    local('git push origin master')

def pushall():
    pushfrankie()
    pushcarm()
