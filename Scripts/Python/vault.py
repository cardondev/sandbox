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
#
#🛠️ Usage:       python3 vault.py [options]
#
# 🔍 Options:
#   -i, --info    Displays information about the script
#   -d, --debug   Enable debug mode for verbose output
#
#
# 📝 Revision History:
#     Date     - Author's Name        - Version - Changes Made
#     04/14/24 - Cardondev            - v1.0    - Created  
#
#==============================================================================
import os
import base64
import argparse
from cryptography.fernet import Fernet, InvalidToken
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.exceptions import InvalidSignature

# Function to generate an encryption key from a password
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

# Function to encrypt a secret using the encryption key
def encrypt_secret(secret, key):
    f = Fernet(key)
    encrypted_secret = f.encrypt(secret.encode())
    return encrypted_secret

# Function to decrypt a secret using the encryption key
def decrypt_secret(encrypted_secret, key):
    f = Fernet(key)
    decrypted_secret = f.decrypt(encrypted_secret).decode()
    return decrypted_secret

# Function to check if a secret name already exists in the vault
def secret_exists(vault_file, secret_name):
    try:
        with open(vault_file, "r") as file:
            for line in file:
                parts = line.strip().split(":", 1)
                if len(parts) == 2:
                    name = parts[0]
                    if name == secret_name:
                        return True
        return False
    except FileNotFoundError:
        return False

# Function to store a secret in a vault file
def store_secret(vault_file, secret_name, secret_value, key, debug=False):
    if secret_exists(vault_file, secret_name):
        print(f"Secret '{secret_name}' already exists in vault '{vault_file}'. Please use a unique name.")
        return

    encrypted_secret = encrypt_secret(secret_value, key)

    try:
        with open(vault_file, "rb") as file:
            existing_data = file.read().strip()
        if existing_data:
            existing_data += b"\n"
        with open(vault_file, "wb") as file:
            file.write(existing_data + f"{secret_name}:{base64.b64encode(encrypted_secret).decode()}\n".encode())
    except FileNotFoundError:
        with open(vault_file, "wb") as file:
            file.write(f"{secret_name}:{base64.b64encode(encrypted_secret).decode()}\n".encode())

    if debug:
        print(f"Debug: Stored secret '{secret_name}' in vault '{vault_file}'.")
    else:
        print(f"Secret '{secret_name}' stored successfully in vault '{vault_file}'.")

# Function to retrieve a secret from a vault file
def retrieve_secret(vault_file, secret_name, key, debug=False):
    try:
        with open(vault_file, "r") as file:
            for line in file:
                parts = line.strip().split(":", 1)
                if len(parts) == 2:
                    name, encrypted_secret = parts
                    if name == secret_name:
                        try:
                            decrypted_secret = decrypt_secret(base64.b64decode(encrypted_secret), key)
                            if debug:
                                print(f"Debug: Retrieved secret '{secret_name}' from vault '{vault_file}'.")
                            return decrypted_secret
                        except InvalidToken:
                            if debug:
                                print(f"Debug: Invalid secret format for '{secret_name}' in vault '{vault_file}'.")
                            return None
        if debug:
            print(f"Debug: Secret '{secret_name}' not found in vault '{vault_file}'.")
        return None
    except FileNotFoundError:
        if debug:
            print(f"Debug: Vault '{vault_file}' not found.")
        return None

# Function to delete a secret from a vault file
def delete_secret(vault_file, secret_name, debug=False):
    try:
        with open(vault_file, "r") as file:
            lines = file.readlines()
        secret_found = False
        with open(vault_file, "w") as file:
            for line in lines:
                parts = line.strip().split(":", 1)
                if len(parts) == 2:
                    name = parts[0]
                    if name == secret_name:
                        secret_found = True
                    else:
                        file.write(line)
        if secret_found:
            if debug:
                print(f"Debug: Deleted secret '{secret_name}' from vault '{vault_file}'.")
            else:
                print(f"Secret '{secret_name}' deleted successfully from vault '{vault_file}'.")
        else:
            print(f"Secret '{secret_name}' not found in vault '{vault_file}'.")
    except FileNotFoundError:
        if debug:
            print(f"Debug: Vault '{vault_file}' not found.")
        else:
            print(f"Vault '{vault_file}' not found.")

# Function to list available vault files
def list_vaults(debug=False):
    vaults = [file for file in os.listdir(".") if file.endswith(".vlt")]
    if vaults:
        print("Available vaults:")
        for vault in vaults:
            print(f"- {vault}")
    else:
        if debug:
            print("Debug: No vaults found.")
        else:
            print("No vaults found.")

# Function to list secrets in a vault file
def list_secrets(vault_file, debug=False):
    try:
        with open(vault_file, "r") as file:
            secrets = []
            for line in file:
                parts = line.strip().split(":", 1)
                if len(parts) == 2:
                    secrets.append(parts[0])
        if secrets:
            print(f"Secrets in vault '{vault_file}':")
            for secret in secrets:
                print(f"- {secret}")
        else:
            if debug:
                print(f"Debug: No secrets found in vault '{vault_file}'.")
            else:
                print(f"No secrets found in vault '{vault_file}'.")
    except FileNotFoundError:
        if debug:
            print(f"Debug: Vault '{vault_file}' not found.")
        else:
            print(f"Vault '{vault_file}' not found.")

# Function to validate the password for a vault file
def validate_password(vault_file, password):
    try:
        with open(vault_file, "rb") as file:
            encrypted_data = file.read()
        key = generate_key(password)
        f = Fernet(key)
        f.decrypt(encrypted_data)
        return True, None
    except FileNotFoundError:
        return False, "Vault not found"
    except (ValueError, InvalidToken, InvalidSignature):
        return False, "Invalid password"

# Function to check if a vault name already exists
def vault_exists(vault_file):
    return os.path.isfile(vault_file)

# Main function
def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Vault Script")
    parser.add_argument("-d", "--debug", action="store_true", help="Enable debug mode")
    parser.add_argument("-i", "--info", action="store_true", help="Display script information")
    args = parser.parse_args()

    # Display script information if the --info flag is provided
    if args.info:
        print("Vault Script")
        print("-------------------------")
        print("This script provides a secure way to manage and store secrets in encrypted vault files.")
        print("You can create vaults, store secrets, retrieve secrets, delete secrets, and list available vaults and secrets within a vault.")
        print("The secrets are encrypted using the Fernet symmetric encryption algorithm from the cryptography library.")
        print("Each vault is protected by a user-provided password, which is used to derive the encryption key.")
        print("The encrypted secrets are stored in vault files with a '.vlt' extension.")
        return

    debug_mode = args.debug
    if debug_mode:
        print("Debug mode enabled.")

    print("Vault Main Menu")
    print("=================")

    # Main loop for user interaction
    while True:
        print("\nOptions:")
        print("1. Create a new vault")
        print("2. Open an existing vault")
        print("3. List available vaults")
        print("4. Quit")

        choice = input("Enter your selection (1-4): ")

        # Create a new vault
        if choice == "1":
            while True:
                vault_file = input("Enter the name of the new vault file (without extension): ")
                vault_file = f"{vault_file}.vlt"
                if vault_exists(vault_file):
                    print(f"Vault '{vault_file}' already exists. Please use a unique name.")
                else:
                    break

            while True:
                password = input("Enter the password to access the vault: ")
                confirm_password = input("Confirm the password: ")
                if password == confirm_password:
                    break
                else:
                    print("Passwords do not match. Please try again.")

            key = generate_key(password)
            with open(vault_file, "wb") as file:
                file.write(Fernet(key).encrypt(b""))
            if debug_mode:
                print(f"Debug: Created vault '{vault_file}'.")
            else:
                print(f"Vault '{vault_file}' created successfully.")
        # Open an existing vault
        elif choice == "2":
            vault_file = input("Enter the name of the vault file to open include .vlt extension (e.g., fortknox.vlt): ")
            if not vault_exists(vault_file):
                print(f"Vault '{vault_file}' does not exist.")
                continue

            attempts = 3
            while attempts > 0:
                password = input("Enter the password to access the vault: ")
                valid_password, reason = validate_password(vault_file, password)
                if valid_password:
                    key = generate_key(password)
                    while True:
                        print(f"\nVault: {vault_file}")
                        print("Options:")
                        print("1. Store a secret")
                        print("2. Retrieve a secret")
                        print("3. Delete a secret")
                        print("4. List secrets")
                        print("5. Back to main menu")

                        vault_choice = input("Enter your selection (1-5): ")

                        if vault_choice == "1":
                            secret_name = input("Enter the name of the secret: ")
                            secret_value = input("Enter the value of the secret: ")
                            store_secret(vault_file, secret_name, secret_value, key, debug_mode)
                        elif vault_choice == "2":
                            secret_name = input("Enter the name of the secret to retrieve: ")
                            secret_value = retrieve_secret(vault_file, secret_name, key, debug_mode)
                            if secret_value:
                                print(f"Secret '{secret_name}': {secret_value}")
                            else:
                                print(f"Secret '{secret_name}' not found in vault '{vault_file}'.")
                        elif vault_choice == "3":
                            secret_name = input("Enter the name of the secret to delete: ")
                            delete_secret(vault_file, secret_name, debug_mode)
                        elif vault_choice == "4":
                            list_secrets(vault_file, debug_mode)
                        elif vault_choice == "5":
                            break
                        else:
                            print("Invalid selection. Please try again.")

                    break
                else:
                    attempts -= 1
                    if attempts > 0:
                        print(f"Invalid password. {attempts} attempts remaining.")
                    else:
                        print("Access denied. Maximum attempts reached.")
                        break
        # List available vaults
        elif choice == "3":
            list_vaults(debug_mode)
        # Quit the script
        elif choice == "4":
            break
        else:
            print("Invalid selection. Please try again.")

# Run the main function if the script is executed directly
if __name__ == "__main__":
    main()
