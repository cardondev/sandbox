#!/usr/bin/env python3
#==============================================================================
#
#  _   _____  __  ____ ______  ____________  _______  ______
# | | / / _ |/ / / / //_  __/ / __/ ___/ _ \/  _/ _ \/_  __/
# | |/ / __ / /_/ / /__/ /   _\ \/ /__/ , _// // ___/ / /   
# |___/_/ |_\____/____/_/   /___/\___/_/|_/___/_/    /_/    
#                                                         
#
#==============================================================================
#
# 🐍 Script Name:       vault.py
# 📚 Description:       The script provides a secure way to manage and store secrets in encrypted vault files.
# 👤 Author:            Cardondev
# 📅 Date:              14 April 2024
# 🤖 Last Modified By:  Cardondev
# 🗓 Last Modified:     04/14/2024
# 🏷️ Version:           v1.0
#
# 📝 Revision History:
#     Date     - Author's Name        - Version - Changes Made
#     04/14/24 - Cardondev            - v1.0    - Created  
#
#==============================================================================
import os
import base64
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

def generate_key(password):
    salt = b'some_random_salt'
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000
    )
    key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
    return key

def encrypt_secret(secret, key):
    f = Fernet(key)
    encrypted_secret = f.encrypt(secret.encode())
    return encrypted_secret

def decrypt_secret(encrypted_secret, key):
    f = Fernet(key)
    decrypted_secret = f.decrypt(encrypted_secret).decode()
    return decrypted_secret

def store_secret(vault_file, secret_name, secret_value, key):
    encrypted_secret = encrypt_secret(secret_value, key)
    with open(vault_file, "a") as file:
        file.write(f"{secret_name}:{base64.b64encode(encrypted_secret).decode()}\n")
    print(f"Secret '{secret_name}' stored successfully in vault '{vault_file}'.")

def retrieve_secret(vault_file, secret_name, key):
    try:
        with open(vault_file, "r") as file:
            for line in file:
                name, encrypted_secret = line.strip().split(":")
                if name == secret_name:
                    decrypted_secret = decrypt_secret(base64.b64decode(encrypted_secret), key)
                    return decrypted_secret
        return None
    except FileNotFoundError:
        return None

def delete_secret(vault_file, secret_name):
    try:
        with open(vault_file, "r") as file:
            lines = file.readlines()
        with open(vault_file, "w") as file:
            for line in lines:
                name, _ = line.strip().split(":")
                if name != secret_name:
                    file.write(line)
        print(f"Secret '{secret_name}' deleted successfully from vault '{vault_file}'.")
    except FileNotFoundError:
        print(f"Vault '{vault_file}' not found.")

def list_vaults():
    vaults = [file for file in os.listdir(".") if file.endswith(".vlt")]
    if vaults:
        print("Available vaults:")
        for vault in vaults:
            print(f"- {vault}")
    else:
        print("No vaults found.")

def list_secrets(vault_file):
    try:
        with open(vault_file, "r") as file:
            secrets = [line.strip().split(":")[0] for line in file]
        if secrets:
            print(f"Secrets in vault '{vault_file}':")
            for secret in secrets:
                print(f"- {secret}")
        else:
            print(f"No secrets found in vault '{vault_file}'.")
    except FileNotFoundError:
        print(f"Vault '{vault_file}' not found.")

print("Secret Management")
print("=================")

while True:
    print("\nOptions:")
    print("1. Create a new vault")
    print("2. Open an existing vault")
    print("3. List available vaults")
    print("4. Quit")

    choice = input("Enter your choice (1-4): ")

    if choice == "1":
        vault_file = input("Enter the name of the new vault file (e.g., myvault.vlt): ")
        password = input("Enter the password to access the vault: ")
        key = generate_key(password)
        with open(vault_file, "w") as file:
            pass
        print(f"Vault '{vault_file}' created successfully.")
    elif choice == "2":
        vault_file = input("Enter the name of the vault file to open (e.g., myvault.vlt): ")
        password = input("Enter the password to access the vault: ")
        key = generate_key(password)
        while True:
            print(f"\nVault: {vault_file}")
            print("Options:")
            print("1. Store a secret")
            print("2. Retrieve a secret")
            print("3. Delete a secret")
            print("4. List secrets")
            print("5. Back to main menu")

            vault_choice = input("Enter your choice (1-5): ")

            if vault_choice == "1":
                secret_name = input("Enter the name of the secret: ")
                secret_value = input("Enter the value of the secret: ")
                store_secret(vault_file, secret_name, secret_value, key)
            elif vault_choice == "2":
                secret_name = input("Enter the name of the secret to retrieve: ")
                secret_value = retrieve_secret(vault_file, secret_name, key)
                if secret_value:
                    print(f"Secret '{secret_name}': {secret_value}")
                else:
                    print(f"Secret '{secret_name}' not found in vault '{vault_file}'.")
            elif vault_choice == "3":
                secret_name = input("Enter the name of the secret to delete: ")
                delete_secret(vault_file, secret_name)
            elif vault_choice == "4":
                list_secrets(vault_file)
            elif vault_choice == "5":
                break
            else:
                print("Invalid choice. Please try again.")
    elif choice == "3":
        list_vaults()
    elif choice == "4":
        break
    else:
        print("Invalid choice. Please try again.")
