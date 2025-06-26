#!/usr/bin/env python3

import re
import sys
import os

def main():
    # Check args
    if len(sys.argv) != 3:
        sys.exit(1)

    input_file = sys.argv[1]
    output_dir = sys.argv[2]

    # Check if input file exists
    if not os.path.isfile(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)

    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Read the input file
    with open(input_file, 'r') as f:
        content = f.read()

    # Extract unseal keys
    unseal_key_pattern = r"Unseal Key (\d+): ([\w+/=]+)"
    unseal_keys = re.findall(unseal_key_pattern, content)
    for num, key in unseal_keys:
        filename = os.path.join(output_dir, f"unseal_key_{num}.txt")
        with open(filename, 'w') as out:
            out.write(key.strip())
        print(f"Saved {filename}")

    # Extract root token
    root_token_pattern = r"Initial Root Token: (\S+)"
    root_token_match = re.search(root_token_pattern, content)
    if root_token_match:
        token = root_token_match.group(1).strip()
        token_file = os.path.join(output_dir, "root_token.txt")
        with open(token_file, 'w') as out:
            out.write(token)
        print(f"Saved {token_file}")
    else:
        print("Root token not found.")

if __name__ == "__main__":
    main()
