from fabric.api import *
import fabric.contrib.project as project
import os
import shutil
import sys
import SocketServer

def pushfrankie():
    local('git push origin master')

def pushcaramelized():
    local('git push carm master')

def pushall():
    pushfrankie()
    pushcaramelized()
