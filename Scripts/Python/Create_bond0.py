import os

def configure_bond0():
    # Create bond0 interface
    os.system("sudo modprobe bonding")

    # Set bond0 configuration
    os.system("sudo echo 'bond0' > /sys/class/net/bonding_masters")

    # Add eth0 and eth1 as slaves to bond0
    os.system("sudo echo '+eth0' > /sys/class/net/bond0/bonding/slaves")
    os.system("sudo echo '+eth1' > /sys/class/net/bond0/bonding/slaves")

    # Configure bond0 with mode 1 (active-backup)
    os.system("sudo echo '1' > /sys/class/net/bond0/bonding/mode")
    # Configure bond0 with miimon 100
    os.system("sudo echo '100' > /sys/class/net/bond0/bonding/miimon")
    # Configure bond0 with primary as eth0
    os.system("sudo echo 'eth0' > /sys/class/net/bond0/bonding/primary")
    # Configure bond0 with mtu 9000
    os.system("sudo echo '9000' > /sys/class/net/bond0/mtu")
    # Bring bond0 up
    os.system("sudo ip link set bond0 up")

configure_bond0()
