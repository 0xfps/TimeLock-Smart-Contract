from brownie import QuickMath, TimeLock, accounts, network, config


def getAccount():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config['wallet']['from_key'])
      
def deploy():
   account = getAccount()

   print("Deploying...")

   QuickMath.deploy({"from": account}, publish_source=True)
   deploy = TimeLock.deploy({"from": account}, publish_source=True)


   print(f"Deployed at {deploy.address} !!!")

   title = "TimeLock"
   link = "https://rinkeby.etherscan.io/address/"
   with open("../Deployment Address.txt", "a+") as file:
      file.write(f"{title} => {link}{deploy.address}\n\n")


def main():
   deploy()