from brownie import QuickMath, TimeLock, accounts, network, config, reverts
import time

def getAccount():
   acc = accounts[0]
   return acc


def deploy():
   acc = getAccount()

   QuickMath.deploy({"from": acc})
   dep = TimeLock.deploy({"from": acc})

   return dep

def testLock():
   acc = getAccount()
   deps = deploy()

   deps.deposit({"from": acc, "value": "200 gwei"})
   time.sleep(45)
   deps.withdraw({"from":acc})

   val = 0
   with reverts():
      val = deps.seeSafe(acc)

   assert val == 0
