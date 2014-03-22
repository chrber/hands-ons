import subprocess

class HostnameSetter:
    '''
    Class that sets the the hostname of a machine if needed
    '''

    def __init__(self):
        self.name = 'Hostname Setter'
            
    def setHostNameToMachineByIP(self, ip):
        if (not self.hostNameMatches(ip, hostname)):
            print ("Change hostname of %s to %s" % (ip, hostname))
        else:
            print ("Hostname of %s already set to %s" % (ip, hostname))

    def dnsEntryCheck(self, ip, hostname):
        if (not self.dnsEntryMatch(ip, hostname)):
           print ("DNS entry not set correctly for IP:%s" % ip)
        else:
            print ("DNS entry set correctly for IP:%s" % ip)

    def hostNameMatches(self, ip, hostname):
        p = subprocess.Popen(["ssh","-l", "root", ip, "hostname"],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate();
        if (out.strip() == hostname):
            return True
        else:
            print ("Hostname for %s is %s, it should be  %s" % (ip, out, hostname))
            self.setHostName(ip, out, hostname)
            return False

    def dnsVsHostnameCheck(self, ip):
        return

    def setHostName(self, ip, oldHostname, newHostname):
        p = subprocess.Popen(["ssh","-l", "root", ip, "hostname", hostname],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate();
        print ("Set hostname of %s from %s to %s" % (ip, oldHostname, newHostname)) 

    def dnsEntryMatch(self, ip, hostname):
        p = subprocess.Popen(["host", ip],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate()
        if hostname in out:
            return True
        else:
            print ("Hostname for %s is %s, it should be  %s" % (ip, out, hostname))
            return False

    def main(self):
        print self

if __name__ == '__main__':

    ipToNameMap = {}    
    hostnameSetter = HostnameSetter()
    with open("handson_IPs.txt") as f:

        for line in f:
            splitLine = line.split()
            ipToNameMap[splitLine[1]] = splitLine[0]

    for ip, hostname in ipToNameMap.items():
        print (ip, hostname)
        hostnameSetter.dnsEntryCheck(ip, hostname)
        #hostnameSetter.hostNameMatches(ip, hostname)

